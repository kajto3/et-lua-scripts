Version = 	2.2
Author  =   "^7Perl^do_0^7ung^d?!"
Description = "^yH^7ide^D&^7Seek^7"
Homepage = "^7www^1.^7ef-clan^1.^7org"

-------------global vars----------------
et.MAX_WEAPONS = 50
samplerate = 200
rechargerate = 30
et.CS_PLAYERS = 689
et.CS_VOTE_STRING = 7
et.CS_MULTI_MAPWINNER = 14
medic_max_hp = 150
----------------------------------------


weapons = {
	false,	--// 1
	false,	--WP_LUGER,				// 2
	false,	--WP_MP40,				// 3
	false,	--WP_GRENADE_LAUNCHER,	// 4
	false,	--WP_PANZERFAUST,		// 5
	false,	--WP_FLAMETHROWER,		// 6
	true,	--WP_COLT,				// 7	// equivalent american weapon to german luger
	false,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	false,	--WP_GRENADE_PINEAPPLE,	// 9
	false,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	true,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	false,	--WP_AMMO,				// 12	// JPW NERVE likewise
	false,	--WP_ARTY,				// 13
	false,	--WP_SILENCER,			// 14	// used to be sp5
	false,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	true,	--WP_MEDKIT,			// 19
	false,	--WP_BINOCULARS,		// 20
	nil,	--// 21
	nil,	--// 22
	false,	--WP_KAR98,				// 23	// WolfXP weapons
	false,	--WP_CARBINE,			// 24
	false,	--WP_GARAND,			// 25
	false,	--WP_LANDMINE,			// 26
	false,	--WP_SATCHEL,			// 27
	false,	--WP_SATCHEL_DET,		// 28
	nil,	--// 29
	false,	--WP_SMOKE_BOMB,		// 30
	false,	--WP_MOBILE_MG42,		// 31
	false,	--WP_K43,				// 32
	false,	--WP_FG42,				// 33
	nil,	--// 34
	false,	--WP_MORTAR,			// 35
	nil,	--// 36
	false,	--WP_AKIMBO_COLT,		// 37
	false,	--WP_AKIMBO_LUGER,		// 38
	nil,	--// 39
	nil,	--// 40
	false,	--WP_SILENCED_COLT,		// 41
	false,	--WP_GARAND_SCOPE,		// 42
	false,	--WP_K43_SCOPE,			// 43
	false,	--WP_FG42SCOPE,			// 44
	false,	--WP_MORTAR_SET,		// 45
	true,	--WP_MEDIC_ADRENALINE,	// 46
	false,	--WP_AKIMBO_SILENCEDCOLT,// 47
	false	--WP_AKIMBO_SILENCEDLUGER,// 48
}

map_table = {
	{ map = "supply", type=0, },
	{ map = "library_b2", type=0, },
	{ map = "adlernest_hns", type=1, },
	{ map = "oasis", type=1, },
	{ map = "odenthal_b2", type=1, },
	{ map = "radar", type=1, },
	{ map = "tc_base", type=0, },
	{ map = "et_beach", type=1, },
	{ map = "frostbite", type=0, },
	{ map = "sp_delivery_te", type=0, },
	{ map = "adlernest", type=0, },
	{ map = "bremen_b2", type=1, },
	{ map = "braundorf_b4", type=0, },
	{ map = "et_ice", type=1, },
	{ map = "goldrush-ga", type=1, },
	{ map = "railgun", type=1, },
	{ map = "dubrovnik_final", type=1, },
	{ map = "sw_battery", type=1, },
	{ map = "1944_beach", type=1, },
	{ map = "caen2", type=1, },
	{ map = "venice", type=1, },
	{ map = "coast_b1", type=1, },
	{ map = "Haemar_a11", type=0, },
	{ map = "et_mor_pro", type=1, },
	{ map = "vio_grail", type=1, },
	{ map = "frost_final", type=0, },
	{ map = "missile_b2", type=1, },
	{ map = "rommel_final", type=1, },
	{ map = "et_village", type=1, },
	{ map = "el_kef_final", type=1, },
	{ map = "axislab_final", type=1, },
	{ map = "reactor_final", type=0, },
	{ map = "sos_secret_weapon", type=0, },
	{ map = "sottevast_b3", type=0, },
	{ map = "townsquare_final", type=1, },
	{ map = "fueldump", type=1, },
	{ map = "pirates_b4", type=1, },
	{ map = "bergen", type=1, },
	{ map = "rhineland_bridge_4", type=1, },
	{ map = "tounine_b1", type=0, },
	{ map = "base12_b6", type=0, },
	{ map = "mp_sub_rc1", type=1, },
	{ map = "base", type=0, },
}

