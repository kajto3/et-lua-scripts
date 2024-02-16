---------------------
--  gw_ref lua script
---------------------
--  This lua script adds in additional commands available to refs, and some other useful functions to combat cheaters and troublemakers.
--  Thanks to Fusion and Ghostworks members for their patience during the debugging.
--  Credit to im2good4u for his noweapons script, and to [FuN]Connor for introducing me to lua with rconx.

--  INSTALLATION:  
--  1.  Save the gw_refvXXX.lua script in the server's etpro folder.
--  2.  Add the line: set lua_modules "gw_refvXXX.lua" to your server.cfg (where XXX is the version number, check the filename)
--  3.  Restart your server.

--  COMMANDS:
--  !gwown <slot number> - If client kills someone, they die by the same weapon (victim gets the kill).
--  !gwdisarm <slot number> - Disarms the client of all ammo.  Gets refreshed every <samplerate> milliseconds, to empty ammo picked up.
--  !gwall <slot number> - Performs both !gwown and !gwdisarm.
--  !gwtele <slot number> - Randomly (almost) teleports the client around the map every <samplerate> milliseconds.
--  !gwrewind <slot number> - Every 2 x <samplerate> milliseconds, client's position is rewound to <samplerate> milliseconds ago.
--  !gwwait 1/0 - Turns on/off a wait time.  Clients must wait <wait_time_mins> minutes after joining the server before they can join a team.  Off by default, gets switched off on map change.
--  !gwresetown - Resets any !gwowns to 0.
--  !gwresetdisarm - Resets any !gwdisarms to 0.
--  !gwresetall - Resets everything (except !gwwait).

--  OTHER FEATURES:
--  Refs are notified of the etpro guids of joining players, and points out any that fail a length and hex test.
--  ETPro guids can be logged to file.
--  Muted players can not send private messages or call votes.  Clients calling the unmute vote will be instantly gibbed.

--  IMPORTANT NOTES:
--  ET admin_mod is not required to run this script.  A "!gw" prefix has been used to identify all gw_ref commands.
--  Commands must be entered in console, not in global chat.
--  Slot-specific commands are emptied on client-disconnect and on et_Initgame (map and config loads).
--  !gwtele and !gwrewind can only be called on 1 client at a time in this version.

--  GhosT:McSteve
--  www.ghostworks.co.uk
--  #ghostworks, #pbbans @quakenet
--  Version 3, 21/1/07


-----------------------------------------------------------------------------
-- ADMIN - SET OPTIONS HERE
wait_time_mins = 2	-- define the wait time for !gwwait in minutes here
etproguid_logging = 1	-- 1/0 = on/off
guidfilename = "etproguids"		-- set the name of the file to capture etproguids (will be created in etpro folder)


-- modify below this line only if you know how
------------------------------------------------------------------------------
-- global vars
et.MAX_WEAPONS = 50
samplerate = 3000 -- check player state every x milliseconds

-- ok, its not random, but its random enough :)
random_seed = {4; 4; 5; 4; 1; 4; 2; 3; 4; 3; 1; 4; 3; 5; 5; 4; 2; 1; 5; 2; 2; 4; 4; 3; 2; 4; 1; 1; 3; 2; 5; 2; 3; 5; 5; 6; 4; 4; 6; 6; 5; 4; 2; 1; 3; 5; 4; 5; 2; 3; 3; 3; 5; 6; 3; 2; 3; 3; 5; 5}

--convert the wait time to milliseconds
wait_time_ms = wait_time_mins * 60 * 1000


-- im2good4u's no weapon script
weapons = {
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
	true,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	false,	--WP_AMMO,				// 12	// JPW NERVE likewise
	false,	--WP_ARTY,				// 13
	false,	--WP_SILENCER,			// 14	// used to be sp5
	false,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	false,	--WP_MEDKIT,			// 19
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



-- on game initialise, get the maxclients and initialise the arrays (holds 1 or 0 for each client)
function et_InitGame( levelTime, randomSeed, restart )		--called on game initialise
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )	--gets the maxclients
	own_client = {}
	disarm_client = {}
	teleport_client = {}
	rewind_client = {}

	ppos = {}	

	isref = {}
	enter_time = {}
	connect_time = {}

	wait = 0	
	next_tele = 1
	z = 1
	rewind_switch = 0

	for i = 0, (maxclients - 1) do
		own_client[i] = 0
		disarm_client[i] = 0
		isref[i] = 0
		teleport_client[i] = 0
		rewind_client[i] = 0
	end
