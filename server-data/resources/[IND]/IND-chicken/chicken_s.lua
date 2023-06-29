INDCore = nil
TriggerEvent('INDCore:GetObject', function(obj) INDCore = obj end)

RegisterServerEvent('IND-chickenjob:getNewChicken')
AddEventHandler('IND-chickenjob:getNewChicken', function()
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)


      if TriggerClientEvent("INDCore:Notify", src, "You Received 3 Alive chicken!", "Success", 8000) then
          Player.Functions.AddItem('alivechicken', 3)
          TriggerClientEvent("inventory:client:ItemBox", source, INDCore.Shared.Items['alivechicken'], "add")
      end
end)

RegisterServerEvent('IND-chickenjob:getcutChicken')
AddEventHandler('IND-chickenjob:getcutChicken', function()
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)


      if TriggerClientEvent("INDCore:Notify", src, "Well! You slaughtered chicken.", "Success", 8000) then
          Player.Functions.RemoveItem('alivechicken', 1)
          Player.Functions.AddItem('slaughteredchicken', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, INDCore.Shared.Items['alivechicken'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, INDCore.Shared.Items['slaughteredchicken'], "add")
      end
end)

RegisterServerEvent('IND-chickenjob:startChicken')
AddEventHandler('IND-chickenjob:startChicken', function()
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)

      if TriggerClientEvent("INDCore:Notify", src, "You Paid $100!", "Success", 8000) then
        Player.Functions.RemoveMoney('bank', 100)
          
      end
end)

RegisterServerEvent('IND-chickenjob:getpackedChicken')
AddEventHandler('IND-chickenjob:getpackedChicken', function()
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
  

      if TriggerClientEvent("INDCore:Notify", src, "You Packed Slaughtered chicken .", "Success", 8000) then
          Player.Functions.RemoveItem('slaughteredchicken', 1)
          Player.Functions.AddItem('packagedchicken', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, INDCore.Shared.Items['slaughteredchicken'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, INDCore.Shared.Items['packagedchicken'], "add")
      end
end)


local ItemList = {
    ["packagedchicken"] = math.random(322, 470),
}

RegisterServerEvent('IND-chickenjob:sell')
AddEventHandler('IND-chickenjob:sell', function()
    local src = source
    local price = 0
    local Player = INDCore.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-items")
        TriggerClientEvent('INDCore:Notify', src, "You have sold your items")
    else
        TriggerClientEvent('INDCore:Notify', src, "You don't have items")
    end
end)


