fx_version 'cerulean'
game 'gta5'

description 'IND-VehicleFailure'
version '1.2.2'

shared_scripts {
    '@IND-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

lua54 'yes'
