

-- initializing Kmod+
-- function newTDB()

global_admin_table = {}
global_mute_table = {}
admin_commands_table = {}
global_level_table = {}
global_online_admins =""
global_players_table = {}
global_ghost_table = {}
global_spawnkilling_table = {}
global_ban_table = {}
global_banmask_table = {}
global_game_table = {}
global_game_table["fight"] = 0

--global_soundpath_table = {}
--global_message_table = {}

global_players_info_table = {}


k_slashkills = -1
k_endroundshuffle = 0
k_lastblood = 0
k_sprees = 0

killingspree = {}
flakmonkey = {}
deathspree = {}
multikill = {}
playerwhokilled = {}
killedwithweapk = {}
killedwithweapv = {}
playerlastkilled = {}
muted = {}
muteDuration = {}
nummutes = {}
chkIP = {}
antiloopadr1 = {}
antiloopadr2 = {}
adrenaline = {}
adrnum = {}
adrnum2 = {}
adrtime = {}
adrtime2 = {}
adrendummy = {}
clientrespawn = {}
invincStart = {}
invincDummy = {}
switchteam = {}
gibbed = {}
randomClient = {}

timecounter = 1

kill1 = {}
kill2 = {}
kill3 = {}
kill4 = {}
kill5 = {}
kill6 = {}
kill7 = {}
kill8 = {}
killr = {}
selfkills = {}
teamkillr = {}
khp = {}
PlayerName = {}
Bname = {}

EV_GLOBAL_CLIENT_SOUND = 54
et.CS_PLAYERS = 689
EV_GENERAL_SOUND = 49

team = { "AXIS" , "ALLIES" , "SPECTATOR" }
class = { [0]="SOLDIER" , "MEDIC" , "ENGINEER" , "FIELD OPS" , "COVERT OPS" }
adminalias = { [0]="public" , "Protected player" , "^aadmin" , "^aadmin" , "^2High level admin" , "^2High level admin" , "^3High level admin" , "^3High level admin" , "^1Server Admin" , "^3God" }
--AdminLV0 = {}
--AdminLV1 = {}
--AdminLV2 = {}
--AdminLV3 = {}
AdminLV = {}
for z=0, 9999, 1 do
	AdminLV[z] = {}
end
chkGUID = {}
AdminName = {}
originalclass = {}
originalweap = {}

et.MAX_WEAPONS = 50
GAMEPAUSED = 0

-- 6 original maps maps.cfg
ORIGINAL_6_MAPS_ROTATION = {	["battery"] = {	["name"] = "battery",
						["min_players"] = 0,
						["max_players"] = 64,
						["available"] = 1},

				["railgun"] = {	["name"] = "railgun",
						["min_players"] = 0,
						["max_players"] = 64,
						["available"] = 1},

				["oasis"] = {	["name"] = "oasis",
						["min_players"] = 0,
						["max_players"] = 64,
						["available"] = 1},				

				["goldrush"] = {["name"] = "goldrush",
						["min_players"] = 0,
						["max_players"] = 64,
						["available"] = 1},

				["radar"] = {	["name"] = "radar",
						["min_players"] = 0,
						["max_players"] = 64,
						["available"] = 1},

				["fueldump"] = {["name"] = "fueldump",
						["min_players"] = 0,
						["max_players"] = 64,
						["available"] = 1}
			}

if not tonumber(et.trap_Cvar_Get("k_endroundPlayers")) then et.trap_Cvar_Set("k_endroundPlayers", 0) end

