-- !help
function dolua(params) 


	local string_out = "" -- will hold up to 5 commands
	local total_commands = 0
	local spaces = 12
	local PlayerID = params.slot
	local command
	

	local command_count = 0	
	if (params.slot == "console") then
		for command,level in pairs(admin_commands_table) do
				command_count = command_count + 1
				total_commands = total_commands + 1
				string_out = string_out .. "^f" .. command
				if ( command_count < 5) then				    
					string_out = string_out .. string.rep(" ", spaces - string.len(command))
				end
				if ( command_count >= 5 ) then
					command_count = 0
					et.G_Print( string.format(string_out) .. "\n")
					string_out = ""
				end
		end
		-- if theres less then a "block" of commands left not printed - print!
		if (string.len(string_out) > 0) then
			et.G_Print( string.format(string_out) .. "\n")
		end
		return 1
	end

	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

	-- normal player
	--et.trap_SendServerCommand(PlayerID, string.format("print \"^3Here's the list of all allowed commands:\n")

	local level = AdminUserLevel(PlayerID)
	local i
	for i=1, table.getn(global_level_table[level]["commands"]), 1 do
		command = global_level_table[level]["commands"][i]

		command_count = command_count + 1
		total_commands = total_commands + 1
		string_out = string_out .. "^f" .. command
		if ( command_count < 5) then				    
			string_out = string_out .. string.rep(" ", spaces - string.len(command))
		end
		if ( command_count >= 5 ) then
			command_count = 0
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"], string_out)) 
			string_out = ""
		end


	end
--[[
	for command,level in pairs(admin_commands_table) do
			if AdminUserLevel(PlayerID) >= level then
					command_count = command_count + 1
					total_commands = total_commands + 1
					string_out = string_out .. "^f" .. command
					if ( command_count < 5) then				    
						string_out = string_out .. string.rep(" ", spaces - string.len(command))
					end
					if ( command_count >= 5 ) then
						command_count = 0
						et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"], string_out)) 
						string_out = ""
					end
			end
	end
--]]
	-- if theres less then a "block" of commands left not printed - print!
	if (string.len(string_out) > 0) then
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"], string_out)) 
	end
	et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Help^w:^f " ..total_commands .. " available commands^w")) 
	return 1

end

