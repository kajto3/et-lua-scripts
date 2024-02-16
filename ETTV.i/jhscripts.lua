--[[module_name	= "JHMOD"
WebSite	= "http://jumptohistory.info/"]]

AUTO_FOLLOW_DEFAULT = true
FOLLOW_SEARCH = true
VOTE_HANDLE = 2
REVIVE_HEALTH_MANAGEMENT = true
ALLOW_SWITCHING_POSITIONS = true

VOTE_PERCENT = 65
VOTE_HESITATION = 1200
REVIVE_INVUL = 2500
--REVIVE_ADREN = 3000
REVIVE_BASE_HEALTH = 65
SWITCH_SECONDS = 10

-------------------------------------------------
-- No need to change these
-------------------------------------------------
--require("etconst")
et.CS_VOTE_TIME =     6
et.CS_VOTE_STRING =     7
et.CS_VOTE_YES =      8
et.CS_VOTE_NO =      9
et.CS_PLAYERS = 689

GS_PLAYING = 0
GS_WARMUP = 2
GS_INTERMISSION = 3
GS_RESET = 5

GT_WOLF_CAMPAIGN = 4

EV_GENERAL_SOUND = 51
EV_MEDIC_CALL = 129

NAME_NO_MATCH = -1
NAME_MULTIPLE_MATCH = -2
NAME_TOO_SHORT_KEYWORD = -3
VOTE_YES = 1
VOTE_NO = 2
VOTE_ABSTAIN = 3
SWITCH_ERROR_SPECTATOR = 1
AUTO_FOLLOW_ALWAYS = 2
LOAD_AT_ANOTHER_PLAYER = -1

WP_MP40 = 3
WP_PANZERFAUST = 5
WP_FLAMETHROWER = 6
WP_THOMPSON = 8
WP_STEN = 10
WP_GARAND = 25
WP_MOBILE_MG42 = 31
WP_K43 = 32
WP_FG42 = 33
WP_MORTAR = 35

BUTTON_ACTIVATE = 64

PW_NOFATIGUE = 5
PW_ADRENALINE = 12

STAT_MAX_HEALTH = 4
-------------------------------------------------

INT_MAX = 2147483647

max_clients = tonumber(et.trap_Cvar_Get("sv_maxclients"))
gamestate = tonumber(et.trap_Cvar_Get("gamestate"))
voter_list = {}
vote = {yes = 0, no = 0, players = 0, limit = 3, perSeconds = 200}
vote2 = {yes = 0, no = 0, players = 0, time = -30000, faded = 0, }
VOTE_INTERVAL = 600
player_list = {}
revived_players = {}

function et_InitGame(levelTime, randomSeed, restart)
	et.RegisterModname("Jump to History!!")
	
	--math.randomseed(randomSeed)
	mapname = et.trap_Cvar_Get("mapname")
	mapname_lower = string.lower(mapname)

	et.trap_SendConsoleCommand(et.EXEC_APPEND, "; loadmaplua;")
	
	if VOTE_HANDLE and et.trap_Cvar_Get("jh_voteHandle") == "" then
		et.trap_Cvar_Set("jh_voteHandle", VOTE_HANDLE)
	end
	if et.trap_Cvar_Get("jh_allowSwitch") == "" then
		et.trap_Cvar_Set("jh_allowSwitch", "1")
	end
	if et.trap_Cvar_Get("jh_gametype") == "" then
		et.trap_Cvar_Set("jh_gametype", "2")
	end
end

function et_ClientConnect(clientNum, firstTime, isBot)
	player_list[clientNum] = {}
	player_list[clientNum].specClient = nil
	player_list[clientNum].specState = nil
	player_list[clientNum].autoFollow = AUTO_FOLLOW_DEFAULT
	player_list[clientNum].health = 0
	player_list[clientNum].reduceDamage = nil
	player_list[clientNum].down = false
	player_list[clientNum].switch = {}
	player_list[clientNum].adrenSpawn = true
	player_list[clientNum].nofatigue = false
	player_list[clientNum].sessionTeam = 3
	--player_list[clientNum].cheatAdren = false
	--player_list[clientNum].down = false
	--player_list[clientNum].loadViewangles = false
	voter_list[clientNum] = {}
	voter_list[clientNum].count = 0
	voter_list[clientNum].callvotesLeft = vote.limit

	function GetClientInfoFromCvar()
		if et.Info_ValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "adrenSpawn") == "false" then
			player_list[clientNum].adrenSpawn = false
		end
		if et.Info_ValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "loadViewangles") == "true" then
			player_list[clientNum].loadViewangles = true
		end
		if et.Info_ValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "nofatigue") == "true" then
			player_list[clientNum].nofatigue = true
		end
		if et.Info_ValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "cheatAdren") == "true" then
			player_list[clientNum].cheatAdren = true
		end
	end
		
	if et.trap_Cvar_Get("jh_saveRestore") == "1" then
		local userinfo = et.trap_GetUserinfo(clientNum)
		local ip = et.Info_ValueForKey(userinfo, "ip")
		local guid = et.Info_ValueForKey(userinfo, "cl_guid")
		local playerKey
		
		if string.len(guid) == 32 then
			playerKey = guid
		else
			playerKey = ip
		end
		
		if player_list[playerKey] then
			for j = 1, 3 do
				player_list[clientNum][j] = player_list[playerKey][j]
			end
			et.trap_Cvar_Set("jhmod_clientInfo" .. clientNum, et.Info_SetValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "adrenSpawn", tostring(player_list[clientNum].adrenSpawn)))
			et.trap_Cvar_Set("jhmod_clientInfo" .. clientNum, et.Info_SetValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "loadViewangles", tostring(player_list[clientNum].loadViewangles)))
		else
			for j = 1, 3 do
				player_list[clientNum][j] = {}
			end
			if firstTime == 0 then
				if gamestate ~= GS_PLAYING then
					et.trap_Cvar_Set("jhmod_clientInfo" .. clientNum, et.Info_SetValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "nofatigue", ""))
					et.trap_Cvar_Set("jhmod_clientInfo" .. clientNum, et.Info_SetValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "cheatAdren", ""))
				end
				GetClientInfoFromCvar()
			end
		end
	else
		for j = 1, 3 do
			player_list[clientNum][j] = {}
		end
		GetClientInfoFromCvar()
	end

	if et.trap_Cvar_Get("jh_voteLimitRestore") == "1" then
		local userinfo = et.trap_GetUserinfo(clientNum)
		local ip = et.Info_ValueForKey(userinfo, "ip")
		local guid = et.Info_ValueForKey(userinfo, "cl_guid")
		local playerKey
		
		if string.len(guid) == 32 then
			playerKey = guid
		else
			playerKey = ip
		end
		
		if voter_list[playerKey] then
			voter_list[clientNum].callvotesLeft = voter_list[playerKey].callvotesLeft
			voter_list[clientNum].nextIncr = voter_list[playerKey].nextIncr
		end
	end

end

function et_ClientDisconnect(clientNum)
	local userinfo = et.trap_GetUserinfo(clientNum)
	local guid = et.Info_ValueForKey(userinfo, "cl_guid")
	player_list[clientNum].specClient = nil
	player_list[clientNum].specState = nil
	player_list[clientNum].autoFollow = AUTO_FOLLOW_DEFAULT
	player_list[clientNum].reduceDamage = nil
	player_list[clientNum].switchto = nil
	player_list[clientNum].name = nil
	
	if et.trap_Cvar_Get("jh_saveRestore") == "1" then
		local playerKey
		
		if string.len(guid) == 32 then
			playerKey = guid
		else
			playerKey = et.Info_ValueForKey(userinfo, "ip")
		end
		
		if player_list[playerKey] == nil then
			player_list[playerKey] = {}
		end
		for j = 1, 3 do
			player_list[playerKey][j] = player_list[clientNum][j]
		end
		player_list[playerKey].adrenSpawn = player_list[clientNum].adrenSpawn
		player_list[playerKey].loadViewangles = player_list[clientNum].loadViewangles
	end
	if et.trap_Cvar_Get("jh_voteLimitRestore") == "1" then
		local playerKey
		
		if string.len(guid) == 32 then
			playerKey = guid
		else
			playerKey = et.Info_ValueForKey(userinfo, "ip")
		end
		
		if voter_list[playerKey] == nil then
			voter_list[playerKey] = {}
		end
		voter_list[playerKey].callvotesLeft = voter_list[clientNum].callvotesLeft
		voter_list[playerKey].nextIncr = voter_list[clientNum].nextIncr
	end
	
	for i = 0, max_clients - 1 do
		if player_list[i] then
			if player_list[i].nextStalk == clientNum then
				player_list[i].nextStalk = nil
			end
			if et.gentity_get(i, "sess.sessionTeam") == 3 and et.gentity_get(i, "sess.spectatorClient") == clientNum then
				if player_list[i].nextStalk then
					et.gentity_set(i, "sess.latchSpectatorClient", player_list[i].nextStalk)
					player_list[i].specClient = player_list[i].nextStalk
					player_list[i].nextStalk = nil
				end
				player_list[i].specState = et.gentity_get(i, "sess.spectatorState")
				player_list[i].specReleasingTime = et_level_time
			end
		end
	end
	
	if vote.inProgress then
		voter_list[clientNum].vote = nil
		CountVotes()
	end
	if vote2.time >= 0 then
		voter_list[clientNum].vote = nil
		CountVotes2()
	end
	
	et.trap_Cvar_Set("jhmod_clientInfo" .. clientNum, "")
	player_list[clientNum] = nil
	voter_list[clientNum] = nil
end

function et_ClientUserinfoChanged(clientNum)

	if not IsIDNamesEnabled() then
		-- a number that could be a client number should not be used for a player name
		-- due to ref command issue
		local userinfo = et.trap_GetUserinfo(clientNum)
		local name = et.Q_CleanStr(et.Info_ValueForKey(userinfo, "name"))
		if tonumber(name) and tonumber(name) >= 0 and tonumber(name) < max_clients and string.find(name, "%.") == nil and string.find(name, "-") == nil then
			local nf,nt = string.find(name, "%d+")
			local zf,zt = string.find(name, "0")
			if nf ~= zf or nt - zt == 0 then
				name = "^9<" .. name .. "^9>"
				userinfo = et.Info_SetValueForKey(userinfo, "name", name)
				et.trap_SetUserinfo(clientNum, userinfo)
				et.ClientUserinfoChanged(clientNum)
			end
		end
	end
end

