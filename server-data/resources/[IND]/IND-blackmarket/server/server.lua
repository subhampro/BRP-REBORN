INDCore = nil
TriggerEvent('INDCore:GetObject', function(obj) INDCore = obj end)

RegisterServerEvent('black:server:market')
AddEventHandler('black:server:market', function()
	local src = source
    TriggerClientEvent('open:market', src)
end)

RegisterServerEvent('black:server:marketGang')
AddEventHandler('black:server:marketGang', function()
	local src = source
    TriggerClientEvent('open:marketGang', src)
end)