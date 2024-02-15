Modname = "EndMatch"
Version = "1.0"
Author  = "MNwa!"
Description = "^wEnd of Match"
Homepage = "www.gs2175.fastdl.de"
 
--global vars
samplerate = 200
--

function et_InitGame(levelTime,randomSeed,restart)
	et.G_Print("[EndMatch] Version:"..Version.." Loaded\n")
	et.RegisterModname(Modname .. " " .. Version)
	mapname = et.trap_Cvar_Get( "mapname" )
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )   --gets the maxclients
	if gamestate ~= 3 then
		blocker = 0
		blockend = 0
	end
end

function et_RunFrame( levelTime )
local gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
if math.mod(levelTime, samplerate) ~= 0 then return end
 for clientNum = 0, (maxclients - 1) do
	if gamestate == 1 and blockend == 0 then
		Mapstart(clientNum)
		blocker = 0
		blockend = 1
	end
	if gamestate == 3 and blocker == 0 then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref shufflenorestart\n" )
		et.trap_SendServerCommand(-1, "chat \"^1Console: ^.Teams have been shuffled by XP!\"" )
		Mapend(clientNum)
		blockend = 0
		blocker = 1
	end
 end
end

function Mapstart(clientNum)
		if mapname then	--do for all maps
		        et.trap_SendConsoleCommand(et.EXEC_APPEND, "exec \""..mapname..".cfg\n\" ") --exec mapname.cfg
		elseif mapname == "oasis" then	-- do for this map
				et.trap_Cvar_Set( "g_friendlyfire", "1" )	--example
		elseif mapname == "radar" then	-- do for this map
				et.trap_Cvar_Set( "timelimit", "20" )	--example
				et.trap_SendServerCommand(clientNum, "forcecvar r_zfar 5000\n" ) --Disable fog by forcing a client command
		end
end

function Mapend(clientNum)
		if mapname then
		        et.trap_SendConsoleCommand(et.EXEC_APPEND, "exec \""..mapname.."_end.cfg\n\" ") --exec mapname_end.cfg
		elseif mapname == "oasis" then
				et.trap_Cvar_Set( "g_friendlyfire", "0" )
		elseif mapname == "radar" then
				et.trap_Cvar_Set( "timelimit", "30" )
				et.trap_SendServerCommand(clientNum, "forcecvar r_zfar 0\n" )	--reset the command to default
		end
end

-- This could be used too but et_Print seems to be bugged in etpub
--[[
function et_Print(text)
	if text == "Exit: Wolf EndRound." then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref shuffleteamsxp\n" )
		et.trap_SendServerCommand(-1, "chat \"^1Console: ^.Teams have been shuffled by XP!\"" )
	end
end
--]]