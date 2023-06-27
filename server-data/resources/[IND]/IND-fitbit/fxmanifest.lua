fx_version 'cerulean'
game 'gta5'

description 'IND-FitBit'
version '1.2.0'

ui_page 'html/index.html'

shared_scripts {
    '@IND-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

server_script 'server/main.lua'
client_script 'client/main.lua'

files {
    'html/*'
}
