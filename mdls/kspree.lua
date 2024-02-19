shrubbot = "shrubbot.cfg"
vips = {}

--
-- kspree.lua
--
-- $Id: kspree.lua 174 2007-02-28 19:17:56Z bennz $
-- $Date: 2007-02-28 20:17:56 +0100 (Mi, 28 Feb 2007) $
-- $Revision: 174 $
--
version = "1.0.7"

-- kspree.lua logic "stolen" from Vetinari's rspree.lua, who "stole" from etadmin_mod.pl and so on
-- CONSOLE COMMANDS : ksprees, kspeesall, kspreerecords
-- added: new readRecords() function
-- added: First Blood + Last Blood
-- added: Greatshot option, display last killers name v56
-- added: Sorry option, display last TKed's name v45
-- added: spree announcement can be disabled
-- FIXME: recordMessage() does not work everytime -- FIXED !!!
-- FIXME: use wait_table[id] ~= nil --FIXED mmmhhh :/ ???

-- x0rnn: added "thanks, [name]" vsay for revives
-- x0rnn: added doublekill announce for 2 pistol kills
-- x0rnn: added topshots (most kills with x, most hs...)
-- x0rnn: added ammo left message to vsay_team NeedAmmo
-- x0rnn: added class message to vsay_team EnemyDisguised
-- x0rnn: added !multikillstats, !vsstats for current map
-- x0rnn: made kills and deaths preserve after switching teams
-- x0rnn: fixed vsay medic spam
-- x0rnn: -- shows kill assist information upon death (who all shot you, how much HP they took and how many HS they made)

-- If you run etadmin_mod, change the following lines in "etadmin.cfg"
--      spree_detector          = 0
--      longest_spree_display     = 0 
--      persistent_spree_record     = 0
--      persistent_map_spree_record   = 0
--      first_blood           = 0
--      multikill_detector        = 0
--      monsterkill_detector      = 0
--      last_blood            = 0
--
-------------------------------------------------------------------------------------
-------------------------------CONFIG START------------------------------------------

-- ######## announce_hp
announce_hp = true
announce_hp_pos = "cp"      -- console only 64
announce_killer = true -- announce kill assists to the killer also
-- ######## announce_hp_pos => http://wolfwiki.anime.net/index.php/SendServerCommand

kspree_cfg    = "killingspree.txt"
record_cfg   = "kspree-records.txt"

date_fmt     = "%Y-%m-%d, %H:%M:%S"

kmultitk_announce = true      -- announce multi TK
kmulti_announce   = true      -- announce multi/mega/ultra....kill
kspree_announce   = true      -- announce sprees

kmulti_sound      = true      -- multi-sounds
kspree_sound    = true      -- spree-sounds

first_blood     = true      -- display First Blood
last_blood      = true      -- display Last Blood

kmulti_pos        = "cpm"     -- multi + megakill - position 8
kmonster_pos      = "cp"    -- ultra + monster + ludicrous + holy shit - position
kmultitk_pos    = "cp"    -- multi TK - position
kspree_pos        = "cpm"     -- killing spree position 8
kspree_color      = "8"     -- killing spree color

-- mod selection harle rip off
gamename = et.trap_Cvar_Get("gamename")
if (gamename == "etpub" or gamename == "nq")  then
kspree_pos    = "chat" -- see http://wolfwiki.anime.net/index.php/SendServerCommand for valid locations
kmulti_pos      = "chat"
kmonster_pos    = "chat" -- b 32 == cp (this info is for harle :o))
announce_hp = true
announce_hp_pos = "chat"      -- console only
end
-- mod selection harle rip off

kmulti_msg        = "^7!3! ^1Multi kill ^7> ^7%s ^7< ^1Multi kill ^7!3!"
kmega_msg   = "^7!4! ^1Mega kill ^7> ^7%s ^7< ^1Mega kill ^7!4!"
kultra_msg        = "^7!5! ^1ULTRA KILL ^7>>> ^7%s ^7<<< ^1ULTRA KILL ^7!5!"
kmonster_msg      = "^7!6! ^1MONSTER KILL ^7>>> ^7%s ^7<<< ^1MONSTER KILL ^7!6!"
kludicrous_msg    = "^7!7! ^1LUDICROUS KILL ^7>>> ^7%s ^7<<< ^1LUDICROUS KILL ^7!7!"
kholyshit_msg   = "^7!8! ^1H O L Y  S H I T ^7>>> ^7%s ^7<<< ^1H O L Y  S H I T ^7!8!"
kmultitk_msg    = "^7!!! ^1Multi Teamkill ^7> ^7%s ^7< ^1Multi Teamkill ^7!!!"
doublekill_msg = "^7!!! ^1Double pistol kill ^7> ^7%s ^7< ^1Double pistol kill ^7!!!"

firstbloodsound   = "sound/misc/firstblood.wav"
multisound    = "sound/misc/multikill.wav"
megasound   = "sound/misc/megakill.wav"
ultrasound    = "sound/misc/ultrakill.wav"
monstersound    = "sound/misc/monsterkill.wav"
ludicroussound    = "sound/misc/ludicrouskill.wav"
holyshitsound     = "sound/misc/holyshit.wav"
multitksound    = "sound/misc/teamkiller.wav"
killingspreesound = "sound/misc/killingspree.wav"
rampagesound    = "sound/misc/rampage.wav"
dominatingsound   = "sound/misc/dominating.wav"
godlikesound    = "sound/misc/godlike.wav"
unstoppablesound  = "sound/misc/unstoppable.wav"
wickedsicksound   = "sound/misc/wickedsick.wav"
pottersound     = "sound/misc/potter.wav"
doublekillsound = "sound/misc/doublekill.wav"

killingspree_private  = false    -- send killingspree message + sound to client only, if set to true
                  -- (You are on a killing spree), all other messages are global messages, like rampage and so on

kspree_cmd_enabled  = true      -- set to false to ignore the "kspree_cmd"
kspree_cmd      = "!spree_record"

record_cmd      = "!top"  -- command to print players with most multi,mega,ultra... kills
multikill_cmd   = "!multikillstats" -- command to print multikillstats rank
stats_cmd       = "!statspub"   -- same as etadmin_mod's "!stats", prints personal killing records (i.e. multi,mega,ultra... kills)
statsme_cmd     = "!stats"  -- shows ur personal killing stats (private)

srv_record      = true      -- set to true, if u want to save killing stats
record_last_nick  = true      -- set to true to keep the last known nick a guid has
--records_expire    = 60*60*24*90   -- in seconds! 60*60*24*5 == 5 days
records_expire    = 0   -- in seconds! 60*60*24*5 == 5 days

allow_spree_sk    = true      -- allow new killing spree record, even if he killed himself

great_shot      = true      -- name of ur killer will be added if u vsay "GreatShot" within "great_shot_time" ms
great_shot_time   = 5000      -- 5000 = 5 seconds = Five SECONDS
great_shot_repeat   = false     -- set to true, name will be added everytime u vsay Greatshot within "great_shot_time" ms

sorry       = true      -- name of ur last tk will be added if u vsay_team "Sorry" within "sorry_time" ms
sorry_time      = 9000      -- 9000 = 9 seconds = Nine SECONDS
sorry_repeat    = false     -- set to true, name will be added everytime u vsay_team "sorry" within "sorry_time" ms

thanks = true
thanks_time = 5000
thanks_repeat = false

save_awards = true          -- save Ludicrouskill + Holy Shit + Multi TK in textfile "awards_file"
awards_file = "awards.txt"

msg_command = "ksprees"       -- '\ksprees 1|0' to switch on / off the messages and sounds
                  -- clients can set their default with 'setu b_ksprees 1' (or 0)
msg_default = true          -- print kspree messages to client if true

K_Sprees = {            -- adjust them to ur needs
     [5] = "is on a killing spree",
    [10] = "is on a rampage!",
    [15] = "is dominating!",
    [20] = "is unstoppable!!",
    [25] = "is godlike!!!",
    [30] = "is wicked sick!!!!",
    [35] = "is a real POTTER!!!!!",
}

-------------------------------CONFIG END -------------------------------------------
-------------------------------------------------------------------------------------

et.MAX_WEAPONS = 50
EV_GLOBAL_CLIENT_SOUND = 54
killing_sprees = {}
kmax_spree     = 0
kmax_id        = nil
alltime_stats = {}
kmulti         = {}
kmultitk    = {}
wait_table  = {}
kmap_record    = false
srv_records = {}
kendofmap      = false
eomap_done = false
eomaptime = 0
gamestate   = -1
last_b    = ""
last_killer = {}
last_tk = {}
last_revive = {}
last_vsaymedic = {}
last_vsaythanks = {}
client_msg = {}
topshot_msg = {}
topshot_msg_cmd = "topshots" -- '\topshots 1|0' to switch on / off the messages
                  -- clients can set their default with 'setu b_topshots 1' (or 0)
topshot_msg_default = true          -- print topshots messages to client if true
topshots = {}
mkps = {}
weaponstats = {}
endplayers = {}
endplayerscnt = 0
tblcount = 0
medic_table = {}
covert_table = {}
u_flag = {}
last_use = {}
doublekill = {}
et.CS_PLAYERS = 689
kspree_endmsg = ""
vsstats = {}
vsstats_kills = {}
vsstats_deaths = {}
kills = {}
deaths = {}
dmg_given = {}
dmg_rcvd = {}
teamswitch = {}
players = {}
worst_enemy = {}
easiest_prey = {}
kteams = { [0]="Spectator", [1]="Axis", [2]="Allies", [3]="Unknown", }
topshot_names = { [1]="Most damage given", [2]="Most damage received", [3]="Most team damage given", [4]="Most team damage received", [5]="Most teamkills", [6]="Most selfkills", [7]="Most deaths", [8]="Most kills per minute", [9]="Quickest multikill w/ light weapons", [11]="Farthest riflenade kill", [12]="Most light weapon kills", [13]="Most pistol kills", [14]="Most rifle kills", [15]="Most riflenade kills", [16]="Most sniper kills", [17]="Most knife kills", [18]="Most air support kills", [19]="Most mine kills", [20]="Most grenade kills", [21]="Most panzer kills", [22]="Most mortar kills", [23]="Most panzer deaths", [24]="Mortarmagnet", [25]="Most multikills", [26]="Most MG42 kills", [27]="Most MG42 deaths", [28]="Most revives", [29]="Most revived", [30]="Adrenaline junkie", [31]="Best K/D ratio", [32]="Most health packs taken", [33]="Most ammo packs taken", [34]="Most dynamites planted", [35]="Most dynamites defused", [36]="Most doublekills", [37]="Most shoves", [38]="Most shoved", [39]="Most objectives stolen", [40]="Most objectives returned", [41]="RAMBO - Reviving Ain't My Biz. Obv.", [42]="Can't shut up", [43]="Pussy Award (most IFSKs)", [44]="Most uniforms stolen", [45]="Most corpse gibs", [46]="Most kill assists", [47]="Most killsteals", [48]="Most headshot kills", [49]="Most damage per minute", [50]="Tank/Meatshield (Refuses to die)", [51]="Most useful kills (>Half respawn time left)", [52]="Full respawn king", [53]="Least time dead (What spawn?)"}
dmg_switch = {}
damage_received_temp = {}
hitters = {}
light_weapons = {1,2,3,5,6,7,8,9,10,11,12,13,14,17,37,38,44,45,46,50,51,53,54,55,56,61,62,66}
explosives = {15,16,18,19,20,22,23,26,39,40,41,42,52,63,64}
HR_HEAD = 0
HR_ARMS = 1
HR_BODY = 2
HR_LEGS = 3
HR_NONE = -1
HR_TYPES = {HR_HEAD, HR_ARMS, HR_BODY, HR_LEGS}
hitRegionsData = {}
death_time = {}
death_time_total = {}
ltm2 = 0
redspawn = 0
bluespawn = 0
redspawn2 = 0
bluespawn2 = 0
spawns = {}
redflag = false
blueflag = false
redlimbo1 = 0
bluelimbo1 = 0
redlimbo2 = 0
bluelimbo2 = 0
changedred = false
changedblue = false

weapontable = {
[3]=	"MP40",
[5]=	"Panzerfaust",
[6]=	"Flamethrower",
[8]=	"Thompson",
[10]=	"Sten", 
[23]=	"K43 Rifle",
[24]=	"M1 Rifle",
[25]=	"M1 Garand",
[30]=	"MG42",
[31]=	"K43",
[32]=	"FG42",
[34]=	"Mortar",
[37]=	"K43 Riflegrenade",
[38]=	"M1 Riflegrenade",
[40]=	"M1 Garand",
[41]=	"K43",
[42]=	"FG42",
[43]=	"Mortar",
[47]=	"MG42",
[49]=	"Mobile Browning",
[50]=	"Mobile Browning",
[51]=	"Mortar",
[52]=	"Mortar",
[53]=	"Bazooka",
[54]=	"MP34",
}

pistols = {
[2]=	"Luger",
[7]=	"Colt",
[14]=	"Silenced Luger",
[35]=	"Akimbo Colt",
[36]=	"Akimbo Luger", 
[39]=	"Silenced Colt",
[45]=	"Silenced Akimbo Colt",
[46]=	"Silenced Akimbo Luger", 
}

classtable = {
[0] = "Soldier",
[1] = "Medic",
[2] = "Engineer",
[3] = "FieldOps",
[4] = "CovertOps",
}

mod_weapons = {
[1]=	"MG",
[2]=	"Browning",
[3]=	"MG42",
[5]=	"Knife",
[6]=	"Luger",
[7]=	"Colt",
[8]=	"MP40",
[9]=	"Thompson",
[10]=	"Sten", 
[11]=	"Garand",
[12]=	"Luger",
[13]=	"FG42",
[14]=	"Scoped FG42",
[15]=	"Panzerfaust",
[16]=	"Grenade",
[17]=	"Flamethrower",
[18]=	"Grenade",
[19]=	"Mortar",
[20]=	"Mortar",
[22]=	"Dynamite",
[23]=	"Airstrike",
[26]=	"Arty",
[37]=	"Rifle",
[38]=	"Rifle",
[39]=	"Riflenade",
[40]=	"Riflenade",
[41]=	"Mine",
[42]=	"Satchel",
[44]=	"MG42",
[45]=	"Colt",
[46]=	"Scoped Garand",
[50]=	"K43",
[51]=	"Scoped K43",
[52]=	"Mortar",
[53]=	"Akimbo Colt",
[54]=	"Akimbo Luger",
[55]=	"Akimbo Colt",
[56]=	"Akimbo Luger",
[61]=	"Knife",
[62]=	"Browning",
[63]=	"Mortar",
[64]=	"Bazooka",
[66]=	"MP34",
}

