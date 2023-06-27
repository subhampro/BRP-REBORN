fx_version 'cerulean'
game 'gta5'

description 'IND-HouseRobbery'
version '1.2.0'

shared_scripts {
    'config.lua',
    '@IND-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_script 'client/main.lua'
server_script 'server/main.lua'

dependencies {
    'IND-lockpick',
    'IND-skillbar'
}

lua54 'yes'
