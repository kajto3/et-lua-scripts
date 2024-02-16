function dolua(params)

	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

	local i = 0
	local guid 
	local level
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/shrubbot.dat', et.FS_READ )


	if len <= 0 then
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"], "^:Error, no admins defind!\n")) 
	else
		local filestr = et.trap_FS_Read( fd, len )
		local i = 0
		local spaces = 15
		-- get the level and the guid out of the shrubbot.dat
		for level,guid,name in string.gfind(filestr, "(-?%d+)%s%-%s(%x+)%s%- ([^%\n]+)") do
			--message = "^f" .. i .. string.rep(" ", spaces - string.len(et.Q_CleanStr(i)))
			level = tonumber(level)
			if (level_flag(level,"@") )  then -- "incognito" - display admin as level 0
				level = 0
			end
			message = i .." ^f- " .. global_level_table[level]["name"]
			message = message .. string.rep(" ", spaces - string.len(et.Q_CleanStr(global_level_table[level]["name"])))
			message = message .. "^f- " .. name .. "\n"
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',"print ",message))
			--et.trap_SendServerCommand( params["broadcast"], params["say"].." ^3Listadmins^w: ^fNo Admins Defined!" )
			i=i+1
		end
	
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"], "^:Listadmins^w: ^f" .. i .. " known admins")) 

	end
	et.trap_FS_FCloseFile( fd ) 
	return 1
end