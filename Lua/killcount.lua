--global vars
Author  = "MNwa!"
Homepage = "www.gs2175.fastdl.de"
Modname = "Killcount"
Version = "0.1"
samplerate = 1000
killamount = {}
--
function et_InitGame(levelTime,randomSeed,restart)
	et.G_Print("["..Modname.."] Version:"..Version.." Loaded\n")
	et.RegisterModname(Modname .. " " .. Version) -- /lua_status
	gamestate = tonumber(et.trap_Cvar_Get( "gamestate" )) -- get the gamestate -> warmup, match, matchend
	sv_maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients")) -- get the command sv_maxclients
	for i=0, sv_maxclients-1 do
		killamount[i] = 0 -- set killamount to 0 so it can be counted
	end
end

function et_Obituary( victim, killer, meansofdeath )
 if gamestate == 0 then --only do it ingame (no warmup or matchend)
	if killer ~= 1022 and killer ~= 1023 and meansofdeath ~= 37 and meansofdeath ~= 64 then -- no world / unknown kills / selfkill / team switch
		killamount[killer] = killamount[killer] + 1 -- count +1
	end
	
	if killamount[killer] == 1 then -- if 1 kill then do something
		et.trap_SendServerCommand(killer,"chat \"^wDebug ^11^z: "..killamount[killer].." kill \"")
	end
	
	if killamount[killer] >= 2 then -- if 2 kills or more then do something
		et.trap_SendServerCommand(killer,"chat \"^wDebug ^12^z: "..killamount[killer].." kills \"")
	end
 end -- end the gamestate
end -- end the et_Obituary