local INDCore = exports['IND-core']:GetCoreObject()
local PlayerJob = INDCore.Functions.GetPlayerData().job
local shownBossMenu = false
local DynamicMenuItems = {}

-- UTIL
local function CloseMenuFull()
    exports['IND-menu']:closeMenu()
    exports['IND-core']:HideText()
    shownBossMenu = false
end

local function comma_value(amount)
    local formatted = amount
    while true do
        local k
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

local function AddBossMenuItem(data, id)
    local menuID = id or (#DynamicMenuItems + 1)
    DynamicMenuItems[menuID] = deepcopy(data)
    return menuID
end

exports("AddBossMenuItem", AddBossMenuItem)

local function RemoveBossMenuItem(id)
    DynamicMenuItems[id] = nil
end

exports("RemoveBossMenuItem", RemoveBossMenuItem)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = INDCore.Functions.GetPlayerData().job
    end
end)

RegisterNetEvent('INDCore:Client:OnPlayerLoaded', function()
    PlayerJob = INDCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('INDCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('IND-bossmenu:client:OpenMenu', function()
    if not PlayerJob.name or not PlayerJob.isboss then return end

    local bossMenu = {
        {
            header = Lang:t("headers.bsm").. string.upper(PlayerJob.label),
            icon = "fa-solid fa-circle-info",
            isMenuHeader = true,
        },
        {
            header = Lang:t("body.manage"),
            txt = Lang:t("body.managed"),
            icon = "fa-solid fa-list",
            params = {
                event = "IND-bossmenu:client:employeelist",
            }
        },
        {
            header = Lang:t("body.hire"),
            txt = Lang:t("body.hired"),
            icon = "fa-solid fa-hand-holding",
            params = {
                event = "IND-bossmenu:client:HireMenu",
            }
        },
        {
            header = Lang:t("body.storage"),
            txt = Lang:t("body.storaged"),
            icon = "fa-solid fa-box-open",
            params = {
                event = "IND-bossmenu:client:Stash",
            }
        },
        {
            header = Lang:t("body.outfits"),
            txt = Lang:t("body.outfitsd"),
            icon = "fa-solid fa-shirt",
            params = {
                event = "IND-bossmenu:client:Wardrobe",
            }
        },
        {
            header = Lang:t("body.money"),
            txt = Lang:t("body.moneyd"),
            icon = "fa-solid fa-sack-dollar",
            params = {
                event = "IND-bossmenu:client:SocietyMenu",
            }
        },
    }

    for _, v in pairs(DynamicMenuItems) do
        bossMenu[#bossMenu + 1] = v
    end

    bossMenu[#bossMenu + 1] = {
        header = Lang:t("body.exit"),
        icon = "fa-solid fa-angle-left",
        params = {
            event = "IND-menu:closeMenu",
        }
    }

    exports['IND-menu']:openMenu(bossMenu)
end)

RegisterNetEvent('IND-bossmenu:client:employeelist', function()
    local EmployeesMenu = {
        {
            header = Lang:t("body.mempl").. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
        },
    }
    INDCore.Functions.TriggerCallback('IND-bossmenu:server:GetEmployees', function(cb)
        for _, v in pairs(cb) do
            EmployeesMenu[#EmployeesMenu + 1] = {
                header = v.name,
                txt = v.grade.name,
                icon = "fa-solid fa-circle-user",
                params = {
                    event = "IND-bossmenu:client:ManageEmployee",
                    args = {
                        player = v,
                        work = PlayerJob
                    }
                }
            }
        end
        EmployeesMenu[#EmployeesMenu + 1] = {
            header = Lang:t("body.return"),
            icon = "fa-solid fa-angle-left",
            params = {
                event = "IND-bossmenu:client:OpenMenu",
            }
        }
        exports['IND-menu']:openMenu(EmployeesMenu)
    end, PlayerJob.name)
end)

RegisterNetEvent('IND-bossmenu:client:ManageEmployee', function(data)
    local EmployeeMenu = {
        {
            header = Lang:t("body.mngpl").. data.player.name .. " - " .. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info"
        },
    }
    for k, v in pairs(INDCore.Shared.Jobs[data.work.name].grades) do
        EmployeeMenu[#EmployeeMenu + 1] = {
            header = v.name,
            txt =  Lang:t("body.grade") .. k,
            params = {
                isServer = true,
                event = "IND-bossmenu:server:GradeUpdate",
                icon = "fa-solid fa-file-pen",
                args = {
                    cid = data.player.empSource,
                    grade = tonumber(k),
                    gradename = v.name
                }
            }
        }
    end
    EmployeeMenu[#EmployeeMenu + 1] = {
        header = Lang:t("body.fireemp"),
        icon = "fa-solid fa-user-large-slash",
        params = {
            isServer = true,
            event = "IND-bossmenu:server:FireEmployee",
            args = data.player.empSource
        }
    }
    EmployeeMenu[#EmployeeMenu + 1] = {
        header = Lang:t("body.return"),
        icon = "fa-solid fa-angle-left",
        params = {
            event = "IND-bossmenu:client:OpenMenu",
        }
    }
    exports['IND-menu']:openMenu(EmployeeMenu)
end)

RegisterNetEvent('IND-bossmenu:client:Stash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "boss_" .. PlayerJob.name, {
        maxweight = 4000000,
        slots = 25,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "boss_" .. PlayerJob.name)
end)

RegisterNetEvent('IND-bossmenu:client:Wardrobe', function()
    TriggerEvent('IND-clothing:client:openOutfitMenu')
end)

RegisterNetEvent('IND-bossmenu:client:HireMenu', function()
    local HireMenu = {
        {
            header = Lang:t("body.hireemp").. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
        },
    }
    INDCore.Functions.TriggerCallback('IND-bossmenu:getplayers', function(players)
        for _, v in pairs(players) do
            if v and v ~= PlayerId() then
                HireMenu[#HireMenu + 1] = {
                    header = v.name,
                    txt = Lang:t("body.cid").. v.citizenid .. " - ID: " .. v.sourceplayer,
                    icon = "fa-solid fa-user-check",
                    params = {
                        isServer = true,
                        event = "IND-bossmenu:server:HireEmployee",
                        args = v.sourceplayer
                    }
                }
            end
        end
        HireMenu[#HireMenu + 1] = {
            header = Lang:t("body.return"),
            icon = "fa-solid fa-angle-left",
            params = {
                event = "IND-bossmenu:client:OpenMenu",
            }
        }
        exports['IND-menu']:openMenu(HireMenu)
    end)
end)

RegisterNetEvent('IND-bossmenu:client:SocietyMenu', function()
    INDCore.Functions.TriggerCallback('IND-bossmenu:server:GetAccount', function(cb)
        local SocietyMenu = {
            {
                header = Lang:t("body.balance").. comma_value(cb) .. " - " .. string.upper(PlayerJob.label),
                isMenuHeader = true,
                icon = "fa-solid fa-circle-info",
            },
            {
                header = Lang:t("body.deposit"),
                icon = "fa-solid fa-money-bill-transfer",
                txt = Lang:t("body.depositd"),
                params = {
                    event = "IND-bossmenu:client:SocetyDeposit",
                    args = comma_value(cb)
                }
            },
            {
                header = Lang:t("body.withdraw"),
                icon = "fa-solid fa-money-bill-transfer",
                txt = Lang:t("body.withdrawd"),
                params = {
                    event = "IND-bossmenu:client:SocetyWithDraw",
                    args = comma_value(cb)
                }
            },
            {
                header = Lang:t("body.return"),
                icon = "fa-solid fa-angle-left",
                params = {
                    event = "IND-bossmenu:client:OpenMenu",
                }
            },
        }
        exports['IND-menu']:openMenu(SocietyMenu)
    end, PlayerJob.name)
end)

RegisterNetEvent('IND-bossmenu:client:SocetyDeposit', function(money)
    local deposit = exports['IND-input']:ShowInput({
        header = Lang:t("body.depositm").. money,
        submitText = Lang:t("body.submit"),
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = Lang:t("body.amount")
            }
        }
    })
    if deposit then
        if not deposit.amount then return end
        TriggerServerEvent("IND-bossmenu:server:depositMoney", tonumber(deposit.amount))
    end
