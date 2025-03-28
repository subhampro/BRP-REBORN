local function getAvailableDrugs(source)
    local AvailableDrugs = {}
    local Player = INDCore.Functions.GetPlayer(source)

    if not Player then return nil end

    for k in pairs(Config.DrugsPrice) do
        local item = Player.Functions.GetItemByName(k)

        if item then
            AvailableDrugs[#AvailableDrugs + 1] = {
                item = item.name,
                amount = item.amount,
                label = INDCore.Shared.Items[item.name]["label"]
            }
        end
    end
    return table.type(AvailableDrugs) ~= "empty" and AvailableDrugs or nil
end

INDCore.Functions.CreateCallback('IND-drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    cb(getAvailableDrugs(source))
end)

RegisterNetEvent('IND-drugs:server:giveStealItems', function(drugType, amount)
    local availableDrugs = getAvailableDrugs(source)
    local Player = INDCore.Functions.GetPlayer(source)

    if not availableDrugs or not Player then return end

    Player.Functions.AddItem(availableDrugs[drugType].item, amount)
end)

RegisterNetEvent('IND-drugs:server:sellCornerDrugs', function(drugType, amount, price)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    local availableDrugs = getAvailableDrugs(src)

    if not availableDrugs or not Player then return end

    local item = availableDrugs[drugType].item

    local hasItem = Player.Functions.GetItemByName(item)
    if hasItem.amount >= amount then
        TriggerClientEvent('INDCore:Notify', src, Lang:t("success.offer_accepted"), 'success')
        Player.Functions.RemoveItem(item, amount)
        Player.Functions.AddMoney('cash', price, "sold-cornerdrugs")
        TriggerClientEvent('inventory:client:ItemBox', src, INDCore.Shared.Items[item], "remove")
        TriggerClientEvent('IND-drugs:client:refreshAvailableDrugs', src, getAvailableDrugs(src))
    else
        TriggerClientEvent('IND-drugs:client:cornerselling', src)
    end
end)

RegisterNetEvent('IND-drugs:server:robCornerDrugs', function(drugType, amount)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    local availableDrugs = getAvailableDrugs(src)

    if not availableDrugs or not Player then return end

    local item = availableDrugs[drugType].item

    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, INDCore.Shared.Items[item], "remove")
    TriggerClientEvent('IND-drugs:client:refreshAvailableDrugs', src, getAvailableDrugs(src))
end)
