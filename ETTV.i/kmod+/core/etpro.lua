--[[
-------------------------------------
---------- ETpro functions ----------
-------------------------------------


-- for more info look at the ETpro Lua API 
-- http://wolfwiki.anime.net/index.php/ETPro:Lua_Mod_API
-- note: there are some non-etpro functuions in here too

et_InitGame( levelTime, randomSeed, restart )
et_ClientSpawn(clientNum,revived)
et_ShutdownGame ( restart )
et_ClientDisconnect( clientNum)
et_ConsoleCommand() 
et_ClientBegin( clientNum )
ClientUserCommand(PlayerID, mode, command, params)
et_Obituary( victim, killer, meansOfDeath )
et.G_ClientSound(clientnum, soundfile)
runcommand (command , params)
et_ClientUserinfoChanged( clientNum )
et_Quit() 
et_Print( text )
et_ClientConnect( clientNum, firstTime, isBot )
et_ClientCommand( clientNum, command ) --> moved to its own file
et_ClientSay(clientNum,mode,text) -> removed

KILL = "kill"

--]]





function et_RunFrame( levelTime )


	local server_time = tonumber(levelTime) -- any server time_cvar value should be compared with this (player inactivity time, etc...) server doesnt use the corrent os.time()
	mtime=tonumber(levelTime) -- still cannot remember why i made this but its used in alot of stuff so i'll leave it


	if timedvs == 0 then
		local ktime = (((mtime - initTime)/1000))
		timecounter = ktime
		timedvs = 1
	end

	timelimit=tonumber(et.trap_Cvar_Get("timelimit"))

	-- the clientBegin function has a problem forcing a player name (seems like the client sends userinfo strings after the function is called)
	-- so we need to force the name *after* the player joined
	
	for player=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		if global_players_table[player] then
			if global_players_table[player]['forced_name_flag'] then
				checkForced(player)
				global_players_table[player]['forced_name_flag'] = nil
			end
		end
	end
	
	Gamestate=tonumber(et.trap_Cvar_Get("gamestate"))
	if Gamestate == WARMUP then -- Warmup!
		if global_game_table["fight"] ~= 0 then
			global_game_table["fight"] = 0
		end
	end

	if Gamestate == PLAYING then -- playing
		if global_game_table["fight"] == 0 then
			global_game_table["fight"] = 1
			if et.trap_Cvar_Get("k_fight") ~= "" and et.trap_Cvar_Get("k_fight") ~= " " then
				et.G_globalSound( et.trap_Cvar_Get("k_fight") )
			end
			
		end
	end
		

	if Gamestate == INTERMISSION then -- intermission
		disablewars()
		if global_game_table["last_blood"] ~= nil then
			local str = string.gsub(k_lb_message, "#killer#", global_game_table["last_blood"])
			et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..MOD["CHAT"].." "..str.."\n" )
			global_game_table["last_blood"] = nil
		end
		-- end killing spree's
		if tonumber(et.trap_Cvar_Get("k_endkills")) ~= nil and tonumber(et.trap_Cvar_Get("k_endkills")) > 0 then
			for player=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
				if global_players_table[player] then
					if global_players_table[player][KILL]["spree"] > 0 then
						if getSpreeEnd(global_players_table[player][KILL]["spree"]) > 0 then
							et.G_Print("test: " ..global_players_table[player][KILL]["spree"] .. " \n") 
							et.trap_SendConsoleCommand( et.EXEC_APPEND, string.format('%s \"%s"',"qsay", global_players_table[player]["name"] .. "^a's killing spree ended due to map end ^w(^1" ..global_players_table[player][KILL]["spree"] .. " ^akills^w)" ))
							global_players_table[player][KILL]["spree"] = 0
						end
					end
				end
			end
		end
	end


	if GAMEPAUSED == 1 then
		if pausedv == 0 then
			pausetime = mtime
			pausedv = 1
		end

		if ((mtime - pausetime)/1000) >= 180 then    -- Server is paused for 3 minutes (180 seconds)
			GAMEPAUSED = 0
		end
	elseif GAMEPAUSED == 0 and pausedv == 1 then
		if pausedv2 == 0 then
			pausetime = mtime
			pausedv2 = 1
		end
		if ((mtime - pausetime)/1000) >= 10 then     -- when unpaused before 3 minutes is up it counts down from 10 seconds
			pausedv = 0
			pausedv2 = 0
			timedv1 = nil
			timedv2 = nil
		end
	else
		if timedv == 0 then
			timedv1 = mtime
			timedv = 1
			if type(timedv2) ~= "nil" then
				timecounter=timecounter+((timedv1 - timedv2)/1000)
				s,e,thous = string.find(timecounter, "%d*%.%d%d(%d*)")
--				s,e = string.find(thous, "9")
				if thous == 9999999 then
					timecounter=timecounter+0.000000001
				end
			end
		else
			timedv2 = mtime
			timedv = 0
			timecounter=timecounter+((timedv2 - timedv1)/1000)
			s,e,thous = string.find(timecounter, "%d*%.%d%d(%d*)")
--			s,e = string.find(thous, "9")
			if thous == 9999999 then
				timecounter=timecounter+0.000000001
			end
		end

--		timecounter=timecounter+0.05
	end





	-- player inactivity
	if tonumber(et.trap_Cvar_Get("g_inactivity")) then
		if tonumber(et.trap_Cvar_Get("g_inactivity")) > 0 then
			if tonumber(et.trap_Cvar_Get("k_playerInactivity")) then
				if (  tonumber(et.trap_Cvar_Get("k_playerInactivity")) > 0  ) then
					for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
						if global_players_table[i] ~= nil then
							if global_players_table[i]["begin"] == 1 then
								if global_players_table[i]["team"] ~= SPECTATOR and global_players_table[i]["team"] ~= CONNECTING then
	


										if not POP then POP = 0 end
											POP = POP + 1
											if POP == 10 then
											POP = 0      
											et.G_Print( levelTime .. " - " .. et.gentity_get(i,"client.inactivityTime").. " - " .. et.trap_Cvar_Get("g_Inactivity") .. "\n")
										end

									--et.G_Print("hello\n")
									--local inactivity = tonumber(et.gentity_get(i,"client.inactivityTime"))
									local inactivity = math.ceil(mtime/1000) - (math.ceil(tonumber(et.gentity_get(i,"client.inactivityTime"))/1000) - tonumber(et.trap_Cvar_Get("g_Inactivity")))
									--et.G_Print(math.abs( math.ceil(mtime/1000) .. " - " .. math.ceil(tonumber(et.gentity_get(i,"client.inactivityTime"))/1000) .. " - " .. tonumber(et.trap_Cvar_Get("g_Inactivity")) .."\n"))
									
									if inactivity > tonumber(et.trap_Cvar_Get("k_playerInactivity")) then
										et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref remove ".. i)
										et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',MOD["CHAT"],global_players_table[i]["name"] .. " ^fhas been moved to spectators due to inactivity" ))
										global_players_table[i]["team"] = et.gentity_get(i,"sess.sessionTeam")


									end

								end
							end
						end
					end
				end
			end

		end
	end

--[[
http://etpub.org/viewtopic.php?f=8&t=71

1644 - 1704 - 259200
 
1696 - 260895 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1696 - 1756 - 259200
1696 - 1756 - 259200
1696 - 1756 - 259200
1696 - 1756 - 259200
1696 - 1756 - 259200
1696 - 1756 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1696 - 260896 - 259200
1697 - 260896 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200
1697 - 260897 - 259200 -- player stopped
1697 - 1757 - 259200
1697 - 1757 - 259200
1697 - 1757 - 259200
1698 - 1757 - 259200
1698 - 1758 - 259200
1698 - 1758 - 259200
1698 - 1758 - 259200
--]]



