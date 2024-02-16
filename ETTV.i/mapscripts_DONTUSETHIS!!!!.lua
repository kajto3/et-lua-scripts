local cvars = {}

if mapname_lower == "[!]-b2" then
	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if origin[1] >= 6602 and origin[1] <= 13558 and origin[2] >= 8300 and origin[2] <= 38600 and origin[3] >= 760 and origin[3] <= 6000 then
			return true
		end
		return false
	end
elseif string.find(mapname_lower, "^bloodydave1") then
	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if origin[1] >= -30445.875 and origin[1] <= -27346.125 and origin[2] >= -11181.875 and origin[2] <= -9810.125
		or origin[1] >= -25005.875 and origin[1] <= -23634.125 and origin[2] >= -9325.875  and origin[2] <= -7186.125
		or origin[1] >= -26637.875 and origin[1] <= -25266.125 and origin[2] >= -10093.875 and origin[2] <= -7422.125
		or origin[1] >= -31469.875 and origin[1] <= -27954.125 and origin[2] >= -1549.875 and origin[2] <= -114.125 and origin[3] >= 1848.125 then
			return true
		else
			return false
		end
	end
elseif mapname_lower == "divinejumps" then
	--saveMaxUPS = 160
	--et.trap_Cvar_Set("jh_saveMaxUPS", saveMaxUPS)

	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if (origin[1] >= 17530 and origin[1] <= 18110 and origin[2] >= 3162 and origin[2] <= 4670)
		and not (origin[2] >= 3750 and origin[3] >552)
		or origin[1] >= 2420 and origin[1] <= 4082.125 and origin[2] >= -7685.875 and origin[2] <= -6122.125 and origin[3] >= -350 and origin[3] <= 50
		or origin[1] >= 10000 and origin[1] <= 10458.125 and origin[2] >= 14517.875 and origin[2] <= 15882.125 then
			return true
		--[[elseif origin[1] >= 17925.875 and origin[1] <= 18109.875 and origin[2] >= 3162.125 and origin[2] <= 4550 and origin[3] >= 112 and origin[3] <= 552 then
			et.trap_SendServerCommand(clientNum, "cp \"^1Noob saves here.\n\"")]]
		end
		return false
	end
elseif mapname_lower == "escapejump_b2" then
	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if origin[1] >= -30445.875 and origin[1] <= -27346.125 and origin[2] >= -11181.875 and origin[2] <= -9810.125
		or origin[1] >= -25005.875 and origin[1] <= -23634.125 and origin[2] >= -9325.875  and origin[2] <= -7186.125
		or origin[1] >= -26637.875 and origin[1] <= -25266.125 and origin[2] >= -10093.875 and origin[2] <= -7422.125 and origin[3] >= -1447.875
		or origin[1] >= -31469.875 and origin[1] <= -27954.125 and origin[2] >= -1549.875 and origin[2] <= -114.125 and origin[3] >= 1848.125
		or origin[1] >= -21933.875 and origin[1] <= -20534.125 and origin[2] >= -3501.875 and origin[2] <= -2130.125
		or origin[1] >= -4670 and origin[1] <= -978.125 and origin[2] >= -4381.875 and origin[2] <= -3586.125 and origin[3] >= -1191.875
		or origin[1] >= -9025 and origin[1] <= -4882.125 and origin[2] >= -4381.875 and origin[2] <= -3586.125 and origin[3] >= -1191.875 
		or origin[1] >= -13290 and origin[1] <= -11218.125 and origin[2] >= -5005.875 and origin[2] <= -3250.125 and origin[3] >= -1191.875
		or origin[1] >= -27565.875 and origin[1] <= -24082.125 and origin[2] >= -20570 and origin[2] <= -19505
		or origin[1] > -24082.125 and origin[1] <= -21080 and origin[2] >= -21781.875 and origin[2] <= -18298.125
		or origin[1] >= -25101.875 and origin[1] <= -23666.125 and origin[2] >= -12973.875 and origin[2] <= -9548.125 and origin[3] < -2647.875
		or origin[1] >= -22861.875 and origin[1] <= -21426.125 and origin[2] >= -15629.875 and origin[2] <= -12500 and origin[3] < -2663.875
		or origin[1] >= -21069.875 and origin[1] <= -19634.125 and origin[2] >= -15149.875 and origin[2] <= -12165 and origin[3] < -2663.875
		or origin[1] >= -30637.875 and origin[1] <= -29266.125 and origin[2] >= -22040 and origin[2] <= -19282.125  then
			return true
		else
			return false
		end
	end
