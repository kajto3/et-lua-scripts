Modname = "stenwar"
Version = "1.0"
Author  = "MNwa!"
Description = "^7Stenwar"
Homepage = "www.gs2175.fastdl.de"

--[[
			Based on noweapon.lua
-------------------------------------------------------
  Updated Feb 2011
  Changelog:
  
    1.0:
      Known bugs u still get a knife
      Initial release

-------------------------------------------------------
 --]]
 
 --Shrubbot min level to execute the command
 min_level     = 3
 
 
 --[[
 Usage: 
 !stenwar on
 !stenwar off
 --]]
 stenwar_cmd 			= "!stenwar"
 
 
 --[[
 Set to "true" to enable it
 noreload = true
 noreload = false
 --]]
 noreload = false
 
 
 --Sound that get played if you enable stenwar
 sound =  "sound/chat/allies/953a.wav" 
 
 --------------------------------------------------------------------------------
 
--global vars
et.MAX_WEAPONS = 50
et.CS_PLAYERS = 689
samplerate = 200
STEN = 10
--

--note sme got no comments because it arent weapons
weapons = {
	false,		--WP_THROWABLE_KNIFE // 1
	false,	--WP_LUGER,				// 2
	false,	--WP_MP40,				// 3
	false,	--WP_GRENADE_LAUNCHER,		// 4
	false,	--WP_PANZERFAUST,			// 5
	false,	--WP_FLAMETHROWER,		// 6
	false,		--WP_COLT,				// 7	// equivalent american weapon to german luger
	false,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	false,	--WP_GRENADE_PINEAPPLE,	/	// 9
	true,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	true,		--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	true,		--WP_AMMO,				// 12	// JPW NERVE likewise
	false,	--WP_ARTY,				// 13
	false,	--WP_SILENCER,			// 14	// used to be sp5
	true,	--WP_DYNAMITE,			// 15
	nil,		--// 16
	nil,		--// 17
	nil,		--// 18
	true,		--WP_MEDKIT,			// 19
	true,	--WP_BINOCULARS,			// 20
	nil,		--// 21
	nil,		--// 22
	false,	--WP_KAR98,				// 23	// WolfXP weapons
	false,	--WP_CARBINE,			// 24
	false,	--WP_GARAND,			// 25
	false,	--WP_LANDMINE,			// 26
	true,	--WP_SATCHEL,			// 27
	true,	--WP_SATCHEL_DET,			// 28
	nil,		--// 29
	true,	--WP_SMOKE_BOMB,			// 30
	false,	--WP_MOBILE_MG42,			// 31
	false,	--WP_K43,				// 32
	false,	--WP_FG42,				// 33
	nil,		--// 34
	false,	--WP_MORTAR,			// 35
	nil,		--// 36
	false,	--WP_AKIMBO_COLT,			// 37
	false,	--WP_AKIMBO_LUGER,		// 38
	nil,		--// 39
	nil,		--// 40
	false,	--WP_SILENCED_COLT,		// 41
	false,	--WP_GARAND_SCOPE,		// 42
	false,	--WP_K43_SCOPE,			// 43
	false,	--WP_FG42SCOPE,			// 44
	false,	--WP_MORTAR_SET,			// 45
	true,	--WP_MEDIC_ADRENALINE,		// 46
	false,	--WP_AKIMBO_SILENCEDCOLT,	// 47
	false		--WP_AKIMBO_SILENCEDLUGER,	// 48
}

function et_InitGame(levelTime,randomSeed,restart)
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )   --gets the maxclients
	gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
	et.G_Print("[Stenwar] Version:"..Version.." Loaded\n")
	et.RegisterModname(Modname .. "  " .. Version)
	blocker = 0
	if stenwar == nil then
		et.trap_Cvar_Set( "g_stenwar", "0" )
	end
end

-- called every server frame
function et_RunFrame( levelTime )
local stenwar = tonumber(et.trap_Cvar_Get( "g_stenwar" ))
		--et.trap_SendServerCommand(-1, "cp \"^w"..stenwar.."\n\"") -- Debug to get stenwar value
if math.mod(levelTime, samplerate) ~= 0 then return end
   -- for all clients
   for j = 0, (maxclients - 1) do
      for k=1, (et.MAX_WEAPONS - 1), 1 do
		if stenwar == 1 then
         if not weapons[k] then
			if noreload then
			   et.gentity_set(j, "ps.ammoclip", 10, 32)
			end
            et.gentity_set(j, "ps.ammoclip", k, 0)
            et.gentity_set(j, "ps.ammo", k, 0)
            et.gentity_set(j, "ps.ammo", 10, 1337)
			et.gentity_set(j,"sess.latchPlayerType",4)
			if checkclass(j) ~= 4 and blocker == 0 then
				changeclass(j)
				changeweapon(j)
				SetHP()
				blocker = 1
			end
			latchweapon(j)
		 end
		end
	  end
	end
 end
 
