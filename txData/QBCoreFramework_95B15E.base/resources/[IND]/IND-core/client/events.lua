-- Player load and unload handling
-- New method for checking if logged in across all scripts (optional)
-- if LocalPlayer.state['isLoggedIn'] then
RegisterNetEvent('INDCore:Client:OnPlayerLoaded', function()
    ShutdownLoadingScreenNui()
    LocalPlayer.state:set('isLoggedIn', true, false)
    if not INDConfig.Server.PVP then return end
    SetCanAttackFriendly(PlayerPedId(), true, false)
    NetworkSetFriendlyFireOption(true)
end)

RegisterNetEvent('INDCore:Client:OnPlayerUnload', function()
    LocalPlayer.state:set('isLoggedIn', false, false)
end)

RegisterNetEvent('INDCore:Client:PvpHasToggled', function(pvp_state)
    SetCanAttackFriendly(PlayerPedId(), pvp_state, false)
    NetworkSetFriendlyFireOption(pvp_state)
end)
-- Teleport Commands

RegisterNetEvent('INDCore:Command:TeleportToPlayer', function(coords)
    local ped = PlayerPedId()
    SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('INDCore:Command:TeleportToCoords', function(x, y, z, h)
    local ped = PlayerPedId()
    SetPedCoordsKeepVehicle(ped, x, y, z)
    SetEntityHeading(ped, h or GetEntityHeading(ped))
end)

RegisterNetEvent('INDCore:Command:GoToMarker', function()
    local PlayerPedId = PlayerPedId
    local GetEntityCoords = GetEntityCoords
    local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord

    local blipMarker <const> = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blipMarker) then
        INDCore.Functions.Notify(Lang:t("error.no_waypoint"), "error", 5000)
        return 'marker'
    end

    -- Fade screen to hide how clients get teleported.
    DoScreenFadeOut(650)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    local ped, coords <const> = PlayerPedId(), GetBlipInfoIdCoord(blipMarker)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local oldCoords <const> = GetEntityCoords(ped)

    -- Unpack coords instead of having to unpack them while iterating.
    -- 825.0 seems to be the max a player can reach while 0.0 being the lowest.
    local x, y, groundZ, Z_START = coords['x'], coords['y'], 850.0, 950.0
    local found = false
    if vehicle > 0 then
        FreezeEntityPosition(vehicle, true)
    else
        FreezeEntityPosition(ped, true)
    end

    for i = Z_START, 0, -25.0 do
        local z = i
        if (i % 2) ~= 0 then
            z = Z_START - i
        end

        NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
        local curTime = GetGameTimer()
        while IsNetworkLoadingScene() do
            if GetGameTimer() - curTime > 1000 then
                break
            end
            Wait(0)
        end
        NewLoadSceneStop()
        SetPedCoordsKeepVehicle(ped, x, y, z)

        while not HasCollisionLoadedAroundEntity(ped) do
            RequestCollisionAtCoord(x, y, z)
            if GetGameTimer() - curTime > 1000 then
                break
            end
            Wait(0)
        end

        -- Get ground coord. As mentioned in the natives, this only works if the client is in render distance.
        found, groundZ = GetGroundZFor_3dCoord(x, y, z, false);
        if found then
            Wait(0)
            SetPedCoordsKeepVehicle(ped, x, y, groundZ)
            break
        end
        Wait(0)
    end

    -- Remove black screen once the loop has ended.
    DoScreenFadeIn(650)
    if vehicle > 0 then
        FreezeEntityPosition(vehicle, false)
    else
        FreezeEntityPosition(ped, false)
    end

    if not found then
        -- If we can't find the coords, set the coords to the old ones.
        -- We don't unpack them before since they aren't in a loop and only called once.
        SetPedCoordsKeepVehicle(ped, oldCoords['x'], oldCoords['y'], oldCoords['z'] - 1.0)
        INDCore.Functions.Notify(Lang:t("error.tp_error"), "error", 5000)
    end

    -- If Z coord was found, set coords in found coords.
    SetPedCoordsKeepVehicle(ped, x, y, groundZ)
    INDCore.Functions.Notify(Lang:t("success.teleported_waypoint"), "success", 5000)
end)

-- Vehicle Commands