function et_InitGame(levelTime, randomSeed, restart)

    local func_start = et.trap_Milliseconds()
    et.RegisterModname("kspree.lua "..version.." "..et.FindSelf())
    sv_maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))

	local fd, len = et.trap_FS_FOpenFile(shrubbot, et.FS_READ)
	if len > -1 then
		local content = et.trap_FS_Read(fd, len)
		for guid, level in string.gmatch(content, "[Gg]uid%s*=%s*(%x+)%s*\n[Ll]evel\t%= (%d)") do
			if tonumber(level) >= 2 then
				vips[guid] = true
			end
		end
		content = nil
	end
	et.trap_FS_FCloseFile(fd)

    local i = 0
    for i=0, sv_maxclients-1 do
        killing_sprees[i] = 0
        kmulti[i] = { [1]=0, [2]=0, }
        doublekill[i] = { [1]=0 }
        topshots[i] = { [1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0, [10]=0, [11]=0, [12]=0, [13]=0, [14]=0, [15]=0, [16]=0, [17]=0, [18]=0, [19]=0, [20]=0, [21]=0, [22]=0, [23]=0, [24]=0, [25]=0, [26]=0, [27]=0, [28]=0, [29]=0, [30]=0, [31]=0, [32]=0, [33]=0, [34]=0, [35]=0, [36]=0, [37]=0, [38]=0, [39]=0, [40]=0, [41]=0}
		vsstats[i]={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0,[15]=0,[16]=0,[17]=0,[18]=0,[19]=0,[20]=0,[21]=0,[22]=0,[23]=0,[24]=0,[25]=0,[26]=0,[27]=0,[28]=0,[29]=0,[30]=0,[31]=0,[32]=0,[33]=0,[34]=0,[35]=0,[36]=0,[37]=0,[38]=0,[39]=0,[40]=0,[41]=0,[42]=0,[43]=0,[44]=0,[45]=0,[46]=0,[47]=0,[48]=0,[49]=0,[50]=0,[51]=0,[52]=0,[53]=0,[54]=0,[55]=0,[56]=0,[57]=0,[58]=0,[59]=0,[60]=0,[61]=0,[62]=0,[63]=0}
		vsstats_kills[i]={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0,[15]=0,[16]=0,[17]=0,[18]=0,[19]=0,[20]=0,[21]=0,[22]=0,[23]=0,[24]=0,[25]=0,[26]=0,[27]=0,[28]=0,[29]=0,[30]=0,[31]=0,[32]=0,[33]=0,[34]=0,[35]=0,[36]=0,[37]=0,[38]=0,[39]=0,[40]=0,[41]=0,[42]=0,[43]=0,[44]=0,[45]=0,[46]=0,[47]=0,[48]=0,[49]=0,[50]=0,[51]=0,[52]=0,[53]=0,[54]=0,[55]=0,[56]=0,[57]=0,[58]=0,[59]=0,[60]=0,[61]=0,[62]=0,[63]=0}
		vsstats_deaths[i]={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0,[15]=0,[16]=0,[17]=0,[18]=0,[19]=0,[20]=0,[21]=0,[22]=0,[23]=0,[24]=0,[25]=0,[26]=0,[27]=0,[28]=0,[29]=0,[30]=0,[31]=0,[32]=0,[33]=0,[34]=0,[35]=0,[36]=0,[37]=0,[38]=0,[39]=0,[40]=0,[41]=0,[42]=0,[43]=0,[44]=0,[45]=0,[46]=0,[47]=0,[48]=0,[49]=0,[50]=0,[51]=0,[52]=0,[53]=0,[54]=0,[55]=0,[56]=0,[57]=0,[58]=0,[59]=0,[60]=0,[61]=0,[62]=0,[63]=0}
		worst_enemy[i]={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0,[15]=0,[16]=0,[17]=0,[18]=0,[19]=0,[20]=0,[21]=0,[22]=0,[23]=0,[24]=0,[25]=0,[26]=0,[27]=0,[28]=0,[29]=0,[30]=0,[31]=0,[32]=0,[33]=0,[34]=0,[35]=0,[36]=0,[37]=0,[38]=0,[39]=0,[40]=0,[41]=0,[42]=0,[43]=0,[44]=0,[45]=0,[46]=0,[47]=0,[48]=0,[49]=0,[50]=0,[51]=0,[52]=0,[53]=0,[54]=0,[55]=0,[56]=0,[57]=0,[58]=0,[59]=0,[60]=0,[61]=0,[62]=0,[63]=0}
		easiest_prey[i]={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0,[15]=0,[16]=0,[17]=0,[18]=0,[19]=0,[20]=0,[21]=0,[22]=0,[23]=0,[24]=0,[25]=0,[26]=0,[27]=0,[28]=0,[29]=0,[30]=0,[31]=0,[32]=0,[33]=0,[34]=0,[35]=0,[36]=0,[37]=0,[38]=0,[39]=0,[40]=0,[41]=0,[42]=0,[43]=0,[44]=0,[45]=0,[46]=0,[47]=0,[48]=0,[49]=0,[50]=0,[51]=0,[52]=0,[53]=0,[54]=0,[55]=0,[56]=0,[57]=0,[58]=0,[59]=0,[60]=0,[61]=0,[62]=0,[63]=0}
        mkps[i] = { [1]=0, [2]=0, [3]=0 }
        kills[i] = 0
        deaths[i] = 0
        dmg_given[i] = 0
		dmg_rcvd[i] = 0
		players[i] = nil
		teamswitch[i] = false
        client_msg[i] = false
        topshot_msg[i] = false
        if kmultitk_announce then
          kmultitk[i]   = { [1]=0, [2]=0, }
        end
        dmg_switch[i] = 0
		damage_received_temp[i] = 0
		u_flag[i] = false
		hitters[i] = {nil, nil, nil, nil, nil}
		death_time[i] = 0
        death_time_total[i] = 0
        spawns[i] = nil
    end

    i = readStats(kspree_cfg)
    et.G_Print("kspree.lua: loaded %d alltime stats from %s\n", i, kspree_cfg)

    if srv_record then
        i = readRecords(record_cfg)
        et.G_Print("kspree.lua: loaded %d alltime records from %s\n", i, record_cfg)
    end

--    et.trap_SendConsoleCommand(et.EXEC_NOW,"sets KSpree_version "..version)
    et.G_Print("bennz's kspree.lua version "..version.." activated...\n")
  et.G_Print("kspree.lua: startup: %d ms\n", et.trap_Milliseconds() - func_start)
end

function sayClients(pos, msg)
    --et.G_Print("kspree.lua: sayClients('%s', '%s')\n", pos, msg)
    --et.trap_SendServerCommand(-1, pos.." \""..msg.."^7\"\n")
    local message = string.format("%s \"%s^7\"", pos, msg)
	for id, msg_ok in pairs(client_msg) do
            if msg_ok then
                et.trap_SendServerCommand(id, message)
            end
        end
end

function topshot_sayClients(msg)
    local message = string.format("chat \"%s^7\"", msg)
	for id, msg_ok in pairs(topshot_msg) do
            if msg_ok then
                et.trap_SendServerCommand(id, message)
            end
        end
end

function soundClients(which_sound)
	et.trap_SendServerCommand(-1, "spl " .. which_sound)
end

function mapName ()
    return(string.lower(et.trap_Cvar_Get("mapname")))
end

function teamName (t)
    if t < 0 or t > 3 then
        t = 3
    end
    return(kteams[t])
end

local function roundNum(num, n)
	local mult = 10^(n or 0)
	return math.floor(num * mult + 0.5) / mult
end

function inSlot( PartName )
  local x=0
  local j=1
  local size=tonumber(et.trap_Cvar_Get("sv_maxclients"))     --get the serversize
  local matches = {}
  while (x<size) do
    found = string.find(string.lower(et.Q_CleanStr( et.Info_ValueForKey( et.trap_GetUserinfo( x ), "name" ) )),string.lower(PartName))
    if(found~=nil) then
        matches[j]=x
        j=j+1
    end
    x=x+1
  end
  if (#matches~=nil) then
    x=1
    while (x<=#matches) do
        matchingSlot = matches[x] 
      x=x+1
    end
    if #matches == 0 then
      et.G_Print("You had no matches to that name.\n")
      matchingSlot = nil
    else
      if #matches >= 2 then
        et.G_Print("Partial playername got more than 1 match\n")
        matchingSlot = nil
      end
    end
  end
  return matchingSlot
end

function getGuid (id)
    return(string.lower(et.Info_ValueForKey(et.trap_GetUserinfo(id), "cl_guid")))
end

function playerName(id)
    return(et.Info_ValueForKey(et.trap_GetUserinfo(id), "name"))
end

function findMaxKSpree()
    local max = alltime_stats[mapName()]
    if max == nil then
        max = {}
    end
    return(max)
end

function saveStats(file, list)
    local fd, len = et.trap_FS_FOpenFile(file, et.FS_WRITE)
    if len == -1 then
        et.G_Print("kspree.lua: failed to open %s", file)
        return(0)
    end
    local head = string.format("# %s, written %s\n", file, os.date())
    et.trap_FS_Write(head, string.len(head), fd)
	for first, arr in pairs(list) do
		local line = first .. ";".. table.concat(arr, ";").."\n"
		et.trap_FS_Write(line, string.len(line), fd)
	end

    et.trap_FS_FCloseFile(fd)
end

function readStats(file)
    local fd,len = et.trap_FS_FOpenFile( file, et.FS_READ )
    local count      = 0
    if len == -1 then
        et.G_Print("kspree.lua: no killingspree.txt\n")
        return(0)
    end
    local filestr = et.trap_FS_Read( fd, len )
    et.trap_FS_FCloseFile( fd )
    local map, frags, zwiebel, naim
    for map, frags, zwiebel, naim in string.gmatch(filestr,"[^%#]([%_%w]*)%;(%d*)%;(%d*)%;([^%\n]*)") do
        alltime_stats[map] = {
            tonumber(frags),
            tonumber(zwiebel),
            naim
        }
        count = count + 1
    end

    return(count)
end

function readRecords(file)
    local func_start = et.trap_Milliseconds()
    local fd,len = et.trap_FS_FOpenFile( file, et.FS_READ )
    local count      = 0

    if len == -1 then
        et.G_Print("kspree.lua: no Spree Records \n")
        et.G_Print("rspree.lua: readRecords(): %d ms\n", et.trap_Milliseconds() - func_start)
        return(0)
    end

    local guid,multi,mega,ultra,monster,ludic,kills,name,first,last
    local now = tonumber(os.time(os.date("!*t")))
    local exp_diff = now - records_expire
    local filestr = et.trap_FS_Read( fd, len )
    et.trap_FS_FCloseFile( fd )
    for guid,multi,mega,ultra,monster,ludic,kills,name,first,last in string.gmatch(filestr,
        "[^%#](%x+)%;(%d*)%;(%d*)%;(%d*)%;(%d*)%;(%d*)%;(%d*)%;([^;]*)%;(%d*)%;([^%\n]*)") do
        local seen = tonumber(last)
        if (records_expire == 0) or (exp_diff < seen) then
            srv_records[guid] = {
                tonumber(multi),
                tonumber(mega),
                tonumber(ultra),
                tonumber(monster),
                tonumber(ludic),
                tonumber(kills),
                name,
                tonumber(first),
                seen
            }
            count = count + 1
        end
    end


    et.G_Print("kspree.lua: readRecords(): %d ms\n", et.trap_Milliseconds() - func_start)
    return(count)
end

function getKeysSortedByValue(tbl, sortFunction)
	local keys = {}
	for key in pairs(tbl) do
		table.insert(keys, key)
	end

	table.sort(keys, function(a, b)
		return sortFunction(tbl[a], tbl[b])
	end)
	
	return keys
end

function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

function getAllHitRegions(clientNum)
	local regions = {}
	for index, hitType in ipairs(HR_TYPES) do
		regions[hitType] = et.gentity_get(clientNum, "pers.playerStats.hitRegions", hitType)
	end       
	return regions
end     

function hitType(clientNum)
	local playerHitRegions = getAllHitRegions(clientNum)
	if hitRegionsData[clientNum] == nil then
		hitRegionsData[clientNum] = playerHitRegions
		return 2
	end
	for index, hitType in ipairs(HR_TYPES) do
		if playerHitRegions[hitType] > hitRegionsData[clientNum][hitType] then
			hitRegionsData[clientNum] = playerHitRegions
			return hitType
		end		
	end
	hitRegionsData[clientNum] = playerHitRegions
	return -1
end

function et_Damage(target, attacker, damage, damageFlags, meansOfDeath)
	if target ~= attacker and attacker ~= 1022 and attacker ~= 1023 and not (tonumber(target) < 0) and not (tonumber(target) > tonumber(et.trap_Cvar_Get("sv_maxclients"))) then
		if has_value(light_weapons, meansOfDeath) or has_value(explosives, meansOfDeath) then
			local v_team = et.gentity_get(target, "sess.sessionTeam")
			local k_team = et.gentity_get(attacker, "sess.sessionTeam")
			local v_health = et.gentity_get(target, "health")
			local hitType = hitType(attacker)
			if hitType == HR_HEAD then
				if not has_value(explosives, meansOfDeath) then
					hitters[target][et.trap_Milliseconds()] = {[1]=attacker, [2]=damage, [3]=1, [4]=meansOfDeath}
					if v_team ~= k_team then
						if damage >= v_health then
							topshots[attacker][38] = topshots[attacker][38] + 1
						end
					end
				end
			else
				hitters[target][et.trap_Milliseconds()] = {[1]=attacker, [2]=damage, [3]=0, [4]=meansOfDeath}
			end
		end
	end
end

function topshots_f(id)
	local max = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 100}
	local max_id = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	local i = 0
	for i=0, sv_maxclients-1 do
		local team = tonumber(et.gentity_get(i, "sess.sessionTeam"))
		if team == 1 or team == 2 then
			local dg = tonumber(et.gentity_get(i, "sess.damage_given"))
			local dr = tonumber(et.gentity_get(i, "sess.damage_received"))
			local tdg = tonumber(et.gentity_get(i, "sess.team_damage"))
			local tdr = tonumber(et.gentity_get(i, "sess.team_received"))
			local tk = tonumber(et.gentity_get(i, "sess.team_kills"))
			local sk = tonumber(et.gentity_get(i, "sess.self_kills"))
			local d = tonumber(et.gentity_get(i, "sess.deaths"))
			local k = tonumber(et.gentity_get(i, "sess.kills"))
			local gibs = tonumber(et.gentity_get(i, "sess.gibs"))
			local kd = 0
			local kr = 0
			local timeplayed = tonumber(et.gentity_get(i, "sess.time_axis")) + tonumber(et.gentity_get(i, "sess.time_allies"))
			if death_time[i] ~= 0 then
				local diff = et.trap_Milliseconds() - death_time[i]
				death_time_total[i] = death_time_total[i] + diff
			end

			if d ~= 0 then
				kd = k/d
			else
				kd = k + 1
			end
			
			-- damage given
			if dg > max[1] then 
				max[1] = dg
				max_id[1] = i
			end
			-- damage received
			if dr > max[2] then 
				max[2] = dr
				max_id[2] = i
			end
			-- team damage given
			if tdg > max[3] then 
				max[3] = tdg
				max_id[3] = i
			end
			-- team damage received
			if tdr > max[4] then 
				max[4] = tdr
				max_id[4] = i
			end
			-- teamkills
			if tk > max[5] then 
				max[5] = tk
				max_id[5] = i
			end
			-- selfkills
			if sk > max[6] then 
				max[6] = sk
				max_id[6] = i
			end
			-- deaths
			if d > max[7] then 
				max[7] = d
				max_id[7] = i
			end
			-- kills per minute
			if k > 10 then
				local kpm = 0
				if eomaptime == 0 then
					kpm = k/((timeplayed/1000)/60)
				else
					kpm = k/((timeplayed/1000)/60)
				end
				if kpm > max[8] then
					max[8] = kpm
					max_id[8] = i
				end
			end
			-- quickest lightweapon multikill
			if topshots[i][14] >= max[9] then 
				if topshots[i][14] > max[9] then
					max[9] = topshots[i][14]
					max[10] = topshots[i][15]
					max_id[9] = i
					max_id[10] = i
				elseif topshots[i][14] == max[9] then
					if topshots[i][15] < max[10] then
						max[9] = topshots[i][14]
						max[10] = topshots[i][15]
						max_id[9] = i
						max_id[10] = i
					end
				end
			end
			-- farthest riflegrenade kill
			if topshots[i][16] > max[11] then
				max[11] = topshots[i][16]
				max_id[11] = i
			end
			-- lightweapon kills
			if topshots[i][1] > max[12] then
				max[12] = topshots[i][1]
				max_id[12] = i
			end
			-- pistol kills
			if topshots[i][2] > max[13] then
				max[13] = topshots[i][2]
				max_id[13] = i
			end
			-- rifle kills
			if topshots[i][3] > max[14] then
				max[14] = topshots[i][3]
				max_id[14] = i
			end
			-- riflegrenade kills
			if topshots[i][4] > max[15] then
				max[15] = topshots[i][4]
				max_id[15] = i
			end
			-- sniper kills
			if topshots[i][5] > max[16] then
				max[16] = topshots[i][5]
				max_id[16] = i
			end
			-- knife kills
			if topshots[i][6] > max[17] then
				max[17] = topshots[i][6]
				max_id[17] = i
			end
			-- air support kills
			if topshots[i][7] > max[18] then
				max[18] = topshots[i][7]
				max_id[18] = i
			end
			-- mine kills
			if topshots[i][8] > max[19] then
				max[19] = topshots[i][8]
				max_id[19] = i
			end
			-- grenade kills
			if topshots[i][9] > max[20] then
				max[20] = topshots[i][9]
				max_id[20] = i
			end
			-- panzerfaust kills
			if topshots[i][10] > max[21] then
				max[21] = topshots[i][10]
				max_id[21] = i
			end
			-- mortar kills
			if topshots[i][11] > max[22] then
				max[22] = topshots[i][11]
				max_id[22] = i
			end
			-- panzerfaust deaths
			if topshots[i][12] > max[23] then
				max[23] = topshots[i][12]
				max_id[23] = i
			end
			-- mortar deaths
			if topshots[i][13] > max[24] then
				max[24] = topshots[i][13]
				max_id[24] = i
			end
			-- multikills
			if topshots[i][17] > max[25] then
				max[25] = topshots[i][17]
				max_id[25] = i
			end
			-- mg42 kills
			if topshots[i][18] > max[26] then
				max[26] = topshots[i][18]
				max_id[26] = i
			end
			-- mg42 deaths
			if topshots[i][19] > max[27] then
				max[27] = topshots[i][19]
				max_id[27] = i
			end
			-- most revives
			if topshots[i][20] > max[28] then
				max[28] = topshots[i][20]
				max_id[28] = i
			end
			-- most revived
			if topshots[i][21] > max[29] then
				max[29] = topshots[i][21]
				max_id[29] = i
			end
			-- adrenaline junkie
			if topshots[i][22] > max[30] then
				max[30] = topshots[i][22]
				max_id[30] = i
			end
			-- k/d ratio
			if k > 9 then
				if kd > max[31] then
					max[31] = kd
					max_id[31] = i
				end
			end
			-- most healthpacks taken
			if topshots[i][23] > max[32] then
				max[32] = topshots[i][23]
				max_id[32] = i
			end
			-- most ammopacks taken
			if topshots[i][24] > max[33] then
				max[33] = topshots[i][24]
				max_id[33] = i
			end
			-- most dynamites planted
			if topshots[i][25] > max[34] then
				max[34] = topshots[i][25]
				max_id[34] = i
			end
			-- most dynamites defused
			if topshots[i][26] > max[35] then
				max[35] = topshots[i][26]
				max_id[35] = i
			end
			-- most doublekills
			local dk = topshots[i][27] - topshots[i][17]
			if dk > max[36] then
				max[36] = dk
				max_id[36] = i
			end
			-- most shoves
			if topshots[i][28] > max[37] then
				max[37] = topshots[i][28]
				max_id[37] = i
			end
			-- most shoved
			if topshots[i][29] > max[38] then
				max[38] = topshots[i][29]
				max_id[38] = i
			end
			-- most objectives stolen
			if topshots[i][30] > max[39] then
				max[39] = topshots[i][30]
				max_id[39] = i
			end
			-- most objectives returned
			if topshots[i][31] > max[40] then
				max[40] = topshots[i][31]
				max_id[40] = i
			end
			-- rambo medic
			if topshots[i][32] > 20 then -- medic kills
				if topshots[i][20] > 0 then -- revives
					kr = topshots[i][32] / topshots[i][20]
				else
					kr = topshots[i][32] + 1
				end
				if kr >= 4 then
					if kr > max[41] then
						max[41] = kr
						max_id[41] = i
					end
				end
			end
			-- can't shut up
			if topshots[i][33] > 10 then
				if topshots[i][33] > max[42] then
					max[42] = topshots[i][33]
					max_id[42] = i
				end
			end
			-- most IFSKs
			if topshots[i][34] > max[43] then
				max[43] = topshots[i][34]
				max_id[43] = i
			end
			-- most uniforms stolen
			if topshots[i][35] > max[44] then
				max[44] = topshots[i][35]
				max_id[44] = i
			end
			-- most gibs
			if gibs > max[45] then 
				max[45] = gibs
				max_id[45] = i
			end
			-- most kill assists
			if topshots[i][36] > max[46] then
				max[46] = topshots[i][36]
				max_id[46] = i
			end
			-- most killsteals
			if topshots[i][37] > max[47] then
				max[47] = topshots[i][37]
				max_id[47] = i
			end
			-- most headshot kills
			if topshots[i][38] > max[48] then
				max[48] = topshots[i][38]
				max_id[48] = i
			end
			-- damage per minute
			if dg > 1400 then
				local dpm = 0
				if eomaptime == 0 then
					dpm = dg/((timeplayed/1000)/60)
				else
					dpm = dg/((timeplayed/1000)/60)
				end
				if dpm > max[49] then
					max[49] = dpm
					max_id[49] = i
				end
			end
			-- tank (damage received/deaths)
			if dr > 2000 then
				local drdr = 0
				if d ~= 0 then
					drdr = (dr / d) / 130
				else
					drdr = (dr + 1) / 130
				end
				if drdr > 3 then
					max[50] = drdr
					max_id[50] = i
				end
			end
			-- most useful kills
			if topshots[i][41] > max[51] then
				max[51] = topshots[i][41]
				max_id[51] = i
			end
			-- most time dead
			if timeplayed > 600000 or timeplayed == et.trap_Cvar_Get("timelimit") then
				if (death_time_total[i] / timeplayed) * 100 > max[52] then
					max[52] = (death_time_total[i] / timeplayed) * 100
					max_id[52] = i
					max[54] = death_time_total[i]
				end
			end
			-- least time dead
			if timeplayed > 600000 or timeplayed == et.trap_Cvar_Get("timelimit") then
				if (death_time_total[i] / timeplayed) * 100 < max[53] then
					max[53] = (death_time_total[i] / timeplayed) * 100
					max_id[53] = i
					max[55] = death_time_total[i]
				end
			end
		end
	end
	if id == -2 then
		local ws_max = { 0, 0, 0, 0 }
		local ws_max_id = { 0, 0, 0, 0 }
		local cnt = 0
		for cnt=0, sv_maxclients-1 do
			if endplayers[cnt] then
				-- highest light weapons accuracy
				if weaponstats[cnt][2] > 100 then
					if (weaponstats[cnt][1]/weaponstats[cnt][2])*100 > ws_max[1] then
						ws_max[1] = (weaponstats[cnt][1]/weaponstats[cnt][2])*100
						ws_max_id[1] = cnt
					end
				end
				-- highest headshot accuracy
				if weaponstats[cnt][1] > 10 and weaponstats[cnt][2] > 100 then
					if (weaponstats[cnt][3]/weaponstats[cnt][1])*100 > ws_max[2] then
						ws_max[2] = (weaponstats[cnt][3]/weaponstats[cnt][1])*100
						ws_max_id[2] = cnt
					end
				end
				-- most headshots
				if weaponstats[cnt][3] > ws_max[3] then
					ws_max[3] = weaponstats[cnt][3]
					ws_max_id[3] = cnt
				end
				-- most bullets fired
				if weaponstats[cnt][2] > ws_max[4] then
					ws_max[4] = weaponstats[cnt][2]
					ws_max_id[4] = cnt
				end
			end
		end
		local j = 1
		local players2 = {}
		for j=1, 53 do
			if (max[j] > 1 and j ~= 53) or (j == 53 and max[j] ~= 100) then
				if j ~= 10 and j ~= 25 and j ~= 36 and j ~= 49 then
					if j == 1 then
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. max[j] .. "\"\n")
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							max[j]
						})
						if max[49] > 1 then
							--topshot_sayClients("^z" .. topshot_names[49] .. ": " .. et.gentity_get(max_id[49], "pers.netname") .. " ^z- ^1" .. max[49] .. "\"\n")
							table.insert(players2, {
								topshot_names[49],
								et.gentity_get(max_id[49], "pers.netname"),
								math.floor(max[49])
							})
						end
					elseif j == 8 then
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. roundNum(max[j], 2) .. "\"\n")
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							roundNum(max[j], 2)
						})
					elseif j == 9 then
						-- dirty "fix" instead of reordering all indexes lol
						if max[36] > 1 then
							--topshot_sayClients("^z" .. topshot_names[36] .. ": " .. et.gentity_get(max_id[36], "pers.netname") .. " ^z- ^1" .. max[36] .. "\"\n")
							table.insert(players2, {
								topshot_names[36],
								et.gentity_get(max_id[36], "pers.netname"),
								max[36]
							})
						end
						--topshot_sayClients("^z" .. topshot_names[25] .. ": " .. et.gentity_get(max_id[25], "pers.netname") .. " ^z- ^1" .. max[25] .. "\"\n")
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. max[j] .. " ^zkills in ^1" .. roundNum(max[10]/1000, 3) .. " ^zseconds\"\n")
						table.insert(players2, {
							topshot_names[25],
							et.gentity_get(max_id[25], "pers.netname"),
							max[25]
						})
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							max[j] .. " ^7kills in " .. roundNum(max[10]/1000, 2) .. "s"
						})
					elseif j == 11 then
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. roundNum(max[j], 2) .. " ^zm\"\n")
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							roundNum(max[j], 2) .. " ^7m"
						})
					elseif j == 30 then
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. max[j] .. " ^zuses\"\n")
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							max[j] .. " ^7uses"
						})
					elseif j == 31 then
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. roundNum(max[j], 2) .. "\"\n")
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							roundNum(max[j], 2)
						})
					elseif j == 41 then
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. topshots[max_id[j]][32] .. " ^zMedic kills, ^1" .. topshots[max_id[j]][20] .. " ^zrevives\"\n")
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							topshots[max_id[j]][32] .. " ^7Medic kills, " .. topshots[max_id[j]][20] .. " revives"
						})
					elseif j == 42 then
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. max[j] .. " ^zchats\"\n")
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							max[j] .. " ^7chats"
						})
					elseif j == 50 then
						--et.trap_SendServerCommand(-1, "chat \"^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. roundNum(max[j], 2) .. " ^zpercent\"\n")
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							"^7Damage received vs death ratio: " .. roundNum(max[j], 2) .. "^7x"
						})
					elseif j == 52 or j == 53 then
						--et.trap_SendServerCommand(-1, "chat \"^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. roundNum(max[j], 2) .. " ^zpercent, ^1" .. roundNum((max[j+2] / 60000), 2) .. " ^zmin\"\n")
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							roundNum(max[j], 2) .. " ^7percent, " .. roundNum((max[j+2] / 60000), 2) .. " ^7min"
						})
					else
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. max[j] .. "\"\n")
						table.insert(players2, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							max[j]
						})
					end
				end
			end
		end
		local z = 1
		for z = 1, 4 do
			if ws_max[z] > 1 then
				if z == 1 then
					--topshot_sayClients("^zHighest light weapons accuracy: " .. et.gentity_get(ws_max_id[z], "pers.netname") .. " ^z- ^1" .. roundNum(ws_max[z], 2) .. " ^zpercent\"\n")
					table.insert(players2, {
						"Highest light weapons accuracy",
						et.gentity_get(ws_max_id[z], "pers.netname"),
						roundNum(ws_max[z], 2) .. " percent"
					})
				elseif z == 2 then
					--topshot_sayClients("^zHighest headshot accuracy: " .. et.gentity_get(ws_max_id[z], "pers.netname") .. " ^z- ^1" .. roundNum(ws_max[z], 2) .. " ^zpercent\"\n")
					table.insert(players2, {
						"Highest headshot accuracy",
						et.gentity_get(ws_max_id[z], "pers.netname"),
						roundNum(ws_max[z], 2) .. " percent"
					})
				elseif z == 3 then
					--topshot_sayClients("^zMost headshots: " .. et.gentity_get(ws_max_id[z], "pers.netname") .. " ^z- ^1" .. ws_max[z] .. "\"\n")
					table.insert(players2, {
						"Most headshots",
						et.gentity_get(ws_max_id[z], "pers.netname"),
						ws_max[z]
					})
				elseif z == 4 then
					--topshot_sayClients("^zMost bullets fired: " .. et.gentity_get(ws_max_id[z], "pers.netname") .. " ^z- ^1" .. ws_max[z] .. "\"\n")
					table.insert(players2, {
						"Most bullets fired",
						et.gentity_get(ws_max_id[z], "pers.netname"),
						ws_max[z]
					})
				end
			end
		end
		send_table(-1, {
			{name = "Award"                 },
			{name = "Player",  align = "right"},
			{name = "Value", align = "right"},
		}, players2)
		local p = 0
		for p=0, sv_maxclients-1 do
			local t = tonumber(et.gentity_get(p, "sess.sessionTeam"))
			if t == 1 or t == 2 then
				et.trap_SendServerCommand(p, "cpm \"^zKills: ^1" .. kills[p] .. " ^z- Deaths: ^1" .. deaths[p] .. " ^z- Damage given: ^1" .. tonumber(et.gentity_get(p, "sess.damage_given")) .. "\"\n")
				local top_we = {0, 0}
				local top_ep = {0, 0}
				local e = 0
				for e=0, sv_maxclients-1 do
					if e ~= p then
						local t2 = tonumber(et.gentity_get(e, "sess.sessionTeam"))
						if t2 == 1 or t2 == 2 then
							if t ~= t2 then
								vsstats_f(p, e, true)
								if worst_enemy[p][e] > top_we[1] then
									top_we[1] = worst_enemy[p][e]
									top_we[2] = e
								end
								if easiest_prey[p][e] > top_ep[1] then
									top_ep[1] = easiest_prey[p][e]
									top_ep[2] = e
								end
							end
						end
					end
				end
				local sortedKeys = getKeysSortedByValue(vsstats_kills[p], function(a, b) return a > b end)
				local players3 = {}
				for _, key in ipairs(sortedKeys) do
					if not (vsstats_kills[p][key] == 0 and vsstats_deaths[p][key] == 0) then
						local t3 = tonumber(et.gentity_get(key, "sess.sessionTeam"))
						if t3 == 1 or t3 == 2 then
							if t ~= t3 then
								--et.trap_SendServerCommand(p, "chat \"" .. et.gentity_get(key, "pers.netname") .. "^7: ^3Kills: ^7" .. vsstats_kills[p][key] .. " ^3Deaths: ^7" .. vsstats_deaths[p][key] .. "\"")
								table.insert(players3, {
									et.gentity_get(key, "pers.netname"),
									vsstats_kills[p][key],
									vsstats_deaths[p][key]
								})
							end
						end
					end
				end
				send_table(p, {
					{name = "Player"                 },
					{name = "Kills",  align = "right"},
					{name = "Deaths", align = "right"},
				}, players3)

				if top_ep[1] > 3 then
					et.trap_SendServerCommand(p, "cpm \"^zEasiest prey: " .. et.gentity_get(top_ep[2], "pers.netname") .. "^z- Kills: ^1" .. top_ep[1] .. "\"\n")
				end
				if top_we[1] > 3 then
					et.trap_SendServerCommand(p, "cpm \"^zWorst enemy: " .. et.gentity_get(top_we[2], "pers.netname") .. "^z- Deaths: ^1" .. top_we[1] .. "\"\n")
				end
			end
		end
	else
		local ws_max = { 0, 0, 0, 0 }
		local ws_max_id = { 0, 0, 0, 0 }
		local cnt = 0
		local aweaponstats = {}
		for cnt=0, sv_maxclients-1 do
			local ws
			local hits = 0
			local shots = 0
			local hs = 0
			for j = 2, 6 do
				ws = et.gentity_get(cnt, "sess.aWeaponStats", j)
				hits = hits + ws[4]
				shots = shots + ws[1]
				hs = hs + ws[3]
				if j == 6 then
					ws = et.gentity_get(cnt, "sess.aWeaponStats", 26)
					hits = hits + ws[4]
					shots = shots + ws[1]
					hs = hs + ws[3]
				end
			end
			aweaponstats[cnt] = { [1]=hits, [2]=shots, [3]=hs }
			-- highest light weapons accuracy
			if aweaponstats[cnt][2] > 100 then
				if (aweaponstats[cnt][1]/aweaponstats[cnt][2])*100 > ws_max[1] then
					ws_max[1] = (aweaponstats[cnt][1]/aweaponstats[cnt][2])*100
					ws_max_id[1] = cnt
				end
			end
			-- highest headshot accuracy
			if aweaponstats[cnt][1] > 10 and aweaponstats[cnt][2] > 100 then
				if (aweaponstats[cnt][3]/aweaponstats[cnt][1])*100 > ws_max[2] then
					ws_max[2] = (aweaponstats[cnt][3]/aweaponstats[cnt][1])*100
					ws_max_id[2] = cnt
				end
			end
			-- most headshots
			if aweaponstats[cnt][3] > ws_max[3] then
				ws_max[3] = aweaponstats[cnt][3]
				ws_max_id[3] = cnt
			end
			-- most bullets fired
			if aweaponstats[cnt][2] > ws_max[4] then
				ws_max[4] = aweaponstats[cnt][2]
				ws_max_id[4] = cnt
			end
		end
		local players4 = {}
		for j=1, 53 do
			if (max[j] > 1 and j ~= 53) or (j == 53 and max[j] ~= 100) then
				if j ~= 10 and j ~= 25 and j ~= 36 and j ~= 49 then
					if j == 1 then
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. max[j] .. "\"\n")
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							max[j]
						})
						if max[49] > 1 then
							--topshot_sayClients("^z" .. topshot_names[49] .. ": " .. et.gentity_get(max_id[49], "pers.netname") .. " ^z- ^1" .. max[49] .. "\"\n")
							table.insert(players4, {
								topshot_names[49],
								et.gentity_get(max_id[49], "pers.netname"),
								math.floor(max[49])
							})
						end
					elseif j == 8 then
						--et.trap_SendServerCommand(id, "cpm \"^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. roundNum(max[j], 2) .. "\"\n")
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							roundNum(max[j], 2)
						})
					elseif j == 9 then
						-- dirty "fix" instead of reordering all indexes lol
						if max[36] > 1 then
							--et.trap_SendServerCommand(id, "cpm \"^z" .. topshot_names[36] .. ": " .. et.gentity_get(max_id[36], "pers.netname") .. " ^z- ^1" .. max[36] .. "\"\n")
							table.insert(players4, {
								topshot_names[36],
								et.gentity_get(max_id[36], "pers.netname"),
								max[36]
							})
						end
						--et.trap_SendServerCommand(id, "cpm \"^z" .. topshot_names[25] .. ": " .. et.gentity_get(max_id[25], "pers.netname") .. " ^z- ^1" .. max[25] .. "\"\n")
						--et.trap_SendServerCommand(id, "cpm \"^z" .. topshot_names[j].. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. max[j] .. " ^zkills in ^1" .. roundNum(max[10]/1000, 3) .. " ^zseconds\"\n")
						table.insert(players4, {
							topshot_names[25],
							et.gentity_get(max_id[25], "pers.netname"),
							max[25]
						})
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							max[j] .. " ^7kills in " .. roundNum(max[10]/1000, 3) .. " s"
						})
					elseif j == 11 then
						--et.trap_SendServerCommand(id, "cpm \"^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. roundNum(max[j], 2) .. " ^zm\"\n")
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							roundNum(max[j], 2) .. " ^7m"
						})
					elseif j == 30 then
						--et.trap_SendServerCommand(id, "cpm \"^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. max[j] .. " ^zuses\"\n")
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							max[j] .. " ^7uses"
						})
					elseif j == 31 then
						--et.trap_SendServerCommand(id, "cpm \"^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. roundNum(max[j], 2) .. " \"\n")
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							roundNum(max[j], 2)
						})
					elseif j == 41 then
						--et.trap_SendServerCommand(id, "cpm \"^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. topshots[max_id[j]][32] .. " ^zMedic kills, ^1" .. topshots[max_id[j]][20] .. " ^zrevives\"\n")
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							topshots[max_id[j]][32] .. " ^7Medic kills, " .. topshots[max_id[j]][20] .. " revives"
						})
					elseif j == 42 then
						--topshot_sayClients("^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. max[j] .. " ^zchats\"\n")
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							max[j] .. " ^7chats"
						})
					elseif j == 50 then
						--et.trap_SendServerCommand(-1, "chat \"^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. roundNum(max[j], 2) .. " ^zpercent\"\n")
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							"^7Damage received vs death ratio: " .. roundNum(max[j], 2) .. "^7x"
						})
					elseif j == 52 or j == 53 then
						--et.trap_SendServerCommand(-1, "chat \"^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. roundNum(max[j], 2) .. " ^zpercent, ^1" .. roundNum((max[j+2] / 60000), 2) .. " ^zmin\"\n")
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							roundNum(max[j], 2) .. " ^7percent, " .. roundNum((max[j+2] / 60000), 2) .. " ^7min"
						})
					else
						--et.trap_SendServerCommand(id, "cpm \"^z" .. topshot_names[j] .. ": " .. et.gentity_get(max_id[j], "pers.netname") .. " ^z- ^1" .. max[j] .. "\"\n")
						table.insert(players4, {
							topshot_names[j],
							et.gentity_get(max_id[j], "pers.netname"),
							max[j]
						})
					end
				end
			end
		end
		local z = 1
		for z = 1, 4 do
			if ws_max[z] > 1 then
				if z == 1 then
					--topshot_sayClients("^zHighest light weapons accuracy: " .. et.gentity_get(ws_max_id[z], "pers.netname") .. " ^z- ^1" .. roundNum(ws_max[z], 2) .. " ^zpercent\"\n")
					table.insert(players4, {
						"Highest light weapons accuracy",
						et.gentity_get(ws_max_id[z], "pers.netname"),
						roundNum(ws_max[z], 2) .. " percent"
					})
				elseif z == 2 then
					--topshot_sayClients("^zHighest headshot accuracy: " .. et.gentity_get(ws_max_id[z], "pers.netname") .. " ^z- ^1" .. roundNum(ws_max[z], 2) .. " ^zpercent\"\n")
					table.insert(players4, {
						"Highest headshot accuracy",
						et.gentity_get(ws_max_id[z], "pers.netname"),
						roundNum(ws_max[z], 2) .. " percent"
					})
				elseif z == 3 then
					--topshot_sayClients("^zMost headshots: " .. et.gentity_get(ws_max_id[z], "pers.netname") .. " ^z- ^1" .. ws_max[z] .. "\"\n")
					table.insert(players4, {
						"Most headshots",
						et.gentity_get(ws_max_id[z], "pers.netname"),
						ws_max[z]
					})
				elseif z == 4 then
					--topshot_sayClients("^zMost bullets fired: " .. et.gentity_get(ws_max_id[z], "pers.netname") .. " ^z- ^1" .. ws_max[z] .. "\"\n")
					table.insert(players4, {
						"Most bullets fired",
						et.gentity_get(ws_max_id[z], "pers.netname"),
						ws_max[z]
					})
				end
			end
		end
		send_table(id, {
			{name = "Award"                 },
			{name = "Player",  align = "right"},
			{name = "Value", align = "right"},
		}, players4)
	end
