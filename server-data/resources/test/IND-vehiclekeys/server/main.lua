-----------------------
----   Variables   ----
-----------------------
local INDCore = exports['IND-core']:GetCoreObject()
local VehicleList = {}

-----------------------
----   Threads     ----
-----------------------

-----------------------
---- Server Events ----
-----------------------

-- Event to give keys. receiver can either be a single id, or a table of ids.
-- Must already have keys to the vehicle, trigger the event from the server, or pass forcegive paramter as true.
RegisterNetEvent('IND-vehiclekeys:server:GiveVehicleKeys', function(receiver, plate)
    local giver = source

    if HasKeys(giver, plate) then
        TriggerClientEvent('INDCore:Notify', giver, "You hand over the keys.", 'success')
        if type(receiver) == 'table' then
            for _,r in ipairs(receiver) do
                GiveKeys(receiver[r], plate)
            end
        else
            GiveKeys(receiver, plate)
        end
    else
        TriggerClientEvent('INDCore:Notify', giver, "You don't have keys to this vehicle.", "error")
    end
end)

RegisterNetEvent('IND-vehiclekeys:server:AcquireVehicleKeys', function(plate)
    local src = source
    GiveKeys(src, plate)
end)

INDCore.Functions.CreateCallback('IND-vehiclekeys:server:GetVehicleKeys', function(source, cb)
    local citizenid = INDCore.Functions.GetPlayer(source).PlayerData.citizenid
    local keysList = {}
    for plate, citizenids in pairs (VehicleList) do
        if citizenids[citizenid] then
            keysList[plate] = true
        end
    end
    cb(keysList)
end)

-----------------------
----   Functions   ----
-----------------------

function GiveKeys(id, plate)
    local citizenid = INDCore.Functions.GetPlayer(id).PlayerData.citizenid

    if not VehicleList[plate] then VehicleList[plate] = {} end
    VehicleList[plate][citizenid] = true
    
    TriggerClientEvent('INDCore:Notify', id, "You get keys to the vehicle!")
    TriggerClientEvent('IND-vehiclekeys:client:AddKeys', id, plate)
end

function RemoveKeys(id, plate)
    local citizenid = INDCore.Functions.GetPlayer(id).PlayerData.citizenid

    if VehicleList[plate] and VehicleList[plate][citizenid] then
        VehicleList[plate][citizenid] = nil
    end

    TriggerClientEvent('IND-vehiclekeys:client:RemoveKeys', id, plate)
end

function HasKeys(id, plate)
    local citizenid = INDCore.Functions.GetPlayer(id).PlayerData.citizenid
    if VehicleList[plate] and VehicleList[plate][citizenid] then
        return true
    end
    return false
end

INDCore.Commands.Add("engine", "Toggle Engine", {}, false, function(source)
    local vehSeat = GetPedInVehicleSeat(source, -1) -- Test -1, -2, 0, 1, 2. (One of them is only the driver seat)
    if vehSeat then
        TriggerClientEvent('IND-vehiclekeys:client:ToggleEngine', source)
      else
        TriggerClientEvent('INDCore:Notify', src, 'You are not the driver of this vehicle.Can not toggle engine')
      end
end)

INDCore.Commands.Add("givekeys", "Hand over the keys to someone. If no ID, gives to closest person or everyone in the vehicle.", {{name = "id", help = "Player ID"}}, false, function(source, args)
	local src = source
    TriggerClientEvent('IND-vehiclekeys:client:GiveKeys', src, tonumber(args[1]))
end)

INDCore.Commands.Add("addkeys", "Adds keys to a vehicle for someone.", {{name = "id", help = "Player ID"}, {name = "plate", help = "Plate"}}, true, function(source, args)
	local src = source
    if not args[1] or not args[2] then
        TriggerClientEvent('INDCore:Notify', src, 'Fill out the player ID and Plate arguments.')
        return
    end
    GiveKeys(tonumber(args[1]), args[2])
end, 'admin')

INDCore.Commands.Add("removekeys", "Remove keys to a vehicle for someone.", {{name = "id", help = "Player ID"}, {name = "plate", help = "Plate"}}, true, function(source, args)
	local src = source
    if not args[1] or not args[2] then
        TriggerClientEvent('INDCore:Notify', src, 'Fill out the player ID and Plate arguments.')
        return
    end
    RemoveKeys(tonumber(args[1]), args[2])
end, 'admin')