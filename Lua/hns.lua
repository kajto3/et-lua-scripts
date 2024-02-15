-- Hide & Seek --

Modname = 		"HideNSeek"
Version = 		"1.2.8"
Homepage = 		""
Email = 		""

--[[
true = on
false = off
--]]

etpub = true												--is the mod based on etpub?

--[[

Changelog:

v. 1.2.8
Ratio fixes
Added unfreezetime
Added killing streaks (nuke,gunner)

v. 1.2.7
Added revive streaks
Lua cleanup

v. 1.2.6
Added balance

v. 1.2.5
8-02-2013 Creativee -> Improved Security
Added Boom command

--]]

min_level = 					6 							--minimum level needed to use admin commands
pm_level = 						6 							--minimum level needed to use /m
secretpmlevel = 				6 							--minimum level needed to use /mp for noname message

-- Micha!

unfreezetime =					150							--freeze time at match start
															--set it to 0 to disable freeze


-- added balance
ratio_cmd = 					"!ratio"					--admin command to balance (usage: !ratio number) (set it to 0 to disable balance system)
ratiovalue_cmd = 				"!ratiovalue"
put_cmd =						"!putteam"					--!putteam command

--[[
-- added extra healthpoints charge
hp_chargetime = 				2.4							--time in seconds of extra healthpoints (1.2 is like default medic charge)
hp_amount = 					1							--amount of extra healthpoints
--]]

-- revive streaks
-- painkiller: extra healthpoints on time
painkilleramount =				5							--revives needed to enable painkiller (set 0 to disable it)
announcetextpainkiller =		true						--should lua announce the painkiller text?
painkillertext =				"^7has been rewarded with ^1PAINKILLER ^7skill." --text which popup for all players
painkillercharge = 				6							--seconds remaining till extra healthpoints (painkiller)
painkillerhp = 					3							--amount of healthpoints that axis gain in painkiller streak
revivespree1 = 					"sound/misc/rank_up.wav"	--painkiller sound (more hp regeneration)

-- juggernaut: increase maximal healthpoints
juggernautamount =				10							--revives needed to enable juggernaut (set 0 to disable it)
announcetextjugger =			true						--should lua announce the juggernaut text?
juggernauttext =				"^7has been rewarded with ^1JUGGERNAUT ^7skill." --text which popup for all players
juggernauthp = 					200							--value of healthpoints that axis recieve in juggernaut streak
revivespree2 = 					"sound/misc/rank_up.wav"	--juggernaut sound (max hp increase)

--killing streaks
--gunner
killamountthompson =			10							--gunner streak kills (set 0 to disable it)
announcetextthompson = 			true						--should lua announce the gunner text?
killspreetextthompson =			"^7has been rewarded with ^1GUNNER ^7skill." --text which popup for all players
killingspree1 = 				"sound/misc/rank_up.wav"	--gunner streak sound
thompsonbullets = 				30							--ammo amount

--nuke
killamountnuke =				15							--nuke strike kills (set 0 to disable it)
nuke_cmd = 						"!nuke"						--nuke strike command
burn_cmd = 						"burn"						--this should be the shrubbot burn command (without !)
burndamage = 					100							--this is the damage which axis will recieve
burndamagelow = 				40							--this is the damage which axis will recieve on lower healthpoints (less then burndamage)
announcetextnuke =				true						--should lua announce the nuke text?
killspreetextnuke =				"^7has been rewarded with ^1TACTICAL NUKE ^7skill." --text which popup for all players
killingspree2 = 				"sound/misc/rank_up.wav"	--nuke strike sound
nukestrikesound1 = "sound/vo/general/axis/hq_airstrike_b.wav"
nukestrikesound2 = "sound/world/alarm_02.wav"
nukestrikesound3 = "sound/weapons/artillery/artillery_fly_1.wav"
nukestrikesound4 = "sound/weapons/artillery/artillery_expl_2.wav"
nukestrikesound5 = "sound/weapons/flamethrower/flame_pilot.wav"

-- end Micha! adds :)

refereesound = 					"sound/misc/referee.wav"	--referee sound


-------------------------------------------------------------------------------------------------------------------
-----------------END OF CONFIG-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

samplerate = 200
et.MAX_WEAPONS = 50
et.CS_VOTE_STRING = 7
et.CS_PLAYERS = 689
freezetimer = 0
medic_max_hp = 9999
medic_max_hp_axis = 140
votetime = 800
mapblock = 1
AXIS = 1
ALLIES = 2
revivespree = {}
revivespamblock = {}
revivespamblock2 = {}
revivespamblock3 = {}
killspree = {}
gunnerstreak = {}
nukestrike = {}
--


