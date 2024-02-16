function dolua(params) 
	COMMAND = "makeshout"
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR

	if (params["slot"] == "console") then -- rcon command
		if ( params[1] ~= nil ) then
			local PlayerID = tonumber(params[1])
			if PlayerID == nil then -- its a player's name
				s,e=string.find(params[1], params[1])
				e = e or 0
				if e <= 2 then
					et.G_Print(HEADING .. "Player name requires more than 2 characters\n" )
				else
					PlayerID = getPlayernameToId(params[1])
				end
			end
			if PlayerID ~= nil then -- either a number or the victim doesnt exist
				if global_players_table[PlayerID] == nil then
					et.G_Print(HEADING .. params[1] .. "^f is not on the server!^7\n")
					return
				end
				--local GUID = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "cl_guid" ))
				local name = et.gentity_get(PlayerID,"pers.netname")
				if name ~= "" and name ~= nil then
						et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref makeshoutcaster " .. PlayerID) 
						et.G_Print(HEADING .. name ..COMMAND_COLOR .. " is now a Shoutcaster\n" )
				end
			else
				et.G_Print(HEADING .. params[1] .. COMMAND_COLOR.. " is not on the server!^7\n")
			end
		else
			et.G_Print(COMMAND_COLOR .. COMMAND .. " - usage^w: " .. COMMAND_COLOR .. "!" .. COMMAND .. " [name|slot] \n")
		end
	return
	end


	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	if ( params[1] ~= nil ) then
		local PlayerID = tonumber(params[1])
		if PlayerID == nil then
			s,e=string.find(params[1], params[1])
			e = e or 0
			if e <= 2 then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING .. "Player name requires more than 2 characters\n" ))
				PlayerID = nil
			else
				PlayerID = getPlayernameToId(params[1])
			end
		end
		if PlayerID ~= nil then
			if global_players_table[PlayerID] == nil then
				et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s\"',params["say"],HEADING  .. params[1] .. COMMAND_COLOR .. " is not on the server!^7"))
				return 1
			end 
			--local GUID = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "cl_guid" ))
			local name = et.gentity_get(PlayerID,"pers.netname")
			if name ~= "" and name ~= nil then
					local shout = tonumber(et.Info_ValueForKey(et.trap_GetConfigstring(et.CS_PLAYERS + PlayerID), "sc"))
					if shout == 0 then
						et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref makeshoutcaster " .. PlayerID) 
						et.trap_SendServerCommand(-1 , string.format('%s \"%s"\n',params["say"],HEADING .. name .. COMMAND_COLOR .." is now a Shoutcaster"))
					else
						et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],HEADING .. name ..COMMAND_COLOR .." is already a Shoutcaster"))
					end
			end	
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],HEADING  .. params[1] .. COMMAND_COLOR .." is not on the server!^7"))
		end
	else
		--et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s"\n',params["say"],"^3Ref - usage^w:^f !ref [name|slot]"))
		--command executed on self
		local shout = tonumber(et.Info_ValueForKey(et.trap_GetConfigstring(et.CS_PLAYERS + params["slot"]), "sc"))
		if shout == 0 then
			et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref makeshoutcaster " .. params["slot"]) 
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],HEADING..  "you are now a Shoutcaster"))
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],HEADING .. "you are already a Shoutcaster"))
		end
	end
	return 1

end