-- if et.trap_Cvar_Get( "net_ip" )  ~= "188.40.49.145" then return 1 end



function et_InitGame(levelTime,randomSeed,restart)
	mclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
	gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
   	mapname = et.trap_Cvar_Get( "mapname" ) 
	et.G_Print("[Hidenseek] Version:2.2 Loaded\n")
   	et.RegisterModname("H&S by Perlo_0ung!?")
    count = {}
	pos = {}
	rpos = {}
	knspree = {}
	postimer = 0
	watertimer = 0
	waittimer = 0
	votetimer = 1
	counta = 0
	countb = 0
	playercountready = 0
	removeentity = 5
	timecounter = 0
         for cno = 0, mclients - 1 do
        	count[cno] = 1 
         	knspree[cno] = 0  
	  end
	if gamestate == 0 then	
		waittimer = 1
	end
	nextmap(0)
end

function et_ClientSpawn(cno,revived)
	teamnum = et.gentity_get(cno, "sess.sessionTeam")
	pos[cno] = et.gentity_get(cno, "origin")
	if revived == 1 then           
		et.gentity_set(cno, "ps.stats", 4,(medic_max_hp-19))
    	elseif revived == 0 then
		count[cno] = 1	
		et.gentity_set(cno, "ps.stats", 4,(medic_max_hp-19))
		et.gentity_set(cno, "health", medic_max_hp)
	end
	if teamnum == 1 then
		pos1 = et.gentity_get(cno, "origin")
	elseif teamnum == 2 then
		pos2 = et.gentity_get(cno, "origin")
		et.gentity_set(cno, "health", 500)
		et.gentity_set(cno, "ps.stats", 4, 600)
	end
	for i=1,(et.MAX_WEAPONS-1),1 do
	    if not weapons[i] then
  	if teamnum == 1 then
		 et.gentity_set(cno, "ps.ammoclip",i,0)
		 et.gentity_set(cno, "ps.ammo",i,0)
   		 et.gentity_set(cno, "ps.ammoclip",11,150)
   		 et.gentity_set(cno, "ps.ammo",11,150)
	elseif teamnum == 2 then
 		 et.gentity_set(cno, "ps.ammoclip",i,0)
		 et.gentity_set(cno, "ps.ammo",i,0)
			end	
		end
	end
end


function et_RunFrame( levelTime )

	ratioindex = 1

	for cno = 0, (mclients - 1) do
	InvincibleAttacked(cno)
	AntiGib(cno)	
	if waittimer > 0 then
		if et.gentity_get(cno, "sess.sessionTeam") == 2 then
		et.gentity_set(cno,"ps.powerups", 14, 3000000)
		end
	   end
	end
	
	
if math.mod(levelTime, samplerate) ~= 0 then return end
-------//------------------nextmapbrokecheck---------------------
	nBeginn, nEnde = string.find(tostring(et.trap_Cvar_Get( "nextmap" )), "map")
	if nBeginn ~= 1 or nEnde ~= 3 then
		nextmap(0)
	end

