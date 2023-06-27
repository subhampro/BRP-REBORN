local INDCore = exports['IND-core']:GetCoreObject()

local function exploitBan(id, reason)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            GetPlayerName(id),
            INDCore.Functions.GetIdentifier(id, 'license'),
            INDCore.Functions.GetIdentifier(id, 'discord'),
            INDCore.Functions.GetIdentifier(id, 'ip'),
            reason,
            2147483647,
            'IND-pawnshop'
        })
    TriggerEvent('IND-log:server:CreateLog', 'pawnshop', 'Player Banned', 'red',
        string.format('%s was banned by %s for %s', GetPlayerName(id), 'IND-pawnshop', reason), true)
    DropPlayer(id, 'You were permanently banned by the server for: Exploiting')
end

RegisterNetEvent('IND-pawnshop:server:sellPawnItems', function(itemName, itemAmount, itemPrice)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    local totalPrice = (tonumber(itemAmount) * itemPrice)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local dist
    for _, value in pairs(Config.PawnLocation) do
        dist = #(playerCoords - value.coords)
        if #(playerCoords - value.coords) < 2 then
            dist = #(playerCoords - value.coords)
            break
        end
    end
    if dist > 5 then exploitBan(src, 'sellPawnItems Exploiting') return end
    if Player.Functions.RemoveItem(itemName, tonumber(itemAmount)) then
        if Config.BankMoney then
            Player.Functions.AddMoney('bank', totalPrice)
        else
            Player.Functions.AddMoney('cash', totalPrice)
        end
        TriggerClientEvent('INDCore:Notify', src, Lang:t('success.sold', { value = tonumber(itemAmount), value2 = INDCore.Shared.Items[itemName].label, value3 = totalPrice }),'success')
        TriggerClientEvent('inventory:client:ItemBox', src, INDCore.Shared.Items[itemName], 'remove')
    else
        TriggerClientEvent('INDCore:Notify', src, Lang:t('error.no_items'), 'error')
    end
    TriggerClientEvent('IND-pawnshop:client:openMenu', src)
end)

RegisterNetEvent('IND-pawnshop:server:meltItemRemove', function(itemName, itemAmount, item)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(itemName, itemAmount) then
        TriggerClientEvent('inventory:client:ItemBox', src, INDCore.Shared.Items[itemName], 'remove')
        local meltTime = (tonumber(itemAmount) * item.time)
        TriggerClientEvent('IND-pawnshop:client:startMelting', src, item, tonumber(itemAmount), (meltTime * 60000 / 1000))
        TriggerClientEvent('INDCore:Notify', src, Lang:t('info.melt_wait', { value = meltTime }), 'primary')
    else
        TriggerClientEvent('INDCore:Notify', src, Lang:t('error.no_items'), 'error')
    end
end)

RegisterNetEvent('IND-pawnshop:server:pickupMelted', function(item)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local dist
    for _, value in pairs(Config.PawnLocation) do
        dist = #(playerCoords - value.coords)
        if #(playerCoords - value.coords) < 2 then
            dist = #(playerCoords - value.coords)
            break
        end
    end
    if dist > 5 then exploitBan(src, 'pickupMelted Exploiting') return end
    for _, v in pairs(item.items) do
        local meltedAmount = v.amount
        for _, m in pairs(v.item.reward) do
            local rewardAmount = m.amount
            if Player.Functions.AddItem(m.item, (meltedAmount * rewardAmount)) then
                TriggerClientEvent('inventory:client:ItemBox', src, INDCore.Shared.Items[m.item], 'add')
                TriggerClientEvent('INDCore:Notify', src, Lang:t('success.items_received',{ value = (meltedAmount * rewardAmount), value2 = INDCore.Shared.Items[m.item].label }), 'success')
            else
                TriggerClientEvent('INDCore:Notify', src, Lang:t('error.inventory_full', { value = INDCore.Shared.Items[m.item].label}), 'warning', 7500)
            end
        end
    end
    TriggerClientEvent('IND-pawnshop:client:resetPickup', src)
    TriggerClientEvent('IND-pawnshop:client:openMenu', src)
end)

INDCore.Functions.CreateCallback('IND-pawnshop:server:getInv', function(source, cb)
    local Player = INDCore.Functions.GetPlayer(source)
    local inventory = Player.PlayerData.items
    return cb(inventory)
end)
