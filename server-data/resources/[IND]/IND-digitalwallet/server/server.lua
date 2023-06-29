-- INDCore = nil
local INDCore = exports['IND-core']:GetCoreObject()

TriggerEvent('INDCore:GetObject', function(obj) INDCore = obj end)

local function getMoneyFromUser(id_user)
	local xPlayer = INDCore.Functions.GetPlayer(id_user)
	return xPlayer.PlayerData.money["cash"]

end

local function getBankFromUser(id_user)
		local xPlayer = INDCore.Functions.GetPlayer(id_user)
		local account = xPlayer.PlayerData.money["bank"]
	return account.money

end


RegisterServerEvent('allcity_wallet:getMoneys')
AddEventHandler('allcity_wallet:getMoneys', function()

	local source = source
	local xPlayer = INDCore.Functions.GetPlayer(source)
	if xPlayer ~= nil then
		local wallet 		= xPlayer.PlayerData.money["bank"]
		local bank 			= xPlayer.PlayerData.money["cash"]
	    TriggerClientEvent("allcity_wallet:setValues", source, wallet, bank)
	end

end)