-- spectator inactivity
	if tonumber(et.trap_Cvar_Get("g_spectatorInactivity")) then
		if tonumber(et.trap_Cvar_Get("g_spectatorInactivity")) > 0 then -- g_inactivity is required or this will not work (if g_inactivity == 0, then the player's inactivity time is updated to the servers time every frame, even if the player is afk)
			if tonumber(et.trap_Cvar_Get("k_spectatorInactivity")) then
				if (  tonumber(et.trap_Cvar_Get("k_spectatorInactivity")) > 0  ) then
					
					local online = 0
					for i=tonumber(et.trap_Cvar_Get("sv_privateclients")), tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do -- lets count how many players there are in the public slots
						if global_players_table[i] ~= nil then
							online = online +1
						end
					end

					if ( online >= tonumber(et.trap_Cvar_Get("sv_maxclients")) -  tonumber(et.trap_Cvar_Get("sv_privateclients")) ) then -- server is full
						for i=tonumber(et.trap_Cvar_Get("sv_privateclients")), tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
							if global_players_table[i] ~= nil then
								if ( not level_flag(AdminUserLevel(i), "0") ) then
									if global_players_table[i]["team"] == SPECTATOR then
										local inactivity = math.ceil(mtime/1000) - (math.ceil(tonumber(et.gentity_get(i,"client.inactivityTime"))/1000) - tonumber(et.trap_Cvar_Get("g_Inactivity")))
										--et.G_Print(inactivity .. " - " .. global_players_table[i]["team"] .. "\n")
										if global_players_table[i]["inactivity_warning"] == nil then
											--et.G_LogPrint("inactivity error: client " .. i .. " nil warning!" .. "\n")
											break
										else
											if inactivity > tonumber(et.trap_Cvar_Get("k_spectatorInactivity")) then
												--et.G_Print(inactivity .. "\n")
												if global_players_table[i]["inactivity_warning"] ~= 1 then
													if global_players_table[i]["begin"] ~= nil then -- only if the client got in!
														et.trap_SendServerCommand(i, string.format('%s \"%s"\n',"cp","^3" .. 120 .. " seconds until inactivity drop!"))
														et.G_LogPrint("inactivity warning issued to client " .. i .. " - " .. global_players_table[i]["name"] .. "\n")
														global_players_table[i]["inactivity_warning"] = 1
													end
												else
													if inactivity > tonumber(et.trap_Cvar_Get("k_spectatorInactivity")) + 120 then
														if global_players_table[i]["begin"] == 1 then -- only if the client got in!
															et.trap_DropClient( i, "dropped due to inactivity", 0 )
															et.G_LogPrint("inactivity Drop - slot: " .. i .. " player: " .. global_players_table[i]["name"] .. " team: " .. global_players_table[i]["team"] .. " inactivity: " ..inactivity.. " warning: " .. global_players_table[i]["inactivity_warning"] .. "\n")
															global_players_table[i] = nil
														end
													end
												end											
											else
												if global_players_table[i]["inactivity_warning"] == 1 then
													et.G_LogPrint("inactivity warning removed from client " .. i .. " - " .. global_players_table[i]["name"] .. "\n")
													global_players_table[i]["inactivity_warning"] = 0
												end
											end
										end
									end
								end
							end
						end
					else -- server isnt full, let em spec (set their inactivity time-stamp to current time)
						for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
							if global_players_table[i] ~= nil then
								if global_players_table[i]["team"] == 3 then
									et.gentity_set(i,"client.inactivityTime",mtime + tonumber(et.trap_Cvar_Get("g_Inactivity"))*1000 ) -- im too lazy now
								end
							end
						end
					end
						
				end
			end
		end
	end
	


-------------------------------------
------------ !war -------------------
-------------------------------------
-- !panzerwar (for example)

if global_weapons_table ~= nil then
	

	local k,i,j
	
	for k=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		 
		 if global_players_table[k] ~= nil then
			--et.G_Print("runing on client - ".. k .. "\n")
			if os.time() - global_old_time_var > 1 then -- update the ammo clip
				for i=1,(et.MAX_WEAPONS-1),1 do
					--et.G_Print("client -".. k .. "ammo check " .. "\n")
					if global_weapons_table["weapons"][i] ~= nil then
						if global_weapons_table["weapons"][i][1] ~= nil then
							--et.G_Print("client - ".. k .. "forcing ammo1" .. "\n")
							et.gentity_set(k,"ps.ammoclip",i,global_weapons_table["weapons"][i][1])
						end
						if global_weapons_table["weapons"][i][2] ~= nil then
							et.G_Print("client - ".. k .. "forcing ammo2" .. "\n")
							et.gentity_set(k,"ps.ammo",i,global_weapons_table["weapons"][i][2])
						end
					end
				end
				
			end

			-- dont let him choose any other class
			if global_players_table[k]["team"] == AXIS then -- axis
				if global_weapons_table["class_axis"] ~= nil then
					if tonumber(et.gentity_get(k,"sess.latchPlayerType")) ~= global_weapons_table["class_axis"] then
						et.gentity_set(k,"sess.latchPlayerType",global_weapons_table["class_axis"])
					end
				end
			elseif global_players_table[k]["team"] == ALLIES then
				if global_weapons_table["class_allies"] ~= nil then
					if tonumber(et.gentity_get(k,"sess.latchPlayerType")) ~= global_weapons_table["class_allies"] then
						et.gentity_set(k,"sess.latchPlayerType",global_weapons_table["class_allies"])
						
					end
				end
			end

			
--[[
			if global_weapons_table["available"] ~= nil then
				local current_weapon = tonumber(et.gentity_get(k,"sess.latchPlayerWeapon"))
				local flag = true
				for j=0,table.getn(global_weapons_table["available"]),1 do
					if current_weapon == global_weapons_table["available"][j] then
						flag = false
						break
					end
				end
				if flag then -- this player holds an un-autorized weapon!
					if global_players_table[k]["team"] == 1 then -- axis
						et.gentity_set(k,"sess.latchPlayerWeapon",global_weapons_table["axis"])
					elseif global_players_table[k]["team"] == 2 then
						et.gentity_set(k,"sess.latchPlayerWeapon",global_weapons_table["allies"])
					end
				end
			end
--]]


		end
		
			


	end

	if os.time() - global_old_time_var > 1 then
		global_old_time_var = os.time()
	end
end





	

	if k_endroundshuffle == 1 then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref shuffleteamsxp_norestart\n" )
		k_endroundshuffle = 0
	end


	if k_advancedadrenaline == 1 then
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		local adrentlimit = 10
		local adrensound = "sound/misc/regen.wav"
		if pausedv == 1 then
			adrendummy[i] = 1
		end

		if adrendummy[i] == 1 and tonumber(et.gentity_get(i,"ps.powerups", 12)) == 0 then
			adrendummy[i] = 0
		end
	
		if adrendummy[i] == 0 then
			if tonumber(et.gentity_get(i,"ps.powerups", 12)) > 0 then
	
				adrnum[i] = tonumber(et.gentity_get(i,"ps.powerups", 12))
				soundindex = et.G_SoundIndex(adrensound)
				local name = et.gentity_get(i,"pers.netname")
				if antiloopadr1[i] == 0 then
					adrtime[i] = mtime
					if k_adrensound == 1 then
						et.G_Sound( i,  soundindex)
					end
					antiloopadr1[i] = 1
				end
				if antiloopadr2[i] == 0 then
					adrtime2[i] = mtime
					adrnum2[i] = tonumber(et.gentity_get(i,"ps.powerups", 12))
					antiloopadr2[i] = 1
				end
				adrenaline[i] = 1
				local tottime = math.floor((((mtime - adrtime[i])/1000)+0.05))
				local tottime2 = math.floor((((mtime - adrtime2[i])/1000)+0.05))

				if tottime >= 1 then
					antiloopadr1[i] = 0
				end
				if adrnum[i] ~= adrnum2[i] then
					adrnum2[i] = tonumber(et.gentity_get(i,"ps.powerups", 12))
					if k_adrensound == 1 then
						et.G_Sound( i,  soundindex)
					end
					adrtime[i] = mtime
					adrtime2[i] = mtime
				end
				local atime = (adrentlimit - tottime2)

				et.trap_SendServerCommand(i, string.format("cp \"^3Adrenaline ^1".. atime .."\n\""))
			else
				adrenaline[i] = 0
				antiloopadr1[i] = 0
				antiloopadr2[i] = 0
				adrnum[i] = 0
				adrnum2[i] = 0
			end
		end
	end
	end

--[[
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do


		local mute = et.gentity_get(i, "sess.muted")
		if (muted[i] ~= nil) then
			if muted[i] > 0 then
				if mtime > muted[i] then
					if mute == 1 then
						local name = et.gentity_get(i,"pers.netname")
						et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref unmute \""..i.."\"\n" )
						et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3CurseFilter: ^7"..name.." ^7has been auto unmuted.  Please watch your language!\n" )
					end
					muted[i] = 0
				elseif mtime < muted[i] then
					if mute == 0 then
						muted[i] = 0
						setMute(i, 0)
					end
				elseif mute == 0 then
					muted[i] = 0
				end
			elseif muted[i] == -1 then
				if mute == 0 then
					muted[i] = 0
				end
			end
		end
	end
--]]

	if k_disablevotes == 1 then
		local timelimit = tonumber(et.trap_Cvar_Get("timelimit"))
		if k_dvmode == 1 then
			local cancel_time = ( timelimit - k_dvtime )
			if timecounter >= (cancel_time * 60) then
				if votedis == 0 then
					votedis = 1
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay XP-Shuffle / Map Restart / Swap Teams  / Match Reset and New Campaign votings are now DISABLED\n")
				end
			else
				if votedis == 1 then
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay XP-Shuffle / Map Restart / Swap Teams  / Match Reset and New Campaign votings have been reenabled due to timelimit change\n")
				end
				votedis = 0
			end
		elseif k_dvmode == 3 then
			if timecounter >= (k_dvtime * 60) then
				if votedis == 0 then
					votedis = 1
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay XP-Shuffle / Map Restart / Swap Teams  / Match Reset and New Campaign votings are now DISABLED\n")
				end
			else
				if votedis == 1 then
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay XP-Shuffle / Map Restart / Swap Teams  / Match Reset and New Campaign votings have been reenabled due to timelimit change\n")
				end
				votedis = 0
			end
		else
			local cancel_percent = ( timelimit * ( k_dvtime / 100 ) )
			if timecounter >= (cancel_percent * 60) then
				if votedis == 0 then
					votedis = 1
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay XP-Shuffle / Map Restart / Swap Teams  / Match Reset and New Campaign votings are now DISABLED\n")
				end
			else
				if votedis == 1 then
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay XP-Shuffle / Map Restart / Swap Teams  / Match Reset and New Campaign votings have been reenabled due to timelimit change\n")
				end
				votedis = 0
			end
		end
	end



