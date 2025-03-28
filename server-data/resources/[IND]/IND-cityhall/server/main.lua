local INDCore = exports['IND-core']:GetCoreObject()
local availableJobs = {}

if not INDCore.Shared.INDJobsStatus then
    availableJobs = Config.AvailableJobs
end

-- Exports

local function AddCityJob(jobName, toCH)
    if availableJobs[jobName] then return false, "already added" end
    availableJobs[jobName] = {
        ["label"] = toCH.label,
        ["isManaged"] = toCH.isManaged
    }
    return true, "success"
end

exports('AddCityJob', AddCityJob)

-- Functions

local function giveStarterItems()
    local Player = INDCore.Functions.GetPlayer(source)
    if not Player then return end
    for _, v in pairs(INDCore.Shared.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "Class C Driver License"
        end
        Player.Functions.AddItem(v.item, 1, nil, info)
    end
end

-- Callbacks

INDCore.Functions.CreateCallback('IND-cityhall:server:receiveJobs', function(_, cb)
    cb(availableJobs)
end)

-- Events

RegisterNetEvent('IND-cityhall:server:requestId', function(item, hall)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    if not Player then return end
    local itemInfo = Config.Cityhalls[hall].licenses[item]
    if not Player.Functions.RemoveMoney("cash", itemInfo.cost) then return TriggerClientEvent('INDCore:Notify', src, ('You don\'t have enough money on you, you need %s cash'):format(itemInfo.cost), 'error') end
    local info = {}
    if item == "id_card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif item == "driver_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "Class C Driver License"
    elseif item == "weaponlicense" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
    else
        return false -- DropPlayer(src, 'Attempted exploit abuse')
    end
    if not Player.Functions.AddItem(item, 1, nil, info) then return end
    TriggerClientEvent('inventory:client:ItemBox', src, INDCore.Shared.Items[item], 'add')
end)

RegisterNetEvent('IND-cityhall:server:sendDriverTest', function(instructors)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    if not Player then return end
    for i = 1, #instructors do
        local citizenid = instructors[i]
        local SchoolPlayer = INDCore.Functions.GetPlayerByCitizenId(citizenid)
        if SchoolPlayer then
            TriggerClientEvent("IND-cityhall:client:sendDriverEmail", SchoolPlayer.PlayerData.source, Player.PlayerData.charinfo)
        else
            local mailData = {
                sender = "Township",
                subject = "Driving lessons request",
                message = "Hello,<br><br>We have just received a message that someone wants to take driving lessons.<br>If you are willing to teach, please contact them:<br>Name: <strong>" .. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. "<br />Phone Number: <strong>" .. Player.PlayerData.charinfo.phone .. "</strong><br><br>Kind regards,<br>Township Los Santos",
                button = {}
            }
            exports["IND-phone"]:sendNewMailToOffline(citizenid, mailData)
        end
    end
    TriggerClientEvent('INDCore:Notify', src, "An email has been sent to driving schools, and you will be contacted automatically", "success", 5000)
end)

RegisterNetEvent('IND-cityhall:server:ApplyJob', function(job, cityhallCoords)
    local src = source
    local Player = INDCore.Functions.GetPlayer(src)
    if not Player then return end
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)

    local data = {
        ["src"] = src,
        ["job"] = job
    }
    if #(pedCoords - cityhallCoords) >= 20.0 or not availableJobs[job] then
        return false -- DropPlayer(source, "Attempted exploit abuse")
    end
    if INDCore.Shared.INDJobsStatus then
        exports["IND-jobs"]:submitApplication(data, "Jobs")
    else
        local JobInfo = INDCore.Shared.Jobs[job]
        Player.Functions.SetJob(data.job, 0)
        TriggerClientEvent('INDCore:Notify', data.src, Lang:t('info.new_job', { job = JobInfo.label }))
    end
end)

RegisterNetEvent('IND-cityhall:server:getIDs', giveStarterItems)

RegisterNetEvent('INDCore:Client:UpdateObject', function()
    INDCore = exports['IND-core']:GetCoreObject()
end)

-- Commands

INDCore.Commands.Add("drivinglicense", "Give a drivers license to someone", { { "id", "ID of a person" } }, true, function(source, args)
    local Player = INDCore.Functions.GetPlayer(source)
    local SearchedPlayer = INDCore.Functions.GetPlayer(tonumber(args[1]))
    if SearchedPlayer then
        if not SearchedPlayer.PlayerData.metadata["licences"]["driver"] then
            for i = 1, #Config.DrivingSchools do
                for id = 1, #Config.DrivingSchools[i].instructors do
                    if Config.DrivingSchools[i].instructors[id] == Player.PlayerData.citizenid then
                        SearchedPlayer.PlayerData.metadata["licences"]["driver"] = true
                        SearchedPlayer.Functions.SetMetaData("licences", SearchedPlayer.PlayerData.metadata["licences"])
                        TriggerClientEvent('INDCore:Notify', SearchedPlayer.PlayerData.source, "You have passed! Pick up your drivers license at the town hall", "success", 5000)
                        TriggerClientEvent('INDCore:Notify', source, ("Player with ID %s has been granted access to a driving license"):format(SearchedPlayer.PlayerData.source), "success", 5000)
                        break
                    end
                end
            end
        else
            TriggerClientEvent('INDCore:Notify', source, "Can't give permission for a drivers license, this person already has permission", "error")
        end
    else
        TriggerClientEvent('INDCore:Notify', source, "Player Not Online", "error")
    end
end)
