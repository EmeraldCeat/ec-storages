fx_version 'cerulean';
game 'gta5';
lua54 'yes';

author 'gadget2 & emeraldceat';
description 'Storage units for FiveM';
version '1.0.0';

client_script {
    'core/client.lua',
    'modules/**/client.lua'
};

server_script {
    '@oxmysql/lib/MySQL.lua',
    'core/server.lua',
    'modules/**/server.lua'
};

shared_script {
    '@ox_lib/init.lua',
    'core/config.lua'
};
dependency 'ox_lib';