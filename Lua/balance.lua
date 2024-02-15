modname = "balance"
version = "0.2"

function et_InitGame(levelTime,randomSeed,restart)
	et.RegisterModname(modname .. " " .. version)
	
	gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
end

unevenDiff = 2
max_unevenTime = 20
max_unevenDiff = 4

axisPlayers = {}
alliedPlayers = {}
unevenTime = -1

function et_RunFrame( levelTime )
   if gamestate == 3 then return end
   local numAlliedPlayers = table.getn( alliedPlayers )
   local numAxisPlayers = table.getn( axisPlayers )
   if numAlliedPlayers >= numAxisPlayers + max_unevenDiff then
      local clientNum = alliedPlayers[ numAlliedPlayers ]
      et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref putaxis " .. clientNum .. " r" )
	  et.trap_SendServerCommand(-1, "chat \"balancing teams... " .. et.gentity_get( clientNum, "pers.netname" ) .. "^7 moved to ^1AXIS\"" ) 
   elseif numAxisPlayers >= numAlliedPlayers + max_unevenDiff then
      local clientNum = axisPlayers[ numAxisPlayers ]
      et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref putallies " .. clientNum .. " b" )
	  et.trap_SendServerCommand(-1, "chat \"balancing teams... " .. et.gentity_get( clientNum, "pers.netname" ) .. "^7 moved to ^4ALLIES\"" ) 
   elseif numAlliedPlayers >= numAxisPlayers + unevenDiff then
      if unevenTime > 0 then
         if tonumber( levelTime ) - unevenTime >= max_unevenTime * 1000 then
            local clientNum = alliedPlayers[ numAlliedPlayers ]
            et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref putaxis " .. clientNum .. " r" )
			et.trap_SendServerCommand(-1, "chat \"balancing teams... " .. et.gentity_get( clientNum, "pers.netname" ) .. "^7 moved to ^1AXIS\"" ) 
         end
      else
         unevenTime = tonumber( levelTime )
      end
   elseif numAxisPlayers >= numAlliedPlayers + unevenDiff then
      if unevenTime > 0 then
         if tonumber( levelTime ) - unevenTime >= max_unevenTime * 1000 then
            local clientNum = axisPlayers[ numAxisPlayers ]
            et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref putallies " .. clientNum .. " b" )
			et.trap_SendServerCommand(-1, "chat \"balancing teams... " .. et.gentity_get( clientNum, "pers.netname" ) .. "^7 moved to ^4ALLIES\"" ) 
         end
      else
         unevenTime = tonumber( levelTime )
      end
   else
      unevenTime = -1
   end
end

function et_ClientSpawn( clientNum, revived, teamChange, restoreHealth )
   if teamChange ~= 0 then
      local team = tonumber( et.gentity_get( clientNum, "sess.sessionTeam" ) )
      -- these were the teamnumbers prior to the move
      local numAlliedPlayers = table.getn( alliedPlayers )
      local numAxisPlayers = table.getn( axisPlayers )
      if team == 1 then
         for i, num in ipairs( alliedPlayers ) do
            if num == clientNum then
               table.remove( alliedPlayers, i )
               break
            end
         end
         -- this should not happen but still check for it to avoid doubles
         for i, num in ipairs( axisPlayers ) do
            if num == clientNum then
               return
            end
         end
         -- make sure a player who (got) moved when teams were uneven doesn't get moved right back
         if numAlliedPlayers >= numAxisPlayers + unevenDiff then
            table.insert( axisPlayers, 1, clientNum )
         else
            table.insert( axisPlayers, clientNum )
         end
      elseif team == 2 then
         for i, num in ipairs( axisPlayers ) do
            if num == clientNum then
               table.remove( axisPlayers, i )
               break
            end
         end
         for i, num in ipairs( alliedPlayers ) do
            if num == clientNum then
               return
            end
         end
         if numAxisPlayers >= numAlliedPlayers + unevenDiff then
            table.insert( alliedPlayers, 1, clientNum )
         else
            table.insert( alliedPlayers, clientNum )
         end
      else
         for i, num in ipairs( alliedPlayers ) do
            if num == clientNum then
               table.remove( alliedPlayers, i )
               return
            end
         end
         for i, num in ipairs( axisPlayers ) do
            if num == clientNum then
               table.remove( axisPlayers, i )
               return
            end
         end
      end
   end
end

function et_ClientDisconnect( clientNum )
   for i, num in ipairs( alliedPlayers ) do
      if num == clientNum then
         table.remove( alliedPlayers, i )
         return
      end
   end
   for i, num in ipairs( axisPlayers ) do
      if num == clientNum then
         table.remove( axisPlayers, i )
         return
      end
   end
end