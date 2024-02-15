Version = 	1.5
Author  =   "Perlo_0ung?!"
Description = "LUGERWAR"
Homepage = "www.ef-clan.org"

--global vars
et.MAX_WEAPONS = 50
samplerate = 200
vtime = 1500
min_vote_time = 300    

--

--note sme got no comment thats becase it arent weapons
weapons = {
	nil,	--// 1
	true,	--WP_LUGER,				// 2
	false,	--WP_MP40,				// 3
	false,	--WP_GRENADE_LAUNCHER,	// 4
	false,	--WP_PANZERFAUST,		// 5
	false,	--WP_FLAMETHROWER,		// 6
	true,	--WP_COLT,				// 7	// equivalent american weapon to german luger
	false,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	false,	--WP_GRENADE_PINEAPPLE,	// 9
	false,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	false,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	true,	--WP_AMMO,				// 12	// JPW NERVE likewise
	true,	--WP_ARTY,				// 13
	false,	--WP_SILENCER,			// 14	// used to be sp5
	true,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	false,	--WP_MEDKIT,			// 19
	true,	--WP_BINOCULARS,		// 20
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
	false,	--WP_MEDIC_ADRENALINE,	// 46
	false,	--WP_AKIMBO_SILENCEDCOLT,// 47
	false	--WP_AKIMBO_SILENCEDLUGER,// 48
}

sweapons = {
	nil,	--// 1
	false,	--WP_LUGER,				// 2
	false,	--WP_MP40,				// 3
	false,	--WP_GRENADE_LAUNCHER,	// 4
	false,	--WP_PANZERFAUST,		// 5
	false,	--WP_FLAMETHROWER,		// 6
	false,	--WP_COLT,				// 7	// equivalent american weapon to german luger
	false,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	false,	--WP_GRENADE_PINEAPPLE,	// 9
	true,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	false,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	true,	--WP_AMMO,				// 12	// JPW NERVE likewise
	true,	--WP_ARTY,				// 13
	false,	--WP_SILENCER,			// 14	// used to be sp5
	true,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	false,	--WP_MEDKIT,			// 19
	true,	--WP_BINOCULARS,		// 20
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
	false,	--WP_MEDIC_ADRENALINE,	// 46
	false,	--WP_AKIMBO_SILENCEDCOLT,// 47
	false	--WP_AKIMBO_SILENCEDLUGER,// 48
}
kweapons = {
	nil,	--// 1
	false,	--WP_LUGER,				// 2
	false,	--WP_MP40,				// 3
	false,	--WP_GRENADE_LAUNCHER,	// 4
	false,	--WP_PANZERFAUST,		// 5
	false,	--WP_FLAMETHROWER,		// 6
	false,	--WP_COLT,				// 7	// equivalent american weapon to german luger
	false,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	false,	--WP_GRENADE_PINEAPPLE,	// 9
	false,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	false,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	true,	--WP_AMMO,				// 12	// JPW NERVE likewise
	true,	--WP_ARTY,				// 13
	false,	--WP_SILENCER,			// 14	// used to be sp5
	true,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	false,	--WP_MEDKIT,			// 19
	true,	--WP_BINOCULARS,		// 20
	nil,	--// 21
	nil,	--// 22
	true,	--WP_KAR98,				// 23	// WolfXP weapons
	true,	--WP_CARBINE,			// 24
	true,	--WP_GARAND,			// 25
	false,	--WP_LANDMINE,			// 26
	false,	--WP_SATCHEL,			// 27
	false,	--WP_SATCHEL_DET,		// 28
	nil,	--// 29
	false,	--WP_SMOKE_BOMB,		// 30
	false,	--WP_MOBILE_MG42,		// 31
	true,	--WP_K43,				// 32
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
	false,	--WP_MEDIC_ADRENALINE,	// 46
	false,	--WP_AKIMBO_SILENCEDCOLT,// 47
	false	--WP_AKIMBO_SILENCEDLUGER,// 48
}
function tobits( number )
   
   -- bits array
   local bits = { }

    -- let's get some bits
   while( number > 0 ) do
   
      -- bit value (reversed)
      table.insert( bits, math.mod( number, 2 ) )
      
      -- divide
      number = math.floor( number / 2 )
   end

   return bits
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