---------------------------------------------------------------
----------- time based stuff ----------------------------------
---------------------------------------------------------------

	time_based()



end








function et_Print( text ) -- use hard checks, do not allow player manipulation
	local t = ParseString(text)

	if t[1] == "Vote" and t[2] == "Passed:" and t[3] == "MUTE" then
		local target = NameToSlot(table.concat(t,"",4)) -- should use table.concat if the player has spaces in the name...
		if (table.getn(target) ~= 1) then
			--et.G_Print("num = " .. table.getn(target) .. "\n")
			return
		end
		--et.G_Print("check - "..  target[1] .. "\n")
		mute(target[1])
	end

	--et.G_Print(" hello\n\n\n")
	if t[1] == "Vote" and t[2] == "Passed:" and t[3] == "UN-MUTE" then
		local target = NameToSlot(table.concat(t,"",4)) -- should use table.concat if the player has spaces in the name...
		if (table.getn(target) ~= 1) then
			--et.G_Print("num = " .. table.getn(target) .. "\n")
			return
		end
		unmute(global_players_table[target[1]]["guid"])
	end

	if t[1] == "Medic_Revive:" then
		local reviver = tonumber(t[2])
		teamkillr[reviver] = teamkillr[reviver] + 1
		if teamkillr[reviver] > k_tklimit_high then
			teamkillr[reviver] = k_tklimit_high
		end
	end
end






function et_ShutdownGame ( restart )


	disablewars()



	local k_mute = tonumber(et.trap_Cvar_Get("k_mute"))
	local bit = bitflag(k_mute,32)
	if bit[2] then -- unmute all players at map end
		for guid,v in pairs(global_mute_table) do
			
			unmute(guid)
		end
	end



	if k_logchat == 1 then
		log_chat( "DV", "START", "DV" )
	end


	-- player track facility -> save all player data
	local player_tracker = tonumber(et.trap_Cvar_Get("k_player_tracker"))
	if player_tracker ~= nil then
		if player_tracker ~= 0 then
			for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
				if global_players_table[i] ~= nil then
					if global_players_table[i]["guid"] ~= "UNKNOWN" then 
						write_player_info_table(global_players_table[i]["guid"])
					end
				end
			end
		end
	end

	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		if global_players_table[i] ~= nil then
			if global_players_table[i]["guid"] ~= "UNKNOWN" then 
				-- warnings
				if global_players_table[i]["warnings"] then
					WriteTableToFile('kmod+/misc/warnings/'..global_players_table[i]["guid"]..'.dat',global_players_table[i]["warnings"])
				end
			end
		end
	end

	if restart == 0 then
		local rotation = et.trap_Cvar_Get("k_rotation")
		if rotation ~= "" and rotation ~= " " then
			rotation = explode(";",rotation)
			if table.getn(rotation) <= 0 then 
				et.G_Print( "KMOD+ Rotation Error: no rotation defined!\n" )
			else
				et.trap_Cvar_Set("k_endroundPlayers", countAllies() + countAxis())
				index = tonumber(et.trap_Cvar_Get("k_current_map"))
				if not index then
					et.G_Print( "KMOD+ Rotation Error: map index is not set!\n" )
					et.trap_Cvar_Set("k_current_map","0")
					eet.trap_Cvar_Set("k_playedRotation",et.trap_Cvar_Get("mapname")) -- the rotation was reset
				else
					if index + 1 > table.getn(rotation) or rotation[index+1] == "" then
						et.trap_Cvar_Set("k_current_map","1") -- restart rotation
					else
						et.trap_Cvar_Set("k_current_map",index + 1) -- next map in rotation
					end
				end
			end
		end
	end	
	

end







function et_ClientSpawn(clientNum,revived)
	--et.gentity_set(clientNum,"ps.powerups", 1, 0 )
	if global_players_table[clientNum] ~= nil then 
		global_players_table[clientNum]["team"] = et.gentity_get(clientNum,"sess.sessionTeam")
	else
		global_players_table[clientNum] = {}
		global_players_table[clientNum]["team"] = CONNECTING -- the client is still connecting!!!
	end

	----------------------------------------------------------------------------
		-- check weapon restrictions		By Necromancer
	----------------------------------------------------------------------------
	TEAM_SPECTATOR = 3
	if tonumber(et.gentity_get(clientNum,"sess.sessionTeam")) ~= TEAM_SPECTATOR and k_countspecs == 0 then
	heavyWeaponRestriction(PANZERFAUST)
	heavyWeaponRestriction(FLAMETHROWER)
	heavyWeaponRestriction(MOBILE_MG42)
	heavyWeaponRestriction(MORTAR)
	heavyWeaponRestriction(LANDMINE)
	heavyWeaponRestriction(GRENADE_LAUNCHER)
	elseif k_countspecs == 1 then
	heavyWeaponRestriction(PANZERFAUST)
	heavyWeaponRestriction(FLAMETHROWER)
	heavyWeaponRestriction(MOBILE_MG42)
	heavyWeaponRestriction(MORTAR)
	heavyWeaponRestriction(LANDMINE)
	heavyWeaponRestriction(GRENADE_LAUNCHER)
	end

end






function et_InitGame( levelTime, randomSeed, restart )
	initTime = levelTime
	--local currentver = et.trap_Cvar_Get("mod_version")
	-- please dont change the mod name, it will influance the statistic websites 
	--et.trap_SendConsoleCommand(et.EXEC_APPEND, "forcecvar mod_version \"" .. currentver .. " - KMOD" .. KMODversion2 .. "\"" .. "\n" )
	--et.RegisterModname("KMOD+ v" .. et.trap_Cvar_Get("kmod_version"))
	et.RegisterModname("KMOD+")
	if restart == 0 then -- its a new map, reset the admin set map
		et.trap_Cvar_Set("k_adminmap","false")
	end

	et.trap_Cvar_Set("k_levelTime",levelTime)






	
	initTime = levelTime
	
	load_players()
	loadlevels()
	loadAdmins()
	load_mutes()
	
	

	loadbanners()
	

	loadbans()
	load_banmask()

	loadspreerecord()
	loadmapspreerecord()
--	loadcommands()
	load_ignores()
	global_config_table = {}

	
	global_spree_table = loadBlocksFromFile('kmod+/spree.cfg',"spree")
	global_multikill_table = loadBlocksFromFile('kmod+/spree.cfg',"kill")
	global_spree_end_table = loadBlocksFromFile('kmod+/spree.cfg',"end")

	if not global_spree_table then 
		if tonumber(et.trap_Cvar_Get("k_debug")) > 0 then et.G_Print("KMOD+ ERROR: couldn't load killing sprees!\n" ) end 
		global_spree_table = {}
	end
	if not global_spree_end_table then 
		if tonumber(et.trap_Cvar_Get("k_debug")) > 0 then et.G_Print("KMOD+ ERROR: couldn't killing spree end! \n" ) end 
		global_spree_end_table = {}
	end
	if not global_multikill_table then 
		if tonumber(et.trap_Cvar_Get("k_debug")) > 0 then et.G_Print("KMOD+ ERROR: couldn't load multikills \n" ) end 
		global_multikill_table = {}
	end
	

	

	--[[
	for key,value in pairs(global_spree_table) do
		et.G_LogPrint("key: " .. key)
		if type(value) == "table" then
			et.G_LogPrint("\n")
			for k,v in pairs(value) do
				et.G_LogPrint("		k: " .. k .. " - v: " .. v .. "\n")
			end
		else
			et.G_LogPrint(" value: " .. value .. "\n")
		end
	end
	--]]

--[[
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
			name = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" )
			guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" ))
			team = et.gentity_get(i,"sess.sessionTeam")
			
			if (team ~= nil and team ~= "" and guid ~= nil and guid ~= "" and name ~= nil and name ~= "") then
				global_players_table[i] = {}
				global_players_table[i]["name"] = name
				global_players_table[i]["guid"] = guid
				global_players_table[i]["team"] = team
				global_players_table[i]["begin"] = 0
				--et.G_Print("***initializing player***\n")
				--et.G_Print("name - " .. name .. "\n")
				--et.G_Print("team - " .. team .. "\n")
				--et.G_Print("guid - " .. guid .. "\n")
			end
			

	end
--]]






	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		killingspree[i] = 0
		flakmonkey[i] = 0
		deathspree[i] = 0
		multikill[i] = 0
		muted[i] = 0
		nummutes[i] = 0
		antiloopadr1[i] = 0
		antiloopadr2[i] = 0
		adrenaline[i] = 0
		adrnum[i] = 0
		adrnum2[i] = 0
		adrtime[i] = 0
		adrtime2[i] = 0
		adrendummy[i] = 0
		clientrespawn[i] = 0
		invincDummy[i] = 0
		switchteam[i] = 0
		gibbed[i] = 0

		playerwhokilled[i] = 1022
		killedwithweapk[i] = ""
		killedwithweapv[i] = ""
		playerlastkilled[i] = 1022
		selfkills[i] = 0
		teamkillr[i] = 0
		khp[i] = 0
		AdminName[i] = ""
		originalclass[i] = ""
		originalweap[i] = ""

		killr[i] = 0
	end

	


