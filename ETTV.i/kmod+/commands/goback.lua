function dolua(params)

	local command = "goback"

	if (params["slot"] == "console" ) then
		return -- console cannot goback
	end


	if tonumber(et.trap_Cvar_Get("k_mod")) ~= nil then
		if tonumber(et.trap_Cvar_Get("k_mod")) ~= MOD_TRICKJUMP then
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],COMMAND_COLOR .. command .. "^w:" .. COMMAND_COLOR .." unknown command " .. command)) 
			return
		end
	else
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],COMMAND_COLOR .. command .. "^w:" .. COMMAND_COLOR .. " unknown command " .. command)) 
		return
	end

	if et.gentity_get(params["slot"],"sess.sessionTeam") >= 3 or et.gentity_get(params["slot"],"sess.sessionTeam") < 1 then
		et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],COMMAND_COLOR .. command .."^w: "..COMMAND_COLOR.."you must be on a team!" ))
		return
	end

	local command = "goback"
	local trick_jump_mod = findVMslot("TJmod")
	if trick_jump_mod == nil then
		et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],COMMAND_COLOR .. command .."^w: "..COMMAND_COLOR.."trick jump module isn't runing on this server!" ))
		et.G_LogPrint("K_ERROR: COMMAND - goback: trick jump module isn't runing on this server!\n")
		return
	end
	local ok = et.IPCSend(trick_jump_mod, string.format("%s %d", command, params["slot"]))
	if ok ~= 1 then --(==0)
		et.G_LogPrint("K_ERROR: COMMAND - goback: cross Trick jump - KMOD+ problem !\n")
		return
	end


	et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],COMMAND_COLOR .. command .."^w: "..COMMAND_COLOR.."your previous position has been restored!" ))
			

end

