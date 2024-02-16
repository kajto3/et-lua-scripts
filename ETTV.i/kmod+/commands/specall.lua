-- TODO: check if the client is already on the team he's supposed to be, and dont move him (post error message: client is already on TEAM)
function dolua(params)
	command = "remove"
	if (params["slot"] == "console" ) then

		
		for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
			if global_players_table[i] then
				if global_players_table[i]["team"] ~= SPECTATOR and global_players_table[i]["team"] ~= CONNECTING then
					et.trap_SendConsoleCommand( et.EXEC_NOW, "ref " .. command .. " ".. global_players_table[i]["name"])	
				end
			end
		end
		et.G_LogPrint("^3specall^w:^f all players joined the spectators!^7" .. "\n")


		return
	end

	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

	--et.G_LogPrint("------> Here 1 <----------------\n")
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		if global_players_table[i] then
			--et.G_LogPrint("------> Here 2 <----------------\n")
			if global_players_table[i]["team"] ~= SPECTATOR and global_players_table[i]["team"] ~= CONNECTING then
				et.trap_SendConsoleCommand( et.EXEC_NOW, "ref " .. command .. " ".. global_players_table[i]["name"])
				--et.G_LogPrint("command: " .. "ref " .. command .. " ".. global_players_table[i]["name"] .."\n")
				
			end
		end
	end
	--et.G_LogPrint("------> Here 3 <----------------\n")
	et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3specall^w: ^f all players joined the spectators!^7"))


	return 1


end