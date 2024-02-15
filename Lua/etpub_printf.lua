-------------------------------------------------------------------------
--- etpub_printf.lua
--- $Id$
--- $Date$
--- $Revision$
local version = "1.1"

local revivers = {}
local patients = {}
local killers  = {}
local preys    = {}
local health   = {}
local replace_pat
local sv_maxclients

local weapons = {
   [0] = "none",
   [1] = "knife",
   [2] = "luger",
   [3] = "mp40", -- "MP 40"?
   [4] = "grenade launcher",
   [5] = "panzerfaust",
   [6] = "flame thrower",
   [7] = "colt",
   [8] = "thompson",
   [9] = "grenade",
  [10] = "sten",
  [11] = "syringe",
  [12] = "ammo pack",
  [13] = "arty",
  [14] = "silencer",
  [15] = "dynamite",
  [16] = "smoke trail",
  [17] = "mapmortar",
  [18] = "VERYBIGEXPLOSION", -- explosion effect for airplane
  [19] = "medkit", -- "med pack"?
  [20] = "binoculars",
  [21] = "pliers",
  [22] = "smoke marker",
  [23] = "kar98",   -- axis' gren launcher's base weapon ;-)
  [24] = "carbine", -- allies' gren launcher's base weapon ;-)
  [25] = "garand",
  [26] = "landmine",
  [27] = "satchel",
  [28] = "satchel det",
  [29] = "tripmine",
  [30] = "smoke bomb",
  [31] = "mobile mg42", -- "mobile MG42"?
  [32] = "k43", -- "K43"?
  [33] = "fg42", -- "FG42"?
  [34] = "dummy mg42", -- haha :)
  [35] = "mortar",
  [36] = "lockpick",
  [37] = "akimbo colt", -- "akimbo colts"?
  [38] = "akimbo luger", -- "akimbo lugers"?

  [39] = "gpg40",
  [40] = "m7",
  [41] = "silenced colt",
  [42] = "garand scope", -- "scoped garand"?
  [43] = "k43 scope", -- "scoped K43"?
  [44] = "fg42 scope", -- "scoped FG42"?
  [45] = "mortar",
  [46] = "medic adrenaline",
  [47] = "akimbo silenced colt", -- "silenced akimbo colts"?
  [48] = "akimbo silenced luger", -- "silenced akimbo lugers"?
  [49] = "mobile mg42 set", -- remove " set"?
}

local classes = {
    [0]="soldier",
    [1]="medic",
    [2]="engineer",
    [3]="field ops",
    [4]="covert ops"
}

replace = {
    -- Ammo given from
    a = function(id, cmd)
        return(string.format("^7*unknown*%s", say_cmds[cmd][SAY_COLOR]))
    end,
    -- Class
    c = function(id, cmd)
        return(classes[tonumber(et.gentity_get(id, "sess.playerType"))])
    end,
    -- Death from
    d = function(id, cmd)
        return(string.format("^7%s%s", playerName(killers[id]), 
                                       say_cmds[cmd][SAY_COLOR]))
    end,
    -- Health given from
    h = function(id, cmd)
        return(string.format("^7*unknown*%s", say_cmds[cmd][SAY_COLOR]))
    end,
    -- Killed by you
    k = function(id, cmd)
        return(string.format("^7%s%s", playerName(preys[id]),
                                       say_cmds[cmd][SAY_COLOR]))
    end,
    -- Location
    l = function(id, cmd) -- no way with etpro 3.2.6, wishlist request filed ;-)
        return(string.format("[%d,%d,%d]",
                unpack(et.gentity_get(id, "r.currentOrigin"))
            )
        )
    end,
    -- name of a Medic's last revive
    m = function(id, cmd)
        return(string.format("^7%s%s", playerName(patients[id]),
                                       say_cmds[cmd][SAY_COLOR]))
    end,
    -- Name
    n = function(id, cmd)
        return(string.format("^7%s%s", playerName(id),
                                       say_cmds[cmd][SAY_COLOR]))
    end,
    -- Player looking at, just for compat with etpub
    p = function(id, cmd)
        return(string.format("^7*unknown*%s", say_cmds[cmd][SAY_COLOR]))
    end,
    -- Reviver
    r = function(id, cmd)
        return(string.format("^7%s%s", playerName(revivers[id]),
                                       say_cmds[cmd][SAY_COLOR]))
    end,
    -- health Status
    s = function(id, cmd)
        local hp = et.gentity_get(id, "health")
        if hp == nil or hp < 0 then
            hp = 0
        end
        return hp
    end,
    -- ammo for current weap
    t = function(id, cmd)
        local weapon = et.gentity_get(id, "s.weapon")
        if weapon == 0 then -- no weapon, no ammo ;-)
            return "0"
        end
        return(et.gentity_get(id,"ps.ammoclip", weapon) +
               et.gentity_get(id,"ps.ammo", weapon)
              )
    end,
    -- Weapon
    w = function(id, cmd)
        return(weapons[et.gentity_get(id, "s.weapon")])
    end,
    -- Health of last killer
    x = function(id, cmd)
        local hp = health[id] or 0
        return(hp)
    end,
}

vsays = {
    -- name, number of possible choices
    ["affirmative"] = 3,
    ["negativ"]     = 3,
    ["welcome"]     = 3,
    ["thanks"]      = 3,
    ["oops"]        = 3,
    ["hi"]          = 3,
    ["bye"]         = 3,
    ["cheer"]       = 8,
    ["__default"]   = 2,
}

