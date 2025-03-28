fx_version 'cerulean'
game 'gta5'

description 'IND-Houses'
version '2.2.0'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    '@IND-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_scripts {
    'client/main.lua',
    'client/decorate.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    'html/index.html',
    'html/reset.css',
    'html/style.css',
    'html/script.js',
    'html/img/dynasty8-logo.png'
}

dependencies {
    'IND-core',
    'IND-interior',
    'IND-clothing',
    'IND-weathersync'
}

lua54 'yes'
