local INDCore = exports['IND-core']:GetCoreObject()

-- Functions

local function ResetHouseStateTimer(house)
    CreateThread(function ()
        Wait(Config.TimeToCloseDoors * 60000)
        Config.Houses[house]["opened"] = false
        for _, v in pairs(Config.Houses[house]["furniture"]) do
            v["searched"] = false
        end
        TriggerClientEvent('IND-houserobbery:client:ResetHouseState', -1, house)
    end)
end

-- Callbacks

INDCore.Functions.CreateCallback('IND-houserobbery:server:GetHouseConfig', function(_, cb)
    cb(Config.Houses)
end)

-- Events

RegisterNetEvent('IND-houserobbery:server:SetBusyState', function(cabin, house, bool)
    Config.Houses[house]["furniture"][cabin]["isBusy"] = bool
    TriggerClientEvent('IND-houserobbery:client:SetBusyState', -1, cabin, house, bool)
end)

RegisterNetEvent('IND-houserobbery:server:enterHouse', function(house)
    local src = source
    if not Config.Houses[house]["opened"] then
        ResetHouseStateTimer(house)
        TriggerClientEvent('IND-houserobbery:client:setHouseState', -1, house, true)
    end
    TriggerClientEvent('IND-houserobbery:client:enterHouse', src, house)
    Config.Houses[house]["opened"] = true
end)

RegisterNetEvent('IND-houserobbery:server:searchFurniture', function(cabin, house)
    local src = source
    local player = INDCore.Functions.GetPlayer(src)
    local tier = Config.Houses[house].tier
    local availableItems = Config.Rewards[tier][Config.Houses[house].furniture[cabin].type]
    local itemCount = math.random(0, 3)

    if itemCount > 0 then
        for _ = 1, itemCount do
            local selectedItem = availableItems[math.random(1, #availableItems)]
            local itemInfo = INDCore.Shared.Items[selectedItem.item]

            if not itemInfo.unique then
                player.Functions.AddItem(selectedItem.item, math.random(selectedItem.min, selectedItem.max))
            else
                player.Functions.AddItem(selectedItem.item, 1)
            end
            TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            Wait(500)
        end
    else
        TriggerClientEvent('INDCore:Notify', src, Lang:t("error.emty_box"), 'error')
    end

    Config.Houses[house]["furniture"][cabin]["searched"] = true
    TriggerClientEvent('IND-houserobbery:client:setCabinState', -1, house, cabin, true)
end)

RegisterNetEvent('IND-houserobbery:server:removeAdvancedLockpick', function()
    local Player = INDCore.Functions.GetPlayer(source)
    if not Player then return end

    Player.Functions.RemoveItem('advancedlockpick', 1)
end)

RegisterNetEvent('IND-houserobbery:server:removeLockpick', function()
    local Player = INDCore.Functions.GetPlayer(source)
    if not Player then return end

    Player.Functions.RemoveItem('lockpick', 1)
end)