--maps that could be voted with random map vote
randommaptable = {
	{ mapname = "oasis" },
	{ mapname = "radar" },
	{ mapname = "railgun" },
	{ mapname = "goldrush" },
	{ mapname = "battery" },
	{ mapname = "adlernest_hns" },
	{ mapname = "adlernest" },
	{ mapname = "drush_b3" },
	{ mapname = "frostbite" },
	{ mapname = "haunted_mansion" },
	{ mapname = "necrology_b2" },
	{ mapname = "reactor_final" },
	{ mapname = "t_spookyb2" },
	{ mapname = "school" },
	{ mapname = "goldrush-ga" },
	{ mapname = "stonehenge_koth" },
	{ mapname = "supply" },
	{ mapname = "sp_delivery_te" },
	{ mapname = "te_escape2" },
	{ mapname = "tounine_b2" },
	{ mapname = "warbell" },
	{ mapname = "pirates" },
	{ mapname = "et_ice" },
	{ mapname = "et_beach" },
	{ mapname = "caen2" },
	{ mapname = "sp_delivery_te" },
	{ mapname = "falkenstein_sw2" },
	{ mapname = "et_village" },
	{ mapname = "et_mor2_night_final" },
	{ mapname = "karsiah_te2" },
	{ mapname = "resurrection" },
	{ mapname = "mp_communique" },
	{ mapname = "tm_halloween1" },
}
--

--note some got no comments because it aren't weapons
weapons = {
	nil,		--							// 1
	false,		--WP_LUGER,					// 2
	false,		--WP_MP40,					// 3
	false,		--WP_GRENADE_LAUNCHER,		// 4
	false,		--WP_PANZERFAUST,			// 5
	false,		--WP_FLAMETHROWER,			// 6
	true,		--WP_COLT,					// 7	// equivalent american weapon to german luger
	true,		--WP_THOMPSON,				// 8	// equivalent american weapon to german mp40
	true,		--WP_GRENADE_PINEAPPLE,		// 9
	false,		--WP_STEN,					// 10	// silenced sten sub-machinegun
	true,		--WP_MEDIC_SYRINGE,			// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	true,		--WP_AMMO,					// 12	// JPW NERVE likewise
	false,		--WP_ARTY,					// 13
	false,		--WP_SILENCER,				// 14	// used to be sp5
	false,		--WP_DYNAMITE,				// 15
	nil,		--							// 16
	nil,		--							// 17
	nil,		--							// 18
	true,		--WP_MEDKIT,				// 19
	true,		--WP_BINOCULARS,			// 20
	nil,		--							// 21
	nil,		--							// 22
	false,		--WP_KAR98,					// 23	// WolfXP weapons
	false,		--WP_CARBINE,				// 24
	false,		--WP_GARAND,				// 25
	false,		--WP_LANDMINE,				// 26
	false,		--WP_SATCHEL,				// 27
	false,		--WP_SATCHEL_DET,			// 28
	nil,		--							// 29
	true,		--WP_SMOKE_BOMB,			// 30
	false,		--WP_MOBILE_MG42,			// 31
	false,		--WP_K43,					// 32
	false,		--WP_FG42,					// 33
	nil,		--							// 34
	false,		--WP_MORTAR,				// 35
	nil,		--							// 36
	false,		--WP_AKIMBO_COLT,			// 37
	false,		--WP_AKIMBO_LUGER,			// 38
	nil,		--							// 39
	nil,		--							// 40
	false,		--WP_SILENCED_COLT,			// 41
	false,		--WP_GARAND_SCOPE,			// 42
	false,		--WP_K43_SCOPE,				// 43
	false,		--WP_FG42SCOPE,				// 44
	false,		--WP_MORTAR_SET,			// 45
	false,		--WP_MEDIC_ADRENALINE,		// 46
	false,		--WP_AKIMBO_SILENCEDCOLT,	// 47
	false		--WP_AKIMBO_SILENCEDLUGER,	// 48
}


function et_InitGame(levelTime,randomSeed,restart)

	et.RegisterModname(Modname .. " " .. Version)
	
	gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )   --gets the maxclients

	pos1 = {}
	-------//--------------------Balance----------------------------
	counta = 0
	countb = 0
	playercountready = 0
	-------//-----------------Streaks-------------------------
	for i = 0, maxclients - 1 do
		revivespree[i] = 0
		revivespamblock[i] = 0
		revivespamblock2[i] = 0
		revivespamblock3[i] = 0
		killspree[i] = 0
		nukestrike[i] = 0
		nukestrikecount = 0
		gunnerstreak[i] = 0
	end
	----------------------------------------------------------------
			
	if et.trap_Cvar_Get( "g_gametype" ) ~= "5" then
		et.trap_Cvar_Set( "g_gametype", "5" ) 
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "ref maprestart\n" ) 
	end
	if gamestate == 0 and unfreezetime > 1 then	
		freezetimer = 1
	end
	
	et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref speclock\n" )