------------------------------ map Rotation -----------------------------------------------
	local rotation = et.trap_Cvar_Get("k_rotation")
	if rotation ~= "" and rotation ~= " " then
		et.trap_Cvar_Set("nextmap","vstr k_nextmap") 
		global_maps_table = loadBlocksFromFile('kmod+/maps.cfg',"map")
		if type(global_maps_table) == "nil" then
			et.trap_Cvar_Set("k_rotation","")
			et.G_Print( "KMOD+ Rotation ERROR: can't load map settings from kmod+/maps.cfg \n" )
			--et.G_Print( "KMOD+ Rotation Error: using original 6 maps.\n" )
			--global_maps_table = ORIGINAL_6_MAPS_ROTATION
		end
		if tonumber(et.trap_Cvar_Get("k_debug")) > 1 then
			et.G_Print( "KMOD+ Rotation debug: printing loaded maps\n" )
			for nickname,map in pairs(global_maps_table) do
				et.G_Print( "KMOD+ Rotation debug: nickname - " ..nickname.. " .bsp - " .. map["name"] .."\n" )
			end
		end
	end

	if restart == 0 then	
		Krotation(true)
	end


	----
	et.G_Print( "KMOD+ version " .. et.trap_Cvar_Get("kmod_version") .. " has been initialized...\n" )
	----



end





function et_ClientDisconnect(clientNum)
	if clientNum == nil then return end -- No Quarter calls et_ClientDisconnect for no reason on empty server, genrating an error
	if global_players_table[clientNum] == nil then -- same reasaon as above
		return -- player has never been set, nothing left to do.
	end 
	if global_players_table[clientNum]["team"] == CONNECTING then -- client dropped on connection, even before joining the server, nothing to do here...
		return
	end
	local guid = string.upper(global_players_table[clientNum]["guid"])

	-- store warnings
	if global_players_table[clientNum]["warnings"] then
		WriteTableToFile('kmod+/misc/warnings/'..global_players_table[clientNum]["guid"]..'.dat',global_players_table[clientNum]["warnings"])
	end

	if k_logchat == 1 then
		log_chat(clientNum, "DISCONNECT", "DV2")
	end

	-- unignore all clients this slot ignored (delete from the ignore file)
	write_ignores()

	-- player track facility
	local player_tracker = tonumber(et.trap_Cvar_Get("k_player_tracker"))
	if player_tracker ~= nil then
		if player_tracker > 0 then
			if guid ~= "UNKNOWN" then
				write_player_info_table(guid)
			end
			
		end
	end

	-- distroy the slots table
	global_players_table[clientNum] = nil


	----- k_mute section ----
	k_mute = tonumber(et.trap_Cvar_Get("k_mute"))
	if k_mute ~= nil then
		if k_mute > 0 then
			local bit = bitflag(k_mute,32)

		
			if global_mute_table[guid] ~= nil then
				if bit[1] == 0 then -- persistant mute is disabled, delete the mute!
					unmute(guid)
				end
			end
			
			if bit[4] == 1 then -- unmute all players this admin/player has muted
				for k,v in pairs(global_mute_table) do
					if global_mute_table[k]["muter_guid"] == guid then
						--et.G_Print("check - \n\n\n\n")
						unmute(k)
					end
				end
			end
		end

	end

	-- globals
	CONNECTED_PLAYERS = CONNECTED_PLAYERS - 1

	killingspree[clientNum] = 0
	flakmonkey[clientNum] = 0
	deathspree[clientNum] = 0
	multikill[clientNum] = 0
	nummutes[clientNum] = 0
	antiloopadr1[clientNum] = 0
	antiloopadr2[clientNum] = 0
	adrenaline[clientNum] = 0
	adrnum[clientNum] = 0
	adrnum2[clientNum] = 0
	adrtime[clientNum] = 0
	adrtime2[clientNum] = 0
	adrendummy[clientNum] = 0
	clientrespawn[clientNum] = 0
	invincDummy[clientNum] = 0
	switchteam[clientNum] = 0
	gibbed[clientNum] = 0

	playerwhokilled[clientNum] = 1022
	killedwithweapk[clientNum] = ""
	killedwithweapv[clientNum] = ""
	playerlastkilled[clientNum] = 1022
	selfkills[clientNum] = 0
	teamkillr[clientNum] = 0
	khp[clientNum] = 0
	AdminName[clientNum] = ""
	originalclass[clientNum] = ""
	originalweap[clientNum] = ""

	killr[clientNum] = 0

	kill1[clientNum] = ""
	kill2[clientNum] = ""
	kill3[clientNum] = ""
	kill4[clientNum] = ""
	kill5[clientNum] = ""
	kill6[clientNum] = ""




	



	---- greeting -------
	-- the player/admin disconnected, delete him from the "online admins" (so it will play his greeting next time he connects)
	Cvar.Remove_Slot("k_online_admins",clientNum)




	----------------------------------------------------------------------------
		-- check weapon restrictions		By Necromancer
	----------------------------------------------------------------------------
	TEAM_SPECTATOR = 3
	if tonumber(et.gentity_get(clientNum,"sess.sessionTeam")) ~= TEAM_SPECTATOR and k_countspecs == 0 then
	heavyWeaponRestriction(PANZERFAUST)
	heavyWeaponRestriction(FLAMETHROWER)
	heavyWeaponRestriction(MOBILE_MG42)
	heavyWeaponRestriction(MORTAR)
	heavyWeaponRestriction(LANDMINE)
	heavyWeaponRestriction(GRENADE_LAUNCHER)
	elseif k_countspecs == 1 then
	heavyWeaponRestriction(PANZERFAUST)
	heavyWeaponRestriction(FLAMETHROWER)
	heavyWeaponRestriction(MOBILE_MG42)
	heavyWeaponRestriction(MORTAR)
	heavyWeaponRestriction(LANDMINE)
	heavyWeaponRestriction(GRENADE_LAUNCHER)
	end





------------------------------ map Rotation -----------------------------------------------
	Krotation(false)
end






function et_ConsoleCommand() 





	-- console commands , By Necromancer
	local s,e,command = string.find(et.trap_Argv(0), k_commandprefix .. "(%w+)")
	if (command ~= nil) then
		local params = {}
		local i=1
		-- if et.trap_Argv(i) is empty, it returns "" (and not nil!)
		while string.lower(et.trap_Argv(i)) ~= "" do
			params[i] =  string.lower(et.trap_Argv(i))
			i=i+1
		end
		ClientUserCommand("console", "SC", command, params)
		return 1 -- command was intercepted!
	end




	if string.lower(et.trap_Argv(0)) == "m2" then  -- used when advancedpms is enabled
		if k_advancedpms == 1 then
			if (et.trap_Argc() < 2) then 
				et.G_Print("Useage:  /m \[pname/ID\] \[message\]\n")
				return 1
			else
				private_message(1022, et.trap_Argv(1), et.ConcatArgs(2))
			end

			if k_logchat == 1 then
				log_chat( 1022, "PMESSAGE", et.ConcatArgs(2), et.trap_Argv(1) )
			end
			return 1
		end
	elseif string.lower(et.trap_Argv(0)) == "m" or string.lower(et.trap_Argv(0)) == "pm" or string.lower(et.trap_Argv(0)) == "msg" then
		--if k_advancedpms == 0 then
			
			if k_logchat == 1 then
				log_chat( 1022, "PMESSAGE", et.ConcatArgs(2),  et.trap_Argv(1) )
				
			end
			
			-- doesnt work currently, use the ETpro's PM's (sending m to console seems to trigger ETpro's PM system, it doesnt pass it to lua first :/ )

			--private_message(1022, et.trap_Argv(1), et.ConcatArgs(2))
			--return 0
		--end
	elseif string.lower(et.trap_Argv(0)) == "ma" or string.lower(et.trap_Argv(0)) == "pma" then
		local sender_name = "^wconsole"
		if k_logchat == 1 then
			log_chat( 1022, "PMADMINS", et.ConcatArgs(2),  et.trap_Argv(1) )
				
		end

		for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do
			if global_players_table[i] ~= nil then
				if level_flag(AdminUserLevel(i), "~") or tonumber(et.gentity_get(i,"sess.referee")) ~= 0 then
					et.trap_SendServerCommand(i, string.format('%s \"%s"\n',MOD["CHAT"],"^w(^aAdminchat^w) " ..sender_name .. "^w: ^a" ..et.ConcatArgs(1) ))
				end
			end
		end
		et.G_Print("^w(^aAdminchat^w) " ..sender_name .. "^w: ^a" ..et.ConcatArgs(1) )
		return 1
	elseif string.lower(et.trap_Argv(0)) == "ref" and string.lower(et.trap_Argv(1)) == "pause" and pausedv == 0 then
		GAMEPAUSED = 1
		dummypause = mtime
		return 0
	elseif string.lower(et.trap_Argv(0)) == "ref" and string.lower(et.trap_Argv(1)) == "unpause" and pausedv == 1 then
		GAMEPAUSED = 0
		return 0
	else
		--return 0 
	end 



	-- the function must return something in order to stop the 
	-- etpro: et_ConsoleCommand - expected integer, got nil 
	-- error.

	-- and if we got untill here.. then we got a pass-thrue, return 0
	return 0

end 






function et_ClientConnect( clientNum, firstTime, isBot )
	if global_players_table[clientNum] == nil then
		global_players_table[clientNum] = {}
		global_players_table[clientNum]["guid"] = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "cl_guid" ))
		global_players_table[clientNum]["ignoreClients"] = {}
	end

	if isBot == 1 then
		global_players_table[clientNum]["bot"] = true
	else
		global_players_table[clientNum]["bot"] = false
	end