end

function vsstats_f(id, id2, flag)
	local ratio = 0
	if vsstats[id2][id] == 0 then
		ratio = vsstats[id][id2]
	else
		if vsstats[id][id2] == 0 then
			ratio = -vsstats[id2][id]
		else
			ratio = roundNum(vsstats[id][id2]/vsstats[id2][id], 2)
		end
	end
	if flag == false then
		et.trap_SendServerCommand(-1, "chat \"^7Current map's versus stats for: " .. et.gentity_get(id, "pers.netname") .. " ^7vs. " .. et.gentity_get(id2, "pers.netname") .. "^7: ^3Kills: ^7" .. vsstats[id][id2] .. " ^3Deaths: ^7" .. vsstats[id2][id] .. " ^3Ratio: ^7" .. ratio .. "\"")
	elseif flag == true then
		if not (vsstats[id][id2] == 0 and vsstats[id2][id] == 0) then
			vsstats_kills[id][id2] = vsstats[id][id2]
			vsstats_deaths[id][id2] = vsstats[id2][id]
			--et.trap_SendServerCommand(id, "chat \"" .. et.gentity_get(id2, "pers.netname") .. "^7: ^3Kills: ^7" .. vsstats[id][id2] .. " ^3Deaths: ^7" .. vsstats[id2][id] .. " ^3Ratio: ^7" .. ratio .. "\"")
		end
	end
