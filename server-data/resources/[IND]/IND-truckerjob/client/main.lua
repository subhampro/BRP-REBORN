local INDCore = exports['IND-core']:GetCoreObject()
local PlayerJob = {}
local JobsDone = 0
local LocationsDone = {}
local CurrentLocation = nil
local CurrentBlip = nil
local hasBox = false
local isWorking = false
local currentCount = 0
local CurrentPlate = nil
local selectedVeh = nil
local TruckVehBlip = nil
local TruckerBlip = nil
local Delivering = false
local showMarker = false
local markerLocation
local zoneCombo = nil
local returningToStation = false

-- Functions

local function returnToStation()
    SetBlipRoute(TruckVehBlip, true)
    returningToStation = true
end

local function hasDoneLocation(locationId)
    if LocationsDone and table.type(LocationsDone) ~= "empty" then
        for _, v in pairs(LocationsDone) do
            if v == locationId then
                return true
            end
        end
    end
    return false
end

local function getNextLocation()
    local current = 1

    if Config.TruckerJobFixedLocation then
        local pos = GetEntityCoords(PlayerPedId(), true)
        local dist = nil
        for k, v in pairs(Config.TruckerJobLocations["stores"]) do
            local dist2 = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
            if dist then
                if dist2 < dist then
                    current = k
                    dist = dist2
                end
            else
                current = k
                dist = dist2
            end
        end
    else
        while hasDoneLocation(current) do
            current = math.random(#Config.TruckerJobLocations["stores"])
        end
    end

    return current
end

local function isTruckerVehicle(vehicle)
    for k in pairs(Config.TruckerJobVehicles) do
        if GetEntityModel(vehicle) == joaat(k) then
            return true
        end
    end
    return false
end

local function getTruckerVehicle(vehicle)
    for k in pairs(Config.TruckerJobVehicles) do
        if GetEntityModel(vehicle) == joaat(k) then
            return k
        end
    end
    return false
end
local function RemoveTruckerBlips()
    ClearAllBlipRoutes()
    if TruckVehBlip then
        RemoveBlip(TruckVehBlip)
        TruckVehBlip = nil
    end

    if TruckerBlip then
        RemoveBlip(TruckerBlip)
        TruckerBlip = nil
    end

    if CurrentBlip then
        RemoveBlip(CurrentBlip)
        CurrentBlip = nil
    end
end

local function MenuGarage()
--    if PlayerData.metadata.jobrep.trucker >= v.jobrep then
        local truckMenu = {
            {
                header = Lang:t("menu.header"),
                isMenuHeader = true
            }
        }
        for k,v in pairs(Config.TruckerJobVehicles) do
            truckMenu[#truckMenu+1] = {
             header = v.label,
             params = {
                 event = "IND-trucker:client:TakeOutVehicle",
                 args = {
                     vehicle = k
                   }
                }
            }
        end
        truckMenu[#truckMenu+1] = {
            header = Lang:t("menu.close_menu"),
            txt = "",
            params = {
            event = "IND-menu:client:closeMenu"
        }
        }
        exports['IND-menu']:openMenu(truckMenu)
--    end
end

local function SetDelivering(active)
    if PlayerJob.name ~= "trucker" then return end
    Delivering = active
end

local function ShowMarker(active)
    if PlayerJob.name ~= "trucker" then return end
    showMarker = active
end

local function CreateZone(type, number)
    local coords
    local heading
    local boxName
    local event
    local label
    local size

    if type == "main" then
        event = "IND-truckerjob:client:PaySlip"
        label = "Payslip"
        coords = vector3(Config.TruckerJobLocations[type].coords.x, Config.TruckerJobLocations[type].coords.y, Config.TruckerJobLocations[type].coords.z)
        heading = Config.TruckerJobLocations[type].coords.h
        boxName = Config.TruckerJobLocations[type].label
        size = 3
    elseif type == "vehicle" then
        event = "IND-truckerjob:client:Vehicle"
        label = "Vehicle"
        coords = vector3(Config.TruckerJobLocations[type].coords.x, Config.TruckerJobLocations[type].coords.y, Config.TruckerJobLocations[type].coords.z)
        heading = Config.TruckerJobLocations[type].coords.h
        boxName = Config.TruckerJobLocations[type].label
        size = 10
    elseif type == "stores" then
        event = "IND-truckerjob:client:Store"
        label = "Store"
        coords = vector3(Config.TruckerJobLocations[type][number].coords.x, Config.TruckerJobLocations[type][number].coords.y, Config.TruckerJobLocations[type][number].coords.z)
        heading = Config.TruckerJobLocations[type][number].coords.h
        boxName = Config.TruckerJobLocations[type][number].name
        size = 40
    elseif type == "line-haul" then
        event = "IND-truckerjob:client:Line-Haul"
        label = "Line-Haul"
        coords = vector3(Config.TruckerJobLocations[type][number].coords.x, Config.TruckerJobLocations[type][number].coords.y, Config.TruckerJobLocations[type][number].coords.z)
        heading = Config.TruckerJobLocations[type][number].coords.h
        boxName = Config.TruckerJobLocations[type][number].name
        size = 40
    elseif type == "fuel-delivery" then
        event = "IND-truckerjob:client:Line-Haul"
        label = "Fuel-Haul"
        coords = vector3(Config.TruckerJobLocations[type][number].coords.x, Config.TruckerJobLocations[type][number].coords.y, Config.TruckerJobLocations[type][number].coords.z)
        heading = Config.TruckerJobLocations[type][number].coords.h
        boxName = Config.TruckerJobLocations[type][number].name
        size = 40
    end

    if Config.UseTarget and type == "main" then
        exports['IND-target']:AddBoxZone(boxName, coords, size, size, {
            minZ = coords.z - 5.0,
            maxZ = coords.z + 5.0,
            name = boxName,
            heading = heading,
            debugPoly = false,
        }, {
            options = {
                {
                    type = "client",
                    event = event,
                    label = label,
                },
            },
            distance = 2
        })
    else
        local zone = BoxZone:Create(
            coords, size, size, {
                minZ = coords.z - 5.0,
                maxZ = coords.z + 5.0,
                name = boxName,
                debugPoly = false,
                heading = heading,
            })

        zoneCombo = ComboZone:Create({zone}, {name = boxName, debugPoly = false})
        zoneCombo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                if type == "main" then
                    TriggerEvent('IND-truckerjob:client:PaySlip')
                elseif type == "vehicle" then
                    TriggerEvent('IND-truckerjob:client:Vehicle')
                elseif type == "stores" then
                    markerLocation = coords
                    INDCore.Functions.Notify(Lang:t("mission.store_reached"))
                    ShowMarker(true)
                    SetDelivering(true)
                end
            else
                if type == "stores" then
                    ShowMarker(false)
                    SetDelivering(false)
                end
            end
        end)
        if type == "vehicle" then
            local zonedel = BoxZone:Create(
                coords, 40, 40, {
                    minZ = coords.z - 5.0,
                    maxZ = coords.z + 5.0,
                    name = boxName,
                    debugPoly = false,
                    heading = heading,
                })

            local zoneCombodel = ComboZone:Create({zonedel}, {name = boxName, debugPoly = false})
            zoneCombodel:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    markerLocation = coords
                    ShowMarker(true)
                else
                    ShowMarker(false)
                end
            end)
        elseif type == "stores" then
            CurrentLocation.zoneCombo = zoneCombo
        end
    end
