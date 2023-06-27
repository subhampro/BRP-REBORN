INDCore = {}
INDCore.Config = INDConfig
INDCore.Shared = INDShared
INDCore.ClientCallbacks = {}
INDCore.ServerCallbacks = {}

exports('GetCoreObject', function()
    return INDCore
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local INDCore = exports['IND-core']:GetCoreObject()