function et_InitGame(levelTime,randomSeed,restart)
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )	--gets the maxclients
	gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
	et.G_Print("[Lugerwar] Version:1.2 Loaded\n")
   	et.RegisterModname("Lugerwar by Perlo_0ung!?")
	et.trap_SendServerCommand(-1, "chat \"^1Welcome to ^7e^yL^7emen^yT^1'^73 ^yH^7ead^ys^7hot^7!! ^7This server runs ^3changed mapscripts ^7please visit ^7www^y.^7ef-clan^y.^7org for additional informations and check command map 4 new spawnpoints\n\"" )
		count = {}
		ammocount = {}
		hp = {}
		voteon = 0
		voteoff = 0
		vcount1 = 0
		vcount2 = 0
		svoteon = 0
		svoteoff = 0
		svcount1 = 0
		svcount2 = 0
		kvoteon = 0
		kvoteoff = 0
		kvcount1 = 0
		kvcount2 = 0
		mcount = 0
			for i = 0, maxclients - 1 do
			count[i] = 0
			ammocount[i] = 5
	end
	if gamestate == 0 then
	if tonumber(et.trap_Cvar_Get( "g_luger" )) == 1 or tonumber(et.trap_Cvar_Get( "g_k43" )) == 1 or tonumber(et.trap_Cvar_Get( "g_sten" )) == 1 then
	et.trap_SendServerCommand( -1 , "chat \"^7FUNWAR voting has been ^1disabled ^7for 5 minutes!\n\"" )
	voteon = 1
	end
    end	
end

function et_ClientSpawn(client,revived)
	count[client] = 0
	hp[client] = tonumber(et.gentity_get(client, "health"))
	luger = tonumber(et.trap_Cvar_Get( "g_luger" )) 
	for i=1,(et.MAX_WEAPONS-1),1 do
	    if not weapons[i] then
		if luger == 1 then
			et.gentity_set(client,"ps.ammoclip",i,0)
			et.gentity_set(client,"ps.ammo",i,0)
			et.gentity_set(client, "ps.ammo", 7, 150)
			et.gentity_set(client, "ps.ammo", 2, 150)
		elseif luger == 0 then
			et.gentity_set(client,"ps.ammoclip",3,30)
			et.gentity_set(client,"ps.ammo",3,30)
			et.gentity_set(client,"ps.ammoclip",8,30)
			et.gentity_set(client,"ps.ammo",8,30)
		end
		end
	end
end

