local INDCore = exports['IND-core']:GetCoreObject()

RegisterNetEvent('KickForAFK', function()
	DropPlayer(source, Lang:t("afk.kick_message"))
end)

INDCore.Functions.CreateCallback('IND-afkkick:server:GetPermissions', function(source, cb)
    cb(INDCore.Functions.GetPermission(source))
end)
