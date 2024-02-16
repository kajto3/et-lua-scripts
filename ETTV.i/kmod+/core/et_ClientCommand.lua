-- TODO: censor() - change b_censor cvar's to k_censor cvars, otherwise etpro (the mod) keeps censoring admins

function et_ClientCommand( clientNum, command )
	local name2 = et.gentity_get(clientNum,"pers.netname")
	local name2 = et.Q_CleanStr( name2 )
	local arg0 = string.lower(et.trap_Argv(0))
	local arg1 = string.lower(et.trap_Argv(1))
	local muted = et.gentity_get(clientNum, "sess.muted")


	-- player might of changed teams, update!
	if global_players_table[clientNum] ~= nil then
		global_players_table[clientNum]["team"] = tonumber(et.gentity_get(clientNum,"sess.sessionTeam"))
	end




	--saneClientCommand: 2 setspawnpt 2
	-- update the spawn counts without reseting the spawnshield (some1 manually changed the spawn point)
	if et.trap_Argv(0) ==  "setspawnpt" then
		--global_map_spawns[tonumber(et.trap_Argv(1))]
	end


	
	







	if muted == 0 then
		if arg0 == "say" then
			if k_logchat == 1 then
				log_chat( clientNum, et.SAY_ALL, et.ConcatArgs(1))
			end

			--et_ClientSay( clientNum, et.SAY_ALL, et.ConcatArgs(1))
		elseif arg0 == "say_team" then
			if k_logchat == 1 then
				log_chat( clientNum, et.SAY_TEAM, et.ConcatArgs(1))
			end

			--et_ClientSay( clientNum, et.SAY_TEAM, et.ConcatArgs(1))
		elseif arg0 == "st" then
			--speaker_test( clientNum, et.ConcatArgs(1))
			speaker_test( clientNum, et.ConcatArgs(1))
			return 1
		elseif arg0 == "say_buddy" then
			if k_logchat == 1 then
				log_chat( clientNum, et.SAY_BUDDY, et.ConcatArgs(1))
			end

			--et_ClientSay( clientNum, et.SAY_BUDDY, et.ConcatArgs(1))
		elseif arg0 == "say_teamnl" then
			if k_logchat == 1 then
				log_chat( clientNum, et.SAY_TEAMNL, et.ConcatArgs(1))
			end

			--et_ClientSay( clientNum, et.SAY_TEAMNL, et.ConcatArgs(1))


		elseif arg0 == "vsay" then
			if k_logchat == 1 then
				log_chat( clientNum, "VSAY_ALL", et.ConcatArgs(1))
			end
		elseif arg0 == "vsay_team" then
			if k_logchat == 1 then
				log_chat( clientNum, "VSAY_TEAM", et.ConcatArgs(1))
			end
		elseif arg0 == "vsay_buddy" then
			if k_logchat == 1 then
				log_chat( clientNum, "VSAY_BUDDY", et.ConcatArgs(1))
			end
		end
	end
	-- out of the "if not muted"
--[[
	-- silent commands , By Necromancer
	local s,e,admincommand = string.find(arg0, k_commandprefix .. "(%w+)")
	if (admincommand ~= nil) then
		-- dont let players spam commands!
		-- players with silent-command ability can spam commands with
		-- /say hello;!command;!command;!command;!command;!command;!command;!command
		if (os.time() - global_players_table[clientNum]["lastcommand"] > 0) then
			global_players_table[clientNum]["lastcommand"] = os.time()
			local params = {}
			local i=1
			-- if et.trap_Argv(i) is empty, it returns "" (and not nil!)
			while string.lower(et.trap_Argv(i)) ~= "" do
				params[i] =  string.lower(et.trap_Argv(i))
				i=i+1
			end
			if (level_flag(AdminUserLevel(clientNum),"3") ) then -- does the player has permission to use silent commands? (flags = 3)
				ClientUserCommand(clientNum, "SC", admincommand, params)
				return 1 -- command was intercepeted
			end
		end
	end
--]]


	if arg0 == "dmg_test" then
		dmg_test(clientNum)
		return 1
	end

	if arg0 == "m" or arg0 == "pm" or arg0 == "msg" then
		if k_logchat == 1 then
			log_chat( clientNum, "PMESSAGE", et.ConcatArgs(2), et.trap_Argv(1) )
		end
	end

	if k_advplayers == 1 then
		if string.lower(command) == "players" then
   			advPlayers(clientNum)
		return 1 
		end
		--[[ Micha! - not implemented 
		if AdminUserLevel(clientNum) >= 2 then
			if string.lower(command) == "admins" then
   				admins(clientNum)
			return 1
  			end
		end
		--]]
	end

	local ref = tonumber(et.gentity_get(clientNum,"sess.referee"))

	if tonumber(et.gentity_get(clientNum,"sess.sessionTeam")) == 3 then
		if et.trap_Argv(0) == "team" and et.trap_Argv(1) then
			switchteam[clientNum] = 1
		end
	end

	if votedis == 1 then
		local vote = et.trap_Argv(1)

		if AdminUserLevel(clientNum) < 3 then
			if et.trap_Argv(0) == "callvote" then
				if vote == "shuffleteamsxp" or vote == "shuffleteamsxp_norestart" or vote == "nextmap" or vote == "swapteams" or vote == "matchreset" or vote == "maprestart" or vote == "map" then
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay Voting has been disabled!\n")
				end
			end
		end

	end

	if arg0 == "ref" and arg1 == "pause" and pausedv == 0 then
		GAMEPAUSED = 1
		dummypause = mtime
	elseif arg0 == "ref" and arg1 == "unpause" and pausedv == 1 then
		if ((mtime - dummypause)/1000) >= 5 then
			GAMEPAUSED = 0
		end
	end