-- called every server frame
function et_RunFrame( levelTime )

 	luger = tonumber(et.trap_Cvar_Get( "g_luger" )) 
	if math.mod(levelTime, samplerate) ~= 0 then return end
	if sten == 1 then
	for j = 0, (maxclients - 1) do
		et.gentity_set(j,"sess.latchPlayerWeapon", 10)
		end
	end
	if k43 == 1 then
	for j = 0, (maxclients - 1) do
	teamnum = et.gentity_get(j,"sess.sessionTeam")
	weapon = et.gentity_get(j,"sess.latchPlayerWeapon")
	if teamnum == 1 then
		et.gentity_set(j,"sess.latchPlayerWeapon", 23)
	elseif teamnum == 2 then
		et.gentity_set(j,"sess.latchPlayerWeapon", 24)
		end
	if weapon == 3 or weapon == 8 then
			et.gentity_set(j, "health", -200)
			et.trap_SendServerCommand( j,"qsay \"^7U have been gibbed: ^1Spawned with wrong weapon!\n\"")

		end
          end
	end

	if mcount == 1 then
		mcount = mcount + 1
	end
	if mcount == 300 then
		mcount = 0
	end
	if lvoteon == 1 then
		vcount1 = vcount1 + 1
	end
	if lvoteoff == 1 then
		vcount2 = vcount2 + 1
	end
	if kvoteon == 1 then
		kvcount1 = kvcount1 + 1
	end
	if kvoteoff == 1 then
		kvcount2 = kvcount2 + 1
	end
	if svoteon == 1 then
		svcount1 = svcount1 + 1
	end
	if svoteoff == 1 then
		svcount2 = svcount2 + 1
	end
	if vcount1 == vtime then
		voteon = 0
		et.trap_SendServerCommand(-1 , "chat \"^7LUGERWAR Voting is now: ^1Activated!\n\"" )
		vcount1 = 0		
	end
	if vcount2 == vtime then
		voteoff = 0
		et.trap_SendServerCommand(-1 , "chat \"^7LUGERWAR Voting is now: ^1Activated!\n\"" )
		vcount2 = 0	
	end
	if kvcount1 == vtime then
		kvoteon = 0
		et.trap_SendServerCommand(-1 , "chat \"^7K43WAR Voting is now: ^1Activated!\n\"" )
		kvcount1 = 0		
	end
	if kvcount2 == vtime then
		kvoteoff = 0
		et.trap_SendServerCommand(-1 , "chat \"^7K43WAR Voting is now: ^1Activated!\n\"" )
		kvcount2 = 0	
	end
	if svcount1 == vtime then
		svoteon = 0
		et.trap_SendServerCommand(-1 , "chat \"^7STENWAR Voting is now: ^1Activated!\n\"" )
		svcount1 = 0		
	end
	if svcount2 == vtime then
		svoteoff = 0
		et.trap_SendServerCommand(-1 , "chat \"^7STENWAR Voting is now: ^1Activated!\n\"" )
		svcount2 = 0	
	end
	for j = 0, (maxclients - 1) do
		if count[j] == 50 then
		et.trap_SendServerCommand(-1 , "chat \""..et.gentity_get(j, "pers.netname").."^3's prone-disarm has been lifted!\n\"" )
		count[j] = 0
			et.gentity_set(j,"ps.ammoclip",3,30)
			et.gentity_set(j,"ps.ammo",3,60)
			et.gentity_set(j,"ps.ammoclip",8,30)
			et.gentity_set(j,"ps.ammo",8,60)
			et.gentity_set(j,"ps.ammo",7,32)
			et.gentity_set(j,"ps.ammoclip",7,8)
			et.gentity_set(j,"ps.ammo",2,32)
			et.gentity_set(j,"ps.ammoclip",2,8)
			et.gentity_set(j,"ps.ammo",10,64)
			et.gentity_set(j,"ps.ammoclip",10,32)
			et.gentity_set(j,"ps.ammo",23,20)
			et.gentity_set(j,"ps.ammoclip",23,10)
			et.gentity_set(j,"ps.ammo",24,20)
			et.gentity_set(j,"ps.ammoclip",24,10)
		end
		if count[j] > 0 then
		count[j] = count[j] +1
		end
	end
	for j = 0, (maxclients - 1) do
		local bits = tobits( et.gentity_get( j, "s.eFlags" ) )
			if bits[20] or bits[21] then 
		    if gamestate == 0 then
			if count[j] == 0 then
			count[j] = count[j] + 1  
		if count[j] == 1 then
			et.trap_SendServerCommand(-1 , "chat \""..et.gentity_get(j, "pers.netname").." ^3proned !He has been disarmed for 10 Seconds!\n\"" )
				end	
			end
		end
	end