end


-- called every server frame
function et_RunFrame( levelTime )
 	
	if math.mod(levelTime, samplerate) ~= 0 then return end
	-- for all clients
	for j = 0, (maxclients - 1) do

		-- scans every <samplerate> for refs present
		if et.gentity_get(j, "sess.referee") == 1 then 
			isref[j] = 1
		else
			isref[j] = 0
		end

		-- check to see if client is marked for disarm
		if disarm_client[j] == 1 then		
			for k=1, (et.MAX_WEAPONS - 1), 1 do
	    			if not weapons[k] then
					et.gentity_set(j, "ps.ammoclip", k, 0)
					et.gentity_set(j, "ps.ammo", k, 0)
					--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3runtime\"\n")
				end
			end
		end

		-- check to see if client is marked for teleport
		if teleport_client[j] == 1 then
			next_tele = random_seed[z]
			if z == 60 then
				z = 1
			else
				z = (z+1)
			end
			--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3runtime "  .. next_tele .. "\"\n")

			-- check value of next_tele and impose teleport
			if next_tele == 1 then	
	
      			ppos = et.gentity_get(j, "r.currentOrigin")	--creates ppos[1], ppos[2] and ppos[3] x, y, z
				ppos[3] = (ppos[3] + 250)			
				et.gentity_set(j, "origin",  ppos)

			elseif next_tele == 2 then

     			ppos = et.gentity_get(j, "r.currentOrigin")	
				ppos[1] = (ppos[1] - 500)			
				et.gentity_set(j, "origin",  ppos)

			elseif next_tele == 3 then

     			ppos = et.gentity_get(j, "r.currentOrigin")	
				ppos[2] = (ppos[2] + 500)			
				et.gentity_set(j, "origin",  ppos)

			elseif next_tele == 4 then

     			ppos = et.gentity_get(j, "r.currentOrigin")	
				ppos[1] = (ppos[1] + 500)			
				et.gentity_set(j, "origin",  ppos)

			elseif next_tele == 5 then

     			ppos = et.gentity_get(j, "r.currentOrigin")	
				ppos[2] = (ppos[2] - 500)			
				et.gentity_set(j, "origin",  ppos)

			elseif next_tele == 6 then

     			ppos = et.gentity_get(j, "r.currentOrigin")	--creates ppos[1], ppos[2] and ppos[3] x, y, z
				ppos[3] = (ppos[3] + 500)			
				et.gentity_set(j, "origin",  ppos)

			end

		end

		if rewind_client[j] == 1 then

			--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3runtime "  .. next_tele .. "\"\n")

			-- check value of rewind_switch, 
			if rewind_switch == 0 then	

      			ppos = et.gentity_get(j, "r.currentOrigin")	--creates ppos[1], ppos[2] and ppos[3] x, y, z
				rewind_switch = 1

			elseif rewind_switch == 1 then

				et.gentity_set(j, "origin",  ppos)
				rewind_switch = 0

			end

		end
	end

end

-- called when a client enters the game world
function et_ClientBegin( cno )

	tempname = et.Info_ValueForKey( et.trap_GetUserinfo( cno ), "name" )
	cnoname = et.Q_CleanStr( tempname )

	-- capture the clients enter_time
	enter_time[cno] = et.trap_Milliseconds()
end


