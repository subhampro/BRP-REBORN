local INDCore = exports['IND-core']:GetCoreObject()
INDCore.Commands.Add("fix", "Repair your vehicle (Admin Only)", {}, false, function(source)
    TriggerClientEvent('iens:repaira', source)
    TriggerClientEvent('vehiclemod:client:fixEverything', source)
end, "admin")

INDCore.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = INDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("IND-vehiclefailure:client:RepairVehicle", source)
    end
end)

INDCore.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = INDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("IND-vehiclefailure:client:CleanVehicle", source)
    end
end)

INDCore.Functions.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = INDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("IND-vehiclefailure:client:RepairVehicleFull", source)
    end
end)

RegisterNetEvent('IND-vehiclefailure:removeItem', function(item)
    local src = source
    local ply = INDCore.Functions.GetPlayer(src)
    ply.Functions.RemoveItem(item, 1)
end)

RegisterNetEvent('IND-vehiclefailure:server:removewashingkit', function(veh)
    local src = source
    local ply = INDCore.Functions.GetPlayer(src)
    ply.Functions.RemoveItem("cleaningkit", 1)
    TriggerClientEvent('IND-vehiclefailure:client:SyncWash', -1, veh)
end)