--[[
	if string.lower(command) == "m" or string.lower(command) == "msg" or string.lower(command) == "pm" then
		if et.trap_Argv(1) == "" or et.trap_Argv(1) == " " then 
			et.trap_SendServerCommand(clientNum, string.format("print \"Useage:  /m \[pname/ID\] \[message\]\n"))
		else
			private_message(clientNum, et.trap_Argv(1), et.ConcatArgs(2))
			return 1
		end
	end



	if string.lower(command) == "ma" or string.lower(command) == "pma" then
		if level_flag(AdminUserLevel(clientNum), "~") or tonumber(et.gentity_get(clientNum,"sess.referee")) ~= 0 then
			if k_logchat == 1 then
				log_chat( clientNum, "PMADMINS", et.ConcatArgs(1))
			end

			local sender_name = global_players_table[clientNum]["name"]
			for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do
				if global_players_table[i] ~= nil then
					if level_flag(AdminUserLevel(i), "~") or tonumber(et.gentity_get(i,"sess.referee")) ~= 0 then
						et.trap_SendServerCommand(i, string.format('%s \"%s"\n',"b 8","^w(^aAdminchat^w) " ..sender_name .. "^w: ^a" ..et.ConcatArgs(1) ))
					end
				end
			end
			return 1
		end
	end

	if string.lower(command) == "ignore" then -- ETpro doesnt expose the sess.ignoreClients field, we need to keep a record of our own.
		--et.G_Print("******************\n")
		ignore(clientNum, et.trap_Argv(1))

	end
	if string.lower(command) == "unignore" then
		unignore(clientNum, et.trap_Argv(1))
	end
--]]

	





	




	local intercept = selfKill(clientNum, command) -- check for self-kill
	local flag = 1

	-- intercept votes
	flag = voteCalled(clientNum) -- cancel vote etc...
	if flag ~= nil and flag ~= 0 and flag ~= false then intercept = 1 end

	-- launch client console commands (/follow,/ignore,/info)
	local params = {}
	local i=1
	while string.lower(et.trap_Argv(i)) ~= "" do
		params[i] =  string.lower(et.trap_Argv(i))
		i=i+1
	end
	params["slot"] = clientNum
	params["say"] = "print"
	flag = runClientConsoleCommand( string.lower(command), params)
	if flag ~= nil and flag ~= 0 and flag ~= false then intercept = 1 end

	-- intercept admin commands
	flag = getAdminCommand(clientNum)
	if flag ~= nil and flag ~= 0 and flag ~= false then intercept = 1 end
	

	-----------------
	-- censor text --
	-----------------
	if intercept ~= nil and intercept ~= false and intercept ~= 0 then return intercept end -- dont run censor if its normal console command (like private message)
	if muted == 0 then
		if isBadword(et.ConcatArgs(1)) then -- punish the player if found a curse
			curse_punish(clientNum)
		end
		if et.trap_Cvar_Get("k_cursefilteraction") ~= "" then
			if arg0 == "say" or arg0 == "say_team" --[[ or arg0 == "say_buddy"--]] then 
				if isBadword(et.ConcatArgs(1)) then
					flag = censor(clientNum)
				end
			end
		end
		if flag ~= nil and flag ~= 0 then intercept = 1 end

	end

	if tonumber(et.trap_Cvar_Get("k_test")) ~= nil then
		et.G_Print("KMOD test: " .. type(intercept) .. "\n")
	end


	-- intercept must be an integer (in particularly, must not be nil)
	-- or else the console will spam 
	-- etpro: et_ClientCommand - expected integer, got nil
	return intercept


	--intercept = censor(clientNum,mode,text) 
	



	--return 0
end