end

function et_Print(text)
	if gamestate == 0 then
		if string.find(text, "Medic_Revive") then
			local junk1,junk2,medic,zombie = string.find(text, "^Medic_Revive:%s+(%d+)%s+(%d+)")
			topshots[tonumber(medic)][20] = topshots[tonumber(medic)][20] + 1
			topshots[tonumber(zombie)][21] = topshots[tonumber(zombie)][21] + 1
			if thanks then
				last_revive[tonumber(zombie)] = {playerName(tonumber(medic)) , et.trap_Milliseconds()}
			end
		end
		if string.find(text, "Ammo_Pack") then -- use the same medic logic
			local junk1,junk2,medic,zombie = string.find(text, "^Ammo_Pack:%s+(%d+)%s+(%d+)")
			local team1 = tonumber(et.gentity_get(medic, "sess.sessionTeam"))
			local team2 = tonumber(et.gentity_get(zombie, "sess.sessionTeam"))
			if team1 == team2 then
				if thanks then
					last_revive[tonumber(zombie)] = {playerName(tonumber(medic)) , et.trap_Milliseconds()}
				end
			end
		end
		if string.find(text, "item_health") then
	        local i, j = string.find(text, "%d+")
   	     local id = tonumber(string.sub(text, i, j))
   		 topshots[id][23] = topshots[id][23] + 1
		end
        if string.find(text, "weapon_magicammo") then
   	     local i, j = string.find(text, "%d+")   
	        local id = tonumber(string.sub(text, i, j))
			topshots[id][24] = topshots[id][24] + 1
	    end
		if string.find(text, "Dynamite_Plant") then
   	     local i, j = string.find(text, "%d+")   
	        local id = tonumber(string.sub(text, i, j))
			topshots[id][25] = topshots[id][25] + 1
	    end
		if string.find(text, "Dynamite_Diffuse") then
	   	 local i, j = string.find(text, "%d+")   
		    local id = tonumber(string.sub(text, i, j))
			topshots[id][26] = topshots[id][26] + 1
	    end
		if string.find(text, "Shove:%s+%d+%s+%d+") then
			local junk1,junk2,id1,id2 = string.find(text, "Shove:%s+(%d+)%s+(%d+)")
			topshots[tonumber(id1)][28] = topshots[tonumber(id1)][28] + 1
			topshots[tonumber(id2)][29] = topshots[tonumber(id2)][29] + 1
		end
		if string.find(text, "team_CTF_redflag") or string.find(text, "team_CTF_blueflag") then
   	     local i, j = string.find(text, "%d+")   
	        local id = tonumber(string.sub(text, i, j))
			if string.find(text, "team_CTF_redflag") then
				local team = tonumber(et.gentity_get(id, "sess.sessionTeam"))
				if team == 2 then
					topshots[id][30] = topshots[id][30] + 1
				elseif team == 1 then
					topshots[id][31] = topshots[id][31] + 1
				end
			elseif string.find(text, "team_CTF_blueflag") then
				local team = tonumber(et.gentity_get(id, "sess.sessionTeam"))
				if team == 1 then
					topshots[id][30] = topshots[id][30] + 1
				elseif team == 2 then
					topshots[id][31] = topshots[id][31] + 1
				end
			end
	    end
	
		if string.find(text, "LUA event: match auto-paused") then
			changedred = true
			redflag = false
			changedblue = true
			blueflag = false
		end
	end

    if kendofmap and string.find(text, "^WeaponStats: ") == 1 then
		if endplayerscnt < tblcount then
			for id, m, bla in string.gmatch(text, "WeaponStats: ([%d]+) [%d]+ ([%d]+) ([^\n]+)") do
				if endplayers[tonumber(id)] then
					if weaponstats[tonumber(id)] == nil then
						endplayerscnt = endplayerscnt + 1
						local ws
						local hits = 0
						local shots = 0
						local hs = 0
						for j = 2, 6 do
							ws = et.gentity_get(tonumber(id), "sess.aWeaponStats", j)
							hits = hits + ws[4]
							shots = shots + ws[1]
							hs = hs + ws[3]
							if j == 6 then
								ws = et.gentity_get(tonumber(id), "sess.aWeaponStats", 26)
								hits = hits + ws[4]
								shots = shots + ws[1]
								hs = hs + ws[3]
							end
						end
						weaponstats[tonumber(id)] = { [1]=hits, [2]=shots, [3]=hs }
					end
				end
			end
			if endplayerscnt == tblcount then
				eomap_done = true
				eomaptime = et.trap_Milliseconds() + 1000
				if kmax_id ~= nil then
      	          local re_name = playerName(kmax_id)
  	              if re_name == "" then
   	                 re_name = "^0MIA" -- missing in action
 	               end
  	              local longest = ""
  	              local max     = findMaxKSpree()
  	              if #max == 3 then
   	                 if kmap_record then
     	                   longest = " ^"..kspree_color.."This is a New map record!"
   	                     saveStats(kspree_cfg, alltime_stats)
    	                else
     	                   longest = string.format(" ^7[record: %d by %s^7 @%s]", max[1], max[3], os.date(date_fmt, max[2]))
     	               end
   	             end
  	              local msg = string.format("^7Longest killing spree: %s^7 with %d kills!%s", re_name, kmax_spree, longest)
  	              if kspree_announce then
						kspree_endmsg = msg
  	              end
  	          end
  	          if srv_record then
   	             saveStats(record_cfg, srv_records)
  	          end
			end
		end
        return(nil)
    end

    if text == "Exit: Timelimit hit.\n" or text == "Exit: Wolf EndRound.\n" then
    	local x = 0
	    for x=0,sv_maxclients-1 do
			local team = tonumber(et.gentity_get(x, "sess.sessionTeam"))
			if team == 1 or team == 2 then
				endplayers[x] = true
			end
		end
		for _ in pairs(endplayers) do
			tblcount = tblcount + 1
		end
        kendofmap = true
        for i = 0, sv_maxclients-1 do
            if killing_sprees[i] > 0 then
                checkKSpreeEnd(i, 1022, true)
            end
        end
        if last_b ~= "" and last_blood then
            msg = string.format("^7And the final kill of this round goes to: %s ^7!", last_b )
            et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \""..msg.."^7\"\n")
        end
        return(nil)
    end
end

function checkMultiKill (id, mod)
    local lvltime = et.trap_Milliseconds()
    if (lvltime - kmulti[id][1]) < 3000 then
        kmulti[id][2] = kmulti[id][2] + 1
        if mod==6 or mod==7 or mod==8 or mod==9 or mod==53 or mod==54 then
        	mkps[id][1] = mkps[id][1] + 1
        	if mkps[id][2] == 0 then
   	     	mkps[id][2] = lvltime
    		else
    			mkps[id][3] = et.trap_Milliseconds()
			end
        	if mkps[id][1] >= 3 then
	        	if mkps[id][1] >= topshots[id][14] then
	    	    	if mkps[id][1] > topshots[id][14] then
   	     			topshots[id][14] = mkps[id][1]
    					topshots[id][15] = mkps[id][3] - mkps[id][2]
    	    		elseif mkps[id][1] == topshots[id][14] then
    					if (mkps[id][3] - mkps[id][2]) < topshots[id][15] then
    						topshots[id][15] = mkps[id][3] - mkps[id][2]
    					end
     	   		end
     	   	end
     		end
        end
        
        if mod==6 or mod==7 or mod==12 or mod==45 or mod==53 or mod==54 or mod==55 or mod==56 then
        	doublekill[id][1] = doublekill[id][1] + 1
        end

		if doublekill[id][1] == 2 then
			wait_table[id] = {lvltime, 666}
			doublekill[id][1] = 0
		end
		if kmulti[id][2] == 2 then
			topshots[id][27] = topshots[id][27] + 1
        elseif kmulti[id][2] == 3 then
            wait_table[id] = {lvltime, 1}
            topshots[id][17] = topshots[id][17] + 1
        elseif kmulti[id][2] == 4 then
            wait_table[id] = {lvltime, 2}
        elseif kmulti[id][2] == 5 then
            wait_table[id] = {lvltime, 3}
        elseif kmulti[id][2] == 6 then
            topshots[id][17] = topshots[id][17] + 1
            wait_table[id] = {lvltime, 4}
        elseif kmulti[id][2] == 7 then
            wait_table[id] = {lvltime, 5}
            if save_awards then add_qwnage(id, 1) end
        elseif kmulti[id][2] >= 8 then
            wait_table[id] = {lvltime, 6}
            if save_awards then add_qwnage(id, 2) end
        end
    else
        kmulti[id][2] = 1
		doublekill[id][1] = 0
        if mod==6 or mod==7 or mod==12 or mod==45 or mod==53 or mod==54 or mod==55 or mod==56 then
        	doublekill[id][1] = 1
        end
        mkps[id][1] = 1
        mkps[id][2] = 0
        mkps[id][3] = 0
    end
    kmulti[id][1] = lvltime
end

function checkMultiTk(id)
    local lvltime = et.trap_Milliseconds()

    if (lvltime - kmultitk[id][1]) < 3000 then
        kmultitk[id][2] = kmultitk[id][2] + 1
        if kmultitk[id][2] == 3 then
            sayClients(kmultitk_pos, string.format(kmultitk_msg, playerName(id)))
			sayClients("chat", string.format(kmultitk_msg, playerName(id)))
            et.G_globalSound(multitksound)
            if save_awards then
                add_qwnage(id, 3)
            end
            -- send to irc-bot
            --et.G_LogPrint("say: Mony: !admin2monitor %s 00,01has made a Multi TK.02,15 Everyone has agreed that Speed0 is to blame!!!\n",
            --playerName(id)
            --)
        end
    else
        kmultitk[id][2] = 1
    end

    kmultitk[id][1] = lvltime
end

function dist(a, b)
	ax, ay, az = a[1], a[2], a[3]
	bx, by, bz = b[1], b[2], b[3]
	dx = math.abs(bx - ax)
	dy = math.abs(by - ay)
	dz = math.abs(bz - az)
	d = math.sqrt((dx ^ 2) + (dy ^ 2) + (dz ^ 2))
	return math.floor(d) / 39.37
end