end)

RegisterNetEvent('IND-bossmenu:client:SocetyWithDraw', function(money)
    local withdraw = exports['IND-input']:ShowInput({
        header = Lang:t("body.withdrawm").. money,
        submitText = Lang:t("body.submit"),
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = Lang:t("body.amount")
            }
        }
    })
    if withdraw then
        if not withdraw.amount then return end
        TriggerServerEvent("IND-bossmenu:server:withdrawMoney", tonumber(withdraw.amount))
    end
end)

-- MAIN THREAD
CreateThread(function()
    if Config.UseTarget then
        for job, zones in pairs(Config.BossMenuZones) do
            for index, data in ipairs(zones) do
                exports['IND-target']:AddBoxZone(job.."-BossMenu-"..index, data.coords, data.length, data.width, {
                    name = job.."-BossMenu-"..index,
                    heading = data.heading,
                    -- debugPoly = true,
                    minZ = data.minZ,
                    maxZ = data.maxZ,
                }, {
                    options = {
                        {
                            type = "client",
                            event = "IND-bossmenu:client:OpenMenu",
                            icon = "fas fa-sign-in-alt",
                            label = Lang:t("target.label"),
                            canInteract = function() return job == PlayerJob.name and PlayerJob.isboss end,
                        },
                    },
                    distance = 2.5
                })
            end
        end
    else
        while true do
            local wait = 2500
            local pos = GetEntityCoords(PlayerPedId())
            local inRangeBoss = false
            local nearBossmenu = false
            if PlayerJob then
                wait = 0
                for k, menus in pairs(Config.BossMenus) do
                    for _, coords in ipairs(menus) do
                        if k == PlayerJob.name and PlayerJob.isboss then
                            if #(pos - coords) < 5.0 then
                                inRangeBoss = true
                                if #(pos - coords) <= 1.5 then
                                    nearBossmenu = true
                                    if not shownBossMenu then
                                        exports['IND-core']:DrawText(Lang:t("drawtext.label"), 'left')
                                        shownBossMenu = true
                                    end
                                    if IsControlJustReleased(0, 38) then
                                        exports['IND-core']:HideText()
                                        TriggerEvent("IND-bossmenu:client:OpenMenu")
                                    end
                                end

                                if not nearBossmenu and shownBossMenu then
                                    CloseMenuFull()
                                    shownBossMenu = false
                                end
                            end
                        end
                    end
                end
                if not inRangeBoss then
                    Wait(1500)
                    if shownBossMenu then
                        CloseMenuFull()
                        shownBossMenu = false
                    end
                end
            end
            Wait(wait)
        end
    end
end)