function getAdminCommand(clientNum)
	local mode = getClientSay(et.trap_Argv(0))
	if mode then
		local command, temp
		local params = {}
		params["chat"] = mode
		local s,e -- start and end index
		-- stupid etpro, if you write !command <parameter 1> in the console the commabd buffer has 2 parameters
		-- but if you write the same thing in the chat, it has only 1 parameter (etpro executes a et.ConcatArgs over it)
		s,e,command,temp = string.find(et.ConcatArgs(1), k_commandprefix)
		if ( s == 1) then -- we got a command!
			s,e,command,temp = string.find(et.ConcatArgs(1), k_commandprefix .. "(%w+)%s+(.*)")
			if (temp ~= nil) then
				params = ParseString(temp)
				params["chat"] = mode
				--userPrint(clientNum,et.SAY_ALL,et.ConcatArgs(1))
				return ClientUserCommand(clientNum, mode, string.lower(command), params)
			else
				s,e,command = string.find(et.ConcatArgs(1), k_commandprefix .. "([%S]*)") 
				command = command or "nil"
				--userPrint(clientNum,et.SAY_ALL,et.ConcatArgs(1))
				return ClientUserCommand(clientNum, mode, string.lower(command), params)
			end
		else -- just some text including k_commandprefix
			command = nil
			temp = nil
		end
		return 0
		--[[
		s,e,command = string.find(string.lower(et.trap_Argv(1)), k_commandprefix .. "(%S+)")
		if ( s == 1) then -- we got a command!


			if et.trap_Argv(2) ~= '' then
				local i=2
				--et.G_Print("check - " .. et.trap_Argv(2) .. "\n")
				-- if et.trap_Argv(i) is empty, it returns "" (and not nil!)
				while string.lower(et.trap_Argv(i)) ~= "" do
					params[i-1] =  string.lower(et.trap_Argv(i))
					i=i+1
				end
			end
			ClientUserCommand(clientNum, et.SAY_ALL, command, params)
			return 1
		end
		--]]
	else -- possibly a silent command

		-- silent commands , By Necromancer
		local s,e,command = string.find(string.lower(et.trap_Argv(0)), k_commandprefix .. "(%S+)")
		if (command ~= nil) then
			-- dont let players spam commands!
			-- players with silent-command ability can spam commands with
			-- /say hello;!command;!command;!command;!command;!command;!command;!command
			if (os.time() - global_players_table[clientNum]["lastcommand"] > 0) then
				global_players_table[clientNum]["lastcommand"] = os.time()
				local params = {}
				local i=1
				-- if et.trap_Argv(i) is empty, it returns "" (and not nil!)
				while string.lower(et.trap_Argv(i)) ~= "" do
					params[i] =  string.lower(et.trap_Argv(i))
					i=i+1
				end
				if (level_flag(AdminUserLevel(clientNum),"3") ) then -- does the player has permission to use silent commands? (flags = 3)
					--et.G_Print("heyloo2\n")
					return ClientUserCommand(clientNum, "SC", string.lower(command), params)
					 -- command was intercepeted
				end
			end
		end
	end
end



