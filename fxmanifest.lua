fx_version 'cerulean'
game 'gta5'

shared_script 'Config/config.lua'

server_scripts {
    "Server/**.*",
    "Config/serverConfig.lua"
}

client_scripts {
    "Client/**.*"
}

ui_page 'html/index.html'

files {
    'html/*.*'
}