end

local function getNewLocation()
    local location = getNextLocation()
    if location ~= 0 then
        CurrentLocation = {}
        CurrentLocation.id = location
        CurrentLocation.dropcount = math.random(1, 3)
        CurrentLocation.store = Config.TruckerJobLocations["stores"][location].name
        CurrentLocation.x = Config.TruckerJobLocations["stores"][location].coords.x
        CurrentLocation.y = Config.TruckerJobLocations["stores"][location].coords.y
        CurrentLocation.z = Config.TruckerJobLocations["stores"][location].coords.z
        CreateZone("stores", location)

        CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
        SetBlipColour(CurrentBlip, 3)
        SetBlipRoute(CurrentBlip, true)
        SetBlipRouteColour(CurrentBlip, 3)
    else
        INDCore.Functions.Notify(Lang:t("success.payslip_time"))
        if CurrentBlip ~= nil then
            RemoveBlip(CurrentBlip)
            ClearAllBlipRoutes()
            CurrentBlip = nil
        end
    end
end

local function CreateElements()
    TruckVehBlip = AddBlipForCoord(Config.TruckerJobLocations["vehicle"].coords.x, Config.TruckerJobLocations["vehicle"].coords.y, Config.TruckerJobLocations["vehicle"].coords.z)
    SetBlipSprite(TruckVehBlip, 326)
    SetBlipDisplay(TruckVehBlip, 4)
    SetBlipScale(TruckVehBlip, 0.6)
    SetBlipAsShortRange(TruckVehBlip, true)
    SetBlipColour(TruckVehBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.TruckerJobLocations["vehicle"].label)
    EndTextCommandSetBlipName(TruckVehBlip)

    TruckerBlip = AddBlipForCoord(Config.TruckerJobLocations["main"].coords.x, Config.TruckerJobLocations["main"].coords.y, Config.TruckerJobLocations["main"].coords.z)
    SetBlipSprite(TruckerBlip, 479)
    SetBlipDisplay(TruckerBlip, 4)
    SetBlipScale(TruckerBlip, 0.6)
    SetBlipAsShortRange(TruckerBlip, true)
    SetBlipColour(TruckerBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.TruckerJobLocations["main"].label)
    EndTextCommandSetBlipName(TruckerBlip)

    CreateZone("main")
    CreateZone("vehicle")