function voteCalled(clientNum)
	if et.trap_Argv(0) == "callvote" then
		
		local caller = tonumber(clientNum)
		local vote = et.trap_Argv(1)
		local start,stop
		-- check for suspicious votes; using string.format with option %q to interpret it safely (",',\n\r etc.. wont break the lua in interpreter)
		-- ill check it one by one, plain search, to be sure. all magic charactars are off.
		local str = et.ConcatArgs(1)
		start,stop = string.find(string.format('%s',str),'"',1,true)
		if start and stop then return 1 end -- intercept the vote, suspicious!
		start,stop = string.find(string.format('%q',str),';',1,true)
		if start and stop then return 1 end
		start,stop = string.find(string.format('%q',str),'\\',1,true)
		if start and stop then return 1 end
		start,stop = string.find(string.format('%q',str),'\n',1,true)
		if start and stop then return 1 end 
		start,stop = string.find(string.format('%q',str),'\r',1,true)
		if start and stop then return 1 end
		start,stop = string.find(string.format('%q',str),'\'',1,true)
		if start and stop then return 1 end
		

		if (vote == "kick" or vote == "mute" or vote == "unmute" ) then   -- match restart/reset etc.. doesnt have a player target.
			--et.G_Print("check - " .. et.ConcatArgs( 2 )  .. "\n")
			local target = NameToSlot(et.ConcatArgs(2) )
			if (table.getn(target) ~= 1) then
				--et.G_Print("num = " .. table.getn(target) .. "\n")
				return 0
			end

			
			if vote == "kick" then
				if (level_flag(AdminUserLevel(target[1]),"1") ~= nil ) then
					--et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay Admins cannot be vote kicked !\n")
					et.trap_SendServerCommand( caller , string.format('%s \"%s"\n',MOD["CHAT"],COMMAND_COLOR .. "vote^w: ".. COMMAND_COLOR .. "Admins cannot be vote kicked!"))
					return 1 -- intercept the vote
				end
			end

			
			if vote == "mute" then
				if (level_flag(AdminUserLevel(target[1]),"1") ~= nil ) then
					--et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay Admins cannot be vote muted!\n")
					et.trap_SendServerCommand( caller , string.format('%s \"%s"\n',MOD["CHAT"],COMMAND_COLOR .. "vote^w: ".. COMMAND_COLOR .. "Admins cannot be vote muted!"))
					return 1 -- intercept the vote
				end
			end

			if vote == "unmute" then
				
				local k_mute = tonumber(et.trap_Cvar_Get("k_mute"))
				local bit = bitflag(k_mute,32)
				if bit[8] then -- check if the admin is on the server
					if ismuteron(global_mute_table[global_players_table[target[1]]["guid"]]["muter_guid"]) ~= -1 then
						--et.G_Print("check3 - hello52\n")
						--et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay " .. global_players_table[target[1]]["name"] .."^w cannot be vote un-muted!\n")
						et.trap_SendServerCommand( caller , string.format('%s \"%s"\n',MOD["CHAT"],COMMAND_COLOR .. "vote^w: "..global_players_table[target[1]]["name"] .. COMMAND_COLOR .. " cannot be vote un-muted!"))
						return 1 -- intercept the vote
					end
				end
				if bit[32] then -- language censor muted players cannot be unmuted
					if global_mute_table[global_players_table[target[1]]["guid"]]["muter_guid"] == "CurseFilter" then
						--et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay " .. global_players_table[target[1]]["name"] .."^w cannot be vote un-muted! next time keep your mouth shut.\n")
						et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',MOD["CHAT"],COMMAND_COLOR .. "vote^w: "..global_players_table[target[1]]["name"] .. COMMAND_COLOR .. " cannot be vote un-muted! next time keep your mouth shut!"))
						return 1 -- intercept the vote
					end
				end
					
			end
		end

		if  (vote == "poll") then
			local k_censor_poll = tonumber(et.trap_Cvar_Get("k_censor_poll"))
			local bit = bitflag(k_censor_poll,2)
			if bit[1] then
				if isBadword( et.ConcatArgs(2) ) then
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote")
				end
			end
			if bit[2] then
				if isBadword( et.ConcatArgs(2) ) then
					curse_punish(caller)
				end
			end
		end


	end
end


function selfKill(clientNum, command)
	k_slashkills = tonumber(et.trap_Cvar_Get("k_slashkills"))
	if k_slashkills >=0 then
		local name = et.gentity_get(clientNum,"pers.netname")
		local teamnumber = tonumber(et.gentity_get(clientNum,"sess.sessionTeam"))
		if string.lower(command) == "kill" then
			if teamnumber ~= 3 then
				if et.gentity_get(clientNum,"health") > 0 then
					if selfkills[clientNum] < k_slashkills then
						selfkills[clientNum] = selfkills[clientNum] + 1
						if selfkills[clientNum] == k_slashkills then
							if k_advancedpms == 1 then
--								et.trap_SendConsoleCommand( et.EXEC_APPEND, "m2 " .. name .. " ^7You have reached your /kill limit!  You can no longer /kill for the rest of this map.\n" )
								et.trap_SendConsoleCommand( et.EXEC_APPEND, "m2 " .. clientNum .. " ^7You have reached your /kill limit!  You can no longer /kill for the rest of this map.\n" )
								et.G_ClientSound(clientNum, pmsound)
							else
								et.trap_SendConsoleCommand( et.EXEC_APPEND, "m " .. name .. " ^7You have reached your /kill limit!  You can no longer /kill for the rest of this map.\n" )
							end
						elseif selfkills[clientNum] == (k_slashkills - 1) then
							if k_advancedpms == 1 then
--								et.trap_SendConsoleCommand( et.EXEC_APPEND, "m2 " .. name .. " ^7You have ^11^7 /kill left for this map.\n" )
								et.trap_SendConsoleCommand( et.EXEC_APPEND, "m2 " .. clientNum .. " ^7You have ^11^7 /kill left for this map.\n" )
								et.G_ClientSound(clientNum, pmsound)
							else
								et.trap_SendConsoleCommand( et.EXEC_APPEND, "m " .. name .. " ^7You have ^11^7 /kill left for this map.\n" )
							end
						end
					else
						if k_advancedpms == 1 then
--							et.trap_SendConsoleCommand( et.EXEC_APPEND, "m2 " .. name .. " ^7You may no longer /kill for the rest of this map!\n" )
							et.trap_SendConsoleCommand( et.EXEC_APPEND, "m2 " .. clientNum .. " ^7You may no longer /kill for the rest of this map!\n" )
							et.G_ClientSound(clientNum, pmsound)
						else
							et.trap_SendConsoleCommand( et.EXEC_APPEND, "m " .. name .. " ^7You may no longer /kill for the rest of this map!\n" )
						end
						return 1
					end
				end
			end
		end
	end
	return 0
end


--[[
function et_ClientSay(clientNum,mode,text)
	local curses = et.trap_Cvar_Get("b_cursefilter") 
	local s -- lua returns the string index
	local e -- lua returns the string index
	local command
	local temp
	local params = {}

	-- s - mach start (will be the 1); e - mach end ( len), first - the first word of the string, second - the 2nd, thrid - the rest.
	s,e,command,temp = string.find(text, k_commandprefix)


	if ( s == 1) then -- we got a command!
		s,e,command,temp = string.find(text, k_commandprefix .. "(%w+)%s+(.*)")
		if (temp ~= nil) then
			params = ParseString(temp)
		else
			s,e,command = string.find(text, k_commandprefix .. "([%S]*)") 
			command = command or "nil"
		end
	else -- just some text including k_commandprefix
		command = nil
		temp = nil
	end
	


	

	-- bad word checking (the censor is done by the etpro mod)
	-- not space -> word (that m!ght contain 1337 charactars)
	local Bword
	local s,e
	for Bword in string.gfind(curses, "([%S]+)") do
	--et.G_Print("Bword = ".. Bword .." and it is ".. string.len(Bword) .." long\n" )
		
		s,e = string.find(text,Bword,1,1)
		if s and e then
			et.G_Print("got ya little prick! slot - " .. clientNum .. " \n")
			curse_filter( clientNum )
			break -- 1 bad word is enough to punish, etpro does the censoring of the word\s
		end
			
		
	end

	-- either public chat or silent command
	mode = mode or "et.SAY_ALL"
	if (mode == et.SAY_ALL or mode == "SC") then
		if ( command ~= nil ) then -- we have a command
			command = string.lower(command)
			
			return ClientUserCommand(clientNum, mode, command, params)
		end
	end
end
--]]





function ClientUserCommand(PlayerID, mode, command, params)
	local level -- the level
	local alias -- command alias
	local subs -- the "real command", the alias substatution
	-- Rany B
	local gotcommand = false


	params["slot"] = PlayerID

	params["say"] = MOD["CHAT"]

--[[
	local fd,len = et.trap_FS_FOpenFile( "kmod\commands.cfg", et.FS_READ )
	if len > 0 then
		local filestr = et.trap_FS_Read( fd, len )
		if ( tonumber(PlayerID) ~= nil ) then  -- possible if its an rcon command, in that case PlayerID == "console"
			for level,alias,subs in string.gfind(filestr, "[^%#](%d)%s*%-%s*([%w%_]*)%s*%=%s*([^%\n]*)") do
				local strnumber = {}
				local strnumber = ParseString(subs)
	
				local comm2 = alias
				local t = tonumber(et.gentity_get(PlayerID,"sess.sessionTeam"))
				local c = tonumber(et.gentity_get(PlayerID,"sess.latchPlayerType"))
				local player_last_victim_name = ""
				local player_last_killer_name = ""
				local player_last_victim_cname = ""
				local player_last_killer_cname = ""
				if playerlastkilled[PlayerID] == 1022 then
					player_last_victim_name = "NO ONE"
					player_last_victim_cname = "NO ONE"
				else
					player_last_victim_name = et.Q_CleanStr(et.gentity_get(playerlastkilled[PlayerID],"pers.netname"))
					player_last_victim_cname = et.gentity_get(playerlastkilled[PlayerID],"pers.netname")
				end
				if playerwhokilled[PlayerID] == 1022 then
					player_last_killer_name = "NO ONE"
					player_last_killer_cname = "NO ONE"
				else
					player_last_killer_name = et.Q_CleanStr(et.gentity_get(playerwhokilled[PlayerID],"pers.netname"))
					player_last_killer_cname = et.gentity_get(playerwhokilled[PlayerID],"pers.netname")
				end
				if (params[1] ~= nil) then
					local pnameID = part2id(params[1])
					if not pnameID then
						pnameID = 1021
					end
					local PBpnameID = pnameID + 1
					local PBID = PlayerID + 1
					str = string.gsub(str, "<PBPNAME2ID>", PBpnameID)
					str = string.gsub(str, "<PB_ID>", PBID)
					str = string.gsub(str, "<PNAME2ID>", pnameID)
	
				end
	
	
				local randomC = randomClientFinder()
				local randomTeam = team[tonumber(et.gentity_get(randomC,"sess.sessionTeam"))]
				local randomCName = et.gentity_get(randomC,"pers.netname")
				local randomName = et.Q_CleanStr(et.gentity_get(randomC,"pers.netname"))
				local randomClass = class[tonumber(et.gentity_get(randomC,"sess.latchPlayerType"))]
				local str = subs
				str = string.gsub(str, "<CLIENT_ID>", PlayerID)
				str = string.gsub(str, "<GUID>", et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "cl_guid" ))
				str = string.gsub(str, "<COLOR_PLAYER>", et.gentity_get(PlayerID,"pers.netname"))
				str = string.gsub(str, "<ADMINLEVEL>", AdminUserLevel(PlayerID))
				str = string.gsub(str, "<PLAYER>", et.Q_CleanStr(et.gentity_get(PlayerID,"pers.netname")))
				str = string.gsub(str, "<PLAYER_CLASS>", class[c])
				str = string.gsub(str, "<PLAYER_TEAM>", team[t])
				if (params[1] ~= nil and params[2] ~= nil) then
					str = string.gsub(str, "<PARAMETER>", params[1].. " " ..params[2])
				end
				--str = string.gsub(str, "<PARAMETER>", params[1]..params[2])
				str = string.gsub(str, "<PLAYER_LAST_KILLER_ID>", playerwhokilled[PlayerID])
				str = string.gsub(str, "<PLAYER_LAST_KILLER_NAME>", player_last_killer_name)
				str = string.gsub(str, "<PLAYER_LAST_KILLER_CNAME>", player_last_killer_cname)
				str = string.gsub(str, "<PLAYER_LAST_KILLER_WEAPON>", killedwithweapv[PlayerID])
				str = string.gsub(str, "<PLAYER_LAST_VICTIM_ID>", playerlastkilled[PlayerID])
				str = string.gsub(str, "<PLAYER_LAST_VICTIM_NAME>", player_last_victim_name)
				str = string.gsub(str, "<PLAYER_LAST_VICTIM_CNAME>", player_last_victim_cname)
				str = string.gsub(str, "<PLAYER_LAST_VICTIM_WEAPON>", killedwithweapk[PlayerID])
				str = string.gsub(str, "<RANDOM_ID>", randomC)
				str = string.gsub(str, "<RANDOM_CNAME>", randomCName)
				str = string.gsub(str, "<RANDOM_NAME>", randomName)
				str = string.gsub(str, "<RANDOM_CLASS>", randomClass)
				str = string.gsub(str, "<RANDOM_TEAM>", randomTeam)
				local teamnumber = tonumber(et.gentity_get(PlayerID,"sess.sessionTeam"))
				local classnumber = tonumber(et.gentity_get(PlayerID,"sess.latchPlayerType"))
	
				if (string.lower(command) == comm2 ) then
					if tonumber(level) <= AdminUserLevel(PlayerID) then
						et.trap_SendConsoleCommand( et.EXEC_APPEND, "".. str .. "\n" )
						gotcommand = true
						if strnumber[1] == "forcecvar" then
							et.trap_SendServerCommand( params["broadcast"], params["say"].." ^3etpro svcmd: ^7forcing client cvar ["..strnumber[2].."] to [".. params[1] .."]\n" )
						end						
					else
						et.trap_SendServerCommand( params["broadcast"], params["say"].." ^7Insufficient Admin status\n" )
					end
				end
			end
		end
	end	
	et.trap_FS_FCloseFile( fd )
--]]



	if (gotcommand == false) then
		if (PlayerID == CONSOLE) or tonumber(et.gentity_get(params["slot"],"sess.referee")) ~= 0 then -- if its console or ref
			return runcommand(command, params)


		else -- normal admin
			if ( levelcommand(AdminUserLevel(PlayerID),command) ) then -- check premission

				return runcommand(command, params)
				
			else
				-- remove the command to print "unknown command" every time a user uses a !<command_does_not_exist>
				--et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3" .. command .. "^w:^f unknown command " .. command)) 
			end
		end
	end