function et_ClientCommand(clientNum, command)
	local cmd = string.lower(command)
	local arg1 = string.lower(et.trap_Argv(1))
	local argList = GetArgList(et.ConcatArgs(0))
	local concatArgs1 = et.ConcatArgs(1)
	
	if cmd == "say" then
		if argList[1] == nil or et.gentity_get(clientNum, "sess.muted") == 1 then
			return 0
		end
		
		local argListLower = {}
		for key,value in pairs(argList) do
			argListLower[key] = string.lower(value)
		end
		
		if argList[2] and (argListLower[1] == "!switch" or argListLower[1] == "!swap") and ALLOW_SWITCHING_POSITIONS and et.trap_Cvar_Get("jh_allowSwitch") == "1" then
			local num = tonumber(argList[2])
			if not (num and num >= 0 and num < max_clients) or string.len(argList[2]) > 2 or string.find(argList[2], "%.") or argList[3] then
				local f,t = string.find(et.ConcatArgs(1), "%s+")
				local name = string.sub(et.ConcatArgs(1), t+1)
				num = SearchForClient(name)
			end
			if num == NAME_MULTIPLE_MATCH then
				et.trap_SendServerCommand(clientNum, "chat \"More than 1 player found.\"")
				return 1
			elseif num == NAME_TOO_SHORT_KEYWORD then
				et.trap_SendServerCommand(clientNum, 'chat "Too short keyword."')
				return 1
			elseif num < 0 or not player_list[num] then
				et.trap_SendServerCommand(clientNum, 'chat "Player not found."')
				return 1
			end
			
			et.trap_SendServerCommand(-1, string.format("c %d \"%s\"", clientNum, concatArgs1))
			ReadyToSwitch(clientNum, num, SWITCH_SECONDS)
			return 1
		elseif argListLower[1] == "!unswitch" or argListLower[1] == "!noswitch" or argListLower[1] == "!cancel" then
			player_list[clientNum].switch.cnum = nil
			et.trap_SendServerCommand(-1, string.format('chat "%s"', argList[1]))
			et.trap_SendServerCommand(clientNum, 'chat "Canceled switching."')
		elseif argListLower[1] == "!save" and et.trap_Cvar_Get("jh_temporalSave") == "1" then
			local concatArgs = et.ConcatArgs(1)
			local saveNum = tonumber(argList[2])
			if saveNum == nil then
				saveNum = 0
			end
			if player_list[clientNum].maxLoads and saveNum ~= 0 or saveNum < 0 or saveNum > 3 then
				et.trap_SendServerCommand(clientNum, "cp \"^3Invalid save slot.\n\"")
				return 1
			end
			
			local maxLoadsBak = player_list[clientNum].maxLoads
			if player_list[clientNum].maxLoads then
				player_list[clientNum].maxLoads = player_list[clientNum].maxLoads + 1
			end
			if SavePosition(clientNum, saveNum, true) then
				et.trap_SendServerCommand(-1, string.format("c %d \"%s\"", clientNum, concatArgs))

				et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format(";putspec %d;", clientNum))
				if saveNum == 0 then
					et.trap_SendServerCommand(-1, "chat \"Saved\"")
				else
					et.trap_SendServerCommand(-1, string.format("chat \"Saved %d\"", saveNum))
				end
			end
			player_list[clientNum].maxLoads = maxLoadsBak
			return 1
		elseif argListLower[1] == "!load" and et.trap_Cvar_Get("jh_temporalSave") == "1" then
			local concatArgs = et.ConcatArgs(1)
			local team, class, saveNum = -1, -1, -1
			local loadRet
			
			if argList[2] then
				if argListLower[2] == "axis" then
					team = 1
				elseif argListLower[2] == "allies" then
					team = 2
				end
			end
			if team == 1 or team == 2 then
				if argList[3] then
					if argListLower[3] == "s" then
						class = 0
					elseif argListLower[3] == "m" then
						class = 1
					elseif argListLower[3] == "e" then
						class = 2
					elseif argListLower[3] == "f" then
						class = 3
					elseif argListLower[3] == "c" then
						class = 4
					end
				end
				saveNum = tonumber(argList[4])
				if saveNum == nil then
					saveNum = 0
				elseif saveNum < 0 or saveNum > 3 then
					return 1
				end
				
				player_list[clientNum].onceLoadViewangles = true
				loadRet = LoadPosition(clientNum, saveNum, {team = team, class = class})
				if loadRet == false then
					et.trap_SendServerCommand(clientNum, "cp \"Use save first\n\"")
					return 1
				elseif loadRet == LOAD_AT_ANOTHER_PLAYER then
					et.trap_SendServerCommand(clientNum, "cp \"There's another player where you're trying to load.\n\"")
					return 1
				end
			else
				team = player_list[clientNum].sessionTeam
				class = player_list[clientNum].playerType
				saveNum = tonumber(argList[2])
				if saveNum == nil then
					if argList[2] then
						return 1
					end
					saveNum = 0
				elseif saveNum < 0 or saveNum >3 then
					return 1
				end
				
				player_list[clientNum].onceLoadViewangles = true
				loadRet = LoadPosition(clientNum, saveNum)
				if loadRet == false then
					et.trap_SendServerCommand(clientNum, "cp \"Use save first\n\"")
					return 1
				elseif loadRet == LOAD_AT_ANOTHER_PLAYER then
					et.trap_SendServerCommand(clientNum, "cp \"There's another player where you're trying to load.\n\"")
					return 1
				end
			end
			
			if loadRet == true then
				player_list[clientNum][team][class][saveNum] = nil
				et.trap_SendServerCommand(-1, string.format("c %d \"%s\"", clientNum, concatArgs))
				et.trap_SendServerCommand(-1, "chat \"Loaded position and the save was removed\"")
			end
			return 1
		elseif argListLower[1] == "!mapinfo" or argListLower[1] == "!minfo" then
			if player_list[clientNum].nextMapinfo and player_list[clientNum].nextMapinfo + 500 > et_level_time then
				et.trap_SendServerCommand(clientNum, string.format("cpm \"^3mapinfo: ^7Wait %s seconds to use again\"", math.ceil((player_list[clientNum].nextMapinfo + 500 - et_level_time) / 1000)))
				return 1
			end
			et.trap_SendServerCommand(-1, string.format("c %d \"%s\"", clientNum, concatArgs1))
			
			local function SendPakInfo(pak)
				local size
				if pak.size >= 1048576 then
					size = string.format("%.1f", pak.size / 1024 / 1024) .. "MB"
				else
					size = string.format("%d", (pak.size / 1024)) .. "KB"
				end
				et.trap_SendServerCommand(-1, string.format("chat \"^fpak^*: %s  ^fsize^*: %s\"", pak.basename, size))
			end

			local info
			if argList[2] then
				local f, t, str = string.find(concatArgs1, argList[1] .. "%s+(.*)")
				info = MapInfo(str)
			else
				info = MapInfo(mapname)
			end
			if info.map then
				info.briefing = string.gsub(info.briefing, "\\n\\n", " \n")
				info.briefing = string.gsub(info.briefing, "\\n", " ")
				et.trap_SendServerCommand(-1, string.format("chat \"^xmap^*: %s  ^xlongname^*: %s\"", info.map, info.longname))
				if info.pak then
					SendPakInfo(info.pak)
				end
				et.trap_SendServerCommand(-1, string.format("chat \"%s\"", info.briefing))
			else
				if argList[2] then
					if string.len(info.findmap) == 0 then
						return 1
					end
					if info.pak then
						et.trap_SendServerCommand(-1, string.format("chat \"^9map^*: %s\"", argList[2]))
						SendPakInfo(info.pak)
					else
						et.trap_SendServerCommand(-1, string.format("chat \"%s\"", info.findmap))
					end
				else
					et.trap_SendServerCommand(-1, string.format("chat \"^9map^*: %s\"", mapname))
					SendPakInfo(info.pak)
				end
			end
			
			player_list[clientNum].nextMapinfo = et_level_time + 500
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setfindmaptime %d 250", clientNum))
			return 1
		elseif argListLower[1] == "!findmap" then
			if player_list[clientNum].nextMapinfo and player_list[clientNum].nextMapinfo > et_level_time then
				et.trap_SendServerCommand(clientNum, string.format("cpm \"^3findmap: ^7Wait %s seconds to use again\"", math.ceil((player_list[clientNum].nextMapinfo + 500 - et_level_time) / 1000)))
				return 1
			end
			et.trap_SendServerCommand(-1, string.format("c %d \"%s\"", clientNum, et.ConcatArgs(1)))
			if argList[2] then
				local f, t, str = string.find(concatArgs1, argList[1] .. "%s+(.*)")
				et.trap_Cvar_Set("returnvalue", "")
				et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("findmap r %s", str))
				et.trap_SendServerCommand(-1, string.format("chat \"%s\"", et.trap_Cvar_Get("returnvalue")))
				player_list[clientNum].nextMapinfo = et_level_time + 500
				et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setfindmaptime %d 500", clientNum))
			end
			return 1
		elseif argListLower[1] == "!listmaps" then
			et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; chat %d \"See console for listed maps.\"; listmaps %d;", clientNum, clientNum))
		elseif argListLower[1] == "!maplist"  then
			et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; chat %d \"See console for full maplist.\"; maplist %d;", clientNum, clientNum))
		elseif argListLower[1] == "!physics" then
			if player_list[clientNum].nextMapinfo and player_list[clientNum].nextMapinfo > et_level_time then
				et.trap_SendServerCommand(clientNum, string.format("cpm \"^3physics: ^7Wait %s seconds to use again\"", math.ceil((player_list[clientNum].nextMapinfo + 500 - et_level_time) / 1000)))
				return 1
			end
			et.trap_SendServerCommand(-1, string.format("c %d \"%s\"", clientNum, et.ConcatArgs(1)))
			local g_gravity, g_speed, pmove_msec = et.trap_Cvar_Get("g_gravity"), et.trap_Cvar_Get("g_speed"), et.trap_Cvar_Get("pmove_msec")
			local gravity, speed, pmMsec
			if tonumber(g_gravity) == 800 then
				gravity = "800 ^7(default)"
			else
				gravity = "=22" .. g_gravity .. "=22"
			end
			if tonumber(g_speed) == 320 then
				speed = "320 ^7(default)"
			else
				speed = "=22" .. g_speed .. "=22"
			end
			if tonumber(pmove_msec) == 8 then
				pmMsec = "8 ^7(default)"
			else
				pmMsec = "=22" .. pmove_msec .. "=22"
			end
			et.trap_SendServerCommand(-1, string.format("chat \"^5g_gravity: ^7%s  ^5g_speed: ^7%s  ^5pmove_msec: ^7%s", gravity, speed, pmMsec))
			player_list[clientNum].nextMapinfo = et_level_time + 500
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setfindmaptime %d 500", clientNum))
			return 1
		end
	elseif cmd == "team" then
		if player_list[clientNum].switchto and not (arg1 == "s" or arg1 == "spectator") then
			return 1
		end
		player_list[clientNum].switchto = nil
		--[[player_list[clientNum].switchto = nil
		et.trap_SendServerCommand(clientNum, "chat \"Switch failed due to player changing team or class.\n\"")]]
		player_list[clientNum].specState = nil
	elseif cmd == "noclip" then
		local sv_cheats = tonumber(et.trap_Cvar_Get("sv_cheats"))
		if sv_cheats and math.abs(sv_cheats) >= 1 then
			player_list[clientNum].noclipped = true
		end
		return 0
	elseif cmd == "warp" then
		local sv_cheats = tonumber(et.trap_Cvar_Get("sv_cheats"))
		if sv_cheats and math.abs(sv_cheats) >= 1 then
			local originTo = {tonumber(arg1), tonumber(et.trap_Argv(2)), tonumber(et.trap_Argv(3))}
			if originTo[1] and originTo[2] and originTo[3] then
				player_list[clientNum].noclipped = true
				et.gentity_set(clientNum, "origin", originTo)
			end
			return 1
		end
	elseif cmd == "callvote2" and et.trap_Cvar_Get("jh_voteHandle2") == "1" or (cmd == "callvote" and et.trap_Cvar_Get("jh_voteHandle") == "2") and VOTE_HANDLE then
		if tonumber(et.trap_GetConfigstring(et.CS_VOTE_TIME)) and et_level_time <= tonumber(et.trap_GetConfigstring(et.CS_VOTE_TIME)) + 30000 then
			if clientNum then
				et.trap_SendServerCommand(clientNum, "cpm \"A vote is already in progress.\n\"")
			end
			return 1
		elseif clientNum and voter_list[clientNum].callvotesLeft < 1 then
			et.trap_SendServerCommand(clientNum, string.format("cpm \"Wait %d seconds to call another vote.\n\"", math.ceil((voter_list[clientNum].nextIncr - et_level_time) / 1000)))
			return 1
		else
			local function InitVote2()
				vote2.called = argList
				vote2.called[1] = arg1
				vote2.time = et_level_time - 15000
				vote2.timeCalled = et_level_time
				vote2.caller = clientNum
				ResetVoteFlags()
				et.G_globalSound("sound/misc/vote.wav")
				et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
				et.trap_SendConsoleCommand(et.EXEC_APPEND, "; removevoteflags;")  -- ET needs to be modified to use this
			end
			local function ShowDisabledMessage()
				if clientNum then
					et.trap_SendServerCommand(clientNum, string.format("cpm \"Sorry, ^3%s ^7voting has been disabled\n\"", arg1))
				end
			end
			local votingFor
			if arg1 == "map" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_map"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					if argList[2] then
						local fd, len = et.trap_FS_FOpenFile(string.format("maps/%s.bsp", argList[2]), et.FS_READ)
						if len < 0 and et.trap_Cvar_Get("jh_mapVoteFun") ~= "1" and clientNum then
							et.trap_Cvar_Set("returnvalue", "")
							et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("findmap r %s", argList[2]))
							local rv = et.trap_Cvar_Get("returnvalue")
							if string.find(rv, "findmap:") then
								et.trap_SendServerCommand(clientNum, string.format("print \"^3%s ^7is not on the server\nUse /^3listmaps ^7or /^3findmap\n\"", argList[2]))
							else
								et.trap_SendServerCommand(clientNum, string.format("print \"^3%s ^7is not on the server\nDid you mean:\n%s\n\"", argList[2], rv))
							end
						else
							et.trap_FS_FCloseFile(fd)
							InitVote2()
							votingFor = string.format("Change map to %s", argList[2])
						end
					elseif clientNum then
						et.trap_SendServerCommand(clientNum, string.format("print \"^2map ^7is currently ^3%s\n\"", mapname))
					end
				elseif clientNum then
					ShowDisabledMessage()
					et.trap_SendServerCommand(clientNum, string.format("print \"^2map ^7is currently ^3%s\n\"", mapname))
				end
			elseif arg1 == "campaign" and argList[2] then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_map"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					if argList[2] then
						InitVote2()
						votingFor = string.format("Change campaign to %s", argList[2])
					end
				else
					ShowDisabledMessage()
				end
			elseif arg1 == "timelimit" then
				local currentTimelimit = tonumber(et.trap_Cvar_Get("timelimit"))
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_timelimit"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					local timelimit = tonumber(argList[2])
					if timelimit and timelimit ~= currentTimelimit then
						InitVote2()
						if currentTimelimit and currentTimelimit ~= 0 and timelimit >= currentTimelimit or timelimit == 0 then
							vote2.time = et_level_time - 20000
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
						end
						votingFor = string.format("Timelimit %s", timelimit)
					elseif clientNum then
						et.trap_SendServerCommand(clientNum, string.format("cpm \"^2timelimit ^7is currently ^3%d\n\"", currentTimelimit))
					end
				elseif clientNum then
					ShowDisabledMessage()
					et.trap_SendServerCommand(clientNum, string.format("print \"^2timelimit ^7is currently ^3%d\n\"", currentTimelimit))
				end
			elseif arg1 == "friendlyfire" then
				local friendlyFire = tonumber(et.trap_Cvar_Get("g_friendlyFire"))
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_friendlyfire"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					if argList[2] == "1" then
						if friendlyFire and math.abs(friendlyFire) >= 1 then
							if clientNum then
								et.trap_SendServerCommand(clientNum, "print \"^3friendlyfire ^5is already ENABLED!\n\"")
							end
						else
							InitVote2()
							vote2.time = et_level_time - 20000
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
							votingFor = "Friendly Fire ACTIVATED"
						end
					elseif argList[2] == "0" then
						if friendlyFire and math.abs(friendlyFire) >= 1 then
							InitVote2()
							vote2.time = et_level_time - 20000
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
							votingFor = "Friendly Fire DEACTIVATED"
						elseif clientNum then
							et.trap_SendServerCommand(clientNum, "print \"^3friendlyfire ^5is already DISABLED!\n\"")
						end
					elseif clientNum then
						et.trap_SendServerCommand(clientNum, "print \"Usage: ^3\\callvote friendlyfire <0|1>\n\"")
						if friendlyFire and math.abs(friendlyFire) >= 1 then
							et.trap_SendServerCommand(clientNum, "print \"^2friendlyfire ^7is currently ^3ENABLED\n\"")
						else
							et.trap_SendServerCommand(clientNum, "print \"^2friendlyfire ^7is currently ^3DISABLED\n\"")
						end
					end
				elseif clientNum then
					ShowDisabledMessage()
					if friendlyFire and math.abs(friendlyFire) >= 1 then
						et.trap_SendServerCommand(clientNum, "print \"^2friendlyfire ^7is currently ^3ENABLED\n\"")
					else
						et.trap_SendServerCommand(clientNum, "print \"^2friendlyfire ^7is currently ^3DISABLED\n\"")
					end
				end
			elseif arg1 == "saveload" or arg1 == "save" then
				local saveLoad = et.trap_Cvar_Get("jh_saveload")
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_saveload"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					if argList[2] == "1" then
						if saveLoad == "1" and saveMaxUPS and saveMaxUPS > 0 and saveMaxUPS <= 300 then
							if clientNum then
								et.trap_SendServerCommand(clientNum, "print \"^3saveload ^5is already ENABLED!\n\"")
							end
						else
							InitVote2()
							vote2.called[1] = "saveload"
							vote2.time = et_level_time - 20000
							if et.trap_Cvar_Get("jh_nosaveload") == "1" then
								votingFor = "Save/Load ACTIVATED (for noobs only)"
								vote2.time = et_level_time - 20000
							else
								votingFor = "Save/Load ACTIVATED"
							end
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
						end
					elseif argList[2] == "0" then
						if saveLoad ~= "0" then
							InitVote2()
							vote2.called[1] = "saveload"
							vote2.time = et_level_time - 20000
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
							votingFor = "Save/Load DEACTIVATED"
						elseif clientNum then
							et.trap_SendServerCommand(clientNum, "print \"^3saveload ^5is already DISABLED!\n\"")
						end
					elseif clientNum then
						et.trap_SendServerCommand(clientNum, "print \"Usage: ^3\\callvote saveload <0|1>\n\"")
						if saveLoad == "1" then
							et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3ENABLED\n\"")
						else
							et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3DISABLED\n\"")
						end
					end
				elseif clientNum then
					ShowDisabledMessage()
					if saveLoad == "1" then
						et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3ENABLED\n\"")
					else
						et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3DISABLED\n\"")
					end
				end
			elseif arg1 == "axissaveload" or arg1 == "axissave" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_teamSaveload"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					if argList[2] == "1" then
						if axis_save_load ~= false then
							if clientNum then
								et.trap_SendServerCommand(clientNum, "print \"^3saveload ^5is already ENABLED!\n\"")
							end
						else
							InitVote2()
							vote2.called[1] = "axissaveload"
							vote2.time = et_level_time - 20000
							if axis_no_save_load then
								votingFor = "Save/Load for Axis ACTIVATED (for noobs)"
								vote2.time = et_level_time - 20000
							else
								votingFor = "Save/Load for Axis ACTIVATED"
							end
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
						end
					elseif argList[2] == "0" then
						if saveLoad ~= "0" then
							InitVote2()
							vote2.called[1] = "axissaveload"
							vote2.time = et_level_time - 20000
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
							votingFor = "Save/Load for Axis DEACTIVATED"
						elseif clientNum then
							et.trap_SendServerCommand(clientNum, "print \"^3saveload ^5is already DISABLED!\n\"")
						end
					elseif clientNum then
						et.trap_SendServerCommand(clientNum, "print \"Usage: ^3\\callvote saveload <0|1>\n\"")
						if saveLoad == "1" then
							et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3ENABLED\n\"")
						else
							et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3DISABLED\n\"")
						end
					end
				elseif clientNum then
					ShowDisabledMessage()
					if saveLoad == "1" then
						et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3ENABLED\n\"")
					else
						et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3DISABLED\n\"")
					end
				end				
			elseif arg1 == "alliedsaveload" or arg1 == "alliedsave" or arg1 == "alliessaveload" or arg1 == "alliessave" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_teamSaveload"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					if argList[2] == "1" then
						if allied_save_load ~= false then
							if clientNum then
								et.trap_SendServerCommand(clientNum, "print \"^3saveload ^5is already ENABLED!\n\"")
							end
						else
							InitVote2()
							vote2.called[1] = "alliedsaveload"
							vote2.time = et_level_time - 20000
							if allied_no_save_load then
								votingFor = "Save/Load for Allies ACTIVATED (for noobs)"
								vote2.time = et_level_time - 20000
							else
								votingFor = "Save/Load for Allies ACTIVATED"
							end
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
						end
					elseif argList[2] == "0" then
						if saveLoad ~= "0" then
							InitVote2()
							vote2.called[1] = "alliedsaveload"
							vote2.time = et_level_time - 20000
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
							votingFor = "Save/Load for Allies DEACTIVATED"
						elseif clientNum then
							et.trap_SendServerCommand(clientNum, "print \"^3saveload ^5is already DISABLED!\n\"")
						end
					elseif clientNum then
						et.trap_SendServerCommand(clientNum, "print \"Usage: ^3\\callvote saveload <0|1>\n\"")
						if saveLoad == "1" then
							et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3ENABLED\n\"")
						else
							et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3DISABLED\n\"")
						end
					end
				elseif clientNum then
					ShowDisabledMessage()
					if saveLoad == "1" then
						et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3ENABLED\n\"")
					else
						et.trap_SendServerCommand(clientNum, "print \"^2saveload ^7is currently ^3DISABLED\n\"")
					end
				end				
			elseif arg1 == "numberednames" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_numberednames"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					if argList[2] == "1" then
						if IsIDNamesEnabled() then
							if clientNum then
								et.trap_SendServerCommand(clientNum, "print \"^3numberednames ^7is already ENABLED!\n\"")
							end
						else
							InitVote2()
							vote2.time = et_level_time - 20000
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
							votingFor = "Numbered Names ACTIVATED"
						end
					elseif argList[2] == "0" then
						if IsIDNamesEnabled() then
							InitVote2()
							vote2.time = et_level_time - 20000
							et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
							votingFor = "Numbered Names DEACTIVATED"
						elseif clientNum then
							et.trap_SendServerCommand(clientNum, "print \"^3numberednames ^7is already DISABLED!\n\"")
						end
					elseif clientNum then
						local numberednames = tonumber(et.trap_Cvar_Get("sv_numberedNames"))
						et.trap_SendServerCommand(clientNum, "print \"Usage: ^3\\callvote numberednames <0|1>\n\"")
						if numberednames and math.abs(numberednames) >= 1 then
							et.trap_SendServerCommand(clientNum, "print \"^2numberednames ^7is currently ^3ENABLED\n\"")
						else
							et.trap_SendServerCommand(clientNum, "print \"^2numberednames ^7is currently ^3DISABLED\n\"")
						end
					end
				else
					ShowDisabledMessage()
				end
			elseif arg1 == "maprestart" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_maprestart"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					InitVote2()
					votingFor = "Map Restart"
				else
					ShowDisabledMessage()
				end
			elseif arg1 == "nextmap" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_nextmap"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					if tonumber(et.trap_Cvar_Get("g_gametype")) == GT_WOLF_CAMPAIGN then
						local nextcamp = et.trap_Cvar_Get("nextcampaign")
						if nextcamp ~= "" then
							InitVote2()
							votingFor = "Load Next Map"
						elseif clientNum then
							et.trap_SendServerCommand(clientNum, "cpm \"'nextcampaign' is not set.\n\"")
						end
					else
						local nextmap = et.trap_Cvar_Get("nextmap")
						if nextmap ~= "" and string.lower(nextmap) ~= "map_restart 0" then
							InitVote2()
							votingFor = "Load Next Map"
						elseif clientNum then
							et.trap_SendServerCommand(clientNum, "cpm \"'nextmap' is not set.\n\"")
						end
					end
				else
					ShowDisabledMessage()
				end
			elseif arg1 == "gametype" then
				local function ShowCurrentGametype()
					local g_gametype = math.floor(tonumber(et.trap_Cvar_Get("g_gametype")))
					local currentType
					if g_gametype == 2 then
						currentType = "2 (Objective)"
					elseif g_gametype == 3 then
						currentType = "3 (Stopwatch)"
					elseif g_gametype == 4 then
						currentType = "4 (Campaign)"
					elseif g_gametype == 5 then
						currentType = "5 (Last Man Standing)"
					end
					if g_gametype and clientNum then
						et.trap_SendServerCommand(clientNum, string.format("print \"^3gametype ^7is currently ^3%s\n\"", currentType))
					end							
				end
				
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_gametype"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					local gametype = tonumber(et.trap_Argv(2))
					if et.trap_Argv(2) == "" then
						ShowCurrentGametype()
					elseif gametype and (gametype == 2 or gametype == 3 or gametype == 5)  then
						local g_gametype = math.floor(tonumber(et.trap_Cvar_Get("g_gametype")))
						if et.trap_Cvar_Get("jh_gametype") == "" then
							et.trap_Cvar_Set("jh_gametype", g_gametype)
						end
						local jh_gametype = tonumber(et.trap_Cvar_Get("jh_gametype"))
						if gametype == 2 then
							if g_gametype == gametype and jh_gametype == gametype then
								if clientNum then
									et.trap_SendServerCommand(clientNum, "cpm \"^3Gametype ^5is already set to Objective!\n\"")
								end
							else
								votingFor = "Set Gametype to Objective"
							end
						elseif gametype == 3 then
							if g_gametype == gametype and jh_gametype == gametype then
								if clientNum then
									et.trap_SendServerCommand(clientNum, "cpm \"^3Gametype ^5is already set to Stopwatch!\n\"")
								end
							else
								votingFor = "Set Gametype to Stopwatch"
							end
						elseif gametype == 5 then
							if g_gametype == gametype and jh_gametype == gametype then
								if clientNum then
									et.trap_SendServerCommand(clientNum, "cpm \"^3Gametype ^5is already set to Last Man Standing!\n\"")
								end
							else
								votingFor = "Set Gametype to Last Man Standing"
							end
						end
						if votingFor then
							InitVote2()
						end
					elseif clientNum then
						et.trap_SendServerCommand(clientNum, string.format("print \"\n^3Invalid gametype: ^7%s\n\"", et.trap_Argv(2)))
						et.trap_SendServerCommand(clientNum, "print \"\nAvailable gametypes:\n--------------------\n\"")
						et.trap_SendServerCommand(clientNum, "print \"  2 ^3(Objective)\n  ^73 ^3(Stopwatch)\n  ^75 ^3(Last Man Standing)\n\n\"")
					end
				elseif clientNum then
					ShowDisabledMessage()
					ShowCurrentGameType()
				end						
			elseif arg1 == "cointoss" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_cointoss"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					InitVote2()
					vote2.time = et_level_time - 15000
					et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
					votingFor = "Config Change?"
				else
					ShowDisabledMessage()
				end
			elseif arg1 == "fun" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_fun"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					local arg2 = string.lower(et.trap_Argv(2))
					if arg2 == "gaychan" or arg2 == "neko" then
						InitVote2()
						vote2.time = et_level_time - 15000
						et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
						vote2.called[2] = arg2
						votingFor = "[???] " .. et.trap_Argv(2)
					end
				else
					ShowDisabledMessage()
				end
			elseif arg1 == "mute" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_muting"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					local targetNum = tonumber(et.ConcatArgs(2))
					if targetNum == nil or targetNum < 0 or string.len(et.ConcatArgs(2)) > 2 or string.find(argList[2], "%.") or (string.find(argList[2], "0") == string.find(argList[2], "%d") and targetNum ~= 0) then
						targetNum = SearchForClient(et.trap_Argv(2))
					end
					if targetNum >= 0 and targetNum < max_clients and et.gentity_get(targetNum, "inuse") then
						if et.gentity_get(targetNum, "sess.muted") == 0 then
							InitVote2()
							vote2.called[2] = targetNum
							if IsIDNamesEnabled() then
								votingFor = string.format("MUTE %s", et.gentity_get(targetNum, "pers.netname"))
							else
								votingFor = string.format("MUTE %d;%s", targetNum, et.gentity_get(targetNum, "pers.netname"))
							end
						elseif clientNum then
							et.trap_SendServerCommand(clientNum, "cpm \"Player is already muted!\n\"")
						end
					end
				else
					ShowDisabledMessage()
				end
			elseif arg1 == "unmute" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_muting"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					local targetNum = tonumber(et.trap_Argv(2))
					if targetNum == nil or targetNum < 0 or string.len(et.ConcatArgs(2)) > 2 or string.find(argList[2], "%.") or (string.find(argList[2], "0") == string.find(argList[2], "%d") and targetNum ~= 0) then
						targetNum = SearchForClient(et.trap_Argv(2))
					end
					if targetNum >= 0 and targetNum < max_clients and et.gentity_get(targetNum, "inuse") then
						if et.gentity_get(targetNum, "sess.muted") == 1 then
							InitVote2()
							vote2.called[2] = targetNum
							if IsIDNamesEnabled() then
								votingFor = string.format("UN-MUTE %s", et.gentity_get(targetNum, "pers.netname"))
							else
								votingFor = string.format("UN-MUTE %d;%s", targetNum, et.gentity_get(targetNum, "pers.netname"))
							end
						elseif clientNum then
							et.trap_SendServerCommand(clientNum, "cpm \"Player is not muted!\n\"")
						end
					end
				else
					ShowDisabledMessage()
				end
			elseif arg1 == "putspec" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_putspec"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					local targetNum = tonumber(et.trap_Argv(2))
					if targetNum == nil or targetNum < 0 or string.len(et.ConcatArgs(2)) > 2 or string.find(argList[2], "%.") or (string.find(argList[2], "0") == string.find(argList[2], "%d") and targetNum ~= 0) then
						targetNum = SearchForClient(et.trap_Argv(2))
					end
					if targetNum >= 0 and targetNum < max_clients and et.gentity_get(targetNum, "inuse") and et.gentity_get(targetNum, "sess.sessionTeam") ~= 3 then
						InitVote2()
						vote2.called[2] = targetNum
						if IsIDNamesEnabled() then
							votingFor = string.format("PUTSPEC %s", et.gentity_get(targetNum, "pers.netname"))
						else
							votingFor = string.format("PUTSPEC %d;%s", targetNum, et.gentity_get(targetNum, "pers.netname"))
						end
					end
				else
					ShowDisabledMessage()
				end
			elseif arg1 == "kick" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_kick"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					local targetNum = tonumber(et.trap_Argv(2))
					if targetNum == nil or targetNum < 0 or string.len(et.trap_Argv(2)) > 2 or string.find(argList[2], "%.") or (string.find(argList[2], "0") == string.find(argList[2], "%d") and targetNum ~= 0) then
						targetNum = SearchForClient(et.trap_Argv(2))
					end
					if targetNum >= 0 and targetNum < max_clients and et.gentity_get(targetNum, "inuse") then
						InitVote2()
						vote2.called[2] = targetNum
						local reason = et.ConcatArgs(3)
						if reason ~= "" then
							if IsIDNamesEnabled() then
								votingFor = string.format("^7KICK %s ^7{Reason: %s^7}",  et.gentity_get(targetNum, "pers.netname"), reason)
							else
								votingFor = string.format("^7KICK %d;%s ^7{Reason: %s^7}",  targetNum, et.gentity_get(targetNum, "pers.netname"), reason)
							end
							vote2.called[3] = reason
						else
							if IsIDNamesEnabled() then
								votingFor = string.format("^7KICK %s",  et.gentity_get(targetNum, "pers.netname"))
							else
								votingFor = string.format("^7KICK %d;%s",  targetNum, et.gentity_get(targetNum, "pers.netname"))
							end
							vote2.called[3] = nil
						end
					end
				else
					ShowDisabledMessage()
				end
			elseif arg1 == "poll" then
				local vote_allow = tonumber(et.trap_Cvar_Get("vote_allow_poll"))
				if not vote_allow or math.abs(vote_allow) >= 1 then
					InitVote2()
					vote2.time = et_level_time - 15000
					et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
					votingFor = string.format("[Poll] %s", et.ConcatArgs(2))
				else
					ShowDisabledMessage()
				end
			elseif clientNum then
				et.trap_SendServerCommand(clientNum, "print \"^3Available parameters: ^5map timelimit maprestart gametype friendlyfire saveload fun mute unmute putspec kick poll numberednames\n\"")
			end
			if votingFor then
				vote2.votingFor = votingFor
				et.trap_SetConfigstring(et.CS_VOTE_STRING, votingFor)
				if clientNum == nil then
					et.trap_SendServerCommand(-1, string.format("print \"Vote called from server console. Voting for: %s\n\"", votingFor))
				elseif IsIDNamesEnabled() then
					et.trap_SendServerCommand(-1, string.format("print \"%s ^7called a vote. Voting for: %s\n\"", et.gentity_get(clientNum, "pers.netname"), votingFor))
					et.trap_SendServerCommand(-1, string.format("cp \"%s\n^7called a vote.\n\"", et.gentity_get(clientNum, "pers.netname")))
				else
					et.trap_SendServerCommand(-1, string.format("print \"%d;%s ^7called a vote. Voting for: %s\n\"", clientNum, et.gentity_get(clientNum, "pers.netname"), votingFor))
					et.trap_SendServerCommand(-1, string.format("cp \"%d;%s\n^7called a vote.\n\"", clientNum, et.gentity_get(clientNum, "pers.netname")))
				end
				if clientNum and cmd == "callvote" then
					voter_list[clientNum].vote = VOTE_YES
					et.trap_SendServerCommand(clientNum, "cpm \"Voting ^3YES\n\"")
				end
				CountVotes2()
			end
		end
		return 1
	elseif cmd == "callvote" and VOTE_HANDLE and et.trap_Cvar_Get("jh_voteHandle") == "1" then
		if et_level_time <= vote2.time + 30000 then
			et.trap_SendServerCommand(clientNum, "cpm \"A vote is already in progress.\n\"")
			return 1
		elseif vote.inProgress or et.gentity_get(clientNum, "sess.sessionTeam") == 3 then
			return 0
		elseif voter_list[clientNum].callvotesLeft < 1 then
			et.trap_SendServerCommand(clientNum, string.format("cpm \"Please wait %d seconds to call another vote.\n\"", math.ceil((voter_list[clientNum].nextIncr - et_level_time) / 1000)))
			return 1
		end
		et.trap_Cvar_Set("vote_percent", VOTE_PERCENT)
		ResetVoteFlags()
		voter_list[clientNum].call = arg1
		voter_list[clientNum].vote = VOTE_YES
		CountVotes()
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "; removevoteflags;")  -- ET needs to be modified to use this
	elseif cmd == "callvote" and VOTE_HANDLE and et.trap_Cvar_Get("jh_voteHandle") ~= "1" then
		if tonumber(et.trap_Cvar_Get("vote_percent")) < 51 then
			et.trap_Cvar_Set("vote_percent", "51")
		end
	elseif cmd == "vote" and VOTE_HANDLE then
		local function Interval(vote)
			if et_level_time < voter_list[clientNum].interval or (vote == VOTE_YES and et_level_time < voter_list[clientNum].intervalYes) or (vote == VOTE_NO and et_level_time < voter_list[clientNum].intervalNo) then
				local interval = et_level_time + 150
				if interval > voter_list[clientNum].interval then
					voter_list[clientNum].interval = interval
				end
				if vote == VOTE_YES then
					voter_list[clientNum].intervalNo = et_level_time + 350
				elseif vote == VOTE_NO then
					voter_list[clientNum].intervalYes = et_level_time + 350
				end
				return true
			end
		end
		if arg1 == "yes" then
			if tonumber(et.trap_GetConfigstring(et.CS_VOTE_TIME)) == vote2.time and et_level_time <= vote2.time + 30000 then
				if Interval(VOTE_YES) then
					return 1
				end
				if voter_list[clientNum].vote == VOTE_NO or voter_list[clientNum].vote == VOTE_ABSTAIN then
					voter_list[clientNum].vote = nil
					if et_level_time >= vote2.timeCalled + VOTE_HESITATION then
						voter_list[clientNum].interval = et_level_time + VOTE_INTERVAL
					end
					et.trap_SendServerCommand(clientNum, "cpm \"Not voting\n\"")
				else
					voter_list[clientNum].vote = VOTE_YES
					et.trap_SendServerCommand(clientNum, "cpm \"Voting ^3YES\n\"")
				end
				CountVotes2()
				if et_level_time >= vote2.timeCalled + VOTE_HESITATION and vote2.yesInGame >= vote2.playersInGame * (VOTE_PERCENT / 100) and vote2.yes >= vote2.players * (VOTE_PERCENT / 100) or vote2.faded >= 1 and vote2.yes + vote2.yesInGame >= (vote2.players + vote2.playersInGame) * (VOTE_PERCENT / 100) then
					if vote2.called[1] ~= "kick" or vote2.yes > vote2.players / 2 then
						--et.trap_SendServerCommand(-1, string.format("print \"^oVotes^7: Yes:%d No:%d / %d\n\"", vote2.yes, vote2.no, vote2.players))
						et.trap_SendServerCommand(-1, string.format("cpm \"^5Vote passed. %s\n\"", GetVoteResult()))
						--et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; wait 5; clearvote;"))
						et.trap_SetConfigstring(et.CS_VOTE_TIME, "")
						vote2.time = -30000
						ExecVoteContent(vote2.called)
					end
				end
				return 1
			elseif vote.inProgress and et.gentity_get(clientNum, "sess.sessionTeam") < 3 then
				if Interval(VOTE_YES) then
					return 1
				end
				if voter_list[clientNum].vote == nil and et_level_time >= voter_list[clientNum].interval then
					voter_list[clientNum].vote = VOTE_YES
					et.trap_SendServerCommand(clientNum, "print \"Vote cast.\n\"")
				elseif voter_list[clientNum].vote == VOTE_NO or voter_list[clientNum].vote == VOTE_ABSTAIN then
					voter_list[clientNum].vote = nil
					voter_list[clientNum].interval = et_level_time + VOTE_INTERVAL
				end
				CountVotes()
				return 1
			end
		elseif arg1 == "no" then
			if tonumber(et.trap_GetConfigstring(et.CS_VOTE_TIME)) == vote2.time and et_level_time <= vote2.time + 30000 then
				if Interval(VOTE_NO) then
					return 1
				end
				if voter_list[clientNum].vote == VOTE_YES or voter_list[clientNum].vote == VOTE_ABSTAIN then
					voter_list[clientNum].vote = nil
					if et_level_time >= vote2.timeCalled + VOTE_HESITATION then
						voter_list[clientNum].interval = et_level_time + VOTE_INTERVAL
					end
					et.trap_SendServerCommand(clientNum, "cpm \"Not voting\n\"")
				else
					if vote2.caller == clientNum then
						vote2.time = -30000
						DecreaseVoteLimit(2)
						et.trap_SetConfigstring(et.CS_VOTE_TIME, "")
						et.trap_SendServerCommand(-1, "cpm \"Vote cancelled\n\"")
					else
						voter_list[clientNum].vote = VOTE_NO
						et.trap_SendServerCommand(clientNum, "cpm \"Voting ^3NO\n\"")
					end
				end
				CountVotes2()
				if vote2.no + vote2.noInGame > vote2.players + vote2.playersInGame - (vote2.players + vote2.playersInGame) * (VOTE_PERCENT / 100) and vote2.no > (vote2.yes + vote2.no) - (vote2.yes + vote2.no) * (VOTE_PERCENT / 100) then
					vote2.time = -30000
					DecreaseVoteLimit(2)
					--et.trap_SendServerCommand(-1, string.format("print \"^oVotes^7: Yes:%d No:%d / %d\n\"", vote2.yes, vote2.no, vote2.players))
					et.trap_SendServerCommand(-1, string.format("cpm \"^2Vote FAILED! %s\n\"", GetVoteResult()))
					--et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; wait 5; clearvote;"))
					et.trap_SetConfigstring(et.CS_VOTE_TIME, "")
				end
				return 1
			elseif vote.inProgress or voter_list[clientNum].call and et.gentity_get(clientNum, "sess.sessionTeam") < 3 and et_level_time >= voter_list[clientNum].interval then
				if Interval(VOTE_NO) then
					return 1
				end
				CountVotes()
				if not vote.inProgress and voter_list[clientNum].call and not voter_list[clientNum].vote then
					return 1
				elseif voter_list[clientNum].vote == nil and vote.no + 1 > vote.players * ((100 - VOTE_PERCENT) / 100)  or vote.no > vote.players * ((100 - VOTE_PERCENT) / 100) or vote.players + vote.abstain <= 1 or (vote.caller == clientNum and voter_list[clientNum].vote == nil) then
					et.trap_Cvar_Set("vote_percent", 100)
					if vote.caller then
						voter_list[vote.caller].callvotesLeft = voter_list[vote.caller].callvotesLeft - 1
						if not voter_list[vote.caller].nextIncr then
							voter_list[vote.caller].nextIncr = et_level_time + vote.perSeconds * 1000
						end
						if vote.caller == clientNum then
							et.trap_SendServerCommand(-1, string.format("print \"^aVotes^7: Yes:%d No:%d Abstain:%d\n\"", vote.yes, vote.no + 1, vote.abstain))
						else
							et.trap_SendServerCommand(-1, string.format("print \"^oVotes^7: Yes:%d No:%d Abstain:%d\n\"", vote.yes, vote.no + 1, vote.abstain))
						end
					elseif vote.players <= 1 then
						voter_list[clientNum].callvotesLeft = voter_list[clientNum].callvotesLeft - 1
						if not voter_list[clientNum].nextIncr then
							voter_list[clientNum].nextIncr = et_level_time + vote.perSeconds * 1000
						end
					end
					ResetVoteFlags()
					return 0
				elseif voter_list[clientNum].call and string.lower(voter_list[clientNum].call) == "kick" then
					return 0
				else
					if voter_list[clientNum].vote == nil and et_level_time >= voter_list[clientNum].interval then
						voter_list[clientNum].vote = VOTE_NO
						et.trap_SendServerCommand(clientNum, "print \"Vote cast.\n\"")
					elseif voter_list[clientNum].vote == VOTE_YES or voter_list[clientNum].vote == VOTE_ABSTAIN then
						voter_list[clientNum].vote = nil
						voter_list[clientNum].interval = et_level_time + VOTE_INTERVAL
					end
					CountVotes()
					return 1
				end
			end
		elseif arg1 == "abstain" or arg1 == "abs" then
			voter_list[clientNum].vote = VOTE_ABSTAIN
			if tonumber(et.trap_GetConfigstring(et.CS_VOTE_TIME)) == vote2.time and et_level_time <= vote2.time + 30000 then
				CountVotes2()
				et.trap_SendServerCommand(clientNum, "cpm \"Abstaining from voting\n\"")
				if et_level_time >= vote2.timeCalled + VOTE_HESITATION and vote2.yes >= 1 and (vote2.yesInGame >= vote2.playersInGame * (VOTE_PERCENT / 100) and vote2.yes >= vote2.players * (VOTE_PERCENT / 100) or vote2.faded >= 1 and vote2.yes + vote2.yesInGame >= (vote2.players + vote2.playersInGame) * (VOTE_PERCENT / 100)) then
					--et.trap_SendServerCommand(-1, string.format("print \"^oVotes^7: Y:%d N:%d\n\"", vote2.yes, vote2.no))
					et.trap_SendServerCommand(-1, string.format("cpm \"^5Vote passed. %s\n\"", GetVoteResult()))
					--et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; wait 10; clearvote;"))
					et.trap_SetConfigstring(et.CS_VOTE_TIME, "")
					vote2.time = -30000
					ExecVoteContent(vote2.called)
				elseif vote2.no + vote2.noInGame > vote2.players + vote2.playersInGame - (vote2.players + vote2.playersInGame) * (VOTE_PERCENT / 100) and vote2.no > (vote2.yes + vote2.no) - (vote2.yes + vote2.no) * (VOTE_PERCENT / 100) then
					vote2.time = -30000
					DecreaseVoteLimit(2)
					---et.trap_SendServerCommand(-1, string.format("print \"^oVotes^7: Y:%d N:%d\n\"", vote2.yes, vote2.no))
					et.trap_SendServerCommand(-1, string.format("cpm \"^2Vote FAILED! %s\n\"", GetVoteResult()))
					--et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; wait 20; clearvote;"))
					et.trap_SetConfigstring(et.CS_VOTE_TIME, "")
				end
				return 1
			elseif vote.inProgress and et.gentity_get(clientNum, "sess.sessionTeam") < 3 then
				et.trap_SendServerCommand(clientNum, "print \"Vote cast.\n\"")
				CountVotes()
				return 1
			end
			return 0
		elseif arg1 == "afk" then
			if et.trap_Argv(2) == "0" then
				voter_list[clientNum].afk = false
				et.trap_SendServerCommand(clientNum, "print \"You are back.\n\"")
			else
				voter_list[clientNum].afk = true
				et.trap_SendServerCommand(clientNum, "print \"You will be abstaining from voting. Use [/vote back] when you're back.\n\"")
			end
			return 1
		elseif arg1 == "back" then
			voter_list[clientNum].afk = false
			et.trap_SendServerCommand(clientNum, "print \"You are back.\n\"")
			if voter_list[clientNum].vote == VOTE_ABSTAIN then
				voter_list[clientNum].vote = nil
			end
			return 1
		else
			et.trap_SendServerCommand(clientNum, "print \"^3Available parameters: ^5yes no abstain afk back\n\"")
			return 1
		end
	elseif cmd == "follow" and FOLLOW_SEARCH then
		if concatArgs1 == "" then
			et.gentity_set(clientNum, "sess.spectatorState", 2)
			player_list[clientNum].specState = 2
			player_list[clientNum].specReleasingTime = et_level_time
			return 1
		end
		local playerID = tonumber(concatArgs1)
		if not playerID or playerID < 0 or playerID >= max_clients then
			playerID = SearchForClient(concatArgs1)
		end
		if playerID >= 0 then
			et.gentity_set(clientNum, "sess.latchSpectatorClient", playerID)
			et.gentity_set(clientNum, "sess.spectatorState", 2)
			player_list[clientNum].specState = 2
			player_list[clientNum].specReleasingTime = et_level_time
		elseif playerID == NAME_MULTIPLE_MATCH then
			et.trap_SendServerCommand(clientNum, "print \"More than one player with that name.\n\"")
		elseif playerID == NAME_NO_MATCH then
			et.trap_SendServerCommand(clientNum, string.format("print \"Player %s is not on the server.\n\"", concatArgs1))
		end
		return 1
	elseif cmd == "spec" or cmd == "stalk" then
		local playerID = tonumber(et.trap_Argv(1))
		if not (playerID and playerID >= 0 and playerID < max_clients) then
			player_list[clientNum].specClient = SearchForClient(et.trap_Argv(1))
		elseif et.gentity_get(playerID, "inuse") then
			player_list[clientNum].specClient = playerID
		else
			player_list[clientNum].specClient = -1
		end
		
		if player_list[clientNum].specClient >= 0 then
			et.trap_SendServerCommand(clientNum, string.format("print \"You will be automatically following ID:%d\n\"", player_list[clientNum].specClient))
		else
			et.trap_SendServerCommand(clientNum, string.format("print \"You will be automatically following someone.\n\""))
		end
		
		et.gentity_set(clientNum, "sess.latchSpectatorClient", player_list[clientNum].specClient)
		et.gentity_set(clientNum, "sess.spectatorState", 2)
		return 1
	elseif cmd == "unspec" or cmd == "unstalk" then
		player_list[clientNum].specClient = nil
		player_list[clientNum].specState = nil
		player_list[clientNum].nextStalk = nil
		return 1
	elseif cmd == "nextstalk" then
		local playerID = tonumber(et.trap_Argv(1))
		if not (playerID and 0 <= playerID < max_clients and et.gentity_get(playerID, "inuse")) then
			playerID = SearchForClient(et.trap_Argv(1))
		end
		player_list[clientNum].nextStalk = playerID
				
		--et.gentity_set(clientNum, "sess.spectatorState", 2)
		return 1		
	elseif cmd == "keepfollow" or cmd == "autofollow" then
		local param = tonumber(et.trap_Argv(1))
		if param and math.floor(math.abs(param)) == 0 then
			player_list[clientNum].autoFollow = false
			et.trap_SendServerCommand(clientNum, string.format("print \"Autofollow has been disabled.\n\""))
		elseif param and math.floor(param) == 2 then
			player_list[clientNum].autoFollow = AUTO_FOLLOW_ALWAYS
			et.trap_SendServerCommand(clientNum, "print \"Autofollow level set to 2.\n\"")
		else
			player_list[clientNum].autoFollow = true
			et.trap_SendServerCommand(clientNum, string.format("print \"Autofollow has been enabled.\n\""))
		end
		return 1
	elseif cmd == "nofollow" then
		player_list[clientNum].autoFollow = false
		et.trap_SendServerCommand(clientNum, string.format("print \"Autofollow has been disabled.\n\""))
		player_list[clientNum].specState = nil
		return 1
	elseif cmd == "specing" then
		et.trap_SendServerCommand(clientNum, string.format("print \"state:%d ID:%d latch:%d\n\"", et.gentity_get(clientNum, "sess.specTatorState"), et.gentity_get(clientNum, "sess.spectatorClient"), et.gentity_get(clientNum, "sess.latchSpectatorClient")))
		return 1
	elseif cmd == "clientsearch" or cmd == "csearch" then
		local playerID = SearchForClient(et.trap_Argv(1))
		if playerID >= 0 then
			local userinfo = et.trap_GetUserinfo(playerID)
			local playerName = et.Info_ValueForKey(userinfo, "name")
			et.trap_SendServerCommand(clientNum, string.format("print \"%d:%s\n", playerID, playerName))
		elseif playerID == NAME_NO_MATCH then
			et.trap_SendServerCommand(clientNum, "print \"No client found.\n\"")
		elseif playerID == NAME_MULTIPLE_MATCH then
			et.trap_SendServerCommand(clientNum, "print \"More than 1 client found.\n\"")
		elseif playerID == NAME_TOO_SHORT_KEYWORD then
			et.trap_SendServerCommand(clientNum, "print \"Too short keyword.\n\"")
		end
		return 1
	elseif cmd == "voterstatus" or cmd == "vstatus" then
		if voter_list[clientNum].nextIncr then
			et.trap_SendServerCommand(clientNum, string.format("cpm \"You may call %d more votes. %d seconds until it's increased.\n\"", voter_list[clientNum].callvotesLeft, math.ceil((voter_list[clientNum].nextIncr - et_level_time) / 1000)))
		else
			et.trap_SendServerCommand(clientNum, string.format("cpm \"You may call %d more votes.\n\"", voter_list[clientNum].callvotesLeft, voter_list[clientNum].nextIncr))
		end
		return 1
	elseif cmd == "nofatigue" then
		local param = tonumber(et.trap_Argv(1))
		if param and math.floor(math.abs(param)) == 0 then
			player_list[clientNum].nofatigue = false
			et.gentity_set(clientNum, "ps.powerups", PW_NOFATIGUE, 0)
			et.trap_SendServerCommand(clientNum, "print \"^5Nofatigue has been disabled\n\"")
		elseif et.trap_Cvar_Get("jh_nofatigue") ~= "1" then
			return 0
		else
			if player_list[clientNum].playerType == 1 then
				et.gentity_set(clientNum, "ps.powerups", PW_NOFATIGUE, INT_MAX)
				et.gentity_set(clientNum, "ps.ammoclip", 11, 10000)
				--et.gentity_set(clientNum, "ps.ammo", 11, 10000)
			end
			if not player_list[clientNum].nofatigue then
				player_list[clientNum].nofatigue = true
				et.trap_SendServerCommand(clientNum, "cp \"^1Noob enables nofatigue\n\"")
			end
			et.trap_SendServerCommand(clientNum, "print \"Nofatigue enabled for medic. /nofatigue 0 to disable it.\n\"")
			player_list[clientNum].usedCheatAdren = true
		end
		et.trap_Cvar_Set("jhmod_clientInfo" .. clientNum, et.Info_SetValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "nofatigue", tostring(player_list[clientNum].nofatigue)))
		return 1
	elseif cmd == "cheatadren" then
		local param = tonumber(et.trap_Argv(1))
		if param and math.floor(math.abs(param)) == 0 then
			player_list[clientNum].cheatAdren = false
			et.trap_SendServerCommand(clientNum, "print \"Cheatadren disabled.\n\"")
		elseif et.trap_Cvar_Get("jh_nofatigue") == "1" then
			if player_list[clientNum].playerType == 1 then
				et.gentity_set(clientNum, "ps.ammoclip", 11, 10000)
				--et.gentity_set(clientNum, "ps.ammo", 11, 10000)
			end
			if not player_list[clientNum].cheatAdren then
				player_list[clientNum].cheatAdren = true
				if et.trap_Cvar_Get("jh_saveload") ~= "1" or et.trap_Cvar_Get("jh_nosaveload") == "1" then
					et.trap_SendServerCommand(clientNum, "cp \"^8Noob enables cheatadren\n\"")
				end
			end
			et.trap_SendServerCommand(clientNum, "print \"Cheatadren enabled. /cheatAdren 0 to disable it.\n\"")
			player_list[clientNum].usedCheatAdren = true
		else
			et.trap_SendServerCommand(clientNum, "print \"cheatadren is not allowed on this map.\n\"")
			return 1
		end
		et.trap_Cvar_Set("jhmod_clientInfo" .. clientNum, et.Info_SetValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "cheatAdren", tostring(player_list[clientNum].cheatAdren)))
		return 1
	elseif cmd == "give" then
		if arg1 == "adren" and et.trap_Cvar_Get("jh_nofatigue") == "1" then
			local amount = tonumber(et.trap_Argv(2))
			if amount then
				if amount <= et.gentity_get(clientNum, "ps.ammoclip", 11) then
					return 1
				elseif amount < 5245 then
					amount = 5245
				end
				et.gentity_set(clientNum, "ps.ammoclip", 11, amount)
				et.gentity_set(clientNum, "ps.ammo", 11, 9999)
			else
				et.gentity_set(clientNum, "ps.ammoclip", 11, 5245)
				et.gentity_set(clientNum, "ps.ammo", 11, 5245)
			end
			if et.trap_Cvar_Get("jh_saveload") ~= "1" or et.trap_Cvar_Get("jh_nosaveload") == "1" then
				et.trap_SendServerCommand(clientNum, "cp \"^=User wants more syringes\"")
			end
			player_list[clientNum].usedCheatAdren = true
			return 1
		end	
	elseif cmd == "adrenspawn" then
		local param = tonumber(et.trap_Argv(1))
		if param and math.floor(math.abs(param)) == 0 then
			player_list[clientNum].adrenSpawn = false
			et.trap_SendServerCommand(clientNum, 'print "Adrenaline is now unset to default weapon..\n"')
		else
			player_list[clientNum].adrenSpawn = true
			et.trap_SendServerCommand(clientNum, 'print "Adrenaline is now set to default weapon. /adrenSpawn 0 to unset it.\n"')
		end
		et.trap_Cvar_Set("jhmod_clientInfo" .. clientNum, et.Info_SetValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "adrenSpawn", tostring(player_list[clientNum].adrenSpawn)))
		return 1
	elseif cmd == "loadviewangles" or cmd == "loadangles" or cmd == "loadviewangle" or cmd == "loadangle" or cmd == "lva" then
		local param = tonumber(et.trap_Argv(1))
		if param and math.floor(math.abs(param)) == 0 then
			player_list[clientNum].loadViewangles = false
			et.trap_SendServerCommand(clientNum, "print \"Loading viewangles disabled.\n\"")
		else
			player_list[clientNum].loadViewangles = true
			et.trap_SendServerCommand(clientNum, "print \"Loading viewangles enabled. /loadAngles 0 to disable it.\n\"")
		end
		et.trap_Cvar_Set("jhmod_clientInfo" .. clientNum, et.Info_SetValueForKey(et.trap_Cvar_Get("jhmod_clientInfo" .. clientNum), "loadViewangles", tostring(player_list[clientNum].loadViewangles)))
		return 1
	elseif cmd == "bedead" then
		if player_list[clientNum].reduceDamage then
			player_list[clientNum].reduceDamage = nil
			et.gentity_set(clientNum, "ps.stats", 4, player_list[clientNum].maxHealth)
			et.gentity_set(clientNum, "health", math.ceil(et.gentity_get(clientNum, "health") / 6))
		end
		local health = et.gentity_get(clientNum, "health")
		if et.gentity_get(clientNum, "sess.sessionTeam") ~= 3 and health > 0 then
			et.gentity_set(clientNum, "ps.powerups", 1, 0)
			et.gentity_set(clientNum, "ps.powerups", 12, 0)
			et.G_Damage(clientNum, 1022, 1022, health, 0, 32)
			et_Obituary(clientNum, 1022, 32)
		end
		return 1
	elseif cmd == "suicide" then
		et.gentity_set(clientNum, "ps.powerups", 1, 0)
		et.G_Damage(clientNum, 1022, 1022, 500, 24, 37)
		et_Obituary(clientNum, 1022, 37)
		return 1
	elseif cmd == "switch" or cmd == "swap" then
		local concatArgs = et.ConcatArgs(1)
		local num = tonumber(et.trap_Argv(1))
		if not (num and num >= 0 and num < max_clients) or string.len(concatArgs) > 2 or string.find(concatArgs, "%.") then
			num = SearchForClient(concatArgs)
		end
		if num == NAME_MULTIPLE_MATCH then
			et.trap_SendServerCommand(clientNum, "chat \"More than 1 player found.\"")
			return 1
		elseif num == NAME_TOO_SHORT_KEYWORD then
			et.trap_SendServerCommand(clientNum, 'chat "Too short keyword."')
			return 1
		elseif num < 0 or not et.gentity_get(num, "inuse") then
			et.trap_SendServerCommand(clientNum, 'chat "Player not found."')
			return 1
		end
		ReadyToSwitch(clientNum, num, SWITCH_SECONDS)
		return 1
	elseif cmd == "unswitch" or cmd == "noswitch" or cmd == "cancel" then
		player_list[clientNum].switch.cnum = nil
		et.trap_SendServerCommand(clientNum, 'print "Switch canceled.\n"')
		return 1
	elseif cmd == "mapinfo" or cmd == "minfo" then
		if player_list[clientNum].nextMapinfo and player_list[clientNum].nextMapinfo > et_level_time then
			et.trap_SendServerCommand(clientNum, string.format("cpm \"^3mapinfo: ^7Wait %s seconds to use again\"", math.ceil((player_list[clientNum].nextMapinfo - et_level_time) / 1000)))
			return 1
		end

		local function SendPakInfo(pak)
			local size
			if pak.size >= 1048576 then
				size = string.format("%.1f", pak.size / 1024 / 1024) .. "MB"
			else
				size = string.format("%d", (pak.size / 1024)) .. "KB"
			end
			et.trap_SendServerCommand(clientNum, string.format("print \"^fpak^*: %s  ^fsize^*: %s\n\"", pak.basename, size))
		end

		local info
		if concatArgs1 ~= "" then
			info = MapInfo(concatArgs1)
		else
			info = MapInfo(mapname)
		end
		if info.map then
			--info.briefing = string.gsub(info.briefing, "%^0", "^9")
			info.briefing = et.Q_CleanStr(info.briefing)
			info.briefing = string.gsub(info.briefing, "\\n\\n", "\n")
			info.briefing = string.gsub(info.briefing, "\\n", "\n")
			et.trap_SendServerCommand(clientNum, string.format("print \"^xmap: ^*%s\n^xlongname: ^*%s\n^*%s\n\"",info.map, info.longname, info.briefing))
		else
			if concatArgs1 ~= "" then
				if info.findmap == "" then
					return 1
				end
				if info.pak then
					et.trap_SendServerCommand(clientNum, string.format("print \"^9map^*: %s\n\"", concatArgs1))
				else
					et.trap_SendServerCommand(clientNum, string.format("print \"%s\n\"", info.findmap))
				end
			else
				et.trap_SendServerCommand(clientNum, string.format("print \"^zmap^*: %s\n\"", mapname))
			end
		end

		if info.pak then
			SendPakInfo(info.pak)
		end
		
		player_list[clientNum].nextMapinfo = et_level_time + 250
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setfindmaptime %d 0", clientNum))
		return 1
	elseif cmd == "physics" then
		local g_gravity, g_speed, pmove_msec = et.trap_Cvar_Get("g_gravity"), et.trap_Cvar_Get("g_speed"), et.trap_Cvar_Get("pmove_msec")
		et.trap_SendServerCommand(clientNum, string.format("print \"^5g_gravity: ^7%s  ^5g_speed: ^7%s  ^5pmove_msec: ^7%s\n", g_gravity, g_speed, pmove_msec))
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setfindmaptime %d 0", clientNum))
		return 1
	elseif cmd == "save" or cmd == "load" then
		if et.trap_Cvar_Get("jh_saveload") == "1" then
			if player_list[clientNum].sessionTeam == 1 and axis_save_load == false then
				if et.trap_Cvar_Get("jh_voteHandle") == "2" then
					if axis_no_save_load then
						et.trap_SendServerCommand(clientNum, "cpm \"Save/Load is disabled for Axis, noobs could enable it by ^9[^7/callvote axissaveload^9]\"")
					else
						et.trap_SendServerCommand(clientNum, "cpm \"^9[^7/callvote axissaveload 1^9] ^7to activate Save/Load\n\"")
					end
				else
					et.trap_SendServerCommand(clientNum, "cpm \"Save/Load is currently disabled for Axis.\"")
				end
				return 1
			elseif player_list[clientNum].sessionTeam == 2 and allied_save_load == false then
				if et.trap_Cvar_Get("jh_voteHandle") == "2" then
					if allied_no_save_load then
						et.trap_SendServerCommand(clientNum, "cpm \"Save/Load is disabled for Allies, noobs could enable it by ^9[^7/callvote alliedsaveload^9]\"")
					else
						et.trap_SendServerCommand(clientNum, "cpm \"^9[^7/callvote alliedsaveload 1^9] ^7to activate Save/Load\n\"")
					end
				else
					et.trap_SendServerCommand(clientNum, "cpm \"Save/Load is currently disabled for Allies.\"")
				end
				return 1
			elseif cmd == "save" then
				local saveNum = tonumber(et.trap_Argv(1))
				if saveNum == nil then
					saveNum = 0
				end
				if player_list[clientNum].maxLoads and saveNum ~= 0 or saveNum < 0 or saveNum > 3 then
					et.trap_SendServerCommand(clientNum, "cp \"^3Invalid save slot.\n\"")
					return 1
				end
				
				if SavePosition(clientNum, saveNum) then
					if saveNum == 0 then
						if et.trap_Cvar_Get("jh_nosaveload") == "1" then
							et.trap_SendServerCommand(clientNum, "cp \"Saved\"")
						else
							et.trap_SendServerCommand(clientNum, "cp \"Saved\"")
						end
					else
						if et.trap_Cvar_Get("jh_nosaveload") == "1" then
							et.trap_SendServerCommand(clientNum, string.format("cp \"Saved %d\"", saveNum))
						else
							et.trap_SendServerCommand(clientNum, string.format("cp \"Saved %d\"", saveNum))
						end
					end
					if player_list[clientNum].maxLoads then
						et.trap_SendServerCommand(clientNum, string.format("cp \"Saved\n\"", player_list[clientNum].maxLoads))
					end
				end
				
				return 1
			elseif cmd == "load" then
				local saveNum = 0
				if et.trap_Argc() >= 2 then
					saveNum = tonumber(et.trap_Argv(1))
				end
				
				local loadRet = LoadPosition(clientNum, saveNum)
				if loadRet == true then
					if saveNum == 0 then
						if et.trap_Cvar_Get("jh_nosaveload") == "1" then
							et.trap_SendServerCommand(clientNum, "cp \"\"")
						else
							et.trap_SendServerCommand(clientNum, "cp \"\"")
						end
					else
						if et.trap_Cvar_Get("jh_nosaveload") == "1" then
							et.trap_SendServerCommand(clientNum, string.format("cp \"Loaded %d\"", saveNum))
						else
							et.trap_SendServerCommand(clientNum, string.format("cp \"Loaded %d\"", saveNum))
						end
					end
				elseif loadRet == LOAD_AT_ANOTHER_PLAYER then
					et.trap_SendServerCommand(clientNum, "cpm \"There's another player where you're trying to load.\n\"")
				elseif loadRet == false then
					et.trap_SendServerCommand(clientNum, "cp \"Use save first\"")
				end
				
				return 1
			end
		else
			if et.trap_Cvar_Get("jh_nosaveload") == "1" then
				et.trap_SendServerCommand(clientNum, "cpm \"Save/Load is disabled on this map, noobs could enable it by ^9[^7/callvote saveload 1^9]\n\"")
			elseif et.trap_Cvar_Get("jh_voteHandle") == "2" then
				et.trap_SendServerCommand(clientNum, "cpm \"^9[^7/callvote save 1^9] ^7to activate Save/Load\n\"")
				return 1
			elseif et.trap_Cvar_Get("jh_voteHandle2")  == "1" then
				et.trap_SendServerCommand(clientNum, "cpm \"^9[^7/callvote2 saveload 1^9] ^7to activate Save/Load\n\"")
				return 1
			else
				et.trap_SendServerCommand(clientNum, "cpm \"^7Save/Load is currently disabled.\n\"")
			end
			if et.trap_Cvar_Get("jh_temporalSave") == "1" then
				et.trap_SendServerCommand(clientNum, "cpm \"^2!save ^7and ^2!load ^7for temporal save\n\"")
			end
			return 1
		end
	elseif cmd == "removesaves" then
		player_list[clientNum][et.gentity_get(clientNum, "sess.sessionTeam")] = {}
		et.trap_SendServerCommand(clientNum, "cpm \"Your saves have been removed.\"")
		return 1
	end
	
	return 0
