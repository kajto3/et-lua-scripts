-- TODO: check if the client is already on the team he's supposed to be, and dont move him (post error message: client is already on TEAM)
function dolua(params)
	if (params["slot"] == "console" ) then

		if ( params[1] ~= nil and params[2] ~= nil ) then
		
			local client = tonumber(params[1])
			if client == nil then -- its a player's name
				s,e=string.find(params[1], params[1])
				e = e or 0
				if e <= 2 then
					et.G_Print("^3Mute^w: ^fPlayer name requires more than 2 characters" )
				else
					client = getPlayernameToId(params[1])
				end
			end
			-- either a slot or the victim doesnt exist
			if client ~= nil then
				if global_players_table[client] == nil then
					et.G_Print("^3Putteam^w: " .. params[1] .. "^f is not on the server!^7")
					return
				end
				local command = ""
				local fullteam = ""
				if ( params[2] == "r" or params[2] == "axis" ) then
					command = "putaxis"
					fullteam = "axis"
				elseif ( params[2] == "b" or params[2] == "allies" ) then
					command = "putallies"
					fullteam = "allies"
				elseif ( params[2] == "s" or params[2] == "spec" ) then
					command = "remove"
					fullteam = "spectators"
				else
					et.G_Print("^3Putteam^w: unknown team ^1" ..params[2])
					return
				end
				local name = et.gentity_get(client,"pers.netname")
				et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref " .. command .. " ".. client)
				et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3Putteam^w: ^1" ..name.. " ^fjoined the " .. fullteam))
			
			else
				et.G_Print("^3Putteam^w: " .. params[1] .. "^f is not on the server!^7")
			end
		else
			et.G_Print("^fPutteam - usage^w:^f !putteam [name|slot] [b|r|s]")
		end	
	return
	end



	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	if ( params[1] ~= nil and params[2] ~= nil ) then
		local client = tonumber(params[1])
		if client == nil then -- its a player's name
			s,e=string.find(params[1], params[1])
			e = e or 0
			if e <= 2 then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"],"^3Putteam^w: ^fPlayer name requires more than 2 characters" ))
			else
				client = getPlayernameToId(params[1])
			end
		end
		-- either a slot or the victim doesnt exist
		if client ~= nil then
			if global_players_table[client] == nil then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Putteam^w: " .. params[1] .. "^f is not on the server!^7"))
				return 1
			end
			local command = ""
			local fullteam = ""
			if ( params[2] == "r" or params[2] == "axis" ) then
				command = "putaxis"
				fullteam = "axis"
			elseif ( params[2] == "b" or params[2] == "allies" ) then
				command = "putallies"
				fullteam = "allies"
			elseif ( params[2] == "s" or params[2] == "spec" ) then
				command = "remove"
				fullteam = "spectators"
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Putteam^w: unknown team ^1" ..params[2]))
				return 1
			end
			local name = et.gentity_get(client,"pers.netname")
			if AdminUserLevel(params["slot"]) >= AdminUserLevel(client) then
				et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref " .. command .. " ".. client)
				et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3Putteam^w: ^1" ..name.. " ^fjoined the " .. fullteam))
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Putteam^w: ^fcannot target a higher level"))
			end
		
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Putteam^w: " .. params[1] .. "^f is not on the server!^7"))
		end
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^fPutteam - usage^w:^f !putteam [name|slot] [b|r|s]"))
	end	
	return 1


end