elseif mapname_lower == "ewp_gamma2" then
	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if origin[1] > 16173.875 and origin[2] >= 698 and origin[2] <= 1214 and origin[3] > -343
		or origin[1] >= 15210 and origin[1] <= 15300 then
			return true
		else
			return false
		end
	end
elseif mapname_lower == "jh_fun" then
	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if origin[1] >= -5293.875 and origin[1] <= -3770 and origin[2] >= -2637.875 and origin[2] <= -2162.125 and origin[3] >= 2665 then
			return true
		else
			return false
		end
	end
	
	MOD_FALLING = 36
	function ObituaryOnMap(victim, killer, meansOfDeath, playerList)
		if meansOfDeath == MOD_FALLING then
			local origin = et.gentity_get(victim, "origin")
			if origin[1] >= -3000 and origin[1] <= -500 and origin[2] >= -12000 and origin[2] <= -10000 then
				et.gentity_set(victim, "sess.latchPlayerType", et.gentity_get(victim, "sess.playerType"))
				et.gentity_set(victim, "sess.latchPlayerWeapon", et.gentity_get(victim, "sess.playerWeapon"))
				et.gentity_set(victim, "sess.latchPlayerWeapon2", et.gentity_get(victim, "sess.playerWeapon2"))
				playerList[victim].switchto = { origin = { -3872, -10656, 2968.125 }, health = playerList[victim].health, }
			end
		end
	end
	
	PW_INVULNERABLE = 1
	WP_LUGER = 2
	WP_GRENADE_LAUNCHER = 4
	WP_COLT = 7
	WP_GRENADE_PINEAPPLE = 9
	WP_AKIMBO_COLT = 37
	WP_AKIMBO_LUGER = 38
	WP_AKIMBO_SILENCEDCOLT = 47
	WP_AKIMBO_SILENCEDLUGER = 48
	function RunFrameOnMap()
		for i = 0, max_clients - 1 do
			if player_list[i] and player_list[i].sessionTeam < 3 and not player_list[i].loaded then
				local origin = et.gentity_get(i, "origin")
				if player_list[i].finished then
					--if origin[1] >= 13300 and origin[1] <= 13700 and origin[2] > -11726 and origin[2] <= -11500 then
					if not player_list[i].noclipped and origin[1] > 5338 and origin[1] < 6566 and origin[2] > -4494 and origin[2] < -3314 then
						--et.trap_SendConsoleCommand(et.EXEC_NOW, "weaponset " .. i .. " " .. WP_FLAMETHROWER)
						player_list[i].finished = false
						et.trap_SendConsoleCommand(et.EXEC_NOW, "weaponset " .. i .. " " .. WP_LUGER)
						if not player_list[i].usedCheatAdren then
							et.gentity_set(i, "ps.ammoclip", WP_LUGER, 4989)
							if player_list[i].sessionTeam == 2 then
								et.trap_SendConsoleCommand(et.EXEC_NOW, "weaponset " .. i .. " " .. WP_THOMPSON)
								et.gentity_set(i, "ps.ammoclip", WP_THOMPSON, 4989)
								et.trap_SendConsoleCommand(et.EXEC_NOW, "weaponset " .. i .. " " .. WP_MP40)
								et.gentity_set(i, "ps.ammo", WP_MP40, 45245)
								et.trap_SendConsoleCommand(et.EXEC_NOW, "weaponset " .. i .. " " .. WP_GRENADE_PINEAPPLE)
								et.gentity_set(i, "ps.ammo", WP_GRENADE_PINEAPPLE, 45)
								et.trap_SendConsoleCommand(et.EXEC_NOW, "weaponset " .. i .. " " .. WP_GRENADE_LAUNCHER)
								et.gentity_set(i, "ps.ammoclip", WP_GRENADE_LAUNCHER, 45)
								et.trap_SendConsoleCommand(et.EXEC_NOW, "weaponset " .. i .. " " .. WP_AKIMBO_SILENCEDCOLT)
								et.gentity_set(i, "ps.ammoclip", WP_COLT, 4989)
								et.gentity_set(i, "ps.ammoclip", WP_AKIMBO_COLT, 4989)
								et.trap_SendConsoleCommand(et.EXEC_NOW, "weaponset " .. i .. " " .. WP_AKIMBO_SILENCEDLUGER)
								et.gentity_set(i, "ps.ammoclip", WP_LUGER, 45245)
								et.gentity_set(i, "ps.ammoclip", WP_AKIMBO_LUGER, 45245)
							end
						end
					end
				elseif origin[1] > 282 and origin[1] < 678 and origin[2] > 3490 and origin[2] < 3798 then
					player_list[i].finished = true
					local teamName, musicLocation
					if player_list[i].sessionTeam == 1 then
						teamName = "GAMMAJUMPS"
						musicLocation = "sound/music/axis_win.wav"
					else
						teamName = "FUNJUMPS"
						musicLocation = "sound/music/allies_win.wav"
					end
					if player_list[i].noclipped then
						et.trap_SendServerCommand(-1, "cpm \"" .. et.gentity_get(i, "pers.netname") .. "^7 has finished with ^1noclip^7.\n\"")
					else
						if not player_list[i].usedCheatAdren then
							et.trap_SendServerCommand(-1, "cpm \"" .. et.gentity_get(i, "pers.netname") .. "^7 has finished the " .. teamName .. " without Save/Load!\n\"")
							et.trap_SendServerCommand(i, string.format("mu_stop 0"))
							et.trap_SendServerCommand(i, string.format("mu_play %s 0", musicLocation))
							--et.trap_SendServerCommand(i, string.format("mu_fade %f 0", volume))
							--et.G_globalSound(musicLocation)
						else
							et.trap_SendServerCommand(-1, "cpm \"" .. et.gentity_get(i, "pers.netname") .. "^7 has finished the " .. teamName .. " without Save/Load, but used unlimited adrenaline.\n\"")
						end
						et.gentity_set(i, "ps.powerups", PW_INVULNERABLE, INT_MAX)
					end
				end
			end
		end
	end

	et.trap_SendConsoleCommand(et.EXEC_APPEND, "; sv_cvar com_maxfps GE 20;")
	cvars.jh_alliedSaveMaxUPS = 4
	--cvars.jh_saveload = 0
	--cvars.jh_nosaveload = 1
	allied_save_load = false
	allied_no_save_load = true