-------//------------------remove hp/ammoracks/mg42----------------
	timecounter = timecounter + 1
	if removeentity > 0 then		
		if mapname == "adlernest_hns" then -- remove ea.h8ter clips
			et.trap_UnlinkEntity( 302 ) 
			et.trap_UnlinkEntity( 303 ) 
			et.trap_UnlinkEntity( 304 )
			et.trap_UnlinkEntity( 305 )
			et.trap_UnlinkEntity( 306 ) 
			et.trap_UnlinkEntity( 307 ) 
		end
		for i = 64, 1021 do
		if mapname == "odenthal_b2" then
			if et.gentity_get(i, "targetname") == "sideentrance" then --remove sideentrance odenthal_b2 @ e8
				et.trap_UnlinkEntity( i ) 
			end
		end
   		if et.gentity_get(i, "classname") == "misc_mg42" then
				et.trap_UnlinkEntity( i )
			end
		if et.gentity_get(i, "classname") == "trigger_ammo" or et.gentity_get(i, "classname") == "trigger_heal" then  
			et.trap_UnlinkEntity( i ) 
		end
	    end
	   removeentity = removeentity - 1
	end
-------//--------------------votetimer----------------------------
	if votetimer > 0 then
		votetimer = votetimer + 1
	end
	if votetimer == 100 then
		votetimer = 0 
	end
-------//--------------------Watertimer----------------------------
	if watertimer > 0 and watertimer < 25 then 
		watertimer = watertimer + 1
	elseif watertimer == 25 then	
		watertimer = 0
	end
-------//--------------------Blackscreentimer----------------------
	if waittimer > 0 then
		waittimer = waittimer + 1
	end
	if waittimer == 25 or waittimer == 50 or waittimer == 75 or waittimer == 100  then
		local seconds = (((125 - waittimer )*200) / 1000 )
		et.trap_SendServerCommand(-1, "chat \"^3BLACKSCREENTIMER^7: ^1"..seconds.." ^7seconds until ^3Allied team^7 may move. \n\"" )
		for cno=0, mclients-1, 1 do
			SetWaitPos(cno)
		end
	elseif waittimer == 110 then 
		local threesec = "sound/misc/three.wav" 
		et.G_globalSound( threesec )
	elseif waittimer == 115 then
		local twosec = "sound/misc/two.wav" 		
		et.G_globalSound( twosec )
	elseif waittimer == 120 then
		local onesec = "sound/misc/one.wav" 
		et.G_globalSound( onesec )
	elseif waittimer == 125 then
		et.G_globalSound( "sound/etpro/osp_fight.wav" )
		et.trap_SendServerCommand(-1, "cp \"^3ALLIED TEAM MAY MOVE NOW \n\"" )
		et.trap_SendServerCommand(-1, "chat \"^3BLACKSCREENTIMER^7: ^7DISABLED ^3//// ^7Allied team may move now. \n\"" )
		for cno=0, mclients-1, 1 do
		SetWaitPos(cno)
	if et.gentity_get(cno, "sess.sessionTeam") == 3 and gamestate == 0 then
			et.gentity_set(cno, "sess.spec_invite",2) 
			end
		end
		waittimer = 0
	end
-------//--------------------RechargeHP----------------------------
	if timecounter == rechargerate then
  	    for cno = 0, (mclients - 1) do
			SetMaxHP(cno)
			timecounter = 0
		end
	end
-------//--------------------Countplayer---------------------------
	counta = 0
	countb = 0
	for cno=0, mclients-1, 1 do
	teamnum = et.gentity_get(cno, "sess.sessionTeam")
		if teamnum == 1 then	
			counta = counta + 1
		elseif teamnum == 2 then
			countb = countb + 1
		end
	end
