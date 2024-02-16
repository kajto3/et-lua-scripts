function dolua(params)

	COMMAND = "unbanmask"
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR
	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end

	local ip,ip1,ip2, name, ban
	local line = tonumber(params[1])
	local flag = false
	if line == nil then 
		if params["slot"] == "console" then
			et.G_Print(HEADING .."undefind ban\n")
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],HEADING ..  "undefind ban"))
		end
	elseif line <= 0 then 
		if params["slot"] == "console" then
			et.G_Print(HEADING .."undefind ban " .. line .. "\n")
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],HEADING ..  "undefind ban " .. line))
		end
	end
	local i = 1

	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banmask.dat', et.FS_READ )
	if (line ~= nil) then
		if (len <= 0) then
			et.G_Print(HEADING .. "no bans defined \n")
			return
		else
			local filestr = et.trap_FS_Read( fd, len )
			et.trap_FS_FCloseFile( fd )
			-- done reading, parse the banlist, and re-write back all bans *exept* the specified ban
			-- open new banlist
			fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banmask.dat', et.FS_WRITE )
			for ip1,ip2,name in string.gfind(filestr, "%s*(%d+).(%d+)%s*-%s*([^%\n]*)%s*") do
				ip = ip1 .. "." .. ip2
				if (i == line) then 
					flag = true
					global_banmask_table[ip] = nil -- unban
					et.G_Print(HEADING .."^w" .. name ..COMMAND_COLOR.. "ip mask has been unbanned\n")
					et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],HEADING .."^w" .. name .. " ip mask has been unbanned"))
				else -- copy the ban back to the banlist
				
					ban = ip ..  " - " .. name .. "\n"
					et.trap_FS_Write( ban, string.len(ban) ,fd )
				end
				i=i+1
			end
			et.trap_FS_FCloseFile( fd )
			

			if not flag then
				if params["slot"] == "console" then
					et.G_Print(HEADING .. "undefind ban " .. line .. "\n")
				else
					et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],HEADING .. "undefind ban " .. line))
				end
	
			end
		end
	end
	return 1
end
			