end

function et_ConsoleCommand()
	local cmd = string.lower(et.trap_Argv(0))
	local arg = et.trap_Argv(1)
	local args = et.ConcatArgs(0)
	local argc = et.trap_Argc()
	local argList = GetArgList(args)

	if cmd == "chat" then
		local cnum = tonumber(et.trap_Argv(1))
		if cnum == nil or cnum >= max_clients then
			cnum = SearchForClient(et.trap_Argv(1))
			if cnum < 0 then
				return 1
			end
		end
		et.trap_SendServerCommand(cnum, string.format("chat \"%s\"", et.ConcatArgs(2)))
		return 1
	elseif cmd == "cpm2" then
		local cnum = tonumber(et.trap_Argv(1))
		if cnum == nil or cnum >= max_clients then
			cnum = SearchForClient(et.trap_Argv(1))
			if cnum < 0 then
				return 1
			end
		end
		et.trap_SendServerCommand(cnum, string.format("cpm \"%s\n\"", et.ConcatArgs(2)))
		return 1
	elseif cmd == "clearvote" then
		et.trap_SetConfigstring(et.CS_VOTE_TIME, "")
		return 1
	elseif cmd == "ref" and string.lower(arg) == "saveload" then
		local arg2 = et.trap_Argv(2)
		if arg2 == "1" then
			if et.trap_Cvar_Get("jh_saveload") == "1" then
				et.G_Print("saveload is already ENABLED!\n")
			else
				et.G_globalSound("sound/misc/referee.wav")
				et.trap_SendServerCommand(-1, 'cpm "^3Save/Load is: ^5ENABLED\n"')
				et.trap_SendServerCommand(-1, 'cp "^1** Referee Server Setting Change **\n"')
				et.trap_Cvar_Set("jh_saveload", "1")
				et.trap_SendServerCommand(-1, "print \"Server: jh_saveload changed to 1\n\"")
			end
		elseif arg2 == "0" then
			if et.trap_Cvar_Get("jh_saveload") == "0" then
				et.G_Print("saveload is already DISABLED!\n")
			else
				et.G_globalSound("sound/misc/referee.wav")
				et.trap_SendServerCommand(-1, 'cpm "^3Save/Load is: ^5DISABLED\n"')
				et.trap_SendServerCommand(-1, 'cp "^1** Referee Server Setting Change **\n"')
				et.trap_Cvar_Set("jh_saveload", "0")
				et.trap_SendServerCommand(-1, "print \"Server: jh_saveload changed to 0\n\"")
			end
		end
		return 1
	elseif cmd == "callvote" then
		et_ClientCommand(nil, cmd)
		return 1
	elseif cmd == "crushvote" or cmd == "cancelvote2" then
		if tonumber(et.trap_GetConfigstring(et.CS_VOTE_TIME)) == vote2.time and et_level_time <= vote2.time + 30000 then
			vote2.time = -30000
			et.trap_SetConfigstring(et.CS_VOTE_TIME, "")
			et.trap_SendServerCommand(-1, "cpm \"Vote crushed\n\"")
			return 1
		end
	elseif cmd == "putspec" then -- not called if coded in ET
		et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; forceteam %s s;", et.ConcatArgs(1)))
		return 1
	elseif cmd == "loadmaplua" then
		local fd, len = et.trap_FS_FOpenFile("mapscripts.lua", et.FS_READ)
		if len > 0 then
			local func, error = loadstring(et.trap_FS_Read(fd, len))
			if func then
				if not pcall(func) then
					et.G_Print("Error while executing mapscripts.lua\n")
				end
			else
				et.G_Print(string.format("Error occurred in mapscripts.lua: %s\n", error))
			end
		end
		et.trap_FS_FCloseFile(fd)
		saveMaxUPS = tonumber(et.trap_Cvar_Get("jh_saveMaxUPS"))
		alliedSaveMaxUPS = tonumber(et.trap_Cvar_Get("jh_alliedSaveMaxUPS"))
		axisSaveMaxUPS = tonumber(et.trap_Cvar_Get("jh_axisSaveMaxUPS"))
		if not saveMaxUPS then
			saveMaxUPS = 300
		end
		return 1
	end
	
	return 0
