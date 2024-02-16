-- nil is needs to be executed if there's no command found
function dolua(params) 
	et.trap_SendServerCommand( params.slot, params.say.." \"^fUnknown command^7\"" )
end