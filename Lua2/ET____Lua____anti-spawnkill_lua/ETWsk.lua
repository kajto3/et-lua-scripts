--------------------------------------------------------------------------------
-- ETWsk - ETW-FZ Enemy Territory Anti-Spawnkill Mod for etpro
--------------------------------------------------------------------------------
-- This script can be freely used and modified as long as [ETW-FZ] and the 
-- original author are mentioned.
--------------------------------------------------------------------------------
module_name    = "ETWsk"
module_version = "0.8"
Author         = "[ETW-FZ] Mad@Mat , Editor [ETW-FZ] schnoog"
--------------------------------------------------------------------------------
-- DESCRIPTION
--------------------------------------------------------------------------------
-- ETWsk aims to reduce spawnkilling (SK) on public funservers. An SK here is if
-- someone kills an enemy near a fix spawn point. A fix spawn point means that
-- it can not be cleared by the enemy. E.g. on radar map, the allied Side Gate 
-- spawn is not fix as the axis can destroy the command post. However, the Main
-- Bunker spawn is fix after the Allies have destroyed the Main Gate. ETWsk does
-- not prevent but it detects and counts SKs for every player. If a player has
-- caused a certain number of SKs, he gets punished (putspec, kick, ban, ...).
-- As the detection of fix spawns is difficult especially on custom maps, little
-- configuration work has to be done.
--
-- Features:
--     - circular protection areas around spawn points
--     - two protection radius can be defined: heavy weapons and normal weapons
--     - the spawn protection expires when a player hurts an enemy
--       (can be disabled)
--     - fully configurable for individual maps: fixing radius, positions;
--       adding actions that change protected areas during the game; adding new
--       protection areas.
--     - client console commands for stats and help for configuration
--     - no RunFrame() -> low server load
--------------------------------------------------------------------------------
-- CONFIG
--------------------------------------------------------------------------------
ETWsk_putspec = 3                -- number of sk's needed for setting a client
                                 -- to spectators
ETWsk_kick = 4                   -- number of sk's needed for kicking a client
ETWsk_kicklen = 5                -- duration of kick
ETWsk_defaultradius1 = 400       -- protection radius for ordinary weapons
ETWsk_defaultradius2 = 800       -- protection radius for heavy weapons
ETWsk_savemode = 1               -- if enabled, protection is only active on
                                 -- maps that are configured
ETWsk_expires = 1                -- if enabled, spawn protection expires when
                                 -- the victim hurts an enemy
ETWsk_MapConfigFolder = "mapSpawns" --Subfolder for the map configurations e.g. mapSpawns for /etpro/mapSpawns
--------------------------------------------------------------------------------
heavyweapons = {17,27,57,30}     -- heavy weapon indexes 
                                 -- (pf, mortar, airstrike, arty)
maxcheckpointdist = 800          -- used to detect capturable flag poles
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- CONSTANTS
NO_PROTECT     = 0
PROTECT_AXIS   = 1
PROTECT_ALLIES = 2
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function getConfig(map)
--------------------------------------------------------------------------------
-- configures protection of spawn areas in specific maps
--------------------------------------------------------------------------------
--	elseif map == "<the map name>" then
--		<spawn definitions>
--		<action definitions>
--------------------------------------------------------------------------------
-- spawn definitions:
--      c.spawn[<spawn-num>] = {<spawn-fields>}
-- spawn-num: spawn index (see /etwsk_spawns command)
-- spawn-fields: - comma-separated list of "key = value"
--               - for existing spawns all fields are optional (they overwrite
--                 default values).
--               - fields:
--                     name = <String>  : name of spawn point
--                     state = NO_PROTECT|PROTECT_ALLIES|PROTECT_AXIS
--                     pos = {x,y,z}    : map coordinates of spawn point 
--                     radius1 = <Int>  : protection radius for normal weapons
--                     radius2 = <Int>  : protection radius for heavy weapons
-- action definitions: actions are definitions of transitions of one state of a
--                     spawn point into another one triggered by a message.
--      c.action[<action-num>] = {<action-fields>}
-- action-num: just an increment number
-- action-fields: - comma-separated list of "key = value"
--                - all fields are mandatory
--                - fields:
--                     spawn = <spawn-num>
--                     newstate = NO_PROTECT|PROTECT_ALLIES|PROTECT_AXIS
--                     trigger = <String>: part of a message that is displayed
--                                         by the server on a specific event.
-- adding new protection areas to maps:
--     new protection areas can easily been added:
--     1. enter the map and walk to the location where you want to add the area
--     2. type /etwsk_spawns and remember the highest spawn index number
--     3. type /etwsk_pos and write down the coordinates
--     4. add spawn to config with at least the name,state and pos field to a text
--To do this, create an empty text file and add the following lines:
-----------------Begin of map config
--local c = {spawns = {}, actions = {}, defaults = true}
-- --define your spawns here--
--return c
-----------------End of map config
--and save the file as "mapname.lua" in your ETWsk_MapConfigFolder
-- default values:
--     At mapstart, ETWsk scans for all spawnpoints and sets the state either to
--     PROTECT_ALLIES or PROTECT_AXIS. It also scans for capturable flag poles
--     and sets the state of a spawnpoint near a flag pole to NO_PROTECT. The
--     location of a spawnpoint is taken from the WOLF_objective entity, the
--     small spawn flag that can be selected in the command map. This entity is
--     usually placed in the center of the individual player-spawnpoints.
--     However, on some maps this is not the case. Check the positions of the
--     small spawn flags on the command map or type /etwsk_pos after you have
--     spawned to check the distance to protected areas. If needed, adjust the 
--     radius, or the pos or add a new protection area to the map.
--     If you wish to set all protection areas manually in a map, add:
--         c.defaults = false
--     to the definitions for a map.
--------------------------------------------------------------------------------
	--hier testen ob datei (etpro/mapsk/map.lua) existiert = hasconfig
	--wenn existiert auslesen und in c speichern
	--aus ETAsk:  dofile(et.trap_Cvar_Get("fs_homepath") .. '/etpro/mapSpawns/ETAsk.lua')
