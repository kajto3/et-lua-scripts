function dolua(params)
	
	if params.slot ~= CONSOLE then
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end

	et.trap_SendConsoleCommand( et.EXEC_APPEND, "exec kmod+/kmod+.cfg" )
	loadlevels()
	loadspreerecord()
	loadmapspreerecord()
	loadAdmins()
	loadbanners()
	load_mutes()
	et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^:(^3#reloading config done^:)" ))

	return 1
end