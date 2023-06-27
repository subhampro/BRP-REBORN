local INDCore = exports['IND-core']:GetCoreObject()

local Races = {}

RegisterNetEvent('IND-streetraces:NewRace', function(RaceTable)
    local src = source
    local RaceId = math.random(1000, 9999)
    local xPlayer = INDCore.Functions.GetPlayer(src)
    if xPlayer.Functions.RemoveMoney('cash', RaceTable.amount, "streetrace-created") then
        Races[RaceId] = RaceTable
        Races[RaceId].creator = INDCore.Functions.GetIdentifier(src, 'license')
        Races[RaceId].joined[#Races[RaceId].joined+1] = INDCore.Functions.GetIdentifier(src, 'license')
        TriggerClientEvent('IND-streetraces:SetRace', -1, Races)
        TriggerClientEvent('IND-streetraces:SetRaceId', src, RaceId)
        TriggerClientEvent('INDCore:Notify', src, "You joind the race for €"..Races[RaceId].amount..",-", 'success')
    end
end)

RegisterNetEvent('IND-streetraces:RaceWon', function(RaceId)
    local src = source
    local xPlayer = INDCore.Functions.GetPlayer(src)
    xPlayer.Functions.AddMoney('cash', Races[RaceId].pot, "race-won")
    TriggerClientEvent('INDCore:Notify', src, "You won the race and €"..Races[RaceId].pot..",- recieved", 'success')
    TriggerClientEvent('IND-streetraces:SetRace', -1, Races)
    TriggerClientEvent('IND-streetraces:RaceDone', -1, RaceId, GetPlayerName(src))
end)

RegisterNetEvent('IND-streetraces:JoinRace', function(RaceId)
    local src = source
    local xPlayer = INDCore.Functions.GetPlayer(src)
    local zPlayer = INDCore.Functions.GetPlayer(Races[RaceId].creator)
    if zPlayer ~= nil then
        if xPlayer.PlayerData.money.cash >= Races[RaceId].amount then
            Races[RaceId].pot = Races[RaceId].pot + Races[RaceId].amount
            Races[RaceId].joined[#Races[RaceId].joined+1] = INDCore.Functions.GetIdentifier(src, 'license')
            if xPlayer.Functions.RemoveMoney('cash', Races[RaceId].amount, "streetrace-joined") then
                TriggerClientEvent('IND-streetraces:SetRace', -1, Races)
                TriggerClientEvent('IND-streetraces:SetRaceId', src, RaceId)
                TriggerClientEvent('INDCore:Notify', zPlayer.PlayerData.source, GetPlayerName(src).." Joined the race", 'primary')
            end
        else
            TriggerClientEvent('INDCore:Notify', src, "You dont have enough cash", 'error')
        end
    else
        TriggerClientEvent('INDCore:Notify', src, "The person wo made the race is offline!", 'error')
        Races[RaceId] = {}
    end
end)

INDCore.Commands.Add("createrace", "Start A Street Race", {{name="amount", help="The Stake Amount For The Race."}}, false, function(source, args)
    local src = source
    local amount = tonumber(args[1])
    if GetJoinedRace(INDCore.Functions.GetIdentifier(src, 'license')) == 0 then
        TriggerClientEvent('IND-streetraces:CreateRace', src, amount)
    else
        TriggerClientEvent('INDCore:Notify', src, "You Are Already In A Race", 'error')
    end
end)

INDCore.Commands.Add("stoprace", "Stop The Race You Created", {}, false, function(source, _)
    CancelRace(source)
end)

INDCore.Commands.Add("quitrace", "Get Out Of A Race. (You Will NOT Get Your Money Back!)", {}, false, function(source, _)
    local src = source
    local RaceId = GetJoinedRace(INDCore.Functions.GetIdentifier(src, 'license'))
    if RaceId ~= 0 then
        if GetCreatedRace(INDCore.Functions.GetIdentifier(src, 'license')) ~= RaceId then
            RemoveFromRace(INDCore.Functions.GetIdentifier(src, 'license'))
            TriggerClientEvent('INDCore:Notify', src, "You Have Stepped Out Of The Race! And You Lost Your Money", 'error')
        else
            TriggerClientEvent('INDCore:Notify', src, "/stoprace To Stop The Race", 'error')
        end
    else
        TriggerClientEvent('INDCore:Notify', src, "You Are Not In A Race ", 'error')
    end
end)

INDCore.Commands.Add("startrace", "Start The Race", {}, false, function(source)
    local src = source
    local RaceId = GetCreatedRace(INDCore.Functions.GetIdentifier(src, 'license'))

    if RaceId ~= 0 then

        Races[RaceId].started = true
        TriggerClientEvent('IND-streetraces:SetRace', -1, Races)
        TriggerClientEvent("IND-streetraces:StartRace", -1, RaceId)
    else
        TriggerClientEvent('INDCore:Notify', src, "You Have Not Started A Race", 'error')

    end
end)

function CancelRace(source)
    local RaceId = GetCreatedRace(INDCore.Functions.GetIdentifier(source, 'license'))
    local Player = INDCore.Functions.GetPlayer(source)

    if RaceId ~= 0 then
        for key in pairs(Races) do
            if Races[key] ~= nil and Races[key].creator == Player.PlayerData.license then
                if not Races[key].started then
                    for _, iden in pairs(Races[key].joined) do
                        local xdPlayer = INDCore.Functions.GetPlayer(iden)
                            xdPlayer.Functions.AddMoney('cash', Races[key].amount, "race-cancelled")
                            TriggerClientEvent('INDCore:Notify', xdPlayer.PlayerData.source, "Race Has Stopped, You Got Back $"..Races[key].amount.."", 'error')
                            TriggerClientEvent('IND-streetraces:StopRace', xdPlayer.PlayerData.source)
                            RemoveFromRace(iden)
                    end
                else
                    TriggerClientEvent('INDCore:Notify', Player.PlayerData.source, "The Race Has Already Started", 'error')
                end
                TriggerClientEvent('INDCore:Notify', source, "Race Stopped!", 'error')
                Races[key] = nil
            end
        end
        TriggerClientEvent('IND-streetraces:SetRace', -1, Races)
    else
        TriggerClientEvent('INDCore:Notify', source, "You Have Not Started A Race!", 'error')
    end
end

function RemoveFromRace(identifier)
    for key in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for i, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    table.remove(Races[key].joined, i)
                end
            end
        end
    end
end

function GetJoinedRace(identifier)
    for key in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for _, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    return key
                end
            end
        end
    end
    return 0
end

function GetCreatedRace(identifier)
    for key in pairs(Races) do
        if Races[key] ~= nil and Races[key].creator == identifier and not Races[key].started then
            return key
        end
    end
    return 0
end
