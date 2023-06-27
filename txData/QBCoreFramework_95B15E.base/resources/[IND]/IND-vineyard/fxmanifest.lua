fx_version 'cerulean'
game 'gta5'

description 'IND-Vineyard'
version '1.2.0'

shared_scripts {
    '@IND-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

server_script 'server.lua'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client.lua'
}

dependencies {
    'IND-core',
    'PolyZone'
}

lua54 'yes'
