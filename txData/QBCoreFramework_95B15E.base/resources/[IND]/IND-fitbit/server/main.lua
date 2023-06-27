local INDCore = exports['IND-core']:GetCoreObject()

INDCore.Functions.CreateUseableItem("fitbit", function(source)
    TriggerClientEvent('IND-fitbit:use', source)
end)

RegisterNetEvent('IND-fitbit:server:setValue', function(type, value)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    if not Player then return end
    if not Player.Functions.GetItemByName("fitbit") then return end

    local currentMeta = Player.PlayerData.metadata["fitbit"]
    local fitbitData = {
        thirst = type == "thirst" and value or currentMeta.thirst,
        food = type == "food" and value or currentMeta.food
    }
    Player.Functions.SetMetaData('fitbit', fitbitData)
end)
