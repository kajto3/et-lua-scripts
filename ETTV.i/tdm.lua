---------------------------------------
---------       TDM	    -----------
---------  By Necromancer   -----------
---------    07/02/2012     -----------
---------------------------------------


-- Team Death Mach
-- this module prints the number of kills every team has
-- and stop the match at the LIMIT, printing correctly the wining team.
-- reviving a teammate will refund the kill

LIMIT = 25 -- kills limit to reach
PRINT = 1 -- print the status of kills every kill? (0 - disable, 1 - enable)
MINUTES = 2 -- print the status of kills every X minutes, set 0 to disable.
END = 1 -- end the game once the team has reached the LIMIT 
KCHAT = "b 16" -- ô where to print the status every kill. 8 - chat area, 16 - left popup area, 32 - centered above chat area, 64 - console only, 128 - banner area (top screen)
BCHAT = "b 8" -- ô where to print the status every MINUTES. 8 - chat area, 16 - left popup area, 32 - centered above chat area, 64 - console only, 128 - banner area (top screen)
NO_TIME_LIMIT = 1 -- disable the time limit, game ends when one of the teams reaches the LIMIT, set to 0 to disable

-- TODO: random spawn points on LMS (H&S) map scripts

ALLIES = 1
AXIS = 2
ALLIED_KILLS = 0
AXIS_KILLS = 0
et.CS_MULTI_MAPWINNER = 14
BANNER = 0

function et_InitGame( levelTime, randomSeed, restart )
	if NO_TIME_LIMIT > 0 then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "timelimit 0" )
	end
end

function et_RunFrame( levelTime )

	local Gamestate = tonumber(et.trap_Cvar_Get("gamestate"))
	-- we control who wins the game
	if Gamestate == 3 and global_first_intermission == nil then
		global_first_intermission = 1
		
		if ALLIED_KILLS > AXIS_KILLS then -- allies win
			local cs = et.trap_GetConfigstring(et.CS_MULTI_MAPWINNER)
			cs = et.Info_SetValueForKey( cs, "winner", "1" )
			et.trap_SetConfigstring(et.CS_MULTI_MAPWINNER, cs)
			et.trap_SendServerCommand(-1, string.format('%s \"%s"\n',"b 8","^fTDM: ^4Allies ^3WIN! ^4" .. ALLIED_KILLS .. "^3 - ^1" .. AXIS_KILLS ))
		else -- axis win
			local cs = et.trap_GetConfigstring(et.CS_MULTI_MAPWINNER)
			cs = et.Info_SetValueForKey( cs, "winner", "0" )
			et.trap_SetConfigstring(et.CS_MULTI_MAPWINNER, cs)
			et.trap_SendServerCommand(-1, string.format('%s \"%s"\n',"b 8","^fTDM: ^1Axis ^3WIN! ^4" .. ALLIED_KILLS .. "^3 - ^1" .. AXIS_KILLS ))
		end
	end

	if MINUTES > 0 then
		BANNER = BANNER + 1
		if BANNER >= (MINUTES*60*20) then -- minutes * 60 seconds * 20 frames/sec
			BANNER = 0
			et.trap_SendServerCommand(-1, string.format('%s \"%s"\n',BCHAT,"^fTDM: ^4Allies^f:^4 " .. ALLIED_KILLS .. " ^3 - ^1Axis^f:^1 " ..AXIS_KILLS  .. "^f Out of:^3 " .. LIMIT ))
		end
	end
end



function et_Obituary( victim, killer, meansOfDeath )

	if victim == killer then -- self kill

	end

	victimteam = et.gentity_get(victim,"sess.sessionTeam")
	killerteam = et.gentity_get(killer,"sess.sessionTeam")

	if victimteam ~= killerteam and killer ~= 1022 and killer ~= victim then
		
		if killerteam == ALLIES then
			ALLIED_KILLS = ALLIED_KILLS +1
			if END > 0 then
				if ALLIED_KILLS >= LIMIT then -- allies win!
					et.trap_SendConsoleCommand( et.EXEC_NOW, "timelimit 1" )
				end
			end
		elseif killerteam == AXIS then 
			AXIS_KILLS = AXIS_KILLS +1
			if END > 0 then
				if AXIS_KILLS >= LIMIT then -- axis win!
					et.trap_SendConsoleCommand( et.EXEC_NOW, "timelimit 1" )
				end
			end
		end
		if PRINT == 1 then
			et.trap_SendServerCommand(-1, string.format('%s \"%s"\n',KCHAT,"^fTDM: ^4Allies^f:^4 " .. ALLIED_KILLS .. " ^1Axis^f:^1 " ..AXIS_KILLS  .. "^f Out of:^3 " .. LIMIT ))
		end
	end

end

function et_ClientSpawn(slot, revived )
	if revived == 1 then -- refund a ticket to the reviving team
		if et.gentity_get(victim,"sess.sessionTeam") == ALLIES then
			AXIS_KILLS = AXIS_KILLS - 1
		elseif et.gentity_get(victim,"sess.sessionTeam") == AXIS then
			ALLIED_KILLS = ALLIED_KILLS -1
		end
	end
end

