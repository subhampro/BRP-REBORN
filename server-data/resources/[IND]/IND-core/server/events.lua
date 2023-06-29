-- Event Handler

AddEventHandler('chatMessage', function(_, _, message)
    if string.sub(message, 1, 1) == '/' then
        CancelEvent()
        return
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if not INDCore.Players[src] then return end
    local Player = INDCore.Players[src]
    TriggerEvent('IND-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..' ..'\n **Reason:** ' .. reason)
    Player.Functions.Save()
    INDCore.Player_Buckets[Player.PlayerData.license] = nil
    INDCore.Players[src] = nil
end)

-- Player Connecting

local function onPlayerConnecting(name, _, deferrals)
    local src = source
    local license
    local identifiers = GetPlayerIdentifiers(src)
    deferrals.defer()

    -- Mandatory wait
    Wait(0)

    if INDCore.Config.Server.Closed then
        if not IsPlayerAceAllowed(src, 'qbadmin.join') then
            deferrals.done(INDCore.Config.Server.ClosedReason)
        end
    end

    for _, v in pairs(identifiers) do
        if string.find(v, 'license') then
            license = v
            break
        end
    end

    if GetConvarInt("sv_fxdkMode", false) then
        license = 'license:AAAAAAAAAAAAAAAA' -- Dummy License
    end

    if not license then
        deferrals.done(Lang:t('error.no_valid_license'))
    elseif INDCore.Config.Server.CheckDuplicateLicense and INDCore.Functions.IsLicenseInUse(license) then
        deferrals.done(Lang:t('error.duplicate_license'))
    end

    local databaseTime = os.clock()
    local databasePromise = promise.new()

    -- conduct database-dependant checks
    CreateThread(function()
        deferrals.update(string.format(Lang:t('info.checking_ban'), name))
        local databaseSuccess, databaseError = pcall(function()
            local isBanned, Reason = INDCore.Functions.IsPlayerBanned(src)
            if isBanned then
                deferrals.done(Reason)
            end
        end)

        if INDCore.Config.Server.Whitelist then
            deferrals.update(string.format(Lang:t('info.checking_whitelisted'), name))
            databaseSuccess, databaseError = pcall(function()
                if not INDCore.Functions.IsWhitelisted(src) then
                    deferrals.done(Lang:t('error.not_whitelisted'))
                end
            end)
        end

        if not databaseSuccess then
            databasePromise:reject(databaseError)
        end
        databasePromise:resolve()
    end)

    -- wait for database to finish
    databasePromise:next(function()
        deferrals.update(string.format(Lang:t('info.join_server'), name))
        deferrals.done()
    end, function (databaseError)
        deferrals.done(Lang:t('error.connecting_database_error'))
        print('^1' .. databaseError)
    end)

    -- if conducting checks for too long then raise error
    while databasePromise.state == 0 do
        if os.clock() - databaseTime > 30 then
            deferrals.done(Lang:t('error.connecting_database_timeout'))
            error(Lang:t('error.connecting_database_timeout'))
            break
        end
        Wait(1000)
    end

    -- Add any additional defferals you may need!
end

AddEventHandler('playerConnecting', onPlayerConnecting)

-- Open & Close Server (prevents players from joining)

RegisterNetEvent('INDCore:Server:CloseServer', function(reason)
    local src = source
    if INDCore.Functions.HasPermission(src, 'admin') then
        reason = reason or 'No reason specified'
        INDCore.Config.Server.Closed = true
        INDCore.Config.Server.ClosedReason = reason
        for k in pairs(INDCore.Players) do
            if not INDCore.Functions.HasPermission(k, INDCore.Config.Server.WhitelistPermission) then
                INDCore.Functions.Kick(k, reason, nil, nil)
            end
        end
    else
        INDCore.Functions.Kick(src, Lang:t("error.no_permission"), nil, nil)
    end
end)

RegisterNetEvent('INDCore:Server:OpenServer', function()
    local src = source
    if INDCore.Functions.HasPermission(src, 'admin') then
        INDCore.Config.Server.Closed = false
    else
        INDCore.Functions.Kick(src, Lang:t("error.no_permission"), nil, nil)
    end
end)

-- Callback Events --

-- Client Callback
RegisterNetEvent('INDCore:Server:TriggerClientCallback', function(name, ...)
    if INDCore.ClientCallbacks[name] then
        INDCore.ClientCallbacks[name](...)
        INDCore.ClientCallbacks[name] = nil
    end
end)