elseif string.find(mapname_lower, "^jhgamma") then
	cvars.jh_axisSaveMaxUPS = 10
	cvars.jh_saveMaxUPS = 300
	--cvars.jh_saveload = 0
	axis_save_load = false
elseif mapname_lower == "kj" then
	function RunFrameOnMap()
		for i = 0, max_clients - 1 do
			if player_list[i] and player_list[i].sessionTeam == 2 and not player_list[i].loaded and not player_list[i].finished then
				local origin = et.gentity_get(i, "origin")
				if origin[1] > 8594 and origin[1] < 9966 and origin[2] > -4718 and origin[2] < -4360 then
					player_list[i].finished = true
					if player_list[i].usedCheatAdren then
						et.trap_SendServerCommand(-1, "cpm \"" .. et.gentity_get(i, "pers.netname") .. "^7 has finished the ^0funjumps ^7without Save/Load but used unlimited adrenaline.\"")
					else
						et.trap_SendServerCommand(-1, "cpm \"" .. et.gentity_get(i, "pers.netname") .. "^7 has finished the ^0funjumps ^7without Save/Load!\"")
					end
					et.trap_SendServerCommand(i, string.format("mu_stop 0"))
					et.trap_SendServerCommand(i, string.format("mu_play sound/music/allies_win.wav 0"))
				end
			end
		end
	end
	allied_save_load = false
	allied_no_save_load = true
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "; sv_cvar com_maxfps GE 20;")
	cvars.jh_alliedSaveMaxUPS = 10
elseif mapname_lower == "kj3" then
	function ClientSpawnOnMap(clientNum, revived, playerList)
		if revived ~= 1 then
			if playerList[clientNum].playerType == 4 or playerList[clientNum].playerType == 0 then
				et.gentity_set(clientNum, "health", et.gentity_get(clientNum, "ps.stats", STAT_MAX_HEALTH))
				et.gentity_set(clientNum, "ps.powerups", PW_ADRENALINE, INT_MAX)
			else
				et.gentity_set(clientNum, "ps.powerups", PW_NOFATIGUE, INT_MAX)
			end
		end
	end
	for i = 0, max_clients - 1 do
		if player_list[i] and player_list[i].sessionTeam < 3 then
			ClientSpawnOnMap(i, 0, player_list)
		end
	end
