function dolua(params)

	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

	COMMAND = "admindel"
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR

	-- im leaving all the guid, name, etc.. if some1 will ever want to change it to !unban by name or guid etc...
	-- btw, im sure it can also be configured to read the pbbans.dat file (ban.lua, showbans.lua, unban.lua), but it
	-- wont be that good for streaming servers, because they will have thousands of bans on the list.
	local i = 0
	local guid 
	local name
	local level
	local line = tonumber(params[1])
	local flag = false
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/shrubbot.dat', et.FS_READ )

	if (params["slot"] == CONSOLE) then
		-- currently not available
		return 1
	end


	if (line ~= nil) then
		if (len <= 0) then
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING .. "no admins defind"))
			return 1
		else
			local filestr = et.trap_FS_Read( fd, len ) --        name " - " guid - banner - reason 
			for temp_level,guid,temp_name in string.gfind(filestr, "(-?%d+)%s%-%s(%x+)%s%- ([^%\n]+)") do
				if (i == line) then
					flag = true
					name = temp_name
					level = tonumber(temp_level)
					--et.G_Print("level: " .. level)
					break -- line does exist!
				end
				i=i+1
			end
			et.trap_FS_FCloseFile( fd )
			if flag then
				if AdminUserLevel(params["slot"]) < level then
					et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s\"',params["say"],HEADING .."cannot delete a higher admin"))
					return 1
				end
				DeleteFileLine("kmod+/misc/shrubbot.dat", line+1)
				loadAdmins()
				et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],HEADING .."is no longer an admin"))
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING .."undefind admin " .. line))
			end
		end

	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"], COMMAND_COLOR .. COMMAND .. " - usage^w: " .. COMMAND_COLOR.. "!" .. COMMAND .." [admin number]"))
	end
	return 1
	
end
			
