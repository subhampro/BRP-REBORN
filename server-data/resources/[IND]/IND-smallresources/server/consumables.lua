local INDCore = exports['IND-core']:GetCoreObject()
----------- / alcohol

for k,_ in pairs(Config.ConsumablesAlcohol) do
    INDCore.Functions.CreateUseableItem(k, function(source, item)
        TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
    end)
end

----------- / Eat

for k,_ in pairs(Config.ConsumablesEat) do
    INDCore.Functions.CreateUseableItem(k, function(source, item)
        local Player = INDCore.Functions.GetPlayer(source)
        if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end)
end

----------- / Drink
for k,_ in pairs(Config.ConsumablesDrink) do
    INDCore.Functions.CreateUseableItem(k, function(source, item)
        local Player = INDCore.Functions.GetPlayer(source)
        if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end)
end

----------- / Custom
for k,_ in pairs(Config.ConsumablesCustom) do
    INDCore.Functions.CreateUseableItem(k, function(source, item)
        local Player = INDCore.Functions.GetPlayer(source)
        if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
        TriggerClientEvent("consumables:client:Custom", source, item.name)
    end)
end

local function CreateItem(name,type)
    INDCore.Functions.CreateUseableItem(name, function(source, item)
        local Player = INDCore.Functions.GetPlayer(source)
        if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
        TriggerClientEvent("consumables:client:"..type, source, item.name)
    end)
end
----------- / Drug

INDCore.Functions.CreateUseableItem("joint", function(source, item)
    local Player = INDCore.Functions.GetPlayer(source)
    if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
    TriggerClientEvent("consumables:client:UseJoint", source)
end)

INDCore.Functions.CreateUseableItem("cokebaggy", function(source)
    TriggerClientEvent("consumables:client:Cokebaggy", source)
end)

INDCore.Functions.CreateUseableItem("crack_baggy", function(source)
    TriggerClientEvent("consumables:client:Crackbaggy", source)
end)

INDCore.Functions.CreateUseableItem("xtcbaggy", function(source, _)
    TriggerClientEvent("consumables:client:EcstasyBaggy", source)
end)

INDCore.Functions.CreateUseableItem("oxy", function(source)
    TriggerClientEvent("consumables:client:oxy", source)
end)

INDCore.Functions.CreateUseableItem("meth", function(source)
    TriggerClientEvent("consumables:client:meth", source)
end)

----------- / Tools

INDCore.Functions.CreateUseableItem("armor", function(source)
    TriggerClientEvent("consumables:client:UseArmor", source)
end)

INDCore.Functions.CreateUseableItem("heavyarmor", function(source)
    TriggerClientEvent("consumables:client:UseHeavyArmor", source)
end)

INDCore.Commands.Add("resetarmor", "Resets Vest (Police Only)", {}, false, function(source)
    local Player = INDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("consumables:client:ResetArmor", source)
    else
        TriggerClientEvent('INDCore:Notify', source,  "For Police Officer Only", "error")
    end
end)

INDCore.Functions.CreateUseableItem("binoculars", function(source)
    TriggerClientEvent("binoculars:Toggle", source)
end)

INDCore.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = INDCore.Functions.GetPlayer(source)
    if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
    TriggerClientEvent("consumables:client:UseParachute", source)
end)

INDCore.Commands.Add("resetparachute", "Resets Parachute", {}, false, function(source)
    TriggerClientEvent("consumables:client:ResetParachute", source)
end)

RegisterNetEvent('IND-smallpenis:server:AddParachute', function()
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.AddItem("parachute", 1)
end)

----------- / Firework

for _,v in pairs(ConsumablesFireworks) do
    INDCore.Functions.CreateUseableItem(v, function(source, item)
        local src = source
        TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "proj_indep_firework")
    end)
end

----------- / Lockpicking

INDCore.Functions.CreateUseableItem("lockpick", function(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, false)
end)

INDCore.Functions.CreateUseableItem("advancedlockpick", function(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, true)
end)

----------- / Unused

-- INDCore.Functions.CreateUseableItem("smoketrailred", function(source, item)
--     local Player = INDCore.Functions.GetPlayer(source)
--     if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
--     TriggerClientEvent("consumables:client:UseRedSmoke", source)
-- end)

-- Events for adding and removing specific items to fix some exploits

RegisterNetEvent('consumables:server:resetArmor', function()
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.AddItem('heavyarmor', 1)
end)

RegisterNetEvent('consumables:server:useHeavyArmor', function()
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('heavyarmor', 1)
end)

RegisterNetEvent('consumables:server:useArmor', function()
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('armor', 1)
end)

RegisterNetEvent('consumables:server:useMeth', function()
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('meth', 1)
end)

RegisterNetEvent('consumables:server:useOxy', function()
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('oxy', 1)
end)

RegisterNetEvent('consumables:server:useXTCBaggy', function()
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('xtcbaggy', 1)
end)

RegisterNetEvent('consumables:server:useCrackBaggy', function()
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('crack_baggy', 1)
end)

RegisterNetEvent('consumables:server:useCokeBaggy', function()
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('cokebaggy', 1)
end)

RegisterNetEvent('consumables:server:drinkAlcohol', function(item)
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    local foundItem = nil

    for k in pairs(Config.ConsumablesAlcohol) do
        if k == item then
            foundItem = k
            break
        end
    end

    if not foundItem then return end

    Player.Functions.RemoveItem(foundItem, 1)
end)

RegisterNetEvent('consumables:server:UseFirework', function(item)
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    local foundItem = nil

    for i = 1, #ConsumablesFireworks do
        if ConsumablesFireworks[i] == item then
            foundItem = ConsumablesFireworks[i]
            break
        end
    end

    if not foundItem then return end

    Player.Functions.RemoveItem(foundItem, 1)
end)

RegisterNetEvent('consumables:server:addThirst', function(amount)
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.SetMetaData('thirst', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', source, Player.PlayerData.metadata.hunger, amount)
end)

RegisterNetEvent('consumables:server:addHunger', function(amount)
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.SetMetaData('hunger', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', source, amount, Player.PlayerData.metadata.thirst)
end)

INDCore.Functions.CreateCallback('consumables:itemdata', function(_, cb, itemName)
    cb(Config.ConsumablesCustom[itemName])
end)

local function AddDrink(drinkname, replenish)
    if Config.ConsumablesDrink[drinkname] ~= nil then
        return false, "already added"
    else
        Config.ConsumablesDrink[drinkname] = replenish
        CreateItem(drinkname, 'Drink')
        return true, "success"
    end
end

exports('AddDrink', AddDrink)

local function AddFood(foodname, replenish)
    if Config.ConsumablesEat[foodname] ~= nil then
        return false, "already added"
    else
        Config.ConsumablesEat[foodname] = replenish
        CreateItem(foodname, 'Eat')
        return true, "success"
    end
end

exports('AddFood', AddFood)

local function AddAlcohol(alcoholname, replenish)
    if Config.ConsumablesAlcohol[alcoholname] ~= nil then
        return false, "already added"
    else
        Config.ConsumablesAlcohol[alcoholname] = replenish
        CreateItem(alcoholname, 'DrinkAlcohol')
        return true, "success"
    end
end

exports('AddAlcohol', AddAlcohol)

local function AddCustom(itemname, data)
    if 'consumables:itemdata' ~= nil then
        return false, "already added"
    else
        Config.ConsumablesCustom[itemname] = data
        CreateItem(itemname, 'Custom')
        return true, "success"
    end
end

exports('AddCustom', AddCustom)