-- KMOD+ By Necromancer
-- 11/4/2008



-- TODO: player track facility
-- for each player there will be a file in kmod+/players/player_guid.dat
-- the file will contain:
-- [alias]
-- [ips]
-- [warning]
-- when a player joins, either a new file is created (if new player) or its info is loaded.
-- need to update the info of the players when a player changes his name or gets a warning.
-- on join if there's new ip.




-- TODO: full shrubbot.cfg support (shrubET/ETpub style) - not sure its necessery and worth it, i find the commands string alot easier to use
-- TODO: rework ETadmin_mod to work based on SLAC/TZAC userID
-- TODO: stat saver - save number of kills,deaths, and headshots. 

-- MIGHT-DO: awardSave (XPsave) with et_UpgradeSkill( slot, skill ) 
-- and et_SetPlayerSkill( slot, skill ) 

--TODO: pb_sv_plist -> ac_sv_listplayers 
-- guid_spoof_check only if PB enabled
-- function pb_line(line) -> to parse TZAC's lines, guids, names, and ac_sv_listplayers

--TODO: throw guid_age + slac_name over nextmap/restart (using ghost table)
-- dump the guid_age and slac_name into the player.dat file, using TDB

--TODO: ET:Ask warns players using kmod+
--TODO: !warn (test)

--TODO: random rotation
---- cvar stores all .bsp's played in the rotation
---- comparing between the cvar to the rotation to determine random played maps.