end


-- called every server frame
function et_RunFrame( levelTime )
if math.mod(levelTime, samplerate) ~= 0 then return end

	-------//--------------------Countplayer---------------------------
	ratioindex = tonumber(et.trap_Cvar_Get( "g_ratio" ))
	
	counta = 0
	countb = 0
	for cno=0, maxclients-1, 1 do
		if checkteam(cno) == AXIS then	
			counta = counta + 1
		elseif checkteam(cno) == ALLIES then
			countb = countb + 1
		end
	end

	-------//--------------------Vote timer---------------------------
	votetime = votetime + 1
	rvotetime = math.floor((1000 - votetime) /5)
	if rvotetime ~= nil and rvotetime <= 0 then
		mapblock = 0
	end

	-------//--------------------Start freeze---------------------------
	if freezetimer == 1 then
		for j = 0, maxclients - 1 do
			if checkteam(j) == 2 then
				et.trap_SendConsoleCommand( et.EXEC_APPEND, "freeze "..j.."\n" )
			end
		end
	end	
	--[[ --unused
	if freezetimer == 10 or freezetimer == 50 or freezetimer == 90 or freezetimer == 130 or freezetimer == 170 or freezetimer == 210 then
		et.trap_SendServerCommand(-1 , "" )
	end
	--]]
	if freezetimer == unfreezetime then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "unfreeze\n" )	
		freezetimer = 0	
	end
	if freezetimer > 0 then
		freezetimer = freezetimer + 1
	end
	-------//--------------------Weapon Ammo---------------------------
   -- for all clients
   for j = 0, (maxclients - 1) do
      for k=1, (et.MAX_WEAPONS - 1), 1 do
        if not weapons[k] then
            et.gentity_set(j, "ps.ammoclip", k, 0)
            et.gentity_set(j, "ps.ammo", k, 0)
            et.gentity_set(j, "ps.ammo", 7, 500)
			et.gentity_set(j, "ps.ammo",11,500)
			et.gentity_set(j, "ps.ammoclip",11,500)
			--et.gentity_set(j, "ps.powerups", 12, levelTime + 10000 )
			et.gentity_set(j, "ps.powerups", 12, 1 )
			--et.gentity_set(client,"sess.spec_invite",team)  
			et.gentity_set(j,"sess.spec_invite",2) 
			if checkteam(j) == ALLIES then
				et.gentity_set(j, "ps.stats", 4, medic_max_hp-1078)
				et.gentity_set(j, "ps.ammoclip", 1, 1)
				et.gentity_set(j, "ps.ammo", 1, 1)
			end
			-------//--------------------Gunner Streak---------------------------
			et.gentity_set(j, "ps.ammo",8,0)
			if gunnerstreak[j] == 0 then
				et.gentity_set(j, "ps.ammoclip",8,0)
			elseif gunnerstreak[j] == 1 then
				et.gentity_set(j, "ps.ammoclip",8,thompsonbullets)
				gunnerstreak[j] = 2
			end
				--[[
				-------//--------------------Anti Gib---------------------------
				if checkteam(j) == AXIS then
					local hp = tonumber(et.gentity_get(j,"health"))
					if hp <= 0 then
						et.gentity_set(j, "ps.powerups", 1, levelTime + 9999999 )
					end
					if hp >= 0 then
						et.gentity_set(j, "ps.powerups", 1, 0 )
					end
				end--]]
        end
	end
	end
	-------//----------------Nuke Strike----------------------
	for cno = 0, (maxclients - 1) do
		if nukestrike[cno] == 2 and gamestate ~= 3 then
			nukestrikecount = nukestrikecount + 1
			if nukestrikecount == 2 then
				et.G_globalSound ( nukestrikesound2 )
			elseif nukestrikecount == 15 then	--15 50
				et.G_globalSound ( nukestrikesound3 )
			elseif nukestrikecount == 19 then	--19 75
				et.G_globalSound ( nukestrikesound4 )
			elseif nukestrikecount == 24 then	--24 94
				et.G_globalSound ( nukestrikesound5 )
			elseif nukestrikecount >= 24 then	--24 94
				for j = 0, (maxclients - 1) do
					if checkteam(j) == AXIS then
						et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..burn_cmd.." "..j.." \n" ) --used for visual
						local newhp = (tonumber(et.gentity_get(j,"health") - burndamage))
						local newhplow = (tonumber(et.gentity_get(j,"health") - burndamagelow))
						local hp = (tonumber(et.gentity_get(j,"health")))
						if hp < 1 then 
							nukestrike[cno] = 3
						elseif hp < burndamage then
							et.gentity_set(j, "health", newhplow)
							nukestrike[cno] = 3
						elseif hp >= burndamage then
							et.gentity_set(j, "health", newhp)
							nukestrike[cno] = 3
						end
					end
				end
			end
		end
	end
	-------//----------------Extra heal Allies----------------------
	for cno = 0, (maxclients - 1) do
		if checkteam(cno) == ALLIES then
			SetMaxHP(cno)
		end
	end
	-------//-------------Extra heal on time Axis--------------------
	--[[
    if math.mod(levelTime, (hp_chargetime*1000)) ~= 0 then return end --every x:1000 second
 	for cno = 0, (maxclients - 1) do
		if checkteam(cno) == AXIS then
			local hp = (tonumber(et.gentity_get(cno,"health")))
			local ghp = (tonumber(et.gentity_get(cno,"health")) + hp_amount )
			if hp < 1 then 
				return
			elseif hp < medic_max_hp_axis then
				et.gentity_set(cno, "health", ghp)
			end
		end
	end
	--]]
	-------//-----------------Revive Streak-------------------------
	for cno = 0, (maxclients - 1) do
		if revivespree[cno] >= painkilleramount and revivespamblock[cno] == 0 and painkilleramount > 0 then
			if announcetextpainkiller then
				et.trap_SendServerCommand( -1,"chat \""..playerName(cno).." "..painkillertext.." ^m(^w"..revivespree[cno].."^m) ^7revives!\"")
			end
			et.trap_SendServerCommand(cno, "cpm \"^3You will gain ^1+"..painkillerhp.." ^3healthpoints every ^1"..painkillercharge.." ^3second.\"" )
			if etpub then
				et.G_ClientSound(cno, et.G_SoundIndex(revivespree1) ) --reward sound (Plays the sound revivespree1 for the client with cno only.)
			else
				et.G_Sound(cno, et.G_SoundIndex(revivespree1) ) --reward sound
			end
			revivespamblock[cno] = 1
		elseif revivespree[cno] >= juggernautamount and revivespamblock2[cno] == 0 and juggernautamount > 0 then
			if announcetextjugger then
				et.trap_SendServerCommand( -1,"chat \""..playerName(cno).." "..juggernauttext.." ^m(^w"..revivespree[cno].."^m) ^7revives!\"")
			end
			et.trap_SendServerCommand(cno, "cpm \"^3Maximum healthpoints set to ^1"..juggernauthp.."^3.\"" )
			if etpub then
				et.G_ClientSound(cno, et.G_SoundIndex(revivespree1) ) --reward sound (Plays the sound revivespree1 for the client with cno only.)
			else
				et.G_Sound(cno, et.G_SoundIndex(revivespree2) ) --reward sound
			end
			revivespamblock2[cno] = 1
		end
		--et.trap_SendServerCommand( cno,"chat \"^3"..playerName(cno).." ^7Debug ^1(^w"..revivespree[cno].."^1) ^7revives. Block: "..revivespamblock[cno].." \"") --Debug line revive streak
		if checkteam(cno) == AXIS then
			local hp = (tonumber(et.gentity_get(cno,"health")))
			local ghp = (tonumber(et.gentity_get(cno,"health")) + painkilleramount )
			if hp < 1 then 
				return
			end
			if revivespamblock2[cno] == 1 and revivespamblock3[cno] == 0 then
				et.gentity_set(cno, "ps.stats", 4,(juggernauthp - 21))
				et.gentity_set(cno, "health", (juggernauthp - 21))
				revivespamblock3[cno] = 1
			end
			if math.mod(levelTime, (painkillercharge*1000)) ~= 0 then return end --every x:1000 second
			if revivespamblock[cno] == 1 then
				if hp < medic_max_hp_axis and revivespamblock2[cno] == 0 then
					et.gentity_set(cno, "health", ghp)
				elseif hp < juggernauthp and revivespamblock2[cno] == 1 then
					et.gentity_set(cno, "health", ghp)
				end
			end
		end
	end
	-------//-------------------------------------------------------
 end --end runframe