end






function et_ClientBegin( clientNum )
	
	local name = et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "name" )
	local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "cl_guid" ))
	if TZAC > 0 then
		local cs   = et.trap_GetConfigstring(63)
		tzac_guid = et.Info_ValueForKey(cs, string.format('ac_g%d', clientNum))
		guid = string.format('%032d', tonumber(tzac_guid))
	end

	-- i removed the credits from showing in-game
	-- the client doesnt care if this server runs KMOD or not, why would he? its just spam
	-- and if an admin whants to use KMOD, im sure he'll be able to find it and use it.
	--ModInfo(clientNum, name)

	CONNECTED_PLAYERS = CONNECTED_PLAYERS + 1

	if  global_players_table[clientNum] == nil then -- how is it possible? see et_ClientSpawn
		global_players_table[clientNum] = {}
	end
	global_players_table[clientNum]["guid"] = guid


	

	
	global_players_table[clientNum]["name"] = name
	global_players_table[clientNum]["tzac_name"] = false -- later to be overriden by slac/tzac
	global_players_table[clientNum]["ip"] = string.gsub(et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "ip" ), "%:%d+", "") -- gsub removed the :port from the ip
	global_players_table[clientNum]["team"] = et.gentity_get(clientNum,"sess.sessionTeam")
	--et.G_Print("slot: " .. clientNum .. " guid: " ..  global_players_table[clientNum]["guid"] .. " IP: " .. global_players_table[clientNum]["ip"] .. "\n")
	global_players_table[clientNum]["spawn_num"] = et.gentity_get(clientNum,"sess.spawnObjectiveIndex")
	--et.G_Print("players spawn point is: " ..global_players_table[clientNum]["spawn_num"] ..  "\n")
	global_players_table[clientNum]["lastcommand"] = os.time()
	global_players_table[clientNum]["begin"] = 1
	global_players_table[clientNum]["namechange"] = 0
	global_players_table[clientNum]["inactivity_warning"] = 0
	if global_players_table[clientNum]["ignoreClients"] == nil then 
		global_players_table[clientNum]["ignoreClients"] = {}
	end

	-- killing, spree's, etc..
	-- injury
	global_players_table[clientNum][KILL] = {}
	global_players_table[clientNum][KILL]["spree"] = 0
	global_players_table[clientNum][KILL]["killer_name"] = ""
	global_players_table[clientNum][KILL]["killer_weapon"] = 0
	global_players_table[clientNum][KILL]["victim_name"] = ""
	global_players_table[clientNum][KILL]["victim_weapon"] = 0
	global_players_table[clientNum][KILL]["kill_time"] = 0
	global_players_table[clientNum][KILL]["multikill"] = 1
	global_players_table[clientNum][KILL]["kills"] = 0
	global_players_table[clientNum][KILL]["teamkills"] = 0
	global_players_table[clientNum][KILL]["deaths"] = 0

	isBanned(clientNum)

	global_players_table[clientNum]["level"] = AdminUserLevel(clientNum)
	
	-- check if name is forced
	-- TODO: move to global, so it'll only be read once a map
	checkForced(clientNum)
	if global_players_table[clientNum]['forced_name'] then
		global_players_table[clientNum]['forced_name_flag'] = true
		if tonumber(et.trap_Cvar_Get("k_debug")) > 0 then et.G_Print("KMOD+: client " .. clientNum .. " name is forced to " .. global_players_table[clientNum]['forced_name'] .. "\n" ) end
	end

	

	--et.G_Print("player defind: " .. clientNum .. " name: " .. name .. "\n")
