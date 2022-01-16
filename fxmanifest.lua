fx_version 'cerulean'
games {'gta5'}

author 'Adzeepulse#7832'
description 'ap_createjob'
version '1.0.0'

client_scripts {
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}