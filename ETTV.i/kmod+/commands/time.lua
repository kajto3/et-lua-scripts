-- !time
function dolua(params) 

	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end

	local time = os.date("%I:%M:%S%p")
	et.trap_SendServerCommand( params.slot, params.say.." \"^3The server time is " ..time.. "^7\"" )

	return 1
end