end
	
function et_ClientSpawn(clientNum, revived)
	local sessionTeam = et.gentity_get(clientNum, "sess.sessionTeam")
	if revived == 1 then
		table.insert(revived_players, clientNum)
	elseif sessionTeam < 3 then
		local playerType = et.gentity_get(clientNum, "sess.playerType")
		local spawnInvul = tonumber(et.trap_Cvar_Get("jh_spawnInvul"))
		if spawnInvul then
			et.gentity_set(clientNum, "ps.powerups", 1, et_level_time + spawnInvul)
		end
		local spawnAdren = tonumber(et.trap_Cvar_Get("jh_spawnAdren"))
		if spawnAdren then
			et.gentity_set(clientNum, "ps.powerups", 12, et_level_time + spawnAdren)
		end
		
		if player_list[clientNum].adrenSpawn and playerType == 1 then
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponchange %d %d", clientNum, 46))
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setweaponstate %d %d", clientNum, 1))
		end
	
		for i = 0, max_clients -1 do
			if player_list[i] and player_list[i].sessionTeam == 3 then
				if player_list[i].specClient then
					et.gentity_set(i, "sess.latchSpectatorClient", player_list[i].specClient)
					et.gentity_set(i, "sess.spectatorState", 2)
				elseif player_list[i].autoFollow and player_list[i].specState == 2 then
					et.trap_Cvar_Set("returnvalue", "")
					et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("getlastactivitytime %d buttons %d", i, BUTTON_ACTIVATE))
					local lastActivateRecievingTime = tonumber(et.trap_Cvar_Get("returnvalue"))
					et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("getlastactivitytime %d upmove", i))
					local lastUpmoveRecievingTime = tonumber(et.trap_Cvar_Get("returnvalue"))
					if player_list[i].autoFollow ~= AUTO_FOLLOW_ALWAYS and (lastActivateRecievingTime and lastActivateRecievingTime >= player_list[i].specReleasingTime or lastUpmoveRecievingTime and lastUpmoveRecievingTime >= player_list[i].specReleasingTime) then
						player_list[i].specState = nil
					else
						et.gentity_set(i, "sess.spectatorState", 2)
					end
				end
			end
		end
		
		if vote.inProgress then
			CountVotes()
		end
		
		player_list[clientNum].maxLoads = tonumber(et.trap_Cvar_Get("jh_loadLimit"))
		player_list[clientNum].loaded = false
		player_list[clientNum].usedCheatAdren = false
		player_list[clientNum].finished = false
		player_list[clientNum].noclipped = false
		if et.trap_Cvar_Get("jh_nofatigue") == "1" and playerType == 1 then
			if player_list[clientNum].nofatigue then
				et.gentity_set(clientNum, "ps.powerups", PW_NOFATIGUE, INT_MAX)
				et.gentity_set(clientNum, "ps.ammoclip", 11, 10000)
				player_list[clientNum].usedCheatAdren = true
			end
			if player_list[clientNum].cheatAdren then
				et.gentity_set(clientNum, "ps.ammoclip", 11, 10000)
				player_list[clientNum].usedCheatAdren = true
			end
		end	

		if player_list[clientNum].switchto then
			SetPosition(clientNum, player_list[clientNum].switchto)
			player_list[clientNum].switchto = nil
			et.gentity_set(clientNum, "ps.powerups", 1, et_level_time)
		end
		player_list[clientNum].playerType = playerType
	else
		if vote.inProgress then
			voter_list[clientNum].vote = nil
			CountVotes()
			if et.gentity_get(clientNum, "pers.voteCount") > voter_list[clientNum].count then
				voter_list[clientNum].callvotesLeft = voter_list[clientNum].callvotesLeft - 1
				if not voter_list[clientNum].nextIncr then
					voter_list[clientNum].nextIncr = et_level_time + vote.perSeconds * 1000
				end
				ResetVoteFlags()
			elseif  vote.players == 1 and vote.yes < 1 then
				et.trap_SendConsoleCommand(et.EXEC_NOW, "cancelvote")
				ResetVoteFlags()
			end
		end
		
		local switchto = player_list[clientNum].switchto
		if switchto then
			player_list[clientNum].switchto = nil
			--et.gentity_set(clientNum, "sess.spectatorState", 2)
			player_list[clientNum].specState = 2
			player_list[clientNum].specReleasingTime = et_level_time
			et.gentity_set(clientNum, "sess.latchSpectatorClient", switchto.cnum)
		end
	end
	
	player_list[clientNum].down = false
	player_list[clientNum].reduceDamage = nil