-- panzer war settings
pweapons = {
	nil,	--// 1
	false,	--WP_LUGER,				// 2
	false,	--WP_MP40,				// 3
	false,	--WP_GRENADE_LAUNCHER,	// 4
	true,	--WP_PANZERFAUST,		// 5
	false,	--WP_FLAMETHROWER,		// 6
	false,	--WP_COLT,				// 7	// equivalent american weapon to german luger
	false,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	false,	--WP_GRENADE_PINEAPPLE,	// 9
	false,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	false,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	false,	--WP_AMMO,				// 12	// JPW NERVE likewise
	false,	--WP_ARTY,				// 13
	false,	--WP_SILENCER,			// 14	// used to be sp5
	false,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	false,	--WP_MEDKIT,			// 19
	false,	--WP_BINOCULARS,		// 20
	nil,	--// 21
	nil,	--// 22
	false,	--WP_KAR98,				// 23	// WolfXP weapons
	false,	--WP_CARBINE,			// 24
	false,	--WP_GARAND,			// 25
	false,	--WP_LANDMINE,			// 26
	false,	--WP_SATCHEL,			// 27
	false,	--WP_SATCHEL_DET,		// 28
	nil,	--// 29
	false,	--WP_SMOKE_BOMB,		// 30
	false,	--WP_MOBILE_MG42,		// 31
	false,	--WP_K43,				// 32
	false,	--WP_FG42,				// 33
	nil,	--// 34
	false,	--WP_MORTAR,			// 35
	nil,	--// 36
	false,	--WP_AKIMBO_COLT,		// 37
	false,	--WP_AKIMBO_LUGER,		// 38
	nil,	--// 39
	nil,	--// 40
	false,	--WP_SILENCED_COLT,		// 41
	false,	--WP_GARAND_SCOPE,		// 42
	false,	--WP_K43_SCOPE,			// 43
	false,	--WP_FG42SCOPE,			// 44
	false,	--WP_MORTAR_SET,		// 45
	false,	--WP_MEDIC_ADRENALINE,	// 46
	false,	--WP_AKIMBO_SILENCEDCOLT,// 47
	false	--WP_AKIMBO_SILENCEDLUGER,// 48
}

-- frenzy war settings
fweapons = {
	nil,	--// 1
	true,	--WP_LUGER,				// 2
	true,	--WP_MP40,				// 3
	true,	--WP_GRENADE_LAUNCHER,	// 4
	true,	--WP_PANZERFAUST,		// 5
	true,	--WP_FLAMETHROWER,		// 6
	true,	--WP_COLT,				// 7	// equivalent american weapon to german luger
	true,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	true,	--WP_GRENADE_PINEAPPLE,	// 9
	true,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	true,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	true,	--WP_AMMO,				// 12	// JPW NERVE likewise
	true,	--WP_ARTY,				// 13
	true,	--WP_SILENCER,			// 14	// used to be sp5
	true,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	true,	--WP_MEDKIT,			// 19
	true,	--WP_BINOCULARS,		// 20
	nil,	--// 21
	nil,	--// 22
	true,	--WP_KAR98,				// 23	// WolfXP weapons
	true,	--WP_CARBINE,			// 24
	true,	--WP_GARAND,			// 25
	true,	--WP_LANDMINE,			// 26
	true,	--WP_SATCHEL,			// 27
	true,	--WP_SATCHEL_DET,		// 28
	nil,	--// 29
	true,	--WP_SMOKE_BOMB,		// 30
	true,	--WP_MOBILE_MG42,		// 31
	true,	--WP_K43,				// 32
	true,	--WP_FG42,				// 33
	nil,	--// 34
	true,	--WP_MORTAR,			// 35
	nil,	--// 36
	true,	--WP_AKIMBO_COLT,		// 37
	true,	--WP_AKIMBO_LUGER,		// 38
	nil,	--// 39
	nil,	--// 40
	true,	--WP_SILENCED_COLT,		// 41
	true,	--WP_GARAND_SCOPE,		// 42
	true,	--WP_K43_SCOPE,			// 43
	true,	--WP_FG42SCOPE,			// 44
	true,	--WP_MORTAR_SET,		// 45
	false,	--WP_MEDIC_ADRENALINE,	// 46
	true,	--WP_AKIMBO_SILENCEDCOLT,// 47
	true	--WP_AKIMBO_SILENCEDLUGER,// 48
}

