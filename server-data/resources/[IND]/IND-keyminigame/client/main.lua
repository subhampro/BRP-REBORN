KeyMinigameCallback = {}

RegisterNetEvent('IND-keyminigame:show', function()
	SendNUIMessage({
        action = "ShowMinigame"
    })
	SetNuiFocus(true, false)
end)

RegisterNetEvent('IND-keyminigame:start', function(callback)
    KeyMinigameCallback = callback
	SendNUIMessage({
        action = "StartMinigame"
    })
end)

RegisterNUICallback('callback', function(data, cb)
	KeyMinigameCallback(data.faults)
    SendNUIMessage({
        action = "HideMinigame"
    })
	SetNuiFocus(false, false)
    cb('ok')
end)