elseif mapname_lower == "kj_funjump" then
	function ObituaryOnMap(victim, killer, meansOfDeath, playerList)
		if killer == 1023 then
			return
		end
		
		local function PlayerRestrict()
			et.gentity_set(victim, "sess.latchPlayerType", et.gentity_get(victim, "sess.playerType"))
			et.gentity_set(victim, "sess.latchPlayerWeapon", et.gentity_get(victim, "sess.playerWeapon"))
			et.gentity_set(victim, "sess.latchPlayerWeapon2", et.gentity_get(victim, "sess.playerWeapon2"))
		end
		
		local origin = et.gentity_get(victim, "origin")	
		if killer == 1022 and origin[1] >= -6317.875 and origin[1] <= 5613.875 and origin[2] >= 9234.125 and origin[2] <= 11245.875 then
			PlayerRestrict()
			playerList[victim].switchto = { origin = {6870, 10239.5, 783.125}, health = playerList[victim].health, viewangles = "0 180 0", }
		end
		playerList[victim].onceLoadViewangles = true
	end
elseif mapname_lower == "lnatrickjump_deadly" then
	cvars.jh_saveload = 0
	cvars.jh_loadLimit = 3
elseif mapname_lower == "makamejump-b3" then
	function ObituaryOnMap(victim, killer, meansOfDeath, playerList)
		if killer == 1023 then
			return
		end
		
		local function PlayerRestrict()
			et.gentity_set(victim, "sess.latchPlayerType", et.gentity_get(victim, "sess.playerType"))
			et.gentity_set(victim, "sess.latchPlayerWeapon", et.gentity_get(victim, "sess.playerWeapon"))
			et.gentity_set(victim, "sess.latchPlayerWeapon2", et.gentity_get(victim, "sess.playerWeapon2"))
		end
		
		local origin = et.gentity_get(victim, "origin")	
		if killer == 1022 and origin[1] >= -11901.875 and origin[1] <= -11146.125 and origin[2] >= -8658.125 and origin[2] <= -8493.875 then
			PlayerRestrict()
			playerList[victim].switchto = { origin = {-11862, -4208, 3344.125}, health = playerList[victim].health, viewangles = "0 0 0", }
		end
		playerList[victim].onceLoadViewangles = true
	end
elseif mapname_lower == "mj_b3" then
	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if origin[1] >= 3218 and origin[1] <= 10110 and origin[2] >= -5934 and origin[2] <= 4370 and origin[3] >= -800
		or origin[1] >= -2590 and origin[1] <= 1246 and origin[2] >= -14326 and origin[2] <= -13842 and origin[3] >= -1752 and origin[3] < 1464  then
			return true
		else
			return false
		end
	end
elseif mapname_lower == "nekojump" then
	function ObituaryOnMap(victim, killer, meansOfDeath, playerList)
		if killer == 1023 then
			return
		end
		
		local function PlayerRestrict()
			et.gentity_set(victim, "sess.latchPlayerType", et.gentity_get(victim, "sess.playerType"))
			et.gentity_set(victim, "sess.latchPlayerWeapon", et.gentity_get(victim, "sess.playerWeapon"))
			et.gentity_set(victim, "sess.latchPlayerWeapon2", et.gentity_get(victim, "sess.playerWeapon2"))
		end
		
		local origin = et.gentity_get(victim, "origin")	
		if origin[1] >= 9500 and origin[1] <= 10100 and origin[2] >= 5218.125 and origin[2] <= 5420 then
			PlayerRestrict()
			playerList[victim].switchto = { origin = {9784, 21040, 5088.125}, health = playerList[victim].health, viewangles = "0 -90 0", }
		elseif origin[1] >= 18026.125 and origin[1] <= 18997.875 and origin[2] >= 5218.125 and origin[2] < 6738.125 then
			PlayerRestrict()
			playerList[victim].switchto = { origin = {18480, 20960, 5088.125}, health = playerList[victim].health, viewangles = "0 -90 0", }
		end
		playerList[victim].onceLoadViewangles = true
	end
	cvars.jh_saveload = 0
	cvars.jh_nosaveload = 1
