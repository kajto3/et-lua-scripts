--------------------------------------------------------------------------------
-- ETW_Mines -- Set the number of mines according to number of players
-- created by [ETW-FZ] Schnoog (http://etw-funzone.eu/)
--------------------------------------------------------------------------------
-- This script can be freely used and modified as long as [ETW-FZ] and the 
-- original authors are mentioned.
--------------------------------------------------------------------------------
--
--
--
--
--


--*************************************************************************
-- global variables (initialization
--*************************************************************************
players = 0 -- current number of players
mines   = 0 -- current number of max. allowed mines per tea

--*************************************************************************
-- message functions
--*************************************************************************
function printConsole(id, message) -- prints a message to the console
  et.trap_SendServerCommand(id, "print \"" .. message .. "\n\"")
end

function printChat(id, message) -- prints a message to the chat
  et.trap_SendServerCommand(id, "chat \"" .. message .. "\"")  
end

function printCenter(id, message) -- prints a message to the center
  et.trap_SendServerCommand(id, "cp \"" .. message .. "\"")
end

function printBanner(id, message) -- prints a message to the center
  et.trap_SendServerCommand(id, "bp \"" .. message .. "\"")
end

--*************************************************************************
-- change number of landmines
--*************************************************************************
function setMaxMines() -- sets the number of max. allowed landmines
  
  if players > 8 then
    maxmines = 15
  elseif players > 6 then
    maxmines = 10
  elseif players > 4 then
    maxmines = 8
  else
    maxmines = 5
  end

  if mines ~= maxmines then
    et.trap_Cvar_Set("team_maxmines", maxmines)
	printConsole(-1, "Max. " .. maxmines .. " mines allowed.")
	mines = maxmines
  end
end

--*************************************************************************
-- player connecting
--*************************************************************************
function et_ClientConnect(id, firstTime, isBot) -- is called when a client connects
  players = players + 1
  setMaxMines()
end

--*************************************************************************
-- player disconnection
--*************************************************************************
function et_ClientDisconnect(id) -- client disconnects
  players = players - 1
  setMaxMines()
end
