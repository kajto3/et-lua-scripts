function dolua(params) 
	if (params["slot"] == "console") then -- rcon command
		if ( params[1] ~= nil ) then
			local PlayerID = tonumber(params[1])
			if PlayerID == nil then -- its a player's name
				s,e=string.find(params[1], params[1])
				e = e or 0
				if e <= 2 then
					et.G_Print("^:finger Player name requires more than 2 characters\n" )
				else
					PlayerID = getPlayernameToId(params[1])
				end
			end
			if PlayerID ~= nil then -- either a number or the victim doesnt exist
				local GUID = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "cl_guid" ))
				local name = et.gentity_get(PlayerID,"pers.netname")
				if name ~= "" and name ~= nil then
					if (global_admin_table[GUID] ~= nil) then
						if (level_flag(AdminUserLevel(PlayerID),"@") )  then -- "incognito" - display admin as level 0
							et.G_Print(" ^:Finger^w: ^f" .. name .. " ^fis a level " .. 0 .. " user ( " ..global_level_table[0]["name"].. " ^f)\n" )
						else
							et.G_Print(" ^:Finger^w: ^f" .. name .. " ^fis a level " .. global_admin_table[GUID]["level"] .. " user ( " ..global_level_table[global_admin_table[GUID]["level"]]["name"].. " ^f)\n" )
						end
					else
						et.G_Print(" ^:Finger^w: ^f" .. name .. " ^fis a level " .. 0 .. " user ( " ..global_level_table[0]["name"].. " ^f)\n" )
					end
				end
			else
				et.G_Print("^3Finger^w: " .. params[1] .. "^f is not on the server!^7\n")
			end
		else
			et.G_Print("^:Finger - usage^w:^f !finger [name|slot] \n")
		end
	return
	end





	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

	if ( params[1] ~= nil ) then
		local PlayerID = tonumber(params[1])
		if PlayerID == nil then
			s,e=string.find(params[1], params[1])
			e = e or 0
			if e <= 2 then
				et.trap_SendServerCommand( params["slot"], params["say"].." ^:Player name requires more than 2 characters\n" )
				PlayerID = nil
			else
				PlayerID = getPlayernameToId(params[1])
			end
		end
		if PlayerID ~= nil then
			local GUID = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "cl_guid" ))
			local name = et.gentity_get(PlayerID,"pers.netname")
			if name ~= "" and name ~= nil then
				if (global_admin_table[GUID] ~= nil) then
					if (level_flag(AdminUserLevel(PlayerID),"@") )  then -- "incognito" - display admin as level 0
						--et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s"\n',params["say"],"^3Finger^w: ^f" .. name .. " ^fis a level " .. 0 .. " user ( " ..global_level_table[0]["name"].. " ^f)" ))
						et.trap_SendServerCommand(-1, "chat \"^:Finger ^f" .. name .. " ^:is a level " .. 0 .. " user ( " ..global_level_table[0]["name"].. " ^f) \"" )
						return 1
					end
				end
				if ( AdminUserLevel(params["slot"]) < AdminUserLevel(PlayerID) ) then
					et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^:request cannot target a higher level"))
					return 1
				end
				if (global_admin_table[GUID] ~= nil) then
					--et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s"\n',params["say"]," ^3Finger^w: ^f" .. name .. " ^fis a level " .. global_admin_table[GUID]["level"] .. " user ( " ..global_level_table[global_admin_table[GUID]["level"]]["name"].. " ^f)" ))
					et.trap_SendServerCommand(-1, "chat \"^:Finger ^f" .. name .. " ^:is a level " .. global_admin_table[GUID]["level"] .. " user ( " ..global_level_table[global_admin_table[GUID]["level"]]["name"].. " ^f) \"" )
				else
					--et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s"\n',params["say"],"^3Finger^w: ^f" .. name .. " ^fis a level " .. 0 .. " user ( " ..global_level_table[0]["name"].. " ^f)" ))
					et.trap_SendServerCommand(-1, "chat \"^:Finger ^f" .. name .. " ^:is a level " .. 0 .. " user ( " ..global_level_table[0]["name"].. " ^f) \"" )
				end

			end	
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Finger^w: "  .. params[1] .. "^f is not on the server!^7"))
		end
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Finger - usage^w:^f !finger [name|slot]"))
	end
	return 1

end