end





-- returns 1 if censored, or 0 otherwise
function censor(slot) -- we get the say params from the buffer 
	local word, curse
	local mode = et.trap_Argv(0)
	local s,e, mode = string.find(et.trap_Argv(0),"(%w+)")

	if mode == "say" then mode = et.SAY_ALL 
	elseif mode == "say_team" then mode = et.SAY_TEAM
	else mode = et.SAY_BUDDY end

	local ref = tonumber(et.gentity_get(slot,"sess.referee"))
	if ref == 1 then return 0 end -- cannot mute ref's

	local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "cl_guid" ))
	if global_admin_table[guid] ~= nil then
		if level_flag(global_admin_table[guid]["level"],"2") ~= nil then -- this level has the "2" flag - cannot be censored
			return 0
		end
	end



	-- silently filter the messages 
	if tonumber(et.trap_Cvar_Get("k_cursefilteraction")) == 1 then -- 1 = silently filter the messages (it will still appear to the player as though his/her message was sent)
		local flag = nil
		local i
		-- et.trap_Argv(0) = mode
		for curse in string.gfind(et.trap_Cvar_Get("b_cursefilter"), "%S+") do
			for i=1 , et.trap_Argc(), 1 do
				local capture
				for capture in string.gfind(et.Q_CleanStr(string.lower(et.trap_Argv(i))), string.lower(curse)) do
					userPrint(slot,mode, et.ConcatArgs(1), slot)
					return 1

				end
			end
		end
		if heavyCensor() then 
			userPrint(slot,mode, et.ConcatArgs(1), slot) 
			return 1	
		end

	-- censor *****
	elseif tonumber(et.trap_Cvar_Get("k_cursefilteraction")) == 2 then -- censor *****
		local flag = false
		local message = ""
		local word, new
		for i=1 , et.trap_Argc(), 1 do
			-- maybe we need to add et.Q_CleanStr() to remove colors if the mod doesnt do it.
			for w in string.gfind(et.trap_Argv(i), "%S+") do
				local mini_flag = false -- flag to see if the current word is a curse or not (we only want to add it to the message once)
				for curse in string.gfind(et.trap_Cvar_Get("b_cursefilter"), "%S+") do
					word = et.Q_CleanStr(string.lower(w))
					if not excluded_word(word) then
						new = string.gsub (word, string.lower(curse), string.rep("*", string.len(curse)))
						if word ~= new then
							message = message .. new .. " "
							flag = true
							mini_flag = true
							break
						end-- maybe add a " " 
					end
				end
				if mini_flag == false then
					message = message .. w .. " "
				end
			end
		end

		if flag == true then -- something was censored out
			userPrint(slot,mode, message, -1)
			return 1			
		end
		
		if heavyCensor() then
			message = et.Q_CleanStr(et.ConcatArgs(1))
			string.gsub(message, "%w", "*")
			userPrint(slot,mode, message, -1)
			return 1
		end

	-- ignore message
	else -- 3 = dont send the message at all
		local flag = nil
		for i=1 , et.trap_Argc(), 1 do
			for curse in string.gfind(et.trap_Cvar_Get("b_cursefilter"), "%S+") do
				flag = string.gfind(et.Q_CleanStr(string.lower(et.trap_Argv(i))), string.lower(curse))
				if flag ~= nil then -- Bad word found! 
					return 1
				end
			end
		end
		if heavyCensor() then return 1 end
		
	end
	-- wasnt censored
	return 0