--	player_list[clientNum].health = 0

	player_list[clientNum].sessionTeam = sessionTeam
	if ClientSpawnOnMap then
		ClientSpawnOnMap(clientNum, revived, player_list)
	end
end

function et_Obituary(victim, killer, meansOfDeath)
	--et.G_Print("Obituary\n")
	for i = 0, max_clients - 1 do
		if player_list[i] and player_list[i].sessionTeam == 3 and et.gentity_get(i, "sess.spectatorClient") == victim then
			if player_list[i].nextStalk then
				et.gentity_set(i, "sess.latchSpectatorClient", player_list[i].nextStalk)
				player_list[i].specClient = player_list[i].nextStalk
				player_list[i].nextStalk = nil
			end
			player_list[i].specState = et.gentity_get(i, "sess.spectatorState")
			player_list[i].specReleasingTime = et_level_time
		end
	end
	--player_list[victim].obituary = killer
	player_list[victim].down = true
	if player_list[victim].reduceDamage then
		player_list[victim].reduceDamage = nil
		et.gentity_set(victim, "health", math.floor(et.gentity_get(victim, "health") / 6))
	end
	
	player_list[victim].switch.cnum = nil
	for key, value in pairs(player_list) do
		if value.switch and value.switch.cnum == victim then
			player_list[key].switch.cnum = nil
		end
	end
	
	--player_list[victim].onceLoadViewangles = true
	
	if ObituaryOnMap then
		ObituaryOnMap(victim, killer, meansOfDeath, player_list)
	end
end