local c = {spawns = {}, actions = {}, defaults = true}
file = ETWsk_MapConfigFolder .. "/" .. map .. ".lua"
fd,len = et.trap_FS_FOpenFile(file, et.FS_READ)
    if len == -1 then
        strm = " ^2Sorry, no spawn configuration found for this map (^4" .. map .. "^2)..ETWsk disabled"
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "say" .. strm)
        hasconfig = false 
    else
        --et.trap_SendConsoleCommand(et.EXEC_APPEND, "say konfig" .. file .. " gefunden")
        hasconfig = true 	
	et.trap_FS_FCloseFile(fd)
    	--dofile(et.trap_Cvar_Get(file))
    	loadfile(et.trap_Cvar_Get(file))
--    	dofile(et.trap_Cvar_Get("fs_homepath") .. '/etpro/' .. file)
--		loadfile(et.trap_Cvar_Get("fs_homepath") .. '/etpro/' .. file)
    end

return c
end


--------------------------------------------------------------------------------
-- called when client types a command like "/command" on console
function et_ClientCommand(cno, command) 
--------------------------------------------------------------------------------
-- commands: 
--     etwsk        : prints mod info and current spawnkill statistics
--     etwsk_spawns : prints list of spawnpoints with current state
--     etwsk_pos    : prints current position and distances to protected spawns
--------------------------------------------------------------------------------
    local cmd = string.lower(command) 
    if cmd == "etwsk_spawns" then 
        --et.trap_SendConsoleCommand(et.EXEC_APPEND, "say aaaaaaaaaaaaaaaaaaaaaaaaa")
		printSpawns(cno)
        return 1 
    elseif cmd == "etwsk_pos" then
        printPos(cno)
        return 1
    elseif cmd == "etwsk" then
        printStats(cno)
        return 1
    end 
    return 0 
end 

--------------------------------------------------------------------------------
-- calculates the distance
-- note: not true distance as hight is doubled. So the body defined by constant
--       distance is not a sphere, but an ellipsoid
function calcDist(pos1, pos2)
--------------------------------------------------------------------------------
	local dist2 = (pos1[1]-pos2[1])^2 + (pos1[2]-pos2[2])^2 
                  + ((pos1[3]-pos2[3])*2)^2
    return math.sqrt(dist2)
end
    