aweapons = {
	nil,	--// 1
	true,	--WP_LUGER,				// 2
	true,	--WP_MP40,				// 3
	true,	--WP_GRENADE_LAUNCHER,	// 4
	true,	--WP_PANZERFAUST,		// 5
	true,	--WP_FLAMETHROWER,		// 6
	true,	--WP_COLT,				// 7	// equivalent american weapon to german luger
	true,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	true,	--WP_GRENADE_PINEAPPLE,	// 9
	true,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	true,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	true,	--WP_AMMO,				// 12	// JPW NERVE likewise
	true,	--WP_ARTY,				// 13
	true,	--WP_SILENCER,			// 14	// used to be sp5
	true,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	true,	--WP_MEDKIT,			// 19
	true,	--WP_BINOCULARS,		// 20
	nil,	--// 21
	nil,	--// 22
	true,	--WP_KAR98,				// 23	// WolfXP weapons
	true,	--WP_CARBINE,			// 24
	true,	--WP_GARAND,			// 25
	true,	--WP_LANDMINE,			// 26
	true,	--WP_SATCHEL,			// 27
	true,	--WP_SATCHEL_DET,		// 28
	nil,	--// 29
	true,	--WP_SMOKE_BOMB,		// 30
	true,	--WP_MOBILE_MG42,		// 31
	true,	--WP_K43,				// 32
	true,	--WP_FG42,				// 33
	nil,	--// 34
	true,	--WP_MORTAR,			// 35
	nil,	--// 36
	true,	--WP_AKIMBO_COLT,		// 37
	true,	--WP_AKIMBO_LUGER,		// 38
	nil,	--// 39
	nil,	--// 40
	true,	--WP_SILENCED_COLT,		// 41
	true,	--WP_GARAND_SCOPE,		// 42
	true,	--WP_K43_SCOPE,			// 43
	true,	--WP_FG42SCOPE,			// 44
	true,	--WP_MORTAR_SET,		// 45
	false,	--WP_MEDIC_ADRENALINE,	// 46
	true,	--WP_AKIMBO_SILENCEDCOLT,// 47
	true	--WP_AKIMBO_SILENCEDLUGER,// 48
}

-- granade war settings
gweapons = {
	nil,	--// 1
	false,	--WP_LUGER,				// 2
	false,	--WP_MP40,				// 3
	true,	--WP_GRENADE_LAUNCHER,	// 4
	false,	--WP_PANZERFAUST,		// 5
	false,	--WP_FLAMETHROWER,		// 6
	false,	--WP_COLT,				// 7	// equivalent american weapon to german luger
	false,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	true,	--WP_GRENADE_PINEAPPLE,	// 9
	false,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	false,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	false,	--WP_AMMO,				// 12	// JPW NERVE likewise
	false,	--WP_ARTY,				// 13
	false,	--WP_SILENCER,			// 14	// used to be sp5
	false,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	false,	--WP_MEDKIT,			// 19
	false,	--WP_BINOCULARS,		// 20
	nil,	--// 21
	nil,	--// 22
	false,	--WP_KAR98,				// 23	// WolfXP weapons
	false,	--WP_CARBINE,			// 24
	false,	--WP_GARAND,			// 25
	false,	--WP_LANDMINE,			// 26
	false,	--WP_SATCHEL,			// 27
	false,	--WP_SATCHEL_DET,		// 28
	nil,	--// 29
	false,	--WP_SMOKE_BOMB,		// 30
	false,	--WP_MOBILE_MG42,		// 31
	false,	--WP_K43,				// 32
	false,	--WP_FG42,				// 33
	nil,	--// 34
	false,	--WP_MORTAR,			// 35
	nil,	--// 36
	false,	--WP_AKIMBO_COLT,		// 37
	false,	--WP_AKIMBO_LUGER,		// 38
	nil,	--// 39
	nil,	--// 40
	false,	--WP_SILENCED_COLT,		// 41
	false,	--WP_GARAND_SCOPE,		// 42
	false,	--WP_K43_SCOPE,			// 43
	false,	--WP_FG42SCOPE,			// 44
	false,	--WP_MORTAR_SET,		// 45
	false,	--WP_MEDIC_ADRENALINE,	// 46
	false,	--WP_AKIMBO_SILENCEDCOLT,// 47
	false	--WP_AKIMBO_SILENCEDLUGER,// 48
}

