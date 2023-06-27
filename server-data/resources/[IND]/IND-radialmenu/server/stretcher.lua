RegisterNetEvent('IND-radialmenu:server:RemoveStretcher', function(pos, stretcherObject)
    TriggerClientEvent('IND-radialmenu:client:RemoveStretcherFromArea', -1, pos, stretcherObject)
end)

RegisterNetEvent('IND-radialmenu:Stretcher:BusyCheck', function(id, type)
    TriggerClientEvent('IND-radialmenu:Stretcher:client:BusyCheck', id, source, type)
end)

RegisterNetEvent('IND-radialmenu:server:BusyResult', function(isBusy, otherId, type)
    TriggerClientEvent('IND-radialmenu:client:Result', otherId, isBusy, type)
end)