local INDCore = exports['IND-core']:GetCoreObject()

RegisterNetEvent('fuel:pay', function(price)
	local Player = INDCore.Functions.GetPlayer(source)
	local amount = math.floor(price + 0.5)

	if not Player or price <= 0 then return end

	Player.Functions.RemoveMoney('cash', amount)
end)

RegisterNetEvent('fuel:addPetrolCan', function()
	local Player = INDCore.Functions.GetPlayer(source)

	if not Player then return end

	Player.Functions.AddItem('weapon_petrolcan', 1)
end)
