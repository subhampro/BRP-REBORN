local INDCore = exports['IND-core']:GetCoreObject()

if Config.UseableItems then

    INDCore.Functions.CreateUseableItem("newscam", function(source)
        TriggerClientEvent("Cam:ToggleCam", source)
    end)

    INDCore.Functions.CreateUseableItem("newsmic", function(source)
        TriggerClientEvent("Mic:ToggleMic", source)
    end)

    INDCore.Functions.CreateUseableItem("newsbmic", function(source)
        TriggerClientEvent("Mic:ToggleBMic", source)
    end)

else

    local Player = INDCore.Functions.GetPlayer(source)
    INDCore.Commands.Add("newscam", "Grab a news camera", {}, false, function(source, _)
        if Player.PlayerData.job.name ~= "reporter" then return end
        TriggerClientEvent("Cam:ToggleCam", source)
    end)

    INDCore.Commands.Add("newsmic", "Grab a news microphone", {}, false, function(source, _)
        if Player.PlayerData.job.name ~= "reporter" then return end
        TriggerClientEvent("Mic:ToggleMic", source)
    end)

    INDCore.Commands.Add("newsbmic", "Grab a Boom microphone", {}, false, function(source, _)
        if Player.PlayerData.job.name ~= "reporter" then return end
        TriggerClientEvent("Mic:ToggleBMic", source)
    end)
end