end
		for j = 0, (maxclients - 1) do
		for l=1, (et.MAX_WEAPONS - 1), 1 do
	    	if not weapons[l] then
		local luger = tonumber(et.trap_Cvar_Get( "g_luger" )) 
		if luger == 1 then
			if count[j] < 50 then
			   if count[j] > 0 then
				et.gentity_set(j, "ps.ammoclip", l, 0)
				et.gentity_set(j, "ps.ammo", l, 0)
				et.gentity_set(j, "ps.ammo", 7, 0)
				et.gentity_set(j, "ps.ammo", 2, 0)
				et.gentity_set(j, "ps.ammoclip", 7, 0)
				et.gentity_set(j, "ps.ammoclip", 2, 0)
					end
				end
			if count[j] == 0 then
				et.gentity_set(j, "ps.ammoclip", l, 0)
				et.gentity_set(j, "ps.ammo", l, 0)
				et.gentity_set(j, "ps.ammo", 7, 150)
				et.gentity_set(j, "ps.ammo", 2, 150)
				end
		elseif luger == 0 then 
			if count[j] < 50 then
			    if count[j] > 0 then
				et.gentity_set(j, "ps.ammoclip", l, 0)
				et.gentity_set(j, "ps.ammo", l, 0)
				et.gentity_set(j, "ps.ammo", 7, 0)
				et.gentity_set(j, "ps.ammo", 2, 0)
				et.gentity_set(j, "ps.ammoclip", 7, 0)
				et.gentity_set(j, "ps.ammoclip", 2, 0)
						end
					end
				end	
			end
		end
		for s=1, (et.MAX_WEAPONS - 1), 1 do
		if not sweapons[s] then
		local sten = tonumber(et.trap_Cvar_Get( "g_sten" )) 
		if sten == 1 then
			if count[j] < 50 then
			   if count[j] > 0 then
				et.gentity_set(j, "ps.ammoclip", s, 0)
				et.gentity_set(j, "ps.ammo", s, 0)
				et.gentity_set(j, "ps.ammo", 10, 0)
				et.gentity_set(j, "ps.ammoclip", 10, 0)
					end
				end
			if count[j] == 0 then
				et.gentity_set(j, "ps.ammoclip", s, 0)
				et.gentity_set(j, "ps.ammo", s, 0)
				et.gentity_set(j, "ps.ammo", 10, 150)
				end
		elseif sten == 0 then 
			if count[j] < 50 then
			    if count[j] > 0 then
				et.gentity_set(j, "ps.ammoclip", s, 0)
				et.gentity_set(j, "ps.ammo", s, 0)
				et.gentity_set(j, "ps.ammo", 7, 0)
				et.gentity_set(j, "ps.ammo", 2, 0)
				et.gentity_set(j, "ps.ammoclip", 7, 0)
				et.gentity_set(j, "ps.ammoclip", 2, 0)
						end
					end
				end	
			end
		    end
		for k=1, (et.MAX_WEAPONS - 1), 1 do
		if not kweapons[k] then
		local k43 = tonumber(et.trap_Cvar_Get( "g_k43" )) 
		if k43 == 1 then
			if count[j] < 50 then
			   if count[j] > 0 then
				et.gentity_set(j, "ps.ammoclip", k, 0)
				et.gentity_set(j, "ps.ammo", k, 0)
				et.gentity_set(j, "ps.ammo", 23, 0)
				et.gentity_set(j, "ps.ammoclip", 23, 0)
				et.gentity_set(j, "ps.ammo", 24, 0)
				et.gentity_set(j, "ps.ammoclip", 24, 0)
					end
				end
			if count[j] == 0 then
				et.gentity_set(j, "ps.ammoclip", k , 0)
				et.gentity_set(j, "ps.ammo", k, 0)
				et.gentity_set(j, "ps.ammo", 23, 150)
				et.gentity_set(j, "ps.ammo", 24, 150)
				end
		elseif k43 == 0 then 
			if count[j] < 50 then
			    if count[j] > 0 then
				et.gentity_set(j, "ps.ammoclip", k, 0)
				et.gentity_set(j, "ps.ammo", k, 0)
				et.gentity_set(j, "ps.ammo", 23, 0)
				et.gentity_set(j, "ps.ammo", 24, 0)
				et.gentity_set(j, "ps.ammoclip", 23, 0)
				et.gentity_set(j, "ps.ammoclip", 24, 0)
						end
					end
				end	
			end
		    end

		end
	end
