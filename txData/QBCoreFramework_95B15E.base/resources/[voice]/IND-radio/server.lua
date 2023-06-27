local INDCore = exports['IND-core']:GetCoreObject()

INDCore.Functions.CreateUseableItem("radio", function(source)
    TriggerClientEvent('IND-radio:use', source)
end)

for channel, config in pairs(Config.RestrictedChannels) do
    exports['pma-voice']:addChannelCheck(channel, function(source)
        local Player = INDCore.Functions.GetPlayer(source)
        return config[Player.PlayerData.job.name] and Player.PlayerData.job.onduty
    end)
end
