-- !ban necro 20 you suck!
function dolua(params)
	--et.G_Print("hello\n") 
	local fd, len = et.trap_FS_FOpenFile("kmod+/misc/banlist.dat", et.FS_APPEND )
	if len == -1 then -- file does not exist
		fd, len = et.trap_FS_FOpenFile("kmod+/misc/banlist.dat", et.FS_WRITE )
		if len == -1 then
			et.G_Print("K_ERROR: unable to open/create banlist.dat\n")
			return
		end
	end
	et.trap_FS_FCloseFile( fd )

	if (params["slot"] == "console") then
		if ( params[1] ~= nil ) then
		
			local client = tonumber(params[1])
			if client == nil then -- its a player's name
				s,e=string.find(params[1], params[1])
				e = e or 0
				if e <= 2 then
					et.G_Print("^3Ban^w: ^fPlayer name requires more than 2 characters\n" )
				else
					client = getPlayernameToId(params[1])
				end
			end
			-- either a slot or the victim doesnt exist
			if client ~= nil then
				if global_players_table[client] == nil then
					et.G_Print("^3Ban^w: " .. params[1] .. "^f is not on the server!^7")
					return
				end
				local guis = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "cl_guid" )
				local GUID = string.upper( guis )
				if (GUID == nil or GUID == "") then
					et.G_Print("^3Ban^w: " .. params[1] .. "^f is not on the server!^7")
					return
				end
				if GUID == "NO_GUID" then
					GUID = "NOGUID00000000000000000000000000"
				end
				local name = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
				ip = string.gsub(et.Info_ValueForKey( et.trap_GetUserinfo( client ), "ip" ), "%:%d+", "") -- gsub removed the :port from the ip
				local admin = "console"
				local ban = ""
				time = tonumber(params[2])
				if ( time ~= nil ) then -- its temp ban
					local i=3
					reason = ""
					while (params[i] ~= nil) do
						reason = reason .. params[i] .. " "
						i = i + 1
					end
					if (reason == "") then
						reason = "Banned By Admin"
					end
					-- time to ban, lets log the ban localy
					
					fd, len = et.trap_FS_FOpenFile( 'kmod+/misc/banlist.dat', et.FS_APPEND ) 
					
					ban = "\n"
					ban = ban .. "[ban]" .. "\n"
					ban = ban .. "name	= " .. name .. "\n"
					ban = ban .. "guid	= " .. GUID .. "\n"
					ban = ban .. "ip	= " .. ip .. "\n"
					ban = ban .. "reason	= " .. reason .. "\n"
					ban = ban .. "made	= " .. os.date("%x %H:%M") .. "\n"
					ban = ban .. "expires	= " .. (os.time() + time*60) .. "\n" -- ban time is in minutes (PB ban time is set in minutes)
					ban = ban .. "banner	= " .. admin .. "\n"

					if ( len > -1 ) then
						et.trap_FS_Write( ban, string.len(ban) ,fd )
					end
					et.trap_FS_FCloseFile( fd )
					loadtempbans()
					
					if et.trap_Cvar_Get( "sv_punkbuster" ) == 1 then
						local client = client + 1 -- pb counts from 1, and not 0
						et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. client .. " " .. time .. " reason: " ..  reason) 
						et.trap_SendConsoleCommand(et.EXEC_INSERT , "pb_sv_updbanfile" ) 
					else
						et.trap_DropClient( client, "You have been banned! reason: "..reason.." expire: "..(os.time() + time*60).."", (os.time() + time*60) )
					end
					
					et.G_Print("Ban: " .. name .. " " .. GUID .. " " .. admin .. " " .. reason .. "\n")
					-- announce the player has been banned!
					et.trap_SendServerCommand( -1 , params.say.." \"^fBan^w: " .. name .. " ^fhas been banned. reason: ".. reason )
					et.trap_SendServerCommand( -1 , string.format('%s \"%s"',"cpm","^fBan^w: " .. name .. " ^fhas been banned. reason: ".. reason ))

				else -- permenent ban
					
					local i=2
					reason = ""
					while (params[i] ~= nil) do
						reason = reason .. params[i] .. " "
						i = i + 1
					end
					if (reason == "") then
						reason = "Banned By Admin"
					end
					
					fd, len = et.trap_FS_FOpenFile( "kmod+/misc/banlist.dat", et.FS_APPEND )  
					-- time to ban, lets log the ban localy	so we can unban later

					ban = "\n"
					ban = ban .. "[ban]" .. "\n"
					ban = ban .. "name	= " .. name .. "\n"
					ban = ban .. "guid	= " .. GUID .. "\n"
					ban = ban .. "ip	= " .. ip .. "\n"
					ban = ban .. "reason	= " .. reason .. "\n"
					ban = ban .. "made	= " .. os.date("%x %H:%M") .. "\n"
					ban = ban .. "expires	= " .. 0 .. "\n" -- ban time is in minutes (PB ban time is set in minutes)
					ban = ban .. "banner	= " .. admin .. "\n"
				

					if ( len > -1 ) then
						et.trap_FS_Write( ban, string.len(ban) ,fd )
					end
					et.trap_FS_FCloseFile( fd )
					
					if et.trap_Cvar_Get( "sv_punkbuster" ) == 1 then
						local client = client + 1 -- pb counts from 1, and not 0
						-- banguid does not display reason
						--et.trap_SendConsoleCommand(et.EXEC_NOW , "PB_SV_BanGuid " .. GUID .. " " .. name .. " " .. ip .. " " .. reason) 
						et.trap_SendConsoleCommand(et.EXEC_APPEND , "PB_SV_Ban " .. client .. " " .. reason) 
						et.trap_SendConsoleCommand(et.EXEC_INSERT , "pb_sv_updbanfile" ) 
					else
						et.trap_DropClient( client, "You have been perm banned! reason: "..reason.." ", (os.time() + 999999999999*60))
					end
					
					et.G_Print("Ban: " .. name .. " " .. GUID .. " " .. admin .. " " .. reason .. "\n")
					-- announce the player has been banned!
					et.trap_SendServerCommand( -1 , params.say.." ^fBan^w: " .. name .. " ^fhas been banned. reason: ".. reason )
					et.trap_SendServerCommand( -1 , string.format('%s \"%s"',"cpm","^fBan^w: " .. name .. " ^fhas been banned. reason: ".. reason ))
				end
			else
				et.G_Print("^3Ban^w: " .. params[1] .. "^f is not on the server!^7\n")
			end
		else
			et.G_Print("^fBan - usage^w:^f !ban [name|slot] [time] [reason]\n")
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
					et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^3Ban^w: ^fPlayer name requires more than 2 characters" ))
				else
					client = getPlayernameToId(params[1])
				end
			end
			-- either a slot or the victim doesnt exist
			if client ~= nil then
				if global_players_table[client] == nil then
					et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^3Ban^w: " .. params[1] .. "^f is not on the server!^7"))
					return
				end
				if ( AdminUserLevel(params["slot"]) < AdminUserLevel(client)) then
					et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^3Ban^w: ^fcannot target a higher level"))
					return
				end
				local guis = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "cl_guid" )
				local GUID = string.upper( guis )
				if (GUID == nil or GUID == "") then
					et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^3Ban^w: " .. params[1] .. "^f is not on the server!^7"))
					return
				end
				
				

				local name = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
				ip = string.gsub(et.Info_ValueForKey( et.trap_GetUserinfo( client ), "ip" ), "%:%d+", "")
				local admin = et.Info_ValueForKey( et.trap_GetUserinfo( params["slot"] ), "name" )
				local ban = ""
				time = tonumber(params[2])
				if ( time ~= nil ) then -- its temp ban
				-- TODO: log temp-bans, show them in !showbans, and auto-remove them when expire
					local i=3
					reason = ""
					while (params[i] ~= nil) do
						reason = reason .. params[i] .. " "
						i = i + 1
					end
					if (reason == "") then
						if level_flag(AdminUserLevel(params.slot), "6") == nil then
							et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^3Ban^w:^f you must specify a reason!^7"))
							return
						else
							reason = "Banned By Admin"
						end
					end
					fd, len = et.trap_FS_FOpenFile( "kmod+/misc/banlist.dat", et.FS_APPEND )  
					-- time to ban, lets log the ban localy	so we can unban later
					
					ban = "\n"
					ban = ban .. "[ban]" .. "\n"
					ban = ban .. "name	= " .. name .. "\n"
					ban = ban .. "guid	= " .. GUID .. "\n"
					ban = ban .. "ip	= " .. ip .. "\n"
					ban = ban .. "reason	= " .. reason .. "\n"
					ban = ban .. "made	= " .. os.date("%x %H:%M") .. "\n"
					ban = ban .. "expires	= " .. (os.time() + time*60) .. "\n" -- ban time is in minutes (PB ban time is set in minutes)
					ban = ban .. "banner	= " .. admin .. "\n"
				

					if ( len > -1 ) then
						et.trap_FS_Write( ban, string.len(ban) ,fd )
					end
					et.trap_FS_FCloseFile( fd )
					loadtempbans()
					
					if et.trap_Cvar_Get( "sv_punkbuster" ) == 1 then
						local client = client + 1 -- pb counts from 1, and not 0
						et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. client .. " " .. time .. " reason: " ..  reason) 
						et.trap_SendConsoleCommand(et.EXEC_INSERT , "pb_sv_updbanfile" )
					else
						et.trap_DropClient( client, "You have been banned! reason: "..reason.." expire: "..(os.time() + time*60).." ", (os.time() + time*60))
					end
					et.G_Print("Ban: " .. name .. " " .. GUID .. " " .. admin .. " " .. reason .. "\n")
					-- announce the player has been banned!
					et.trap_SendServerCommand( -1 , string.format('%s \"%s"',params["say"],"^fBan^w: " .. name .. " ^fhas been banned. reason: ".. reason ))
					et.trap_SendServerCommand( -1 , string.format('%s \"%s"',"cpm","^fBan^w: " .. name .. " ^fhas been banned. reason: ".. reason ))
					

				else -- permenent ban
					
					if level_flag(AdminUserLevel(params.slot), "8") == nil then
						et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^3Ban^w:^f you must specify a duration^7"))
						return
					else
						reason = "Banned By Admin"
					end

					local i=2
					reason = ""
					while (params[i] ~= nil) do
						reason = reason .. params[i] .. " "
						i = i + 1
					end
					if (reason == "") then
						if level_flag(AdminUserLevel(params.slot), "6") == nil then
							et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^3Ban^w:^f you must specify a reason!^7"))
							return
						else
							reason = "Banned By Admin"
						end
					end
					fd, len = et.trap_FS_FOpenFile( "kmod+/misc/banlist.dat", et.FS_APPEND ) 
					-- time to ban, lets log the ban localy	so we can unban later

					

					ban = "\n"
					ban = ban .. "[ban]" .. "\n"
					ban = ban .. "name	= " .. name .. "\n"
					ban = ban .. "guid	= " .. GUID .. "\n"
					ban = ban .. "ip	= " .. ip .. "\n"
					ban = ban .. "reason	= " .. reason .. "\n"
					ban = ban .. "made	= " .. os.date("%x %H:%M") .. "\n"
					ban = ban .. "expires	= " .. 0 .. "\n" -- ban time is in minutes (PB ban time is set in minutes)
					ban = ban .. "banner	= " .. admin .. "\n"
				

					if ( len > -1 ) then
						et.trap_FS_Write( ban, string.len(ban) ,fd )
					end
					et.trap_FS_FCloseFile( fd )
					
					if et.trap_Cvar_Get( "sv_punkbuster" ) == 1 then
						local client = client + 1 -- pb counts from 1, and not 0
						-- banguid does not display reason
						--et.trap_SendConsoleCommand(et.EXEC_NOW , "PB_SV_BanGuid " .. GUID .. " " .. name .. " " .. ip .. " " .. reason) 
						et.trap_SendConsoleCommand(et.EXEC_APPEND , "PB_SV_Ban " .. client .. " " .. reason) 
						et.trap_SendConsoleCommand(et.EXEC_INSERT , "pb_sv_updbanfile" ) 
					else
						et.trap_DropClient( client, "You have been perm banned! reason: "..reason.." ", (os.time() + 999999999999*60))
					end
					
					et.G_Print("Ban: " .. name .. " " .. GUID .. " " .. admin .. " " .. reason .. "\n")
					-- announce the player has been banned!
					et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^fBan^w: " .. name .. " ^fhas been banned. reason: ".. reason ))
					et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',"cpm","^fBan^w: " .. name .. " ^fhas been banned. reason: ".. reason ))
				end
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Ban^w: " .. params[1] .. "^f is not on the server!^7"))
			end
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^fBan - usage^w:^f !ban [name|slot] [time] [reason]"))
		end	
end