elseif mapname_lower == "nekoglasstower" then
	cvars.jh_saveload = 0
	cvars.jh_loadLimit = 3
elseif mapname_lower == "naturejump4" then
	function RunFrameOnMap()
		for i = 0, max_clients - 1 do
			if player_list[i] and player_list[i] < 3 then
				local origin = et.gentity_get(i, "origin")
				if origin[3] >= -191.875 and origin[3] <= -161.875 then
					if origin[1] >= 4230 and origin[1] <= 4470 and origin[2] >= 5522.125 and origin[2] <= 5610 then
						if origin[1] > 4355 then
							et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setvelocity %d 15 12 600", i))
						else
							et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setvelocity %d 100 20 600", i))
						end
					elseif origin[1] >= 5640 and origin[1] <= 5760 and origin[2] >= 6280 and origin[2] <= 6390 then
						et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setvelocity %d 300 -20 640", i))
					end
				end
			end
		end
	end
elseif mapname_lower == "progressive-tj-b1" then
	function RunFrameOnMap()
 		for i = 0, max_clients - 1 do
			if player_list[i] and player_list[i].sessionTeam == 1 then
				local origin = et.gentity_get(i, "origin")
				
				if not player_list[i].startJumppad and origin[1] >= -40 and origin[1] <= 134 and origin[2] >= -574 and origin[2] <= -220 and origin[3] >= 300 and origin[3] <= 425 then
					player_list[i].startJumppad = true
					et.trap_SendServerCommand(i, "cpm \"^aSkip-pad activated for you at spawn\n\"")
				elseif player_list[i].startJumppad and origin[1] >= 1 and origin[1] <= 65 and origin[2] >= -190 and origin[2] <= -125 and origin[3] >= 48 and origin[3] <= 49 then
					et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setvelocity %d 1 -10 600", i))
				elseif player_list[i].flag2Jumppad and origin[1] >= -4510 and origin[1] <= -4415 and origin[2] >= 1775 and origin[2] <= 1829 and origin[3] >= 656 and origin[3] <= 657 then
					et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setvelocity %d 1 10 550", i))
				elseif not player_list[i].flag2Jumppad and origin[1] >= -7030 and origin[1] <= -6842 and origin[2] >= 3800 and origin[2] <= 4181 and origin[3] >= 240.125 and origin[3] <= 314.125 then
					player_list[i].flag2Jumppad = true
					et.trap_SendServerCommand(i, "cpm \"^2Skip-pad activated for you at spawn\n\"")
				end
			end
		end
	end
elseif mapname_lower == "pushjumpfun_b3" then
	function RunFrameOnMap()
		for i = 0, max_clients - 1 do
			if player_list[i] and player_list[i] < 3 then
				local origin = et.gentity_get(i, "origin")
				
				if origin[1] >= 5568 and origin[1] <= 5709.875 and origin[2] >= 3135 and origin[2] <= 3295 and origin[3] >= 32 and origin[3] <= 50 then
					et.gentity_set(i, "origin", {6000, 3070, 536.125})
					et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("clearvelocity %d", i))
					et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setviewangles %d 0 90 0", i))
				end
			end
		end
	end
elseif mapname_lower == "ralfunpark" then
	saveMaxUPS = 320
	cvars.jh_saveMaxUPS = saveMaxUPS

	for i = 0, max_clients - 1 do
		player_list[i].loadViewangles = true
	end

	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if origin[1] >= -45.875 and origin[1] <= 1309.875 and origin[2] >= -45.875 and origin[2] <= 557.875 and origin[3] <= 33 then
			return false
		end
		return true
	end
elseif mapname_lower == "ralfunpark2" then
	saveMaxUPS = 320
	cvars.jh_saveMaxUPS = saveMaxUPS

	for i = 0, max_clients - 1 do
		player_list[i].loadViewangles = true
	end

	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if origin[1] >= -677.875 and origin[1] <= 677.875 and origin[2] >= -173.875 and origin[2] <= 837.875 and origin[3] <= 33 then
			return false
		end
		return true
	end