--[[
	if global_ghost_table[clientNum] ~= nil then
		--et.G_Print("ghost player joined\n")
		--for k,v in pairs(global_ghost_table[clientNum]) do
		--	et.G_Print("key: " .. k .. " value: " .. v .. "\n")
		--end
		if global_ghost_table[clientNum]["guid_age"] ~= nil then
			if global_ghost_table[clientNum]["guid"] == guid then
				
				global_players_table[clientNum]["guid_age"] = global_ghost_table[clientNum]["guid_age"] 
				global_ghost_table[clientNum] = nil
				--et.G_Print("guid_age set on client_begin: " .. clientNum .." age: " .. global_players_table[clientNum]["guid_age"] .."\n")
			else
				global_ghost_table[clientNum] = nil
			end
		end
		global_ghost_table[clientNum] = nil
	end
--]]
	
	local temp_guid,temp_slot,args
	for slot,args in pairs(global_ghost_table) do
		--for k,v in pairs(args) do
		--	et.G_Print(" *** args key - ".. k .. " - value - " .. v .." *** \n")
		--end
		
		--et.G_Print("\n\n *** runing on guids! *** \n")
		if args["guid"] ~= nil then
			--et.G_Print("comparing - " ..args["guid"] .. " | " .. guid ..  "\n")
			if guid == args["guid"] then
				if args["guid_age"] ~= nil then
					global_players_table[clientNum]["guid_age"] = args["guid_age"]
					--et.G_Print("guid age - spotted!\n")
				end
			end
		end
	end


	--loadAdmins()
	MuteCheck(clientNum)



	teamkillr[clientNum] = 0
	selfkills[clientNum] = 0

	


	if k_logchat == 1 then
		log_chat(clientNum, "CONN", "DV")
	end



	if (global_level_table[global_players_table[clientNum]["level"]]["greeting"] ~= "" or global_level_table[global_players_table[clientNum]["level"]]["sound"] ~= "" ) then -- display the greeting (or sound)
		if global_players_table[clientNum]["bot"] ~= true then -- don't show greetings for bots

			if not Cvar.Slot_Exists("k_online_admins",clientNum) then -- he just connected (hes not set on the cvar)
				if (global_level_table[global_players_table[clientNum]["level"]]["greeting"] ~= "") then
					-- the % charactar works as an escape charactar in string.gsub (like the \ charactar normally)
					--local greeting = string.gsub(global_level_table[global_players_table[clientNum]["level"]]["greeting"],"%[level%]", tostring(global_level_table[global_players_table[clientNum]["level"]]["name"]) ) -- deprecated
					local greeting = global_level_table[global_players_table[clientNum]["level"]]["greeting"]
					greeting = string.gsub(greeting,"%[player%]", name)
					et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',MOD["CHAT"],greeting))
					--et.G_LogPrint("KMOD+: greeting slot " ..clientNum .." name " ..  name .." level " ..global_players_table[clientNum]["level"] .. " with: " ..greeting .. "\n"  )
				end
				if (global_level_table[global_players_table[clientNum]["level"]]["sound"] ~= "") then
					--et.G_Print("playing sound greeting: " .. global_level_table[global_admin_table[guid]["level"]]["sound"] .. "\n")
					et.G_globalSound(global_level_table[global_players_table[clientNum]["level"]]["sound"])
				end

				Cvar.Add_Slot("k_online_admins",clientNum) -- remember the admin, to *not* display his greeting next round.
			end
		end
		
	end

	


	local guid_age = tonumber(et.trap_Cvar_Get("k_min_guid_age"))
	if guid_age ~= nil then
		if guid_age ~= 0 then
			if global_players_table[clientNum]["guid_age"] ~= nil then		
				if (global_players_table[clientNum]["guid_age"] < math.abs(guid_age)) then
					et.G_LogPrint("KMOD+ player kicked: " .. clientNum .. " guid is too new")
					if guid_age > 0 then
						et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. clientNum+1 .. " " .. 2 .. " ^9reason: " ..  "^9your guid is too new, please come back in ^1" .. guid_age-global_players_table[clientNum]["guid_age"] .. "^9 days\n") 
					else
						et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. clientNum+1 .. " " .. (math.abs(guid_age)-global_players_table[clientNum]["guid_age"])*1440 .. " ^9reason: " ..  "^9your guid is too new, please come back in ^1" .. math.abs(guid_age)-global_players_table[clientNum]["guid_age"] .. "^9 days\n") 
					end
				end
			end
		end
	end


	checkPlayerName(clientNum) -- make sure the name is fine

	-- display last warning if available
	global_players_table[clientNum]["warnings"] = LoadFileToTable('kmod+/misc/warnings/'..global_players_table[clientNum]["guid"]..'.dat')
	if global_players_table[clientNum]["warnings"] and table.getn(global_players_table[clientNum]["warnings"]) > 0 then
		local last = table.getn(global_players_table[clientNum]["warnings"])
		local warning = global_players_table[clientNum]["warnings"][last]
		et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',"print" , global_players_table[clientNum]["name"] .. ' ^3was warned ^1[' .. last .. '/' .. MAX_WARNINGS .. ']^3: ^w' .. warning ))
	end


	-- player tracker facility
	local player_tracker = tonumber(et.trap_Cvar_Get("k_player_tracker"))
	if player_tracker ~= nil then
		if player_tracker > 0 then

			if guidCheck(guid) then
		
				local ip = string.gsub(et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "ip" ), "%:%d+", "")
			
				if load_player_info_table(guid) == -1 then -- new player
					local s,e
					local db
					--[[
					-- players might use the system reserved names: [alias] [ip] and [warning]
					-- adding a follow char like ^w should prevent the loader from loading crap
					s,e = string.find(name, "s*\%[alias%]")
					if s and e then 
						name = "^w[^wali^was]"
					end
					s,e = string.find(name, "s*\%[ip%]")
					if s and e then 
						name = "^w[^wi^wp]"
					end
					s,e = string.find(name, "s*\%[warning%]")
					if s and e then 
						name = "^w[^wwarn^wing]"
					end
					
					global_players_info_table[guid]["alias"][1] = name
					global_players_info_table[guid]["ip"][1]  = ip
					--]]
					global_players_info_table[guid] = newTDB()
					global_players_info_table[guid]["alias"] = {}
					global_players_info_table[guid]["alias"][1] = name
					global_players_info_table[guid].setList("ip",ip)
					if global_players_table[clientNum]["tzac_name"] then
						global_players_info_table[guid].set("tzac_name",global_players_table[clientNum]["tzac_name"])
					end


				
					-- check if the player isnt ban-masked
					local temp_ip = {}
					
					s,e,temp_ip[1],temp_ip[2],temp_ip[3],temp_ip[4] = string.find(ip, "(%d+).(%d+).(%d+).(%d+)")
					if s and e then
						temp_ip = temp_ip[1] .. "." .. temp_ip[2]

						if global_banmask_table[temp_ip] ~= nil then -- the player has been banned
							et.G_LogPrint("KMOD banmask - " .. temp_ip .. " : client ".. clientNum .. " - " .. global_players_table[clientNum]["name"] .. " has been kicked \n")
							et.trap_DropClient( clientNum, "You are banned from this server")
							-- dont save him!
							global_players_info_table[guid] = nil
							
						end
					end
				else -- not a new player
					--
					if not player_info_isAliasExist(global_players_info_table[guid]["alias"],name) then
						--et.G_Print("**** begin-alias: " .. name .. " table index:" .. table.getn(global_players_info_table[guid]["alias"])+1 .."\n")
						if (global_players_info_table[guid]["alias"] == nil) then
							global_players_info_table[guid]["alias"] = {}
						end
						global_players_info_table[guid]["alias"][table.getn(global_players_info_table[guid]["alias"])+1] = name

						
					end
					if global_players_info_table[guid].get("tzac_name") then
						global_players_table[clientNum]["tzac_name"] =  global_players_info_table[guid].get("tzac_name")
					end
					if global_players_info_table[guid].get("guid_age") then
						global_players_table[clientNum]["guid_age"] =  global_players_info_table[guid].get("guid_age")
					end
					--et.G_Print("**** TEST: " .. type(global_players_info_table[guid].get("guid_age")) .. "\n")

					--[[
					if not player_info_isIpExist(global_players_info_table[guid]["ip"],ip) then
						--et.G_Print("**** begin-ip: " .. ip .."  table index:" ..  table.getn(global_players_info_table[guid]["ip"])+1 .. "\n")
						--global_players_info_table[guid]["ip"][table.getn(global_players_info_table[guid]["ip"])+1] = ip
						
					end
					--]]
					global_players_info_table[guid].setList("ip",ip)

					-- display the last player warning!
					--[[
					if global_players_info_table[guid]["warnings"] then
						local last_warning = table.getn(global_players_info_table[guid]["warnings"])
						local warn = ""
						local date = ""
						s,e, date = string.find(global_players_info_table[guid]["warnings"][last_warning], "%d+")
						if s and e then
							date = tonumber(date)
							warn = string.sub(global_players_info_table[guid]["warnings"][last_warning],e+1)
						end

							
						--global_players_info_table[guid]["warnings"][table.getn(global_players_info_table[guid]["warnings"])]
						et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',"print" , global_players_table[clientNum]["name"] .. ' ^3was warned ^1[' .. table.getn(global_players_info_table[guid]["warnings"]) .. '/' .. MAX_WARNINGS .. ']^3: ^w' .. warn ))
					end
	--]]
				end
			end

		end

	end
	
	if et.trap_Cvar_Get( "sv_punkbuster" ) == 0 then
		 
		local ip = string.gsub(et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "ip" ), "%:%d+", "")
			
		local s,e
		local db

		-- check if the player isnt ban-masked
		local temp_ip = {}
					
		s,e,temp_ip[1],temp_ip[2],temp_ip[3],temp_ip[4] = string.find(ip, "(%d+).(%d+).(%d+).(%d+)")
		if s and e then
			temp_ip = temp_ip[1] .. "." .. temp_ip[2]

			if global_banmask_table[temp_ip] ~= nil then -- the player has been banned
				et.G_LogPrint("KMOD banmask - " .. temp_ip .. " : client ".. clientNum .. " - " .. global_players_table[clientNum]["name"] .. " has been kicked \n")
				et.trap_DropClient( clientNum, "You are banned from this server")
							
			end
		end
	end


------------------------------ map Rotation -----------------------------------------------
	Krotation(false)



end



--[[
function ModInfo(PlayerID, Pname)
	et.trap_SendServerCommand( PlayerID,"cpm \"This server is running the Expended KMOD version " .. KMODversion .. "\n\"")
	et.trap_SendServerCommand( PlayerID,"cpm \"Created by Clutch152.\n\"")
	et.trap_SendServerCommand( PlayerID,"cpm \"Extended by ^wNecromancer\n\"")
end
--]]




