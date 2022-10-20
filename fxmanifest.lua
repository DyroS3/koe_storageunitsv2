fx_version 'adamant'

game 'gta5'

version '1.0.0'
lua54 'yes'

client_scripts {
	'client.lua',
	'config.lua'
 }
 
 server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
	'config.lua'
 }

 escrow_ignore {
	'client.lua',
	'config.lua',
	'server.lua',
  }

 shared_script '@ox_lib/init.lua'
 shared_script '@es_extended/imports.lua'