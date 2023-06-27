local INDCore = exports['IND-core']:GetCoreObject()

INDCore.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, _)
	TriggerClientEvent("IND-commandbinding:client:openUI", source)
end)

RegisterNetEvent('IND-commandbinding:server:setKeyMeta', function(keyMeta)
    local src = source
    local ply = INDCore.Functions.GetPlayer(src)

    ply.Functions.SetMetaData("commandbinds", keyMeta)
end)