elseif mapname_lower == "techfunpark" then
	saveMaxUPS = 380
	cvars.jh_saveMaxUPS = saveMaxUPS

	for i = 0, max_clients - 1 do
		player_list[i].loadViewangles = true
	end

	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if origin[1] >= -1006 and origin[1] <= 494 and origin[2] >= 1042 and origin[2] <= 2542 and origin[3] >= 24 and origin[3] <= 600 then
			return false
		elseif origin[1] >= 17938 and origin[1] <= 19950 and origin[2] >= -10222 and origin[2] <= -9220 and origin[3] >= 536 and origin[3] <= 537 then
			return false
		elseif origin[1] >= 6209 and origin[1] <= 8302 and origin[2] >= -10414 and origin[2] <= -9410 and origin[3] >= 1241 and origin[3] <= 1305 then
			return false
		elseif origin[1] >= -3655 and origin[1] <= -3161 and origin[2] >= 3098 and origin[2] <= 3300 and origin[3] >= 24 and origin[3] <= 90 then
			return false
		elseif origin[1] >= 11401 and origin[1] <= 11895 and origin[2] >= 2514 and origin[2] <= 2740 and origin[3] >= 24 and origin[3] <= 90
		or origin[1] >= -1629.875 and origin[1] <= -1058.125 and origin[2] >= 7714.125 and origin[2] <= 7870 and origin[3] >= 408 and origin[3] <= 409 then
			return false
		elseif origin[1] >= 6962.125 and origin[1] <= 8909.875 and origin[2] >= 7986.125 and origin[2] <= 9165.875 and origin[3] >= 568 and origin[3] <= 570
		and et.gentity_get(clientNum, "sess.playerType") ~= 1 then
			return false
		end
		return true
	end
elseif mapname_lower == "tutorialjump" then
	cvars.jh_saveload = 0
	cvars.jh_nosaveload = 1
elseif mapname_lower == "tutorialjump2" then
	--saveMaxUPS = 160
	--et.trap_Cvar_Set("jh_saveMaxUPS", saveMaxUPS)

	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if (origin[1] >= -1190 and origin[1] <= -1125.875 and origin[2] >= 5114 and origin[2] <= 5200)
		--and not (origin[1] >= -1653.875 and origin[1] <= -1242.125 and origin[2] >= 4922.125 and origin[2] <= 5250 and origin[3] <= 645) then
		or origin[1] >= -2445 and origin[1] < -2125.875 and origin[2] >= -1357.875 and origin[2] <= -994.125 and origin[3] < -200 then
			return true
		end
		return false
	end

	function ObituaryOnMap(victim, killer, meansOfDeath, playerList)
		local MOD_FALLING = 36
		
		if killer == 1023 then
			return
		end
		
		local function PlayerRestrict()
			et.gentity_set(victim, "sess.latchPlayerType", et.gentity_get(victim, "sess.playerType"))
			et.gentity_set(victim, "sess.latchPlayerWeapon", et.gentity_get(victim, "sess.playerWeapon"))
			et.gentity_set(victim, "sess.latchPlayerWeapon2", et.gentity_get(victim, "sess.playerWeapon2"))
		end
		
		local origin = et.gentity_get(victim, "origin")
		if meansOfDeath == MOD_FALLING and origin[1] >= -2125.875 and origin[1] <= -1946.125 and origin[2] >= -1357.875 and origin[2] <= -994.125 and origin[3] < -280 then
			PlayerRestrict()
			playerList[victim].switchto = { origin = {-2000, -1180, -280}, health = playerList[victim].health, viewangles = "0 180 0", }
		end
		playerList[victim].onceLoadViewangles = true
	end
	cvars.jh_saveload = 0
elseif mapname_lower == "xtremetricks_b1" then
	function NoSaveZone(clientNum)
		local origin = et.gentity_get(clientNum, "origin")
		if origin[1] >= 6338.125 and origin[1] <= 9670.125 and origin[2] >= -12605.875 and origin[2] <= -10746.125
		or origin[1] >= 2386.125 and origin[1] <  4362.125 and origin[2] >= -8342.125  and origin[2] <= -6981.875 then
			return true
		else
			return false
		end
	end
end

