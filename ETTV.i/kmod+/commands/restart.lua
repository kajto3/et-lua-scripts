function dolua(params)

	if params.slot ~= "console" then
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end

	et.trap_SendConsoleCommand( et.EXEC_APPEND, "reset_match" )
	et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3restart^w: ^frestarting map..."))

	return 1
end

