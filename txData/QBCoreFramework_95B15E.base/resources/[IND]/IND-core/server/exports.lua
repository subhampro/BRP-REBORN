-- Add or change (a) method(s) in the INDCore.Functions table
local function SetMethod(methodName, handler)
    if type(methodName) ~= "string" then
        return false, "invalid_method_name"
    end

    INDCore.Functions[methodName] = handler

    TriggerEvent('INDCore:Server:UpdateObject')

    return true, "success"
end

INDCore.Functions.SetMethod = SetMethod
exports("SetMethod", SetMethod)

-- Add or change (a) field(s) in the INDCore table
local function SetField(fieldName, data)
    if type(fieldName) ~= "string" then
        return false, "invalid_field_name"
    end

    INDCore[fieldName] = data

    TriggerEvent('INDCore:Server:UpdateObject')

    return true, "success"
end

INDCore.Functions.SetField = SetField
exports("SetField", SetField)

-- Single add job function which should only be used if you planning on adding a single job
local function AddJob(jobName, job)
    if type(jobName) ~= "string" then
        return false, "invalid_job_name"
    end

    if INDCore.Shared.Jobs[jobName] then
        return false, "job_exists"
    end

    INDCore.Shared.Jobs[jobName] = job

    TriggerClientEvent('INDCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, "success"
end

INDCore.Functions.AddJob = AddJob
exports('AddJob', AddJob)

-- Multiple Add Jobs
local function AddJobs(jobs)
    local shouldContinue = true
    local message = "success"
    local errorItem = nil

    for key, value in pairs(jobs) do
        if type(key) ~= "string" then
            message = 'invalid_job_name'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        if INDCore.Shared.Jobs[key] then
            message = 'job_exists'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        INDCore.Shared.Jobs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('INDCore:Client:OnSharedUpdateMultiple', -1, 'Jobs', jobs)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, message, nil
end

INDCore.Functions.AddJobs = AddJobs
exports('AddJobs', AddJobs)

-- Single Remove Job
local function RemoveJob(jobName)
    if type(jobName) ~= "string" then
        return false, "invalid_job_name"
    end

    if not INDCore.Shared.Jobs[jobName] then
        return false, "job_not_exists"
    end

    INDCore.Shared.Jobs[jobName] = nil

    TriggerClientEvent('INDCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, nil)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, "success"
end

INDCore.Functions.RemoveJob = RemoveJob
exports('RemoveJob', RemoveJob)

-- Single Update Job
local function UpdateJob(jobName, job)
    if type(jobName) ~= "string" then
        return false, "invalid_job_name"
    end

    if not INDCore.Shared.Jobs[jobName] then
        return false, "job_not_exists"
    end

    INDCore.Shared.Jobs[jobName] = job

    TriggerClientEvent('INDCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, "success"
end

INDCore.Functions.UpdateJob = UpdateJob
exports('UpdateJob', UpdateJob)

-- Single add item
local function AddItem(itemName, item)
    if type(itemName) ~= "string" then
        return false, "invalid_item_name"
    end

    if INDCore.Shared.Items[itemName] then
        return false, "item_exists"
    end

    INDCore.Shared.Items[itemName] = item

    TriggerClientEvent('INDCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, "success"
end

INDCore.Functions.AddItem = AddItem
exports('AddItem', AddItem)

-- Single update item
local function UpdateItem(itemName, item)
    if type(itemName) ~= "string" then
        return false, "invalid_item_name"
    end
    if not INDCore.Shared.Items[itemName] then
        return false, "item_not_exists"
    end
    INDCore.Shared.Items[itemName] = item
    TriggerClientEvent('INDCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, "success"
end

INDCore.Functions.UpdateItem = UpdateItem
exports('UpdateItem', UpdateItem)

-- Multiple Add Items
local function AddItems(items)
    local shouldContinue = true
    local message = "success"
    local errorItem = nil

    for key, value in pairs(items) do
        if type(key) ~= "string" then
            message = "invalid_item_name"
            shouldContinue = false
            errorItem = items[key]
            break
        end

        if INDCore.Shared.Items[key] then
            message = "item_exists"
            shouldContinue = false
            errorItem = items[key]
            break
        end

        INDCore.Shared.Items[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('INDCore:Client:OnSharedUpdateMultiple', -1, 'Items', items)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, message, nil
end

INDCore.Functions.AddItems = AddItems
exports('AddItems', AddItems)

-- Single Remove Item
local function RemoveItem(itemName)
    if type(itemName) ~= "string" then
        return false, "invalid_item_name"
    end

    if not INDCore.Shared.Items[itemName] then
        return false, "item_not_exists"
    end

    INDCore.Shared.Items[itemName] = nil

    TriggerClientEvent('INDCore:Client:OnSharedUpdate', -1, 'Items', itemName, nil)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, "success"
end

INDCore.Functions.RemoveItem = RemoveItem
exports('RemoveItem', RemoveItem)

-- Single Add Gang
local function AddGang(gangName, gang)
    if type(gangName) ~= "string" then
        return false, "invalid_gang_name"
    end

    if INDCore.Shared.Gangs[gangName] then
        return false, "gang_exists"
    end

    INDCore.Shared.Gangs[gangName] = gang

    TriggerClientEvent('INDCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, "success"
end

INDCore.Functions.AddGang = AddGang
exports('AddGang', AddGang)

-- Multiple Add Gangs
local function AddGangs(gangs)
    local shouldContinue = true
    local message = "success"
    local errorItem = nil

    for key, value in pairs(gangs) do
        if type(key) ~= "string" then
            message = "invalid_gang_name"
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        if INDCore.Shared.Gangs[key] then
            message = "gang_exists"
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        INDCore.Shared.Gangs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('INDCore:Client:OnSharedUpdateMultiple', -1, 'Gangs', gangs)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, message, nil
end

INDCore.Functions.AddGangs = AddGangs
exports('AddGangs', AddGangs)

-- Single Remove Gang
local function RemoveGang(gangName)
    if type(gangName) ~= "string" then
        return false, "invalid_gang_name"
    end

    if not INDCore.Shared.Gangs[gangName] then
        return false, "gang_not_exists"
    end

    INDCore.Shared.Gangs[gangName] = nil

    TriggerClientEvent('INDCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, nil)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, "success"
end

INDCore.Functions.RemoveGang = RemoveGang
exports('RemoveGang', RemoveGang)

-- Single Update Gang
local function UpdateGang(gangName, gang)
    if type(gangName) ~= "string" then
        return false, "invalid_gang_name"
    end

    if not INDCore.Shared.Gangs[gangName] then
        return false, "gang_not_exists"
    end

    INDCore.Shared.Gangs[gangName] = gang

    TriggerClientEvent('INDCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('INDCore:Server:UpdateObject')
    return true, "success"
end

INDCore.Functions.UpdateGang = UpdateGang
exports('UpdateGang', UpdateGang)

local function GetCoreVersion(InvokingResource)
    local resourceVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
    if InvokingResource and InvokingResource ~= '' then
        print(("%s called qbcore version check: %s"):format(InvokingResource or 'Unknown Resource', resourceVersion))
    end
    return resourceVersion
end

INDCore.Functions.GetCoreVersion = GetCoreVersion
exports('GetCoreVersion', GetCoreVersion)

local function ExploitBan(playerId, origin)
    local name = GetPlayerName(playerId)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        name,
        INDCore.Functions.GetIdentifier(playerId, 'license'),
        INDCore.Functions.GetIdentifier(playerId, 'discord'),
        INDCore.Functions.GetIdentifier(playerId, 'ip'),
        origin,
        2147483647,
        'Anti Cheat'
    })
    DropPlayer(playerId, Lang:t('info.exploit_banned', {discord = INDCore.Config.Server.Discord}))
    TriggerEvent("IND-log:server:CreateLog", "anticheat", "Anti-Cheat", "red", name .. " has been banned for exploiting " .. origin, true)
end

exports('ExploitBan', ExploitBan)
