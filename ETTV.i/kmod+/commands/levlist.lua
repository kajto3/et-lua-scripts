-- !levlist

function dolua(params) 

	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end

	et.trap_SendServerCommand( params.slot, params.say.." \"^:Level ^70 ^:(^3#Unknown^:) ^:Level ^71 ^:(^3#Registered^:) ^:Level ^72 ^:(^3#Advanced-user^:) ^:Level ^73 ^:(^3#Management^:) ^:Level ^74 ^:(^3#Administrator^:) ^:Level ^75 ^:(^3#Chief-Executive-Officer^:)\"" )

	return 1
end