--[[#######################################################################
############################ change log ###################################
###########################################################################

0.6.0

	

	** 28/07/2012  # fixed: rotation will assume end-of-last-map number of players for the first 30 seconds after map change.
	** 27/07/2012  # fixed: rotation didn't play maps with min_players > 0
	** 27/07/2012  # fixed: player tracker error due to no guid
	** 25/07/2012  # fixed: heavy weapon restriction didn't check grenade launcher availability.
	** 20/07/2012  # fixed: error on kill when the killer has already disconnected (artillery, grenade etc..)
	** 18/07/2012  # fixed: destorying player table before writing ignores, or player tracker on clientDisconnect.
	** 18/07/2012  # fixed: missing field on FEAR team damage sound
	** 18/07/2012  # fixed: error on players with killing spree, deing from world (cursh, fall, killer = 1022)
	** 18/07/2012  # fixed: if no rotation maps were found on map start, an error were generated on client connect.
	** 06/07/2012  # fixed: check for unset nextmap added.
	** 06/07/2012  # fixed: revised some functions
	** 04/07/2012  # fixed: KNOD+ typo
	** 04/07/2012  # changed: disabled greetings for bots (both message and sound)
	** 03/07/2012  # fixed: FEAR sounds incorrect condition generating error.
	** 03/07/2012  # deprecated: greeting substitute of [level] by level's name. 
	** 29/06/2012  # fixed: a non-numrical sv_privateclients would cause an et_RunFrame error.
	** 27/06/2012  # changed: KMOD+ rotation cvars, also changed and extended !rotation and !map commands
	** 25/06/2012  # fixed: cure_punish should now mute players on NoQuarter mod.
	** 25/06/2012  # fixed: added MOD[] values for NoQuarter mod, chat prints should now work. 	
	** 01/06/2012  # fixed: not showing level 0 greetings. added global_players_table[slot]["level"] field.
	** 09/05/2012  # fixed: !setlevel client on TZAC server, where the client had PB guid, the PB guid was used instead of the TZAC one
	** 09/05/2012  # fixed: admins with guid UNKNOWN should not be written/loaded anymore.
	** 09/05/2012  # added: KMOD+ map rotation
	** 08/05/2012  # added: some more documantry to the readme file and kmod+.cfg configuration file about kmod+ cvars and commands
	** 19/04/2012  # fixed: force names now works
	** 19/04/2012  # fixed: warnings now works
	** 12/04/2012  # fixed: newTDB() - removeList() will now delete an empty list.

	commands:
		admin commands added: force, warn
		added: fortune command. fortune cookie must be installed on the server.
		added: whale client fun commands: flipcoin,pizza,coke,coffee,cookie 
		added: every admin command now has description, syntax, and version at the top of the file.

0.5.7
	** 20/02/2012  # add TZAC support: kmod+ now gets the guid age from TZAC
	** 17/02/2012  # fixed TZAC issues
	** 17/02/2012  # added hardcoded fear sounds
	** 02/02/2012  # added heavy weapon restrictions (panzer,flamer,mg42,mortar,mines)
	** 8/20/2011   # added ban support on tzac enabled server
	** 8/19/2011   # revised  core functions and some commands to relay on global_players_table[slot]["guid"] instead of the mod's cl_guid
	** 8/14/2011   # added slac/tzac support, if pb is disabled, player[guid] is the slac/tzac user ID number.


0.5.5
	** 7/2/2009   # added updated kmod+.lua - some forcecvar to make users see the commands output and log in the console
	** 7/2/2009   # fixed doesnt work: callvote() -> callvote(clientNum) 

0.5.4   -- first alpha
	** 6/24/2009  # banner time and index carries over maps (cvar save/load)
	** 6/24/2009  # killing spree, multikills recoded
	** 2/7/2009   # fixed spectator inactivity kicking players on connect, yet again.
	** 01/02/2009 # fixed kmod+ was stop grabbing guid-age's from pb_sv_plist on the first user that didnt have guid (?)
	** 01/02/2009 # fixed spectrator inactivity kicking innocent players on server join, once again. (it heppends because the server assignes some random inactivity 
			number to a connecting player, and until the player loaded the map, he has unpredected "inactivity" time. sometimes that inactivity time is
			bigger then the allowed inactivity time, and the player is kicked instantly)

	** removed: advance player spawn (anti spawn killing) - if you want anti spawnkill module, use ETask.lua, its way better.


0.5.3  
	** added support (not full) for a shrubbot.cfg file - there must be at least 1 [admin] block for it to work (make a dummy admin)
	** work-around: player tracker vulnerability - a player could use the system names [alias] [ip] or [warning] do disrupt the way the info displayed
	** add: smart ban mask using player track facility
			the command !banmask will ban the level 2 ip mask (xxx.xxx) of a player
			and normal ban the player
			players that already exist in the player track facility and connected from the banned ip mask 
			will allow to join the server (assuming they are known and trusted players)
			any new players from the banned subnet mask will be kicked!

0.5.2

	** fix: k_spectatorInactivity kicking players when connecting to the server because of wierd inactivity time stamps
	** fix: k_spectatorInactivity was working always like the server is full
	** add: etpro's /follow command expended - /follow <partial name | slot> will now trigger the follow (unlike full name as before)
	** /console_command has been moved out of the core files into seperate files under "console"
	** changed: private messages - ignored clients are unable to send private messages to the ignoring client
	** work around: etpro's sess.ignoreClients field isnt exposed to the lua API
			we track the ignores by our selves
			a whole ignore/unignore system set up

0.5.1

	** cross TJmod-KMOD+ support! (/save /load /iwant /goto /goback
	** add: k_max_name_change - maximum allowed name changes per map
	** add: fully supported !bans (including temp bans)
	** add: k_mute bitflag (up to bitflag 16 - 5 flags)
	** add: fully supported !mute (including temp mute)
	** changed !war to support diffrent classes for allies and axis, and ability to set ammo/clip munition
	** shurbbot.dat file save functionality change, now dumping all the admins from memory to file.
	** add/fix: swear/censor punishment (just added functunality, need to take another look at the code though)
	** fix: min guid age check - a player connected to the same slot of a player with new guid were kicked for new guid 
	** fix: advance spawning - sometimes player spawned without shield
	** add: spectator Inactivity
	** add: playerInactivity
	** add: levels flags
	** add: guid spoof check
	** add: min guid check
	** improved PM's (can now send to more then 1 person)
	** add: banners
	** add: levels.dat support
	** add: admin greeting
	** add: fully supported !ban !unban !showbans commands ****note: deleting the banlist.dat file will not unban the banned clients, the bans are loaded to punkbuster
	** changed: the unknown KMOD admin and command system, to global tables: global_admin_table[GUID] = level , admin_commands_table[command] = level
	** command return is now either silent or public (silent return if command is silent /!command)
	** can now rcon all commands - /rcon password !command
	** silent command possible - /!command
	** moved all commands out of the kmod.lua to a seperate command.lua files
	** add panzer per players



##########################################################################--]]






--[[------------------------------------------------------------------
---------------- Globals ---------------------------------------------

k_commandprefix = "!" -- the command prefix

global_admin_table[GUID]["level"] = level
global_admin_table[guid]["name"] = name (a.k.a the name the admin had when the admin was given)


global_level_table
	global_level_table[i]["greeting"] = message
	global_level_table[i]["sound"] = path
	global_level_table[i]["name"] = name
	global_level_table[i]["commands"][command_index] = command
	global_level_table[i]["flags"] = flags string (use level_flag(level, flag) to check if this level has a certain flag)
	


global_banners_table
	global_banners_table[i]["message"] = message
	global_banners_table[i]["wait"] = time to wait
	global_banners_table[i]["position"] = position
	global_banners_table["next_banner_index"] = the index of the next banner to print (i)
	global_banners_table["print_banner_time"] = the time to print the next banner


global_players_table[slot]["whatever"] = value
	global_players_table[slot]["guid"] = guid
	global_players_table[slot]["name"] = name
	global_players_table[slot]["guid_age"] = guid_age (only if retrived seccessfuly)
	global_players_table[slot]["inactive"] = timestamp when the client *was* active ( measered in MS, devide by 1000 to have seconds )
	global_players_table[i]["spawn"] = 1 if the player just spawned, or nil otherwise (used to generate the advance_spawn spawn shield)
	global_players_table[i]["spawn_number"] = the spawn position the client is spawning at (use et.trap_SendServerCommand(slot, setspawnpt number) force clients to spawn where you want)
						this adds some nice possibilites, could make lua scripts for maps, to auto-change spawns if a certain event has heppend... 
	global_players_table[i]["lastcommand"] = os.time() // the time this player issued a command, so used in anti-spam-commands
	global_players_table[clientNum]["begin"] = 1 -- player joined the game (function et_clientbegin worked - player isnt loading or something)
	global_players_table[clientNum]["namechange"] = 0 -- how many names did the player have during this map. 
	global_players_table[clientNum]["ignoreClients"][ignored_client_number] = 1 -- ETpro doesnt expose the sess.ignoreClients field, we need to keep a record of our own.


global_mute_table[guid]  
		global_mute_table[guid]["expires"] = expires -- os.time() when the ban going to expire ( 0 - for permanant)
		global_mute_table[guid]["muter_guid"] = muter	-- guid of the muter-admin ( "vote" if was muted by vote)


global_temp_ban_table[ban_index] = expires

global_banmask_table[ip] = banned player name (ip format:  xxx.xxx)





global_ghost_table[slot]["whatever"]
	stores info about players that might * not * be on the server! (as in, i assume the player is on the server - i cannot verify it -, i store the data, then check if the player is on or not)






-- not implemented
global_soundpath_table[key] = path -- see load.lua
global_message_table[key] = message -- see load.lua


--removed
admin_commands_table[command] = level
global_online_admins[guid] = name -- used for the greeting


--]]-------------------------------------------------------------------




global_kversion_var = "0.7"

--et.RegisterModname( "KMOD+ version " .. et.trap_Cvar_Get("kmod_version") .. " " .. et.FindSelf() )
--et.RegisterModname( "KMOD+ v" .. et.trap_Cvar_Get("kmod_version"))
-- mod registration is done in the et_InitGame function, located in the etpro.lua file


-- startup kmod+
local mod = et.trap_Cvar_Get("gamename")
dofile(et.trap_Cvar_Get("fs_homepath") .. '/' .. mod .. '/kmod+/core/etconst.lua')  -- load ET constants
dofile(et.trap_Cvar_Get("fs_homepath") .. '/' .. mod .. '/kmod+/core/init.lua') -- initialize
dofile(et.trap_Cvar_Get("fs_homepath") .. '/' .. mod .. '/kmod+/core/config.lua') -- load settings
dofile(et.trap_Cvar_Get("fs_homepath") .. '/' .. mod .. '/kmod+/core/utils.lua')
dofile(et.trap_Cvar_Get("fs_homepath") .. '/' .. mod .. '/kmod+/core/load.lua') 
dofile(et.trap_Cvar_Get("fs_homepath") .. '/' .. mod .. '/kmod+/core/game.lua') 
dofile(et.trap_Cvar_Get("fs_homepath") .. '/' .. mod .. '/kmod+/core/unknown.lua') 
dofile(et.trap_Cvar_Get("fs_homepath") .. '/' .. mod .. '/kmod+/core/etpro.lua') 
dofile(et.trap_Cvar_Get("fs_homepath") .. '/' .. mod .. '/kmod+/core/et_ClientCommand.lua') 

--pcall(dofile(et.trap_Cvar_Get("fs_homepath") .. '/' .. mod .. '/kmod+/core/custom.lua'))  



-- set defaults
k_commandprefix = "!"

-- eam => ETadmin_mod version
ETADMIN_MOD = 0
if et.trap_Cvar_Get("etadmin_mod") ~= "" then
	ETADMIN_MOD = string.sub(et.trap_Cvar_Get("etadmin_mod"),5,9)
end
--et.trap_SendConsoleCommand( et.EXEC_APPEND, 'sets "KMOD+" "ver=' .. global_kversion_var .. ',eam='.. ETADMIN_MOD  )


--runing the first time
if (tonumber(et.trap_Cvar_Get( "k_first_run" )) == nil ) then 
	et.trap_Cvar_Set( "k_first_run", "1" ) 
	et.trap_SendConsoleCommand( et.EXEC_NOW, "exec kmod+/kmod+.cfg" )
	et.trap_SendConsoleCommand( et.EXEC_NOW, "exec kmod+/core/cvar.cfg" )
	et.trap_Cvar_Set( "kmod_version", global_kversion_var )
	et.trap_Cvar_Set( "k_current_map", "1" ) -- for map rotation
end


global_old_time_var = os.time()


-- if g_inactivity (g_spectatorInactivity) is disabled, then the player is assumed as always active 
--	if only g_inactivity > 0 then server assumes player is active when spec (even if he doesnt move)
--	if only g_spectatorInactivity > 0 server assumes player is active when on team (even if he doesnt move)
--	if both < 0 server assumes player always active
--	when player is active - the players Inactivity time is updated

-- the player's inactivity time is calculated by the value of the g_inactivity / g_spectatorInactivity cvars! (it subs the value of the cvar from the "server-time")
-- so changing this cvar may result in unexepceted behavior ( as in kicking all players off the server )


if tonumber(et.trap_Cvar_Get("k_advancedspawn")) then
	if tonumber(et.trap_Cvar_Get("k_advancedspawn")) > 0 then
		et.trap_Cvar_Set( "g_inactivity", "259200" )  -- 3 days
	end
end

if tonumber(et.trap_Cvar_Get("k_playerInactivity")) then
	if   tonumber(et.trap_Cvar_Get("k_playerInactivity")) > 0  then
		et.trap_Cvar_Set( "g_inactivity", "259200" )  -- 3 days
	end
end

if tonumber(et.trap_Cvar_Get("k_spectatorInactivity")) then
	if  tonumber(et.trap_Cvar_Get("k_spectatorInactivity")) > 0  then
		et.trap_Cvar_Set( "g_spectatorInactivity", "259200" )
	end
end


if tonumber(et.trap_Cvar_Get("k_cursefilteraction")) then -- if the kmod's censor is enabled, disable etpro's censor
	if  tonumber(et.trap_Cvar_Get("k_cursefilteraction")) > 0  then
		et.trap_Cvar_Set( "b_cursefilteraction", "0" )
	end
end

if et.trap_Cvar_Get("g_log") == "" then
	et.trap_Cvar_Set("g_log","etserver.log")
end

TZAC = 0
if (et.trap_Cvar_Get('ac_sv_version') ~= nil and et.trap_Cvar_Get('ac_sv_version') ~= "") then -- slac/tzac
	TZAC = 1 -- string.sub(et.trap_Cvar_Get('ac_sv_version'), 2)
end


-- forcecvar
--et.trap_SendConsoleCommand( et.EXEC_APPEND, "forcecvar b_logbanners 1" ) -- log banners in the client console (!command is shown in the console)
--et.trap_SendConsoleCommand( et.EXEC_NOW, "forcecvar cg_brassTime 99999" ) -- bullet shells stay for 1:30 mintues.
--et.trap_SendConsoleCommand( et.EXEC_APPEND, "forcecvar cg_teamChatTime 8000" ) -- !command is shown for enough time in the chat area (the !command print assumed to be teamchat)

k_sprees =  tonumber(et.trap_Cvar_Get("k_sprees"))
k_lastblood = tonumber(et.trap_Cvar_Get("k_lastblood"))
k_endroundshuffle = tonumber(et.trap_Cvar_Get("k_endroundshuffle"))
k_slashkills = tonumber(et.trap_Cvar_Get("k_slashkills"))



---------------------------------------------------------------------







function dmg_test( PlayerID )
	local damage = et.gentity_get(PlayerID, "damage")
	local sdmgFlags = et.gentity_get(PlayerID, "s.dmgFlags")
	local sessdamage_given = et.gentity_get(PlayerID, "sess.damage_given")
	local sessdamage_received = et.gentity_get(PlayerID, "sess.damage_received")

	et.trap_SendServerCommand("print \"damage = " .. damage .. "\nsdmgflags = " .. sdmgflags .. "\nsessdamage_given = " .. sessdamage_given .. "\nsessdamage_received = " .. sessdamage_received .. "\n\"")
end







function speaker_test(clientnum, soundfile)
	local tempentity
	
	if speaker[clientnum] == nil then
		tempentity = et.G_TempEntity(et.gentity_get(clientnum, "r.currentOrigin"), EV_GLOBAL_CLIENT_SOUND)
		speaker[clientnum] = tempentity
	else
		local origin3 = {}
		origin3[1] = -65536
		origin3[2] = -65536
		origin3[3] = -65536

		et.gentity_set(speaker[clientnum], "r.currentOrigin", origin3)

		tempentity = et.G_TempEntity(et.gentity_get(clientnum, "r.currentOrigin"), EV_GLOBAL_CLIENT_SOUND)
		speaker[clientnum] = tempentity
	end


	et.gentity_set(tempentity, "s.teamNum", clientnum)
	et.gentity_set(tempentity, "s.eventParm", et.G_SoundIndex(soundfile))

	local origin = et.gentity_get(tempentity, "origin")
	local origin2 = et.gentity_get(clientnum, "r.currentOrigin")
	et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay " .. soundfile .. " was played at speaker " .. origin[1] .. ", " .. origin[2] .. ", " .. origin[3] .. " and you are at " .. origin2[1] .. ", " .. origin2[2] .. ", " .. origin2[3] .. "\n" )
end



-- constans
CONNECTING = 0
AXIS = 1
ALLIES = 2
SPECTATOR = 3
CONNECTED_PLAYERS = 0

-- classes
SOLDIER = 0
MEDIC = 1
ENGINEER = 2
FIELDOP = 3
COVERTOP = 4


-- mods
NOQUARTER = "noquarter"
ETPUB = "etpub"
ETPRO = "etpro"

PLAYING = 0
WARMUP = 1
WAIT = 2
INTERMISSION = 3

-- MODs
MOD_DEFAULT = 0
MOD_TRICKJUMP = 1

-- commands color
COMMAND_COLOR = "^f"


MAX_WARNINGS = 99 

--[[
et.trap_SendServerCommand(clientNum, string.format("cpm \"%s\n\"", message))

chat == print to chat area
print == print to console
cpm == print to popup area
cp == print to center area
bp == print to banner area
--]]

-- mod specific cvars
MOD = {}
if et.trap_Cvar_Get("gamename") == "etpub" then
	MOD["CHAT_CLIENT"] = "chatclient"
	MOD["CHAT"] = "chat"
	MOD["CP"] = "cp"
	MOD["MUTE"] = -1
	MOD["NAME"] = ETPUB
elseif et.trap_Cvar_Get("gamename") == "nq" then
	MOD["CHAT_CLIENT"] = "chatclient"
	MOD["CHAT"] = "chat"
	MOD["CP"] = "cp"
	MOD["MUTE"] = 1
	MOD["NAME"] = NOQUARTER
else -- etpro
	MOD["CHAT"] = "b 8"
	MOD["CHAT_CLIENT"] = "b 8"
	MOD["CP"] = "b 32"
	MOD["MUTE"] = 1
	MOD["NAME"] = ETPRO
end


CONSOLE = "console"
KILL = "kill"

