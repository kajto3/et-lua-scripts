function dolua(params)
	if level_flag(AdminUserLevel(params["slot"]), "~") or tonumber(et.gentity_get(params["slot"],"sess.referee")) ~= 0 then
		if k_logchat == 1 then
			log_chat( params["slot"], "PMADMINS", et.ConcatArgs(1))
		end

		local sender_name = global_players_table[params["slot"]]["name"]
		for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do
			if global_players_table[i] ~= nil then
				if level_flag(AdminUserLevel(i), "~") or tonumber(et.gentity_get(i,"sess.referee")) ~= 0 then
					et.trap_SendServerCommand(i, string.format('%s \"%s"\n',"b 8","^w(^aAdminchat^w) " ..sender_name .. "^a: ^3" ..et.ConcatArgs(1) ))
				end
			end
		end
		return 1
	end
end