resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'



description 'Bharat Occasions'

client_script {
	'Config.lua',
    'client/client.lua'
	
}

server_script {
	'Config.lua',
    'server/server.lua'
    
}


client_script "@IND-anticheat/acloader.lua"