function et_RunFrame(levelTime)
	et_level_time = levelTime
	
	for key, value in pairs(voter_list) do
		--[[ Complaints should be disabled for votes.
		if value.obituary and et.gentity_get(value.obituary, "sess.sessionTeam") == et.gentity_get(key, "sess.sessionTeam")
			et.gentity_set(i, "pers.complaintEndTime", -1)
			et.gentity_set(i, "pers.complaintClient", -1)
			et.trap_SendServerCommand("complaint -2")
			voter_list[key].obituary = nil
		end]]

		if value.nextIncr == nil and value.callvotesLeft < vote.limit then
			voter_list[key].nextIncr = levelTime + vote.perSeconds * 1000
		elseif value.nextIncr and levelTime >= value.nextIncr then
			if value.callvotesLeft < vote.limit then
				voter_list[key].callvotesLeft = value.callvotesLeft + 1
			end
			if value.callvotesLeft < vote.limit then
				voter_list[key].nextIncr = levelTime + vote.perSeconds * 1000
			else
				voter_list[key].nextIncr = nil
			end
		end
		
		if value.call then
			if et.gentity_get(key, "pers.voteCount") > value.count then
				if value.call == "kick" or value.call == "surrender" then
					voter_list[key].callvotesLeft = value.callvotesLeft - 1
					if not voter_list[key].nextIncr then
						voter_list[key].nextIncr = levelTime + vote.perSeconds * 1000
					end
					ResetVoteFlags()
				elseif vote.time and levelTime >= vote.time + 1100 and vote.yes >= vote.players * (VOTE_PERCENT / 100) then
					et.trap_Cvar_Set("vote_percent", 0)
					et.trap_SendServerCommand(-1, string.format("print \"^oVotes^7: Yes:%d No:%d Abstain:%d\n\"", vote.yes, vote.no, vote.abstain))
					ResetVoteFlags()
				elseif vote.time and levelTime >=  vote.time + 30000 then
					if vote.yes >= 1 and vote.yes >= (vote.yes + vote.no) * (VOTE_PERCENT / 100) then
						et.trap_Cvar_Set("vote_percent", 0)
					else
						voter_list[key].callvotesLeft = value.callvotesLeft - 1
						if not voter_list[key].nextIncr then
							voter_list[key].nextIncr = levelTime + vote.perSeconds * 1000
						end
					end
					et.trap_SendServerCommand(-1, string.format("print \"^gVotes^7: Yes:%d No:%d Abstain:%d\n\"", vote.yes, vote.no, vote.abstain))
					ResetVoteFlags()
				elseif not vote.inProgress then
					vote.caller = key
					vote.agenda = value.call
					vote.time = tonumber(et.trap_GetConfigstring(et.CS_VOTE_TIME))
					if not vote.time then
						ResetVoteFlags()
						break
					end
					vote.time = vote.time - 100
					et.trap_SetConfigstring(et.CS_VOTE_TIME, vote.time)
					vote.inProgress = true
				end
			else
				ResetVoteFlags()
			end
		end
	end
	
	if tonumber(et.trap_GetConfigstring(et.CS_VOTE_TIME)) == vote2.time then
		if levelTime >= vote2.time + 30000 then
			local function ResetVoteTime()
				vote2.time = -30000
				et.trap_SetConfigstring(et.CS_VOTE_TIME, "")
			end
			
			CountVotes2()
			if gamestate == GS_INTERMISSION then
				et.trap_SendServerCommand(-1, "cpm \"^9Vote failed.\n\"")
				ResetVoteTime()
			elseif vote2.yes >= 1 and vote2.yes + vote2.yesInGame >= (vote2.yes + vote2.yesInGame + vote2.no + vote2.noInGame) * (VOTE_PERCENT / 100) and (vote2.called[1] ~= "kick" or vote2.yes > (vote2.yes + vote2.no) / 2) then
				--et.trap_SendServerCommand(-1, string.format("print \"^gVotes^7: Y:%d N:%d\n\"", vote2.yes, vote2.no))
				--et.trap_SendConsoleCommand(et.EXEC_APPEND, "wait 20; clearvote;")
				if (vote2.called[1] == "putspec" or vote2.called[1] == "kick") and vote2.faded < 1 and (vote2.yesInGame <= vote2.playersInGame / 2 or vote2.called[1] == "kick" and vote2.yes <= vote2.players / 2) then
					for key, value in pairs(voter_list) do
						if value.vote == VOTE_YES then
							voter_list[key].vote = nil
						end
					end
					vote2.faded = vote2.faded + 1
					CountVotes2()
					vote2.time = levelTime - 15000
					et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
					et.trap_SendServerCommand(-1, "cpm \"^3Are you sure?\n\"")
					et.G_globalSound("sound/misc/vote.wav")	
				elseif vote2.called[1] == "saveload" and vote2.faded < 1 and et.trap_Cvar_Get("jh_nosaveload") == "1" and (vote2.called[2] == "1" and et.trap_Cvar_Get("jh_saveload") ~= "1" or vote2.called[2] == "2") and vote2.yesInGame < (vote2.playersInGame + vote2.no - vote2.noInGame) * (VOTE_PERCENT / 100) then
					for key, value in pairs(voter_list) do
						if value.vote == VOTE_YES then
							voter_list[key].vote = nil
						end
					end
					vote2.faded = vote2.faded + 1
					CountVotes2()
					vote2.time = levelTime - 20000
					et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
					et.trap_SetConfigstring(et.CS_VOTE_STRING, "Are you 4real?")
					et.G_globalSound("sound/misc/vote.wav")
				elseif vote2.faded < 1 and vote2.yesInGame < vote2.playersInGame * (VOTE_PERCENT / 100) and vote2.called[1] ~= "poll" and vote2.called[1] ~= "fun" and vote2.called[1] ~= "cointoss" then
					vote2.faded = vote2.faded + 1
					vote2.time = levelTime - (vote2.timeCalled - vote2.time)
					et.trap_SetConfigstring(et.CS_VOTE_TIME, vote2.time)
					et.trap_SendServerCommand(-1, string.format("cpm \"^3Join the vote or it will pass in %d seconds.\n\"", (vote2.time + 30000 - levelTime) / 1000))
					et.G_globalSound("sound/misc/vote.wav")
				else
					et.trap_SendServerCommand(-1, string.format("cpm \"^5Vote passed. %s\n\"", GetVoteResult()))
					ExecVoteContent(vote2.called)
					ResetVoteTime()
				end
			else
				DecreaseVoteLimit(2)
				et.trap_SendServerCommand(-1, string.format("print \"^gVotes^7: Y:%d N:%d\n\"", vote2.yes, vote2.no))
				et.trap_SendServerCommand(-1, string.format("cpm \"^2Vote FAILED! %s\n\"", GetVoteResult()))
				ResetVoteTime()
			end
		elseif not vote2.processed and levelTime >= vote2.timeCalled + VOTE_HESITATION then
			CountVotes2()
			if vote2.yes >= 1 and vote2.yesInGame >= vote2.playersInGame * (VOTE_PERCENT / 100) and vote2.yes >= vote2.players * (VOTE_PERCENT / 100) then
				--et.trap_SendServerCommand(-1, string.format("print \"^oVotes^7: Yes:%d No:%d / %d\n\"", vote2.yes, vote2.no, vote2.players))
				et.trap_SendServerCommand(-1, string.format("cpm \"^5Vote passed. %s\n\"", GetVoteResult()))
				--et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; wait 5; clearvote;"))
				et.trap_SetConfigstring(et.CS_VOTE_TIME, "")
				vote2.time = -30000
				ExecVoteContent(vote2.called)
			end
			vote2.processed = true
		end
	end
	
	for key, value in pairs(revived_players) do
		table.remove(revived_players, key)
		
		local damageRatio = tonumber(et.trap_Cvar_Get("jh_reviveDamageRatio"))
		if not damageRatio then
			damageRatio = 6
		end
		
		if REVIVE_HEALTH_MANAGEMENT then
			et.gentity_set(value, "health", REVIVE_BASE_HEALTH + math.floor(player_list[value].health / damageRatio))
		end
		local reviveAdren = tonumber(et.trap_Cvar_Get("jh_reviveAdren"))
		if et.trap_Cvar_Get("g_fastRes") == "1" then
			et.gentity_set(value, "ps.powerups", 1, 0)
			if reviveAdren then
				et.gentity_set(value, "ps.powerups", 12, levelTime + reviveAdren)
			elseif REVIVE_ADREN then
				et.gentity_set(value, "ps.powerups", 12, levelTime + REVIVE_ADREN)
			end
		else
			local reviveInvul = tonumber(et.trap_Cvar_Get("jh_reviveInvul"))
			if reviveInvul then
				et.gentity_set(value, "ps.powerups", 1, levelTime + reviveInvul)
			elseif REVIVE_INVUL then
				et.gentity_set(value, "ps.powerups", 1, levelTime + REVIVE_INVUL)
			end
			if reviveAdren then
				et.gentity_set(value, "ps.powerups", 12, levelTime + reviveAdren)
			elseif REVIVE_ADREN then
				et.gentity_set(value, "ps.powerups", 12, levelTime + REVIVE_ADREN)
			end
		end

		local reviveReduceDamage = tonumber(et.trap_Cvar_Get("jh_reviveReduceDamage"))
		if reviveReduceDamage and reviveReduceDamage > 0 then
			player_list[value].maxHealth = et.gentity_get(value, "ps.stats", 4)
			local tempHealth = et.gentity_get(value, "health") * damageRatio
			et.gentity_set(value,"health", tempHealth)
			et.gentity_set(value, "ps.stats", 4, player_list[value].maxHealth * damageRatio)
			player_list[value].health = tempHealth
			player_list[value].reduceDamage = et_level_time + reviveReduceDamage
			player_list[value].healthRatio = damageRatio
		end
	end
	for i = 0, max_clients - 1 do
		if player_list[i] then
			--player_list[i].origin = et.gentity_get(i, "origin")
			
			local currentHealth = et.gentity_get(i, "health")
			if player_list[i].reduceDamage and levelTime <= player_list[i].reduceDamage then
				local healthDiff = currentHealth - player_list[i].health
				if healthDiff > 3 then
					currentHealth = player_list[i].health + healthDiff * player_list[i].healthRatio
					local maxHealth = et.gentity_get(i, "ps.stats", 4)
					if currentHealth > maxHealth then
						currentHealth = maxHealth
					end
					et.gentity_set(i, "health", currentHealth)
				end
			end
			player_list[i].health = currentHealth
			if player_list[i].reduceDamage and levelTime >= player_list[i].reduceDamage then
				player_list[i].reduceDamage = nil
				et.gentity_set(i, "health", math.ceil(et.gentity_get(i, "health") / player_list[i].healthRatio))
				et.gentity_set(i, "ps.stats", 4, player_list[i].maxHealth)
			end
		end
	end
	
	if RunFrameOnMap then
		RunFrameOnMap()
	end
end

function et_Quit()
	et.trap_Cvar_Set("vote_percent", VOTE_PERCENT)
	if VOTE_HANDLE then
		et.trap_SendConsoleCommand(et.EXEC_NOW, "cancelvote")
		et.trap_SetConfigstring(et.CS_VOTE_TIME, "")
	end
end

--[[function LoadMapLua()
	local fd, len = et.trap_FS_FOpenFile(string.format("maps/%s.lua", mapname), et.FS_READ)
	if len > 0 then
		local dat = et.trap_FS_Read(fd, len)
		local func = loadstring(dat)
		if func then
			func()
		else
			et.G_Print(string.format("error loading %s.lua\n", mapname))
		end
	end
	et.trap_FS_FCloseFile(fd)
end]]

function CountVotes()
	vote.yes, vote.no, vote.abstain, vote.players = 0, 0, 0, 0
	for i = 0, max_clients - 1 do
		if player_list[i] and player_list[i].sessionTeam < 3 then
			if voter_list[i].vote == VOTE_ABSTAIN then
				vote.abstain = vote.abstain + 1
			else
				if voter_list[i].vote == VOTE_YES then
					vote.yes = vote.yes + 1
				elseif voter_list[i].vote == VOTE_NO then
					vote.no = vote.no + 1
				end
				vote.players = vote.players + 1
			end
		end
	end
	et.trap_SetConfigstring(et.CS_VOTE_YES, vote.yes)
	et.trap_SetConfigstring(et.CS_VOTE_NO, vote.no)
end
function CountVotes2()
	vote2.yes, vote2.no, vote2.abstain, vote2.players = 0, 0, 0, 0
	vote2.yesInGame, vote2.noInGame, vote2.abstainInGame, vote2.playersInGame = 0, 0, 0, 0
	for i = 0, max_clients - 1 do
	for continue = 0, 0 do
		if voter_list[i] then
			local lastActivityTime
			local specInactivity
			if not voter_list[i].vote and vote2.called[1] ~= "kick" and vote2.called[1] ~= "putspec" then
				specInactivity = tonumber(et.trap_Cvar_Get("vote_spectatorInactivityTime"))
				ingameInactivity = tonumber(et.trap_Cvar_Get("vote_ingameInactivityTime"))
				if not specInactivity then
					specInactivity = 300
				end
				if not ingameInactivity then
					ingameInactivity = 300
				end
				et.trap_Cvar_Set("returnvalue", "")
				et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("getlastactivitytime %d", i))
				lastActivityTime = tonumber(et.trap_Cvar_Get("returnvalue"))
			end
			
			if player_list[i].sessionTeam < 3 then
				if lastActivityTime and vote2.timeCalled - lastActivityTime >= (ingameInactivity + specInactivity) * 1000 then
					break --continue
				end
				
				if voter_list[i].vote == VOTE_ABSTAIN then
					vote2.abstainInGame = vote2.abstainInGame + 1
				elseif not (lastActivityTime and vote2.timeCalled - lastActivityTime >= ingameInactivity * 1000) then
					if voter_list[i].vote == VOTE_YES then
						vote2.yesInGame = vote2.yesInGame + 1
					elseif voter_list[i].vote == VOTE_NO then
						vote2.noInGame = vote2.noInGame + 1
					end
					vote2.playersInGame = vote2.playersInGame + 1
				end
			elseif lastActivityTime and vote2.timeCalled - lastActivityTime >= specInactivity * 1000 then
				break --continue
			end
			
			if voter_list[i].vote == VOTE_ABSTAIN then
				vote2.abstain = vote2.abstain + 1
			else
				if voter_list[i].vote == VOTE_YES then
					vote2.yes = vote2.yes + 1
				elseif voter_list[i].vote == VOTE_NO then
					vote2.no = vote2.no + 1
				end
				vote2.players = vote2.players + 1
			end
		end
	end --continue
	end
	et.trap_SetConfigstring(et.CS_VOTE_YES, vote2.yes)
	et.trap_SetConfigstring(et.CS_VOTE_NO, vote2.no)
end
function ResetVoteFlags()
	vote.yes, vote.no, vote.players = 0, 0, nil
	vote.time = nil
	vote.inProgress = false
	vote.caller = nil
	vote.agenda = nil
	vote2.processed = false
	vote2.faded = 0
	for i = 0, max_clients - 1 do
		if voter_list[i] then
			if voter_list[i].afk then
				voter_list[i].vote = VOTE_ABSTAIN
			else
				voter_list[i].vote = nil
			end
			voter_list[i].call = nil
			voter_list[i].count = et.gentity_get(i, "pers.voteCount")
			voter_list[i].interval = 0
			voter_list[i].intervalNo = 0
			voter_list[i].intervalYes = 0
		end
	end
end
function DecreaseVoteLimit(voteType)
	local caller
	if voteType == 1 then
		caller = vote.caller
	elseif voteType == 2 then
		caller = vote2.caller
	end
	if caller then
		voter_list[caller].callvotesLeft = voter_list[caller].callvotesLeft - 1
		if not voter_list[caller].nextIncr then
			voter_list[caller].nextIncr = et_level_time + vote.perSeconds * 1000
		end
	end
end

function SearchForClient(name)
	if string.len(name) < 1 then
		return NAME_TOO_SHORT_KEYWORD
	end

	local playerNames = {}
	for i = 0, max_clients - 1 do
		if player_list[i] then
			--local userinfo = et.trap_GetUserinfo(i)
			--playerNames[i] = et.Info_ValueForKey(userinfo, "originalname")
			playerNames[i] = et.gentity_get(i, "pers.netname")
		end
	end

	local match = nil
	if name ~= et.Q_CleanStr(name) then
		for key, value in pairs(playerNames) do
			if value == name then
				if not match then
					match = key
				else
					return NAME_MULTIPLE_MATCH
				end
			end
		end
	else
		for key, value in pairs(playerNames) do
			if et.Q_CleanStr(value) == name then
				if not match then
					match = key
				else
					return NAME_MULTIPLE_MATCH
				end
			end
		end
	end
	if match then
		return match
	end
	
	if string.len(name) < 2 or string.len(et.Q_CleanStr(name)) < 1 then
		return NAME_TOO_SHORT_KEYWORD
	end
	
	match = nil	
	if name ~= et.Q_CleanStr(name) then	
		for key, value in pairs(playerNames) do
			if string.find(string.lower(value), string.lower(name), 1, true) then
				if not match then
					match = key
				else
					return NAME_MULTIPLE_MATCH
				end
			end
		end
	else
		for key, value in pairs(playerNames) do
			if string.find(string.lower(et.Q_CleanStr(value)), string.lower(name), 1, true) then
				if not match then
					match = key
				else
					return NAME_MULTIPLE_MATCH
				end
			end
		end
	end
	if match then
		return match
	end
	
	return NAME_NO_MATCH
end

function GetArgList(args)
	local argList = {}
	local i = 0
	for str in string.gmatch(args, "%S+") do
		argList[i] = str
		i = i + 1
	end
	return argList
end