-- called on client command
function et_ClientCommand(cno, cmd)	

	-- check to see if wait is active, if so then check for team joins
	if wait == 1 then
		if et.gentity_get(cno, "sess.sessionTeam") == 3 then
			-- check for a team join
			if string.lower(cmd) == "team" then

				--if connect_time < wait_time then deny team join
				time_connected = (et.trap_Milliseconds() - enter_time[cno])
				if time_connected < wait_time_ms then
					et.trap_SendServerCommand(cno, "cp \"^3Sorry, you must wait^5 " .. wait_time_mins ..  " ^3minutes before joining a team.  This is an anti-cheat measure.  Thanks for your patience.\n\" " )
					return 1
				end
			end
		end
	end

		--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3runtime\"\n")
	
	-- check for muted players, and deny them the use of /m and /callvote
	if tonumber(et.gentity_get(cno, "sess.muted")) == 1 then
		if (string.lower(cmd) == "m") then	
			et.trap_SendServerCommand(cno, "cpm \"^1You are muted.  This command is not available to you.\n\" " )
			return 1
		elseif (string.lower(cmd) == "callvote") then
			et.trap_SendServerCommand(cno, "cpm \"^1You are muted.  This command is not available to you.\n\" " )
				-- if the callvote is unmute, assume they are unmuting themselves and gib them (lazy I know)
			--	if string.lower(et.trap_Argv(1)) == "unmute" then			
			--		string.format(et.Info_ValueForKey(et.trap_GetUserinfo(cno), "name"))				
			--		msg = string.format("cpm  \"" .. string.format(et.Info_ValueForKey(et.trap_GetUserinfo(cno), "name")) ..  "^7 got bummed for trying to unmute himself.  What a peon.\n")
			--		et.trap_SendServerCommand(-1, msg)
			--		
			--		--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3unmute\"\n")

			--		et.G_Damage( cno, 80, 1022, 1000, 8, 34 )
			--		--soundindex = et.G_SoundIndex( "/sound/etpro/osp_goat.wav" )	
			--		--et.G_Sound( cno , soundindex )
			--	end
			return 1
		end
	end
	
		--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3runtime "  .. next_tele .. "\"\n")

--------------------------------------------------------------------------------------
-------------------------------REF COMMANDS BELOW HERE--------------------------------
--------------------------------------------------------------------------------------

	-- For ref-only commands, want to ignore anything not coming from a ref
	if et.gentity_get(cno, "sess.referee") == 0 then return 0 end

	-- if command is not say, then 0 end
	if cmd ~= "say" then return 0 end
	
	gwcmd = string.lower(et.trap_Argv(1))

	-- !gwwait command here
	if gwcmd == "!gwwait" then

		--announce !gwwait issued
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3!gwwait command received\"\n")
		if et.trap_Argv(2) == "1" then
			wait = 1
		elseif et.trap_Argv(2) == "0" then
			wait = 0
		end
		--et.trap_SendServerCommand(cno, "cpm \"^3!gwwait = ^5 " .. wait ..  "\" " )
	end

	-- !gwall command here
	if gwcmd == "!gwall" then
	
		--announce !gwall issued
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3!gwall command received\"\n")
	
		x = tonumber(et.trap_Argv(2))
		own_client[x] = 1
		disarm_client[x] = 1
		
	end

	-- !gwtele command here
	if gwcmd == "!gwtele" then

		--announce !gwtele issued
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3!gwtele command received\"\n")

		--if command is "say !gwtele x", where x is the client number, then set teleport_client[x]	
		x = tonumber(et.trap_Argv(2))
		teleport_client[x] = 1

	end

	-- !gwrewind command here
	if gwcmd == "!gwrewind" then

		--announce !gwrewind issued
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3!gwrewind command received\"\n")

		--if command is "say !gwrewind "x", where x is the client number, then set rewind_client[x]	
		x = tonumber(et.trap_Argv(2))
		rewind_client[x] = 1

	end

	-- !gwown command here
	if gwcmd == "!gwown" then

		--announce !gwown issued
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3!gwown command received\"\n")

		--if command is "say !own x", where x is the client number, then set own_client[x]	
		x = tonumber(et.trap_Argv(2))
		own_client[x] = 1

	end

	-- !gwdisarm command here
	if gwcmd == "!gwdisarm" then

		--announce !own issued
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3!gwdisarm command received\"\n")

		--if command is "say !own x", where x is the client number, then set own_client[x]	
		x = tonumber(et.trap_Argv(2))
		disarm_client[x] = 1

	end

	-- !gwresetown command to remove any own_client values
	if gwcmd == "!gwresetown" then

		--announce !gwresetown issued
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3!gwresetown command received\"\n")

		--reset all own_client values to 0
			for i = 0, maxclients - 1 do
				own_client[i] = 0
			end
	end

	-- !gwresetdisarm command to remove any disarm_client values
	if gwcmd == "!gwresetdisarm" then

		--announce !gwresetdisarm issued
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3!gwresetdisarm command received\"\n")

		--reset all disarm_client values to 0
			for i = 0, maxclients - 1 do
				disarm_client[i] = 0
			end
	end

	-- !gwresetall command to remove any own_ and disarm_client values
	if gwcmd == "!gwresetall" then

		--announce !gwresetall issued
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3!gwresetall command received\"\n")

		--reset all own_client values to 0
			for i = 0, maxclients - 1 do
				own_client[i] = 0
				disarm_client[i] = 0
				teleport_client[i] = 0
				rewind_client[i] = 0
			end
	end
	return 0