function et_ClientCommand(client, command)
local argv0 = string.lower(et.trap_Argv(0))
local argv1 = string.lower(et.trap_Argv(1))
local arg1 = et.trap_Argv(1)
local arg2 = et.trap_Argv(2)
local cmd = string.lower(command)
local gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))

	-------//--------------------Balance----------------------------
	if string.find(argv1, "^" .. ratio_cmd .. "") and getlevel(client) == true then
		et.trap_Cvar_Set( "g_ratio", tonumber(arg2) )
		et.trap_SendServerCommand( -1 , "chat \"^3BALANCE^7: ^7Ratio set to ^1("..et.trap_Cvar_Get( "g_ratio")..")^7.\"" )
	end
	
	if string.find(argv1, "^" .. ratiovalue_cmd .. "") then
		if et.trap_Cvar_Get( "g_ratio") == nil or et.trap_Cvar_Get( "g_ratio") == "" then
			et.trap_Cvar_Set( "g_ratio", tonumber(3) )
			et.trap_SendServerCommand( client , "chat \"^3BALANCE^7: ^7Ratio is ^1("..et.trap_Cvar_Get( "g_ratio")..")^7.\"" )
		else
			et.trap_SendServerCommand( client , "chat \"^3BALANCE^7: ^7Ratio is ^1("..et.trap_Cvar_Get( "g_ratio")..")^7.\"" )
		end
	end
	
	if countb >= 1 then
		teamindex = (countb + countb) + 1
	else
		teamindex = countb
	end
	local byte = string.byte(argv1,1)
	
	if cmd == "team" or cmd == "nextteam" then
		if string.len(argv1) > 1 then
			et.trap_SendServerCommand( client , "print \"Invalid team join command.\n\"" )
			return 1
		end
        if argv1 ~= "" and byte ~= 98 and byte ~= 114 and byte ~= 115 then 
			et.trap_SendServerCommand( client , "print \"Invalid team join command.\n\"" )
		return 1
		end
		
		local ratioindex = tonumber(et.trap_Cvar_Get( "g_ratio" ))
		
		if argv1 == "b" and ratioindex > 0 then
			if checkteam(client) == ALLIES then return end
			if checkteam(client) == AXIS then 
				--if (teamindex + 2) > counta then
				if (teamindex + ratioindex - 1) > counta then
					et.trap_SendServerCommand( client , "chat \"^3BADBALANCE^7: ^7You may not switch teams.\"" )
					return 1 	
				end
			end		 
			if teamindex > counta then
				et.trap_SendServerCommand( client , "chat \"^3BADBALANCE^7: ^3Allied ^7team locked, you have been moved to ^3Axis ^7team.\"" )
				et.gentity_set(client,"sess.latchPlayerType",1)
				if gamestate ~= 0 then 
					--et.gentity_set(client,"sess.sessionTeam",AXIS)	--etpro methode
					--et.gentity_set(client,"health",-1000)	--etpro methode
					et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..put_cmd.." " .. client .. " r" )  					
					return 1
				end
				et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..put_cmd.." " .. client .. " r" )  	
				--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref putaxis " .. client .. "\n" )  --etpro methode 
				return 1   -- prevents the teamjoin
			end
		end
		
		--[[ --disabled because it seems useless to lock axis in hide&seek
		if argv1 == "r" and ratioindex > 0 then
			if checkteam(client) == AXIS then return end
			if checkteam(client) == ALLIES then 
				--if (teamindex - 2) < counta then
				if (teamindex - ratioindex + 1) > counta then
					et.trap_SendServerCommand( client , "chat \"^3BADBALANCE^7: ^7You may not switch teams.\"" )
					return 1
				end 	
			end	
			if teamindex < counta then
				et.trap_SendServerCommand( client , "chat \"^3BADBALANCE^7: ^3Axis ^7team locked, you have been moved to ^3Allied ^7team.\"" )
				et.gentity_set(client,"sess.latchPlayerType",1)
				if gamestate ~= 0 then 
					--et.gentity_set(client,"sess.sessionTeam",ALLIES)
					--et.gentity_set(client,"health",-1000)	
					et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..put_cmd.." " .. client .. " b" )					
					return 1
				end
				--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref putallies " .. client .. "\n" )
				et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..put_cmd.." " .. client .. " b" )	
				return 1   -- prevents the teamjoin
			end
		end
		--]]
	end --close team
	
	if string.lower(command) == "callvote" then
		teamindex2 = countb * ratioindex
		if argv1 == "startmatch" then
			countPlayers()
			if playercountready > 5 and gamestate == 2 and ratioindex > 0 then 
				if teamindex2 > counta then
					et.trap_SendServerCommand( client , "chat \"^3STARTMATCH^7: Bad balance^7, ^1"..ratioindex.." ^3Axis ^7on ^11 ^3Allied ^7player needed.\"" )
					return 1
				end
			end
			playercountready = 0
		end
	end
	
	if string.lower(command) == "ready" or string.lower(command) == "readyteam" or string.lower(command) == "imready" then
		countPlayers()
		if playercountready > 5 and gamestate == 2 and ratioindex > 0 then
			if teamindex2 > counta then
				et.trap_SendServerCommand( client , "chat \"^3STARTMATCH^7: Bad balance^7, ^1"..ratioindex.." ^3Axis ^7on ^11 ^3Allied ^7player needed.\"" )
				return 1
			end
		end
		playercountready = 0
	end
	
	-------//-----------------Map vote-------------------------
	if argv1 == "map" and gamestate == 2 and mapblock == 1 then
		et.trap_SendServerCommand(client, "chat \"^3MAPVOTE: ^7Disabled ^7for another ^3"..rvotetime.." ^7seconds after mapchange!\"")
		return 1
	end

	-------//-----------------Boom command-------------------------
	if cmd == "boom" and getlevel(client) then
		et.G_AddEvent( client, 90, 1)
		return 1
	end
	
	-------//-----------------Randommap command-------------------------
	local isref = et.Info_ValueForKey( et.trap_GetConfigstring( et.CS_PLAYERS + client ), "ref" )
	if cmd == "randommap" and isref ~= "0" then
		et.G_globalSound ( refereesound )
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "map " .. randommap() .. "\n" )
		et.G_Print("Random Map\n")
		return 1
	end
	-------//-----------------Ragequit command-------------------------
	if cmd == "rq" or cmd == "ragequit" then
		et.trap_SendServerCommand( -1, "chat \"^7"..playerName(client).." ^7ragequit^1!!!\"" )
		et.trap_DropClient( client, "Good bye!", 0 )
		return 1
	end        
 
	-------//-----------------Save/Load command-------------------------
	if gamestate ~= 0 and cmd == "save" then
		save(client)
		return 1
	end
	if gamestate ~= 0 and cmd == "load" then
		load(client)
		return 1
	end
	if gamestate == 0 then
		if cmd =="save" or cmd =="load" then
			et.trap_SendServerCommand(client,"cp \"^?Y^7ou can not ^1/save ^7or ^1/load ^7while being in a match.\"")
			return 1
		end
	end
	-------//-----------------Private message system-------------------------
	if et.G_shrubbot_level(client) >= secretpmlevel then
		if cmd == "mp" then
			if et.trap_Argc() > 1 then
				-- build message
				local message = ""
				for i = 1, et.trap_Argc() - 1, 1 do
					message = message .. et.trap_Argv(i) .. " "
				end
				-- send message to all other admins
				local playerNum = getPlayerId(et.trap_Argv(1))
				if message == "" or message == nil then return end
				sendstring = " ^m(^wAdmin^m)^w: " .. message
				et.trap_SendServerCommand(playerNum, "chat \"" .. sendstring .. "\"")
				et.trap_SendServerCommand(client, "chat \"^mLUA: ^wPrivate Message sent\"")
			end
			return 1
		end
	end
	-------//-----------------Block commands-------------------------
	if string.lower(command) == "lock" then
		et.trap_SendServerCommand( client, "cpm \"^1Lock has been disabled.\n\"" )
		return 1
	end
	if string.lower(command) == "ignore" then
		et.trap_SendServerCommand( client, "cpm \"^1Ignore has been disabled.\n\"" )
		return 1
	end
	if string.lower(command) == "m" and et.G_shrubbot_level(client) < pm_level then
		et.trap_SendServerCommand( client, "cpm \"^1Private message has been disabled.\n\"" )
		return 1
	end
	if string.lower(command) == "playdead" then
		et.trap_SendServerCommand( client, "cpm \"^1Playdead has been disabled.\n\"" )
		return 1
	end
	-------//-----------------Mute-------------------------
	if string.lower(command) == "m" or string.lower(command) == "pm" or string.lower(command) == "msg" then -- private message
		if checkmuted(client) == 1 then -- client is muted
			return 1 -- abort PM
		end
	end
	-------//-----------------Nuke Strike-------------------------
 	if string.find(argv1, "^" .. nuke_cmd .. "") then
		if nukestrike[client] == 1 then
			if checkteam(client) == ALLIES then
				nukestrikecount = 0
				et.trap_SendServerCommand(-1, "chat \"^3"..Modname..": ^7"..playerName(client).." ^7used his ^1nuke strike^7!\"" )
				nukestrike[client] = 2
				et.G_Sound( client, et.G_SoundIndex(nukestrikesound1) )
				return 1
			elseif checkteam(client) == AXIS then
				et.trap_SendServerCommand(client, "cpm \"^3Warning: ^7You can't nuke your own team!\"" )
				return 1
			elseif checkteam(client) == 3 then
				et.trap_SendServerCommand(client, "cpm \"^3Warning: ^7You can't use nuke as spectator!\"" )
				return 1
			end
		else
			et.trap_SendServerCommand(client, "chat \"^3"..Modname..": ^7You don't have any nuke strikes left!\"" )
			return 1
		end
	end
	 
