fx_version 'cerulean'
game 'gta5'

description 'IND-Drugs'
version '1.2.2'

shared_scripts{
    'config.lua',
    '@IND-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_scripts{
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/deliveries.lua',
    'client/cornerselling.lua'
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'server/deliveries.lua',
    'server/cornerselling.lua'
}

lua54 'yes'
