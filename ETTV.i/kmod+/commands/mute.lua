function dolua(params)

	local fd, len = et.trap_FS_FOpenFile('kmod+/misc/mute.dat', et.FS_APPEND )
	if len == -1 then -- file does not exist
		fd, len = et.trap_FS_FOpenFile('kmod+/misc/mute.dat', et.FS_WRITE )
		if len == -1 then
			et.G_Print("K_ERROR: unable to open/create mute.dat\n")
			return
		end
	end
	et.trap_FS_FCloseFile( fd )

	if (params["slot"] == "console" ) then
		if ( params[1] ~= nil ) then
		
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
					et.G_Print("^3Mute^w: " .. params[1] .. "^f is not on the server!^7\n")
					return
				end
				local name = et.gentity_get(client,"pers.netname")
				local muted = et.gentity_get(client, "sess.muted")
				if (muted == 1) then
					et.G_Print("^3Mute^w: ^1" ..name.. " ^fis already muted\n" )
				else
					local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( client ), "cl_guid" ))
					local expires = 0
					local muter = params["slot"] -- "console"
					if tonumber(params[2]) ~= nil then
						expires = os.time() + tonumber(params[2])
					end
						
					fd, len = et.trap_FS_FOpenFile( 'kmod+/misc/mute.dat', et.FS_APPEND ) 
					local mute = "\n"
					mute = mute .. "[mute]" .. "\n"
					mute = mute .. "name	= " .. name .. "\n"
					mute = mute .. "guid	= " .. guid .. "\n"
					mute = mute .. "expires	= " .. expires .. "\n"
					mute = mute .. "muter	= " .. muter .. "\n"
					if ( len > -1 ) then
						et.trap_FS_Write( mute, string.len(mute) ,fd )
					end
					et.trap_FS_FCloseFile( fd )
					load_mutes()

					--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute " .. client .. "\n" )
					et.gentity_set(client, "sess.muted", MOD["MUTE"])
					et.G_Print("^3Mute^w: ^1" ..name.. " ^fhas been muted\n" )
					et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3Mute^w: ^1" ..name.. " ^fhas been muted\n" ))
				end
					
			else
				et.G_Print("^3Mute^w: " .. params[1] .. "^f is not on the server!^7\n")
			end
		else
			et.G_Print("^fMute - usage^w:^f !mute [name|slot]\n")
		end
	return
	end



	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

	if ( params[1] ~= nil ) then
	
		local client = tonumber(params[1])
		if client == nil then -- its a player's name
			s,e=string.find(params[1], params[1])
			e = e or 0
			if e <= 2 then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"],"^3Mute^w: ^fPlayer name requires more than 2 characters" ))
			else
				client = getPlayernameToId(params[1])
			end
		end
		-- either a slot or the victim doesnt exist
		if client ~= nil then
			if global_players_table[client] == nil then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Mute^w: " .. params[1] .. "^f is not on the server!^7"))
				return 1
			end
			local name = et.gentity_get(client,"pers.netname")
			if AdminUserLevel(params["slot"]) >= AdminUserLevel(client) then
				local ref = tonumber(et.gentity_get(client,"sess.referee"))
				if (ref ~= 0) then
					et.trap_SendServerCommand( params["slot"] , string.format('%s \"%s"\n',params["say"],"^3Mute^w: ^fcannot mute a referee" ))
					return 1
				end
				local muted = et.gentity_get(client, "sess.muted")
				if (muted == 1) then
					et.trap_SendServerCommand( params["slot"] , string.format('%s \"%s"\n',params["say"],"^3Mute^w: ^1" ..name.. " ^fis already muted" ))
				else


					local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( client ), "cl_guid" ))
					local expires = 0
					local muter = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( params["slot"] ), "cl_guid" )) 
					if tonumber(params[2]) ~= nil then
						expires = os.time() + tonumber(params[2])
					end
						
					fd, len = et.trap_FS_FOpenFile( 'kmod+/misc/mute.dat', et.FS_APPEND ) 
					local mute = "\n"
					mute = mute .. "[mute]" .. "\n"
					mute = mute .. "name	= " .. name .. "\n"
					mute = mute .. "guid	= " .. guid .. "\n"
					mute = mute .. "expires	= " .. expires .. "\n"
					mute = mute .. "muter	= " .. muter .. "\n"
					if ( len > -1 ) then
						et.trap_FS_Write( mute, string.len(mute) ,fd )
					end
					et.trap_FS_FCloseFile( fd )
					load_mutes()

					--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute " .. client .. "\n" )
					et.gentity_set(client, "sess.muted", MOD["MUTE"])
					et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3Mute^w: ^1" ..name.. " ^fhas been muted" ))
				end
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Mute^w: ^fcannot target a higher level"))
			end			
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Mute^w: " .. params[1] .. "^f is not on the server!^7"))
		end
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^fMute - usage^w:^f !mute [name|slot]"))
	end	
	return 1
end