if gamestate ~= GS_PLAYING then
	et.trap_Cvar_Set("jh_saveMaxUPS", 300)
	et.trap_Cvar_Set("jh_axisSaveMaxUPS", "")
	et.trap_Cvar_Set("jh_alliedSaveMaxUPS", "")
	et.trap_Cvar_Set("b_shove", 80)
	et.trap_Cvar_Set("b_headshot", "0")
	et.trap_Cvar_Set("jh_spawnInvul", "2500")
	et.trap_Cvar_Set("g_cheatAdren", "0")
	maps_nolagging = {"jumpworld", "iceslide_marathon", "dangerseabase", "techfunpark", "snake3", "qdjump", "slide_in_northpole", "wacowmudjump",
		"ral4", "Divinejumps", "hank-island$", --[["kj",]] "FLY-Xtrem-Jump-Final", "45_icejump_pack", "Pommesjumps_b4", "RoeltjE2", "sillyslide", "slojump3", "tinty_jump", 
		"trickmev2", "weejumps", "Dare2Die", "medictrick", "antartica-tj", "jumpnow", "nekoglasstower", "etrejump", "New_Style", "blackjump_beta2", "snake1", "Naturejump", "hankjump1",
		"pushjumpfun", "ralfunpark", "Cryptic_icejump1", "HJ-FunJump", "smallblock", "sacredtrickjump_B1", "Escapejump", "bp-trickjump7", "SmallMap",
		"jhgamma", }
	for key, value in pairs(maps_nolagging) do
		if string.find(mapname_lower, "^" .. string.lower(value)) then
			et.trap_SendConsoleCommand(et.EXEC_APPEND, "; sv_cvar com_maxfps GE 20;")
			et.trap_Cvar_Set("jh_saveMaxUPS", "10")
			break
		end
	end
	maps_save_default_disabled = {"brokendreams", "country_road_jp", "footrace", "piyojump", --[["piyojump2", ]]"smallblock", "xtremetricks", }
	for key, value in pairs(maps_save_default_disabled) do
		if string.find(mapname_lower,  "^" .. value) then
			et.trap_Cvar_Set("jh_saveload", 0)
			break
		end
	end
	maps_without_save = {"45travel_1", "4HN_mixjump", "55th%-Trickjump", "[TANC]CaptureTheFlag", "[TANC]ToiletmanTJ", "Antarctica", "antartica%-tj", "area51_alpha", "b12", "battletj", "bibimaniatrickjump", "blackjump_beta2", "bp%-jumparea", "bp%-trickjump7", "cary003", "cary4", "caryjump",
		"chocojump", "ComputerBot", "dangerplace", "dangerseabase", "dangerzone", --[["darkjumps1",]] "desert_jump", "easy_map", "ei2", "etrejump", "ewp_trickjump", "FPJump", "Fun", "FunJumpsMap%-b3", "fullcrazy%-trainjump%-final", "fun_tennis", "funhouse%-tj",
		"gavinjump", --[["gilius_TJ",]] "gravityjump", "hank%-island", "hankjump[12]", "hankslide[12]",
		"hex%-trickjump", "Hj%-FunJump", "HoT_tj", "house%-of%-horror", "iceslide_marathon", "ihQ%-race", "indy_final", "Joding_Village", "jumpnow", "jumprace", "jumpworld", "jvparkb5", --[["jv%-trainjump", "jv%-trainjump%-v2", ]]"jv_cave", "jvmazejump", "jvsquare",
		"jv_factory", "JVTrickjump", "JVTravel", "JVTravelReload", "JVTrickjumpII", --[["kAmijump1%-v2", ]]--[["kj$",]] "KJ_FUNJUMP", "land_cave_jump", "leapforward", "lnatjhard2", --[["lnatrickjump_deadly",]] "mAkeMeJump%-B3", "maniacmansion", "mmjump", "mypros_trickjump_arena", "naturejump",  "nejijump4",
		--[["nekoglasstower",]] "nekojump[23]?$", "neonjump2", "newbie%-trainjump", "noob", "palejump", "Progressive%-TJ", --[["pharagamma",]] "Pharaosquest%-b1", "projump_final", "pythons_tj", "qdjump", "quakejump",
		"ral$", "ral[2345]", --[["ralfunpark", "ralfunpark2", ]]"raljump", "returnjvjump1", "RoeltjE", "Skatepark_TJ", "snake1", "Snake2", "Snake3", "SoH%-funjump1", "sphinx", "surf_10x_final", "surf_rebbel_ressistance_final_2", "survivaljumpb2", --[["techfunpark",]]
		"tjcity", --[["tj_2006", ]]"tj_league", "Toiletman42", "Toiletmanfinal", "trickjumptemple3", "trickmev2", "towersrace_b6", "tutorialjump", --[["tutorialjump2", ]]"unknown_jump", "vulcan_jump", "wacowjump", "wacowmudjump", "Yavejump_B1", "zero1", }
	local jh_nosaveload = 0
	for key, value in pairs(maps_without_save) do
		if string.find(mapname_lower, "^" .. string.lower(value)) then
			et.trap_Cvar_Set("jh_saveload", 0)
			jh_nosaveload = 1
			break
		end	
	end
	et.trap_Cvar_Set("jh_nosaveload", jh_nosaveload)
	maps_without_nofatigue = {"55th-Trickjump", "battletj", --[["lnatjhard2", "lnatrickjump_deadly",]] "dangerseabase", "DangerZone_v5", "dangerplace", "JVTravel", "JVTravelReload", "ComputerBot_B2", "jumpworld", }
	local jh_nofatigue = 1
	local b_banners = 4
	for key, value in pairs(maps_without_nofatigue) do
		if mapname_lower == string.lower(value) then
			et.trap_Cvar_Set("g_nofatigue", 0)
			jh_nofatigue = 0
			b_banners = 3
			break
		end
	end
	et.trap_Cvar_Set("jh_nofatigue", jh_nofatigue)
	et.trap_Cvar_Set("b_banners", b_banners)
	maps_with_cheatadren = {"Snake4", "fearjumps_B2", "airmaxjumps_final", "speedlimit_b1", "Airwaves_b1", "dinijumps1", "bloodydave1-b3", 
	"fueldump", "railgun", "radar", "goldrush", "oasis", "adlernest", "supply", "frostbite", "bremen_final", "sp_delivery_te", "braundorf_b4", "berserk_te", "mml_minastirith_fp3", 
	"rommel_final", "canyon3", "transmitter", "braundorf_final",
	"LostDimension", "snakejumps", "bounce_b1", "fuckgammas_b4", "et_league", "handbreaker_b1_fixed", "handbreaker2_fixed", "handbreaker4_antefinal", 
	"funjumpsmap-b4", "HTJumps_b2", "FuckThis_b1", "elitejumps_rev", "Magic_Jumps", "slojump3", "WERNERJUMP_FINAL", "Loenajumps_b4", "FLYJumpingRoomB4", "starjumps2", 
	"just_jump_2", "gnou", "Ocean_Jumps_b3", "slackjumps_b1", "fearjumps_PR1", "usemejump", }
	for key, value in pairs(maps_with_cheatadren) do
		if string.lower(mapname) == string.lower(value) then
			et.trap_Cvar_Set("g_cheatAdren", 1)
		end
	end	
	for key, value in pairs(cvars) do
		et.trap_Cvar_Set(key, value)
	end
