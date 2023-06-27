fx_version 'cerulean'
game 'gta5'

description 'IND-Apartments'
version '2.2.1'

shared_scripts {
    'config.lua',
    '@IND-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
}

dependencies {
    'IND-core',
    'IND-interior',
    'IND-clothing',
    'IND-weathersync',
}

lua54 'yes'