local INDCore = exports['IND-core']:GetCoreObject()

-- Functions

local function generateOID()
    local num = math.random(1, 10) .. math.random(111, 999)

    return "OC" .. num
end

-- Callbacks

INDCore.Functions.CreateCallback('IND-occasions:server:getVehicles', function(_, cb)
    local result = MySQL.query.await('SELECT * FROM occasion_vehicles', {})
    if result[1] then
        cb(result)
    else
        cb(nil)
    end
end)

INDCore.Functions.CreateCallback("IND-occasions:server:getSellerInformation", function(_, cb, citizenid)
    MySQL.query('SELECT * FROM players WHERE citizenid = ?', {citizenid}, function(result)
        if result[1] then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

INDCore.Functions.CreateCallback("IND-vehiclesales:server:CheckModelName", function(_, cb, plate)
    if plate then
        local ReturnData = MySQL.scalar.await("SELECT vehicle FROM player_vehicles WHERE plate = ?", {plate})
        cb(ReturnData)
    end
end)

-- Events

RegisterNetEvent('IND-occasions:server:ReturnVehicle', function(vehicleData)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    local result = MySQL.query.await('SELECT * FROM occasion_vehicles WHERE plate = ? AND occasionid = ?', {vehicleData['plate'], vehicleData["oid"]})
    if result[1] then
        if result[1].seller == Player.PlayerData.citizenid then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {Player.PlayerData.license, Player.PlayerData.citizenid, vehicleData["model"], joaat(vehicleData["model"]), vehicleData["mods"], vehicleData["plate"], 0})
            MySQL.query('DELETE FROM occasion_vehicles WHERE occasionid = ? AND plate = ?', {vehicleData["oid"], vehicleData['plate']})
            TriggerClientEvent("IND-occasions:client:ReturnOwnedVehicle", src, result[1])
            TriggerClientEvent('IND-occasion:client:refreshVehicles', -1)
        else
            TriggerClientEvent('INDCore:Notify', src, Lang:t('error.not_your_vehicle'), 'error', 3500)
        end
    else
        TriggerClientEvent('INDCore:Notify', src, Lang:t('error.vehicle_does_not_exist'), 'error', 3500)
    end
end)

RegisterNetEvent('IND-occasions:server:sellVehicle', function(vehiclePrice, vehicleData)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    MySQL.query('DELETE FROM player_vehicles WHERE plate = ? AND vehicle = ?',{vehicleData.plate, vehicleData.model})
    MySQL.insert('INSERT INTO occasion_vehicles (seller, price, description, plate, model, mods, occasionid) VALUES (?, ?, ?, ?, ?, ?, ?)',{Player.PlayerData.citizenid, vehiclePrice, vehicleData.desc, vehicleData.plate, vehicleData.model,json.encode(vehicleData.mods), generateOID()})
    TriggerEvent("IND-log:server:CreateLog", "vehicleshop", "Vehicle for Sale", "red","**" .. GetPlayerName(src) .. "** has a " .. vehicleData.model .. " priced at " .. vehiclePrice)
    TriggerClientEvent('IND-occasion:client:refreshVehicles', -1)
end)

RegisterNetEvent('IND-occasions:server:sellVehicleBack', function(vehData)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    local price = 0
    local plate = vehData.plate
    for _, v in pairs(INDCore.Shared.Vehicles) do
        if v["hash"] == vehData.model then
            price = tonumber(v["price"])
            break
        end
    end
    local payout = math.floor(tonumber(price * 0.5)) -- This will give you half of the cars value
    Player.Functions.AddMoney('bank', payout)
    TriggerClientEvent('INDCore:Notify', src, Lang:t('success.sold_car_for_price', { value = payout }), 'success', 5500)
    MySQL.query('DELETE FROM player_vehicles WHERE plate = ?', {plate})
end)

RegisterNetEvent('IND-occasions:server:buyVehicle', function(vehicleData)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    local result = MySQL.query.await('SELECT * FROM occasion_vehicles WHERE plate = ? AND occasionid = ?',{vehicleData['plate'], vehicleData["oid"]})
    if result[1] and next(result[1]) then
        if Player.PlayerData.money.bank >= result[1].price then
            local SellerCitizenId = result[1].seller
            local SellerData = INDCore.Functions.GetPlayerByCitizenId(SellerCitizenId)
            local NewPrice = math.ceil((result[1].price / 100) * 77)
            Player.Functions.RemoveMoney('bank', result[1].price)
            MySQL.insert(
                'INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                    Player.PlayerData.license,
                    Player.PlayerData.citizenid, result[1]["model"],
                    GetHashKey(result[1]["model"]),
                    result[1]["mods"],
                    result[1]["plate"],
                    0
                })
            if SellerData then
                SellerData.Functions.AddMoney('bank', NewPrice)
            else
                local BuyerData = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?',{SellerCitizenId})
                if BuyerData[1] then
                    local BuyerMoney = json.decode(BuyerData[1].money)
                    BuyerMoney.bank = BuyerMoney.bank + NewPrice
                    MySQL.update('UPDATE players SET money = ? WHERE citizenid = ?', {json.encode(BuyerMoney), SellerCitizenId})
                end
            end
            TriggerEvent("IND-log:server:CreateLog", "vehicleshop", "bought", "green", "**" .. GetPlayerName(src) .. "** has bought for " .. result[1].price .. " (" .. result[1].plate ..") from **" .. SellerCitizenId .. "**")
            TriggerClientEvent("IND-occasions:client:BuyFinished", src, result[1])
            TriggerClientEvent('IND-occasion:client:refreshVehicles', -1)
            MySQL.query('DELETE FROM occasion_vehicles WHERE plate = ? AND occasionid = ?',{result[1].plate, result[1].occasionid})
            exports['IND-phone']:sendNewMailToOffline(SellerCitizenId, {
                sender = Lang:t('mail.sender'),
                subject = Lang:t('mail.subject'),
                message = Lang:t('mail.message', { value = NewPrice, value2 = INDCore.Shared.Vehicles[result[1].model].name})
            })
        else
            TriggerClientEvent('INDCore:Notify', src, Lang:t('error.not_enough_money'), 'error', 3500)
        end
    end
end)