end

-- returns 1 if found a curse, or nil otherwise
function heavyCensor()
	if tonumber(et.trap_Cvar_Get("k_HeavyCurseCheck")) ~= nil and tonumber(et.trap_Cvar_Get("k_heavycursecheck")) ~= 0 then
		local message = et.Q_CleanStr(et.ConcatArgs(1))
		local message2 = message
		local capture
		local flag = false

		local b_cursefilter = et.trap_Cvar_Get("b_cursefilter")

		-- first of all, if the text has an excluded word in it, the heavy censor cannot work
		local word
		for i=1 , et.trap_Argc(), 1 do
			word = et.Q_CleanStr(string.lower(et.ConcatArgs(i)))
			if excluded_word(word) then return end -- there's an excluded word here, abort

		end

			

		-- 1: convert all 0 to o, all 4's to a's, all ! to i, @ to a, and delete all panctuation charecters

		-- change all 0's to o's
		message2 = string.gsub(message2, "0", "o")
		-- change all 4's to a's
		message2 = string.gsub(message2, "4", "a")
		-- change all !'s to i's
		message2 = string.gsub(message2, "!", "i")
		-- change all @'s to a's
		message2 = string.gsub(message2, "@", "a")
		
		message2 = string.gsub(message2, "%(%)", "o")
		--et.G_Print("---> " .. message2 .. "\n")
		-- now delete all panctuation charecters
		message2 = string.gsub(message2, "%p", "")
		-- now check our message for curses
		for curse in string.gfind(b_cursefilter, "%S+") do
			if string.find(message2, string.lower(curse),1,1) then
				return 1
			end
		end	

		-- 3: convert all 0 to o, 4 to a, uniq all sequential characters
		message2 = message

		-- change all 0's to o's
		message2 = string.gsub(message2, "0", "o")
		-- change all 4's to a's
		message2 = string.gsub(message2, "4", "a")
		message2 = string.gsub(message2, "@", "a")
		message2 = string.gsub(message2, "%(%)", "o")
		message2 = string.gsub(message2, "!", "i")
		message2 = uniqstring(message2)
		for curse in string.gfind(b_cursefilter, "%S+") do
			if string.find(message2, string.lower(curse),1,1) then
				return 1
			end
		end	

		-- 4: convert all 0 to o,uniq all sequential characters, and delete all panctuation charecters

		message2 = string.gsub(message2, "%p", "")
		for curse in string.gfind(b_cursefilter, "%S+") do
			if string.find(message2, string.lower(curse),1,1) then
				return 1
			end
		end	

		return nil -- passed all checks and no curse found
	end
	return nil -- heavy censor disabled
