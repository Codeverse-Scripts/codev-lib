fx_version 'cerulean'
game 'gta5'
author 'CodeVerse'
description 'Library for CodeVerse scripts'
lua54 'yes'

shared_scripts {
    'shared/config.lua',
}

client_scripts {
    'client/main.lua',
    'client/functions.lua',
    'testing/t_client.lua',
    'shared/shared.lua',
}

server_scripts {
    'server/main.lua',
    'server/functions.lua',
    'testing/t_server.lua',
    'shared/shared.lua',
}

version '1.1'