-------//--------------------MoveoutofWater------------------------
	for cno=0, mclients-1, 1 do
	water = et.gentity_get(cno, "waterlevel")
	team = et.gentity_get(cno, "sess.sessionTeam")
	wname = et.gentity_get(cno, "pers.netname")
		if water > 1 then
		if et.gentity_get(cno,"health") <= 0 then
		if team == 1 then
			if watertimer == 0 then
				et.trap_SendServerCommand(-1, "chat \"^3BAYWATCH^7: "..wname.."^7's body has been ^3moved out of water\n\"" )
				et.gentity_set(cno, "origin", pos1)
				watertimer = 1
			end
		elseif team== 2 then
			if watertimer == 0 then
				et.trap_SendServerCommand(-1, "chat \"^3BAYWATCH^7: "..wname.."^7's body has been ^3moved out of water\n\"" )
				et.gentity_set(cno, "origin", pos2)
				watertimer = 1
			end
			end
		end
	end
end
-------//--------------------Weapon/Stamina------------------------
	for cno=0, mclients-1, 1 do
		for k=1, (et.MAX_WEAPONS - 1), 1 do
	    	if not weapons[k] then
	teamnum = et.gentity_get(cno, "sess.sessionTeam")
			if teamnum == 1 then
				et.gentity_set(cno, "ps.ammoclip", k, 0)
				et.gentity_set(cno, "ps.ammo", k, 0)
   				et.gentity_set(cno, "ps.ammo",11,150)
   				et.gentity_set(cno, "ps.ammoclip",11,150)
				et.gentity_set(cno, "ps.powerups", 12, et.trap_Milliseconds() + samplerate + 50)
		elseif teamnum == 2 then
				et.gentity_set(cno, "ps.ammoclip", k, 0)
				et.gentity_set(cno, "ps.ammo", k, 0)
				et.gentity_set(cno, "ps.ammo", 7, 150)
				et.gentity_set(cno, "ps.powerups", 12, et.trap_Milliseconds() + samplerate + 50) 
				end
			end		
		end	
	end
-------//--------------------Announce Nextmap-----------------------
	if math.mod(levelTime, 60000) ~= 0 or tonumber(et.trap_Cvar_Get( "g_currentRound" )) == 0 then return end   
		nextmap(1)
 end


