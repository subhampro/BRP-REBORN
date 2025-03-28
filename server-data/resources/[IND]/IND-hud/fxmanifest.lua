fx_version 'cerulean'
game 'gta5'

description 'IND-hud'
version '2.2.0'

shared_scripts {
    '@IND-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

ui_page 'html/index.html'

files {
    'html/*',
    'html/index.html',
    'html/styles.css',
    'html/responsive.css',
    'html/app.js',
}

lua54 'yes'