RegisterNetEvent('INDCore:Command:SpawnVehicle', function(vehName)
    local ped = PlayerPedId()
    local hash = GetHashKey(vehName)
    local veh = GetVehiclePedIsUsing(ped)
    if not IsModelInCdimage(hash) then return end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end

    if IsPedInAnyVehicle(ped) then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    end

    local vehicle = CreateVehicle(hash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
    SetVehicleFuelLevel(vehicle, 100.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetModelAsNoLongerNeeded(hash)
    TriggerEvent("vehiclekeys:client:SetOwner", INDCore.Functions.GetPlate(vehicle))
end)

RegisterNetEvent('INDCore:Command:DeleteVehicle', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    if veh ~= 0 then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    else
        local pcoords = GetEntityCoords(ped)
        local vehicles = GetGamePool('CVehicle')
        for _, v in pairs(vehicles) do
            if #(pcoords - GetEntityCoords(v)) <= 5.0 then
                SetEntityAsMissionEntity(v, true, true)
                DeleteVehicle(v)
            end
        end
    end
end)

RegisterNetEvent('INDCore:Client:VehicleInfo', function(info)
    local plate = INDCore.Functions.GetPlate(info.vehicle)
    local hasKeys = true

    if GetResourceState('IND-vehiclekeys') == 'started' then
        hasKeys = exports['IND-vehiclekeys']:HasKeys()
    end

    local data = {
        vehicle = info.vehicle,
        seat = info.seat,
        name = info.modelName,
        plate = plate,
        driver = GetPedInVehicleSeat(info.vehicle, -1),
        inseat = GetPedInVehicleSeat(info.vehicle, info.seat),
        haskeys = hasKeys
    }

    TriggerEvent('INDCore:Client:'..info.event..'Vehicle', data)
end)

-- Other stuff

RegisterNetEvent('INDCore:Player:SetPlayerData', function(val)
    INDCore.PlayerData = val
end)

RegisterNetEvent('INDCore:Player:UpdatePlayerData', function()
    TriggerServerEvent('INDCore:UpdatePlayer')
end)

RegisterNetEvent('INDCore:Notify', function(text, type, length)
    INDCore.Functions.Notify(text, type, length)
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon.
RegisterNetEvent('INDCore:Client:UseItem', function(item)
    INDCore.Debug(string.format("%s triggered INDCore:Client:UseItem by ID %s with the following data. This event is deprecated due to exploitation, and will be removed soon. Check IND-inventory for the right use on this event.", GetInvokingResource(), GetPlayerServerId(PlayerId())))
    INDCore.Debug(item)
end)

-- Callback Events --

-- Client Callback
RegisterNetEvent('INDCore:Client:TriggerClientCallback', function(name, ...)
    INDCore.Functions.TriggerClientCallback(name, function(...)
        TriggerServerEvent('INDCore:Server:TriggerClientCallback', name, ...)
    end, ...)
end)

-- Server Callback
RegisterNetEvent('INDCore:Client:TriggerCallback', function(name, ...)
    if INDCore.ServerCallbacks[name] then
        INDCore.ServerCallbacks[name](...)
        INDCore.ServerCallbacks[name] = nil
    end
end)

-- Me command

local function Draw3DText(coords, str)
    local onScreen, worldX, worldY = World3dToScreen2d(coords.x, coords.y, coords.z)
    local camCoords = GetGameplayCamCoord()
    local scale = 200 / (GetGameplayCamFov() * #(camCoords - coords))
    if onScreen then
        SetTextScale(1.0, 0.5 * scale)
        SetTextFont(4)
        SetTextColour(255, 255, 255, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextProportional(1)
        SetTextOutline()
        SetTextCentre(1)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(str)
        EndTextCommandDisplayText(worldX, worldY)
    end
end

RegisterNetEvent('INDCore:Command:ShowMe3D', function(senderId, msg)
    local sender = GetPlayerFromServerId(senderId)
    CreateThread(function()
        local displayTime = 5000 + GetGameTimer()
        while displayTime > GetGameTimer() do
            local targetPed = GetPlayerPed(sender)
            local tCoords = GetEntityCoords(targetPed)
            Draw3DText(tCoords, msg)
            Wait(0)
        end
    end)
end)

-- Listen to Shared being updated
RegisterNetEvent('INDCore:Client:OnSharedUpdate', function(tableName, key, value)
    INDCore.Shared[tableName][key] = value
    TriggerEvent('INDCore:Client:UpdateObject')
end)

RegisterNetEvent('INDCore:Client:OnSharedUpdateMultiple', function(tableName, values)
    for key, value in pairs(values) do
        INDCore.Shared[tableName][key] = value
    end
    TriggerEvent('INDCore:Client:UpdateObject')
end)