end

local function TableCount(tbl)
    local cnt = 0
    for _ in pairs(tbl) do cnt = cnt + 1 end
    return cnt
end

local function BackDoorsOpen(vehicle)
    local tv = getTruckerVehicle(vehicle)
    local cnt = TableCount(Config.TruckerJobVehicles[tv].cargodoors)
    if isTruckerVehicle(vehicle) then
        if cnt == 2 then
            return GetVehicleDoorAngleRatio(vehicle, Config.TruckerJobVehicles[tv].cargodoors[0]) > 0.0 and GetVehicleDoorAngleRatio(vehicle, Config.TruckerJobVehicles[tv].cargodoors[1]) > 0.0
        elseif cnt == 1 then
            return GetVehicleDoorAngleRatio(vehicle, Config.TruckerJobVehicles[tv].cargodoors[0]) > 0.0
        end
    end
end

local function GetInTrunk()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        return INDCore.Functions.Notify(Lang:t("error.get_out_vehicle"), "error")
    end
    local pos = GetEntityCoords(ped, true)
    local vehicle = GetVehiclePedIsIn(ped, true)
    local tv = getTruckerVehicle(vehicle)
    if not isTruckerVehicle(vehicle) or CurrentPlate ~= INDCore.Functions.GetPlate(vehicle) then
        return INDCore.Functions.Notify(Lang:t("error.vehicle_not_correct"), "error")
    end
    if not BackDoorsOpen(vehicle) then
        return INDCore.Functions.Notify(Lang:t("error.backdoors_not_open"), "error")
    end
    local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
    if #(pos - vector3(trunkpos.x, trunkpos.y, trunkpos.z)) > Config.TruckerJobVehicles[tv].trunkpos then
        return INDCore.Functions.Notify(Lang:t("error.too_far_from_trunk"), "error")
    end
    if isWorking then return end
    isWorking = true
    INDCore.Functions.Progressbar("work_carrybox", Lang:t("mission.take_box"), 2000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        isWorking = false
        StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
        TriggerEvent('animations:client:EmoteCommandStart', {"box"})
        hasBox = true
    end, function() -- Cancel
        isWorking = false
        StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
        INDCore.Functions.Notify(Lang:t("error.cancelled"), "error")
    end)
end

local function Deliver()
    isWorking = true
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    Wait(500)
    TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
    INDCore.Functions.Progressbar("work_dropbox", Lang:t("mission.deliver_box"), 2000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        isWorking = false
        ClearPedTasks(PlayerPedId())
        hasBox = false
        currentCount = currentCount + 1
        if currentCount == CurrentLocation.dropcount then
            LocationsDone[#LocationsDone+1] = CurrentLocation.id
            TriggerServerEvent("IND-shops:server:RestockShopItems", CurrentLocation.store)
            exports['IND-core']:HideText()
            Delivering = false
            showMarker = false
            TriggerServerEvent('IND-trucker:server:nano')
            if CurrentBlip ~= nil then
                RemoveBlip(CurrentBlip)
                ClearAllBlipRoutes()
                CurrentBlip = nil
            end
            CurrentLocation.zoneCombo:destroy()
            CurrentLocation = nil
            currentCount = 0
            JobsDone = JobsDone + 1
            if JobsDone == Config.TruckerJobMaxDrops then
                INDCore.Functions.Notify(Lang:t("mission.return_to_station"))
                returnToStation()
            else
                INDCore.Functions.Notify(Lang:t("mission.goto_next_point"))
                getNewLocation()
            end
        else
            INDCore.Functions.Notify(Lang:t("mission.another_box"))
        end
    end, function() -- Cancel
        isWorking = false
        ClearPedTasks(PlayerPedId())
        INDCore.Functions.Notify(Lang:t("error.cancelled"), "error")
    end)
end

-- Events

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    PlayerJob = INDCore.Functions.GetPlayerData().job
    CurrentLocation = nil
    CurrentBlip = nil
    hasBox = false
    isWorking = false
    JobsDone = 0
    if PlayerJob.name ~= "trucker" then return end
    CreateElements()
end)

