-- !date
function dolua(params) 
	local date = os.date("%x %I:%M:%S%p")
	if (params.slot == "console") then
		et.G_Print("^:The server date is " ..date.. "^7\"" )
	else
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
		
		et.trap_SendServerCommand( params.slot, params.say.." \"^:The server date is " ..date.. "^7\"" )
		
		return 1
	end
end