end

-- returns 1 if the word is a word that contains a bad word, but should not be censored, like
-- ass in assassin
-- or nil otherwise
function excluded_word(word)
	local i
	local dictionary = {}
	dictionary[1] = "assassin"
	-- hebrew
	dictionary[2] = "gayus"
	dictionary[3] = "gayius"
	dictionary[4] = "gayes" -- mitgayes
	dictionary[5] = "gayas" -- hitgayasta / hitgayasti
	dictionary[6] = "sharat"
	dictionary[7] = "harasta"
	dictionary[8] = "harashta"
	dictionary[9] = "character"

	for i=1,table.getn(dictionary),1 do
		if string.find(word,dictionary[i])  then return 1 end
	end
	return nil
end


-- deletes every sequential character, for example "noob" -> "nob", nooooob -> nob, fuckkkk -> fuck
function uniqstring(text)
	local char1 = false
	local char2 = false
	local message = ""
	for chararcter in string.gfind(text, "(.)") do
		-- only heppens on the first 2 itirations
		if char1 == false then
			char1 = chararcter
		elseif char2 == false then
			char2 = char1
			char1 = chararcter
		end
		if char2 ~= false and char2 ~= char1 then
			message = message .. char2
		end
	end
	if char2 ~= char1 then -- add the last char in too
		message = message .. char1
	end
	return message
end




function curse_punish(slot)  --- this function only "punishes" the player for cursing

--[[
// 1  - mute           
// 2  - slap player    (like removes a small amount of hp from player *OVERRIDEABLE BY NEXT TWO OPTIONS)
// 4 - kill player    (kills player but is still reviveable *OVERRIDEABLE BY NEXT OPTION)
// 8 - GIB            (makes player explode into pieces )
--]]