return 0
end


function et_Obituary( victim, killer, meansofdeath )
	-------//-----------------Streaks-------------------------
	if meansofdeath then
		revivespree[victim] = 0 --reset the revive spree if the person dies
		revivespamblock[victim] = 0 --block the announce spam of revive spree PAINKILLER
		revivespamblock2[victim] = 0 --block the announce spam of revive spree JUGGERNAUT
		revivespamblock3[victim] = 0
		killspree[victim] = 0 --reset the killing spree if the person dies
		gunnerstreak[victim] = 0
		nukestrike[victim] = 0
	end
	-------//-------------------------------------------------------
		
		soundindex = et.G_SoundIndex("sound/player/gib.wav" )
		soundindex2 = et.G_SoundIndex("sound/player/gasp.wav" )
		if meansofdeath == 6 then
		 if checkteam(victim) == ALLIES then
			if checkteam(killer) == AXIS then
				et.gentity_set(victim, "health", 100)
				et.G_Sound(killer, soundindex )
				et.G_Sound(victim, soundindex2 )
				et.trap_SendServerCommand( killer,"")
				et.gentity_set(killer, "health", -200)
			end
		end
	end	 
	if meansofdeath == 1 then
		et.gentity_set(victim, "health", 100)
		et.gentity_set(killer, "health", -200)
		et.G_Sound(killer, soundindex )
		et.G_Sound(victim, soundindex2 )
    end
	
	-------//-----------------Kill Streak-------------------------
	if meansofdeath == 6 or meansofdeath == 8 or meansofdeath == 10 or meansofdeath == 58 or meansofdeath == 68 then
		if killer ~= 1022 and killer ~= 1023 and meansofdeath ~= 37 and meansofdeath ~= 64 and checkteam(killer) == ALLIES then -- no world / unknown kills / selfkill / team switch
			killspree[killer] = killspree[killer] + 1 -- count +1
		end
		-------//-----------------Nuke Strike-------------------------
		if killspree[killer] == killamountnuke and nukestrike[killer] == 0 and killamountnuke > 0 then
			if announcetextnuke then
				et.trap_SendServerCommand( -1,"chat \""..playerName(killer).." "..killspreetextnuke.." ^m(^w"..killspree[killer].."^m) ^7kills!!!\"")
			end
			et.trap_SendServerCommand(killer, "bp \"^3Use nuke wisely this round: ^1!nuke\"" )
			et.trap_SendServerCommand(killer, "cpm \"^3Use nuke wisely this round: ^1!nuke\"" )
			et.trap_SendServerCommand(killer, "chat \"^3Use nuke wisely this round: ^1!nuke\"" )
			et.trap_Cvar_Set( "g_dmgFlamer", 10 )
			nukestrike[killer] = 1
			if etpub then
				et.G_ClientSound(killer, et.G_SoundIndex(killingspree2) ) --reward sound
			else
				et.G_Sound(killer, et.G_SoundIndex(killingspree2) ) --reward sound
			end
		end
		-------//-----------------Gunner Streak-------------------------
		if killspree[killer] == killamountthompson and gunnerstreak[killer] == 0 and killamountthompson > 0 then
			if announcetextthompson then
				et.trap_SendServerCommand( -1,"chat \""..playerName(killer).." "..killspreetextthompson.." ^m(^w"..killspree[killer].."^m) ^7kills!!!\"")
			end
			et.trap_SendServerCommand(killer, "bp \"^1"..thompsonbullets.." ^3ammo added to ^1Thompson\"" )
			et.trap_SendServerCommand(killer, "cpm \"^1"..thompsonbullets.." ^3ammo added to ^1Thompson\"" )
			et.trap_SendServerCommand(killer, "chat \"^1"..thompsonbullets.." ^3ammo added to ^1Thompson\"" )
			gunnerstreak[killer] = 1
			if etpub then
				et.G_ClientSound(killer, et.G_SoundIndex(killingspree1) ) --reward sound
			else
				et.G_Sound(killer, et.G_SoundIndex(killingspree1) ) --reward sound
			end
		end
	end