function et_InitGame(levelTime, randomSeed, restart)
    sv_maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))
    local p = {}
    table.foreach(replace,
        function(chr, list)
            table.insert(p, chr)
        end
    )
    replace_pat = string.format("%%[([%s])%%]", table.concat(p, ""))
    -- et.G_Print(string.format("REPLACE_PAT='%s'\n", replace_pat))
    et.RegisterModname("etpub_printf.lua" .. version .. " " .. et.FindSelf())
end

function playerName(id)
    if id == nil then
        return "*unknown*"
    end
    local name = et.Info_ValueForKey(et.trap_GetUserinfo(id), "name")
    if name == nil or name == "" then
        return "*unknown*"
    end
    return name
end

SAY_COLOR = 1
SAY_FUNC  = 2

say_cmds = { -- def_color, function
    ["say"]       = { "^r",
                    function(id, txt)
                        et.G_Say(id, et.SAY_ALL, txt)
                    end
                  },
    ["say_team"]  = { "^5",
                    function(id, txt)
                        et.G_Say(id, et.SAY_TEAM, txt)
                    end
                  },
    ["say_buddy"] = { "^3",
                    function(id, txt)
                        et.G_Say(id, et.SAY_BUDDY, txt)
                    end
                  },
    ["say_teamnl"] = { "^5", -- fixme: COLOR
                    function(id, txt) 
                        et.G_Say(id, et.SAY_TEAMNL, txt)
                    end
                  },
    
    ["vsay"]      = { "^r",
                    function(id, txt)
                        local vsay, vs_num
                        vsay, vs_num, txt = getVsay(id, txt)
                        et.trap_SendServerCommand(-1,
                            string.format("vchat 0 %d 50 %s %d \"^r%s\"",
                                id, vsay, vs_num, txt)
                        )
                    end
                  },

    ["vsay_team"] = { "^5",
                    function(id, txt)
                        local pos = et.gentity_get(id, "r.currentOrigin")
                        local tid = tonumber(et.gentity_get(id, "sess.sessionTeam"))
                        local vsay, vs_num
                        vsay, vs_num, txt = getVsay(id, txt)
                        local vtchat = "vtchat 0 %d 50 %s %d %d %d %d \"^5%s\""
                        local cmd = string.format(vtchat,
                                 id, vsay, pos[1], pos[2], pos[3], vs_num, txt)
                        for i=0, sv_maxclients - 1 do
                            if tonumber(et.gentity_get(i, "sess.sessionTeam")) == tid then
                                et.trap_SendServerCommand(i, cmd)
                            end
                        end
                    end
                  }
    }

function getVsay(id, text)
    local words = {}
    local vs_num, vsay
    for w in string.gfind(text, "([^%s]+)%s*") do
        table.insert(words, w)
    end
    local vs_num = tonumber(words[1])
    if vs_num ~= nil then
        vsay = words[2]
        table.remove(words, 1)
        table.remove(words, 1)
    else
        vsay = words[1]
        table.remove(words, 1)
        if vsays[vsay] == nil then
            vs_num = math.random(1, vsays["__default"])
        else
            vs_num = math.random(1, vsays[vsay])
        end
    end
    text = table.concat(words, " ")
    return vsay, vs_num, text
end

function is_sayCmd(word)
    return(table.foreach(say_cmds,
                function(cmd, opts)
                    if cmd == word then return(cmd) end
                end
            )
        )
end

function et_ClientCommand(id, command)
    local say_cmd = is_sayCmd(string.lower(et.trap_Argv(0)))
    if say_cmd ~= nil then
        local text = et.trap_Argv(1)
        local rep  = {}
        local new  = {}
        for chr in string.gfind(text, replace_pat) do
            table.insert(rep, chr)
        end
        if table.getn(rep) == 0 then 
            -- nothing found to replace, message takes the default way
            return(0)
        end

        -- let's see what we have and fill it
        table.foreach(rep,
            function(i, chr)
                if type(replace[chr]) == "function" then
                    local rep_func = replace[chr]
                    local rep_str  = rep_func(id, say_cmd)
                    table.insert(new, i, rep_str)
                else -- err.. this should never happen:
                    table.insert(new, i, "")
                end
            end
        )

        -- protect all "%" in text, replace all [X]s with %s and fill the gaps
        text = string.gsub(text, "%%", "%%%%")
        text = string.gsub(text, replace_pat, "%%s")
        text = string.format(text, unpack(new))

        -- say the new text and tell etpro to ignore it (i.e. not to print
        -- it a second time, after we did it)
        local say_func = say_cmds[say_cmd][SAY_FUNC]
        say_func(id, text)
        return(1)
    end -- say_cmd ~= nil
    return(0) -- not a say cmd
end

function et_Print(text)
    local s,e,medic,zombie = string.find(text, "^Medic_Revive:%s+(%d+)%s+(%d+)")
    if s ~= nil then
        revivers[tonumber(zombie)] = tonumber(medic)
        patients[tonumber(medic)]  = tonumber(zombie)
    end
end

function et_Obituary(victim, killer, mod)
    killers[victim] = killer
    preys[killer]   = victim
    local hp = tonumber(et.gentity_get(killer, "health"))
    if hp == nil or hp < 0 then
        hp = 0
    end

    health[victim] = hp
end

-- vim: ts=4 sw=4 expandtab syn=lua
