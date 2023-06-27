fx_version 'cerulean'
game 'gta5'

description 'IND-Weed'
version '1.2.0'

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

client_script 'client/main.lua'

lua54 'yes'
