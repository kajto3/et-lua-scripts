-- !gib command
-- doesnt wrapped in "function dolua(params)"
	COMMAND = "gib"
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR

if params.slot ~= CONSOLE then
	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
end

if ( params[1] ~= nil ) then
	local client = tonumber(params[1])
	if client == nil then -- its a player's name
		s,e=string.find(params[1], params[1])
		e = e or 0
		if e <= 2 then
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING .."Player name requires more than 2 characters" ))
		else
			client = getPlayernameToId(params[1])
		end
	end
	-- either a slot or the victim doesnt exist
	if global_players_table[client] ~= nil then
		if params["slot"] ~= "console" then
			if AdminUserLevel(params["slot"]) < AdminUserLevel(client) then
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING .."cannot target higher level"))
				return 1
			end
		end
		if global_players_table[client]["team"] == 3 then -- spectator
			if params["slot"] == "console" then
				et.G_Print(HEADING .."player must be on a team\n")
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING .."player must be on a team"))
			end
			return 1
		end

		et.gentity_set(client, "health", -600)
		if params["slot"] == "console" then
			et.G_Print(HEADING  .. global_players_table[client]["name"] .. COMMAND_COLOR.. " was gibbed" .. "\n")
		end
		et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],HEADING  .. global_players_table[client]["name"] .. COMMAND_COLOR.. " was gibbed"))
	else
		if params["slot"] == "console" then
			et.G_Print(HEADING .. params[1] .. COMMAND_COLOR .. " is not on the server!" .. "\n")
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],HEADING .. params[1] .. COMMAND_COLOR .. " is not on the server!"))
		end
	end
	return 1
else
	if params["slot"] == "console" then
		et.G_Print(COMMAND_COLOR .. COMMAND .. " - usage^w: ".. COMMAND_COLOR .. "!"..  COMMAND .. " [name|slot]" .. "\n")
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"], COMMAND_COLOR .. COMMAND .. " - usage^w: ".. COMMAND_COLOR .. "!"..  COMMAND .. " [name|slot]"))
	end
	return 1
end