--------------------------------------------------------------------------------
-- called at map start
function et_InitGame( levelTime, randomSeed, restart)
--------------------------------------------------------------------------------
    local modname = string.format("%s v%s", module_name, module_version)
    et.G_Print(string.format("%s loaded\n", modname))
    et.RegisterModname(modname)

    mapname = et.trap_Cvar_Get("mapname")
    c = getConfig(mapname)
	
    damagegiven = {}
    spawnkills = {}
    
    local checkpoints = {}
    -- find capturable flag poles
    for i = 64, 1021 do
        if et.gentity_get(i, "classname") == "team_WOLF_checkpoint" then			
            table.insert(checkpoints,i)
        end
    end
	-- complete config with default extracted values
    local spawn = 1
    for i = 64, 1021 do
        if et.gentity_get(i, "classname") == "team_WOLF_objective" then
		local pos = et.gentity_get(i, "origin");
    		if c.spawns[spawn] == nil then 
			c.spawns[spawn] = {} end
		if c.spawns[spawn].name == nil then 
			c.spawns[spawn].name = et.gentity_get(i, "message") end
		if c.spawns[spawn].pos == nil then 
			c.spawns[spawn].pos = et.gentity_get(i, "origin") end
		if c.spawns[spawn].state == nil then 
			local iscapturable = false
			for k,v in pairs(checkpoints) do
            			local cp = et.gentity_get(v, "origin")
				if(calcDist(c.spawns[spawn].pos, cp) <= 
				  maxcheckpointdist) then
					iscapturable = true
				end
			end
			if iscapturable then
				c.spawns[spawn].state = NO_PROTECT
			else
				c.spawns[spawn].state = et.G_GetSpawnVar(i, "spawnflags")
			end
		end
		if c.spawns[spawn].radius1 == nil then
			c.spawns[spawn].radius1 = ETWsk_defaultradius1 end
		if c.spawns[spawn].radius2 == nil then 
			c.spawns[spawn].radius2 = ETWsk_defaultradius2 end
		spawn = spawn + 1
        end
    end
    -- auto complete spawns
    for i,spawn in pairs(c.spawns) do
	if spawn.radius1 == nil then
		spawn.radius1 = ETWsk_defaultradius1 end
	if spawn.radius2 == nil then
		spawn.radius2 = ETWsk_defaultradius2 end
    end
end

--------------------------------------------------------------------------------
-- called when something is printed on server console
function et_Print(text)
--------------------------------------------------------------------------------
	if(c == nil) then return end
	for i,action in pairs(c.actions) do
		if(string.find(text, action.trigger)) then
			local msg
			if action.newstate == NO_PROTECT then 
            	msg = "is no longer protected!"
            else msg = "is now protected!"
            end
	c.spawns[action.spawn].state = action.newstate
            et.trap_SendServerCommand(-1, "cpm \"^4ETW^2sk: The ^4"..
				c.spawns[action.spawn].name.." Spawn ^2"..msg.."\n\"")
		end	
	end
end

--------------------------------------------------------------------------------
-- called when client enters the game
function et_ClientBegin(cno)
--------------------------------------------------------------------------------
    -- reset spawnkills
    spawnkills[cno] = nil
end

--------------------------------------------------------------------------------
-- called when client spawns
function et_ClientSpawn(cno, revived )
--------------------------------------------------------------------------------
    if (hasconfig and revived == 0) then
        damagegiven[cno] = et.gentity_get(cno, "sess.damage_given")
	if(damagegiven[cno] == nil) then damagegiven[cno] = 0 end
    end
end

--------------------------------------------------------------------------------
function printSpawns(cno)
--------------------------------------------------------------------------------
    if not hasconfig then
        et.trap_SendServerCommand(cno, 
			"print \"^4ETW^2sk:^7 no config for this map!\n\"")
		if ETWsk_savemode == 1 then
	        et.trap_SendServerCommand(cno, 
				"print \"^4ETW^2sk:^7 protection deactivated (savemode)!\n\"")
		end
    end
    local protect = {}
    protect[0] = "NO_PROTECT"
    protect[1] = "^1PROTECT_AXIS"
    protect[2] = "^4PROTECT_ALLIES"
    if cno >= 0 then 
        et.trap_SendServerCommand(cno, 
			"print \"^4ETW^2sk:^7 Mapname: ^3"..mapname.."\n\"")
    end  
    for i,spawn in pairs(c.spawns) do
        if cno == -1 then et.G_Printf(
			"ETWsk> Spawn %d \"%s\" %s \n", i, spawn.name, protect[spawn.state])
        else et.trap_SendServerCommand(cno, "print \"^4ETW^2sk:^7 Spawn ^3"..
			i.."^7 "..spawn.name.." "..protect[spawn.state].."\n\"")
		end
    end
end

