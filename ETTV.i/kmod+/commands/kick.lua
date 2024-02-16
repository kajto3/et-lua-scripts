function dolua(params)
	--et.G_Print("hello\n") 
	
	if (params["slot"] == "console") then
		if ( params[1] ~= nil ) then
		
			local client = tonumber(params[1])
			if client == nil then -- its a player's name
				s,e=string.find(params[1], params[1])
				e = e or 0
				if e <= 2 then
					et.G_Print("^3Kick^w: ^fPlayer name requires more than 2 characters\n" )
					return
				else
					client = getPlayernameToId(params[1])
				end
			end
			-- either a slot or the victim doesnt exist
			if client ~= nil then
				if global_players_table[client] == nil then
					et.G_Print("^3kick^w: " .. params[1] .. "^f is not on the server!^7\n")
					return
				end
				local name = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
				--time = tonumber(params[2])
				i = 2 
				time =  2 -- default kick time
				reason = ""
				while (params[i] ~= nil) do
					reason = reason .. params[i] .. " "
					i = i + 1
				end
				if (reason == "") then
					reason = "Kicked By Admin"
				end
				
				if et.trap_Cvar_Get( "sv_punkbuster" ) == 1 then
					local client = client + 1 -- pb counts from 1, and not 0
					et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. client .. " " .. time .. " reason: " ..  reason)
				else
					et.trap_DropClient( client, "You have been kicked! reason: "..reason.."", 1 )
				end
				-- announce the player has been kicked!
				et.trap_SendServerCommand( -1 , params.say.." \"^3kick^w: " .. name .. " ^fhas been kicked. reason: ".. reason )
				et.trap_SendServerCommand( -1 , "cpm \"^3kick^w: " .. name .. " ^fhas been kicked. reason: ".. reason )
			else
				et.G_Print("^3kick^w: " .. params[1] .. "^f is not on the server!^7\n")
				return
			end
		else
			et.G_Print("^fkick - usage^w:^f !kick [name|slot] [reason]\n")
		end


	return
	end 


	-- normal user
	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)	
	if ( params[1] ~= nil ) then
	
		local client = tonumber(params[1])
		if client == nil then -- its a player's name
			s,e=string.find(params[1], params[1])
			e = e or 0
			if e <= 2 then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"],"^3Kick^w: ^fPlayer name requires more than 2 characters" ))
				return 1
			else
				client = getPlayernameToId(params[1])
			end
		end
		-- either a slot or the victim doesnt exist
		if client ~= nil then
		
			if global_players_table[client] == nil then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Kick^w: " .. params[1] .. "^f is not on the server!"))
				return 1
			end
			if AdminUserLevel(params["slot"]) < AdminUserLevel(client) then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Kick^w: ^fcannot target higher level"))
				return 1
			end
			local name = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
			time = tonumber(params[2])
			i = 2
			time =  2 -- default kick time
			reason = ""
			reason = ""
			while (params[i] ~= nil) do
				reason = reason .. params[i] .. " "
				i = i + 1
			end
			if (reason == "") then
				if level_flag(AdminUserLevel(params.slot), "6") == nil then
					et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^3Kick^w:^f you must specify a reason!^7"))
					return 1
				else
					reason = "Kicked By Admin"
				end
			end
			
			if et.trap_Cvar_Get( "sv_punkbuster" ) == 1 then
				local client = client + 1 -- pb counts from 1, and not 0
				et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. client .. " " .. time .. " reason: " ..  reason) 
			else
				et.trap_DropClient( client, "You have been kicked! reason: "..reason.."", 1 )
			end
			-- announce the player has been kicked!
			et.trap_SendServerCommand( -1 , params.say.." \"^3kick^w: " .. name .. " ^fhas been kicked. reason: ".. reason )
			et.trap_SendServerCommand( -1 , "cpm \"^3kick^w: " .. name .. " ^fhas been kicked. reason: ".. reason )
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^3kick^w: " .. params[1] .. "^f is not on the server!"))
			return 1
		end
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^fkick - usage^w:^f !kick [name|slot] [reason]"))
	end	
	return 1
end