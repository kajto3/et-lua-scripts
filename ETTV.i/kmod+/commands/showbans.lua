function dolua(params)
	-- banner line supports up to 97 charactars in 1 line
	local i = 1
	local name
	local guid 
	local ip
	local reason
	local made
	local expires
	local admin
	local spaces = 15
	local message = ""
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banlist.dat', et.FS_READ )


	if (params["slot"] == CONSOLE) then
		if len <= 0 then
			et.G_Print("^3Showbans: no bans defined \n")
		else
			local filestr = et.trap_FS_Read( fd, len ) --        name " - " guid - banner - reason
			message = "^f# " .. "player" .. string.rep(" ", spaces - string.len("player")) 
			message = message .. "banned by" .. string.rep(" ", spaces - string.len("banned by")) 
			message = message .. "expires" .. string.rep(" ", spaces - string.len("expires")) 
			message = message .. "date" .. string.rep(" ", spaces - string.len("date"))
			message = message .. "reason" 
			et.G_Print(message .. "\n")
			for name,guid,ip,reason,made,expires,admin in string.gfind(filestr, "%s*\%[ban%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*ip%s*=%s*([^%\n]*)%s*reason%s*=%s*([^%\n]*)%s*made%s*=%s*([^%\n]*)%s*expires%s*=%s*(%d+)%s*banner%s*=%s*([^%\n]*)%s*") do
				--et.G_Print(name .. " " .. guid .. " " .. admin .. " " .. reason .. "\n")
				--et.G_Print("crap - " .. name .. " | " .. guid .. " | " .. ip .. " | " .. reason .. "\n");

				name = crop_text(name,spaces-2)
				admin = crop_text(admin,spaces-2)
				expires = tonumber(expires)
				if expires == 0 then
					expires = "PERMANENT"
				else
					expires = expires - os.time();
					if expires > 86400 then -- count in days
						expires = math.ceil(expires/86400) .. " Days"
					elseif expires > 3600 then -- count in hours
						expires = math.ceil(expires/3600) .. " Hours"
					elseif expires > 60 then -- count in minutes
						expires = math.ceil(expires/60) .. " Min"
					else	expires = expires .. " Sec" end
				end

				message = "^f" .. i .. " "
				message = message .. name .. string.rep(" ", spaces - string.len(et.Q_CleanStr(name)))
				message = message .. "^w" .. admin .. string.rep(" ", spaces - string.len(et.Q_CleanStr(admin)))
				message = message .. "^w" .. expires .. string.rep(" ", spaces - string.len(et.Q_CleanStr(expires)))
				message = message .. "^w" .. made .. string.rep(" ", spaces - string.len(et.Q_CleanStr(made)))
				message = message .. "^f" .. crop_text(reason,57)
				et.G_Print(message.."\n")
				i=i+1
			end
			et.trap_FS_FCloseFile( fd )
		end
	et.trap_FS_FCloseFile( fd )
	-- check if there are any banmasks/ip bans
	local temp = LoadFileToTable('kmod+/misc/banmask.dat')
	if temp ~= nil and table.getn(temp) > 0 then
		--et.G_Print("banned ip adresses:".."\n")
		runcommand("showmask",params)
	end
	return
	end




	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	if len <= 0 then
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Showbans^w: ^fno bans defined")) 
	else
		local filestr = et.trap_FS_Read( fd, len ) --        name " - " guid - banner - reason
			message = "^f# " .. "player" .. string.rep(" ", spaces - string.len("player")) 
			message = message .. "banned by" .. string.rep(" ", spaces - string.len("banned by")) 
			message = message .. "expires" .. string.rep(" ", spaces - string.len("expires")) 
			message = message .. "date" .. string.rep(" ", spaces - string.len("date"))
			message = message .. "reason" 
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],message)) 
			for name,guid,ip,reason,made,expires,admin in string.gfind(filestr, "%s*\%[ban%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*ip%s*=%s*([^%\n]*)%s*reason%s*=%s*([^%\n]*)%s*made%s*=%s*([^%\n]*)%s*expires%s*=%s*(%d+)%s*banner%s*=%s*([^%\n]*)%s*") do
				--et.G_Print(name .. " " .. guid .. " " .. admin .. " " .. reason .. "\n")
				--et.G_Print("crap - " .. name .. " | " .. guid .. " | " .. ip .. " | " .. reason .. "\n");

				name = crop_text(name,spaces-2)
				admin = crop_text(admin,spaces-2)
				expires = tonumber(expires)
				if expires == 0 then
					expires = "PERMANENT"
				else
					expires = expires - os.time();
					if expires > 86400 then -- count in days
						expires = math.ceil(expires/86400) .. " Days"
					elseif expires > 3600 then -- count in hours
						expires = math.ceil(expires/3600) .. " Hours"
					elseif expires > 60 then -- count in minutes
						expires = math.ceil(expires/60) .. " Min"
					else	expires = expires .. " Sec" end
				end

				message = "^f" .. i .. " "
				message = message .. name .. string.rep(" ", spaces - string.len(et.Q_CleanStr(name)))
				message = message .. "^w" .. admin .. string.rep(" ", spaces - string.len(et.Q_CleanStr(admin)))
				message = message .. "^w" .. expires .. string.rep(" ", spaces - string.len(et.Q_CleanStr(expires)))
				message = message .. "^w" .. made .. string.rep(" ", spaces - string.len(et.Q_CleanStr(made)))
				message = message .. "^f" .. crop_text(reason,57)
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],message)) 
			i=i+1
		end
		et.trap_FS_FCloseFile( fd )
	end
	et.trap_FS_FCloseFile( fd )


	-- check if there are any banmasks/ip bans
	local temp = LoadFileToTable('kmod+/banmask.dat')
	if temp ~= nil and table.getn(temp) > 0 then
		--et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^fbanned ip adresses:")) 
		runcommand("showmask",params)
	end

	return 1
	
end
			