function et_ClientCommand(clientNum, command)
	teamindex = (countb + countb) + 1
	teamindex2 = countb * ratioindex
	arg1 = string.lower(et.trap_Argv(1)) 
	arg2 = string.lower(et.trap_Argv(2)) 
	local team = et.gentity_get(clientNum, "sess.sessionTeam")
	local byte = string.byte(arg1,1)
	if string.lower(command) == "ref" then
		if arg1 == "map" then 
			if tonumber(arg2) > 0 and tonumber(arg2) <= table.getn(map_table) then
			local execute = 1 
			table.foreach(map_table, function(k,v)
					if execute == 1 then
						et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref map " .. map_table[tonumber(arg2)].map .. "\n" )
						execute = 0
					end
  				end) 
				return 1
			end
		end
	end
	if string.lower(command) == "team" then
	 if string.len(arg1) > 1 then
			et.trap_SendServerCommand( clientNum , "print \"Invalid team join command.\n\"" )
			return 1
	end
        if arg1 ~= "" and byte ~= 98 and byte ~= 114 and byte ~= 115 then 
			et.trap_SendServerCommand( clientNum , "print \"Invalid team join command.\n\"" )
		return 1
	end
	if arg1 == "b" then
	if team == 2 then return end
	if team == 1 then 
        if (teamindex + 2 ) > counta then
			et.trap_SendServerCommand( clientNum , "chat \"^3BADBALANCE^7: ^7You may not switch teams.\n\"" )
			PlayClientSound(clientNum)
	    return 1 	
	 end
	end		 
       if teamindex > counta then
			et.trap_SendServerCommand( clientNum , "chat \"^3BADBALANCE^7: ^3Allied ^7team locked, you have been moved to ^3Axis ^7team.\n\"" )
			et.gentity_set(clientNum,"sess.latchPlayerType",1)
			if gamestate ~= 0 then 
				et.gentity_set(clientNum,"sess.sessionTeam",1)
				et.gentity_set(clientNum,"health",-1000)				
				return 1
			end
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref putaxis " .. clientNum .. "\n" )
			PlayClientSound(clientNum)        
            return 1   -- prevents the teamjoin
          end
         end
	if arg1 == "r" then
	if team == 1 then return end
	if team == 2 then 
        if (teamindex - 2) < counta then
			et.trap_SendServerCommand( clientNum , "chat \"^3BADBALANCE^7: ^7You may not switch teams.\n\"" )
			PlayClientSound(clientNum)
	   return 1
	  end 	
	end	
	   if teamindex < counta then
			et.trap_SendServerCommand( clientNum , "chat \"^3BADBALANCE^7: ^3Axis ^7team locked, you have been moved to ^3Allied ^7team.\n\"" )
			et.gentity_set(clientNum,"sess.latchPlayerType",1)
			if gamestate ~= 0 then 
				et.gentity_set(clientNum,"sess.sessionTeam",2)
				et.gentity_set(clientNum,"health",-1000)		
				return 1
			end
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref putallies " .. clientNum .. "\n" )
			PlayClientSound(clientNum)        
            return 1   -- prevents the teamjoin
          end
         end
	if arg1 == "s" or arg1 == "spectator" then
		et.gentity_set(clientNum, "sess.spec_invite",2)
		return 0
	   end 
	end
  if string.lower(command) == "callvote" then
	if arg1 == "nextmap" then
		nextmap(1)
	    end
	if arg1 == "startmatch" then
	for i=0, mclients-1, 1 do
		countPlayers(i)
	end
	if playercountready > 5 and gamestate == 2 then 
		if teamindex2 > counta then
			et.trap_SendServerCommand( clientNum , "chat \"^3STARTMATCH^7: Bad balance^7, ^1"..ratioindex.." ^3Axis ^7on ^11 ^3Allied ^7player needed.\n\"" )
			return 1
  		  end
 		end
	   playercountready = 0
	end
	if arg1 == "map" then
		if votetimer > 0 then 
			local rvotetime = math.floor((100 - votetimer) /5)
			et.trap_SendServerCommand(clientNum, "chat \"^3MAPVOTE: ^7Disabled ^7for another ^3"..rvotetime.." ^7seconds after mapchange!\n\" " )
	  		return 1
		end
		for _, line in ipairs(map_table) do
			if arg2 == line.map then
				if line.type == 1 then
					countPlayers()
					if playercountready < 10 then
       		 			et.trap_SendServerCommand(clientNum, "chat \"^3MAPVOTE: ^7At least ^310 ^7players needed to vote for big maps!\n\"" )
						playercountready = 0
						return 1
					end
		  		  end

			   end
		   end
	   end
     end
  if string.lower(command) == "ready" or string.lower(command) == "readyteam" or string.lower(command) == "imready" then
	countPlayers()
	if playercountready > 5 and gamestate == 2 then
		if teamindex2 > counta then
			et.trap_SendServerCommand( clientNum , "chat \"^3STARTMATCH^7: Bad balance^7, ^1"..ratioindex.." ^3Axis ^7on ^11 ^3Allied ^7player needed.\n\"" )
	return 1
   end
 end
 playercountready = 0
end
  if string.lower(command) == "maps" then
   et.trap_SendServerCommand(clientNum, string.format("print \"^3 MAPID    ^3MAPNAME               ^3SIZE \n"))
   et.trap_SendServerCommand(clientNum, string.format("print \"^1---------------------------------------------\n"))
	table.foreach(map_table, function(k,v)
		local size = { "Small" , "Big", }
		local type = (tonumber(map_table[k].type) +1 )
		local mapname = tonumber(string.len(map_table[k].map))-1
      		local namespa = 20 - mapname
		local space = string.rep( " ", namespa)
    		et.trap_SendServerCommand(clientNum, string.format('print "  ^7%2s      %s%s %s\n"',k, map_table[k].map, space, size[type]))
		end) 
	return 1
  end