--[[
	-- check if a badword exists:
	local word, curse
	local flag = false
	local capture = nil
	local flag = false
	for i=1 , et.trap_Argc(), 1 do
		for curse in string.gfind(et.trap_Cvar_Get("b_cursefilter"), "%S+") do
			for capture in string.gfind(et.Q_CleanStr(string.lower(et.trap_Argv(i))), string.lower(curse)) do
				flag = true
				break
			end
		end
		if flag == true then break end
	end	
	
	if flag == false then
		return -- no bad words were found
	end
--]]
	local k_cursemode = tonumber(et.trap_Cvar_Get("k_cursemode"))
	if k_cursemode == nil then return end -- dont do shit if wrong cvar
	local ref = tonumber(et.gentity_get(slot,"sess.referee"))
	if ref == 1 then return end -- cannot mute ref's
	local flags = bitflag(k_cursemode, 32)

	local name = et.gentity_get(slot,"pers.netname")
	local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "cl_guid" ))

	if global_admin_table[guid] ~= nil then
		if level_flag(global_admin_table[guid]["level"],"2") ~= nil then -- this level has the "2" flag - cannot be censored
			return
		end
	end


	if flags[1] then
		
		local expires = 0
		local muter = "CurseFilter" -- "console"
		local mute_time = tonumber(et.trap_Cvar_Get("g_censorMuteTime"))
		if mute_time == nil then 
			mute_time = 60
		end
		expires = os.time() + mute_time
		
		fd, len = et.trap_FS_FOpenFile( 'kmod+/misc/mute.dat', et.FS_APPEND ) 
		local mute = "\n"
		mute = mute .. "[mute]" .. "\n"
		mute = mute .. "name	= " .. name .. "\n"
		mute = mute .. "guid	= " .. guid .. "\n"
		mute = mute .. "expires	= " .. expires .. "\n"
		mute = mute .. "muter	= " .. muter .. "\n"
		if ( len > -1 ) then
			et.trap_FS_Write( mute, string.len(mute) ,fd )
		end
		et.trap_FS_FCloseFile( fd )
		load_mutes()
		--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute " .. slot .. "\n" )
		et.gentity_set(slot, "sess.muted", MOD["MUTE"])
		local say = MOD["CHAT"]
		et.G_Print("^3CurseFilter^w: ^1" ..name.. " ^fhas been muted for " ..mute_time .." seconds!\n" )
		et.trap_SendServerCommand( -1 , string.format("%s \"%s\"",say,"^3CurseFilter^w: ^1" ..name.. " ^fhas been muted for " ..mute_time .." seconds!"))
	end

	if flags[8] then
		et.gentity_set(slot, "health", -600)
	elseif flags[4] then
		et.gentity_set(slot, "health", -1)
	elseif flags[2] then
		if et.gentity_get(slot,"health") >0 then -- dont revive a dead player
			if et.gentity_get(slot,"health") <= 5 then
				et.gentity_set(slot,"health",1) -- dont kill the player
			else
				et.gentity_set(slot,"health",(et.gentity_get(slot,"health")-5))
			end
			local	slapsound = "sound/player/hurt_barbwire.wav"
			local soundindex = et.G_SoundIndex(slapsound)
			et.G_Sound( slot,  soundindex)		
		end	
	end

end









-- the function runs a command file, and passes params{} as an argument
function runClientConsoleCommand (command , params)
	-- assert raises an error... im not sure we want it to raise error if the command/file does not exist
	command = command or "nil"
	--local filename = "C:\\Game_Servers\\Users\\et1\\etpro\\commands\\" .. command .. ".lua"


	--et.G_Print("command1: " ..command .."\n" )

	local filename = et.trap_Cvar_Get("fs_homepath")
	filename = filename .. '/' ..et.trap_Cvar_Get("gamename") ..  '/kmod+/console/' .. command .. ".lua"

	--et.G_Print("command2: " ..filename .."\n" )

	-- the last dolua was defind globaly, thus wasnt distroyed when we exited the function
	-- distroy it before we continue
	dolua = nil


	-- use this to debug your commands. assert prints the error. (remove assert to not-display script errors)
	local code = pcall(loadfile(filename)) -- f = true/false (if filename was loaded and executed normally -> true)
	if code == true then -- file exists!
		code = assert(loadfile(filename)) 
		if (type(code) == "function") then
			pcall(code) -- define the dolua function
			if (type(dolua) == "function") then 

				-- its all good...
				--return dolua(params) -- run the code
				
			else -- the dolua function is not defind in that command/script


				local fd = io.open( filename, "r")
				local filestr =  fd:read("*a")
				fd:close()

				-- for some reason this code doesnt work in some cases... etpro says "cannot malloc -1 bytes" - forward to the etpro team?
				--local fd,len = et.trap_FS_FOpenFile( 'kmod/commands/' .. command .. ".lua", et.FS_READ )
				--if (len > 0) then
				--et.G_Print(command .. "\n")
				--local filestr = et.trap_FS_Read( fd, len ) 
				assert(loadstring('function dolua(params) ' .. filestr .. "\nend","code"))() -- wrap the file in the dolua(params) function, and run the chunk (define the function)

			end
		else 
			if (params.slot == "console") then
				et.G_LogPrint("K_ERROR - command:  Unable to load " ..command )
				return
			else
        			et.trap_SendServerCommand( params.slot, params.say.." \"^fUnable to load  ^g" ..command.. "^7\"" )
				et.G_LogPrint("K_ERROR - command:  Unable to load " ..command )
				return
			end
		end
		

		if (type(dolua) == "function") then 
			return dolua(params) -- run the code
		else
        		et.trap_SendServerCommand( params.slot, params.say.." \"^fImpossible to execute  ^g" ..command.. "^7\"" )
		end



	else  -- the file does not exist (or any other error loading the file)
		-- file might be without the "function dolua(params)" 
		local fd = io.open( filename, "r")
		if fd == nil then return end -- file does not exist
		local filestr =  fd:read("*a")
		fd:close()
		assert(loadstring('function dolua(params) ' .. filestr .. ' end',"code"))()
		--[[
		if (type(f) == "function") then
			et.G_Print("hello2\n")
			pcall(f) -- define the dolua function
			if (type(dolua) == "function") then
				return dolua(params)
			end
		end
		--]]
		if (type(dolua) == "function") then
			return dolua(params)
		end
	end
end