function et_ClientCommand(client, command)
	team = et.gentity_get(client,"sess.sessionTeam")
	sound1 =  "sound/etpro/osp_prepare.wav" 
	luger = tonumber(et.trap_Cvar_Get( "g_luger" )) 
	sten = tonumber(et.trap_Cvar_Get( "g_sten" )) 
	k43 = tonumber(et.trap_Cvar_Get( "g_k43" )) 
  if string.lower(command) == "callvote" then
	if gamestate == 0 then
	if tonumber(et.gentity_get(client, "pers.voteCount")) > 4 then return end
	end
	if et.trap_Argv(1) == "map" then
	if et.trap_Argv(2) == "LUGERON" then

		if luger == 1 then
				if team == 3 then return end
					et.trap_SendServerCommand( client,"cpm \"^7Sorry, but Lugerwar is already ^1ACTIVATED^7!\n\"")
				return 1
			end
		if luger == 0 then
				if team == 3 then return end
				if sten == 1 then 
				et.trap_SendServerCommand( client,"cpm \"^7Sorry, but STENWAR is already ^1ACTIVATED^7!\n\"")
				return 1
				end
				if k43 == 1 then 
				et.trap_SendServerCommand( client,"cpm \"^7Sorry, but K43WAR is already ^1ACTIVATED^7!\n\"")
				return 1
				end
				if lvoteoff == 0 then
					if mcount > 0 then return end
					et.G_globalSound( sound1 ) 
					et.trap_SendServerCommand( -1,"chat \"^7This vote ^1won't change map^7.. It's for activating the ^1Lugerwar^7!!!\n\"")
					mcount = 1
				elseif lvoteoff == 1 then
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
				end
			end
		end
		if et.trap_Argv(2) == "LUGEROFF" then
		if luger == 0 then
				if sten == 1 then 
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
				end
				if k43 == 1 then 
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
				end
				if team == 3 then return end
					et.trap_SendServerCommand( client,"cpm \"^7Sorry, but Lugerwar is already ^1DEACTIVATED^7!\n\"")
				return 1
			end
		if luger == 1 then
				if team == 3 then return end
				if lvoteon == 0 then
					if mcount > 0 then return end
					et.G_globalSound( sound1 ) 
					et.trap_SendServerCommand( -1,"chat \"^7This vote ^1won't change map^7.. It's for deactivating the ^1Lugerwar^7!!!\n\"")
					mcount = 1
				elseif lvoteon == 1 then
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
			end
		end
	end
	if et.trap_Argv(2) == "STENON" then
		if sten == 1 then
				if team == 3 then return end
					et.trap_SendServerCommand( client,"cpm \"^7Sorry, but Stenwar is already ^1ACTIVATED^7!\n\"")
				return 1
			end
		if sten == 0 then
				if team == 3 then return end
				if luger == 1 then 
				et.trap_SendServerCommand( client,"cpm \"^7Sorry, but LUGERWAR is already ^1ACTIVATED^7!\n\"")
				return 1
				end
				if k43 == 1 then 
				et.trap_SendServerCommand( client,"cpm \"^7Sorry, but K43WAR is already ^1ACTIVATED^7!\n\"")
				return 1
				end
				if svoteoff == 0 then
					if mcount > 0 then return end
					et.G_globalSound( sound1 ) 
					et.trap_SendServerCommand( -1,"chat \"^7This vote ^1won't change map^7.. It's for activating the ^1Stenwar^7!!!\n\"")
					mcount = 1
				elseif svoteoff == 1 then
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
				end
			end
		end
		if et.trap_Argv(2) == "STENOFF" then
		if sten == 0 then
				if luger == 1 then 
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
				end
				if k43 == 1 then 
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
				end
				if team == 3 then return end
					et.trap_SendServerCommand( client,"cpm \"^7Sorry, but Stenwar is already ^1DEACTIVATED^7!\n\"")
				return 1
			end
		if sten == 1 then
				if team == 3 then return end
				if svoteon == 0 then
					if mcount > 0 then return end
					et.G_globalSound( sound1 ) 
					et.trap_SendServerCommand( -1,"chat \"^7This vote ^1won't change map^7.. It's for deactivating the ^1Stenwar^7!!!\n\"")
					mcount = 1
				elseif svoteon == 1 then
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
			end
		end

	    end

	if et.trap_Argv(2) == "K43ON" then
		if k43 == 1 then
				if team == 3 then return end
					et.trap_SendServerCommand( client,"cpm \"^7Sorry, but Stenwar is already ^1ACTIVATED^7!\n\"")
				return 1
			end
		if k43 == 0 then
				if team == 3 then return end
				if luger == 1 then 
				et.trap_SendServerCommand( client,"cpm \"^7Sorry, but LUGERWAR is already ^1ACTIVATED^7!\n\"")
				return 1
				end
				if sten == 1 then 
				et.trap_SendServerCommand( client,"cpm \"^7Sorry, but STENWAR is already ^1ACTIVATED^7!\n\"")
				return 1
				end
				if kvoteoff == 0 then
					if mcount > 0 then return end
					et.G_globalSound( sound1 ) 
					et.trap_SendServerCommand( -1,"chat \"^7This vote ^1won't change map^7.. It's for activating the ^1K43war^7!!!\n\"")
					mcount = 1
				elseif kvoteoff == 1 then
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
				end
			end
		end
		if et.trap_Argv(2) == "K43OFF" then
		if k43 == 0 then
				if luger == 1 then 
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
				end
				if sten == 1 then 
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
				end
				if team == 3 then return end
					et.trap_SendServerCommand( client,"cpm \"^7Sorry, but STENWAR is already ^1DEACTIVATED^7!\n\"")
				return 1
			end
		if k43 == 1 then
				if team == 3 then return end
				if kvoteon == 0 then
					if mcount > 0 then return end
					et.G_globalSound( sound1 ) 
					et.trap_SendServerCommand( -1,"chat \"^7This vote ^1won't change map^7.. It's for deactivating the ^1K43war^7!!!\n\"")
					mcount = 1
				elseif kvoteon == 1 then
					et.trap_SendServerCommand( client,"cpm \"^7This vote is currently ^1DISABLED!\n\"")
				return 1
			end
		end

	    end
	end

	if et.trap_Argv(1) == "campaign" then
		if et.trap_Argv(2) == "cmpgn_ef10map" then
			et.trap_SendServerCommand( client,"cpm \"^7Sorry, but map voting has been ^1DISABLED^7!\n\"")
			return 1
		end
		if et.trap_Argv(2) == "cmpgn_centraleurope" then
			et.trap_SendServerCommand( client,"cpm \"^7Sorry, but map voting has been ^1DISABLED^7!\n\"")
			return 1
		end
		if et.trap_Argv(2) == "cmpgn_northafrica" then
			et.trap_SendServerCommand( client,"cpm \"^7Sorry, but map voting has been ^1DISABLED^7!\n\"")
			return 1
                end
		end
	if et.trap_Argv(1) == "shuffleteamsxp" then
		et.trap_SendServerCommand( client,"cpm \"^7Sorry, but you can only vote for ^1shuffle_norestart^7!\n\"")
		return 1
	     end      
       if et.trap_Argv(1) == "timelimit" then
	entered_argument2 = string.lower(et.trap_Argv(2))
	timel = tonumber(entered_argument2)
		if (timel > 1) then
		et.trap_SendServerCommand(client, "cpm \"^7Sorry, but you can only vote for ^1end the map^7!\n\"" )
		return 1
              end
	    end
	end
  	if string.lower(command) == "kill" then
   		 et.trap_SendServerCommand( client, "cp \"^1Sorry, selfkilling is disabled on this server.\n\"" )
  	  return 1
  	 end