function et_Obituary( victim, killer, meansOfDeath )
	KILL = "kill"
	--TEST: killing spree, killing spree end, death spree, death spree end, multi-kills, ownage
	-- works: killing sprees, death sprees, ownage
	if victim == killer then -- some updates
		-- player might of changed teams
		global_players_table[victim]["team"] = et.gentity_get(victim,"sess.sessionTeam")

		--[[
		-- lets check the the teams are still balanced!
		if tonumber(et.trap_Cvar_Get("k_balance")) ~= nil and tonumber(et.trap_Cvar_Get("k_balance")) == 1 then 
			if (math.abs(countAllies() - countAxis() ) > 1) then -- teams are unbalanced by 3+ players!
				balance_teams()
			end
		end
		--]]
			
	end

	--global_players_table[victim]["kill"]
	--[[
	-- killing spree
	if killer == 1022 or killer == victim then -- sucide
		if global_players_table[victim][KILL]["spree"] > 0 then 
			-- print killing spree end message
			killingSpreeEnd(victim, killer)	
		end
	end
	--]]

	-- killing spree end
	if global_players_table[victim][KILL]["spree"] > 0 then 
		killingSpreeEnd(victim, killer)	
		global_players_table[victim][KILL]["spree"] = -1
	else 
		global_players_table[victim][KILL]["spree"] = global_players_table[victim][KILL]["spree"] -1
	end	
	
	MOD_CRUSH = 34
	if meansOfDeath == MOD_CRUSH then return end
	global_players_table[victim][KILL]["killer_name"] = global_players_table[killer]["name"] or ""
	global_players_table[victim][KILL]["killer_weapon"] = meansOfDeath

	if not global_players_table[killer] then return end -- killer has disconnected (an artillery, mortar, granade etc.. kill)

	local ownage = tonumber(et.trap_Cvar_Get("ownage"))
	if not ownage then ownage = 0 end
	if killer ~= 1022 and tonumber(et.gentity_get(victim, "sess.sessionTeam")) ~= tonumber(et.gentity_get(killer, "sess.sessionTeam")) and killer ~= victim and not killingSpree(killer) and ownage > 0 and global_players_table[killer][KILL]["spree"] >= ownage then
		if math.mod (global_players_table[killer][KILL]["spree"] - ownage, tonumber(et.trap_Cvar_Get("ownage_kills_display"))) == 0 then
			-- print message, play music etc...
			local message = et.trap_Cvar_Get("ownage_message")
			local sound = et.trap_Cvar_Get("ownage_sound")
			message = string.gsub(message,"\%[n%]",global_players_table[killer]["name"])
			message = string.gsub(message,"\%[k%]",global_players_table[killer][KILL]["spree"])

			--string.gsub(message,'[v]',global_players_table[killer][KILL]["victim_name"])
			et.trap_SendServerCommand( -1 , string.format('%s \"%s"',"b 32", message))
			if et.trap_Cvar_Get("gamename") == "etpub" then 
				et.trap_SendConsoleCommand( et.EXEC_APPEND, string.format('%s %s', "playsound" , sound ))
			else -- etpro mod
				et.G_globalSound(sound)
			end


		end
	end




	if killer ~= 1022 and  tonumber(et.gentity_get(victim, "sess.sessionTeam")) ~= tonumber(et.gentity_get(killer, "sess.sessionTeam")) and killer ~= victim then -- not teamkill or self-kill or world kill
		-- we got a legitimit kill, stop any death spree's, and count killing spree

		if global_players_table[killer][KILL]["spree"] < 0 then
			-- print end of death spree message
			--et.G_Print("test: print death spree end \n")
			deathSpreeEnd(victim, killer)			

			global_players_table[killer][KILL]["spree"] = 1
		else
			global_players_table[killer][KILL]["spree"] = global_players_table[killer][KILL]["spree"] + 1
		end
	end
	


	if killer == 1022 or tonumber(et.gentity_get(victim, "sess.sessionTeam")) == tonumber(et.gentity_get(killer, "sess.sessionTeam")) then -- teamkill (everything connected to teamkill or selfkill should go here)
		if killer ~= 1022 then -- wasnt killed by "world" (fell to his death, etc...)
			if killer ~= victim then -- not a sucide either (player killed another player from his own team)
				global_players_table[killer][KILL]["teamkills"] = global_players_table[killer][KILL]["teamkills"] + 1
				
				if tonumber(et.trap_Cvar_Get("k_fearsound")) and tonumber(et.trap_Cvar_Get("k_fearsound")) > 0 then -- FEAR "Teams asswhole"
					et.trap_SendServerCommand(et.EXEC_APPEND, "playsound_env " .. victim .. " " .. 'usefpubsounds/fear/15719.wav')
				end
			end
		end
		global_players_table[victim][KILL]["deaths"] = global_players_table[victim][KILL]["deaths"] + 1
		return
	end
	-- NOT TEAM KILL / Self kill!!!

	-- Multi Kills
	local multi_kill,temp
	local scvar = tonumber(et.trap_Cvar_Get("k_multikill"))
	if scvar ~= nil and scvar > 0 then
		if os.time() - global_players_table[killer][KILL]["kill_time"] <= scvar then -- current kill is inside the 3 seconds multi-kill window
			global_players_table[killer][KILL]["multikill"] = global_players_table[killer][KILL]["multikill"] + 1
		else -- else reinitialize the multikill counter
			global_players_table[killer][KILL]["multikill"] = 1
		end
		for multi_kill,temp in pairs(global_multikill_table) do
			if global_players_table[killer][KILL]["multikill"] == multi_kill then
				-- print message, play sound, whatever
				local message, recipients, play
				message = global_multikill_table[multi_kill]["message"]
				message = string.gsub(message,"\%[n%]",global_players_table[killer]["name"])
				message = string.gsub(message,"\%[k%]",math.abs(global_players_table[killer][KILL]["multikill"]))
				if string.lower(global_multikill_table[multi_kill]["display"]) == "all" then
					recipients = -1
				else
					recipients = victim
				end
				et.trap_SendServerCommand( recipients , string.format('%s \"%s"',getMessagePosition(global_multikill_table[multi_kill]["position"]), message))
				if et.trap_Cvar_Get("gamename") == "etpub" then 
					et.trap_SendConsoleCommand( et.EXEC_APPEND, string.format('%s %s',getSoundPosition(global_multikill_table[multi_kill]["play"],killer), global_multikill_table[multi_kill]["sound"] ))
				else -- etpro mod
					if getSoundPosition(global_multikill_table[multi_kill]["play"],killer) == "playsound" then
						et.G_globalSound(global_multikill_table[multi_kill]["sound"])
					else
						et.G_ClientSound(player, global_multikill_table[multi_kill]["sound"])
					end
				end
			end
		end
		-- hardcoded FEAR sounds
		local scvar = tonumber(et.trap_Cvar_Get("k_fearsound"))
		if scvar ~= nil and scvar > 0 then
			if global_players_table[killer][KILL]["multikill"] == 2 then
				rand = math.random(5)
				if rand == 1 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds\fear\25363.wav')
				elseif rand == 2 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds/fear/25353.wav')
				elseif rand == 3 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds/fear/25354.wav')
				elseif rand == 4 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds/fear/25361.wav')
				elseif rand == 5 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds/fear/25360.wav')
				end
			elseif global_players_table[killer][KILL]["multikill"] == 3 then
				rand = math.random(3)
				if rand == 1 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds/fear/25364.wav')
				elseif rand == 2 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds/fear/25362.wav')
				elseif rand == 3 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds/fear/25358.wav')
				end
			elseif global_players_table[killer][KILL]["multikill"] == 4 then
				rand = math.random(3)
				if rand == 1 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds/fear/25365.wav')
				elseif rand == 2 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds/fear/25362.wav')
				elseif rand == 4 then
					et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env " .. killer .. " " .. 'usefpubsounds/fear/25360.wav')
				end
			end
		end
	end

	
	global_players_table[killer][KILL]["victim_name"] = global_players_table[victim]["name"]
	global_players_table[killer][KILL]["victim_weapon"] = meansOfDeath
	global_players_table[killer][KILL]["kill_time"] = os.time()
	global_players_table[killer][KILL]["kills"] = global_players_table[killer][KILL]["kills"] + 1



	if Gamestate == PLAYING then
		if global_game_table["first_blood"] == nil then
			global_game_table["first_blood"] = killer
			if k_firstblood == 1 then
				if k_fb_location == 1 then 
					fb_location = "chat"
				elseif k_fb_location == 2 then 
					fb_location = "cp"
				elseif k_fb_location == 3 then 
					fb_location = "bp"
				else 
					fb_location = "cpm"
				end
				local str = string.gsub(k_fb_message, "#killer#", global_players_table[killer]["name"])
				et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..fb_location.." "..str.."\n" )
				if k_firstbloodsound == 1 then
					if k_noisereduction == 1 then
						et.G_ClientSound(killer, firstbloodsound)
					else
						et.G_globalSound(firstbloodsound)
					end
				end
			end
		end
	end
	global_game_table["last_blood"] = global_players_table[killer]["name"]
	

 
	local killerhp = et.gentity_get(killer, "health") 
	if k_killerhpdisplay == 1 then
		
			et.trap_SendServerCommand( victim , string.format('%s \"%s"',MOD["CP"], global_players_table[killer]["name"] .. " ^fhad ^1" .. killerhp .. " ^fhealth left" ))
		--[[
		
			if (killerhp>=75) then
			et.trap_SendServerCommand(victim, ("b 8 \"^" .. k_color .. "You got owned!"))
				et.trap_SendServerCommand(victim, ("b 8 \"^7" .. killername .. "^" .. k_color .. "'s hp (^o" ..killerhp .. "^" .. k_color .. ")"))
				if adrenaline[killer] == 1 then
					et.trap_SendServerCommand(victim, ("b 8 \"^7" .. killername .. "^" .. k_color .. " is an adrenaline junkie!\""))
				end
			elseif (killerhp>=50 and killerhp<=74) then
				et.trap_SendServerCommand(victim, string.format("b 8 \"^" .. k_color .. "You're not a total newb."))
				et.trap_SendServerCommand(victim, string.format("b 8 \"^7" ..killername .. "^" .. k_color .. "'s hp (^o" ..killerhp.. "^" .. k_color .. ")"))
				if adrenaline[killer] == 1 then
					et.trap_SendServerCommand(victim, ("b 8 \"^7" .. killername .. "^" .. k_color .. " is an adrenaline junkie!\""))
				end
			elseif (killerhp>=25 and killerhp<=49) then
				et.trap_SendServerCommand(victim, string.format("b 8 \"^" .. k_color .. "Try Harder!"))
				et.trap_SendServerCommand(victim, string.format("b 8 \"^7" ..killername.. "^" .. k_color .. "'s hp (^o" ..killerhp.. "^" .. k_color .. ")"))
				if adrenaline[killer] == 1 then
					et.trap_SendServerCommand(victim, ("b 8 \"^7" .. killername .. "^" .. k_color .. " is an adrenaline junkie!\""))
				end
			elseif (killerhp>0 and killerhp<=24) then
				et.trap_SendServerCommand(victim, string.format("b 8 \"^" .. k_color .. "Almost!"))
				et.trap_SendServerCommand(victim, string.format("b 8 \"^7" ..killername.. "^" .. k_color .. "'s hp (^o" ..killerhp.. "^" .. k_color .. ")"))
				if adrenaline[killer] == 1 then
					et.trap_SendServerCommand(victim, ("b 8 \"^7" .. killername .. "^" .. k_color .. " is an adrenaline junkie!\""))
				end
			end 
		
		
			if (killerhp<=0) then
				if meansOfDeath == 4 or meansOfDeath == 18 or meansOfDeath == 18 or meansOfDeath == 26 or meansOfDeath == 27 or meansOfDeath == 30 or meansOfDeath == 44 or meansOfDeath == 43 then
					et.trap_SendServerCommand(victim, string.format("b 8 \"^" .. k_color .. "You were owned by ^7" .. killername .. "^" .. k_color .. "'s explosive inheritance"))
				end
			end
			--]]

	end
	
	--kills(victim, killer, meansOfDeath, weapon)
	--deaths(victim, killer, meansOfDeath, weapon)

	if meansOfDeath == 64 or meansOfDeath == 63 then
		
		switchteam[victim] = 1
	else
		switchteam[victim] = 0
	end

