Config = {}
-- Config.Interior = vector3(-814.89, 181.95, 76.85) -- Interior to load where characters are previewed
Config.Interior = vector4(-622.9, 53.98, 97.6, 91.91)
-- Config.DefaultSpawn = vector3(-1035.71, -2731.87, 12.86) -- Default spawn coords if you have start apartments disabled
-- Config.PedCoords = vector4(-626.07, 53.6, 97.6, 274.41) -- Create preview ped at these coordinates
-- Config.HiddenCoords = vector4(-600.9, 53.98, 97.6, 97.6) -- Hides your actual ped while you are in selection
-- Config.CamCoords = vector4(-622.9, 53.98, 97.6, 97.6) -- Camera coordinates for character preview screen

-- HHFW

Config.PedCoords = vector4(142.0, -2203.5, 4.69, 358.65)
Config.HiddenCoords = vector4(146.15, -2199.86, 4.69, 178.24)
Config.CamCoords = vector4(141.80, -2199.0, 4.69, 180.24)


Config.EnableDeleteButton = true -- Define if the player can delete the character or not
Config.customNationality = false -- Defines if Nationality input is custom of blocked to the list of Countries

Config.DefaultNumberOfCharacters = 5 -- Define maximum amount of default characters (maximum 5 characters defined by default)
Config.PlayersNumberOfCharacters = { -- Define maximum amount of player characters by rockstar license (you can find this license in your server's database in the player table)
    { license = "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", numberOfChars = 2 },
}