return 0
  end

 
function et_Print(text)
	local t = ParseString(text)
 	sound =  "sound/etpro/osp_fight.wav" 
	sound1 =  "sound/chat/allies/65a.wav" 
	sound2 =  "sound/chat/allies/64a.wav"
	sound3 =  "sound/chat/allies/63a.wav"  
	if t[3] == "campaign" and t[4] == "'LUGERON'" then 
			et.G_globalSound( sound )
			et.trap_Cvar_Set( "g_luger", "1" ) 
			lvoteon = 1
			et.trap_SendServerCommand( -1 , "chat \"^3LUGERWAR^7: ^1ON ^7/ ^7All Weapons: ^1OFF \n\"" )
			et.trap_SendServerCommand( -1 , "cp \"^3LUGERWAR^7: ^1ON ^7/ ^7All Weapons: ^1OFF \n\"" )
		if gamestate == 0 then
			et.trap_SendServerCommand( -1 , "chat \"^1FUNWAR voting ^7has been ^1disabled ^7for 5 minutes!\n\"" )
		end
	end	
	if t[3] == "campaign" and t[4] == "'LUGEROFF'" then 
			et.G_globalSound( sound )
			et.trap_Cvar_Set( "g_luger", "0" )
			lvoteoff = 1
			et.trap_SendServerCommand( -1 , "chat \"^3LUGERWAR^7: ^1OFF ^7/ ^7Weapons have been ^1RESTORED\n\"" )
			et.trap_SendServerCommand( -1 , "cp \"^3LUGERWAR^7: ^1OFF ^7/ ^7Weapons have been ^1RESTORED\n\"" )
		if gamestate == 0 then
			et.trap_SendServerCommand( -1 , "chat \"^1FUNWAR voting ^7has been ^1disabled ^7for 5 minutes!\n\"" )
			end	
		for k = 0, (maxclients - 1) do 
			et.gentity_set(k,"ps.ammoclip",3,30)
			et.gentity_set(k,"ps.ammo",3,60)
			et.gentity_set(k,"ps.ammoclip",8,30)
			et.gentity_set(k,"ps.ammo",8,60)
			et.gentity_set(k,"ps.ammo",7,32)
			et.gentity_set(k,"ps.ammoclip",7,8)
			et.gentity_set(k,"ps.ammo",2,32)
			et.gentity_set(k,"ps.ammoclip",2,8)
			et.gentity_set(k,"ps.ammo",23,20)
			et.gentity_set(k,"ps.ammoclip",23,10)
			et.gentity_set(k,"ps.ammo",24,20)
			et.gentity_set(k,"ps.ammoclip",24,10)
		end
	end 

	if t[3] == "campaign" and t[4] == "'STENON'" then 
			et.G_globalSound( sound1 )
			et.trap_Cvar_Set( "g_sten", "1" )
			for k = 0, (maxclients - 1) do  
			et.gentity_set(k,"sess.latchPlayerType",4)
			et.gentity_set(k,"sess.latchPlayerWeapon",10)
			et.trap_Cvar_Set( "team_maxSoldiers", "0" )
			et.trap_Cvar_Set( "team_maxMedics", "0" )
			et.trap_Cvar_Set( "team_maxEngineers", "0" )
			et.trap_Cvar_Set( "team_maxFieldops", "0" )
			et.trap_Cvar_Set( "team_maxCovertops", "-1" )
			et.gentity_set(k, "health", -200)
			end
			svoteon = 1
			et.trap_SendServerCommand( -1 , "chat \"^3STENWAR^7: ^1ON ^7/ ^7All Weapons: ^1OFF \n\"" )
			et.trap_SendServerCommand( -1 , "cp \"^3STENWAR^7: ^1ON ^7/ ^7All Weapons: ^1OFF \n\"" )
		if gamestate == 0 then
			et.trap_SendServerCommand( -1 , "chat \"^1FUNWAR voting ^7has been ^1disabled ^7for 5 minutes!\n\"" )
		end
	end	
	if t[3] == "campaign" and t[4] == "'STENOFF'" then 
			et.G_globalSound( sound2 )
			et.trap_Cvar_Set( "g_sten", "0" )
			svoteoff = 1
			et.trap_SendServerCommand( -1 , "chat \"^3STENWAR^7: ^1OFF ^7/ ^7Weapons have been ^1RESTORED\n\"" )
			et.trap_SendServerCommand( -1 , "cp \"^3STENWAR^7: ^1OFF ^7/ ^7Weapons have been ^1RESTORED\n\"" )
		if gamestate == 0 then
			et.trap_SendServerCommand( -1 , "chat \"^1FUNWAR voting ^7has been ^1disabled ^7for 5 minutes!\n\"" )
			end	
		for k = 0, (maxclients - 1) do 
			et.gentity_set(k,"sess.latchPlayerType",3)
			et.trap_Cvar_Set( "team_maxSoldiers", "-1" )
			et.trap_Cvar_Set( "team_maxMedics", "0" )
			et.trap_Cvar_Set( "team_maxEngineers", "-1" )
			et.trap_Cvar_Set( "team_maxFieldops", "-1" )
			et.trap_Cvar_Set( "team_maxCovertops", "0" )
			et.gentity_set(k, "health", -200)
			et.gentity_set(k,"ps.ammoclip",3,30)
			et.gentity_set(k,"ps.ammo",3,60)
			et.gentity_set(k,"ps.ammoclip",8,30)
			et.gentity_set(k,"ps.ammo",8,60)
			et.gentity_set(k,"ps.ammo",7,32)
			et.gentity_set(k,"ps.ammoclip",7,8)
			et.gentity_set(k,"ps.ammo",2,32)
			et.gentity_set(k,"ps.ammoclip",2,8)
		end
	end 


	if t[3] == "campaign" and t[4] == "'K43ON'" then 
			et.G_globalSound( sound3 )
			et.trap_Cvar_Set( "g_k43", "1" )
			for k = 0, (maxclients - 1) do  
			et.gentity_set(k,"sess.latchPlayerType",2)
			if team == 1 then
			et.gentity_set(k,"sess.latchPlayerWeapon",23)
			elseif team == 2 then
			et.gentity_set(k,"sess.latchPlayerWeapon",24)
			end
			et.trap_Cvar_Set( "team_maxSoldiers", "0" )
			et.trap_Cvar_Set( "team_maxMedics", "0" )
			et.trap_Cvar_Set( "team_maxEngineers", "-1" )
			et.trap_Cvar_Set( "team_maxFieldops", "0" )
			et.trap_Cvar_Set( "team_maxCovertops", "0" )
			et.gentity_set(k, "health", -200)
			end
			kvoteon = 1
			et.trap_SendServerCommand( -1 , "chat \"^3K43WAR^7: ^1ON ^7/ ^7All Weapons: ^1OFF \n\"" )
			et.trap_SendServerCommand( -1 , "cp \"^3K43WAR^7: ^1ON ^7/ ^7All Weapons: ^1OFF \n\"" )
		if gamestate == 0 then
			et.trap_SendServerCommand( -1 , "chat \"^1FUNWAR voting ^7has been ^1disabled ^7for 5 minutes!\n\"" )
		end
	end	
	if t[3] == "campaign" and t[4] == "'K43OFF'" then 
			et.G_globalSound( sound2 )
			et.trap_Cvar_Set( "g_k43", "0" )
			kvoteoff = 1
			et.trap_SendServerCommand( -1 , "chat \"^3K43WAR^7: ^1OFF ^7/ ^7Weapons have been ^1RESTORED\n\"" )
			et.trap_SendServerCommand( -1 , "cp \"^3K43WAR^7: ^1OFF ^7/ ^7Weapons have been ^1RESTORED\n\"" )
		if gamestate == 0 then
			et.trap_SendServerCommand( -1 , "chat \"^1FUNWAR voting ^7has been ^1disabled ^7for 5 minutes!\n\"" )
			end	
		for k = 0, (maxclients - 1) do 
			et.gentity_set(k,"sess.latchPlayerType",3)
			et.trap_Cvar_Set( "team_maxSoldiers", "-1" )
			et.trap_Cvar_Set( "team_maxMedics", "0" )
			et.trap_Cvar_Set( "team_maxEngineers", "-1" )
			et.trap_Cvar_Set( "team_maxFieldops", "-1" )
			et.trap_Cvar_Set( "team_maxCovertops", "0" )
			et.gentity_set(k, "health", -200)
			et.gentity_set(k,"ps.ammoclip",3,30)
			et.gentity_set(k,"ps.ammo",3,60)
			et.gentity_set(k,"ps.ammoclip",8,30)
			et.gentity_set(k,"ps.ammo",8,60)
			et.gentity_set(k,"ps.ammo",7,32)
			et.gentity_set(k,"ps.ammoclip",7,8)
			et.gentity_set(k,"ps.ammo",2,32)
			et.gentity_set(k,"ps.ammoclip",2,8)
		end
	end 
end
function et_ClientDisconnect(cno) 
	count[cno] = 0
end
function et_Obituary( victim, killer, meansofdeath ) 
	count[victim] = 0
end