end

--on a player death, check to see if the killer is flagged up for ownage
function et_Obituary( victim, killer, meansOfDeath )

	-- if the killer is flagged for ownage, then own the bastard
	if own_client[killer] == 1 then

		-- explanation -  et.G_Damage( target, inflictor, attacker, damage, dflags, mod ), mod 0 = unknown
		et.G_Damage( killer, 80, victim, 1000, 8, meansOfDeath )

		-- bring the victim back to life here
		-- note: this doesn't work very well; victim seems to be "dead" hence another kill doesnt register
		-- et.gentity_set(victim, "health", 100)

		-- sends message via qsay, method taken from hadro's anti-sk bot
		msg = "%s ^7just got owned!"
		msg = string.format(msg, et.Info_ValueForKey(et.trap_GetUserinfo(killer), "name"))
		msg = string.format("qsay %s\n", msg)
		et.trap_SendConsoleCommand(et.EXEC_APPEND, msg)

	end
end

-- on client disconnect, empty the values for that slot
function et_ClientDisconnect( cno )
	own_client[cno] = 0
	disarm_client[cno] = 0
	teleport_client[cno] = 0
	rewind_client[cno] = 0
	isref[cno] = 0
end


function et_Print(text)

	if cnoname == nil then return end
	
	cleantext = et.Q_CleanStr( text )

	tempvar1 = string.find(cleantext,"etpro IAC:")
	if tempvar1 then

		tempvar2 = string.find(cleantext, cnoname)
		if tempvar2 then
			--et.G_Print( )
			-- write the string (cleantext) to a file
			
			if etproguid_logging == 1 then
				info = os.date("%x %I:%M:%S%p") .. " " .. cleantext .. "\n"

				fd,len = et.trap_FS_FOpenFile(guidfilename, et.FS_APPEND)
				count = et.trap_FS_Write(info, string.len(info), fd)
				et.trap_FS_FCloseFile(fd)
				fd = nil
			end

			--here we want to send the info to all the refs
			for j = 0, (maxclients - 1) do
				if isref[j] == 1 then
					et.trap_SendServerCommand( j, "cpm \"^3ETPRO GUID =  " .. cleantext ..  "\n\" " )

					-- do the guid tests
					start_index = string.find(cleantext, "GUID [", 1, true)
					end_index = string.find(cleantext, "]", 1, true)
	
					etproguid_start = start_index + 6
					etproguid = string.sub (cleantext, etproguid_start, end_index-1)
					etproguid_length = string.len(etproguid)

					-- length test
					if etproguid_length == 40 then
						for i = 1, 40 do
							hex_test = string.find(etproguid, "%x", i)

							-- hex testing
							if hex_test == nil then
								--flag up the error
								--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^1WARNING: ETPROGUID IS INVALID (HEX ERROR)\"\n")
								et.trap_SendServerCommand( j, "cpm \"^1WARNING: ETPROGUID IS INVALID (HEX ERROR)\n\" " )						
								break
							end
						end
						--et.trap_SendServerCommand( j, "cpm \"^7ETPROGUID OK!\n\" " )
					else
						et.trap_SendServerCommand( j, "cpm \"^1WARNING: ETPROGUID IS INCORRECT LENGTH\n\" " )						
					end

				end
			end
		cnoname = nil
		end		
	end
end

