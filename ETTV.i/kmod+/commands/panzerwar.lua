
function dolua(params)
-- note: if the map changes while this command is runing, the tables are reset and the old server configuration is lost!
-- and !panzerwar off will just raise errors...
-- you should propobly set your permenet server cvars (maxpanzers etc.. ) in the "off" section
-- instead of the global_cvar_backup_table
-- example: if i allow 2 panzers on my server then et.trap_Cvar_Set("team_maxpanzers",2)
	if params.slot ~= CONSOLE then
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end
	
	if params[1] == "1" or params[1] == "on" then

			if global_cvar_backup_table ~= nil then -- we dont want to override the real settings with another's mod settings
				if params.slot ~= "conole" then
					et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s"\n',params["say"],"^3Panzerwar^w: ^f" .. global_weapons_table["mod"] .. " ^fis already on \n" ))
					return 1
				end
			end

			-- remember the old server settings			-- remember the old server settings
			global_cvar_backup_table = {}
			-- weapon cvars
			global_cvar_backup_table["team_maxMortars"] = tonumber(et.trap_Cvar_Get("team_maxMortars"))
			global_cvar_backup_table["team_maxFlamers"] = tonumber(et.trap_Cvar_Get("team_maxFlamers"))
			global_cvar_backup_table["team_maxMg42s"] = tonumber(et.trap_Cvar_Get("team_maxMg42s"))
			global_cvar_backup_table["team_maxMines"] = tonumber(et.trap_Cvar_Get("team_maxMines"))
			global_cvar_backup_table["team_maxriflegrenades"] = tonumber(et.trap_Cvar_Get("team_maxriflegrenades"))
			global_cvar_backup_table["team_maxPanzers"] = tonumber(et.trap_Cvar_Get("team_maxPanzers"))
			-- classes
			global_cvar_backup_table["team_maxSoldiers"] = tonumber(et.trap_Cvar_Get("team_maxSoldiers"))
			global_cvar_backup_table["team_maxMedics"] = tonumber(et.trap_Cvar_Get("team_maxMedics"))
			global_cvar_backup_table["team_maxEngineers"] = tonumber(et.trap_Cvar_Get("team_maxEngineers"))
			global_cvar_backup_table["team_maxFieldops"] = tonumber(et.trap_Cvar_Get("team_maxFieldops"))
			global_cvar_backup_table["team_maxCovertops"] = tonumber(et.trap_Cvar_Get("team_maxCovertops"))
			-- misc
			global_cvar_backup_table["g_soldierchargetime"] = tonumber(et.trap_Cvar_Get("g_soldierchargetime"))
			global_cvar_backup_table["g_speed"] = tonumber(et.trap_Cvar_Get("g_speed"))
			global_cvar_backup_table["g_gravity"] = tonumber(et.trap_Cvar_Get("g_gravity"))
			global_cvar_backup_table["team_maxpanzers"] = tonumber(et.trap_Cvar_Get("team_maxpanzers"))
			

			local k
			--remember old player settings
			global_playerclass_backup = {}
			global_playerweapon_backup = {}
			for k=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
				if global_players_table[k] ~= nil then
					if global_players_table[k]["team"] == 1 or global_players_table[k]["team"] == 2 then
						global_playerclass_backup[k] = tonumber(et.gentity_get(k,"sess.latchPlayerType"))
						global_playerweapon_backup[k] = tonumber(et.gentity_get(k,"sess.latchPlayerWeapon"))
					end
				end
			end
					

			-- new settings
			-- weapons setting weapons with true value to 999 ammo, nil's to 0 ammo
			global_weapons_table = {}

			global_weapons_table["mod"] = "panzerwar"

			global_weapons_table["weapons"] = {}
			--			    loaded ammo , clip ammo
			-- if loaded ammo/clip ammo = nil, it wont be updated
			global_weapons_table["weapons"][1] = nil       --// 1
			global_weapons_table["weapons"][2] = { 0 , 0 } --WP_LUGER,		// 2
			global_weapons_table["weapons"][3] = { 0 , 0 } --WP_MP40,		// 3
			global_weapons_table["weapons"][4] = { 0 , 0 } --WP_GRENADE_LAUNCHER,	// 4
			global_weapons_table["weapons"][5] = { 999 , 0 } --WP_PANZERFAUST,	// 5
			global_weapons_table["weapons"][6] = { 0 , 0 } --WP_FLAMETHROWER,	// 6
			global_weapons_table["weapons"][7] = { 0 , 0 } --WP_COLT,		// 7	// equivalent american weapon to german luger
			global_weapons_table["weapons"][8] = { 0 , 0 } --WP_THOMPSON,		// 8	// equivalent american weapon to german mp40
			global_weapons_table["weapons"][9] = { 0 , 0 } --WP_GRENADE_PINEAPPLE,	// 9
			global_weapons_table["weapons"][10] = { 0 , 0 } --WP_STEN,		// 10	// silenced sten sub-machinegun
			global_weapons_table["weapons"][11] = { 0 , 0 } --WP_MEDIC_SYRINGE,	// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
			global_weapons_table["weapons"][12] = { 0 , 0 } --WP_AMMO,		// 12	// JPW NERVE likewise
			global_weapons_table["weapons"][13] = { 0 , 0 } --WP_ARTY,		// 13
			global_weapons_table["weapons"][14] = { 0 , 0 } --WP_SILENCER,		// 14	// used to be sp5
			global_weapons_table["weapons"][15] = { 0 , 0 } --WP_DYNAMITE,		// 15
			global_weapons_table["weapons"][16] = nil	--// 16
			global_weapons_table["weapons"][17] = nil	--// 17
			global_weapons_table["weapons"][18] = nil	--// 18
			global_weapons_table["weapons"][19] = { 1 , 0 } --WP_MEDKIT,		// 19
			global_weapons_table["weapons"][20] = { 0 , 0 } --WP_BINOCULARS,	// 20
			global_weapons_table["weapons"][21] = nil	--// 21
			global_weapons_table["weapons"][22] = nil	--// 22
			global_weapons_table["weapons"][23] = { 0 , 0 } --WP_KAR98,			// 23	// WolfXP weapons
			global_weapons_table["weapons"][24] = { 0 , 0 } --WP_CARBINE,			// 24
			global_weapons_table["weapons"][25] = { 0 , 0 } --WP_GARAND,			// 25
			global_weapons_table["weapons"][26] = { 0 , 0 } --WP_LANDMINE,			// 26
			global_weapons_table["weapons"][27] = { 0 , 0 } --WP_SATCHEL,			// 27
			global_weapons_table["weapons"][28] = { 0 , 0 } --WP_SATCHEL_DET,		// 28
			global_weapons_table["weapons"][29] = nil	--// 29
			global_weapons_table["weapons"][30] = { 0 , 0 } --WP_SMOKE_BOMB,		// 30
			global_weapons_table["weapons"][31] = { 0 , 0 } --WP_MOBILE_MG42,		// 31
			global_weapons_table["weapons"][32] = { 0 , 0 } --WP_K43,			// 32
			global_weapons_table["weapons"][33] = { 0 , 0 } --WP_FG42,			// 33
			global_weapons_table["weapons"][34] = nil	--// 34
			global_weapons_table["weapons"][35] = { 0 , 0 } --WP_MORTAR,			// 35
			global_weapons_table["weapons"][36] = nil	--// 36
			global_weapons_table["weapons"][37] = { 0 , 0 } --WP_AKIMBO_COLT,		// 37
			global_weapons_table["weapons"][38] = { 0 , 0 } --WP_AKIMBO_LUGER,		// 38
			global_weapons_table["weapons"][39] = nil	--// 39
			global_weapons_table["weapons"][40] = nil	--// 40
			global_weapons_table["weapons"][41] = { 0 , 0 } --WP_SILENCED_COLT,		// 41
			global_weapons_table["weapons"][42] = { 0 , 0 } --WP_GARAND_SCOPE,		// 42
			global_weapons_table["weapons"][43] = { 0 , 0 } --WP_K43_SCOPE,			// 43
			global_weapons_table["weapons"][44] = { 0 , 0 } --WP_FG42SCOPE,			// 44
			global_weapons_table["weapons"][45] = { 0 , 0 } --WP_MORTAR_SET,		// 45
			global_weapons_table["weapons"][46] = { 0 , 0 } --WP_MEDIC_ADRENALINE,		// 46
			global_weapons_table["weapons"][47] = { 0 , 0 } --WP_AKIMBO_SILENCEDCOLT,	// 47
			global_weapons_table["weapons"][48] = { 0 , 0 } --WP_AKIMBO_SILENCEDLUGER,	// 48


			-- axis main weapon
			global_weapons_table["axis"] = 5 -- panzer
			-- allies main weapon
			global_weapons_table["allies"] = 5
			-- class , if class is set (it can be omitted) then all players are forced to play as this class
			global_weapons_table["class_allies"] = 0 -- soldier
			global_weapons_table["class_axis"] = 0
			-- available weapons (if player doesnt hold 1 of those, hell be forced to the have the main weapon of his team)
			global_weapons_table["available"] = {}
			global_weapons_table["available"][1] = 5 -- can hold panzer

			-- the command/file name
			global_weapons_table["command"] = "panzerwar"
			global_weapons_table["disable"] = {}
			-- set the params that the command needs to be called with to disable the mod  
			global_weapons_table["disable"][1] = "0"
			-- the command global_weapons_table["command"] with the params global_weapons_table["disable"] will be called on a map-change by the console
			-- to disable the mod
			
			-- shoot!
			local speed = tonumber(et.trap_Cvar_Get("g_speed"))*2
			-- change server cvars
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "g_speed " .. speed .. " ; forcecvar g_soldierchargetime 0\n ; g_gravity 200; team_maxpanzers -1" )

			-- client change
			for k=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
				if global_players_table[k] ~= nil then
					-- kill em
					if et.gentity_get(k,"health") > 0 then
						et.G_Damage(k, k, 1022, 400, 24, 0)
						et.gentity_set(k,"health",(et.gentity_get(k,"health")-400)) -- in case they recently spawned and are protected by spawn shield
					end

					-- change their weapons
					if global_players_table[k]["team"] == 1 then -- axis
						et.gentity_set(k,"sess.latchPlayerWeapon",global_weapons_table["axis"])
					elseif global_players_table[k]["team"] == 2 then
						et.gentity_set(k,"sess.latchPlayerWeapon",global_weapons_table["allies"])
					end
				end
			end
			if params.slot ~= "conole" then
				et.trap_SendServerCommand(-1, string.format('%s \"%s"\n',params["say"],"^3Panzerwar^w: panzerwar enabled \n" ))
			end

	elseif params[1] == "0" or params[1] == "off" then


			if global_cvar_backup_table == nil then
				check_restriction() -- force restrictions in case there are any leftovers
				et.trap_SendServerCommand(-1, string.format('%s \"%s"\n',params["say"],"^3Panzerwar^w: panzerwar is already disabled \n" ))
				return 1
			end

			-- set old server settings

			local k,v
			for k,v in pairs(global_cvar_backup_table) do 
				et.trap_Cvar_Set(k,v)
			end



			local k
			--gove the players their old settings

			for k=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
				if global_players_table[k] ~= nil then -- could be after a map change
					-- kill em (maybe that class/weapon is disabled)
					if et.gentity_get(k,"health") > 0 then
						et.G_Damage(k, k, 1022, 400, 24, 0)
						et.gentity_set(k,"health",(et.gentity_get(k,"health")-400)) -- in case they recently spawned and are protected by spawn shield
					end					
					if global_players_table[k]["team"] == 1 or global_players_table[k]["team"] == 2 then
						if global_playerclass_backup[k] ~= nil then -- players may have disconnected
							et.gentity_set(k,"sess.latchPlayerType", global_playerclass_backup[k])
							et.gentity_set(k,"sess.latchPlayerWeapon",global_playerweapon_backup[k])
						end
					end
				end
			end
					
			global_cvar_backup_table = nil -- distroy
			global_weapons_table = nil
			global_playerclass_backup = nil
			global_playerweapon_backup = nil


			check_restriction()
			if params.slot ~= "console" then
				et.trap_SendServerCommand(-1, string.format('%s \"%s"\n',params["say"],"^3Panzerwar^w: panzerwar has been disabled \n" ))
			end
	else
		if params.slot ~= "console" then
			et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s"\n',params["say"],"^3Panzerwar - usage^w: ^f!panzerwar [on|off] \n" ))		
		end
	end


	return 1

end