--if string.lower(command) == "wtf234" then
--	et.gentity_set(clientNum,"ps.powerups", 9, 1000) -- medic
--	et.gentity_set(clientNum,"ps.powerups", 8, 1000) -- disguise me
--	return 1
--	end
  if string.lower(command) == "boom234" then
		et.G_AddEvent( clientNum, 84, 1)
	return 1
	end
  if string.lower(command) == "rpos" then
	for i=0, mclients-1, 1 do
		RevivePos(clientNum,i)
	end
	table.sort(rpos)
	if rpos[1] == nil then
	 et.trap_SendServerCommand(clientNum, "chat \"^3REVIVEME: ^7No person to revive near u!\n\"" )
	else
   	 et.trap_SendServerCommand(clientNum, "chat \"^3REVIVEME: ^7Next person to revive in ^1"..rpos[1].."m ^7near u!\n\"" )
	end--
	rpos = {}
	return 1
  end
  if string.lower(command) == "kill" then
	if gamestate == 0 then
	  et.trap_SendServerCommand( clientNum, "cp \"^1Sorry, selfkilling is disabled on this server.\n\"" )
    return 1
  end
end
  if string.lower(command) == "tapout" then
	et.gentity_set(clientNum, "health", -5000)
	return 1
  end
  if string.lower(command) == "forcetapout" then
	if gamestate == 0 then
	 et.trap_SendServerCommand( clientNum, "cp \"^1Sorry, outtapping is disabled on this server.\n\"" )
   return 1
  end
end
  if string.lower(command) == "lock" then
	  et.trap_SendServerCommand( clientNum, "cpm \"^1Sorry, this command is disabled on this server.\n\"" )
    return 1
  end
  if string.lower(command) == "specunlock" then
	  et.trap_SendServerCommand( clientNum, "cpm \"^1Sorry, this command is disabled on this server.\n\"" )
    return 1
  end
     return 0   -- allows the cmd
 end


function et_ClientDisconnect(cno) 
	count[cno] = 0
	knspree[cno] = 0
end

function et_ClientBegin(cno)
	et.gentity_set(cno,"sess.latchPlayerType",1)
	et.trap_SendServerCommand(cno, "cpm \"^1Welcome to ^7e^yL^7emen^yT^1'^yH^7ide^D&^7Seek^7!! ^7This server runs ^3changed mapscripts ^7please visit\n\"")
	et.trap_SendServerCommand(cno, "cpm \"^7www^y.^7ef-clan^y.^7org for additional informations\n\"")
	et.trap_SendServerCommand(cno, "cpm \""..Description.." ^1[^7LUA^1] ^7powered by "..Author.." ^7visit "..Homepage.." \n\"" )
	if et.gentity_get(cno, "sess.sessionTeam") == 3 then
		local name = et.gentity_get(cno,"pers.netname") 
		et.gentity_set(cno, "sess.spec_invite",2) 
		et.trap_SendServerCommand(cno, "cp \"^7Welcome to ^7e^yL^7emen^yT^1'^yH^7ide^D&^7Seek\n\"" )
	end
end

function et_ConsoleCommand()
        if et.trap_Argv(0) == "playsound" then
                if et.trap_Argc() ~= 3 then
                        PlaySoundHelp()
                else
                        et.G_globalSound(et.trap_Argv(2));
                end
                return 1
        end

        if et.trap_Argv(0) == "playsound_env" then
                if et.trap_Argc() ~= 3 then
                        PlaySoundEnvHelp()
                else
                        soundindex = et.G_SoundIndex( et.trap_Argv(2) )
                        et.G_Sound( et.trap_Argv(1) , soundindex )
                end
                return 1
        end

        return 0
