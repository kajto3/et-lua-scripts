function dolua(params) 
	local COMMAND = "info"
	local HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR
	local define = {}
	local victim

	define["msg_syntax"] = HEADING .. " " .. COMMAND .. " [name|slot]" .. "\n"
	define["msg_no_target"] =  HEADING .."<PARAM>" .. COMMAND_COLOR.. " is not on the server!" .. "\n"
	define["msg_higher_admin"] = HEADING .. "cannot target higher level" .. "\n"
	define["reqired_params"] = 1
	victim = readyCommand(params,define)
	if victim ~= -1 then
		local guid = global_players_table[victim]["guid"]
		local name = et.gentity_get(victim,"pers.netname")
		et.trap_SendServerCommand( params["slot"] , string.format('%s \"%s\n\"',"print",HEADING.."current status for player " .. name ))
		local text = COMMAND_COLOR .. "slot: ^w" .. victim .. COMMAND_COLOR .."        name: ^w" ..name ..COMMAND_COLOR.. "        GUID: ^w*" .. string.sub(guid,-8) 
		if global_players_table[victim]["guid_age"] ~= nil then
			text = text .. COMMAND_COLOR .. "        GUID age: ^w"  .. global_players_table[victim]["guid_age"]
		end
		local s = string.find(global_players_table[victim]["ip"],"%.[%d%s]*",-4)
		ip = string.sub(global_players_table[victim]["ip"],1,s)
		text = text .. COMMAND_COLOR .. "        ip: ^w" .. ip .. "*"
		et.trap_SendServerCommand( params["slot"] , string.format('%s \"%s\n\"',"print",text ))
	
		local i
		if table.getn(global_players_info_table[guid]["alias"]) > 1 then
			text = COMMAND_COLOR .. "known aliases:\n^w"
			for i=1,table.getn(global_players_info_table[guid]["alias"]),1 do
				text = text .. global_players_info_table[guid]["alias"][i] .. "\n^w"
				if string.len(text) > 900 then -- turns out the limit is 1022.. who knew... (i got an error - etpro: trap_SendServerCommand( 11, ... ) length exceeds 1022)
					et.trap_SendServerCommand( params["slot"] , string.format('%s \"%s\"',"print",text ))
					text = ""
				end

			end
			if string.len(text) > 1 then -- print the rest
				et.trap_SendServerCommand( params["slot"] , string.format('%s \"%s\"',"print",text ))
			end
		end
		
		local ipt -- temp ip table
		ipt = global_players_info_table[guid].getList("ip")

		if table.getn(ipt) > 1 then
			text = COMMAND_COLOR .. "known ip's:\n^w"
			for i=1,table.getn(ipt),1 do
				s = string.find(ipt[i],"%.[%d%s]*",-4)
				ip = string.sub(ipt[i],1,s)
				text = text .. ip .. "*" .. "\n^w" 
			end
			et.trap_SendServerCommand( params["slot"] , string.format('%s \"%s\"', "print", text ))
		end
		et.trap_SendServerCommand( params["slot"] , string.format('%s \"%s\n\"', "print", COMMAND_COLOR .. "-------------- end of player info --------------" ))
		
		--et.trap_SendServerCommand( params["slot"] , string.format('%s \"%s\"',"print", HEADING .. name .. COMMAND_COLOR.."'s info has been printed in the console!" ))
		--et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],HEADING..name ..COMMAND_COLOR .." was slapped!" ))
		return 1
	end
	return 1


end