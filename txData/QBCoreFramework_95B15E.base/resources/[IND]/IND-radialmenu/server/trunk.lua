local INDCore = exports['IND-core']:GetCoreObject()
local trunkBusy = {}

RegisterNetEvent('IND-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('IND-radialmenu:trunk:client:Door', -1, plate, door, open)
end)

RegisterNetEvent('IND-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

RegisterNetEvent('IND-trunk:server:KidnapTrunk', function(targetId, closestVehicle)
    TriggerClientEvent('IND-trunk:client:KidnapGetIn', targetId, closestVehicle)
end)

INDCore.Functions.CreateCallback('IND-trunk:server:getTrunkBusy', function(_, cb, plate)
    if trunkBusy[plate] then cb(true) return end
    cb(false)
end)

INDCore.Commands.Add("getintrunk", Lang:t("general.getintrunk_command_desc"), {}, false, function(source)
    TriggerClientEvent('IND-trunk:client:GetIn', source)
end)

INDCore.Commands.Add("putintrunk", Lang:t("general.putintrunk_command_desc"), {}, false, function(source)
    TriggerClientEvent('IND-trunk:server:KidnapTrunk', source)
end)