-- snipe war settings
sweapons = {
	nil,	--// 1
	false,	--WP_LUGER,				// 2
	false,	--WP_MP40,				// 3
	false,	--WP_GRENADE_LAUNCHER,	// 4
	false,	--WP_PANZERFAUST,		// 5
	false,	--WP_FLAMETHROWER,		// 6
	false,	--WP_COLT,				// 7	// equivalent american weapon to german luger
	false,	--WP_THOMPSON,			// 8	// equivalent american weapon to german mp40
	false,	--WP_GRENADE_PINEAPPLE,	// 9
	false,	--WP_STEN,				// 10	// silenced sten sub-machinegun
	false,	--WP_MEDIC_SYRINGE,		// 11	// JPW NERVE -- broken out from CLASS_SPECIAL per Id request
	false,	--WP_AMMO,				// 12	// JPW NERVE likewise
	false,	--WP_ARTY,				// 13
	false,	--WP_SILENCER,			// 14	// used to be sp5
	false,	--WP_DYNAMITE,			// 15
	nil,	--// 16
	nil,	--// 17
	nil,		--// 18
	false,	--WP_MEDKIT,			// 19
	false,	--WP_BINOCULARS,		// 20
	nil,	--// 21
	nil,	--// 22
	false,	--WP_KAR98,				// 23	// WolfXP weapons
	false,	--WP_CARBINE,			// 24
	true,	--WP_GARAND,			// 25
	false,	--WP_LANDMINE,			// 26
	false,	--WP_SATCHEL,			// 27
	nil,	--WP_SATCHEL_DET,		// 28
	nil,	--// 29
	false,	--WP_SMOKE_BOMB,		// 30
	false,	--WP_MOBILE_MG42,		// 31
	true,	--WP_K43,				// 32
	true,	--WP_FG42,				// 33
	nil,	--// 34
	false,	--WP_MORTAR,			// 35
	nil,	--// 36
	false,	--WP_AKIMBO_COLT,		// 37
	false,	--WP_AKIMBO_LUGER,		// 38
	nil,	--// 39
	nil,	--// 40
	false,	--WP_SILENCED_COLT,		// 41
	true,	--WP_GARAND_SCOPE,		// 42
	true,	--WP_K43_SCOPE,			// 43
	true,	--WP_FG42SCOPE,			// 44
	false,	--WP_MORTAR_SET,		// 45
	false,	--WP_MEDIC_ADRENALINE,	// 46
	false,	--WP_AKIMBO_SILENCEDCOLT,// 47
	false	--WP_AKIMBO_SILENCEDLUGER,// 48
}

lvls = {}
lvlsc = {}

numAxisPlayers = 0
numAlliedPlayers = 0
active_players = 0
total_players = 0

firstblood = 0
lastblood = ""
oldspree = ""
oldspree2 = ""
intmrecord = ""
oldmapspree = ""
oldmapspree2 = ""
intmMaprecord = ""

k_heavyWeaponRestrictions = {}
k_heavyWeaponRestrictions[PANZERFAUST] = 0
k_heavyWeaponRestrictions[GRENADE_LAUNCHER] = 0
k_heavyWeaponRestrictions[FLAMETHROWER] = 0
k_heavyWeaponRestrictions[MOBILE_MG42] = 0
k_heavyWeaponRestrictions[MORTAR] = 0
k_heavyWeaponRestrictions[LANDMINE] = 0


panzers = ""
medics = ""
cvops = ""
fops = ""
engie = ""
flamers = ""
mortars = ""
mg42s = ""
soldcharge = ""
speed = ""
redlimbo = ""
bluelimbo = ""

floodprotect = 0
commandSaid = false
kick = false
fullcom = ""
finger = false
removereferee = false
makereferee = false
removeshoutcaster = false
makeshoutcaster = false
putspec = false
putallies = false
putaxis = false
unmute = false
mute = false
warn = false
ban = false
crazygravity = false
crazytime = 0

pmsound = "sound/misc/NewBeep.wav"

antiloop = 0
antiloop2 = 0
antiloop3 = 0
antiloop4 = 0
antiloopes = 0
antilooppw = 0
confirm = 0
spreerecordkills = 0
mapspreerecordkills = 0
crazydv = 1
CGactive = 0
panzdv = 0
sldv = 0
frenzdv = 0
grendv = 0
snipdv = 0
antiloopm = 0
pausedv = 0
pausedv2 = 0
pausetime = 0
timedv = 0
timedvs = 0
refreshrate = 0
timedelay_antiloop = 0
egamemodes = 0
run_once = 0

