function dolua(params)

	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end

	et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref shuffleteamsxp_norestart" )
	et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3shuffle^w: ^fteams has been shuffled!"))
	return 1
end

