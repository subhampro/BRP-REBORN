local INDCore = exports['IND-core']:GetCoreObject()
--Events
INDCore.Functions.CreateCallback('IND-shops:server:SetShopInv', function(_,cb)
    local shopInvJson = LoadResourceFile(GetCurrentResourceName(), Config.ShopsInvJsonFile)
    cb(shopInvJson)
end)
RegisterNetEvent('IND-shops:server:SaveShopInv',function()
    if not Config.UseTruckerJob then return end
    local shopinv = {}
    for k, v in pairs(Config.Locations) do
        shopinv[k] = {}
        shopinv[k].products = {}
        for kk, vv in pairs(v.products) do
            shopinv[k].products[kk] = {}
            shopinv[k].products[kk].amount = vv['amount']
        end
    end
    SaveResourceFile(GetCurrentResourceName(), Config.ShopsInvJsonFile, json.encode(shopinv))
end)
RegisterNetEvent('IND-shops:server:UpdateShopItems', function(shop, itemData, amount)
    if not Config.UseTruckerJob then return end
    if not shop or not itemData or not amount then return end
    Config.Locations[shop].products[itemData.slot].amount -= amount
    if Config.Locations[shop].products[itemData.slot].amount < 0 then
        Config.Locations[shop].products[itemData.slot].amount = 0
    end
    TriggerEvent('IND-shops:server:SaveShopInv')
    TriggerClientEvent('IND-shops:client:SetShopItems', -1, shop, Config.Locations[shop].products)
end)
RegisterNetEvent('IND-shops:server:RestockShopItems', function(shop)
    if not shop or not Config.Locations[shop].products then return end
    local randAmount = math.random(10, 50)
    for k in pairs(Config.Locations[shop].products) do
        Config.Locations[shop].products[k].amount += randAmount
    end
    TriggerEvent('IND-shops:server:SaveShopInv')
    TriggerClientEvent('IND-shops:client:RestockShopItems', -1, shop, randAmount)
end)
local ItemList = {
    ["casinochips"] = 1,
}
RegisterNetEvent('IND-shops:server:sellChips', function()
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    local xItem = Player.Functions.GetItemByName("casinochips")
    if xItem then
        for k in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] then
                if ItemList[Player.PlayerData.items[k].name] then
                    local price = ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    Player.Functions.AddMoney("cash", price, "sold-casino-chips")
                    INDCore.Functions.Notify(src, "You sold your chips for $" .. price)
                    TriggerEvent("IND-log:server:CreateLog", "casino", "Chips", "blue", "**" .. GetPlayerName(src) .. "** got $" .. price .. " for selling the Chips")
                end
            end
        end
    else
        INDCore.Functions.Notify(src, "You have no chips..")
    end
end)
RegisterNetEvent('IND-shops:server:SetShopList',function()
    local shoplist = {}
    local cnt = 0
    for k, v in pairs(Config.Locations) do
        cnt = cnt + 1
        shoplist[cnt] = {}
        shoplist[cnt].name = k
        shoplist[cnt].coords = v.delivery
    end
    TriggerClientEvent('IND-truckerjob:client:SetShopList',-1,shoplist)
end)
