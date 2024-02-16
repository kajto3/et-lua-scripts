function dolua(params) 
	COMMAND = "rename"
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR
	local define = {}
	local victim

	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end


	define["msg_syntax"] = HEADING .. " !" .. COMMAND .. " [name|slot] [new nickname]"
	define["msg_no_target"] =  HEADING .."<PARAM>" .. COMMAND_COLOR.. " is not on the server!"
	define["msg_higher_admin"] = HEADING .. "cannot target higher level"
	define["reqired_params"] = 2
	victim = readyCommand(params,define)
	if victim ~= -1 then
		local name = et.gentity_get(victim,"pers.netname")
		local userinfo = et.trap_GetUserinfo(victim)
		userinfo = et.Info_SetValueForKey(userinfo, "name", params[2])
		et.trap_SetUserinfo(victim, userinfo)
		et.ClientUserinfoChanged(victim)
		global_players_table[victim]["name"] = params[2] -- update the player's name
		if params["slot"] == "console" then
			et.G_LogPrint(HEADING.. "^w"..name ..COMMAND_COLOR .." was renamed to ^w" .. params[2] .. "\n")
		else
			et.trap_SendServerCommand(params.slot, string.format('%s \"%s\"',params["say"],HEADING.."^w"..name ..COMMAND_COLOR .." was renamed to ^w" .. params[2] ))
		end
	end
	return 1
end