function ExecVoteContent(content)
	et.G_LogPrint(string.format("Vote Passed: %s\n", vote2.votingFor))
	if content[1] == "map" then
		et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; map %s;", content[2]))
	elseif content[1] == "campaign" then
		et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; campaign %s;", content[2]))
	elseif content[1] == "timelimit" then
		et.trap_Cvar_Set("timelimit", tonumber(content[2]))
	elseif content[1] == "friendlyfire" then
		if content[2] == "1" then
			et.trap_Cvar_Set("g_friendlyFire", 1)
			et.trap_SendServerCommand(-1, "cpm \"^3Friendly Fire is: ^5ENABLED\n\"")
		elseif content[2] == "0" then
			et.trap_Cvar_Set("g_friendlyFire", 0)
			et.trap_SendServerCommand(-1, "cpm \"^3Friendly Fire is: ^5DISABLED\n\"")
		end
	elseif content[1] == "saveload" then
		if content[2] == "1" then
			et.trap_SendServerCommand(-1, "cpm \"^3Save^9/^3Load is: ^5ENABLED\n\"")
			if et.trap_Cvar_Get("jh_nosaveload") == "1" and et.trap_Cvar_Get("jh_saveload") ~= "1" then
				et.trap_SendServerCommand(-1, "cpm \"Players who voted yes are: Lolz\n\"")
				for i = 0, max_clients - 1 do
					if voter_list[i] and voter_list[i].vote == VOTE_YES or vote2.caller == i then
						et.trap_SendServerCommand(i, "cp \"^1You are Lolz\n\"")
					end
				end
			end
			saveMaxUPS = tonumber(et.trap_Cvar_Get("jh_saveMaxUPS"))
			alliedSaveMaxUPS = tonumber(et.trap_Cvar_Get("jh_alliedSaveMaxUPS"))
			axisSaveMaxUPS = tonumber(et.trap_Cvar_Get("jh_axisSaveMaxUPS"))
			if not saveMaxUPS then
				saveMaxUPS = 300
			end
			et.trap_Cvar_Set("jh_saveload", "1")
		elseif content[2] == "0" then
			et.trap_Cvar_Set("jh_saveload", "0")
			et.trap_SendServerCommand(-1, "cpm \"^3Save^9/^3Load is: ^5DISABLED\n\"")
		end
	elseif content[1] == "axissaveload" then
		if content[2] == "0" then
			axis_save_load = false
		else
			axis_save_load = true
		end
	elseif content[1] == "alliedsaveload" then
		if content[2] == "0" then
			allied_save_load = false
		else
			allied_save_load = true
		end
	elseif content[1] == "numberednames" then
		if content[2] == "1" then
			et.trap_Cvar_Set("sv_numberedNames", "1")
		elseif content[2] == "0" then
			et.trap_Cvar_Set("sv_numberedNames", "0")
		end
	elseif content[1] == "maprestart" then
		et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; map_restart 0 %d;", GS_WARMUP))
	elseif content[1] == "nextmap" then
		if tonumber(et.trap_Cvar_Get("g_gametype")) == GT_WOLF_CAMPAIGN then
			et.trap_SendConsoleCommand(et.EXEC_APPEND, "; vstr nextcampaign;")
		else
			et.trap_SendConsoleCommand(et.EXEC_APPEND, "; vstr nextmap;")
		end
	elseif content[1] == "gametype" then
		et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; ref gametype %s;", content[2]))
		et.trap_Cvar_Set("jh_gametype", math.floor(tonumber(content[2])))
	elseif content[1] == "cointoss" then
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "; ref cointoss;")
	elseif content[1] == "fun" then
		if content[2] == "gaychan" then
			et.trap_SendConsoleCommand(et.EXEC_INSERT, string.format("exec AA/gaychan.cfg;"))
			et.G_globalSound("mk/pw/heike.wav")
		elseif content[2] == "neko" then
			et.trap_SendConsoleCommand(et.EXEC_INSERT, string.format("exec AA/NeKo_big.cfg"))
			et.G_globalSound("mk/cotm/nyan.wav")
		end
	elseif type(content[2]) == "number" and et.gentity_get(content[2], "inuse") then
		if content[1] == "mute" then
			et.gentity_set(content[2], "sess.muted", 1)
			et.ClientUserinfoChanged(content[2])
		elseif content[1] == "unmute" then
			et.gentity_set(content[2], "sess.muted", 0)
			et.ClientUserinfoChanged(content[2])
		elseif content[1] == "putspec" and et.gentity_get(content[2], "sess.sessionTeam") ~= 3 then
			et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; putspec %d;", content[2]))
		elseif content[1] == "kick" then
			if content[3] then
				et.trap_DropClient(content[2], content[3], 15)
			else
				et.trap_DropClient(content[2], "player kicked", 15)
			end
		end
	end
end

function GetVoteResult()
	return string.format("^3{Yes:%d^5(%d) ^3No:%d^5(%d) ^3of %d^5(%d) ^3Abstain:%d^5(%d)^3}", vote2.yes, vote2.yesInGame, vote2.no, vote2.noInGame, vote2.players, vote2.playersInGame, vote2.abstain, vote2.abstainInGame)
end

function GetDistance(origin1, origin2)
	local x1, x2, y1, y2, z1, z2 = origin1[1], origin2[1], origin1[2], origin2[2], origin1[3], origin2[3]
	local dist = math.sqrt((x1-x2)*(x1-x2) + (y1 - y2)*(y1 - y2) + (z1 - z2)*(z1 - z2))
	return dist
end

function IsIDNamesEnabled()
	local idNames = tonumber(et.trap_Cvar_Get("sv_numberedNames"))
	if idNames and math.abs(idNames) >= 1 then
		return true
	else
		return false
	end
end

function SwitchPositions(cnum1, cnum2)
	local team1, team2 = et.gentity_get(cnum1, "sess.sessionTeam"), et.gentity_get(cnum2, "sess.sessionTeam")
	if team1 == 3 and team2 == 3 then return SWITCH_ERROR_SPECTATOR end
	if team1 == 3 and team2 == 3 then return SWITCH_ERROR_SPECTATOR end
	
	local class1, class2
	local origin1, origin2
	local health1, health2
	local adrens1, adrens2
	local mainweap1, mainweap2
	local subweap1, subweap2
	local mainammoclip1, mainammoclip2
	local mainammo1, mainammo2
	local subammoclip1, subammoclip2
	local subammo1, subammo2
	if team1 ~= 3 then
		class1 = player_list[cnum1].playerType
		origin1 = et.gentity_get(cnum1, "origin")
		health1 = et.gentity_get(cnum1, "health")
		adrens1 = et.gentity_get(cnum1, "ps.ammoclip", 11)
		mainweap1 = GetMainWeapon(cnum1, class1)
		subweap1 = et.gentity_get(cnum1, "sess.playerWeapon2")
		mainammoclip1 = et.gentity_get(cnum1, "ps.ammoclip", mainweap1)
		mainammo1 = et.gentity_get(cnum1, "ps.ammo", mainweap1)
		subammoclip1 = et.gentity_get(cnum1, "ps.ammoclip", subweap1)
		subammo1 = et.gentity_get(cnum1, "ps.ammo", subweap1)
	end
	if team2 ~= 3 then
		class2 = player_list[cnum2].playerType
		origin2 = et.gentity_get(cnum2, "origin")
		health2 = et.gentity_get(cnum2, "health")
		adrens2 = et.gentity_get(cnum2, "ps.ammoclip", 11)
		mainweap2 = GetMainWeapon(cnum2, class2)
		subweap2 = et.gentity_get(cnum2, "sess.playerWeapon2")
		mainammoclip2 = et.gentity_get(cnum2, "ps.ammoclip", mainweap2)
		mainammo2 = et.gentity_get(cnum2, "ps.ammo", mainweap2)
		subammoclip2 = et.gentity_get(cnum2, "ps.ammoclip", subweap2)
		subammo2 = et.gentity_get(cnum2, "ps.ammo", subweap2)
	end
	local nades1, nades2, rgammoclip1, rgammoclip2, rgammo1, rgammo2
	if mainweap1 == 23 then
		rgammoclip1 = et.gentity_get(cnum1, "ps.ammoclip", 39)
		rgammo1 = et.gentity_get(cnum1, "ps.ammo", 39)
	elseif mainweap1 == 24 then
		rgammoclip1 = et.gentity_get(cnum1, "ps.ammoclip", 40)
		rgammo1 = et.gentity_get(cnum1, "ps.ammo", 40)
	end
	if mainweap2 == 23 then
		rgammoclip2 = et.gentity_get(cnum2, "ps.ammoclip", 39)
		rgammo2 = et.gentity_get(cnum2, "ps.ammo", 39)
	elseif mainweap2 == 24 then
		rgammoclip2 = et.gentity_get(cnum2, "ps.ammoclip", 40)
		rgammo2 = et.gentity_get(cnum2, "ps.ammo", 40)
	end
	if team1 == 1 then
		nades1 = et.gentity_get(cnum1, "ps.ammoclip", 4)
	elseif team1 == 2 then
		nades1 = et.gentity_get(cnum1, "ps.ammoclip", 9)
	end
	if team2 == 1 then
		nades2 = et.gentity_get(cnum2, "ps.ammoclip", 4)
	elseif team2 == 2 then
		nades2 = et.gentity_get(cnum2, "ps.ammoclip", 9)
	end
	
	et.trap_Cvar_Set("returnvalue", "")
	et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("getviewangles %d", cnum1))
	local viewangles1 = et.trap_Cvar_Get("returnvalue")
	et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("getviewangles %d", cnum2))
	local viewangles2 = et.trap_Cvar_Get("returnvalue")
	
	local nofatigue1, nofatigue2 = player_list[cnum1].nofatigue, player_list[cnum2].nofatigue
	if nofatigue1 == false and player_list[cnum1].usedCheatAdren then
		nofatigue1 = nil
	end
	if nofatigue2 == false and player_list[cnum2].usedCheatAdren then
		nofatigue2 = nil
	end
	
	local setTo1 = { cnum = cnum2, origin = origin2, health = health2, adren = adrens2, nades = nades2, mainweap = mainweap2, rgammoclip = rgammoclip2, rgammo = rgammo2, 
	mainammoclip = mainammoclip2, mainammo = mainammo2, subammoclip = subammoclip2, subammo = subammo2, currentweap = et.gentity_get(cnum2, "s.weapon"), viewangles = viewangles2, nofatigue = nofatigue2, 
	usedCheatAdren = player_list[cnum2].usedCheatAdren, loaded = player_list[cnum2].loaded, finished = player_list[cnum2].finished, noclipped = player_list[cnum2].noclipped, }
	local setTo2 = { cnum = cnum1, origin = origin1, health = health1, adren = adrens1, nades = nades1, mainweap = mainweap1, rgammoclip = rgammoclip1, rgammo = rgammo1, 
	mainammoclip = mainammoclip1, mainammo = mainammo1, subammoclip = subammoclip1, subammo = subammo1, currentweap = et.gentity_get(cnum1, "s.weapon"), viewangles = viewangles1, nofatigue = nofatigue1, 
	usedCheatAdren = player_list[cnum1].usedCheatAdren, loaded = player_list[cnum1].loaded, finished = player_list[cnum1].finished, noclipped = player_list[cnum1].noclipped, }
	
	player_list[cnum1].onceLoadViewangles = true
	player_list[cnum2].onceLoadViewangles = true

	if team1 == team2 and class1 == class2 and et.gentity_get(cnum1, "ps.powerups", 6) == 0 and et.gentity_get(cnum1, "ps.powerups", 7) == 0 and et.gentity_get(cnum2, "ps.powerups", 6) == 0 and et.gentity_get(cnum2, "ps.powerups", 7) == 0 then
		SetPosition(cnum1, setTo1)
		SetPosition(cnum2, setTo2)
		et.gentity_set(cnum1, "ps.powerups", 1, et_level_time)
		et.gentity_set(cnum2, "ps.powerups", 1, et_level_time)
		et.gentity_set(cnum1, "ps.powerups", 12, 0)
		et.gentity_set(cnum2, "ps.powerups", 12, 0)
		return 0
	elseif tonumber(et.trap_Cvar_Get("g_bluelimbotime")) <= 5000 and tonumber(et.trap_Cvar_Get("g_redlimbotime")) <= 5000 then
		player_list[cnum1].switchto = setTo1
		player_list[cnum2].switchto = setTo2
		
		--et.gentity_set(cnum1, "sess.latchPlayerWeapon", mainweap2)
		--et.gentity_set(cnum2, "sess.latchPlayerWeapon", mainweap1)
		et.gentity_set(cnum1, "ps.powerups", 1, 0)
		et.gentity_set(cnum2, "ps.powerups", 1, 0)
		et.G_Damage(cnum1, cnum2, 1022, 500, 0, 33)
		et.G_Damage(cnum2, cnum1, 1022, 500, 0, 33)
		if team1 == 3 then
			et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; putspec %d;", cnum2))
			player_list[cnum2].specState = 2
			player_list[cnum2].specReleasingTime = et_level_time
			et.gentity_set(cnum2, "sess.latchSpectatorClient", cnum1)
		else
			et.gentity_set(cnum2, "sess.sessionTeam", team1)
			et.gentity_set(cnum2, "sess.latchPlayerType", class1)
			et.gentity_set(cnum2, "sess.latchPlayerWeapon2", subweap1)
		end
		if team2 == 3 then
			et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; putspec %d;", cnum1))
			player_list[cnum1].specState = 2
			player_list[cnum1].specReleasingTime = et_level_time
			et.gentity_set(cnum1, "sess.latchSpectatorClient", cnum2)
		else
			et.gentity_set(cnum1, "sess.sessionTeam", team2)
			et.gentity_set(cnum1, "sess.latchPlayerType", class2)
			et.gentity_set(cnum1, "sess.latchPlayerWeapon2", subweap2)
		end
		--et.gentity_set(cnum1, "health", -300)
		--et.gentity_set(cnum2, "health", -300)
		et.ClientUserinfoChanged(cnum1)
		et.ClientUserinfoChanged(cnum2)

		return 0
	end
end

function ReadyToSwitch(clientNum, switchWith, seconds)
	if switchWith == clientNum then
		return
	end
	player_list[clientNum].switch.cnum = switchWith
	player_list[clientNum].switch.time = et_level_time + seconds * 1000
	if player_list[switchWith].switch.cnum == clientNum and player_list[switchWith].switch.time >= et_level_time then
		if et.gentity_get(clientNum, "health") <= 0 or et.gentity_get(switchWith, "health") <= 0 then
			et.trap_SendServerCommand(clientNum, "chat \"Both players should be alive to switch positions.\"")
			et.trap_SendServerCommand(switchWith, "chat \"Both players should be alive to switch positions.\"")
			return
		end
		-- Modified ET required
		et.trap_Cvar_Set("returnvalue", "")
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("getvelocity %d", clientNum))
		local velocity = et.trap_Cvar_Get("returnvalue")
		local f, t, val1, val2, val3 = string.find(velocity, "(%S+)%s+(%S+)%s+(%S+)")
		local x, y, z = tonumber(val1), tonumber(val2), tonumber(val3)
		if x and y and z and math.sqrt(x * x + y * y + z * z) >= 100 then
			et.trap_SendServerCommand(clientNum, "chat \"Both players should stand still while switching.\"")
			et.trap_SendServerCommand(switchWith, "chat \"Both players should stand still while switching.\"")
			return
		end
		local result = SwitchPositions(clientNum, switchWith)
		if  result == 0 then
			--et.trap_SendServerCommand(-1, string.format("cpm \"^7%d;%s ^7and %d;%s ^7have switched their positions.\"", value.cnum1, et.gentity_get(value.cnum1, "pers.netname"), value.cnum2, et.gentity_get(value.cnum2, "pers.netname")))
			if IsIDNamesEnabled() then
				--et.trap_SendConsoleCommand(et.EXEC_INSERT, string.format("cpm2 -1 \"^7%s ^7and %s ^7have switched their positions.\"", et.gentity_get(clientNum, "pers.netname"), et.gentity_get(switchWith, "pers.netname")))
				et.trap_SendServerCommand(-1, string.format("cpm \"%s^7 and %s^7 have switched their positions.\"", et.gentity_get(clientNum, "pers.netname"), et.gentity_get(switchWith, "pers.netname")))
			else
				--et.trap_SendConsoleCommand(et.EXEC_INSERT, string.format("cpm2 -1 \"^7%d;%s ^7and %d;%s ^7have switched their positions.\"", clientNum, et.gentity_get(clientNum, "pers.netname"), switchWith, et.gentity_get(switchWith, "pers.netname")))
				et.trap_SendServerCommand(-1, string.format("cpm \"%d;%s^7 and %d;%s^7 have switched their positions.\"", clientNum, et.gentity_get(clientNum, "pers.netname"), switchWith, et.gentity_get(switchWith, "pers.netname")))
			end
			player_list[clientNum].switch.cnum = nil
			player_list[switchWith].switch.cnum = nil
		elseif result == SWITCH_ERROR_SPECTATOR then
			et.trap_SendServerCommand(clientNum, "chat \"Spectators cannot switch.\"")
			et.trap_SendServerCommand(switchWith, "chat \"Spectators cannot switch.\"")
		else
			et.trap_SendServerCommand(clientNum, "chat \"Both players have to be on the same team and the same class.\"")
			et.trap_SendServerCommand(switchWith, "chat \"Both players have to be on the same team and the same class.\"")
		end
	else
		if IsIDNamesEnabled() then
			et.trap_SendServerCommand(clientNum, string.format('chat "You are ready to switch positions with %s ^7for %s seconds."', et.gentity_get(switchWith, "pers.netname"), seconds))
		else
			et.trap_SendServerCommand(clientNum, string.format('chat "You are ready to switch positions with %d;%s ^7for %s seconds."', switchWith, et.gentity_get(switchWith, "pers.netname"), seconds))
		end
	end
end

