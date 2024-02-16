Version = 	1.0
Author  =   "dFx (thanks to im2good4u)"
Description = "Give all weapons\n"
--global vars
et.MAX_WEAPONS = 50
--
weapons = {
	nil,	--// 1
	true,	--WP_LUGER,				// 2
	true,	--WP_MP40,				// 3
	true,	--WP_GRENADE_LAUNCHER,	// 4
	true,	--WP_PANZERFAUST,		// 5
	true,	--WP_FLAMETHROWER,		// 6
	true,	--WP_COLT,				// 7	// equivalent american weapon to german luger
	true,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	true,	--WP_GRENADE_PINEAPPLE,	// 9
	true,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	true,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	true,	--WP_AMMO,				// 12	// JPW NERVE likewise
	true,	--WP_ARTY,				// 13
	true,	--WP_SILENCER,			// 14	// used to be sp5
	true,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	true,	--WP_MEDKIT,			// 19
	true,	--WP_BINOCULARS,		// 20
	nil,	--// 21
	nil,	--// 22
	true,	--WP_KAR98,				// 23	// WolfXP weapons
	true,	--WP_CARBINE,			// 24
	true,	--WP_GARAND,			// 25
	true,	--WP_LANDMINE,			// 26
	true,	--WP_SATCHEL,			// 27
	true,	--WP_SATCHEL_DET,		// 28
	nil,	--// 29
	true,	--WP_SMOKE_BOMB,		// 30
	true,	--WP_MOBILE_MG42,		// 31
	true,	--WP_K43,				// 32
	true,	--WP_FG42,				// 33
	nil,	--// 34
	true,	--WP_MORTAR,			// 35
	nil,	--// 36
	true,	--WP_AKIMBO_COLT,		// 37
	true,	--WP_AKIMBO_LUGER,		// 38
	nil,	--// 39
	nil,	--// 40
	true,	--WP_SILENCED_COLT,		// 41
	true,	--WP_GARAND_SCOPE,		// 42
	true,	--WP_K43_SCOPE,			// 43
	true,	--WP_FG42SCOPE,			// 44
	true,	--WP_MORTAR_SET,		// 45
	true,	--WP_MEDIC_ADRENALINE,	// 46
	true,	--WP_AKIMBO_SILENCEDCOLT,// 47
	true,	--WP_AKIMBO_SILENCEDLUGER,// 48
}

function et_InitGame(levelTime,randomSeed,restart)
        et.G_Print("[ALLWEAPONS] Version:".. Version .." Loaded\n")
        et.RegisterModname("AllWeapons:".. Version .."slot:".. et.FindSelf())
end

function et_ClientSpawn(clientNum,revived)
	for i=1,(et.MAX_WEAPONS -1),1 do
	    if weapons[i] then
			et.gentity_set(clientNum,"ps.ammoclip",i,9999)
			et.gentity_set(clientNum,"ps.ammo",i,9999)
		end
	end
end