end

function et_ClientSpawn(cno,revived)
	if revived ~= 1 and revivespamblock2[cno] == 0 then
		et.gentity_set(cno, "ps.stats", 4, medic_max_hp_axis-6)
	end
end

function et_ClientDisconnect(cno) 
	revivespree[cno] = 0
	revivespamblock[cno] = 0
	revivespamblock2[cno] = 0
	revivespamblock3[cno] = 0
	killspree[cno] = 0
end

function et_Print(text) 
	local t = ParseString(text)
	if t[2] == "Passed:" and t[3] == "[poll]" and string.lower(t[4]) == "random" and string.lower(t[5]) == "map" then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "map " .. randommap() .. "\n" )
		et.G_Print("Random Map\n")
	end
	
	-------//-----------------Revive Streak-------------------------
	local junk1,junk2,medic,zombie = string.find(text, 
                                            "^Medic_Revive:%s+(%d+)%s+(%d+)")
    if medic ~= nil and zombie ~= nil then
        medic  = tonumber(medic)
        zombie = tonumber(zombie)
		if et.gentity_get(zombie, "enemy") == medic then -- tk&revive
			return
		else -- not a tk&revive
			revivespree[medic] = revivespree[medic] + 1
		end
	end
end


-------//--------------------Helper functions---------------------------