function et_Obituary(victim, killer, mod)
	if gamestate == 0 then
		local cl_guid = et.Info_ValueForKey(et.trap_GetUserinfo(victim), "cl_guid")
		local v_teamid = et.gentity_get(victim, "sess.sessionTeam")
		local k_teamid
		if killer ~= 1022 and killer ~= 1023 then
			k_teamid = et.gentity_get(killer, "sess.sessionTeam")
		end
		if (victim == killer) then -- suicide
			if mod ~= 59 then
				deaths[victim] = deaths[victim] + 1
				death_time[victim] = et.trap_Milliseconds()
			end
			if not allow_spree_sk then
				local max = findMaxKSpree()
				if #max == 3 then
					if killing_sprees[victim] > max[1] and kspree_announce then
						sayClients(kspree_pos, string.format("^%sWhat a pity! ^7%s^%s killed himself. This would have been a new ^qspree record ^%s!",
						kspree_color, playerName(victim), kspree_color, kspree_color))
						--sayClients("chat", string.format("^%sWhat a pity! ^7%s^%s killed himself. This would have been a new ^qspree record ^%s!",
						--kspree_color, playerName(victim), kspree_color, kspree_color))
					end
				end
			else
				checkKSpreeEnd(victim, killer, false)
			end
			killing_sprees[victim] = 0
		else
			death_time[victim] = et.trap_Milliseconds()
			if (v_teamid == k_teamid) then -- team kill
				if kmultitk_announce then
					checkMultiTk(killer)
				end
				if sorry then
					last_tk[killer] = {playerName(victim) , et.trap_Milliseconds()}
				end
				checkKSpreeEnd(victim, killer, false)
				killing_sprees[victim] = 0
			else -- nomal kill
				if killer ~= 1022 and killer ~= 1023 then -- no world / unknown kills
					killing_sprees[killer] = killing_sprees[killer] + 1
					vsstats[killer][victim] = vsstats[killer][victim] + 1
					kills[killer] = kills[killer] + 1
					deaths[victim] = deaths[victim] + 1
					dmg_given[killer] = tonumber(et.gentity_get(killer, "sess.damage_given"))
					dmg_rcvd[victim] = tonumber(et.gentity_get(victim, "sess.damage_received"))
					worst_enemy[victim][killer] = worst_enemy[victim][killer] + 1
					easiest_prey[killer][victim] = easiest_prey[killer][victim] + 1
					if et.gentity_get(killer, "sess.PlayerType") == 1 then
						topshots[killer][32] = topshots[killer][32] + 1
					end
					if v_teamid == 1 then
						if redspawn + redlimbo1 / 1000 - ltm2 >= (redlimbo1/1000)/2 and redspawn + redlimbo1 / 1000 - ltm2 > 0 then
							topshots[killer][41] = topshots[killer][41] + 1
						end
					elseif v_teamid == 2 then
						if bluespawn + bluelimbo1 / 1000 - ltm2 >= (bluelimbo1/1000)/2 and bluespawn + bluelimbo1 / 1000 - ltm2 > 0 then
							topshots[killer][41] = topshots[killer][41] + 1
						end
					end

					local guid = getGuid(killer)
					local posk = et.gentity_get(victim, "ps.origin")
					local posv = et.gentity_get(killer, "ps.origin")
					local killdist = dist(posk, posv)

					if srv_record and guid ~= "" then
						-- guid;multi;mega;ultra;monster;ludicrous;revive;nick;firstseen;lastseen
						if type(srv_records[guid]) ~= "table" then
							srv_records[guid] = { 0, 0, 0, 0, 0, 0, playerName(killer), tonumber(os.time(os.date("!*t"))), 0 }
						elseif #srv_records[guid] ~= 9 then
							srv_records[guid] = { 0, 0, 0, 0, 0, 0, playerName(killer), tonumber(os.time(os.date("!*t"))), 0 }
						end
						srv_records[guid][6] = srv_records[guid][6] + 1
						srv_records[guid][9] = tonumber(os.time(os.date("!*t")))
						if record_last_nick or (srv_records[guid][7] == nil) then
							srv_records[guid][7] = playerName(killer)
						end
					end

					if killing_sprees[killer] > kmax_spree then
						kmax_spree = killing_sprees[killer]
						kmax_id    = killer
					end

					if great_shot then
						last_killer[victim] = { playerName(killer), et.trap_Milliseconds() }
					end

					if first_blood then
						sayClients(kmonster_pos, string.format("%s ^1drew first BLOOD ^7!", playerName(killer) ))
						sayClients("chat", string.format("%s ^1drew first BLOOD ^7!", playerName(killer) ))
						--et.G_globalSound(firstbloodsound)
						soundClients(firstbloodsound)
						first_blood = false
					end

					if last_blood then
						last_b = playerName(killer)
					end

					checkMultiKill(killer, mod)

					if kspree_announce then
						checkKSprees(killer)
					end

					checkKSpreeEnd(victim, killer, true)
					-- most lightweapons kills
					if mod==6 or mod==7 or mod==8 or mod==9 or mod==10 or mod==12 or mod==45 or mod==53 or mod==54 or mod==55 or mod==56 or mod==66 then
						-- most pistol kills
						if mod==6 or mod==7 or mod==12 or mod==45 or mod==53 or mod==54 or mod==55 or mod==56 then
							topshots[killer][2] = topshots[killer][2] + 1
						end
						topshots[killer][1] = topshots[killer][1] + 1
					end
					-- most rifle kills
					if mod == 11 or mod == 50 or mod == 37 or mod == 38 then
						topshots[killer][3] = topshots[killer][3] + 1
					end
					-- most riflegrenade kills + farthest riflegrenade kill
					if mod == 39 or mod == 40 then
						topshots[killer][4] = topshots[killer][4] + 1
						if killdist > topshots[killer][16] then
							topshots[killer][16] = killdist
						end
					end
					-- most sniper kills
					if mod == 46 or mod == 51 then
						topshots[killer][5] = topshots[killer][5] + 1
					end
					-- most knife kills
					if mod == 5 or mod == 61 or mod == 65 then
						topshots[killer][6] = topshots[killer][6] + 1
					end
					-- most air support kills
					if mod == 23 or mod == 26 then
						topshots[killer][7] = topshots[killer][7] + 1
					end
					-- most mine kills
					if mod == 41 then
						topshots[killer][8] = topshots[killer][8] + 1
					end
					-- most grenade kills
					if mod == 16 or mod == 18 then
						topshots[killer][9] = topshots[killer][9] + 1
					end
					-- most panzer kills/deaths
					if mod == 15 or mod == 64 then
						topshots[killer][10] = topshots[killer][10] + 1
						topshots[victim][12] = topshots[victim][12] + 1
					end
					-- most mortar kills/deaths
					if mod == 52 or mod == 63 then
						topshots[killer][11] = topshots[killer][11] + 1
						topshots[victim][13] = topshots[victim][13] + 1
					end
					-- most mg42 kills/deaths
					if mod == 1 or mod == 2 or mod == 3 or mod == 44 or mod == 62 then
						topshots[killer][18] = topshots[killer][18] + 1
						topshots[victim][19] = topshots[victim][19] + 1
					end
				else
					deaths[victim] = deaths[victim] + 1
					checkKSpreeEnd(victim, killer, false)
				end
				killing_sprees[victim] = 0
			end

			if has_value(light_weapons, mod) or has_value(explosives, mod) then
				local names = ""
				local names_cens = ""
				local killer_dmg = 0
				local killer_hs = 0
				local killer_wpn = ""
				local killer_wpns = {}
				local assist_dmg = {}
				local assist_hs = {}
				local assist_wpn = {}
				local assist_wpns = {}
				local last_assist_wpn = {}
				local ms = et.trap_Milliseconds()
				for m=ms, ms-1500, -1 do
					if hitters[victim][m] then
						if hitters[victim][m][1] == killer then
							killer_dmg = killer_dmg + hitters[victim][m][2]
							killer_hs = killer_hs + hitters[victim][m][3]
							killer_wpn = mod_weapons[hitters[victim][m][4]]
							if #killer_wpns == 0 then
								table.insert(killer_wpns, killer_wpn)
							else
								if not has_value(killer_wpns, killer_wpn) then
									table.insert(killer_wpns, killer_wpn)
								end
							end
						else
							if assist_dmg[hitters[victim][m][1]] == nil then
								assist_dmg[hitters[victim][m][1]] = hitters[victim][m][2]
							else
								assist_dmg[hitters[victim][m][1]] = assist_dmg[hitters[victim][m][1]] + hitters[victim][m][2]
							end
							if assist_hs[hitters[victim][m][1]] == nil then
								assist_hs[hitters[victim][m][1]] = hitters[victim][m][3]
							else
								assist_hs[hitters[victim][m][1]] = assist_hs[hitters[victim][m][1]] + hitters[victim][m][3]
							end
							assist_wpn[hitters[victim][m][1]] = mod_weapons[hitters[victim][m][4]]
							if not assist_wpns[hitters[victim][m][1]] then
								assist_wpns[hitters[victim][m][1]] = {}
							end
							if not last_assist_wpn[hitters[victim][m][1]] then
								last_assist_wpn[hitters[victim][m][1]] = hitters[victim][m][4]
							end
							if not has_value(assist_wpns[hitters[victim][m][1]], assist_wpn[hitters[victim][m][1]]) then
								table.insert(assist_wpns[hitters[victim][m][1]], assist_wpn[hitters[victim][m][1]])
							end
						end
					end
				end
				local keyset={}
				local n=0
				for k,v in pairs(assist_dmg) do
					n=n+1
					keyset[n]=k
				end
				local max = 0
				local max_id = 0
				for j=1,#keyset do
					if v_teamid ~= et.gentity_get(keyset[j], "sess.sessionTeam") then
						topshots[keyset[j]][36] = topshots[keyset[j]][36] + 1
					end
					if assist_dmg[keyset[j]] > killer_dmg then
						if not has_value(explosives, mod) and not has_value(explosives, last_assist_wpn[keyset[j]]) then
							if v_teamid ~= et.gentity_get(keyset[j], "sess.sessionTeam") and v_teamid ~= k_teamid then 
								topshots[killer][37] = topshots[killer][37] + 1
							end
							if assist_dmg[keyset[j]] > max then
								max = assist_dmg[keyset[j]]
								max_id = keyset[j]
							end
						end
					end
					local C
					if et.gentity_get(keyset[j], "sess.sessionTeam") == 1 then
						C = 1
					else
						C = 4
					end
					if names == "" then
						if assist_hs[keyset[j]] == 0 then
							if #assist_wpns[keyset[j]] == 1 then
								names = et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. assist_wpn[keyset[j]] .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z)"
								if et.gentity_get(keyset[j], "sess.sessionTeam") ~= k_teamid then
									names_cens = "^" .. C .. "TEAMMATE ^z(^" .. C .. assist_wpn[keyset[j]] .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z)"
								else
									names_cens = names
								end
							else
								local wpns = table.concat(assist_wpns[keyset[j]], "^z, ^" .. C) 
								names = et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z)"
								if et.gentity_get(keyset[j], "sess.sessionTeam") ~= k_teamid then
									names_cens = "^" .. C .. "TEAMMATE ^z(^" .. C .. wpns .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z)"
								else
									names_cens = names
								end
							end
						else
							if #assist_wpns[keyset[j]] == 1 then
								names = et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. assist_wpn[keyset[j]] .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z, ^" .. C .. assist_hs[keyset[j]] .. "^zHS)"
								if et.gentity_get(keyset[j], "sess.sessionTeam") ~= k_teamid then
									names_cens = "^" .. C .. "TEAMMATE ^z(^" .. C .. assist_wpn[keyset[j]] .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z, ^" .. C .. assist_hs[keyset[j]] .. "^zHS)"
								else
									names_cens = names
								end
							else
								local wpns = table.concat(assist_wpns[keyset[j]], "^z, ^" .. C)
								names = et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z, ^" .. C .. assist_hs[keyset[j]] .. "^zHS)"
								if et.gentity_get(keyset[j], "sess.sessionTeam") ~= k_teamid then
									names_cens = "^" .. C .. "TEAMMATE ^z(^" .. C .. wpns .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z, ^" .. C .. assist_hs[keyset[j]] .. "^zHS)"
								else
									names_cens = names
								end
							end
						end
					else
						if assist_hs[keyset[j]] == 0 then
							if #assist_wpns[keyset[j]] == 1 then
								names = names .. ", " .. et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. assist_wpn[keyset[j]] .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z)"
								if et.gentity_get(keyset[j], "sess.sessionTeam") ~= k_teamid then
									names_cens = names_cens .. ", ^" .. C .. "TEAMMATE ^z(^" .. C .. assist_wpn[keyset[j]] .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z)"
								else
									names_cens = names_cens .. ", " .. et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. assist_wpn[keyset[j]] .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z)"
								end
							else
								local wpns = table.concat(assist_wpns[keyset[j]], "^z, ^" .. C)
								names = names .. ", " .. et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z)"
								if et.gentity_get(keyset[j], "sess.sessionTeam") ~= k_teamid then
									names_cens = names_cens .. ", ^" .. C .. "TEAMMATE ^z(^" .. C .. wpns .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z)"
								else
									names_cens = names_cens .. ", " .. et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z)"
								end
							end
						else
							if #assist_wpns[keyset[j]] == 1 then
								names = names .. ", " .. et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. assist_wpn[keyset[j]] .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z, ^" .. C .. assist_hs[keyset[j]] .. "^zHS)"
								if et.gentity_get(keyset[j], "sess.sessionTeam") ~= k_teamid then
									names_cens = names_cens .. ", ^" .. C .. "TEAMMATE ^z(^" .. C .. assist_wpn[keyset[j]] .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z, ^" .. C .. assist_hs[keyset[j]] .. "^zHS)"
								else
									names_cens = names_cens .. ", " .. et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. assist_wpn[keyset[j]] .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z, ^" .. C .. assist_hs[keyset[j]] .. "^zHS)"
								end
							else
								local wpns = table.concat(assist_wpns[keyset[j]], "^z, ^" .. C)
								names = names .. ", " .. et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z, ^" .. C .. assist_hs[keyset[j]] .. "^zHS)"
								if et.gentity_get(keyset[j], "sess.sessionTeam") ~= k_teamid then
									names_cens = names_cens .. ", ^" .. C .. "TEAMMATE ^z(^" .. C .. wpns .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z, ^" .. C .. assist_hs[keyset[j]] .. "^zHS)"
								else
									names_cens = names_cens .. ", " .. et.gentity_get(keyset[j], "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. assist_dmg[keyset[j]] .. "^z, ^" .. C .. assist_hs[keyset[j]] .. "^zHS)"
								end
							end
						end
					end
				end
				if max > 0 then
					if v_teamid ~= et.gentity_get(max_id, "sess.sessionTeam") and v_teamid ~= k_teamid then 
						et.trap_SendServerCommand(killer, "cpm \"^zKill stolen from: " .. et.gentity_get(max_id, "pers.netname") .. "\";")
						et.trap_SendServerCommand(max_id, "cpm \"^zKill stolen by: " .. et.gentity_get(killer, "pers.netname") .. "\";")
						if announce_killer == true then
							et.trap_SendServerCommand(killer, "chat \"^zKill Assists: " .. names_cens .. "\";")
						end
					end
				else
					if names ~= "" then
						if v_teamid ~= k_teamid then
							if announce_killer == true then
								et.trap_SendServerCommand(killer, "chat \"^zKill Assists: " .. names_cens .. "\";")
							end
						end
					end
				end
				local C
				if k_teamid == 1 then
					C = 1
				else
					C = 4
				end
				if v_teamid ~= k_teamid then
					if announce_hp == true then
						local posk = et.gentity_get(victim, "ps.origin")
						local posv = et.gentity_get(killer, "ps.origin")
						local killdist = dist(posk, posv)
						local killerhp = et.gentity_get(killer, "health")
						local C2 = 2
						if killerhp <= 50 then
							C2 = 3
						end
						if killerhp <= 20 then
							C2 = 1
						end
						if killerhp <= 0 then
							--if vips[cl_guid] == true then
								if names == "" then
									if #killer_wpns == 1 then
										et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zwas dead.\nDamage received last 1.5s: (^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
										et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zwas dead. Damage received last 1.5s: (^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
									else
										local wpns = table.concat(killer_wpns, "^z, ^" .. C)
										et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zwas dead.\nDamage received last 1.5s: (^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
										et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zwas dead. Damage received last 1.5s: (^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
									end
								else
									if #killer_wpns == 1 then
										et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zwas dead.\nKill Assists: " .. et.gentity_get(killer, "pers.netname") .. "^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z)\n" .. names .. "\";")
										et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zwas dead. Kill Assists: " .. et.gentity_get(killer, "pers.netname") .. "^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z), " .. names .. "\";")
									else
										local wpns = table.concat(killer_wpns, "^z, ^" .. C)
										et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zwas dead.\nKill Assists: " .. et.gentity_get(killer, "pers.netname") .. "^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z)\n" .. names .. "\";")
										et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zwas dead. Kill Assists: " .. et.gentity_get(killer, "pers.netname") .. "^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z), " .. names .. "\";")
									end
								end
							--else
								--et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zwas dead.\";")
								--et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zwas dead.\";")
							--end
						else
							--if vips[cl_guid] == true then
								if names == "" then
									if killer_hs == 0 then
										if #killer_wpns == 1 then
											et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm\nDamage received last 1.5s: (^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
											et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm. Damage received last 1.5s: (^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
										else
											local wpns = table.concat(killer_wpns, "^z, ^" .. C)
											et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm\nDamage received last 1.5s: (^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
											et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm. Damage received last 1.5s: (^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
										end
									else
										if #killer_wpns == 1 then
											et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm\nDamage received last 1.5s: (^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\";")
											et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm. Damage received last 1.5s: (^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\";")
										else
											local wpns = table.concat(killer_wpns, "^z, ^" .. C)
											et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm\nDamage received last 1.5s: (^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\";")
											et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm. Damage received last 1.5s: (^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\";")
										end
									end
								else
									if killer_hs == 0 then
										if #killer_wpns == 1 then
											et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm\nKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z)\n" .. names .. "\";")
											et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm. Kill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z), " .. names .. "\";")
										else
											local wpns = table.concat(killer_wpns, "^z, ^" .. C)
											et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm\nKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z)\n" .. names .. "\";")
											et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm. Kill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z), " .. names .. "\";")
										end
									else
										if #killer_wpns == 1 then
											et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm\nKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\n" .. names .. "\";")
											et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm. Kill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS), " .. names .. "\";")
										else
											local wpns = table.concat(killer_wpns, "^z, ^" .. C)
											et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm\nKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\n" .. names .. "\";")
											et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm. Kill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS), " .. names .. "\";")
										end
									end
								end
							--else
								--et.trap_SendServerCommand(victim, "cp \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm\";")
								--et.trap_SendServerCommand(victim, "chat \"" .. et.gentity_get(killer, "pers.netname") .. " ^zhad ^" .. C2 .. killerhp .. " ^zHP left. Distance was ^3" .. math.floor(roundNum(killdist)) .. " ^zm.\";")
							--end
						end
					else
						if names == "" then
							if killer_hs == 0 then
								if #killer_wpns == 1 then
									et.trap_SendServerCommand(victim, "cp \"^zDamage received last 1.5s: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
									et.trap_SendServerCommand(victim, "chat \"^zDamage received last 1.5s: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
								else
									local wpns = table.concat(killer_wpns, "^z, ^" .. C)
									et.trap_SendServerCommand(victim, "cp \"^zDamage received last 1.5s: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
									et.trap_SendServerCommand(victim, "chat \"^zDamage received last 1.5s: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z)\";")
								end
							else
								if #killer_wpns == 1 then
									et.trap_SendServerCommand(victim, "cp \"^zDamage received last 1.5s: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\";")
									et.trap_SendServerCommand(victim, "chat \"^zDamage received last 1.5s: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\";")
								else
									local wpns = table.concat(killer_wpns, "^z, ^" .. C)
									et.trap_SendServerCommand(victim, "cp \"^zDamage received last 1.5s: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\";")
									et.trap_SendServerCommand(victim, "chat \"^zDamage received last 1.5s: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\";")
								end
							end
						else
							if killer_hs == 0 then
								if #killer_wpns == 1 then
									et.trap_SendServerCommand(victim, "cp \"^zKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z)\n" .. names .. "\";")
									et.trap_SendServerCommand(victim, "chat \"^zKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z), " .. names .. "\";")
								else
									local wpns = table.concat(killer_wpns, "^z, ^" .. C)
									et.trap_SendServerCommand(victim, "cp \"^zKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z)\n" .. names .. "\";")
									et.trap_SendServerCommand(victim, "chat \"^zKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z), " .. names .. "\";")
								end
							else
								if #killer_wpns == 1 then
									et.trap_SendServerCommand(victim, "cp \"^zKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\n" .. names .. "\";")
									et.trap_SendServerCommand(victim, "chat \"^zKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. killer_wpn .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS), " .. names .. "\";")
								else
									local wpns = table.concat(killer_wpns, "^z, ^" .. C)
									et.trap_SendServerCommand(victim, "cp \"^zKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS)\n" .. names .. "\";")
									et.trap_SendServerCommand(victim, "chat \"^zKill Assists: " .. et.gentity_get(killer, "pers.netname") .. " ^z(^" .. C .. wpns .. "^z; ^" .. C .. killer_dmg .. "^z, ^" .. C .. killer_hs .. "^zHS), " .. names .. "\";")
								end
							end
						end
					end
				end
			end
		end
	end -- gamestate
end

function checkKSpreeEnd(id, killer, normal_kill)
    if killing_sprees[id] > 0 then
        local m_name = playerName(id)
        if m_name == "" then
            m_name = "^0MIA" -- missing in action
        end
        local k_name = ""
        if killer == 1022 then
            k_name = "End of Round"
        elseif killer == 1023 then
            k_name = "unknown reasons"
        else
            k_name = playerName(killer)
        end
        local krecord = false
        local msg    = ""

        if kmax_id == id and killing_sprees[id] == kmax_spree then
            local max = findMaxKSpree()
            if #max == 3 and kmax_spree > max[1] then
                alltime_stats[mapName()] = { kmax_spree, os.time(os.date("!*t")), m_name }
                kmap_record = true
                krecord     = true
            elseif #max == 0 then
                alltime_stats[mapName()] = { kmax_spree, os.time(os.date("!*t")), m_name }
                kmap_record = true
                krecord     = true
            end
        end

        if killing_sprees[id] >= 5 and kspree_announce then
            if normal_kill then -- i.e. no TK or suicide
                sayClients(kspree_pos, string.format("%s^%s's killing spree ended (^7%d kills^%s), killed by ^7%s^%s!",
                    m_name, kspree_color, killing_sprees[id], kspree_color, k_name, kspree_color))
				--sayClients("chat", string.format("%s^%s's killing spree ended (^7%d kills^%s), killed by ^7%s^%s!",
                    --m_name, kspree_color, killing_sprees[id], kspree_color, k_name, kspree_color))
                if krecord then
                    sayClients(kspree_pos, "^"..kspree_color.."This is a new map record!^7")
					--sayClients("chat", "^"..kspree_color.."This is a new map record!^7")
                end

            else
                if killer <= sv_maxclients then
                	if id == killer then
                		sayClients(kspree_pos, string.format("%s^%s's killing spree ended (^7%d kills^%s), killed by suicide.",
                        m_name, kspree_color, killing_sprees[id], kspree_color))
						--sayClients("chat", string.format("%s^%s's killing spree ended (^7%d kills^%s), killed by suicide.",
                        --m_name, kspree_color, killing_sprees[id], kspree_color))
                	else
                		sayClients(kspree_pos, string.format("%s^%s's killing spree ended (^7%d kills^%s), ^1teamkilled ^%sby ^7%s^%s!",
                        m_name, kspree_color, killing_sprees[id], kspree_color, kspree_color, k_name, kspree_color))
						--sayClients("chat", string.format("%s^%s's killing spree ended (^7%d kills^%s), ^1teamkilled ^%sby ^7%s^%s!",
                        --m_name, kspree_color, killing_sprees[id], kspree_color, kspree_color, k_name, kspree_color))
                	end
                    if krecord then
   	  	           sayClients(kspree_pos, "^"..kspree_color.."This is a new map record!^7")
				   --sayClients("chat", "^"..kspree_color.."This is a new map record!^7")
  		          end
                else
                	sayClients(kspree_pos, string.format("%s^%s's killing spree ended (^7%d kills^%s), killed by unknown reasons.",
                    m_name, kspree_color, killing_sprees[id], kspree_color))
					--sayClients("chat", string.format("%s^%s's killing spree ended (^7%d kills^%s), killed by unknown reasons.",
                    --m_name, kspree_color, killing_sprees[id], kspree_color))
                    if krecord then
   	                 sayClients(kspree_pos, "^"..kspree_color.."This is a new map record!^7")
					 --sayClients("chat", "^"..kspree_color.."This is a new map record!^7")
  	              end
                end
            end
        end
    end
end

function checkKSprees(id)
    if killing_sprees[id] ~= 0 then
        if math.fmod(killing_sprees[id], 5) == 0 then
            local spree_id = killing_sprees[id]
            local spree = K_Sprees[killing_sprees[id]]
            if killing_sprees[id] > 35 then
                spree = K_Sprees[35]
            end
            if spree == nil then
                spree = "is on a Killing spree"
                et.G_Print("kspree: Killing spree = nil\n")
            end

            if spree_id == 5 then
                if killingspree_private and client_msg[id] then
                    local craap = string.format("%s^%s: You are on a killing spree! (^75 kills in a row^%s)",
                    playerName(id), kspree_color, kspree_color)
                    et.trap_SendServerCommand( id, "cpm \" "..craap.." \"\n")
                    --et.G_Sound( id ,  et.G_SoundIndex("sound/misc/killingspree.wav"))
					--local soundindex = et.G_SoundIndex(killingspreesound)
                    --et.G_ClientSound(id, soundindex)
                    et.trap_SendServerCommand(-1, "spl " .. killingspreesound)
                else
                    sayClients(kspree_pos, string.format("%s^%s %s (^7%d kills in a row^%s)",
                    playerName(id), kspree_color, spree, killing_sprees[id], kspree_color))
					--sayClients("chat", string.format("%s^%s %s (^7%d kills in a row^%s)",
                    --playerName(id), kspree_color, spree, killing_sprees[id], kspree_color))
                    if kspree_sound then
                    soundClients(killingspreesound)
                    --et.G_globalSound(killingspreesound)
                    end
                end
            else
                sayClients(kspree_pos, string.format("%s^%s %s (^7%d kills in a row^%s)",
                    playerName(id), kspree_color, spree, killing_sprees[id], kspree_color))
					--sayClients("chat", string.format("%s^%s %s (^7%d kills in a row^%s)",
                    --playerName(id), kspree_color, spree, killing_sprees[id], kspree_color))
                if spree_id == 10 and kspree_sound then
                    --et.G_globalSound(rampagesound)
                    soundClients(rampagesound)

                elseif spree_id == 15 and kspree_sound then
                    --et.G_globalSound(dominatingsound)
                    soundClients(dominatingsound)

                elseif spree_id == 20 and kspree_sound then
                    --et.G_globalSound(unstoppablesound)
                    soundClients(unstoppablesound)

                elseif spree_id == 25 and kspree_sound then
                    --et.G_globalSound(godlikesound)
                    soundClients(godlikesound)

                elseif spree_id == 30 and kspree_sound then
                    --et.G_globalSound(wickedsicksound)
                    soundClients(wickedsicksound)

                elseif spree_id == 35 and kspree_sound then
                    --et.G_globalSound(pottersound)
                    soundClients(pottersound)
                end
            end --spree_id == 5
        end
    end
end

function et_RunFrame(levelTime)
	if math.fmod(levelTime, 100) == 0 then
		for i = 0, (sv_maxclients - 1) do
			if (et.gentity_get(i, "sess.damage_received")) > (damage_received_temp[i]) then
				dmg_switch[i] = 10 -- 10x100=1000ms
				damage_received_temp[i] = et.gentity_get(i, "sess.damage_received")
			else
				if dmg_switch[i] ~= 0 then
	 				dmg_switch[i] = dmg_switch[i] - 1
				end
			end
		end
	end
    if math.fmod(levelTime, 500) ~= 0 then return end

    local ltm = et.trap_Milliseconds()
	if eomap_done then
	    if eomaptime < ltm then
		    eomap_done = false
			topshots_f(-2)
			if kmax_id ~= nil then
				et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"" .. kspree_endmsg .. "^7\"\n")
			end
	    end
	end
    gamestate = tonumber(et.trap_Cvar_Get("gamestate"))
    if gamestate == 0 then
        -- wait before display multi/mega/monster/ludicrous-kill AND display highest
        -- wait_table[id] = {lvltime, 2}
		for id, arr in pairs(wait_table) do
            local guid = getGuid(id)
            local m_name = playerName(id)
            local startpause = tonumber(arr[1])
            local whichkill = arr[2]

            if whichkill == 1 and (startpause + 3100) < ltm then
                if kmulti_announce then
                    sayClients(kmulti_pos, string.format(kmulti_msg, m_name))
					--sayClients("chat", string.format(kmulti_msg, m_name))
                    if kmulti_sound then
                        --et.G_globalSound(multisound)
                        soundClients(multisound)
                    end
                end
                if srv_record and guid ~= "" then
                    srv_records[guid][1] = srv_records[guid][1] + 1
                end
                wait_table[id] = nil
            end

            if whichkill == 2 and (startpause + 3100) < ltm then
                if kmulti_announce then
                    sayClients(kmulti_pos, string.format(kmega_msg, m_name))
					--sayClients("chat", string.format(kmega_msg, m_name))
                    et.G_LogPrint("LUA event: MEGAKILL: " .. m_name .. "\n")
                    if kmulti_sound then
                        --et.G_globalSound(megasound)
                        soundClients(megasound)
                    end
                end
                if srv_record and guid ~= "" then
                    srv_records[guid][2] = srv_records[guid][2] + 1
                end
                wait_table[id] = nil
            end

            if whichkill == 3 and (startpause + 3100) < ltm then
                if kmulti_announce then
                    sayClients(kmonster_pos, string.format(kultra_msg, m_name))
					sayClients("chat", string.format(kultra_msg, m_name))
                    et.G_LogPrint("LUA event: ULTRAKILL: " .. m_name .. "\n")
                    if kmulti_sound then
                        --et.G_globalSound(ultrasound)
                        soundClients(ultrasound)
                    end
                end
                if srv_record and guid ~= "" then
                    srv_records[guid][3] = srv_records[guid][3] + 1
                end
                wait_table[id] = nil
            end

            if whichkill == 4 and (startpause + 3100) < ltm then
                if kmulti_announce then
                    sayClients(kmonster_pos, string.format(kmonster_msg, m_name))
					sayClients("chat", string.format(kmonster_msg, m_name))
                    et.G_LogPrint("LUA event: MONSTERKILL: " .. m_name .. "\n")
                    if kmulti_sound then
                        --et.G_globalSound(monstersound)
                        soundClients(monstersound)
                    end
                end
                if srv_record and guid ~= "" then
                    srv_records[guid][4] = srv_records[guid][4] + 1
                end
                wait_table[id] = nil
            end

            if whichkill == 5 and (startpause + 3100) < ltm then
                if kmulti_announce then
                    sayClients(kmonster_pos, string.format(kludicrous_msg, m_name))
					sayClients("chat", string.format(kludicrous_msg, m_name))
                    et.G_LogPrint("LUA event: LUDICROUSKILL: " .. m_name .. "\n")
                    if kmulti_sound then
                    --et.G_globalSound(ludicroussound)
                    soundClients(ludicroussound)
                    end
                end
                if srv_record and guid ~= "" then
                    srv_records[guid][5] = srv_records[guid][5] + 1
                end
                wait_table[id] = nil
            end

            if whichkill == 6 and (startpause + 3100) < ltm then
                if kmulti_announce then
                    sayClients(kmonster_pos, string.format(kholyshit_msg, m_name))
					sayClients("chat", string.format(kholyshit_msg, m_name))
                    et.G_LogPrint("LUA event: HOLYSHITKILL: " .. m_name .. "\n")
                    if kmulti_sound then
                        --et.G_globalSound(holyshitsound)
                        soundClients(holyshitsound)
                    end
                end
                wait_table[id] = nil
            end

			if whichkill == 666 and (startpause + 3100) < ltm then
                if kmulti_announce then
                    sayClients(kmulti_pos, string.format(doublekill_msg, m_name))
					--sayClients("chat", string.format(doublekill_msg, m_name))
                    if kmulti_sound then
                        --et.G_globalSound(doublekillsound)
                        soundClients(doublekillsound)
                    end
                end
                wait_table[id] = nil
            end
        end
		for idx, clientNum in pairs(medic_table) do
	        	if last_use[clientNum] < et.trap_Milliseconds() then
    	            if et.gentity_get(clientNum, "ps.powerups", 11 ) > 0 then
    	               last_use[clientNum] = et.trap_Milliseconds() + 6000
 	                  topshots[clientNum][22] = topshots[clientNum][22] + 1
  	              end
				end
	        end
	
		for idx, clientNum in pairs(covert_table) do
    		if et.gentity_get(clientNum, "ps.powerups", 7) == 1 then
    	  	 if u_flag[clientNum] == false then
					topshots[clientNum][35] = topshots[clientNum][35] + 1
					u_flag[clientNum] = true
				end
			else
				if u_flag[clientNum] == true then
					u_flag[clientNum] = false
				end
			end
		end
    end -- gamestate
    if math.fmod(levelTime, 1000) ~= 0 then return end
    if gamestate == 0 then
		redlimbo1 = tonumber(et.trap_Cvar_Get("g_redlimbotime"))
		bluelimbo1 = tonumber(et.trap_Cvar_Get("g_bluelimbotime"))
		if redlimbo2 == 0 then
			redlimbo2 = redlimbo1
			bluelimbo2 = bluelimbo1
		end
		if redlimbo1 ~= redlimbo2 or bluelimbo1 ~= bluelimbo2 then
			if redlimbo1 ~= redlimbo2 then
				changedred = true
				redflag = false
				redlimbo2 = redlimbo1
			elseif bluelimbo1 ~= bluelimbo2 then
				changedblue = true
				blueflag = false
				bluelimbo2 = bluelimbo1
			end
		end
		ltm2 = os.time()
		if redflag == true then
			if ltm2 == redspawn + redlimbo1 / 1000 then
				redspawn = ltm2
			end
		end
		if blueflag == true then
			if ltm2 == bluespawn + bluelimbo1 / 1000 then
				bluespawn = ltm2
			end
		end
	end
end

function et_ClientBegin(id)
    updateUInfoStatus(id)
    
    local team = tonumber(et.gentity_get(id, "sess.sessionTeam"))
	if players[id] == nil then
		players[id] = team
	end
end

function et_ClientUserinfoChanged(clientNum)
    
    local team = tonumber(et.gentity_get(clientNum, "sess.sessionTeam"))

	if players[clientNum] == nil then
		players[clientNum] = team
	end

    if players[clientNum] ~= team then
        
        if (team == 1 or team == 2) and players[clientNum] ~= 3 then
            teamswitch[clientNum] = true
        else
            teamswitch[clientNum] = false
            kills[clientNum] = 0
            deaths[clientNum] = 0
            dmg_given[clientNum] = 0
            dmg_rcvd[clientNum] = 0
        end
       
       spawns[clientNum] = nil

    end
    
    players[clientNum] = team

end

function et_ClientSpawn(id, revived)
	local team = tonumber(et.gentity_get(id, "sess.sessionTeam"))
	if gamestate == 0 then
		if revived ~= 1 then
			local health = tonumber(et.gentity_get(id, "health"))
			-- sess.kills = 0 should mean this is the first spawn.
			if health >= 100 and teamswitch[id] and et.gentity_get(id, "sess.kills") == 0 then
				et.gentity_set(id, "sess.kills", kills[id])
				et.gentity_set(id, "sess.deaths", deaths[id])
				et.gentity_set(id, "sess.damage_given", dmg_given[id])
				et.gentity_set(id, "sess.damage_received", dmg_rcvd[id])
				teamswitch[id] = false
			end

			local cs = et.trap_GetConfigstring(et.CS_PLAYERS + id)
			if et.Info_ValueForKey(cs, "c") == "1" then
				local skillz = et.Info_ValueForKey(cs, "s")
				if string.sub (skillz, 3, 3) == "4" then
					if not is_medic(id) then
						last_use[id] = 0
						table.insert(medic_table, id)
					end
				end
			elseif et.Info_ValueForKey(cs, "c") == "4" then
				if not is_covert(id) then
					table.insert(covert_table, id)
				end
			else
				if is_medic(id) then
					last_use[id] = nil
					table.remove(medic_table, is_medic(id))
				elseif is_covert(id) then
					table.remove(covert_table, is_covert(id))
					u_flag[id] = false
				end
			end

			local team = tonumber(et.gentity_get(id, "sess.sessionTeam"))
			if team == 1 then
				if health > 0 then
					if redflag == false then
						if spawns[id] == nil then
							spawns[id] = 1
						else
							spawns[id] = spawns[id] + 1
						end
						if spawns[id] == 2 then
							redflag = true
							redspawn = os.time()
						end
						if changedred == true then
							redflag = true
							redspawn = os.time()
							changedred = false
						end
					end
					redspawn2 = os.time()
					if redspawn ~= 0 and redspawn ~= redspawn2 then
						redspawn = redspawn2
					end
				end
			elseif team == 2 then
				if health > 0 then
					if blueflag == false then
						if spawns[id] == nil then
							spawns[id] = 1
						else
							spawns[id] = spawns[id] + 1
						end
						if spawns[id] == 2 then
							blueflag = true
							bluespawn = os.time()
						end
						if changedblue == true then
							blueflag = true
							bluespawn = os.time()
							changedblue = false
						end
					end
					bluespawn2 = os.time()
					if bluespawn ~= 0 and bluespawn ~= bluespawn2 then
						bluespawn = bluespawn2
					end
				end
			end
		end
		
		killing_sprees[id] = 0
		hitters[id] = {nil, nil, nil, nil, nil}
		hitRegionsData[id] = getAllHitRegions(id)
		if team == 1 or team == 2 then
			if death_time[id] ~= 0 then
				local diff = et.trap_Milliseconds() - death_time[id]
				death_time_total[id] = death_time_total[id] + diff
			end
		end
		death_time[id] = 0
	end
end

function et_ClientDisconnect(id)
    killing_sprees[id] = 0
    topshots[id] = { [1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0, [10]=0, [11]=0, [12]=0, [13]=0, [14]=0, [15]=0, [16]=0, [17]=0, [18]=0, [19]=0, [20]=0, [21]=0, [22]=0, [23]=0, [24]=0, [25]=0, [26]=0, [27]=0, [28]=0, [29]=0, [30]=0, [31]=0, [32]=0, [33]=0, [34]=0, [35]=0, [36]=0, [37]=0, [38]=0, [39]=0, [40]=0, [41]=0}
    vsstats[id]={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0,[15]=0,[16]=0,[17]=0,[18]=0,[19]=0,[20]=0,[21]=0,[22]=0,[23]=0,[24]=0,[25]=0,[26]=0,[27]=0,[28]=0,[29]=0,[30]=0,[31]=0,[32]=0,[33]=0,[34]=0,[35]=0,[36]=0,[37]=0,[38]=0,[39]=0,[40]=0,[41]=0,[42]=0,[43]=0,[44]=0,[45]=0,[46]=0,[47]=0,[48]=0,[49]=0,[50]=0,[51]=0,[52]=0,[53]=0,[54]=0,[55]=0,[56]=0,[57]=0,[58]=0,[59]=0,[60]=0,[61]=0,[62]=0,[63]=0}
    vsstats_kills[id]={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0,[15]=0,[16]=0,[17]=0,[18]=0,[19]=0,[20]=0,[21]=0,[22]=0,[23]=0,[24]=0,[25]=0,[26]=0,[27]=0,[28]=0,[29]=0,[30]=0,[31]=0,[32]=0,[33]=0,[34]=0,[35]=0,[36]=0,[37]=0,[38]=0,[39]=0,[40]=0,[41]=0,[42]=0,[43]=0,[44]=0,[45]=0,[46]=0,[47]=0,[48]=0,[49]=0,[50]=0,[51]=0,[52]=0,[53]=0,[54]=0,[55]=0,[56]=0,[57]=0,[58]=0,[59]=0,[60]=0,[61]=0,[62]=0,[63]=0}
    vsstats_deaths[id]={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0,[15]=0,[16]=0,[17]=0,[18]=0,[19]=0,[20]=0,[21]=0,[22]=0,[23]=0,[24]=0,[25]=0,[26]=0,[27]=0,[28]=0,[29]=0,[30]=0,[31]=0,[32]=0,[33]=0,[34]=0,[35]=0,[36]=0,[37]=0,[38]=0,[39]=0,[40]=0,[41]=0,[42]=0,[43]=0,[44]=0,[45]=0,[46]=0,[47]=0,[48]=0,[49]=0,[50]=0,[51]=0,[52]=0,[53]=0,[54]=0,[55]=0,[56]=0,[57]=0,[58]=0,[59]=0,[60]=0,[61]=0,[62]=0,[63]=0}
    worst_enemy[id]={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0,[15]=0,[16]=0,[17]=0,[18]=0,[19]=0,[20]=0,[21]=0,[22]=0,[23]=0,[24]=0,[25]=0,[26]=0,[27]=0,[28]=0,[29]=0,[30]=0,[31]=0,[32]=0,[33]=0,[34]=0,[35]=0,[36]=0,[37]=0,[38]=0,[39]=0,[40]=0,[41]=0,[42]=0,[43]=0,[44]=0,[45]=0,[46]=0,[47]=0,[48]=0,[49]=0,[50]=0,[51]=0,[52]=0,[53]=0,[54]=0,[55]=0,[56]=0,[57]=0,[58]=0,[59]=0,[60]=0,[61]=0,[62]=0,[63]=0}
    easiest_prey[id]={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0,[15]=0,[16]=0,[17]=0,[18]=0,[19]=0,[20]=0,[21]=0,[22]=0,[23]=0,[24]=0,[25]=0,[26]=0,[27]=0,[28]=0,[29]=0,[30]=0,[31]=0,[32]=0,[33]=0,[34]=0,[35]=0,[36]=0,[37]=0,[38]=0,[39]=0,[40]=0,[41]=0,[42]=0,[43]=0,[44]=0,[45]=0,[46]=0,[47]=0,[48]=0,[49]=0,[50]=0,[51]=0,[52]=0,[53]=0,[54]=0,[55]=0,[56]=0,[57]=0,[58]=0,[59]=0,[60]=0,[61]=0,[62]=0,[63]=0}
    client_msg[id] = false
    topshot_msg[id] = false
    kills[id] = 0
    deaths[id] = 0
    dmg_given[id] = 0
	dmg_rcvd[id] = 0
	players[id] = nil
	teamswitch[id] = false
    mkps[id] = { [1]=0, [2]=0, [3]=0 }
    if great_shot and last_killer[id] ~= nil then
        last_killer[id] = nil
    end
    if sorry and last_tk[id] ~= nil then
        last_tk[id] = nil
    end
    if thanks and last_revive[id] ~= nil then
        last_revive[id] = nil
    end
    last_vsaymedic[id] = nil
    last_vsaythanks[id] = nil
    if wait_table[id] ~= nil then
        wait_table[id] = nil
    end
    if is_medic(id) then
        	last_use[id] = nil
            table.remove(medic_table, is_medic(id))
	end
	if is_covert(id) then
            table.remove(covert_table, is_covert(id))
            u_flag[id] = false
	end
	local j = 0
	for j=0,sv_maxclients-1 do
		vsstats[j][id] = 0
		worst_enemy[j][id] = 0
		easiest_prey[j][id] = 0
		vsstats_kills[j][id] = 0
		vsstats_deaths[j][id] = 0
	end
	hitters[id] = {nil, nil, nil, nil, nil}
	death_time[id] = 0
	death_time_total[id] = 0
	spawns[id] = nil
end

function is_medic(id)
    local found = nil

	for idx, clientNum in pairs(medic_table) do
		if clientNum == id then
			found = idx
		end
	end
    if found then
    	return found
    else
    	return nil
    end
end

function is_covert(id)
    local found = nil
	
	for idx, clientNum in pairs(covert_table) do
		if clientNum == id then
			found = idx
		end
	end
    if found then
    	return found
    else
    	return nil
    end
end

function multikillstats (id)
	local guid = getGuid(id)
	local name = et.gentity_get(id, "pers.netname")

	local cmultis = 0
	local ckills = 0
	local cratio = 0
	local pmultis = 0
	local pkills = 0
	local pratio = 0
	local count = 1
	if srv_records[guid] ~= nil then
		ckills = srv_records[guid][6]
		if ckills > 1000 then
			cmultis = srv_records[guid][1] + srv_records[guid][2] + srv_records[guid][3] + srv_records[guid][4]*2 + srv_records[guid][5]*2
			cratio = (cmultis/ckills)*100
		else
			et.trap_SendServerCommand(-1, "chat \"No stats for " .. name .. " available ...\n\"")
			return 0
		end
	else
		et.trap_SendServerCommand(-1, "chat \"No stats for " .. name .. " available ...\n\"")
		return 0
	end

	for pguid, arr in pairs(srv_records) do
		if pguid ~= guid then
			pkills = arr[6]
			if pkills > 1000 then
				pmultis = arr[1]+arr[2]+arr[3]+arr[4]*2+arr[5]*2
				pratio = (pmultis/pkills)*100
				if pratio > cratio then
					count = count + 1
				end
			end
		end
	end

	et.trap_SendServerCommand(-1, "chat \"Multikill stats for: " .. name .. "^7: ^3Rank: ^7" .. count .. " ^3Kills: ^7" .. ckills .. " ^3Multikills: ^7" .. cmultis .. " ^3Ratio: ^7" .. roundNum(cratio, 3) .. "\"")
	et.trap_SendServerCommand(-1, "chat \"Multikills: ^3" .. srv_records[guid][1] .. " ^7Megakills: ^3" .. srv_records[guid][2] .. " ^7Ultrakills: ^3" .. srv_records[guid][3] .. " ^7Monsterkills: ^3" .. srv_records[guid][4] .. " ^7Ludicrouskills: ^3" .. srv_records[guid][5] .. "\"")
end

function et_ClientCommand(id, command)
	if string.lower(command) == "kill" then
		if et.gentity_get(id, "health") > 0 then
			if dmg_switch[id] >= 1 then
				topshots[id][34] = topshots[id][34] + 1
			end
		end 
	end 
	if string.lower(command) == "say" or string.lower(command) == "say_team" then
		local args = et.ConcatArgs(1)
		local args_table = {}
		cnt = 0
		for i in string.gmatch(args, "%S+") do
			table.insert(args_table, i)
			cnt = cnt + 1
		end

		topshots[id][33] = topshots[id][33] + 1
		if et.trap_Argv(0) == "say" then
			if et.gentity_get(id, "sess.muted") == 1 then return 1 end
			if et.trap_Argv(1) == "!topshots" then
				topshots_f(id)
			end
			if et.trap_Argv(1) == multikill_cmd and srv_record then
				multikillstats(id)
			end
			if et.trap_Argv(1) == "!getmultikillstats" and srv_record then
				if et.trap_Argc() ~= 3 then
					et.trap_SendServerCommand(id, "chat \"Usage: ^3!getmultikillstats PartOfName\"")
				else
					local id2
					if string.len(et.trap_Argv(2)) < 3 then
						id2 = tonumber(et.trap_Argv(2))
						if id2 then
							if et.gentity_get(id2, "pers.connected") == 2 then
								multikillstats(id2)
							end
						end
					else
						id2 = inSlot(et.trap_Argv(2))
						if id2 ~= nil then
							multikillstats(id2)
						end
					end
				end
			end
			if args_table[1] == "!vsstats" then
				if #args_table == 1 then
					et.trap_SendServerCommand(id, "chat \"Usage: ^3!vsstats PartOfName\"")
				else
					local id2
					if string.len(args_table[2]) < 3 then
						id2 = tonumber(args_table[2])
						if id2 then
							if et.gentity_get(id2, "pers.connected") == 2 then
								vsstats_f(id, id2, false)
							end
						end
					else
						id2 = inSlot(args_table[2])
						if id2 ~= nil then
							vsstats_f(id, id2, false)
						end
					end
				end
			end
			if et.trap_Argv(1) == "!vsstatsall" then
				local t = tonumber(et.gentity_get(id, "sess.sessionTeam"))
				for e=0, sv_maxclients-1 do
					local t2 = tonumber(et.gentity_get(e, "sess.sessionTeam"))
					if t2 == 1 or t2 == 2 then
						if t ~= t2 then
							vsstats_f(id, e, true)
						end
					end
				end
				local sortedKeys = getKeysSortedByValue(vsstats_kills[id], function(a, b) return a > b end)
				local players3 = {}
				for _, key in ipairs(sortedKeys) do
					if not (vsstats_kills[id][key] == 0 and vsstats_deaths[id][key] == 0) then
						local t3 = tonumber(et.gentity_get(key, "sess.sessionTeam"))
						if t3 == 1 or t3 == 2 then
							if t ~= t3 then
								table.insert(players3, {
										et.gentity_get(key, "pers.netname"),
										vsstats_kills[id][key],
										vsstats_deaths[id][key]
									})
								--et.trap_SendServerCommand(id, "chat \"" .. et.gentity_get(key, "pers.netname") .. "^7: ^3Kills: ^7" .. vsstats_kills[id][key] .. " ^3Deaths: ^7" .. vsstats_deaths[id][key] .. "\"") 
							end
						end
					end
				end
				send_table(id, {
						{name = "Player"                 },
						{name = "Kills",  align = "right"},
						{name = "Deaths", align = "right"},
					}, players3)
			end
			if et.trap_Argv(1) == "!getvsstats" then
				if et.trap_Argc() ~= 4 then
					et.trap_SendServerCommand(id, "chat \"Usage: ^3!getvsstats PartOfName1 PartOfName2\"")
				else
					local id2, id3
					local flag1 = false
					local flag2 = false
					if string.len(et.trap_Argv(2)) < 3 then
						id2 = tonumber(et.trap_Argv(2))
						if id2 then
							if et.gentity_get(id2, "pers.connected") == 2 then
								flag1 = true
							end
						end
					else
						id2 = inSlot(et.trap_Argv(2))
						if id2 ~= nil then
							flag1 = true
						end
					end
					if string.len(et.trap_Argv(3)) < 3 then
						id3 = tonumber(et.trap_Argv(3))
						if id3 then
							if et.gentity_get(id3, "pers.connected") == 2 then
								flag2 = true
							end
						end
					else
						id3 = inSlot(et.trap_Argv(3))
						if id3 ~= nil then
							flag2 = true
						end
					end
					if flag1 == true and flag2 == true then
						vsstats_f(id2, id3, false)
					end
				end
			end
			if kspree_cmd_enabled and et.trap_Argv(1) == kspree_cmd then
				local map_msg = ""
				local map_max = findMaxKSpree()
				if #map_max ~= 3 then
					map_max = { 0, 0, nil }
				end
				if map_max[3] ~= nil then
					map_msg = string.format("^1map: ^7%s^1: ^7%s^1 (^7%d^1) @ %s",
											mapName(), map_max[3], map_max[1],
											os.date(date_fmt, map_max[2]))
				else
					map_msg = string.format("^1map: ^7%s^1: ^7no record", mapName())
				end
	
				local all_msg = ""
				local all_max = { 0, 0, nil }
				for map, arr in pairs(alltime_stats) do
									if arr[1] > all_max[1] then
										all_max = arr
									end
							end
				if all_max[3] ~= nil then
					all_msg = string.format(" ^1[^7overall: %s^1 (^7%d^1) @ %s^1]",
						all_max[3], all_max[1], os.date(date_fmt, all_max[2]))
				end
				et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^1kspree_record: "..map_msg..all_msg.."^7\"\n")
			elseif et.trap_Argv(1) == record_cmd and srv_record then
				local rec_msg     = recordMessage()
				et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^1kspree_record: "..rec_msg.."^7\"\n")
			elseif et.trap_Argv(1) == stats_cmd and srv_record then
				local stats_msg = statsMessage(id)
				et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3stats: ^7"..stats_msg.."^7\"\n")
			elseif et.trap_Argv(1) == statsme_cmd and srv_record then
				local statsme_msg = statsMessage(id)
				et.trap_SendServerCommand( id, "chat \"^3statsme: ^7"..statsme_msg.." ^7\"\n")
				return(1)
			end -- end elseif...
		end -- et.trap_Argv(0) == "say"
    end

    if et.trap_Argv(0) == msg_command then
        if et.trap_Argv(1) == "" then
            local status = "^8on^7"
            if client_msg[id] == false then
                status = "^8off^7"
            end
            et.trap_SendServerCommand(id,
                    string.format("chat \"^#(ksprees):^7 Messages are %s\"",
                            status))
        elseif tonumber(et.trap_Argv(1)) == 0 then
            setKSpreeMsg(id, false)
            et.trap_SendServerCommand(id,
                    "chat \"^#(ksprees):^7 Messages are now ^8off^7\"")
        else
            setKSpreeMsg(id, true)
            et.trap_SendServerCommand(id,
                    "chat \"^#(ksprees):^7 Messages are now ^8on^7\"")
        end
        return(1)
    end
    
     if et.trap_Argv(0) == topshot_msg_cmd then
        if et.trap_Argv(1) == "" then
            local status = "^8on^7"
            if topshot_msg[id] == false then
                status = "^8off^7"
            end
            et.trap_SendServerCommand(id,
                    string.format("chat \"^#(topshots):^7 Messages are %s\"",
                            status))
        elseif tonumber(et.trap_Argv(1)) == 0 then
            setTopshotMsg(id, false)
            et.trap_SendServerCommand(id,
                    "chat \"^#(topshots):^7 Messages are now ^8off^7\"")
        else
            setTopshotMsg(id, true)
            et.trap_SendServerCommand(id,
                    "chat \"^#(topshots):^7 Messages are now ^8on^7\"")
        end
        return(1)
    end

    if et.trap_Argv(0) == "vsay" then
        if not great_shot then return end
        if et.trap_Argv(1) == nil then return end

        local vsaystring = ParseString(et.trap_Argv(1))
		local customvsay = ParseString(et.trap_Argv(2))
        if vsaystring[1] == nil then return end
        if string.lower(vsaystring[1]) == "greatshot" and last_killer[id] ~= nil and #customvsay == 0 then
            if (et.trap_Milliseconds() - tonumber(last_killer[id][2])) < great_shot_time then
                local vsaymessage = "Great shot, ^7"..last_killer[id][1].."^r!"
				math.randomseed(et.trap_Milliseconds())
                et.trap_SendServerCommand(-1, "vchat 0 "..id.." GreatShot "..math.random().." -1 \""..vsaymessage.."\"")
                if not great_shot_repeat then
                  last_killer[id] = nil
                end
                return(1)
            else
                return(0)
            end

        end -- end lower
    end -- vsay

    if et.trap_Argv(0) == "vsay_team" then
        if not sorry and not thanks then return end
        if et.trap_Argv(1) == nil then return end

        local vsaystring = ParseString(et.trap_Argv(1))
		local customvsay = ParseString(et.trap_Argv(2))
        if vsaystring[1] == nil then return end
        if string.lower(vsaystring[1]) == "sorry" and last_tk[id] ~= nil and #customvsay == 0 then
            if (et.trap_Milliseconds() - tonumber(last_tk[id][2])) < sorry_time then
           	 last_vsaythanks[last_tk[id]] = {et.gentity_get(id, "pers.netname"), et.trap_Milliseconds()}
                local vsaymessage = "^5Sorry, ^7"..last_tk[id][1].."^5!"
                local ppos = et.gentity_get(id,"r.currentOrigin")
                local TKer_team = et.gentity_get(id, "sess.sessionTeam")
                math.randomseed(et.trap_Milliseconds())
				local cmd = string.format("vtchat 0 %d Sorry %d %d %d %f -1 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), math.random(), vsaymessage)
					for t=0, sv_maxclients-1, 1 do
						if et.gentity_get(t, "sess.sessionTeam") == TKer_team then
							et.trap_SendServerCommand(t, cmd)
						end
					end
                if not sorry_repeat then
                  last_tk[id] = nil
                end
                return(1)
            else
                return(0)
            end
        elseif string.lower(vsaystring[1]) == "thanks" and last_revive[id] ~= nil and #customvsay == 0 then
            if (et.trap_Milliseconds() - tonumber(last_revive[id][2])) < thanks_time then
           	 last_vsaythanks[last_revive[id]] = {et.gentity_get(id, "pers.netname"), et.trap_Milliseconds()}
                local vsaymessage = ""
                local ppos = et.gentity_get(id,"r.currentOrigin")
                local team = tonumber(et.gentity_get(id, "sess.sessionTeam"))
				math.randomseed(et.trap_Milliseconds())
				if team == 1 then
					vsaymessage = "^5Danke, ^7"..last_revive[id][1].."^5!"
				elseif team == 2 then
					vsaymessage = "^5Thanks, ^7"..last_revive[id][1].."^5!"
				end
				local cmd = string.format("vtchat 0 %d Thanks %d %d %d %f -1 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), math.random(), vsaymessage)
				for t=0, sv_maxclients-1, 1 do
					if et.gentity_get(t, "sess.sessionTeam") == team then
						et.trap_SendServerCommand(t, cmd)
					end
				end
                if not thanks_repeat then
                  last_revive[id] = nil
                end
                return(1)
            else
                return(0)
            end
        elseif string.lower(vsaystring[1]) == "welcome" and last_vsaythanks[id] ~= nil and #customvsay == 0 then
            if (et.trap_Milliseconds() - tonumber(last_vsaythanks[id][2])) < thanks_time then
                local vsaymessage = ""
                local ppos = et.gentity_get(id,"r.currentOrigin")
                local team = tonumber(et.gentity_get(id, "sess.sessionTeam"))
				math.randomseed(et.trap_Milliseconds())
				if team == 1 then
					local gen = math.random(1, 3)
					if gen == 1 then
						vsaymessage = "^5You're welcome, "..last_vsaythanks[id][1].."^5!"
						local cmd = string.format("vtchat 0 %d Welcome %d %d %d 0.1 1 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), vsaymessage)
						for t=0, sv_maxclients-1, 1 do
							if et.gentity_get(t, "sess.sessionTeam") == team then
								et.trap_SendServerCommand(t, cmd)
							end
						end
					elseif gen == 2 then
						vsaymessage = "^5Bitte sehr, "..last_vsaythanks[id][1].."^5!"
						local cmd = string.format("vtchat 0 %d Welcome %d %d %d 0.4 2 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), vsaymessage)
						for t=0, sv_maxclients-1, 1 do
							if et.gentity_get(t, "sess.sessionTeam") == team then
								et.trap_SendServerCommand(t, cmd)
							end
						end
					elseif gen == 3 then
						vsaymessage = "^5Kein problem, "..last_vsaythanks[id][1].."^5!"
						local cmd = string.format("vtchat 0 %d Welcome %d %d %d 0.7 3 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), vsaymessage)
						for t=0, sv_maxclients-1, 1 do
							if et.gentity_get(t, "sess.sessionTeam") == team then
								et.trap_SendServerCommand(t, cmd)
							end
						end
					end
				elseif team == 2 then
					local gen = math.random(1, 4)
					if gen == 1 or gen == 2 then
						vsaymessage = "^5You're welcome, "..last_vsaythanks[id][1].."^5!"
						local cmd = ""
						if gen == 1 then
							cmd = string.format("vtchat 0 %d Welcome %d %d %d 0.1 1 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), vsaymessage)
						else
							cmd = string.format("vtchat 0 %d Welcome %d %d %d 0.49 2 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), vsaymessage)
						end
						for t=0, sv_maxclients-1, 1 do
							if et.gentity_get(t, "sess.sessionTeam") == team then
								et.trap_SendServerCommand(t, cmd)
							end
						end
					elseif gen == 3 or gen == 4 then
						vsaymessage = "^5No problem, "..last_vsaythanks[id][1].."^5!"
						local cmd = ""
						if gen == 3 then
							cmd = string.format("vtchat 0 %d Welcome %d %d %d 0.74 3 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), vsaymessage)
						else
							cmd = string.format("vtchat 0 %d Welcome %d %d %d 0.9 4 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), vsaymessage)
						end
						for t=0, sv_maxclients-1, 1 do
							if et.gentity_get(t, "sess.sessionTeam") == team then
								et.trap_SendServerCommand(t, cmd)
							end
						end
					end
				end
                if not thanks_repeat then
                  last_vsaythanks[id] = nil
                end
                return(1)
            else
                return(0)
            end
        elseif string.lower(vsaystring[1]) == "needammo" and #customvsay == 0 then
            local vsaymessage = ""
            local ppos = et.gentity_get(id,"r.currentOrigin")
            local team = tonumber(et.gentity_get(id, "sess.sessionTeam"))
			if team ~= 3 then
				local weaponcode = et.gentity_get(id, "s.weapon")
				local weaponname = weapontable[weaponcode]
				if weaponname ~= nil then
					if weaponcode == 5 or weaponcode == 6 or weaponcode == 53 then --in case it's: Panzerfaust or Flamethrower
						ammo = et.gentity_get(id, "ps.ammoclip", weaponcode)
					elseif weaponcode == 3 or weaponcode == 8 or weaponcode == 10 or weaponcode == 23 or weaponcode == 24 or weaponcode == 25 or weaponcode == 30 or weaponcode == 31 or weaponcode == 32 or weaponcode == 34 or weaponcode == 37 or weaponcode == 38 or weaponcode == 43 or weaponcode == 49 or weaponcode == 52 or weaponcode == 54 then
						if weaponcode == 43 or weaponcode == 52 then -- set mortar
							if weaponcode == 43 then
								ammo = et.gentity_get(id, "ps.ammo", 34) + et.gentity_get(id, "ps.ammoclip", 34)
							else
								ammo = et.gentity_get(id, "ps.ammo", 51) + et.gentity_get(id, "ps.ammoclip", 51)
							end
						else
							ammo = et.gentity_get(id, "ps.ammo", weaponcode) + et.gentity_get(id, "ps.ammoclip", weaponcode)
						end
					elseif weaponcode == 40 or weaponcode == 41 or weaponcode == 42 then
						if weaponcode == 40 then -- scoped garand
							ammo = et.gentity_get(id, "ps.ammo", 25) + et.gentity_get(id, "ps.ammoclip", 25)
						elseif weaponcode == 41 then -- scoped k43
							ammo = et.gentity_get(id, "ps.ammo", 31) + et.gentity_get(id, "ps.ammoclip", 31)
						else -- scoped fg42
							ammo = et.gentity_get(id, "ps.ammo", 32) + et.gentity_get(id, "ps.ammoclip", 32)
						end
					elseif weaponcode == 47 or weaponcode == 50 then -- proned mg42
						if weaponcode == 47 then
							ammo = et.gentity_get(id, "ps.ammo", 30) + et.gentity_get(id, "ps.ammoclip", 30)
						else
							ammo = et.gentity_get(id, "ps.ammo", 49) + et.gentity_get(id, "ps.ammoclip", 49)
						end
					else
						return(0)
					end
					vsaymessage = "^5I need ammo! (^2" .. ammo .. " ^5ammo left / ^2" .. weaponname .. "^5)"
					local cmd = string.format("vtchat 0 %d NeedAmmo %d %d %d 0 0 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), vsaymessage)
					for t=0, sv_maxclients-1, 1 do
						if et.gentity_get(t, "sess.sessionTeam") == team then
							et.trap_SendServerCommand(t, cmd)
						end
					end
					return(1)
				else
					local weaponname2 = pistols[weaponcode]
					if weaponname2 ~= nil then
						vsaymessage = "^5I need ammo! (^2" .. weaponname2 .. "^5)"
						local cmd = string.format("vtchat 0 %d NeedAmmo %d %d %d 0 0 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), vsaymessage)
						for t=0, sv_maxclients-1, 1 do
							if et.gentity_get(t, "sess.sessionTeam") == team then
								et.trap_SendServerCommand(t, cmd)
							end
						end
						return(1)
					else
						return(0)
					end
				end
			else
				return(0)
			end
        elseif string.lower(vsaystring[1]) == "medic" and #customvsay == 0 then
            local vsaymessage = ""
            local ppos = et.gentity_get(id,"r.currentOrigin")
            local team = tonumber(et.gentity_get(id, "sess.sessionTeam"))
			math.randomseed(et.trap_Milliseconds())
			if team ~= 3 then
				local health = tonumber(et.gentity_get(id, "health"))
				local vsayflag = false
				if last_vsaymedic[id] == nil then
					last_vsaymedic[id] = et.trap_Milliseconds()
					vsayflag = true
				else
					if (et.trap_Milliseconds() - tonumber(last_vsaymedic[id])) >= 2000 then
						vsayflag = true
						last_vsaymedic[id] = et.trap_Milliseconds()
					end
				end
				if health < 1 then
					if vsayflag == true then
						local gen = math.random(1, 2)
						if gen == 1 then
							vsaymessage = "^5Need a Medic! (^1dead^5)"
							local cmd = string.format("vtchat 0 %d Medic %d %d %d %f -1 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), math.random(), vsaymessage)
							for t=0, sv_maxclients-1, 1 do
								if et.gentity_get(t, "sess.sessionTeam") == team then
									et.trap_SendServerCommand(t, cmd)
								end
							end
						elseif gen == 2 then
							vsaymessage = "^5Revive me!"
							local cmd = string.format("vtchat 0 %d FTReviveMe %d %d %d %f -1 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), math.random(), vsaymessage)
							for t=0, sv_maxclients-1, 1 do
								if et.gentity_get(t, "sess.sessionTeam") == team then
									et.trap_SendServerCommand(t, cmd)
								end
							end
						end
						return(1)
					else
						return(0)
					end
				else
					 if vsayflag == true then
						vsaymessage = "^5Need a Medic! (^1" .. health .. "^5 HP left)"
						local cmd = string.format("vtchat 0 %d Medic %d %d %d %f -1 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), math.random(), vsaymessage)
						for t=0, sv_maxclients-1, 1 do
							if et.gentity_get(t, "sess.sessionTeam") == team then
								et.trap_SendServerCommand(t, cmd)
							end
						end
						return(1)
					else
						return(0)
					end
				end
			else
				return(0)
			end
		elseif string.lower(vsaystring[1]) == "enemydisguised" and #customvsay == 0 then
			local vsaymessage = ""
			local ppos = et.gentity_get(id,"r.currentOrigin")
			local team = tonumber(et.gentity_get(id, "sess.sessionTeam"))
			math.randomseed(et.trap_Milliseconds())
			if team ~= 3 then
				local c = tonumber(et.Info_ValueForKey(et.trap_GetConfigstring(et.CS_PLAYERS + id), "c"))
				vsaymessage = "^5Enemy in disguise! (^2" .. classtable[c] .. "^5)"
				local cmd = string.format("vtchat 0 %d EnemyDisguised %d %d %d %f -1 \"%s\"", id, math.floor(ppos[1]), math.floor(ppos[2]), math.floor(ppos[3]), math.random(), vsaymessage)
				for t=0, sv_maxclients-1, 1 do
					if et.gentity_get(t, "sess.sessionTeam") == team then
						et.trap_SendServerCommand(t, cmd)
					end
				end
				return(1)
			else
				return(0)
			end
        end -- end lower
    end -- vsay_team
   
	local cl_guid = et.Info_ValueForKey(et.trap_GetUserinfo(id), "cl_guid")
	local admin_flag = false
	if et.trap_Argv(0) == "say" or et.trap_Argv(0) == "say_team" or et.trap_Argv(0) == "say_buddy" then	
		if string.lower(et.trap_Argv(1)) == "!pause" then
			fd,len = et.trap_FS_FOpenFile(shrubbot, et.FS_READ)
			if len ~= -1 then
				filestr = et.trap_FS_Read(fd, len)
				et.trap_FS_FCloseFile(fd)
				for v in string.gmatch(filestr, cl_guid .. "\nlevel\t%= ([^\n]+)") do
					if tonumber(v) >= 7 then -- level 7+
						admin_flag = true
						break
					end
				end
				filestr = nil
			else
				et.trap_FS_FCloseFile(fd)
				et.trap_SendServerCommand(id, "chat \"^7shrubbot.cfg not found.\"\n")
			end
			if admin_flag == true then
				changedred = true
				redflag = false
				changedblue = true
				blueflag = false
			end
		end
	end
    return(0)
end

function setKSpreeMsg(id, value)
    client_msg[id] = value
    if value then
        value = "1"
    else
        value = "0"
    end
    et.trap_SetUserinfo(id,
        et.Info_SetValueForKey(et.trap_GetUserinfo(id), "b_ksprees", value)
    )
end

function setTopshotMsg(id, value)
    topshot_msg[id] = value
    if value then
        value = "1"
    else
        value = "0"
    end
    et.trap_SetUserinfo(id,
        et.Info_SetValueForKey(et.trap_GetUserinfo(id), "b_topshots", value)
    )
end

function updateUInfoStatus(id)
    local rs = et.Info_ValueForKey(et.trap_GetUserinfo(id), "b_ksprees")
    if rs == "" then
        setKSpreeMsg(id, msg_default)
    elseif tonumber(rs) == 0 then
        client_msg[id] = false
    else
        client_msg[id] = true
    end
    
    local ts = et.Info_ValueForKey(et.trap_GetUserinfo(id), "b_topshots")
    if ts == "" then
        setTopshotMsg(id, topshot_msg_default)
    elseif tonumber(ts) == 0 then
        topshot_msg[id] = false
    else
        topshot_msg[id] = true
    end
end

function ParseString(inputString)
    local i = 1
    local t = {}
    for w in string.gmatch(inputString, "([^%s]+)%s*") do
        t[i]=w
        i=i+1
    end
    return t
end

function statsMessage(id)
    local guid = getGuid(id)
    local stats_arr = {}
    local name = playerName(id)
    if type(srv_records[guid]) ~= "table" then
        return("no killing stats for "..name.."^7")
    else
        local i = 1
        for i=1, 5 do
            if srv_records[guid][i] > 0 then
                local whatkill = ""
                if i == 1 then whatkill = "Multikills,"
                    elseif i == 2 then whatkill = "Megakills,"
                    elseif i == 3 then whatkill = "Ultrakills,"
                    elseif i == 4 then whatkill = "Monsterkills,"
                    elseif i == 5 then whatkill = "Ludicrouskills"
                end
                table.insert(stats_arr, string.format("^8%d ^7%s", srv_records[guid][i], whatkill))
            end
        end
        local whathedid = ""
        if #stats_arr ~= 0 then
            table.insert(stats_arr, 1, string.format("^7 has made:"))
            table.insert(stats_arr, string.format("^7and"))
            whathedid = table.concat(stats_arr, " ")
        end

        return(string.format("%s^7%s killed a total of ^8%d ^7players since %s",
                            name, whathedid ,srv_records[guid][6],
                            os.date(date_fmt, srv_records[guid][8])))
    end
end

function recordMessage ()
    local rec_arr     = {}
    local multi_rec   = { 0, nil }
    local mega_rec   = { 0, nil }
    local ultra_rec   = { 0, nil }
    local monster_rec = { 0, nil }
    local ludicrous_rec   = { 0, nil }
    local kill_rec  = { 0, nil }

    --multikill
	for guid, arr in pairs(srv_records) do
            if arr[1] > multi_rec[1] then
                multi_rec = { arr[1], arr[7] }
            end
            if arr[2] > mega_rec[1] then
                mega_rec = { arr[2], arr[7] }
            end
            if arr[3] > ultra_rec[1] then
                ultra_rec = { arr[3], arr[7] }
            end
            if arr[4] > monster_rec[1] then
                monster_rec = { arr[4], arr[7] }
            end
            if arr[5] > ludicrous_rec[1] then
                ludicrous_rec = { arr[5], arr[7] }
            end
            if arr[6] > kill_rec[1] then
                kill_rec = { arr[6], arr[7] }
            end

        end

    if multi_rec[2] ~= nil then
        table.insert(rec_arr,
                     string.format("^7%s ^8(^7%d Multikills^8)^7",
                                   multi_rec[2], multi_rec[1]))
    end

    if mega_rec[2] ~= nil then
        table.insert(rec_arr,
                     string.format("^7%s ^8(^7%d Megakills^8)^7",
                                   mega_rec[2], mega_rec[1]))
    end

    if ultra_rec[2] ~= nil then
        table.insert(rec_arr,
                     string.format("^7%s ^8(^7%d Ultrakills^8)^7",
                                   ultra_rec[2], ultra_rec[1]))
    end

    if monster_rec[2] ~= nil then
        table.insert(rec_arr,
                     string.format("^7%s ^8(^7%d Monsterkills^8)^7",
                                   monster_rec[2], monster_rec[1]))
    end

    if ludicrous_rec[2] ~= nil then
        table.insert(rec_arr,
                     string.format("^7%s ^8(^7%d Ludicrouskills^8)^7",
                                   ludicrous_rec[2], ludicrous_rec[1]))
    end

    if kill_rec[2] ~= nil then
        table.insert(rec_arr,
                     string.format("^7%s ^8(^7%d kills^8)^7",
                                  kill_rec[2], kill_rec[1]))
    end

    if #rec_arr ~= 0 then
        local oldest = 2147483647 -- 2^31 - 1
		for guid, arr in pairs(srv_records) do
                if arr[8] < oldest then
                    oldest = arr[8]
                end
            end
        return("^7Top killers: "..table.concat(rec_arr, ", "))
    else
        return("^7no records found :(")
    end
end

function add_qwnage(id, woot)
    local fdqwnage,len = et.trap_FS_FOpenFile( "awards.txt", et.FS_APPEND )
    if len == -1 then
        et.G_Print("kspree.lua: failed to save awards for %s\n", playerName(id))
    else
        if woot == 1 then
            qwnage = playerName(id).. " - Ludicrous Kill - "..os.date().."\n"
        elseif woot == 2 then
            qwnage = playerName(id).. " - Holy Shit - "..os.date().."\n"
        elseif woot == 3 then
            qwnage = playerName(id).. " - Multi TK - "..os.date().."\n"
        end
        et.trap_FS_Write( qwnage, string.len(qwnage) ,fdqwnage )
        et.trap_FS_FCloseFile( fdqwnage )
    end
    return(1)
end

function et_ConsoleCommand()
    local cmd = et.trap_Argv(0)
    local i = 0
    if cmd == "ksprees" then
        et.G_Print("ksprees: --------------------\n")
        for i=0, sv_maxclients-1 do

            if killing_sprees[i] ~= nil and killing_sprees[i] ~= 0 then
                et.G_Print("^7ksprees: %d %s^7 (%s)^7\n",
                            killing_sprees[i],
                            playerName(i),
                            teamName(tonumber(et.gentity_get(i, "sess.sessionTeam"))))
            end
        end
        et.G_Print("^7ksprees: --------------------\n")
        if kmax_id ~= nil then
            et.G_Print("^7Max: %s^7 with %d\n", playerName(kmax_id), kmax_spree)
        end
        return(1)
    elseif cmd == "kspreesall" then
        et.G_Print("^7Alltime killing sprees:\n")
		for map, arr in pairs(alltime_stats) do
            et.G_Print("kspreesall: %s: %s^7 with %d kills @%s\n", map, arr[3], arr[1], os.date(date_fmt, arr[2]))
        end
        et.G_Print("^7Alltime killing sprees END\n")
        return(1)
    elseif cmd == "kspreerecords" then
        et.G_Print("^1kspree_records: %s\n", recordMessage())
        return(1)
    elseif cmd == "kspreedel" then
        srv_records = {}
        saveStats(record_cfg, srv_records)
        et.G_Print("^7All kspree-records has been deleted.\n")
        return(1)
    elseif cmd == "kspree_reset" then
        alltime_stats = {}
        saveStats(kspree_cfg, alltime_stats)
        et.G_Print("^7All sprees has been deleted.\n")
        return(1)
    end

    return(0)
end

--- Sends a nice table to a client.
-- @param id        client slot
-- @param columns   {name = "column header title", align = "right/left/ommit"}, ...
-- @param rows      { { x0, x1, ...} { ... } ... }
-- @param separator print separators between rows?
function send_table(id, columns, rows, separator)

    local lens = {}

    --table.foreach(columns, function(index, column)
        --lens[index] = string.len(et.Q_CleanStr(column.name))
    --end)

	for index, column in pairs(columns) do
		lens[index] = string.len(et.Q_CleanStr(column.name))
	end

    --table.foreach(rows, function(_, row)
    for _, row in pairs(rows) do
        
        --table.foreach(row, function(index, value)
        for index, value in pairs(row) do
            
            local len = string.len(et.Q_CleanStr(value))
            
            if lens[index] < len then
                lens[index] = len
            end

        --end)
        end

    --end)
    end

    local width = 1

    --table.foreach(lens, function(_, len)
        --width = width + len + 3 -- 3 = padding around the value and cell separator
    --end)
    for _, len in pairs(lens) do
		width = width + len + 3 -- 3 = padding around the value and cell separator
	end

    -- Header separator
    et.trap_SendServerCommand(id, "chat \"^7" .. string.rep('-', width) .. "\"")
    --et.G_LogPrint("Endstats: " .. string.rep('-', width) .. "\"\n")

    -- Column names
    local row = "^7|"

    --table.foreach(columns, function(index, column)
        --row = row .. " " .. column.name .. string.rep(' ', lens[index] - string.len(et.Q_CleanStr(column.name))) .. " |"
    --end)
    for index, column in pairs(columns) do
		row = row .. " " .. column.name .. string.rep(' ', lens[index] - string.len(et.Q_CleanStr(column.name))) .. " |"
	end
    et.trap_SendServerCommand(id, "chat \"" .. row .. "\"")
    --et.G_LogPrint("Endstats: " .. row .. "\"\n")

    if #rows > 0 then

        -- Data separator
        et.trap_SendServerCommand(id, "chat \"^7" .. string.rep('-', width) .. "\"")
        --et.G_LogPrint("Endstats: " .. string.rep('-', width) .. "\"\n")

        -- Rows
        --table.foreach(rows, function(_, r)
        for _, r in pairs(rows) do

            local row = "^7|"

            --table.foreach(r, function(index, value)
            for index, value in pairs(r) do
                if columns[index].align == "right" then
                    row = row .. " " .. string.rep(' ', lens[index] - string.len(et.Q_CleanStr(value))) .. value .. " ^7|"
                else
                    row = row .. " " .. value .. string.rep(' ', lens[index] - string.len(et.Q_CleanStr(value))) .. " ^7|"
                end
            --end)
            end

            et.trap_SendServerCommand(id, "chat \"" .. row .. "\"")                      -- values
            --et.G_LogPrint("Endstats: " .. row .. "\"\n")

            if separator then
                et.trap_SendServerCommand(id, "chat \"^7" .. string.rep('-', width) .. "\"") -- separator
                --et.G_LogPrint("Endstats: " .. string.rep('-', width) .. "\"\n")
            end

        --end)
        end

    end

    -- Bottom line
    if not separator then
        et.trap_SendServerCommand(id, "chat \"^7" .. string.rep('-', width) .. "\"")
        --et.G_LogPrint("Endstats: " .. string.rep('-', width) .. "\"\n")
    end

end