for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
	antiloopadr1[i] = 0
	antiloopadr2[i] = 0
	adrenaline[i] = 0
	adrnum[i] = 0
	adrnum2[i] = 0
	adrtime[i] = 0
	adrtime2[i] = 0
end

k_Admin = {}

qwerty = 0

if not tonumber(et.trap_Cvar_Get("k_soundcommandstamp")) then
	et.trap_Cvar_Set("k_soundcommandstamp",os.time())
end












--[[
TDB = {} -- Text File Data Base By Necromancer. the database is object oriented, and all of its functions are implemented here (look down)
function TDB:new (db) -- creates new database ( a = TDB:new() )
	db = db or {}   -- create object if user does not provide one
	setmetatable(db, self)
	self.__index = self
	return db
end

function TDB:set(key,value)

end

function TDB:setList(list,value)

end

function TDB:writeFile(filename)

end

function TDB:readFile(filename)

end
--]]


-- use: local a = newTDB(); a.set(key,value)
-- available functions
--	set(key,valye)
--	get(key)
--	setList(list,value)
--	removeList(list,value)
--	getList(list)
--	writeFile(filename)
--	readFile(filename)
function newTDB()
	local db = {}

	local set = function (key,value) -- sets a simple key-value 
		if value == nil or value == "" then
			if db[key] ~= nil and type(db[key]) ~= "table" then 
				db[key] = nil
			end
		else
			if tonumber(et.trap_Cvar_Get("k_debug")) > 1 then  et.G_LogPrint("setting key " .. key .. " - " .. value .. "\n") end
			db[key] = value
		end
	end


	local get = function (key) -- returns the key's current value
		if db[key] ~= nil and type(db[key]) ~= "table" then
			return db[key]
		else 
			return nil
		end
	end


	local setList = function (list,value) -- adds the value to the list. (if list does not exists, it creats one. if value is nil or "", the list is deleted. cannot have duplicate values)
		if value == nil or value == "" then
			if db[list] ~= nil and type(db[list]) == "table" then
				db[list] = nil
			end
		else
			if db[list] == nil then
				db[list] = {}
			end
			local i
			if db[list][1] == nil then 
				db[list][table.getn(db[list]) + 1] = value 
				return
			end
			for i=1,table.getn(db[list]),1 do
				if value == db[list][i] then return end
			end

			db[list][table.getn(db[list]) + 1] = value
		end

	end

	local removeList = function (list,value) -- removes the value from the list
		if value == nil or value == "" then return end
		if db[list] ~= nil and type(db[list]) == "table" then
			for i=1,table.getn(db[list]),1 do
				if value == db[list][i] then
					table.remove(db[list],i)
					if table.getn(db[list]) <= 0 then -- the list is empty, no elements left
						db[list] = nil -- remove it.
					end
					break
				end
			end
		end
	end


	local getList = function (list) -- returns a table containing all of the lists elements
		if db[list] == nil or type(db[list]) ~= "table" then
			return nil
		else
			local t={}
			local i
			for i=1,table.getn(db[list]),1 do
				t[i] = db[list][i]
			end
			return t
		end
	end


	local writeFile = function (filename) -- writes the database to the file
		local fd, length =  et.trap_FS_FOpenFile(filename, et.FS_WRITE )
		if length == - 1 then
			et.G_LogPrint("newTDB - cannot open file: " .. filename .. "\n")
			et.trap_FS_FCloseFile( fd )
			return nil
			
		end
		local text
		local key,value
		for key,value in pairs(db) do
			if type(db[key]) == "table" then
				--et.G_LogPrint("writing key " .. key .. " - " .. type(db[key]) .. "\n")
				local i
				text = "[" .. key .. "]\n"
				et.trap_FS_Write( text, string.len(text) ,fd )
				for i=1,table.getn(db[key]),1 do
					text = db[key][i] .. "\n"
					et.trap_FS_Write( text, string.len(text) ,fd )
				end
			else
				--et.G_LogPrint("writing key " .. key .. " - " .. value .. "\n")
				text =  key .. " = " .. value .. "\n"
				et.trap_FS_Write( text, string.len(text) ,fd )
			end
		end
				et.trap_FS_FCloseFile( fd )
	end


	local readFile = function (filename) -- loads the database from the file
		local fd, length =  et.trap_FS_FOpenFile(filename, et.FS_READ )
		if length == - 1 then
			et.G_LogPrint("newTDB - cannot open file: " .. filename .. "\n")
			--et.trap_FS_FCloseFile( filestr )
			return nil
			
		end
		filestr = et.trap_FS_Read( fd, length )
		et.trap_FS_FCloseFile( fd )
		local line,key,value
		local line_number = 1
		local flag = ""
		local start,stop
		
		local line_break
		if string.find(et.trap_Cvar_Get("version"),"linux") then line_break = "\n"
		else line_break = "\r" end

		for line in string.gfind(filestr,"([^%" .. line_break .. "]*)%s*") do
			--et.G_LogPrint("line - " .. line .. "\n")
			if string.find(line,"(%S+)") then
				start,stop,key,value = string.find(line,"(%S+) = ([^%\n]*)%s*")
				if start and stop and key and value then
					db[key] = value
					--et.G_LogPrint("key - " .. key .. " value - " .. value .. "\n")
					flag = ""
				else
					start,stop,key = string.find(line,"\%[([^%]]+)%s*")
					if start and stop and key then
						flag = key
						db[key] = {}
						--et.G_LogPrint("list key - " .. key .. "\n")
					elseif flag ~= "" then
						db[flag][table.getn(db[flag])+1] = line
						--et.G_LogPrint("list value - " .. line .. " list - " .. flag .. "\n")
					else
						et.G_LogPrint("newTDB: ERROR on line " .. line_number .. " in file: " ..filename.."\n")
					end
				end
				
			end
			line_number = line_number + 1
		end
		et.trap_FS_FCloseFile( fd )
		return 1
	end


	return {
		set = set,
		get = get,
		setList = setList,
		removeList = removeList,
		getList = getList,
		writeFile = writeFile,
		readFile = readFile
	}