-- Server Callback
RegisterNetEvent('INDCore:Server:TriggerCallback', function(name, ...)
    local src = source
    INDCore.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('INDCore:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

-- Player

RegisterNetEvent('INDCore:UpdatePlayer', function()
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    if not Player then return end
    local newHunger = Player.PlayerData.metadata['hunger'] - INDCore.Config.Player.HungerRate
    local newThirst = Player.PlayerData.metadata['thirst'] - INDCore.Config.Player.ThirstRate
    if newHunger <= 0 then
        newHunger = 0
    end
    if newThirst <= 0 then
        newThirst = 0
    end
    Player.Functions.SetMetaData('thirst', newThirst)
    Player.Functions.SetMetaData('hunger', newHunger)
    TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, newThirst)
    Player.Functions.Save()
end)

RegisterNetEvent('INDCore:ToggleDuty', function()
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('INDCore:Notify', src, Lang:t('info.off_duty'))
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('INDCore:Notify', src, Lang:t('info.on_duty'))
    end
        
    TriggerEvent('INDCore:Server:SetDuty', src, Player.PlayerData.job.onduty)
    TriggerClientEvent('INDCore:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- BaseEvents

-- Vehicles
RegisterServerEvent('baseevents:enteringVehicle', function(veh,seat,modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entering'
    }
    TriggerClientEvent('INDCore:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteredVehicle', function(veh,seat,modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entered'
    }
    TriggerClientEvent('INDCore:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteringAborted', function()
    local src = source
    TriggerClientEvent('INDCore:Client:AbortVehicleEntering', src)
end)

RegisterServerEvent('baseevents:leftVehicle', function(veh,seat,modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Left'
    }
    TriggerClientEvent('INDCore:Client:VehicleInfo', src, data)
end)

-- Items

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon.
RegisterNetEvent('INDCore:Server:UseItem', function(item)
    print(string.format("%s triggered INDCore:Server:UseItem by ID %s with the following data. This event is deprecated due to exploitation, and will be removed soon. Check IND-inventory for the right use on this event.", GetInvokingResource(), source))
    INDCore.Debug(item)
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon. function(itemName, amount, slot)
RegisterNetEvent('INDCore:Server:RemoveItem', function(itemName, amount)
    local src = source
    print(string.format("%s triggered INDCore:Server:RemoveItem by ID %s for %s %s. This event is deprecated due to exploitation, and will be removed soon. Adjust your events accordingly to do this server side with player functions.", GetInvokingResource(), src, amount, itemName))
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon. function(itemName, amount, slot, info)
RegisterNetEvent('INDCore:Server:AddItem', function(itemName, amount)
    local src = source
    print(string.format("%s triggered INDCore:Server:AddItem by ID %s for %s %s. This event is deprecated due to exploitation, and will be removed soon. Adjust your events accordingly to do this server side with player functions.", GetInvokingResource(), src, amount, itemName))
end)

-- Non-Chat Command Calling (ex: IND-adminmenu)

RegisterNetEvent('INDCore:CallCommand', function(command, args)
    local src = source
    if not INDCore.Commands.List[command] then return end
    local Player = INDCore.Functions.GetPlayer(src)
    if not Player then return end
    local hasPerm = INDCore.Functions.HasPermission(src, "command."..INDCore.Commands.List[command].name)
    if hasPerm then
        if INDCore.Commands.List[command].argsrequired and #INDCore.Commands.List[command].arguments ~= 0 and not args[#INDCore.Commands.List[command].arguments] then
            TriggerClientEvent('INDCore:Notify', src, Lang:t('error.missing_args2'), 'error')
        else
            INDCore.Commands.List[command].callback(src, args)
        end
    else
        TriggerClientEvent('INDCore:Notify', src, Lang:t('error.no_access'), 'error')
    end
end)

-- Use this for player vehicle spawning
-- Vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
-- INDCore.Functions.CreateCallback('INDCore:Server:SpawnVehicle', function(source, cb, model, coords, warp)
--     local ped = GetPlayerPed(source)
--     model = type(model) == 'string' and joaat(model) or model
--     if not coords then coords = GetEntityCoords(ped) end
--     local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, true)
--     -- SetVehicleNumberPlateText(vehicle, plate)
--     while not DoesEntityExist(veh) do Wait(0) end
--     if warp then
--         while GetVehiclePedIsIn(ped) ~= veh do
--             Wait(0)
--             TaskWarpPedIntoVehicle(ped, veh, -1)
--         end
--     end
--     while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
--     cb(NetworkGetNetworkIdFromEntity(veh))
-- end)

RegisterNetEvent('INDCore:Command:SpawnVehicle')
AddEventHandler('INDCore:Command:SpawnVehicle', function(model, plate)
	INDCore.Functions.SpawnVehicle(model, function(vehicle)
		SetVehicleNumberPlateText(vehicle, plate)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
		TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
	end)
end)

-- Use this for long distance vehicle spawning
-- vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
INDCore.Functions.CreateCallback('INDCore:Server:CreateVehicle', function(source, cb, model, coords, warp)
    model = type(model) == 'string' and GetHashKey(model) or model
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local CreateAutomobile = GetHashKey("CREATE_AUTOMOBILE")
    local veh = Citizen.InvokeNative(CreateAutomobile, model, coords, coords.w, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

--INDCore.Functions.CreateCallback('INDCore:HasItem', function(source, cb, items, amount)
-- https://github.com/qbcore-framework/IND-inventory/blob/e4ef156d93dd1727234d388c3f25110c350b3bcf/server/main.lua#L2066
--end)