function checkmuted(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client)
	return tonumber(et.Info_ValueForKey(cs, "mu"))
end
function checkteam(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client)
	return tonumber(et.Info_ValueForKey(cs, "t"))
end

function SetMaxHP(target)
	local hp = tonumber(et.gentity_get(target,"health"))
	  if hp > medic_max_hp then return end
 		if hp > 0 and hp < medic_max_hp then
			et.gentity_set(target, "health", medic_max_hp)
		end
end

function getlevel(client)
	local lvl = et.G_shrubbot_level(client)
	if lvl >= min_level then
		return true
	end
		return nil
end

function playerName(id) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(id), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end


function save(client)
    if checkteam(client) ~= 3 then
    	pos1[client] = et.gentity_get(client,"origin")
    	et.trap_SendServerCommand(client, "cp \"^?S^7aved\"" )
	elseif checkteam(client) == 3 then
    	pos1[client] = et.gentity_get(client,"s.origin")
    	et.trap_SendServerCommand(client, "cp \"^?S^7aved\"" )
    end
end

function load(client)
	if pos1[client] == nil then
		et.trap_SendServerCommand( client, "cpm \"^?U^7se ^1/save ^7first.\"" )
		et.trap_SendServerCommand( client, "cp \"^?U^7se ^1/save ^7first.\"" )
		return 1
	end
	if checkteam(client) ~= 3 then
		et.gentity_set(client,"origin",pos1[client])
		et.trap_SendServerCommand( client, "cp \"^?L^7oaded\"" )
	elseif checkteam(client) == 3 then
		et.trap_SendServerCommand(client,"cp \"^?Y^7ou can not ^1/load ^7as a spectator.\"")
	end
