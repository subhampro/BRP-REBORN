INDCore = nil
TriggerEvent('INDCore:GetObject', function(obj) INDCore = obj end)

INDCore.Commands.Add("repaircar", "Mechanic Repair", {}, false, function(source, args)
	local _player = INDCore.Functions.GetPlayer(source)
	if _player.PlayerData.job.name == "mechanic" or _player.PlayerData.job.name == "mechanic1" or _player.PlayerData.job.name == "mechanic2" or _player.PlayerData.job.name == "mechanic3" then 
		TriggerClientEvent('IND-repair:client:triggerMenu', source)
	else 
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for Mechanic!")
	end
end)