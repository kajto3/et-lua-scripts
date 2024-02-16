function dolua(params)
	
	local message = ""
	local slot
	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end

	--message = "^fslot ref/muted level name"
	--et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],message)) 
	local players = 0
	for slot=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do
		message = ""
		local name = et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "name" )
		if (name ~= "") then -- slot isnt empty
			players = players +1
			
			local level = AdminUserLevel(slot)
			if (level_flag(AdminUserLevel(slot),"@") )  then -- "incognito" - display admin as level 0
				level = 0
			end
			local mute = tonumber(et.gentity_get(slot, "sess.muted"))
			if (mute == 1) then
				mute = "^1M "
			else
				mute = "  "
			end
			local original_name = ""
			local team = global_players_table[slot]["team"]
				if     team == 1 then	team = "^1R "
				elseif team == 2 then	team = "^$B "
				elseif team == 3 then	team = "^3S "
				else			team = "^3C " -- connecting, not sure its possible though
				end

			if level ~= 0 then
				local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "cl_guid" ))
			

--[[
				local temp_name
				local temp_guid 
				local temp_level
				local fd,len = et.trap_FS_FOpenFile( "kmod+//shrubbot.dat", et.FS_READ )
			

				if len > 0 then

					local filestr = et.trap_FS_Read( fd, len )
					local i = 0
					-- get the level and the guid out of the shrubbot.cfg
					for temp_level,temp_guid,temp_name in string.gfind(filestr, "(-?%d+)%s%-%s(%x+)%s%-%s([%S]+)%s*") do
						if (global_level_table[tonumber(temp_level)] ~= nil) then
							if guid == temp_guid then
								original_name = temp_name
							end
						
						end
	
					end

				end
				et.trap_FS_FCloseFile( fd ) 
--]]
			original_name = global_admin_table[guid]["name"]
			end
			if (tonumber(et.gentity_get(slot,"sess.referee")) ~= 0) then
				mute = "^3R "
			end
		
			local spaces = 3
			local temp
			message = "^f" .. slot
			message = message .. string.rep(" ", spaces - string.len(tostring(slot)))
			message = message .. team
			message = message .. mute
			spaces = 15
			level =  global_level_table[level]["name"]
			--[[
			if (level ~= 0) then
				level = "^1" .. level .."^f"
			end
			--]]
			message = message .. level
			--level = tonumber(et.Q_CleanStr(level))
			message = message .. string.rep(" ", spaces - string.len(tostring(level)))
			message = message .. "^w" .. crop_text(name,20) .."^f"
			spaces = 21 -- maximum name legnth to be displayed is 20
			if (level ~= 0 and original_name ~= "") then	
				if (et.Q_CleanStr(name) ~= original_name) then
					original_name = "(^w ".. crop_text(original_name,10) .. " ^f)"
				else
					original_name = ""
				end
			end
			message = message .. original_name
			message = message .. string.rep(" ", spaces - string.len(et.Q_CleanStr(crop_text(name,20))) - string.len(et.Q_CleanStr(crop_text(original_name,20))) )
			temp = spaces
			spaces = 25
			if global_players_table[slot]["guid_age"] ~= nil then
				message = message .. "^f" .. global_players_table[slot]["guid_age"]
				message = message .. string.rep(" ", spaces - string.len(et.Q_CleanStr(global_players_table[slot]["guid_age"])))

			else message = message .. string.rep(" ", spaces ) end
			message = message .. "\n"

			if params.slot == CONSOLE then
				et.G_Print(et.Q_CleanStr(message) .. "\n")
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',"print ",message)) 
			end
		end
	end
	if params["slot"] == CONSOLE then
		et.G_Print("listplayers: " .. players .. " players has been listed in the console\n")
	else
		if players == 1 then
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^:listplayers^w: ^f" .. players.. " player has been listed in the console"))
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^:listplayers^w: ^f" .. players.. " players have been listed in the console"))
		end
	end
	return 1


	
end
			
