function dolua(params)
	-- im leaving all the guid, name, etc.. if some1 will ever want to change it to !unban by name or guid etc...
	-- btw, im sure it can also be configured to read the pbbans.dat file (ban.lua, showbans.lua, unban.lua), but it
	-- wont be that good for streaming servers, because they will have thousands of bans on the list.
	local line = tonumber(params[1])

	local name
	local guid
	local ip
	local reason
	local made
	local expires
	local banner

	local i = 1
	local flag = false
	local fd,len = et.trap_FS_FOpenFile( "kmod+/misc/banlist.dat", et.FS_READ )

	if (params["slot"] == "console") then
			if (line ~= nil) then
				if (len <= 0) then
					et.G_Print("^3Unban: no bans defined \n")
					return
				else
					local filestr = et.trap_FS_Read( fd, len )
					et.trap_FS_FCloseFile( fd )
					-- done reading, parse the banlist, and re-write back all bans *exept* the specified ban
					-- open new banlist
					fd,len = et.trap_FS_FOpenFile( "kmod+//banlist.dat", et.FS_WRITE )
					for name,guid,ip,reason,made,expires,banner in string.gfind(filestr, "%s*\%[ban%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*ip%s*=%s*([^%\n]*)%s*reason%s*=%s*([^%\n]*)%s*made%s*=%s*([^%\n]*)%s*expires%s*=%s*(%d+)%s*banner%s*=%s*([^%\n]*)%s*") do
						if (i == line) then -- pb_unban and announce, dont copy the ban back to the banlist
							flag = true
							et.trap_SendConsoleCommand(et.EXEC_APPEND , "PB_SV_UnBanGuid " .. guid ) 
							et.trap_SendConsoleCommand(et.EXEC_INSERT , "pb_sv_updbanfile" ) 
							et.G_Print("^3unban^w: " .. name .. "^f has been unbanned\n")
							et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3unban^w: " .. name .. "^f has been unbanned"))
						else -- copy the ban back to the banlist
						
							ban = "\n"
							ban = ban .. "[ban]" .. "\n"
							ban = ban .. "name	= " .. name .. "\n"
							ban = ban .. "guid	= " .. guid .. "\n"
							ban = ban .. "ip	= " .. ip .. "\n"
							ban = ban .. "reason	= " .. reason .. "\n"
							ban = ban .. "made	= " .. made .. "\n"
							ban = ban .. "expires	= " .. expires .. "\n" 
							ban = ban .. "banner	= " .. banner .. "\n"
							et.trap_FS_Write( ban, string.len(ban) ,fd )
						end
						i=i+1
					end
					et.trap_FS_FCloseFile( fd )
					loadtempbans()
					

					if not flag then
						et.G_Print("^3unban^w: undefind ban " .. line .. "\n")
					end
				end
				
			else
				et.G_Print("^3unban - usage^w: ^f!unban [ban number]\n")
			end
			return
	end


	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

	if (line ~= nil) then
		if (len <= 0) then
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Unban^w: ^fno bans defind"))
			return
		end
		local filestr = et.trap_FS_Read( fd, len )
		et.trap_FS_FCloseFile( fd )
		-- done reading, parse the banlist, and re-write back all bans *exept* the specified ban
		-- open new banlist
		fd,len = et.trap_FS_FOpenFile( "kmod+/misc/banlist.dat", et.FS_WRITE )
		for name,guid,ip,reason,made,expires,banner in string.gfind(filestr, "%s*\%[ban%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*ip%s*=%s*([^%\n]*)%s*reason%s*=%s*([^%\n]*)%s*made%s*=%s*([^%\n]*)%s*expires%s*=%s*(%d+)%s*banner%s*=%s*([^%\n]*)%s*") do
			if (i == line) then -- pb_unban and announce, dont copy the ban back to the banlist
				flag = true
				et.trap_SendConsoleCommand(et.EXEC_APPEND , "PB_SV_UnBanGuid " .. guid ) 
				et.trap_SendConsoleCommand(et.EXEC_INSERT , "pb_sv_updbanfile" ) 
				et.G_Print("^3unban^w: " .. name .. "^f has been unbanned\n")
				et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3unban^w: " .. name .. "^f has been unbanned"))
			else -- copy the ban back to the banlist
				ban = "\n"
				ban = ban .. "[ban]" .. "\n"
				ban = ban .. "name	= " .. name .. "\n"
				ban = ban .. "guid	= " .. guid .. "\n"
				ban = ban .. "ip	= " .. ip .. "\n"
				ban = ban .. "reason	= " .. reason .. "\n"
				ban = ban .. "made	= " .. made .. "\n"
				ban = ban .. "expires	= " .. expires .. "\n" 
				ban = ban .. "banner	= " .. banner .. "\n"
				et.trap_FS_Write( ban, string.len(ban) ,fd )
			end
			i=i+1
		end
		et.trap_FS_FCloseFile( fd )
		loadtempbans()
		if not flag then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3unban^w: undefind ban " .. line))
		end
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3unban - usage^w: ^f!unban [ban number]"))
	end

	return 1
end
			
