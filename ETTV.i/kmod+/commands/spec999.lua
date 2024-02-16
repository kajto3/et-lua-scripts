-- !spec999
function dolua(params) 

	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end


	local matches = 0
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		local team = tonumber(et.gentity_get(i,"sess.sessionTeam"))
		local ping = tonumber(et.gentity_get(i,"ps.ping"))
		if team ~= 3 and team ~= 0 then
			if ping >= 999 then
				matches = matches + 1
				et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref remove " .. i .. "\n" )
			end
		end
	end
	if matches == 1 then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3Spec999: ^7Moving ^1" ..matches.. " ^7player to spectator\n" )
		return 1
	else
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3Spec999: ^7Moving ^1" ..matches.. " ^7players to spectator\n" )
		return 1
	end
end