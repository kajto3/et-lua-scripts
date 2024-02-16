function dolua(params) 
	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end

	if params[1] == nil then
		et.trap_SendServerCommand( params["slot"] , string.format('%s \"%s"\n',params["say"],"^3map^w: ^fyou must specify a map"))
	else
		et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3map^w: ^fchanging map to " .. params[1]))
		et.trap_SendConsoleCommand(et.EXEC_APPEND , "map " .. params[1] ) 
	end
	return 1
end