end


-- load a block file into a table ADT
function loadBlocksFromFile(filename,block)
	
	local db = {}
	local fd,len = et.trap_FS_FOpenFile( filename, et.FS_READ )
	if len == - 1 then
		-- error: does not exist or unable to open
		et.trap_FS_FCloseFile( fd )
		return
	end

	local filestr = et.trap_FS_Read( fd, len )
	et.trap_FS_FCloseFile( fd )
	
	local start,stop,key,flag = 0
	local line
	local arg = {}
	local masterkey
	local line_break
	if string.find(et.trap_Cvar_Get("version"),"linux") then line_break = "\n"
	else line_break = "\r" end

	for line in string.gfind(filestr,"([^%" .. line_break .. "]*)%s*") do
		if string.find(line,"(%S+)") then
			--et.G_LogPrint(line .. "\n")
			start,stop,current = string.find(line,"\%[([^%]]+)]%s*") 
			if start == 1 and stop and current then -- start == 1: block must be the first thing on the line, ETpub uses special shortcuts that might be mistaken for blocks otherwise ([n] [k] [a] etc...)
				--et.G_LogPrint("*** current block: " .. current .. " start: " .. start .."\n")
				if current == block then -- the current block maches to our block name
					flag = 1 -- its our block, we need to read it!
					--et.G_LogPrint("***block found!\n")
					--et.G_LogPrint("***masterkey nilled #0\n")
					masterkey = nil
				else
					flag = 0 -- its not our block, do not read it!
					--et.G_LogPrint("***masterkey nilled #1\n")
					masterkey = nil
				end
			elseif flag == 1 then -- if its not a heading of a block, then it must be the inside of it
				start,stop,key,value = string.find(line,"(%S+) = ([^%\n]*)%s*")
				if start and stop and key and value then
					if masterkey == nil then
						--et.G_LogPrint("***we got a master key!!\n")
						if tonumber(value) then masterkey = tonumber(value) 
						else  masterkey = value end
						arg[masterkey] = {}
					else
						--et.G_LogPrint("***master: " .. masterkey .. " key: " .. key .. " value: " .. value .."\n")
						arg[masterkey][key] = value
					end
				end
			end
		
		else -- empty line! be ready to capture the next key!
			--et.G_LogPrint("***masterkey nilled #2\n")
			masterkey = nil
		end

	end
	et.trap_FS_FCloseFile( fd )
	return arg


end