INDConfig = {}

INDConfig.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- Gets max players from config file, default 48
INDConfig.DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0)
INDConfig.UpdateInterval = 5 -- how often to update player data in minutes
INDConfig.StatusInterval = 5000 -- how often to check hunger/thirst status in milliseconds

INDConfig.Money = {}
INDConfig.Money.MoneyTypes = { cash = 500, bank = 5000, crypto = 0 } -- type = startamount - Add or remove money types for your server (for ex. blackmoney = 0), remember once added it will not be removed from the database!
INDConfig.Money.DontAllowMinus = { 'cash', 'crypto' } -- Money that is not allowed going in minus
INDConfig.Money.PayCheckTimeOut = 10 -- The time in minutes that it will give the paycheck
INDConfig.Money.PayCheckSociety = false -- If true paycheck will come from the society account that the player is employed at, requires IND-management

INDConfig.Player = {}
INDConfig.Player.HungerRate = 4.2 -- Rate at which hunger goes down.
INDConfig.Player.ThirstRate = 3.8 -- Rate at which thirst goes down.
INDConfig.Player.Bloodtypes = {
    "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-",
}

INDConfig.Server = {} -- General server config
INDConfig.Server.Closed = false -- Set server closed (no one can join except people with ace permission 'qbadmin.join')
INDConfig.Server.ClosedReason = "Server Closed" -- Reason message to display when people can't join the server
INDConfig.Server.Uptime = 0 -- Time the server has been up.
INDConfig.Server.Whitelist = false -- Enable or disable whitelist on the server
INDConfig.Server.WhitelistPermission = 'admin' -- Permission that's able to enter the server when the whitelist is on
INDConfig.Server.PVP = true -- Enable or disable pvp on the server (Ability to shoot other players)
INDConfig.Server.Discord = "" -- Discord invite link
INDConfig.Server.CheckDuplicateLicense = true -- Check for duplicate rockstar license on join
INDConfig.Server.Permissions = { 'god', 'admin', 'mod' } -- Add as many groups as you want here after creating them in your server.cfg

INDConfig.Commands = {} -- Command Configuration
INDConfig.Commands.OOCColor = {255, 151, 133} -- RGB color code for the OOC command

INDConfig.Notify = {}

INDConfig.Notify.NotificationStyling = {
    group = false, -- Allow notifications to stack with a badge instead of repeating
    position = "right", -- top-left | top-right | bottom-left | bottom-right | top | bottom | left | right | center
    progress = true -- Display Progress Bar
}

-- These are how you define different notification variants
-- The "color" key is background of the notification
-- The "icon" key is the css-icon code, this project uses `Material Icons` & `Font Awesome`
INDConfig.Notify.VariantDefinitions = {
    success = {
        classes = 'success',
        icon = 'task_alt'
    },
    primary = {
        classes = 'primary',
        icon = 'notifications'
    },
    error = {
        classes = 'error',
        icon = 'warning'
    },
    police = {
        classes = 'police',
        icon = 'local_police'
    },
    ambulance = {
        classes = 'ambulance',
        icon = 'fas fa-ambulance'
    }
}