end

function et_Obituary( victim, killer, mod )
if gamestate ~= 0 then return end
if killer == 1022 then return end
	et.trap_SendServerCommand(victim, "chat \"^7That's enough!? ^7Use ^3/tapout^7 to end it all!\n\"" )
	local kname = playerName(killer) 
	local vo = et.gentity_get(victim, "r.currentOrigin")
 	local vteam = et.gentity_get(victim, "sess.sessionTeam")
 	local kteam = et.gentity_get(killer, "sess.sessionTeam")
	if mod == 24 then
	   if vteam == kteam then
		et.G_Damage(killer, victim, victim, 1000, 32, 35)
		et.trap_SendServerCommand(killer, "chat \"^3GIBBED^7: Teammate killing by pushing is ^1not allowed. \n\"" )
	    end
	end
	if mod == 6 then
	   if vteam == kteam then return end
		knspree[killer] = knspree[killer] +1
		if math.mod(knspree[killer], 5) == 0 then
			et.trap_SendServerCommand(-1 , "chat \"^7"..kname.." ^8acting like ^7Jack the Ripper! ^8(^7"..knspree[killer].." ^8knife kills)\n\"" )
			et.G_globalSound( "sound/misc/humiliation.wav"  )
		end
	end
end

function et_Print(text)
	local t = ParseString(text)  --Vote Passed: Change map to suppLY
	if t[2] == "Passed:" and t[4] == "map" then
		if tonumber(t[6]) > 0 and tonumber(t[6]) <= table.getn(map_table) then
			if t[6] ~= getCS() then return 1 end
				local dummy = tonumber(t[6])
				local execute = 1
					table.foreach(map_table, function(k,v) 
						if execute == 1 then
							et.trap_SendConsoleCommand( et.EXEC_APPEND, "map " .. map_table[dummy].map .. "\n" )
							execute = 0
						end
  					end) 
		end 
	if string.find(t[6],"%u") == nil or t[6] ~= getCS() then return 1 end
		local mapfixed = string.lower(t[6])
		for _, line in ipairs(map_table) do
			if mapfixed == line.map then 
			et.trap_SendServerCommand(-1, "chat \"^3VOTECHECK^7: Invalid mapvote ^1"..t[6].." ^7called. Loading map ^1"..mapfixed.." ^7instead.\n\"" )
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref map " .. mapfixed .. "\n" )
			end
		end
	end
end    
    

--------------------------HELPER FUNCTIONS------------------------------------------------------------------

function SetMaxHP(target)
	local hp = tonumber(et.gentity_get(target,"health"))
	local team = et.gentity_get(target, "sess.sessionTeam")
	if team == 2 then
		if hp <= 0 then return end 
 			et.gentity_set(target, "health", 500)
			et.gentity_set(target, "ps.stats", 4, 600)
	end
end




function countPlayers()
for i=0, mclients-1, 1 do
	local teamnum = et.gentity_get(i, "sess.sessionTeam")
		if teamnum == 1 or teamnum == 2 then
			if et.gentity_get(i,"inuse") then		
			playercountready = playercountready + 1
			end
		end
   	end
end

function PlayClientSound(clientNum)
	local soundindex = et.G_SoundIndex("sound/menu/cancel.wav")
	local tempentity = et.G_TempEntity(et.gentity_get(clientNum, "r.currentOrigin"), 54)
	et.gentity_set(tempentity, "s.teamNum", clientNum)
	et.gentity_set(tempentity, "s.eventParm", soundindex)
end

function PlaySoundHelp()
        et.G_Print("playsound -1 plays a sound that everybody on the server can hear\n");
        et.G_Print("usage: playsound -1 path_to_sound.wav\n");
end

