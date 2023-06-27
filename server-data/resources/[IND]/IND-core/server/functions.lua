INDCore.Functions = {}
INDCore.Player_Buckets = {}
INDCore.Entity_Buckets = {}
INDCore.UsableItems = {}

-- Getters
-- Get your player first and then trigger a function on them
-- ex: local player = INDCore.Functions.GetPlayer(source)
-- ex: local example = player.Functions.functionname(parameter)

---Gets the coordinates of an entity
---@param entity number
---@return vector4
function INDCore.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return vector4(coords.x, coords.y, coords.z, heading)
end

---Gets player identifier of the given type
---@param source any
---@param idtype string
---@return string?
function INDCore.Functions.GetIdentifier(source, idtype)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end
    return nil
end

---Gets a players server id (source). Returns 0 if no player is found.
---@param identifier string
---@return number
function INDCore.Functions.GetSource(identifier)
    for src, _ in pairs(INDCore.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return 0
end

---Get player with given server id (source)
---@param source any
---@return table
function INDCore.Functions.GetPlayer(source)
    if type(source) == 'number' then
        return INDCore.Players[source]
    else
        return INDCore.Players[INDCore.Functions.GetSource(source)]
    end
end

---Get player by citizen id
---@param citizenid string
---@return table?
function INDCore.Functions.GetPlayerByCitizenId(citizenid)
    for src in pairs(INDCore.Players) do
        if INDCore.Players[src].PlayerData.citizenid == citizenid then
            return INDCore.Players[src]
        end
    end
    return nil
end

---Get offline player by citizen id
---@param citizenid string
---@return table?
function INDCore.Functions.GetOfflinePlayerByCitizenId(citizenid)
    return INDCore.Player.GetOfflinePlayer(citizenid)
end

---Get player by phone number
---@param number number
---@return table?
function INDCore.Functions.GetPlayerByPhone(number)
    for src in pairs(INDCore.Players) do
        if INDCore.Players[src].PlayerData.charinfo.phone == number then
            return INDCore.Players[src]
        end
    end
    return nil
end

---Get all players. Returns the server ids of all players.
---@return table
function INDCore.Functions.GetPlayers()
    local sources = {}
    for k in pairs(INDCore.Players) do
        sources[#sources+1] = k
    end
    return sources
end

---Will return an array of IND Player class instances
---unlike the GetPlayers() wrapper which only returns IDs
---@return table
function INDCore.Functions.GetINDPlayers()
    return INDCore.Players
end

---Gets a list of all on duty players of a specified job and the number
---@param job string
---@return table, number
function INDCore.Functions.GetPlayersOnDuty(job)
    local players = {}
    local count = 0
    for src, Player in pairs(INDCore.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                players[#players + 1] = src
                count += 1
            end
        end
    end
    return players, count
end

---Returns only the amount of players on duty for the specified job
---@param job any
---@return number
function INDCore.Functions.GetDutyCount(job)
    local count = 0
    for _, Player in pairs(INDCore.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                count += 1
            end
        end
    end
    return count
end

-- Routing buckets (Only touch if you know what you are doing)

---Returns the objects related to buckets, first returned value is the player buckets, second one is entity buckets
---@return table, table
function INDCore.Functions.GetBucketObjects()
    return INDCore.Player_Buckets, INDCore.Entity_Buckets
end

---Will set the provided player id / source into the provided bucket id
---@param source any
---@param bucket any
---@return boolean
function INDCore.Functions.SetPlayerBucket(source, bucket)
    if source and bucket then
        local plicense = INDCore.Functions.GetIdentifier(source, 'license')
        SetPlayerRoutingBucket(source, bucket)
        INDCore.Player_Buckets[plicense] = {id = source, bucket = bucket}
        return true
    else
        return false
    end
end

---Will set any entity into the provided bucket, for example peds / vehicles / props / etc.
---@param entity number
---@param bucket number
---@return boolean
function INDCore.Functions.SetEntityBucket(entity, bucket)
    if entity and bucket then
        SetEntityRoutingBucket(entity, bucket)
        INDCore.Entity_Buckets[entity] = {id = entity, bucket = bucket}
        return true
    else
        return false
    end
end

---Will return an array of all the player ids inside the current bucket
---@param bucket number
---@return table|boolean
function INDCore.Functions.GetPlayersInBucket(bucket)
    local curr_bucket_pool = {}
    if INDCore.Player_Buckets and next(INDCore.Player_Buckets) then
        for _, v in pairs(INDCore.Player_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

---Will return an array of all the entities inside the current bucket
---(not for player entities, use GetPlayersInBucket for that)
---@param bucket number
---@return table|boolean
function INDCore.Functions.GetEntitiesInBucket(bucket)
    local curr_bucket_pool = {}
    if INDCore.Entity_Buckets and next(INDCore.Entity_Buckets) then
        for _, v in pairs(INDCore.Entity_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

---Server side vehicle creation with optional callback
---the CreateVehicle RPC still uses the client for creation so players must be near
---@param source any
---@param model any
---@param coords vector
---@param warp boolean
---@return number
function INDCore.Functions.SpawnVehicle(source, model, coords, warp)
    local ped = GetPlayerPed(source)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(ped) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then
        while GetVehiclePedIsIn(ped) ~= veh do
            Wait(0)
            TaskWarpPedIntoVehicle(ped, veh, -1)
        end
    end
    while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
    return veh
end

---Server side vehicle creation with optional callback
---the CreateAutomobile native is still experimental but doesn't use client for creation
---doesn't work for all vehicles!
---comment
---@param source any
---@param model any
---@param coords vector
---@param warp boolean
---@return number
function INDCore.Functions.CreateAutomobile(source, model, coords, warp)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local heading = coords.w and coords.w or 0.0
    local CreateAutomobile = `CREATE_AUTOMOBILE`
    local veh = Citizen.InvokeNative(CreateAutomobile, model, coords, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    return veh
end

--- New & more reliable server side native for creating vehicles
---comment
---@param source any
---@param model any
---@param vehtype any
-- The appropriate vehicle type for the model info.
-- Can be one of automobile, bike, boat, heli, plane, submarine, trailer, and (potentially), train.
-- This should be the same type as the type field in vehicles.meta.
---@param coords vector
---@param warp boolean
---@return number
function INDCore.Functions.CreateVehicle(source, model, vehtype, coords, warp)
    model = type(model) == 'string' and joaat(model) or model
    vehtype = type(vehtype) == 'string' and tostring(vehtype) or vehtype
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicleServerSetter(model, vehtype, coords, heading)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    return veh
end

---Paychecks (standalone - don't touch)
function PaycheckInterval()
    if next(INDCore.Players) then
        for _, Player in pairs(INDCore.Players) do
            if Player then
                local payment = INDShared.Jobs[Player.PlayerData.job.name]['grades'][tostring(Player.PlayerData.job.grade.level)].payment
                if not payment then payment = Player.PlayerData.job.payment end
                if Player.PlayerData.job and payment > 0 and (INDShared.Jobs[Player.PlayerData.job.name].offDutyPay or Player.PlayerData.job.onduty) then
                    if INDCore.Config.Money.PayCheckSociety then
                        local account = exports['IND-management']:GetAccount(Player.PlayerData.job.name)
                        if account ~= 0 then -- Checks if player is employed by a society
                            if account < payment then -- Checks if company has enough money to pay society
                                TriggerClientEvent('INDCore:Notify', Player.PlayerData.source, Lang:t('error.company_too_poor'), 'error')
                            else
                                Player.Functions.AddMoney('bank', payment, 'paycheck')
                                exports['IND-management']:RemoveMoney(Player.PlayerData.job.name, payment)
                                TriggerClientEvent('INDCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                            end
                        else
                            Player.Functions.AddMoney('bank', payment, 'paycheck')
                            TriggerClientEvent('INDCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                        end
                    else
                        Player.Functions.AddMoney('bank', payment, 'paycheck')
                        TriggerClientEvent('INDCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                    end
                end
            end
        end
    end
    SetTimeout(INDCore.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckInterval)
end

-- Callback Functions --

---Trigger Client Callback
---@param name string
---@param source any
---@param cb function
---@param ... any
function INDCore.Functions.TriggerClientCallback(name, source, cb, ...)
    INDCore.ClientCallbacks[name] = cb
    TriggerClientEvent('INDCore:Client:TriggerClientCallback', source, name, ...)
end

---Create Server Callback
---@param name string
---@param cb function
function INDCore.Functions.CreateCallback(name, cb)
    INDCore.ServerCallbacks[name] = cb
end

---Trigger Serv er Callback
---@param name string
---@param source any
---@param cb function
---@param ... any
function INDCore.Functions.TriggerCallback(name, source, cb, ...)
    if not INDCore.ServerCallbacks[name] then return end
    INDCore.ServerCallbacks[name](source, cb, ...)
end

-- Items

---Create a usable item
---@param item string
---@param data function
function INDCore.Functions.CreateUseableItem(item, data)
    INDCore.UsableItems[item] = data
end

---Checks if the given item is usable
---@param item string
---@return any
function INDCore.Functions.CanUseItem(item)
    return INDCore.UsableItems[item]
end

---Use item
---@param source any
---@param item string
function INDCore.Functions.UseItem(source, item)
    if GetResourceState('IND-inventory') == 'missing' then return end
    exports['IND-inventory']:UseItem(source, item)
end

---Kick Player
---@param source any
---@param reason string
---@param setKickReason boolean
---@param deferrals boolean
function INDCore.Functions.Kick(source, reason, setKickReason, deferrals)
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. INDCore.Config.Server.Discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if source then
            DropPlayer(source, reason)
        end
        for _ = 0, 4 do
            while true do
                if source then
                    if GetPlayerPing(source) >= 0 then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(source, reason)
                    end)
                end
            end
            Wait(5000)
        end
    end)
end

---Check if player is whitelisted, kept like this for backwards compatibility or future plans
---@param source any
---@return boolean
function INDCore.Functions.IsWhitelisted(source)
    if not INDCore.Config.Server.Whitelist then return true end
    if INDCore.Functions.HasPermission(source, INDCore.Config.Server.WhitelistPermission) then return true end
    return false
end

-- Setting & Removing Permissions

---Add permission for player
---@param source any
---@param permission string
function INDCore.Functions.AddPermission(source, permission)
    if not IsPlayerAceAllowed(source, permission) then
        ExecuteCommand(('add_principal player.%s qbcore.%s'):format(source, permission))
        INDCore.Commands.Refresh(source)
    end
end

---Remove permission from player
---@param source any
---@param permission string
function INDCore.Functions.RemovePermission(source, permission)
    if permission then
        if IsPlayerAceAllowed(source, permission) then
            ExecuteCommand(('remove_principal player.%s qbcore.%s'):format(source, permission))
            INDCore.Commands.Refresh(source)
        end
    else
        for _, v in pairs(INDCore.Config.Server.Permissions) do
            if IsPlayerAceAllowed(source, v) then
                ExecuteCommand(('remove_principal player.%s qbcore.%s'):format(source, v))
                INDCore.Commands.Refresh(source)
            end
        end
    end
end

-- Checking for Permission Level

---Check if player has permission
---@param source any
---@param permission string
---@return boolean
function INDCore.Functions.HasPermission(source, permission)
    if type(permission) == "string" then
        if IsPlayerAceAllowed(source, permission) then return true end
    elseif type(permission) == "table" then
        for _, permLevel in pairs(permission) do
            if IsPlayerAceAllowed(source, permLevel) then return true end
        end
    end

    return false
end

---Get the players permissions
---@param source any
---@return table
function INDCore.Functions.GetPermission(source)
    local src = source
    local perms = {}
    for _, v in pairs (INDCore.Config.Server.Permissions) do
        if IsPlayerAceAllowed(src, v) then
            perms[v] = true
        end
    end
    return perms
end

---Get admin messages opt-in state for player
---@param source any
---@return boolean
function INDCore.Functions.IsOptin(source)
    local license = INDCore.Functions.GetIdentifier(source, 'license')
    if not license or not INDCore.Functions.HasPermission(source, 'admin') then return false end
    local Player = INDCore.Functions.GetPlayer(source)
    return Player.PlayerData.optin
end

---Toggle opt-in to admin messages
---@param source any
function INDCore.Functions.ToggleOptin(source)
    local license = INDCore.Functions.GetIdentifier(source, 'license')
    if not license or not INDCore.Functions.HasPermission(source, 'admin') then return end
    local Player = INDCore.Functions.GetPlayer(source)
    Player.PlayerData.optin = not Player.PlayerData.optin
    Player.Functions.SetPlayerData('optin', Player.PlayerData.optin)
end

---Check if player is banned
---@param source any
---@return boolean, string?
function INDCore.Functions.IsPlayerBanned(source)
    local plicense = INDCore.Functions.GetIdentifier(source, 'license')
    local result = MySQL.single.await('SELECT * FROM bans WHERE license = ?', { plicense })
    if not result then return false end
    if os.time() < result.expire then
        local timeTable = os.date('*t', tonumber(result.expire))
        return true, 'You have been banned from the server:\n' .. result.reason .. '\nYour ban expires ' .. timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min .. '\n'
    else
        MySQL.query('DELETE FROM bans WHERE id = ?', { result.id })
    end
    return false
end

---Check for duplicate license
---@param license any
---@return boolean
function INDCore.Functions.IsLicenseInUse(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local identifiers = GetPlayerIdentifiers(player)
        for _, id in pairs(identifiers) do
            if string.find(id, 'license') then
                if id == license then
                    return true
                end
            end
        end
    end
    return false
end

-- Utility functions

---Check if a player has an item [deprecated]
---@param source any
---@param items table|string
---@param amount number
---@return boolean
function INDCore.Functions.HasItem(source, items, amount)
    if GetResourceState('IND-inventory') == 'missing' then return end
    return exports['IND-inventory']:HasItem(source, items, amount)
end

---Notify
---@param source any
---@param text string
---@param type string
---@param length number
function INDCore.Functions.Notify(source, text, type, length)
    TriggerClientEvent('INDCore:Notify', source, text, type, length)
end

---???? ... ok
---@param source any
---@param data any
---@param pattern any
---@return boolean
function INDCore.Functions.PrepForSQL(source, data, pattern)
    data = tostring(data)
    local src = source
    local player = INDCore.Functions.GetPlayer(src)
    local result = string.match(data, pattern)
    if not result or string.len(result) ~= string.len(data)  then
        TriggerEvent('IND-log:server:CreateLog', 'anticheat', 'SQL Exploit Attempted', 'red', string.format('%s attempted to exploit SQL!', player.PlayerData.license))
        return false
    end
    return true
end