function checkclass(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client, 4)
	return tonumber(et.Info_ValueForKey(cs, "c"))
end

function changeclass(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client)
	local infoclass = et.Info_SetValueForKey( cs, "c", 4 )
	et.trap_SetConfigstring(689 + client, infoclass)
end

function changeweapon(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client)
	local infoweapon = et.Info_SetValueForKey( cs, "w", STEN )
	et.trap_SetConfigstring(689 + client, infoweapon)
end

function latchweapon(slot)
		local fallback -- default weapon
		if team == AXIS then 
			fallback = STEN
		else fallback = STEN
		end

		-- now update the client (in order for the change to be immidieate, and not wait for the server, we need to update the client's configstring)
		local infostring  
		infostring = et.trap_GetConfigstring(689 + slot)
		infostring = et.Info_SetValueForKey( infostring, "lw", fallback )
		et.trap_SetConfigstring(689 + slot, infostring)
		et.gentity_set(slot,"sess.latchPlayerWeapon",fallback)
end
 
 function getlevel(client)
	local lvl = et.G_shrubbot_level(client)
	if lvl >= min_level then
		return true
	elseif lvl < min_level then
		et.trap_SendServerCommand(client, "cpm \"^3Sorry, you don't have the right to execute this command\n\" " )
		return false
	end
		return nil
end

function SetHP()
	for target = 0, (maxclients - 1) do
	local hp = tonumber(et.gentity_get(target,"health"))
	  if hp < 0 then
		return
	  else
		et.gentity_set(target, "health", -200)
	  end
	 end
end

function et_ClientCommand(client, command)
 local stenwar = tonumber(et.trap_Cvar_Get( "g_stenwar" ))
  if getlevel(client) then
	if et.trap_Argv(0) == "say" or et.trap_Argv(0) == "say_team" or et.trap_Argv(0) == "say_buddy" or et.trap_Argv(0) == "say_teamnl" then
	   	local s, e, type = string.find(et.trap_Argv(1), "^" .. stenwar_cmd .. " ([%w%_]+)$")
			if type == "on" and stenwar == 0 then
					et.trap_Cvar_Set( "g_stenwar", "1" )
					et.G_globalSound( sound )
					et.trap_SendServerCommand(-1, "chat \"^.stenwar: ^3stenwar ^1enabled\" " )
			elseif type == "off" and stenwar == 1 then
					et.trap_Cvar_Set( "g_stenwar", "0" )
					for j = 0, (maxclients - 1) do
						et.gentity_set(j, "ps.ammo", 10, 96)
					end
					et.trap_SendServerCommand(-1, "chat \"^.stenwar: ^3stenwar ^1disabled\" " )
			elseif type == "on" and stenwar == 1 then
					et.trap_SendServerCommand(client, "cpm \"^.stenwar: ^3stenwar ^wis already ^1on\" " )
			elseif type == "off" then
					et.trap_SendServerCommand(client, "cpm \"^.stenwar: ^3stenwar ^wmust be ^1on ^wbefore you can disable it\" " )
			end
			if string.lower(et.trap_Argv(1)) == stenwar_cmd then
				if string.lower(et.trap_Argv(2)) == "on" and stenwar == 0 then
					et.trap_Cvar_Set( "g_stenwar", "1" )
					et.G_globalSound( sound )
					et.trap_SendServerCommand(-1, "chat \"^.stenwar: ^3stenwar ^1enabled\" " )
				elseif string.lower(et.trap_Argv(2)) == "off" and stenwar == 1 then
					et.trap_Cvar_Set( "g_stenwar", "0" )
				    for j = 0, (maxclients - 1) do
						et.gentity_set(j, "ps.ammo", 10, 96)
					end
					et.trap_SendServerCommand(-1, "chat \"^.stenwar: ^3stenwar ^1disabled\" " )
				elseif string.lower(et.trap_Argv(2)) == "on" and stenwar == 1 then
					et.trap_SendServerCommand(client, "cpm \"^.stenwar: ^3stenwar ^wis already ^1on\" " )
				elseif string.lower(et.trap_Argv(2)) == "off" then
					et.trap_SendServerCommand(client, "cpm \"^.stenwar: ^3stenwar ^wmust be ^1on ^wbefore you can disable it\" " )
				elseif string.lower(et.trap_Argv(2)) == "" then
					et.trap_SendServerCommand(client, "cpm \"^3!stenwar ^1on/off\" " )
				end
			end
	end
  end
 return 0
end