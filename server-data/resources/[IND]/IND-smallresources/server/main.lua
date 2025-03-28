local INDCore = exports['IND-core']:GetCoreObject()
local VehicleNitrous = {}

RegisterNetEvent('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent("tackle:client:GetTackled", playerId)
end)

INDCore.Functions.CreateCallback('nos:GetNosLoadedVehs', function(_, cb)
    cb(VehicleNitrous)
end)

INDCore.Commands.Add("id", "Check Your ID #", {}, false, function(source)
    TriggerClientEvent('INDCore:Notify', source,  "ID: "..source)
end)

INDCore.Functions.CreateUseableItem("harness", function(source, item)
    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
end)

RegisterNetEvent('equip:harness', function(item)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)

    if not Player then return end

    if not Player.PlayerData.items[item.slot].info.uses then
        Player.PlayerData.items[item.slot].info.uses = Config.HarnessUses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    elseif Player.PlayerData.items[item.slot].info.uses == 1 then
        TriggerClientEvent("inventory:client:ItemBox", src, INDCore.Shared.Items['harness'], "remove")
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses -= 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)

    if not Player then return end

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses -= 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('IND-carwash:server:washCar', function()
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)

    if not Player then return end

    if Player.Functions.RemoveMoney('cash', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('IND-carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('IND-carwash:client:washCar', src)
    else
        TriggerClientEvent('INDCore:Notify', src, Lang:t("error.dont_have_enough_money"), 'error')
    end
end)

INDCore.Functions.CreateCallback('smallresources:server:GetCurrentPlayers', function(_, cb)
    local TotalPlayers = 0
    local players = INDCore.Functions.GetPlayers()
    for _ in pairs(players) do
        TotalPlayers += 1
    end
    cb(TotalPlayers)
end)
