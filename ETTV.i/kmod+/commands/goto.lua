function dolua(params)


	COMMAND = "goto"
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR

	if (params["slot"] == "console" ) then
		return -- console cannot iwant
	end


	if tonumber(et.trap_Cvar_Get("k_mod")) ~= nil then
		if tonumber(et.trap_Cvar_Get("k_mod")) ~= MOD_TRICKJUMP then
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING.."unknown command " .. COMMAND)) 
			return
		end
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING.."unknown command " .. COMMAND)) 
		return
	end

	if ( params[1] ~= nil ) then
	
		local client = tonumber(params[1])
		if client == nil then -- its a player's name
			s,e=string.find(params[1], params[1])
			e = e or 0
			if e <= 2 then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING.."Player name requires more than 2 characters" ))
			else
				client = getPlayernameToId(params[1])
			end
		end
		-- either a slot or the victim doesnt exist
		if client ~= nil then
			if global_players_table[client] == nil then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING .. params[1] ..COMMAND_COLOR.." is not on the server!^7"))
				return
			end
			local name = et.gentity_get(client,"pers.netname")
			if AdminUserLevel(params["slot"]) >= AdminUserLevel(client) then

				if params["slot"] == client then
					et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],HEADING.."you cannot goto yourself!" ))
					return
				end
				if et.gentity_get(params["slot"],"sess.sessionTeam") >= 3 or et.gentity_get(params["slot"],"sess.sessionTeam") < 1 then
					et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],HEADING.."you must be on a team!" ))
					return
				end
				if et.gentity_get(client,"sess.sessionTeam") >= 3 or et.gentity_get(client,"sess.sessionTeam") < 1 then
					et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],HEADING.."player must be on a team!" ))
					return
				end



				local command = "goto"
				local trick_jump_mod = findVMslot("TJmod")
				if trick_jump_mod == nil then
					et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],CHEADING.."trick jump module isn't runing on this server!" ))
					et.G_LogPrint("K_ERROR: COMMAND - iwant: trick jump module isn't runing on this server!\n")
					return
				end
				local ok = et.IPCSend(trick_jump_mod, string.format("%s %d %d", command, params["slot"], client ))
				if ok ~= 1 then --(==0)
					et.G_LogPrint("K_ERROR: COMMAND - iwant: cross Trick jump - KMOD+ problem !\n")
					return
				end


				et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],HEADING.."you have been moved to ^1" ..name ))
			
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING.."cannot target a higher level"))
			end			
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING.." is not on the server!^7"))
		end
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],COMMAND_COLOR .. COMMAND.. " - usage^w:" ..COMMAND_COLOR.." !".. COMMAND.." [name|slot]"))
	end	
end

