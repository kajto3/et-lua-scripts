function dolua(params)

	
	local fd,len = et.trap_FS_FOpenFile( "kmod+/misc/mute.dat", et.FS_READ )
	et.trap_FS_FCloseFile( fd )
	if (len <= 0) then
		et.G_Print("^3unmute: no mutes defined \n")
		return
	end

	local name
	local guid
	local expires
	local muter

	local i = 1
	

	if (params["slot"] == "console") then

		if ( params[1] ~= nil ) then
		
			local client = tonumber(params[1])
			if client == nil then -- its a player's name
				s,e=string.find(params[1], params[1])
				e = e or 0
				if e <= 2 then
					et.G_Print("^3Unmute^w: ^fPlayer name requires more than 2 characters\n" )
				else
					client = getPlayernameToId(params[1])
				end
			end
			-- either a slot or the victim doesnt exist
			if client ~= nil then
				if global_players_table[client] == nil then
					et.G_Print("^3Unmute^w: " .. params[1] .. "^f is not on the server!\n")
					return
				end
				local muted = et.gentity_get(client, "sess.muted")
				local name = et.gentity_get(client,"pers.netname")
				if (muted == 0) then
					et.G_Print("^3Unmute^w: ^1" ..name.. " ^fis not muted\n" )
				else
		
					local client_guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( client ), "cl_guid" ))


					
					fd,len = et.trap_FS_FOpenFile( "kmod+/misc/mute.dat", et.FS_READ )
					local filestr = et.trap_FS_Read( fd, len )
					et.trap_FS_FCloseFile( fd )
					-- done reading, parse the mute list, and re-write back all mutes *exept* the specified mute
					fd,len = et.trap_FS_FOpenFile( "kmod+/misc/mute.dat", et.FS_WRITE )
					for name,guid,expires,muter in string.gfind(filestr, "%s*\%[mute%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*expires%s*=%s*(%d+)%s*muter%s*=%s*([^%\n]*)%s*") do
						if (guid == client_guid) then 
							et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref unmute " .. client)
							et.G_Print("^3Unmute^w: ^1" ..name.. " ^fhas been unmuted\n" )
							et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3Unmute^w: ^1" ..name.. " ^fhas been unmuted" ))
						else -- copy the ban back to the mute list
						
							local mute = "\n"
							mute = mute .. "[mute]" .. "\n"
							mute = mute .. "name	= " .. name .. "\n"
							mute = mute .. "guid	= " .. guid .. "\n"
							mute = mute .. "expires	= " .. expires .. "\n"
							mute = mute .. "muter	= " .. muter .. "\n"
							if ( len > -1 ) then
								et.trap_FS_Write( mute, string.len(mute) ,fd )
							end
							
						end
						i=i+1
					end
					et.trap_FS_FCloseFile( fd )
					load_mutes()
				end
				
			else
				et.G_Print("^3Unmute^w: " .. params[1] .. "^f is not on the server!\n")
			end
		else
			et.G_Print("^fUnmute - usage^w:^f !unmute [name|slot]\n")
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
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"],"^3Unmute^w: ^fPlayer name requires more than 2 characters" ))
			else
				client = getPlayernameToId(params[1])
			end
		end
		-- either a slot or the victim doesnt exist
		if client ~= nil then
			if global_players_table[client] == nil then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Unmute^w: " .. params[1] .. "^f is not on the server!"))
				return
			end
			local name = et.gentity_get(client,"pers.netname")
			if AdminUserLevel(params["slot"]) >= AdminUserLevel(client) then
				local muted = et.gentity_get(client, "sess.muted")
				if (muted == 0) then
					et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Unmute^w: ^1" ..name.. " ^fis not muted" ))
				else



					local client_guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( client ), "cl_guid" ))

					local k_mute = tonumber(et.trap_Cvar_Get("k_mute"))
					local bit = bitflag(k_mute,32)
					if bit[16] == 1 then -- dont allow lower/same level admins to unmute the player as long as the muter-admin connected
						local admin_guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( params["slot"] ), "cl_guid" ))
						if global_mute_table[client_guid]["muter_guid"] ~= admin_guid then
							local muter = ismuteron(global_mute_table[client_guid]["muter_guid"])
							if  muter ~= -1 then	
								muter = et.gentity_get(muter,"pers.netname")
								et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Unmute^w: ^fonly " .. muter .. "^f can unmute " .. name))
								return
							end
						end
					end

					fd,len = et.trap_FS_FOpenFile( "kmod+/misc/mute.dat", et.FS_READ )
					local filestr = et.trap_FS_Read( fd, len )
					et.trap_FS_FCloseFile( fd )
					-- done reading, parse the mute list, and re-write back all mutes *exept* the specified mute

					fd,len = et.trap_FS_FOpenFile( "kmod+/misc/mute.dat", et.FS_WRITE )
					
					for name,guid,expires,muter in string.gfind(filestr, "%s*\%[mute%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*expires%s*=%s*(%d+)%s*muter%s*=%s*([^%\n]*)%s*") do
						if (guid == client_guid) then 
							et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref unmute " .. client)
							et.trap_SendServerCommand(-1, string.format('%s \"%s"\n',params["say"],"^3Unmute^w: ^1" ..name.. " ^fhas been unmuted" ))
						else -- copy the ban back to the mute list
						
							local mute = "\n"
							mute = mute .. "[mute]" .. "\n"
							mute = mute .. "name	= " .. name .. "\n"
							mute = mute .. "guid	= " .. guid .. "\n"
							mute = mute .. "expires	= " .. expires .. "\n"
							mute = mute .. "muter	= " .. muter .. "\n"
							if ( len > -1 ) then
								et.trap_FS_Write( mute, string.len(mute) ,fd )
							end
							
						end
						
						i=i+1
					end
					et.trap_FS_FCloseFile( fd )
					load_mutes()

				end
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Unmute^w: ^fcannot target a higher level"))
			end
		
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Unmute^w: " .. params[1] .. "^f is not on the server!"))
		end
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^fUnmute - usage^w:^f !unmute [name|slot]"))
	end	

	return 1
end