--------------------------------------------------------------------------------
function printPos(cno)
--------------------------------------------------------------------------------
    local pos = et.gentity_get(cno, "r.currentOrigin")
    local spos = string.format('%d, %d, %d',
		unpack(pos))
    et.trap_SendServerCommand(cno, 
		"print \"^4ETW^2sk:^7 current pos: "..spos.."\n\"")
    local team = et.gentity_get(cno, "sess.sessionTeam")
    local protect_normal = "^2protected_normal"
    local protect_heavy = "^2protected_heavy_only"
    for i,spawn in pairs(c.spawns) do
	local protect = "^1not protected"
        if spawn.state == team then
            local dist = calcDist(pos, spawn.pos)
            if dist < spawn.radius1 then 
				protect = protect_normal
            elseif dist < spawn.radius2 then
				protect = protect_heavy
			end
            et.trap_SendServerCommand(cno, string.format(
                "print \"^4ETW^2sk:^7 spawn ^3%d (%s): %s ^7distance: %d \n\"",
                i, spawn.name, protect, dist))
        end
    end     
end

--------------------------------------------------------------------------------
function printStats(cno)
--------------------------------------------------------------------------------
    et.trap_SendServerCommand(cno, "print \"^4ETW^2sk ^7v"..module_version ..
		" spawnkill protection by ^2[^4ETW^2-^4FZ^2] ^4Mad^2@^4Mat^7^, modified by ^2[^4ETW^2-^4FZ^2] ^2Schn^4oo^2g^7.\n\"")
    for killer,kills in pairs(spawnkills) do
        local killername = 
			et.Info_ValueForKey(et.trap_GetUserinfo(killer), "name")
        et.trap_SendServerCommand(cno, 
			"print \"       "..kills.." SKs: "..killername.."\n\"")
    end     
end

--------------------------------------------------------------------------------
-- called when someone has been killed
function et_Obituary(victim, killer, meansOfDeath)
--------------------------------------------------------------------------------
    -- same team
    -- et.trap_SendServerCommand(-1, "print \"SK: "..victim.." "..killer.."\n\"")
    local vteam = et.gentity_get(victim, "sess.sessionTeam")
    if( vteam == et.gentity_get(killer, "sess.sessionTeam")) then return end
    -- protection expired ?
    if ETWsk_expires == 1 then
	   local vdg = 0
	   vdg = et.gentity_get(victim, "sess.damage_given")
           -- et.G_Printf("vdg = %d, dg = %d\n", vdg, damagegiven[victim])
           if(vdg ~= nil and vdg > damagegiven[victim]) then return end
    end
    -- was heavyweapon?
    local isheavy = false
    for k,v in pairs(heavyweapons) do
        if (meansOfDeath == v) then isheavy = true end
    end
    -- protected spawn?
    local vpos = et.gentity_get(victim, "r.currentOrigin")
    local isprotected = false
    local dist2
    local radius2
    for i,spawn in pairs(c.spawns) do
        if spawn.state == vteam then
            if(isheavy) then
                radius2 = spawn.radius2
            else
                radius2 = spawn.radius1
            end
            dist = calcDist(vpos, spawn.pos)
			if(dist < radius2) then
                ClientSpawnkill(victim, killer, isheavy)
			end
        end
    end
end

--------------------------------------------------------------------------------
-- called when ETWsk has detected a spawnkill
function ClientSpawnkill(victim, killer, isheavy)
--------------------------------------------------------------------------------
    if killer < 0 or (ETWsk_savemode == 1 and not hasconfig) then return end
    if spawnkills[killer] == nil then spawnkills[killer] = 0 end
    spawnkills[killer] = spawnkills[killer] + 1
    local numsk = spawnkills[killer]
    local killername = et.Info_ValueForKey(et.trap_GetUserinfo(killer), "name")
    et.trap_SendServerCommand(-1, "cpm \"^4ETW^2sk: ^1WARNING: ^2Spawnkill (#"..
		numsk..") by "..killername.."\"\n" )
    et.trap_SendServerCommand(killer, "cp \""..killername.." : ^1DO NOT SPAWNKILL!!! \"\n")
    if(numsk >= ETWsk_putspec and numsk < ETWsk_kick) then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "ref remove "..killer.."\n")                
        et.trap_SendServerCommand(-1, "cpm \"^4ETW^2sk: ^0"..killername..
			" ^2was set to Spectators - too many Spawnkills!\"\n")
    elseif(numsk >= ETWsk_kick) then
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "pb_sv_kick \""..killername.."\" "..ETWsk_kicklen.." \"too many spawnkills!\"\n") 
	et.trap_SendServerCommand(-1, "cpm \"^4ETW^2sk: ^0"..killername..
			" ^2has been kicked - too many Spawnkills!\"\n")
    else
	et.gentity_set(killer, "health", -511)
    end
   
end

--------------------------------------------------------------------------------
-- printf wrapper
function et.G_Printf(...)
--------------------------------------------------------------------------------
    et.G_Print(string.format(unpack(arg)))
end