RegisterNetEvent('INDCore:Client:OnPlayerLoaded', function()
    PlayerJob = INDCore.Functions.GetPlayerData().job
    CurrentLocation = nil
    CurrentBlip = nil
    hasBox = false
    isWorking = false
    JobsDone = 0
    if PlayerJob.name ~= "trucker" then return end
    CreateElements()
    TriggerServerEvent('IND-shops:server:SetShopList')
end)

RegisterNetEvent('INDCore:Client:OnPlayerUnload', function()
    RemoveTruckerBlips()
    CurrentLocation = nil
    CurrentBlip = nil
    hasBox = false
    isWorking = false
    JobsDone = 0
end)

RegisterNetEvent('INDCore:Client:OnJobUpdate', function(JobInfo)
    local OldPlayerJob = PlayerJob.name
    PlayerJob = JobInfo
    if OldPlayerJob == "trucker" then
        RemoveTruckerBlips()
        zoneCombo:destroy()
        exports['IND-core']:HideText()
        Delivering = false
        showMarker = false
    elseif PlayerJob.name == "trucker" then
        CreateElements()
    end
end)

RegisterNetEvent('IND-trucker:client:SpawnVehicle', function()
    local vehicleInfo = selectedVeh
    local coords = Config.TruckerJobLocations["vehicle"].coords
    INDCore.Functions.TriggerCallback('INDCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        SetVehicleNumberPlateText(veh, "TRUK"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        SetVehicleLivery(veh, 1)
        SetVehicleColours(veh, 122, 122)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        exports['IND-menu']:closeMenu()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", INDCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = INDCore.Functions.GetPlate(veh)
        getNewLocation()
    end, vehicleInfo, coords, true)
end)

RegisterNetEvent('IND-trucker:client:TakeOutVehicle', function(data)
    local vehicleInfo = data.vehicle
    TriggerServerEvent('IND-trucker:server:DoBail', true, vehicleInfo)
    selectedVeh = vehicleInfo
end)

RegisterNetEvent('IND-truckerjob:client:Vehicle', function()
    if IsPedInAnyVehicle(PlayerPedId()) and isTruckerVehicle(GetVehiclePedIsIn(PlayerPedId(), false)) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
            if isTruckerVehicle(GetVehiclePedIsIn(PlayerPedId(), false)) then
                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                TriggerServerEvent('IND-trucker:server:DoBail', false)
                if CurrentBlip ~= nil then
                    RemoveBlip(CurrentBlip)
                    ClearAllBlipRoutes()
                    CurrentBlip = nil
                end
                if returningToStation or CurrentLocation then
                    ClearAllBlipRoutes()
                    returningToStation = false
                    INDCore.Functions.Notify(Lang:t("mission.job_completed"), "success")
                end
            else
                INDCore.Functions.Notify(Lang:t("error.vehicle_not_correct"), 'error')
            end
        else
            INDCore.Functions.Notify(Lang:t("error.no_driver"))
        end
    else
        MenuGarage()
    end
end)

RegisterNetEvent('IND-truckerjob:client:PaySlip', function()
    if JobsDone > 0 then
        TriggerServerEvent("IND-trucker:server:01101110", JobsDone)
        JobsDone = 0
        if #LocationsDone == #Config.TruckerJobLocations["stores"] then
            LocationsDone = {}
        end
        if CurrentBlip ~= nil then
            RemoveBlip(CurrentBlip)
            ClearAllBlipRoutes()
            CurrentBlip = nil
        end
    else
        INDCore.Functions.Notify(Lang:t("error.no_work_done"), "error")
    end
end)

RegisterNetEvent('IND-truckerjob:client:SetShopList', function(shoplist)
    Config.TruckerJobLocations["stores"] = shoplist
end)
-- Threads
CreateThread(function()
    TriggerServerEvent('IND-shops:server:SetShopList')
end)
CreateThread(function()
    local sleep
    while true do
        sleep = 1000
        if showMarker then
            DrawMarker(2, markerLocation.x, markerLocation.y, markerLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
            sleep = 0
        end
        if Delivering then
            if IsControlJustReleased(0, 38) then
                if not hasBox then
                    GetInTrunk()
                else
                    if #(GetEntityCoords(PlayerPedId()) - markerLocation) < 5 then
                        Deliver()
                    else
                        INDCore.Functions.Notify(Lang:t("error.too_far_from_delivery"), "error")
                    end
                end
            end
            sleep = 0
        end
        Wait(sleep)
    end
end)
