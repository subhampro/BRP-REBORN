fx_version 'cerulean'
game 'gta5'

description 'IND-Crypto'
version '1.2.1'

shared_scripts {
    '@IND-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
client_script 'client/main.lua'

dependency 'mhacking'

lua54 'yes'
