function dolua(params)
	if (params["slot"] == "console" ) then
		if ( params[1] ~= nil ) then
			local lock = string.lower(params[1])
			if  lock == "teams" or lock == "t" then
				et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref unlock") 
				et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Unlock^w: ^fboth teams are unlocked!" ))
			elseif lock == "spec" or lock == "s" then
				et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref specunlock") 
				et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Unlock^w: ^fspectators team is unlocked!" ))
			elseif lock == "all" then
				et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref unlock") 
				et.trap_SendConsoleCommand(et.EXEC_INSERT , "ref specunlock") 
				et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Unlock^w: ^fall teams are unlocked!" ))
			else
				et.G_Print("^3Unlock^w: ^funknown team ^1" .. lock .."\n")
			end
		else	
			et.G_Print("^3Unlock - usage^w: ^f!unlock [t|s|all]\n")
		end
	return
	end


	--if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	--end

	if ( params[1] ~= nil ) then
		local lock = string.lower(params[1])
		if  lock == "teams" or lock == "t" then
			et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref unlock") 
			et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Unlock^w: ^fboth teams are unlocked!" ))
		elseif lock == "spec" or lock == "s" then
			et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref specunlock") 
			et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Unlock^w: ^fspectators team is unlocked!" ))
		elseif lock == "all" then
			et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref unlock") 
			et.trap_SendConsoleCommand(et.EXEC_INSERT , "ref specunlock") 
			et.trap_SendServerCommand(-1 , string.format('%s \"%s"',params["say"],"^3Unlock^w: ^fall teams are unlocked!" ))
		else
			et.trap_SendServerCommand(params["slot"] , string.format('%s \"%s"',params["say"],"^3Unlock^w: ^funknown team ^1" .. lock ))
		end
	else	
		et.trap_SendServerCommand(params["slot"] , string.format('%s \"%s"',params["say"],"^3Unlock - usage^w: ^f!unlock [t|s|all]"))
	end

	return 1
end