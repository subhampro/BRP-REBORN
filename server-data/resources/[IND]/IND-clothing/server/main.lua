local INDCore = exports['IND-core']:GetCoreObject()

RegisterServerEvent("IND-clothing:saveSkin", function(model, skin)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    if model ~= nil and skin ~= nil then
        -- TODO: Update primary key to be citizenid so this can be an insert on duplicate update query
        MySQL.query('DELETE FROM playerskins WHERE citizenid = ?', { Player.PlayerData.citizenid }, function()
            MySQL.insert('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)', {
                Player.PlayerData.citizenid,
                model,
                skin,
                1
            })
        end)
    end
end)

RegisterServerEvent("IND-clothes:loadPlayerSkin", function()
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { Player.PlayerData.citizenid, 1 })
    if result[1] ~= nil then
        TriggerClientEvent("IND-clothes:loadSkin", src, false, result[1].model, result[1].skin)
    else
        TriggerClientEvent("IND-clothes:loadSkin", src, true)
    end
end)

RegisterServerEvent("IND-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        MySQL.insert('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (?, ?, ?, ?, ?)', {
            Player.PlayerData.citizenid,
            outfitName,
            model,
            json.encode(skinData),
            outfitId
        }, function()
            local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
            if result[1] ~= nil then
                TriggerClientEvent('IND-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('IND-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end
end)

RegisterServerEvent("IND-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    MySQL.query('DELETE FROM player_outfits WHERE citizenid = ? AND outfitname = ? AND outfitId = ?', {
        Player.PlayerData.citizenid,
        outfitName,
        outfitId
    }, function()
        local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
        if result[1] ~= nil then
            TriggerClientEvent('IND-clothing:client:reloadOutfits', src, result)
        else
            TriggerClientEvent('IND-clothing:client:reloadOutfits', src, nil)
        end
    end)
end)

INDCore.Functions.CreateCallback('IND-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    local anusVal = {}

    local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
    if result[1] ~= nil then
        for k, v in pairs(result) do
            result[k].skin = json.decode(result[k].skin)
            anusVal[k] = v
        end
        cb(anusVal)
    end
    cb(anusVal)
end)
