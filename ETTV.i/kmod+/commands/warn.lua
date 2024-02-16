function dolua(params) 
	COMMAND = "warn"
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR
	local define = {}
	local victim

	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end


	define["msg_syntax"] = HEADING .. " !" .. COMMAND .. " [name|slot] [reason]"
	define["msg_no_target"] =  HEADING .."<PARAM>" .. COMMAND_COLOR.. " is not on the server!"
	define["msg_higher_admin"] = HEADING .. "cannot target higher level"
	define["reqired_params"] = 2
	victim = readyCommand(params,define)
	if victim ~= -1 then
		local name = et.gentity_get(victim,"pers.netname")
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref warn "..name.." "..params[2].."" )
		if params["slot"] == "console" then
			et.G_LogPrint(HEADING.. "^w"..name ..COMMAND_COLOR .." was issued a ^1warning "..COMMAND_COLOR .."(^w" .. params[2] .. ""..COMMAND_COLOR ..")\n")
		else
			et.trap_SendServerCommand(params.slot, string.format('%s \"%s\"',params["say"],HEADING.."^w"..name.." "..COMMAND_COLOR .." was issued a ^1Warning "..COMMAND_COLOR .."(^w" .. params[2]..""..COMMAND_COLOR ..")" ))
		end
	end
	return 1
end