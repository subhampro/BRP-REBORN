CreateThread(function()
    while true do
        local sleep = 0
        if LocalPlayer.state.isLoggedIn then
            sleep = (1000 * 60) * INDCore.Config.UpdateInterval
            TriggerServerEvent('INDCore:UpdatePlayer')
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if (INDCore.PlayerData.metadata['hunger'] <= 0 or INDCore.PlayerData.metadata['thirst'] <= 0) and not (INDCore.PlayerData.metadata['isdead'] or INDCore.PlayerData.metadata["inlaststand"]) then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                local decreaseThreshold = math.random(5, 10)
                SetEntityHealth(ped, currentHealth - decreaseThreshold)
            end
        end
        Wait(INDCore.Config.StatusInterval)
    end
end)
