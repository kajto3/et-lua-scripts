-- !tk_index
function dolua(params)

	if (params["slot"] == "console") then
		if ( params[1] ~= nil ) then
		
			local client = tonumber(params[1])
			if client then
				if (client >= 0) and (client < 64) then 
					if et.gentity_get(client,"pers.connected") ~= 2 then 
						et.G_Print("^3Tk_index^w: ^fThere is no client associated with this slot number\n" )
						return 
					end 
	
				else              
					et.G_Print("^3Tk_index^w: ^fPlease enter a slot number between 0 and 63\n" )
					return 
				end 
			end
			if client == nil then -- its a player's name
				s,e=string.find(params[1], params[1])
				e = e or 0
				if e <= 2 then
					et.G_Print("^3Tk_index^w: ^fPlayer name requires more than 2 characters\n" )
					return
				else
					client = getPlayernameToId(params[1])
				end
			end
			-- either a slot or the victim doesnt exist
			if client ~= nil then
				if global_players_table[client] == nil then
					et.G_Print("^3Tk_index^w: " .. params[1] .. "^f is not on the server!^7\n")
					return
				end

				local status = ""
				local name = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
				if teamkillr[client] < -1 then
					status = "^1NOT OK"
				else
					status = "^2OK"
				end
				et.G_Print("^3Tk_index: ^7" .. name .. "^7 has a teamkill index of ^3" ..teamkillr[client] .. "^7 \[" .. status .. "^7\]\n" )
				return
				
			else
				et.G_Print("^3Tk_index^w: " .. params[1] .. "^f is not on the server!^7\n")
				return
			end
		else
		
				local client = params.slot
				local status = ""
				local name = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
				if teamkillr[client] < -1 then
					status = "^1NOT OK"
				else
					status = "^2OK"
				end
				et.G_Print("^3Tk_index: ^7" .. name .. "^7 has a teamkill index of ^3" ..teamkillr[client] .. "^7 \[" .. status .. "^7\]\n" )
				return
		end

	return
	end 

	
	-- normal user
	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	params[1] =  string.lower(et.trap_Argv(2))	--this line is needed because default is et.trap_Argv(1) and would be !tk_index
												--see et_ClientCommand.lua line 221 for more info
	if ( params[1] ~= nil ) then
	
		local client = tonumber(params[1])
		if client then
			if (client >= 0) and (client < 64) then 
				if et.gentity_get(client,"pers.connected") ~= 2 then 
					et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"],"^3Tk_index^w: ^fThere is no client associated with this slot number" ))
					return 1
				end 
	
			else              
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"],"^3Tk_index^w: ^fPlease enter a slot number between 0 and 63" ))
				return 1
			end 
		end
		if client == nil then -- its a player's name
			s,e=string.find(params[1], params[1])
			e = e or 0
			if e <= 2 then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"],"^3Tk_index^w: ^fPlayer name requires more than 2 characters" ))
				return 1
			else
				client = getPlayernameToId(params[1])
			end
		end
		-- either a slot or the victim doesnt exist
		if client ~= nil then
		
			if global_players_table[client] == nil then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Tk_index^w: " .. params[1] .. "^f is not on the server!"))
				return 1
			end
			
			local status = ""
			local name = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
			if teamkillr[client] < -1 then
				status = "^1NOT OK"
			else
				status = "^2OK"
			end
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Tk_index: ^7" .. name .. "^7 has a teamkill index of ^3" ..teamkillr[client] .. "^7 \[" .. status .. "^7\] \"" ))
			return 1
			
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^3Tk_index^w: " .. params[1] .. "^f is not on the server!"))
			return 1
		end
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Tk_index: ^7No params \"" ))
		local client = params.slot
		local status = ""
		local name = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
		if teamkillr[client] < -1 then
			status = "^1NOT OK"
		else
			status = "^2OK"
		end
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Tk_index: ^7" .. name .. "^7 has a teamkill index of ^3" ..teamkillr[client] .. "^7 \[" .. status .. "^7\] \"" ))
		return 1
	end	

	return 1
end