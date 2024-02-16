function dolua(params) 
	if (params["slot"] == "console") then -- rcon command
		if ( params[1] ~= nil ) then
			local PlayerID = tonumber(params[1])
			if PlayerID == nil then -- its a player's name
				s,e=string.find(params[1], params[1])
				e = e or 0
				if e <= 2 then
					et.G_Print("^3Ref^w: ^fPlayer name requires more than 2 characters\n" )
				else
					PlayerID = getPlayernameToId(params[1])
				end
			end
			if PlayerID ~= nil then -- either a number or the victim doesnt exist
				if global_players_table[PlayerID] == nil then
					et.G_Print("^3Ref^w: " .. params[1] .. "^f is not on the server!^7\n")
					return
				end
				--local GUID = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "cl_guid" ))
				local name = et.gentity_get(PlayerID,"pers.netname")
				if name ~= "" and name ~= nil then
						et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref referee " .. PlayerID) 
						et.G_Print(" ^3Ref^w: ^f" .. name .. " ^fis now a referee\n" )
				end
			else
				et.G_Print("^3Ref^w: " .. params[1] .. "^f is not on the server!^7\n")
			end
		else
			et.G_Print("^3Ref - usage^w:^f !ref [name|slot] \n")
		end
	return
	end



	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

	if ( params[1] ~= nil ) then
		local PlayerID = tonumber(params[1])
		if PlayerID == nil then
			s,e=string.find(params[1], params[1])
			e = e or 0
			if e <= 2 then
				et.trap_SendServerCommand( params["slot"], params["say"].." ^3Ref^w: ^fPlayer name requires more than 2 characters\n" )
				PlayerID = nil
			else
				PlayerID = getPlayernameToId(params[1])
			end
		end
		if PlayerID ~= nil then
			if global_players_table[PlayerID] == nil then
				et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s"\n',params["say"],"^3Ref^w: "  .. params[1] .. "^f is not on the server!^7"))
				return 1
			end
			--local GUID = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "cl_guid" ))
			local name = et.gentity_get(PlayerID,"pers.netname")
			if name ~= "" and name ~= nil then
					local ref = tonumber(et.gentity_get(PlayerID,"sess.referee"))
					if ref == 0 then
						et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref referee " .. PlayerID) 
						et.trap_SendServerCommand(-1 , string.format('%s \"%s"\n',params["say"]," ^3Ref^w: ^f" .. name .. " ^fis now a referee"))
					else
						et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"]," ^3Ref^w: ^f" .. name .. " ^fis already a referee"))
					end
			end	
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Ref^w: "  .. params[1] .. "^f is not on the server!^7"))
		end
	else
		--et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s"\n',params["say"],"^3Ref - usage^w:^f !ref [name|slot]"))
		--command executed on self
		local ref = tonumber(et.gentity_get(params["slot"],"sess.referee"))
		if ref == 0 then
			et.trap_SendConsoleCommand(et.EXEC_APPEND , "ref referee " .. params["slot"]) 
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"]," ^3Ref^w: ^fyou are now a referee"))
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"]," ^3Ref^w: ^fyou are already a referee"))
		end
	end
	return 1

end