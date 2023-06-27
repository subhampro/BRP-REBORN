if Config.Framework ~= 'IND-core' then return end

local framework = 'IND-core'
local state = GetResourceState(framework)

if state == 'missing' or state == "unknown" then
    -- Framework can't be used if it's missing or unknown
    return
end

local INDCore = exports['IND-core']:GetCoreObject()

-- https://github.com/qbcore-framework/dpemotes/blob/master/Server/Server.lua#L101-L141
INDCore.Commands.Add('e', 'Play an emote', {{ name="emotename", help="dance, camera, sit or any valid emote."}}, true, function(source, args)
    TriggerClientEvent('animations:client:PlayEmote', source, args)
end)

INDCore.Commands.Add('emote', 'Play an emote', {{ name="emotename", help="dance, camera, sit or any valid emote."}}, true, function(source, args)
    TriggerClientEvent('animations:client:PlayEmote', source, args)
end)

if Config.SqlKeybinding then
    INDCore.Commands.Add('emotebind', 'Bind an emote', {{ name="key", help="num4, num5, num6, num7. num8, num9. Numpad 4-9!"}, { name="emotename", help="dance, camera, sit or any valid emote."}}, true, function(source, args)
        TriggerClientEvent('animations:client:BindEmote', source, args)
    end)

    INDCore.Commands.Add('emotebinds', 'Check your currently bound emotes.', {}, false, function(source)
        TriggerClientEvent('animations:client:EmoteBinds', source)
    end)
end

INDCore.Commands.Add('emotemenu', 'Open rpemotes menu (F3) by default.', {}, false, function(source)
    TriggerClientEvent('animations:client:EmoteMenu', source)
end)

INDCore.Commands.Add('em', 'Open rpemotes menu (F3) by default.', {}, false, function(source)
    TriggerClientEvent('animations:client:EmoteMenu', source)
end)

INDCore.Commands.Add('emotes', 'List available emotes.', {}, false, function(source)
    TriggerClientEvent('animations:client:ListEmotes', source)
end)

INDCore.Commands.Add('walk', 'Set your walkingstyle.', {{ name="style", help="/walks for a list of valid styles"}}, true, function(source, args)
    TriggerClientEvent('animations:client:Walk', source, args)
end)

INDCore.Commands.Add('walks', 'List available walking styles.', {}, false, function(source)
    TriggerClientEvent('animations:client:ListWalks', source)
end)

INDCore.Commands.Add('nearby', 'Share emote with a nearby player.', {{ name="emotename", help="hug, handshake, bro or any valid shared emote."}}, true, function(source, args)
    TriggerClientEvent('animations:client:Nearby', source, args)
end)