end

maps_nonading = {"Progressive-TJ-B1", "RoeltjE1", "jh_fun", "jhgamma_b1", "kj" }
for key, value in pairs(maps_nonading) do
	if mapname_lower == string.lower(value) then
		et.trap_Cvar_Set("b_shove", 20)
		INV_BINOCS = 6
		function ClientSpawnOnMap(clientNum, revived, playerList)
			if playerList[clientNum].sessionTeam < 3 and revived < 1 then
				local playerType = et.gentity_get(clientNum, "sess.playerType")

				et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponleave %d  46 19 11  21  12  20 1", clientNum))
				et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("setweaponstate %d 1", clientNum))
				if playerType == 3 then
					--et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("weaponleave %d 12", clientNum))
					et.trap_SendConsoleCommand(et.EXEC_NOW, string.format("clearstatkey %d %d", clientNum, INV_BINOCS))
					--et.gentity_set(clientNum, "ps.stats", STAT_KEYS, clearbit(et.gentity_get(clientNum, "ps.stats", STAT_KEYS), INV_BINOCS + 1))
				end
			end
		end
		for i = 0, max_clients - 1 do
			if player_list[i] and player_list[i].sessionTeam < 3 then
				ClientSpawnOnMap(i, 0, player_list)
			end
		end
		break
	end
end	

et.trap_SendConsoleCommand(et.EXEC_APPEND, "; sv_cvar b_popupTime EQ 0;")
if mapname_lower ~= "sagejumps1_b2" then
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "; sv_cvar com_maxfps LE 125;")
end
