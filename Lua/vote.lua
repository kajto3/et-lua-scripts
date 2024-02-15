version = "1.11"
Author  =   "^wMNwa^0!"
Description = "^7disable Vote"
Homepage = "^7www^1.^7gs2175^1.^7fastdl^1.^7de"

--global vars
--the time after votes gets disabled
cancel_time_mins = 2
--the timelenght votes are disabled
cancel_time = 8


function et_InitGame( levelTime, randomSeed, restart )

   et.RegisterModname("vote.lua "..version.." "..et.FindSelf())

   local gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
   
   if gamestate == 0 then   -- GS_PLAYING
      local milliseconds = et.trap_Milliseconds()     
      cancel_time = (milliseconds) + (cancel_time_mins * 60 * 1000)
   end
end


function et_ClientCommand( cno, cmd )

   local gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
   local milliseconds = tonumber(et.trap_Milliseconds())   
   if milliseconds < cancel_time then return 0 end
   
   local entered_command = string.lower(et.trap_Argv(0))
   local entered_argument = string.lower(et.trap_Argv(1))

disable_message = "^wSome ^1votes ^ware ^1disabled ^wafter "..cancel_time_mins.." minutes of playing!"

   if entered_command == "callvote" then
      if entered_argument == "config" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "maprestart" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "gametype" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "campaign" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "map" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "matchreset" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "nextmap" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "pub" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "comp" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "shuffleteamsxp" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "shuffleteamsxp_norestart" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "swapteams" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "timelimit" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end
      if entered_argument == "surrender" and gamestate == 0 then
		et.trap_SendServerCommand(cno, "cp \""..disable_message.."\n\"" )
	  return 1
      end

   end
   
   return 0
   
end