function dolua(params)
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref nextmap" )
	--et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3nextmap^w: ^fnextmap has been loaded!"))
	
	
	--et.trap_SendConsoleCommand( et.EXEC_APPEND, "timelimit 1" )
	et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3nextmap^w: ^fnextmap has been loaded!"))
	--et.trap_SendConsoleCommand( et.EXEC_INSERT, "exec kmod+/commands/exec/nextmap.cfg" )
	et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref nextmap" )
	--et.trap_SendConsoleCommand( et.EXEC_INSERT, "start_match" )
	return 1
end