function SavePosition(clientNum, saveNum, tempSave)
	local team = player_list[clientNum].sessionTeam
	if team < 3 and et.gentity_get(clientNum, "health") >= 1 then
		if NoSaveZone and NoSaveZone(clientNum, {temp = true}) then
			et.trap_SendServerCommand(clientNum, "cpm \"^3You can't save here.")
			return false
		end
		et.trap_Cvar_Set("returnvalue", "")
		-- ET needs to be modified to make this work
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("getvelocity %d", clientNum))
		--et.G_Print("velocity: " .. et.trap_Cvar_Get("returnvalue") .. "\n")
		local velocity = et.trap_Cvar_Get("returnvalue")
		local f, t, val1, val2, val3 = string.find(velocity, "(.+) (.+) (.+)")
		local x, y, z = tonumber(val1), tonumber(val2), tonumber(val3)
		if x and y and z then
			local UPS = math.sqrt(x * x + y * y + z * z)
			if saveMaxUPS > 0 and UPS >= saveMaxUPS
			or axisSaveMaxUPS and et.gentity_get(clientNum, "sess.sessionTeam") == 1 and UPS >= axisSaveMaxUPS
			or alliedSaveMaxUPS and et.gentity_get(clientNum, "sess.sessionTeam") == 2 and UPS >= alliedSaveMaxUPS
			or (player_list[clientNum].playerType ~= 1 and UPS > 320) then
				et.trap_SendServerCommand(clientNum, "cpm \"^3You can't save while moving.\"")
				return false
			end
		end
		
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("getviewangles %d", clientNum))
		local viewangles = et.trap_Cvar_Get("returnvalue")
		
		local class = player_list[clientNum].playerType
		local origin = et.gentity_get(clientNum, "origin")
		local health = et.gentity_get(clientNum, "health")
		local adrens = et.gentity_get(clientNum, "ps.ammoclip", 11)
		local mainweap = GetMainWeapon(clientNum, class)
		local subweap = et.gentity_get(clientNum, "sess.playerWeapon2")
		local rgammoclip, rgammo
		if mainweap == 23 then
			rgammoclip = et.gentity_get(clientNum, "ps.ammoclip", 39)
			rgammo = et.gentity_get(clientNum, "ps.ammo", 39)
		elseif mainweap == 24 then
			rgammoclip = et.gentity_get(clientNum, "ps.ammoclip", 40)
			rgammo = et.gentity_get(clientNum, "ps.ammo", 40)
		end
				
		local mainammoclip = et.gentity_get(clientNum, "ps.ammoclip", mainweap)
		local mainammo = et.gentity_get(clientNum, "ps.ammo", mainweap)
		local subammoclip = et.gentity_get(clientNum, "ps.ammoclip", subweap)
		local subammo = et.gentity_get(clientNum, "ps.ammo", subweap)
		local nades
		if team == 1 then
			nades = et.gentity_get(clientNum, "ps.ammoclip", 4)
		elseif team == 2 then
			nades = et.gentity_get(clientNum, "ps.ammoclip", 9)
		end
		if player_list[clientNum][team][class] == nil then
			player_list[clientNum][team][class] = {}
		end
		
		if player_list[clientNum].maxLoads then
			if player_list[clientNum].maxLoads < 1 then
				et.trap_SendServerCommand(clientNum, "cpm \"^3You can't load any more!\n\"")
				return
			end
		end
		
		local loaded
		if tempSave then
			loaded = player_list[clientNum].loaded
		else
			loaded = true
		end
		
		player_list[clientNum][team][class][saveNum] = { origin = origin, health = health, adren = adrens, velocity = velocity, viewangles = viewangles, nades = nades, rgammoclip = rgammoclip, rgammo = rgammo, 
		mainammoclip = mainammoclip, mainammo = mainammo, subammoclip = subammoclip, subammo = subammo, mainweap = mainweap, subweap = subweap, currentweap = et.gentity_get(clientNum, "s.weapon"), maxLoads = player_list[clientNum].maxLoads, 
		loaded = player_list[clientNum].loaded, usedCheatAdren = player_list[clientNum].usedCheatAdren, finished = player_list[clientNum].finished, noclipped = player_list[clientNum].noclipped, }
		
		player_list[clientNum].onceLoadViewangles = false
		
		return true
	else
		return false
	end
end

function GetMainWeapon(clientNum, class)
	local mainweap
	local subweap = et.gentity_get(clientNum, "sess.playerWeapon2")
	if not class then
		class = player_list[clientNum].playerType
	end
	if class == 0 then
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_MOBILE_MG42))
		if et.trap_Cvar_Get("returnvalue") == "true" then
			mainweap = WP_MOBILE_MG42
		else
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_FLAMETHROWER))
			if et.trap_Cvar_Get("returnvalue") == "true" then
				mainweap = WP_FLAMETHROWER
			else
				et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_PANZERFAUST))
				if et.trap_Cvar_Get("returnvalue") == "true" then
					mainweap = WP_PANZERFAUST
				else
					et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_MORTAR))
					if et.trap_Cvar_Get("returnvalue") == "true" then
						mainweap = WP_MORTAR
					elseif subweap == WP_MP40 then
						et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_THOMPSON))
						if et.trap_Cvar_Get("returnvalue") == "true" then
							mainweap = WP_THOMPSON
						else
							mainweap = WP_MP40
						end
					else
						et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_MP40))
						if et.trap_Cvar_Get("returnvalue") == "true" then
							mainweap = WP_MP40
						else
							mainweap = WP_THOMPSON
						end
					end
				end
			end
		end
	elseif class == 1 or class == 3 then
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_MP40))
		if et.trap_Cvar_Get("returnvalue") == "true" then
			mainweap = WP_MP40
		else
			mainweap = WP_THOMPSON
		end
	elseif class == 2 then
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, 23))
		if et.trap_Cvar_Get("returnvalue") == "true" then
			mainweap = 23
		else
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, 24))
			if et.trap_Cvar_Get("returnvalue") == "true" then
				mainweap = 24
			else
				et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_MP40))
				if et.trap_Cvar_Get("returnvalue") == "true" then
					mainweap = WP_MP40
				else
					mainweap = WP_THOMPSON
				end
			end
		end
	elseif class == 4 then
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_STEN))
		if et.trap_Cvar_Get("returnvalue") == "true" then
			mainweap = WP_STEN
		else
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_FG42))
			if et.trap_Cvar_Get("returnvalue") == "true" then
				mainweap = WP_FG42
			else
				et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponcheck %d %d", clientNum, WP_K43))
				if et.trap_Cvar_Get("returnvalue") == "true" then
					mainweap = WP_K43
				else
					mainweap = WP_GARAND
				end
			end
		end
	end
	return mainweap
end

function LoadPosition(clientNum, saveNum, respawn)
	local team = player_list[clientNum].sessionTeam
	local class = player_list[clientNum].playerType
	if respawn then
		team = respawn.team
		class = respawn.class
	end
	
	if player_list[clientNum][team][class] and player_list[clientNum][team][class][saveNum] then
		local anotherPlayer
		for i = 0, max_clients -1 do
			if i ~= clientNum and et.gentity_get(i, "inuse") and et.gentity_get(i, "sess.sessionTeam") < 3 then
				local dist = GetDistance(player_list[clientNum][team][class][saveNum].origin, et.gentity_get(i, "origin"))
				if dist <= 160 then
					anotherPlayer = true
					break
				end
			end
		end
		if anotherPlayer then
			if player_list[clientNum][team][class][saveNum].timeToLoad and et_level_time >= player_list[clientNum][team][class][saveNum].timeToLoad and et_level_time <= player_list[clientNum][team][class][saveNum].loadTill then
				player_list[clientNum][team][class][saveNum].timeToLoad = nil
			else
				if player_list[clientNum][team][class][saveNum].timeToLoad == nil or et_level_time > player_list[clientNum][team][class][saveNum].loadTill then
					player_list[clientNum][team][class][saveNum].timeToLoad = et_level_time + 1500
				end
				player_list[clientNum][team][class][saveNum].loadTill = et_level_time + 3000
				return LOAD_AT_ANOTHER_PLAYER
			end
		end
		player_list[clientNum][team][class][saveNum].timeToLoad = nil

		if player_list[clientNum][team][class][saveNum].maxLoads then
			if player_list[clientNum][team][class][saveNum].maxLoads < 1 then
				et.trap_SendServerCommand(clientNum, "cpm \"^3You can't load any more!\n\"")
				return
			end
			player_list[clientNum][team][class][saveNum].maxLoads = player_list[clientNum][team][class][saveNum].maxLoads - 1
			et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("; \"\";", clientNum, player_list[clientNum][team][class][saveNum].maxLoads))
		end
		if et.gentity_get(clientNum, "ps.powerups", 6) > 0 or et.gentity_get(clientNum, "ps.powerups", 7) > 0 then
			BeSwitchingTo(clientNum, team, class, saveNum)
			et.gentity_set(clientNum, "ps.powerups", 1, 0)
			et.G_Damage(clientNum, 1023, 1023, 500, 0, 33)
			et_Obituary(clientNum, 1023, 33)
		else
			if respawn or et.gentity_get(clientNum, "health") < 1 then
				BeSwitchingTo(clientNum, team, class, saveNum)
				--et.G_Damage(clientNum, 1022, 1022, 500, 0, 33)
				et.gentity_set(clientNum, "health", -300)
				et_Obituary(clientNum, 1023, 0)
			else
				SetPosition(clientNum, player_list[clientNum][team][class][saveNum])
				--et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("clearvelocity %d;", clientNum))  -- ET must be modified to make this work
		
				et.gentity_set(clientNum, "ps.powerups", 1, et_level_time)
				if et.gentity_get(clientNum, "ps.powerups", 12) <= et_level_time then
					et.gentity_set(clientNum, "ps.powerups", 12, et_level_time + 50)
				end
			end
		end
		
		return true
	else
		return false
	end
end

function SetPosition(clientNum, setTo)
	local team = et.gentity_get(clientNum, "sess.sessionTeam")
	local playerWeapon = GetMainWeapon(clientNum)
	if player_list[clientNum].sessionTeam ~= 3 and setTo.mainweap and playerWeapon ~= setTo.mainweap then
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponremove %d %d", clientNum, playerWeapon))
		if playerWeapon == 23 then
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponremove %d %d", clientNum, 39))
			et.gentity_set(clientNum, "ps.ammoclip", 39, 0)
		elseif playerWeapon == 24 then
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponremove %d %d", clientNum, 40))
			et.gentity_set(clientNum, "ps.ammoclip", 40, 0)
		elseif playerWeapon == WP_MOBILE_MG42 then
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponremove %d %d", clientNum, 49))
		elseif playerWeapon == WP_MORTAR then
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponremove %d %d", clientNum, 45))
		end
		et.gentity_set(clientNum, "ps.ammoclip", playerWeapon, 0)
		et.gentity_set(clientNum, "ps.ammo", playerWeapon, 0)
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponset %d %d", clientNum, setTo.mainweap))
		if setTo.mainweap == WP_MOBILE_MG42 then
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponset %d %d", clientNum, 49))
		elseif setTo.mainweap == WP_MORTAR then
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponset %d %d", clientNum, 45))
		elseif setTo.mainweap == WP_FG42 then
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponset %d %d", clientNum, 44))			
		elseif setTo.mainweap == WP_GARAND then
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponset %d %d", clientNum, 42))	
		elseif setTo.mainweap == WP_K43 then
			et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponset %d %d", clientNum, 43))		
		end
		local sWeapon = et.gentity_get(clientNum, "s.weapon")
		if sWeapon == playerWeapon --[[or sWeapon == 39 or sWeapon == 40]] or sWeapon == 49 or sWeapon == 45 then
			if setTo.currentweap then
				et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponchange %d %d", clientNum, setTo.currentweap))
			else
				et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponchange %d %d", clientNum, setTo.mainweap))
			end
		end
	end
	if setTo.currentweap and player_list[clientNum].onceLoadViewangles then
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponchange %d %d", clientNum, setTo.currentweap))
	end
	
	et.gentity_set(clientNum, "origin", setTo.origin)
	et.gentity_set(clientNum, "health", setTo.health)
	if setTo.mainammoclip then
		et.gentity_set(clientNum, "ps.ammoclip", setTo.mainweap, setTo.mainammoclip)
	end
	if setTo.mainammo then
		et.gentity_set(clientNum, "ps.ammo", setTo.mainweap, setTo.mainammo)
	end
	if setTo.subammoclip then
		et.gentity_set(clientNum, "ps.ammoclip", et.gentity_get(clientNum, "sess.playerWeapon2"), setTo.subammoclip)
	end
	if setTo.subammo then
		et.gentity_set(clientNum, "ps.ammo", et.gentity_get(clientNum, "sess.playerWeapon2"), setTo.subammo)
	end
	if setTo.adren and (player_list[clientNum].onceLoadViewangles or et.gentity_get(clientNum, "ps.ammoclip", 11) < setTo.adren) then
		et.gentity_set(clientNum, "ps.ammoclip", 11, setTo.adren)
		if setTo.adren > 12 then
			et.gentity_set(clientNum, "ps.ammo", 11, 9999)
		end
	end
	if et.gentity_get(clientNum, "sess.sessionTeam") == 1 then
		if setTo.nades then
			et.gentity_set(clientNum, "ps.ammoclip", 4, setTo.nades)
		end
	elseif et.gentity_get(clientNum, "sess.sessionTeam") == 2 then
		if setTo.nades then
			et.gentity_set(clientNum, "ps.ammoclip", 9, setTo.nades)
		end
	end
	if setTo.mainweap == 23 then
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponset %d %d", clientNum, 39))
		if setTo.rgammoclip then
			et.gentity_set(clientNum, "ps.ammoclip", 39, setTo.rgammoclip)
		end
		if setTo.rgammo then
			et.gentity_set(clientNum, "ps.ammo", 39, setTo.rgammo)
		end
	elseif setTo.mainweap == 24 then
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponset %d %d", clientNum, 40))
		if setTo.rgammoclip then
			et.gentity_set(clientNum, "ps.ammoclip", 40, setTo.rgammoclip)
		end
		if setTo.rgammo then
			et.gentity_set(clientNum, "ps.ammo", 40, setTo.rgammo)
		end
	end
	if setTo.nades then
		if team == 1 then
			et.gentity_set(clientNum, "ps.ammoclip", 4, setTo.nades)
		elseif team == 2 then
			et.gentity_set(clientNum, "ps.ammoclip", 9, setTo.nades)
		end
	end
	if setTo.velocity then
		--et.G_Print(string.format("%s\n", setTo.velocity))
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setvelocity %d %s", clientNum, setTo.velocity))  -- modified ET required
	end
	if setTo.viewangles and (player_list[clientNum].loadViewangles or player_list[clientNum].onceLoadViewangles) then
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setviewangles %d %s", clientNum, setTo.viewangles))
	end
	player_list[clientNum].onceLoadViewangles = false
	
	if setTo.maxLoads then
		player_list[clientNum].maxLoads = setTo.maxLoads
	end
	
	if setTo.nofatigue == true then
		et.gentity_set(clientNum, "ps.powerups", PW_NOFATIGUE, INT_MAX)
	elseif setTo.nofatigue == false then
		et.gentity_set(clientNum, "ps.powerups", PW_NOFATIGUE, 0)
	end
	if setTo.usedCheatAdren ~= nil then
		player_list[clientNum].usedCheatAdren = setTo.usedCheatAdren
	end
	if setTo.loaded ~= nil then
		player_list[clientNum].loaded = setTo.loaded
	end
	if setTo.finished ~= nil then
		player_list[clientNum].finished = setTo.finished
	end
end

function BeSwitchingTo(clientNum, team, class, saveNum)
	--[[local limbotime
	if team == 1 then
		limbotime = tonumber(et.trap_Cvar_Get("g_redlimbotime"))
	elseif team == 2 then
		limbotime = tonumber(et.trap_Cvar_Get("g_bluelimbotime"))
	end
	if limbotime == nil or limbotime > 5000 then
		return
	end]]
	player_list[clientNum].switchto = player_list[clientNum][team][class][saveNum]
	et.gentity_set(clientNum, "sess.sessionTeam", team)
	et.gentity_set(clientNum, "sess.latchPlayerType", class)
	--et.gentity_set(clientNum, "sess.latchPlayerWeapon", player_list[clientNum].switchto.mainweap)
	et.gentity_set(clientNum, "sess.latchPlayerWeapon2", player_list[clientNum].switchto.subweap)
	et.ClientUserinfoChanged(clientNum)
end

function MapInfo(mapName)
	local pakInfo
	local fd, len = et.trap_FS_FOpenFile("scripts/" .. mapName .. ".arena", et.FS_READ)
	if len < 0 then
		et.trap_Cvar_Set("returnvalue", "")
		et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("findmap r %s", mapName))
		local rv = et.trap_Cvar_Get("returnvalue")
		fd, len = et.trap_FS_FOpenFile("scripts/" .. rv .. ".arena", et.FS_READ)
		if len < 0 then
			pakInfo = PakInfoForFile("maps/" .. mapName .. ".bsp")
			if pakInfo then
				return {findmap = rv, pak = pakInfo}
			else
				return {findmap = rv}
			end
		end
		pakInfo = PakInfoForFile("maps/" .. rv .. ".bsp")
	else
		pakInfo = PakInfoForFile("maps/" .. mapName .. ".bsp")
	end
	local filedata = et.trap_FS_Read(fd, len)
	
	et.trap_FS_FCloseFile(fd)
	
	local f, t, map, longName, briefing
	
	f, t, map = string.find(filedata, "[{%s\n]map[%s\n]*\"([^\"]*)\"")
	if not map then
		return {findmap = mapName}
	end
	f, t, longName = string.find(filedata, "[{%s\n]longname[%s\n]*\"([^\"]*)\"")
	if not longName then
		longName = ""
	end
	f, t, briefing = string.find(filedata, "[{%s\n]briefing[%s\n]*\"([^\"]*)\"")
	if not briefing then
		briefing = ""
	end
	
	return {map = map, longname = longName, briefing = briefing, pak = pakInfo}
end

function PakInfoForFile(fileName)
	et.trap_Cvar_Set("returnvalue", "")
	et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("getpakpathwithfile %s", fileName))
	local path = et.trap_Cvar_Get("returnvalue")
	
	local pakBasename = ""
	for str in string.gfind(path, "[/\\]([^/\\]*)") do
		pakBasename = str
	end
	
	local pakFile = io.open(path)
	if not pakFile then
		return
	end
	
	local pakSize = pakFile:seek("end")
	io.close(pakFile)
	
	return {basename = pakBasename, size = pakSize}
end