function PlaySoundEnvHelp()
        et.G_Print("playsound_env plays a sound that you can hear in the proximity of the player with slot -playerslot-\n");
        et.G_Print("usage: playsound_env playerslot path_to_sound.wav\n");
end

function AntiGib(target)
	local hp = tonumber(et.gentity_get(target,"health"))
	local contents = et.gentity_get(target, "r.contents")
	if hp <= 0 and contents ~= 0 then
	et.gentity_set(target, "ps.powerups", 1, 200 )
	end
end

	
function InvincibleAttacked(target)
	if gamestate == 0 then	
	local attacker = et.gentity_get(target, "ps.persistant", 5)
	local teamnum = tonumber(et.gentity_get(target, "sess.sessionTeam"))
	if target ~= attacker and teamnum == 2 then
      if (attacker >= 0) and (attacker < 64) then
 	if et.gentity_get(target, "health") > 0 then 
		if et.gentity_get(attacker,"inuse") then
	et.gentity_set(target, "health", 500)
	et.gentity_set(target, "ps.persistant", 5, 1022)
		end
	  end
	end
  end
 end
end

function playerName(id) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(id), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end

function RevivePos(caller,id)
	if caller == id then return 1 end
	if et.gentity_get(id, "sess.sessionTeam") ~= 1 or et.gentity_get(caller, "sess.sessionTeam") ~= 1 then return 1 end
	if et.gentity_get(id, "health") <= 0 and et.gentity_get(id, "r.contents") ~= 0 then
	local callerpos = et.gentity_get(caller,"r.currentOrigin")
	local idpos = et.gentity_get(id,"r.currentOrigin")
	distance = dist(callerpos,idpos)
	table.insert(rpos,distance)
	end
end
	

function dist(a ,b)
   local dx = math.abs(b[1] - a[1])
   local dy = math.abs(b[2] - a[2])
   local dz = math.abs(b[3] - a[3])
   local d = math.sqrt((dx ^ 2) + (dy ^ 2) + (dz ^ 2))
   return math.floor(d / 52.4934)
end 

function nextmap(announce)
	countPlayers()
	table.foreach(map_table, function(k,v)
		if playercountready < 10 then
			if mapname == v.map then
				if k == table.getn(map_table) then
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "nextmap \"map "..map_table[1].map.."\n\"" )
					if announce == 1 then
						et.trap_SendServerCommand(-1, "chat \"^1[^7Next Map: ^1"..map_table[1].map.."]\n\"" )
					end
					return 1
				end	
				if map_table[k+1].type == 1 then
					repeat 
						if k == table.getn(map_table) then k = 1 break end
			 			k = k + 1
					until map_table[k].type == 0 
						et.trap_SendConsoleCommand( et.EXEC_APPEND, "nextmap \"map "..map_table[k].map.."\n\"" )
					if announce == 1 then
						et.trap_SendServerCommand(-1, "chat \"^1[^7Next Map: ^1"..map_table[k].map.."]\n\"" )
					end
				else
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "nextmap \"map "..map_table[k+1].map.."\n\"" )
					if announce == 1 then
						et.trap_SendServerCommand(-1, "chat \"^1[^7Next Map: ^1"..map_table[k+1].map.."]\n\"" )
					end
				end
			end
		elseif playercountready > 10 then
    		 	if mapname == v.map then
	  			if k == table.getn(map_table) then k = 0 end
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "nextmap \"map "..map_table[k+1].map.."\n\"" )
					if announce == 1 then
		        			et.trap_SendServerCommand(-1, "chat \"^1[^7Next Map: ^1"..map_table[k+1].map.."]\n\"" )
					end
          		end
   	  	end
  	end)
	playercountready = 0
end


function SetWaitPos(target)
	if et.gentity_get(target, "sess.sessionTeam") == 2 then
		et.gentity_set(target, "origin", pos[target])
	end
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
	return t[4]
end
------------------------------------------END HELPER FUNCTIONS----------------------------------------------------------