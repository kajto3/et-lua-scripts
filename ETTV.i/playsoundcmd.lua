--
-- playsoundcmd.lua by Phenomenon
-- http://wolfwiki.anime.net/index.php/User:Phenomenon
--

MODULE_VERSION = "0.1"
EV_GENERAL_SOUND = 51
EV_GLOBAL_CLIENT_SOUND = 54
CON_DISCONNECTED = 0

function et_InitGame(leveltime, randomseed, restart)
	et.RegisterModname(string.format("playsoundcmd-v%s", MODULE_VERSION))
end

function et_ConsoleCommand()
	local command = string.lower(et.trap_Argv(0))
	
	if command == "playsound" or command == "playsound_env" then
		playsound_command()
		return 1
	end
	
	return 0
end

function playsound_command()
	if et.trap_Argc() < 2 then
		et.G_Print("^ousage: ^7playsound ^7[^fname^7|^fslot#^7] ^7[^fsound^7]\n")
		return
	end
	
	if et.trap_Argc() > 2 then
		local clientlist = client_numbers_from_string(et.trap_Argv(1))
		
		if table.getn(clientlist) ~= 1 then
			et.G_Print(string.format("^oplaysound: %s", match_one_client(clientlist)))
			return
		end
		
		local soundindex = et.G_SoundIndex(et.trap_Argv(2))
		
		if string.lower(et.trap_Argv(0)) == "playsound_env" then
			et.G_AddEvent(clientlist[1], EV_GENERAL_SOUND, soundindex)
		else
			local tempentity = et.G_TempEntity(et.gentity_get(clientlist[1], "r.currentOrigin"), EV_GLOBAL_CLIENT_SOUND)
			et.gentity_set(tempentity, "s.teamNum", clientlist[1])
			et.gentity_set(tempentity, "s.eventParm", soundindex)
		end
	else
		et.G_globalSound(et.trap_Argv(1))
	end
end

function client_numbers_from_string(partofname)
	local clientlist, index, maxclients = {}, 1, tonumber(et.trap_Cvar_Get("sv_maxclients"))
	
	table.setn(clientlist, 0)
	
	if tonumber(partofname) then
		local clientnum = tonumber(partofname)
		
		if clientnum >= 0 and clientnum < maxclients then
			if et.gentity_get(clientnum, "pers.connected") ~= CON_DISCONNECTED then
				clientlist[index] = clientnum
				table.setn(clientlist, index)
				return clientlist
			end
		end
	end
	
	local cleanpartofname = sanitize_string(partofname)
	
	if string.len(cleanpartofname) < 1 then
		return clientlist
	end
	
	for clientnum = 0, maxclients - 1, 1 do
		if et.gentity_get(clientnum, "pers.connected") ~= CON_DISCONNECTED then
			if string.find(sanitize_string(et.gentity_get(clientnum, "pers.netname")), cleanpartofname) then
				clientlist[index] = clientnum
				table.setn(clientlist, index)
				index = index + 1
			end
		end
	end
	
	return clientlist
end

function sanitize_string(str)
	return trim(string.lower(et.Q_CleanStr(str)))
end

function trim(str)
	str = string.gsub(str, "^%s+", "")
	str = string.gsub(str, "%s+$", "")
	return str
end

function match_one_client(clientlist)
	if table.getn(clientlist) == 0 then
		return "^7no ^7connected ^7player ^7by ^7that ^7name ^7or ^7slot#\n"
	end
	
	if table.getn(clientlist) > 1 then
		local message = "^7more ^7than ^7one ^7player ^7name ^7matches. ^7be ^7more ^7specific ^7or ^7use ^7the ^7slot#:\n"
		
		for index, clientnum in ipairs(clientlist) do
			message = string.format("%s^7%2i ^7- ^7%s\n", message, clientnum, fix_ending_caret(et.gentity_get(clientnum, "pers.netname")))
		end
		
		return message
	end
end

function fix_ending_caret(str)
	return string.gsub(str, "%^$", "^^ ")
end