Version =  "0.2b"
Author  =   "Perlo_0ung?!"
Homepage = "www.ef-clan.org"
Description = "Speedcup team blocker"

---global vars------------------------------------------
samplerate = 500
-----------------------------------------------------------------------------
--Note: do not use setl g_doWarmup or luamod will not work correctly --------
-----------------------------------------------------------------------------

function et_InitGame(levelTime,randomSeed,restart)
	playercount = 0
	pflood = 1
	mclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
	gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))	
	et.RegisterModname("team-blocker:".. Version .."")
	if gamestate == 0 then  --GS_PLAYING
		et.trap_Cvar_Set( "g_doWarmup", "0" ) --prevent game reset when moved to spec
	elseif gamestate == 2 then  -- GS_WARMUP
		et.trap_Cvar_Set( "g_doWarmup", "1" ) --prevent game reset when moved to spec
	end
	
end

function countPlayers(target)  --count playing players on server 
	local team = tonumber(et.gentity_get(target, "sess.sessionTeam"))
         if team == 1 or team == 2 then
            playercount = playercount + 1
      end   
 end 


function et_ClientCommand(clientNum, command) --on client command 
   if string.lower(command) == "team" then			--team join command
	et.gentity_set(clientNum,"sess.latchPlayerType",2)	-- force to spawn engineer next spawn
	        for cno = 0, mclients - 1 do   			-- for all players
			countPlayers(cno) 	   			-- count number of players
		 end
	if et.trap_Argv(1) == "b" or et.trap_Argv(1) == "r" then 	-- join b=allies or r=axis
	if playercount > 0 then 
           et.trap_SendServerCommand(clientNum, "chat \"^7Please wait until ur on the row!\n\" " )
	return 1   -- prevents team join
	end
   end
  end
  playercount = 0   	 --set number of counted players to 0
  return 0 -- allwos the command
end



function et_RunFrame( levelTime ) 
if math.mod(levelTime, samplerate) ~= 0 then return end
	if tonumber(et.trap_Cvar_Get( "gamestate" )) == 3 then   -- GS_INTERMISSION
	   if tonumber(et.trap_Cvar_Get( "g_currentRound" )) == 1 then --STOPWATCH ROUND 1
		if pflood == 1 then  		
     		   et.trap_SendServerCommand(-1, "chat \"^7Time has been set! Please switch teams!\n\" " )
		pflood = 0 
	   end
	end
	for cno = 0, mclients - 1 do -- for all players
	local team = tonumber(et.gentity_get(cno, "sess.sessionTeam"))  
           if team == 1 or team == 2 then   --- check team of player
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref remove " .. cno .. "\n" )  -- move spec
	    end
	end
   end
end