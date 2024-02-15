Version =  "0.3"
Author  =  "Perlo_0ung?!"
Modname =  "Votelimiter"
Homepage = "www.ef-clan.org"

--votes don't go on, it stucks at 1 second

--global vars
cancel_time_mins = 2
samplerate = 1000 --- nicht ändern



---------------------------------------do not change
cancel_timer = cancel_time_mins * 60
max_votes = tonumber(et.trap_Cvar_Get( "vote_limit" ))
-------------------------------------------
function et_InitGame( levelTime, randomSeed, restart )
  	et.G_Print("[Votelimiter] Version:0.3 Loaded\n")
   	et.RegisterModname(Modname .. " " .. Version)

	gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
		vote = {}
   		vote_config = 0
		vote_maprestart = 0
		vote_map = 0
		vote_matchreset = 0
		vote_nextmap = 0	
		vote_surrender = 0
		vote_counter_config = 0
		vote_counter_maprestart = 0
		vote_counter_map = 0
		vote_counter_matchreset = 0
		vote_counter_nextmap = 0	
		vote_counter_surrender = 0
end
function et_RunFrame( levelTime )
	if math.mod(levelTime, samplerate) ~= 0 then return end
		--et.trap_SendServerCommand(-1 , "chat \""..vote_maprestart.."\n\"" )
		--et.trap_SendServerCommand(-1 , "chat \""..vote_counter_maprestart.."\n\"" )
---------------------------------------------------------------------------------------------------------
   		if vote_counter_config > 1 then
		vote_counter_config = vote_counter_config - 1 	
		end
   		if vote_counter_maprestart > 1 then
		vote_counter_maprestart = vote_counter_maprestart - 1 
		end
   		if vote_counter_map > 1 then
		vote_counter_map = vote_counter_map + 1 
		end
   		if vote_counter_matchreset > 1 then
		vote_counter_matchreset = vote_counter_matchreset - 1 
		end
   		if vote_nextmap > 1 then
		vote_counter_nextmap = vote_counter_nextmap - 1 
		end
   		if vote_surrender > 1 then
		vote_counter_surrender = vote_counter_surrender - 1 
		end	
--------------------------------------------------------------------------------------------------------
   		if vote_config == 1 then
		vote_config = vote_config + 1 	
		end
   		if vote_maprestart == 1 then
		vote_maprestart = vote_maprestart + 1 
		end
   		if vote_map == 1 then
		vote_map = vote_map + 1 
		end
   		if vote_matchreset == 1 then
		vote_matchreset = vote_matchreset + 1 
		end
   		if vote_nextmap == 1 then
		vote_nextmap = vote_nextmap + 1 
		end
   		if vote_surrender == 1 then
		vote_surrender = vote_surrender + 1 
		end	
---------------------------------------------------------------------------------------------------------

		if vote_config == (cancel_time_mins * 60) or gamestate == 2 then
		vote_config = 0
		end
   		if vote_maprestart == (cancel_time_mins * 60) or gamestate == 2  then
		vote_maprestart = 0
		end
   		if vote_map == (cancel_time_mins * 60) or gamestate == 2 then
		vote_map = 0 
		end
   		if vote_matchreset == (cancel_time_mins * 60) or gamestate == 2 then
		vote_matchreset = 0 
		end
   		if vote_nextmap == (cancel_time_mins * 60) or gamestate == 2 then
		vote_nextmap = 0
		end
   		if vote_surrender == (cancel_time_mins * 60) or gamestate == 2 then
		vote_surrender = 0 
		end	
	end
	
function et_ClientCommand( cno, cmd ) 
	local entered_command = string.lower(et.trap_Argv(0))
	local entered_argument = string.lower(et.trap_Argv(1))
   if entered_command == "callvote" then
   if tonumber(et.gentity_get(cno, "pers.voteCount")) >= max_votes then return end
      if entered_argument == "config" then
		if vote_config == 0 then
			vote_config = 1
			vote_counter_config = cancel_timer
		elseif vote_config > 1 then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay ^7Voting has been disabled! To vote again wait ^1"..vote_counter__config.." ^7seconds\n")
		end
	  end
	  
      if entered_argument == "maprestart" then
   		if vote_maprestart == 0 then
	      vote_maprestart = 1
	      vote_counter_maprestart = cancel_timer
		elseif vote_maprestart > 1 then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay ^7Voting has been disabled! To vote again wait ^1"..vote_counter_maprestart.." ^7seconds\n")
		end
	  end
	  
      if entered_argument == "map" then
	    if vote_map == 0 then
		vote_map = 1
		vote_counter_map = cancel_timer
		elseif vote_map > 1 then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay ^7Voting has been disabled! To vote again wait ^1"..vote_counter_map.." ^7seconds\n")
	      end
     end
      if entered_argument == "matchreset" then
	    if vote_matchreset == 0 then
		vote_matchreset = 1
		vote_counter_matchreset = cancel_timer
		elseif vote_matchreset > 1 then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay ^7Voting has been disabled! To vote again wait ^1"..vote_counter_matchreset.." ^7seconds\n")
      end
     end
      if entered_argument == "nextmap" then
	    if vote_nextmap == 0 then
		vote_nextmap = 1
		vote_counter_nextmap = cancel_timer
		elseif vote_nextmap > 1 then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay ^7Voting has been disabled! To vote again wait "..vote_counter_nextmap.." ^7seconds\n")
      end
     end
 
      if entered_argument == "surrender" then
	   if vote_surrender == 0 then
		vote_surrender = 1
		vote_counter_surrender = cancel_timer
		elseif vote_surrender > 1 then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay ^7Voting has been disabled! To vote again wait "..vote_counter_surrender.." ^7seconds\n")
      end
     end

   end
   end