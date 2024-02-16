function dolua(params)
	if (params["slot"] == "console" ) then
		if ( params[1] ~= nil ) then
			local lock = string.lower(params[1])
			if  lock == "teams" or lock == "t" then
				et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref lock") 
				et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Lock^w: ^fboth teams are locked!" ))
			elseif lock == "spec" or lock == "s" then
				et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref speclock") 
				et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Lock^w: ^fspectators team is locked!" ))
			elseif lock == "all" then
				et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref lock") 
				et.trap_SendConsoleCommand(et.EXEC_INSERT , "ref speclock") 
				et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Lock^w: ^fall teams are locked!" ))
			else
				et.G_Print("^3Lock^w: ^funknown team ^1" .. lock .."\n")
			end
		else	
			et.G_Print("^3Lock - usage^w: ^f!lock [t|s|all]\n")
		end
	return
	end


	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

	if ( params[1] ~= nil ) then
		local lock = string.lower(params[1])
		if  lock == "teams" or lock == "t" then
			et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref lock") 
			et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Lock^w: ^fboth teams are locked!" ))
		elseif lock == "spec" or lock == "s" then
			et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref speclock") 
			et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Lock^w: ^fspectators team is locked!" ))
		elseif lock == "all" then
			et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref lock") 
			et.trap_SendConsoleCommand(et.EXEC_INSERT , "ref speclock") 
			et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Lock^w: ^fall teams are locked!" ))
		else
			et.trap_SendServerCommand(params["slot"] , string.format('%s \"%s"',params["say"],"^3Lock^w: ^funknown team ^1" .. lock ))
		end
	else	
		et.trap_SendServerCommand(params["slot"] , string.format('%s \"%s"',params["say"],"^3Lock - usage^w: ^f!lock [t|s|all]"))
	end
	
	return 1
end