end

--old function
function randommap()
	local random = string.lower(randommaptable[math.random(table.getn(randommaptable))].mapname)
	return random
end

function ParseString(inputString)
	local i = 1
	local t = {}
	for w in string.gfind(inputString, "([^%s]+)%s*") do
		t[i]=w
		i=i+1
	end
	return t
 end

function getCS()
	local cs = et.trap_GetConfigstring(et.CS_VOTE_STRING)
	local t = ParseString(cs)
	return t[3]
end

function getPlayerId(name, clientID)
    local i
    -- if it's nil, return nil and throw error
    if (name == "") then
        printmsg("Not enough parameters.", clientID)
        return nil
    end
    -- if it's a number, interpret as slot number
    local clientnum = tonumber(name)
    if clientnum then
        if (clientnum <= tonumber(et.trap_Cvar_Get("sv_maxclients"))) and et.gentity_get(clientnum,"inuse") then
            return clientnum
        else
            printmsg("Slot "..clientnum.." not in use.", clientID)
            return nil
        end
    end
    -- exact match first
    for i=0,et.trap_Cvar_Get("sv_maxclients"),1 do
      playeri = playerName(i)
        if playeri then
            if et.Q_CleanStr( playeri ) == et.Q_CleanStr( name ) then
                return i
            end
        end
    end
    -- partial match
    for i=0,et.trap_Cvar_Get("sv_maxclients"),1 do
       playeri = playerName(i)
        if playeri then
            if (string.find(string.lower(et.Q_CleanStr( playeri )), string.lower(et.Q_CleanStr( name )), 1, true)) then
                return i
            end
        end
    end
    printmsg("No name match found for '"..name.."'.", clientID)
    return nil
end

function countPlayers()
	for i=0, maxclients-1, 1 do
		if checkteam(i) == AXIS or checkteam(i) == ALLIES then
			if et.gentity_get(i,"inuse") then		
			playercountready = playercountready + 1
			end
		end
   	end
end