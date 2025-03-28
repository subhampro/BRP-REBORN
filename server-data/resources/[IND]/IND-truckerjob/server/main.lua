local INDCore = exports['IND-core']:GetCoreObject()
local Bail = {}

RegisterNetEvent('IND-trucker:server:DoBail', function(bool, vehInfo)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    if bool then
        if Player.PlayerData.money.cash >= Config.TruckerJobTruckDeposit then
            Bail[Player.PlayerData.citizenid] = Config.TruckerJobTruckDeposit
            Player.Functions.RemoveMoney('cash', Config.TruckerJobTruckDeposit, "tow-received-bail")
            TriggerClientEvent('INDCore:Notify', src, Lang:t("success.paid_with_cash", {value = Config.TruckerJobTruckDeposit}), 'success')
            TriggerClientEvent('IND-trucker:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.TruckerJobTruckDeposit then
            Bail[Player.PlayerData.citizenid] = Config.TruckerJobTruckDeposit
            Player.Functions.RemoveMoney('bank', Config.TruckerJobTruckDeposit, "tow-received-bail")
            TriggerClientEvent('INDCore:Notify', src, Lang:t("success.paid_with_bank", {value = Config.TruckerJobTruckDeposit}), 'success')
            TriggerClientEvent('IND-trucker:client:SpawnVehicle', src, vehInfo)
        else
            TriggerClientEvent('INDCore:Notify', src, Lang:t("error.no_deposit", {value = Config.TruckerJobTruckDeposit}), 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] then
            Player.Functions.AddMoney('cash', Bail[Player.PlayerData.citizenid], "trucker-bail-paid")
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('INDCore:Notify', src, Lang:t("success.refund_to_cash", {value = Config.TruckerJobTruckDeposit}), 'success')
        end
    end
end)

RegisterNetEvent('IND-trucker:server:01101110', function(drops)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    drops = tonumber(drops)
    local bonus = 0

    if drops >= 5 then
        if Config.TruckerJobBonus < 0 then Config.TruckerJobBonus = 0 end
        bonus = (math.ceil(Config.TruckerJobDropPrice / 100) * Config.TruckerJobBonus) * drops
    end
    local payment = (Config.TruckerJobDropPrice * drops + bonus)
    payment = payment - (math.ceil(payment / 100) * Config.TruckerJobPaymentTax)
    Player.Functions.AddJobReputation(drops)
    Player.Functions.AddMoney("bank", payment, "trucker-salary")
    TriggerClientEvent('INDCore:Notify', src, Lang:t("success.you_earned", {value = payment}), 'success')
end)

RegisterNetEvent('IND-trucker:server:nano', function()
    local chance = math.random(1,100)
    if chance > 26 then return end
    local xPlayer = INDCore.Functions.GetPlayer(tonumber(source))
    xPlayer.Functions.AddItem("cryptostick", 1, false)
    TriggerClientEvent('inventory:client:ItemBox', source, INDCore.Shared.Items["cryptostick"], "add")
end)