--Weapons used!



--et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay <<<<<<INSERT OBITUARY HERE>>>>>>\n" )
--return 1
--et.trap_SendServerCommand(-1, string.format("play sound/misc/ludicrouskill.wav"))
--return
end




function et.G_ClientSound(clientnum, soundfile)
	local tempentity = et.G_TempEntity(et.gentity_get(clientnum, "r.currentOrigin"), EV_GLOBAL_CLIENT_SOUND)
	et.gentity_set(tempentity, "s.teamNum", clientnum)
	et.gentity_set(tempentity, "s.eventParm", et.G_SoundIndex(soundfile))
end






 -- the function runs a command file, and passes params{} as an argument
function runcommand (command , params)
	-- assert raises an error... im not sure we want it to raise error if the command/file does not exist
	command = command or "nil"
	--local filename = "C:\\Game_Servers\\Users\\et1\\etpro\\commands\\" .. command .. ".lua"


	--et.G_Print("command1: " ..command .."\n" )

	local filename = et.trap_Cvar_Get("fs_homepath")
	filename = filename .. '/' .. et.trap_Cvar_Get("gamename") .. '/kmod+/commands/' .. command .. ".lua"

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
				return 0
			else
        			et.trap_SendServerCommand( params.slot, params.say.." \"^fUnable to load  ^g" ..command.. "^7\"" )
				et.G_LogPrint("K_ERROR - command:  Unable to load " ..command )
				return 0
			end
		end
		

		if (type(dolua) == "function") then 
			if k_logchat == 1 then
				log_chat( params["slot"], "ADMIN_COMMAND", table.concat(params," "), command )
			end
			return dolua(params) -- run the code
		else
			if (params.slot == "console") then
				et.G_Print("^fImpossible to execute  ^3" ..command )
			else
        			et.trap_SendServerCommand( params.slot, params.say.." \"^fImpossible to execute  ^g" ..command.. "^7\"" )
			end
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

		
		if (params.slot == "console") then
			et.G_Print("^fUnknown command: ^g" ..command .. "\n")
		else
       			et.trap_SendServerCommand( params.slot, params.say.." \"^fUnknown command: ^g" ..command.. "^7\"" )
		end
	end
	return 0
end








function et_Quit() 
	disablewars()
	-- player track facility -> save all player data
	local player_tracker = tonumber(et.trap_Cvar_Get("k_player_tracker"))
	if player_tracker ~= nil then
		if player_tracker ~= 0 then
			for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
				if global_players_table[i] ~= nil then
					write_player_info_table(global_players_table[i]["guid"])
				end
			end
		end
	end
end



function et_ClientUserinfoChanged( clientNum )
--[[
	et.G_Print("\n\n")
	et.G_Print(math.ceil(tonumber(et.gentity_get(clientNum,"client.inactivityTime"))/1000) .. "\n")
	--et.gentity_set(clientNum,"client.inactivityTime", mtime - tonumber(et.trap_Cvar_Get("k_spectatorInactivity"))*1000 ) -- im too lazy now
	local inactivity = math.ceil(mtime/1000) - (math.ceil(tonumber(et.gentity_get(clientNum,"client.inactivityTime"))/1000) - tonumber(et.trap_Cvar_Get("g_Inactivity")))
	et.G_Print(inactivity .. "\n")
	et.G_Print(tonumber(et.trap_Cvar_Get("g_Inactivity")) .. "\n")
--]]


--[[
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		if global_players_table[i] ~= nil then 
			et.G_Print(i .. " - " .. global_players_table[i]['team'] .. "\n")
		end
	end

	-- team balance check
	if tonumber(et.trap_Cvar_Get("k_balance")) ~= nil and tonumber(et.trap_Cvar_Get("k_balance")) == 1 then 
		if (math.abs(countAllies() - countAxis() ) > 1) then -- teams are unbalanced by 3+ players!
			local i
			balance_teams()
		end
	end
--]]







	-- k_max_name_change - dont let players change names too many times
	if global_players_table[clientNum] ~= nil then
		userinfo = et.trap_GetUserinfo(clientNum)
		if global_players_table[clientNum]["name"] ~= et.Info_ValueForKey( userinfo , "name" ) then -- player changed name
			


			if global_players_table[clientNum]["namechange"] ~= nil then
				--[[
				-- first check if its a forced name, if it is, force it back on the client
				local force = newTDB()
				local forced_name
				local flag = 0
				force.readFile('kmod+/misc/names.dat')
				if force ~= nil then
					forced_name = force.get(guid)
					if forced_name ~= nil then -- we need to force the client to this name
						fflag = 1
						userinfo = et.trap_GetUserinfo(clientNum)
						userinfo = et.Info_SetValueForKey(userinfo, "name", forced_name)
						et.trap_SetUserinfo(clientNum, userinfo)
						et.ClientUserinfoChanged(clientNum)
					end
				end

				--]]

				if global_players_table[clientNum]['forced_name'] ~= nil then
					checkForced(clientNum)
				else


					--et.G_Print("-* name is NOT equal *-\n")
					global_players_table[clientNum]["namechange"] = global_players_table[clientNum]["namechange"] + 1

					if tonumber(et.trap_Cvar_Get("k_max_name_change")) ~= nil then
						local max_renames = tonumber(et.trap_Cvar_Get("k_max_name_change"))
						if max_renames > -1 then
							if global_players_table[clientNum]["namechange"] > max_renames then -- rename the player back to his original name
								--et.G_Print("-**** renaming back ****-\n")
								-- notify the client
								et.trap_SendServerCommand( clientNum , string.format("%s \"%s\n\"","print","^ftoo many name changes - you  cannot change your name anymore!"))
								userinfo = et.Info_SetValueForKey(userinfo, "name", global_players_table[clientNum]["name"])
								et.trap_SetUserinfo(clientNum, userinfo)
								et.ClientUserinfoChanged(clientNum)

							end
						end
					end
				end

			end



			-- player track facility
			-- local guid = string.upper(global_players_table[clientNum]["guid"] ) -- causing on error on players/bots that connected, has their userinfoChange, but did not begin yet.
			local guid = global_players_table[clientNum]["guid"]
			if global_players_info_table[guid] ~= nil then
				local name = et.Info_ValueForKey( userinfo , "name" )

				-- players might use the system reserved names: [alias] [ip] and [warning]
				-- adding a follow char like ^w should prevent the loader from loading crap
				--[[
				s,e = string.find(name, "s*\%[alias%]")
				if s and e then 
					name = "^w[^wali^was]"
				end
				s,e = string.find(name, "s*\%[ip%]")
				if s and e then 
					name = "^w[^wi^wp]"
				end
				s,e = string.find(name, "s*\%[warning%]")
				if s and e then 
					name = "^w[^wwarn^wing]"
				end
				--]]
				if not player_info_isAliasExist(global_players_info_table[guid]["alias"], name) then
					global_players_info_table[guid]["alias"][table.getn(global_players_info_table[guid]["alias"])+1] = name
				end
			end




		end
	end



	if global_players_table[clientNum] == nil then -- player is still connecting
		global_players_table[clientNum] = {}
		global_players_table[clientNum]["name"] = et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "name" )
		global_players_table[clientNum]["guid"] = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "cl_guid" )) 
		-- TZAC
		if TZAC > 0 then
			local cs   = et.trap_GetConfigstring(63)
			tzac_guid = et.Info_ValueForKey(cs, string.format('ac_g%d', clientNum))
			guid = string.format('%032d', tonumber(tzac_guid))
			global_players_table[clientNum]["guid"] = guid
		end
		--global_players_table[clientNum]["team"] = et.gentity_get(clientNum,"sess.sessionTeam")
		global_players_table[clientNum]["team"] = CONNECTING -- 0 = connecting (etpro doesnt support it, it only has axis/allies/specs)
		global_players_table[clientNum]["ip"] = string.gsub(et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "ip" ), "%:%d+", "") -- gsub removed the :port from the ip
		global_players_table[clientNum]["ignoreClients"] = {}
	end









	local temp_old_team = global_players_table[clientNum]["team"] -- save the old team before updating! used for map rotation update check


	if global_players_table[clientNum] ~= nil then
		-- update the player's team
		if global_players_table[clientNum]["team"] ~= CONNECTING then -- dont update the team number if the client is still connecting

			global_players_table[clientNum]["team"] = et.gentity_get(clientNum,"sess.sessionTeam")
		end

		global_players_table[clientNum]["name"] = et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "name" )
	end


	if temp_old_team ~= CONNECTING and temp_old_team ~= global_players_table[clientNum]["team"] then -- player changed team
		if temp_old_team == SPECTATOR or global_players_table[clientNum]["team"] == SPECTATOR then  -- if he was a spectator and his status changed -> he joined a team, if he's now a spectator and he wasnt before -> he joined the spectators!


		------------------------------ map Rotation -----------------------------------------------
			Krotation(false)
		end
	end


end

function et_IPCReceive( vm, message )
	local start,stop,slot,name
	start,stop,slot = string.find(message, "et.G_shrubbot_level(%s*(-?%d+)%s*)")
	if start and stop and slot then
		et.IPCSend( vm, slot )
	end
end