-- !NGadmin v1.3

-- author: X-DOS
-- website: network-games.eu.org

-- ATTENTION:
-- this version is NO more maintained!
-- this version should NOT be used at productive environments!
-- use at your OWN risk!

MOD_PREFIX = "!NGadmin v1.3"
ADMIN_PREFIX = "^1!NGadmin: ^7"
PLAYER_PREFIX = "^3!NGadmin: ^7"

CONFIG = { }
CONFIG["PLAYERS_FOR_SOLDIER"] = 10
CONFIG["PLAYERS_FOR_RIFLEGRENADES"] = 6
CONFIG["UNEVEN_DELAY"] = 10000 --10sec
CONFIG["NOTIFY_DELAY"] = 60000 --1min
CONFIG["UNMUTE_DELAY"] = 300000 --5min
CONFIG["MUTE_TIME"] = 300000 --5min

CONFIG["TK"] = 7
CONFIG["TK_KNIFE"] = 1
CONFIG["TK_LIGHTWEAPONS"] = 4
CONFIG["TK_HEAVYWEAPONS"] = 4

-- SHOW RULES
function ShowRules(client)
  et.trap_SendServerCommand(client, "print \"".. PLAYER_PREFIX .."server's rules\n\"")
  et.trap_SendServerCommand(client, "chat \"^1RULES:\"")
  et.trap_SendServerCommand(client, "chat \" -do game objectives\"")
  et.trap_SendServerCommand(client, "chat \" -respect other players\"")
  et.trap_SendServerCommand(client, "chat \" -play with your team\"")
  et.trap_SendServerCommand(client, "chat \"^1NOT ALLOWED:\"")
  et.trap_SendServerCommand(client, "chat \" spam, cheats, spawnkills, selfkills in fight\"")
  return true
end

-- SHOW INFO
function ShowInfo(client)
  et.trap_SendServerCommand(client, "print \"".. PLAYER_PREFIX .."server's info\n\"")
  et.trap_SendServerCommand(client, "chat \"prosze, nie patrz tak na mnie ^^\"")
  et.trap_SendServerCommand(client, "chat \"\n\"")
  et.trap_SendServerCommand(client, "chat \"^3website:\"")
  et.trap_SendServerCommand(client, "chat \"-> www.network-games.eu.org\"")
  et.trap_SendServerCommand(client, "chat \"^3irc:\"")
  et.trap_SendServerCommand(client, "chat \"-> #network-games @ irc.quakenet.org\"")
  return true
end

-- SHOW MAPS
function ShowMaps(client)
  
  et.trap_SendServerCommand(client, "print \"".. PLAYER_PREFIX .."server's maps\n\"")
  et.trap_SendServerCommand(client, "chat \"^3Cmpgn 1/3:^7 Siwa Oasis, Supply Depot, Gold Rush\"")
  et.trap_SendServerCommand(client, "chat \"^3Cmpgn 2/3:^7 Wurzburg Radar, Braundorf, Caen\"")
  et.trap_SendServerCommand(client, "chat \"^3Cmpgn 3/3:^7 Seawall Battery, Adlernest, Fuel Dump\"")
  return true
end

-- SHOW COMMANDS
function ShowCommands(client)
  if IsAdmin(client) > 0 then
    et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."\n\"")
    et.trap_SendServerCommand(client, "print \"!rules !warn !kick !mute !unmute !getss !protect !unprotect !passvote !cancelvote !vote !notify\n\"")
    et.trap_SendServerCommand(client, "print \"".. PLAYER_PREFIX .."\n\"")
    et.trap_SendServerCommand(client, "print \"!rules !info !time !notify !help\n\"")
  else
    et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .. "!rules !info !time !help\"")
  end
  return true
end

-- IS ADMIN
function IsAdmin(client, status)
  -- set
  if status == true then
    players["admins"] = players["admins"] + 1
    table.insert(admins, client)
    return 0
  -- unset
  elseif status == false then
    players["admins"] = players["admins"] - 1
    for i=0,table.getn(admins),1 do --TODO: lua 5.1 table.maxn
      if admins[i] == client then
        table.remove(admins, i)
        return 0
      end
    end
  -- query
  else
    if et.gentity_get(client, "sess.referee") > 0 then
      for i=0,table.getn(admins),1 do --TODO: lua 5.1 table.maxn
        if admins[i] == client then
          return 2
        end
      end
      return 1
    else
      return 0
    end
  end
end

-- NOTIFY ADMINS
function NotifyAdmins(message)
  if players["admins"] > 0 then
    for i,ref in ipairs(admins) do
      et.trap_SendServerCommand(ref, "chat \"".. ADMIN_PREFIX .. message .."\"")
    end
    return true
  else
    return false
  end
end

-- SAVE LOG
function SaveLog(client, log, command)
  local log_file = et.trap_FS_FOpenFile("/!NGadmin1/".. log .."-".. os.date("%d-%m") ..".log", et.FS_APPEND)
  
  if client >= 0 then
    command = os.date("%d.%m.%Y %X") .." ".. GetPlayerName(client) .." ".. command .."\n"
  else
    command = os.date("%d.%m.%Y %X") .." GAME: ".. command .."\n"
  end
    
  et.trap_FS_Write(command, string.len(command), log_file)
  et.trap_FS_FCloseFile(log_file)
  return 0
end

-- READ ADMINS
function ReadAdminsPasswords()
  local admins_file, length_file = et.trap_FS_FOpenFile("/!NGadmin1/admins.cfg", et.FS_READ)
  local content_file = et.trap_FS_Read(admins_file, length_file)
  et.trap_FS_FCloseFile(admins_file)
  
  --erase the table
  admins_passwords = { }
  
  --load rows into the table
  for name, guid, password in string.gfind(content_file, "([^\r\n]+) (%w+) (%w+)") do
    admins_passwords[guid] = password
  end
end

-- VERYFI ADMIN
function VeryfiAdmin(client, password, strict)
  local player_guid = GetPlayerGUID(client)
  
  if strict == true then
    if admins_passwords[player_guid] == password then
      return true
    else
      return false
    end
  else
    if admins_passwords[player_guid] ~= nil then
      return true
    else
      return false
    end
  end
end

-- READ PROTECTED USERS
function ReadProtectedPlayers()
  --read the file and close
  local protected_file, length_file = et.trap_FS_FOpenFile("/!NGadmin1/protected.cfg", et.FS_READ)
  local content_file = et.trap_FS_Read(protected_file, length_file)
  et.trap_FS_FCloseFile(protected_file)

  --erase the table
  protected_players = { }

  --load rows into the table
  for name, guid in string.gfind(content_file, "([^\r\n]+) (%w+)") do
    protected_players[name] = guid
  end
end

-- WRITE PROTECTED USERS
function WriteProtectedPlayers()
  --erase the file
  local protected_file, length_file = et.trap_FS_FOpenFile("/!NGadmin1/protected.cfg", et.FS_WRITE)
  et.trap_FS_FCloseFile(protected_file)

  --open the file
  local protected_file, length_file = et.trap_FS_FOpenFile("/!NGadmin1/protected.cfg", et.FS_APPEND)

  --write rows to file
  for name, guid in pairs(protected_players) do
    local row = name .. " ".. guid .. "\n"
    et.trap_FS_Write(row, string.len(row), protected_file)
  end

  --close the file
  et.trap_FS_FCloseFile(protected_file)
end

-- CHECK PROTECTED PLAYER
function CheckProtectedPlayer(client)
  local player_guid = GetPlayerGUID(client)
  local player_name = GetPlayerName(client)
  
  for name, guid in pairs(protected_players) do
    if guid == player_guid then
      return true
    end
  end
   
  return false
end

-- CHECK PROTECTED NAMES
function CheckProtectedNames(client)

  local player_name = GetPlayerName(client)
  local player_guid = GetPlayerGUID(client)
  
  for name, guid in pairs(protected_players) do
    if name == player_name and guid ~= player_guid then
      et.trap_SendConsoleCommand(et.EXEC_NOW, "PB_SV_Kick ".. client+1 .." 30 \"Name stealing\"")
      return true
    end
  end

  return false
end

-- GET PLAYER ID
function GetPlayerID(client, name)
  local ref = IsAdmin(client)
  local name = et.Q_CleanStr(name)
  et.trap_SendServerCommand(client, "chat \"".. name .."\"")

  if name == "" then
    if ref > 0 then et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."Not enought parameters\n\"") end
    return nil
  end
  
  local found = false
  
  for i=0,sv_maxclients-1,1 do
    local temp_name = et.Q_CleanStr(et.gentity_get(i, "pers.netname"))
    if temp_name then
      
      if temp_name == name then
        return i
      elseif string.find(string.lower(temp_name), string.lower(name), 1, true) then
        if found ~= false then
          if ref > 0 then et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."More players found\n\"") end
          return nil
        end
        found = i
      end
    end
  end
  
  if found == false then
    if ref > 0 then et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."Player not found\n\"") end
    return nil
  end
  
  return found
end

-- GET PLAYER NAME
function GetPlayerName(client)
  local raw = true
  if raw == true then
    return et.Q_CleanStr(et.gentity_get(client, "pers.netname"))
  else
    return et.gentity_get(client, "pers.netname")
  end
end

-- GET PLAYER GUID
function GetPlayerGUID(client)
  return et.Info_ValueForKey(et.trap_GetUserinfo(client), "cl_guid")
end

-- GET PLAYER IP
function GetPlayerIP(client)
  local ip = et.Info_ValueForKey(et.trap_GetUserinfo(client), "ip")
  local ipstart, ipend, ipmatch = string.find(ip,"(%d+%.%d+%.%d+%.%d+)") 
  return ipmatch
end

----------------------------
----------------------------
-- ENEMY TERRITORY FUNCTIONS

----------------------------------------------------
function et_InitGame(leveltime, randomseed, restart)
  et.RegisterModname(MOD_PREFIX)
  init_time = leveltime

  ReadProtectedPlayers()
  ReadAdminsPasswords()
    
  -- global tables
  admins = { }
  players = { }
  violations = { }
  players[0] = 0 --all
  players[1] = 0 --axis
  players[2] = 0 --allies
  players[3] = 0 --spectators
  players["admins"] = 0
  players["mute"] = false
  
  -- global variables
  sv_maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))

  et.trap_SendServerCommand(-1, "cp \"^3objective gameplay\"")
end

---------------------------------
function et_ShutdownGame(restart)

end

-------------------
function et_ClientConnect(client, firsttime, isbot)
  -- prepare player's tables
  local player_guid = GetPlayerGUID(client)
  players[player_guid] = { }
  violations[player_guid] = { }
end

------------------------------------
function et_ClientDisconnect(client)
  
  -- players uncout
  if players[GetPlayerGUID(client)]["connected"] ~= nil then
    SaveLog(client, "game", "[".. GetPlayerGUID(client) .."] ".. GetPlayerIP(client) .." disconnected")
  
    local player_team = et.gentity_get(client, "sess.SessionTeam")
    if player_team ~= 3 then
      players[0] = players[0] - 1
    end
    players[player_team] = players[player_team] - 1
  end

  -- remove referee status
  if IsAdmin(client) > 0 then
    IsAdmin(client, false)
  end
end

-------------------------------
function et_ClientBegin(client)
  et.trap_SendServerCommand(client, "cp \"^3objective gameplay\"")
  
  if IsAdmin(client) ~= 0 and VeryfiAdmin(client, nil, false) == true then
    IsAdmin(client, true)
  end
  
  SaveLog(client, "game", "[".. GetPlayerGUID(client) .."] ".. GetPlayerIP(client) .." connected")
  
  -- players counting
  local player_guid = GetPlayerGUID(client)
  local player_team = et.gentity_get(client, "sess.SessionTeam")
  if player_team ~= 3 then
    players[0] = players[0] + 1
  end
  players[player_team] = players[player_team] + 1
  players[player_guid]["connected"] = level_time
  players[player_guid]["medals"] = et.Info_ValueForKey(et.trap_GetConfigstring(689 + client), "m")
  
  --greetings for protected players
  --if CheckProtectedPlayer(client) then
  --  et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."Welcome ".. GetPlayerName(client) ..". Have Fun!\"")
  --end
end

----------------------------------------
function et_ClientSpawn(client, revived)

  local player_guid = GetPlayerGUID(client)

  -----------------------
  -- pre SELFKILL restriction
  if revived == 0 then
    players[player_guid]["lastspawn"] = et.gentity_get(client, "pers.lastSpawnTime")
  end
  
  ---------------
  -- pre !SPEC999
  players[player_guid]["origin"] = et.gentity_get(client, "origin")
  players[player_guid]["damage_given"] = et.gentity_get(client, "sess.damage_given")
  
end

-------------------------------------------
function et_Obituary(client, killer, death)
  local player_guid = GetPlayerGUID(client)
  local game_state = tonumber(et.trap_Cvar_Get("gamestate"))

  ----------------------
  -- SOLDIER restriction
  if players[0] < CONFIG["PLAYERS_FOR_SOLDIER"] and tonumber(et.trap_Cvar_Get("team_maxSoldiers")) ~= 0 then
    et.trap_SendConsoleCommand(et.EXEC_NOW, "set team_maxSoldiers 0")
  elseif players[0] >= CONFIG["PLAYERS_FOR_SOLDIER"] and tonumber(et.trap_Cvar_Get("team_maxSoldiers")) ~= 1 then
    et.trap_SendConsoleCommand(et.EXEC_NOW, "set team_maxSoldiers 1")
  end
  
  if et.gentity_get(client, "sess.latchPlayerType") == 0 and tonumber(et.trap_Cvar_Get("team_maxSoldiers")) == 0 then
    if et.gentity_get(client, "sess.PlayerType") ~= 0 then
      et.gentity_set(client, "sess.latchPlayerType", et.gentity_get(client, "sess.PlayerType"))
    else
      et.gentity_set(client, "sess.latchPlayerType", 1)
    end
    
    if death ~= 64 then -- mod_switchteam
      et.trap_SendServerCommand(client, "cp \"Soldiers are currently unavailable\"")
    end
  end
  
  -----------------------------
  -- RIFLE GRENADES restriction
  if players[0] < CONFIG["PLAYERS_FOR_RIFLEGRENADES"] and tonumber(et.trap_Cvar_Get("b_RifleGrenades")) ~= 0 then
    et.trap_SendConsoleCommand(et.EXEC_NOW, "b_RifleGrenades 0")
    et.trap_SendConsoleCommand(et.EXEC_NOW, "team_maxriflegrenades 0")
  elseif players[0] >= CONFIG["PLAYERS_FOR_RIFLEGRENADES"] and tonumber(et.trap_Cvar_Get("b_RifleGrenades")) ~= 1 then
    et.trap_SendConsoleCommand(et.EXEC_NOW, "b_RifleGrenades 1")
    et.trap_SendConsoleCommand(et.EXEC_NOW, "team_maxriflegrenades 1")
  end
  
  --------------------
  -- MINES restriction
  et.trap_SendConsoleCommand(et.EXEC_NOW, "set team_maxMines ".. (players[0]+1)/2)
  
  -- the game is running
  if game_state ~= 1 and game_state ~= 2 then
  
    ---------------
    -- UNEVEN TEAMS
    if (( (players[1] - players[2]) > 1 and et.gentity_get(client, "sess.SessionTeam") == 2 ) or ( (players[2] - players[1]) > 1 and et.gentity_get(client, "sess.SessionTeam") == 1 )) and death ~= 37 then
      if players["uneven_time"] == nil then
        players["uneven_time"] = 0
      end
      
      if level_time - players["uneven_time"] > CONFIG["UNEVEN_DELAY"] then
        et.trap_SendServerCommand(-1, "chat \"".. PLAYER_PREFIX .."Teams look pretty uneven... Please even teams up!\"")
        SaveLog(-1, "game", "uneven teams")
        players["uneven_time"] = level_time
      end
    end
  
    -------------------------
    -- TEAM KILL restrictions
    if et.gentity_get(client, "sess.SessionTeam") == et.gentity_get(killer, "sess.SessionTeam") and client ~= killer then
      local killer_guid = GetPlayerGUID(killer)
      
      if violations[killer_guid]["TK"] == nil then
        violations[killer_guid]["TK"] = 0
      end
      
      local tk_weapon = nil
      if death == 6 then
        tk_weapon = "TK_KNIFE"
      elseif death == 9 or death == 10 then
        tk_weapon = "TK_LIGHTWEAPONS"
      elseif death == 3 or death == 17 or death == 19 or death == 27 or death == 30 or death == 49 or death == 57 then
        tk_weapon = "TK_HEAVYWEAPONS"
      end
      
      if tk_weapon ~= nil then
        if violations[killer_guid][tk_weapon] == nil then
          violations[killer_guid][tk_weapon] = 0
        end
        if violations[killer_guid][tk_weapon .."_time"] == nil then
          violations[killer_guid][tk_weapon .."_time"] = 0
        end
        
        if et.gentity_get(killer, "sess.PlayerType") == 1 then -- exclude medics (can kill to revive)
          --TODO: revive
        else
          if (level_time - violations[killer_guid][tk_weapon .."_time"]) > 3000 then
            violations[killer_guid][tk_weapon] = violations[killer_guid][tk_weapon] + 1
          end
          violations[killer_guid]["TK"] = violations[killer_guid]["TK"] + 1
          
          if violations[killer_guid][tk_weapon] > CONFIG[tk_weapon] or violations[killer_guid]["TK"] > CONFIG["TK"] then
            et.trap_SendServerCommand(killer, "chat \"".. GetPlayerName(killer) .."\"")
            et.trap_SendConsoleCommand(et.EXEC_NOW, "PB_SV_Kick ".. killer+1 .."\" 30 \"Team Kills\"")
          elseif violations[killer_guid][tk_weapon] == CONFIG[tk_weapon] or violations[killer_guid]["TK"] == CONFIG["TK"] then
            et.trap_SendServerCommand(killer, "chat \"".. PLAYER_PREFIX .."TEAM KILLS are not allowed! Your last warning!\"")
          else
            et.trap_SendServerCommand(killer, "chat \"".. PLAYER_PREFIX .."TEAM KILLS are not welcomed!\"")
          end
        end
      end
    end
  end
  
  return 0
end

-----------------------------------------
function et_ClientUserinfoChanged(client)

  local gamestate = tonumber(et.trap_Cvar_Get("gamestate"))
  
  -- players counting
  local player_guid = GetPlayerGUID(client)
  local player_team = et.gentity_get(client, "sess.SessionTeam")
  if players[player_guid]["team"] == nil then
    players[player_guid]["team"] = player_team
  end
  local player_lastteam = players[player_guid]["team"]
  
  if player_team ~= player_lastteam then
    players[player_lastteam] = players[player_lastteam] - 1
    players[player_team] = players[player_team] + 1
    if player_team == 3 then
      players[0] = players[0] - 1
    end
    if player_lastteam == 3 then
      players[0] = players[0] + 1
    end
  end
  
  players[player_guid]["team"] = et.gentity_get(client, "sess.SessionTeam")
  
  -- end of map
  if gamestate ~= 3 and players[player_guid]["medals"] ~= et.Info_ValueForKey(et.trap_GetConfigstring(689 + client), "m") and players["end"] == nil then
    NotifyAdmins("debug: ".. gamestate) --TODO
    et.trap_SendServerCommand(-1, "chat \"Thanks for playing. Visit our webpage:\"")
    et.trap_SendServerCommand(-1, "chat \"-> www.network-games.eu.org\"")
    players["end"] = true
  end

  return 0
end

------------------------------------------
function et_ClientCommand(client, command)

  local command = string.lower(command)
  local arg1 = et.trap_Argv(1)
  local arg2 = et.trap_Argv(2)
  local arg3 = et.trap_Argv(3)
  local args = et.ConcatArgs(1)
  local send_to = client

  local ref = IsAdmin(client)
  
  if (command == "say" or command == "vsay") and players["mute"] == true and ref == 0 then
      return 1
  end
  
  -- SAY's functions
  if command == "say" then
  
    -- LOG
    if ref == 0 then
      SaveLog(client, "game", et.ConcatArgs(0))
    end
  
    -- !DEBUG
    if arg1 == "!bug" then
      et.trap_SendServerCommand(client, "chat \"all = ".. players[0] .."\"")
      et.trap_SendServerCommand(client, "chat \"axis = ".. players[1] .."\"")
      et.trap_SendServerCommand(client, "chat \"allies = ".. players[2] .."\"")
      et.trap_SendServerCommand(client, "chat \"specs = ".. players[3] .."\"")
      return 1
    end
      
    -- !RULES
    if arg1 == "!rules" then   
      ShowRules(send_to)
      return 1
    end
    
    -- !TIME
    if arg1 == "!time" then
      et.trap_SendServerCommand(client, "print \"".. PLAYER_PREFIX .."\n\"")
      et.trap_SendServerCommand(client, "chat \"".. os.date() .." (central europe)\"")
      return 1
    end
    
    -- !NOTIFY
    if arg1 == "!notify" then
      if arg2 == "" then
        et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."Usage: !notify <message>\"")
        return 1
      end
    
      if et.gentity_get(client, "sess.muted") == 0 then
        local player_guid = GetPlayerGUID(client)
        if players[player_guid]["notify"] == nil then
          players[player_guid]["notify"] = 0
        end
              
        -- if admins are present
        if players["admins"] > 0 then
          if (level_time - players[player_guid]["notify"]) > CONFIG["NOTIFY_DELAY"] then
            NotifyAdmins("(".. GetPlayerName(client) ..") ".. et.ConcatArgs(2))
            et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."Your message has been sent to referees.")
            players[player_guid]["notify"] = level_time
          else
            et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."Your request has been ignored. Try later.")
          end
        -- there is no admins
        else
          et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."There is no referees.")
          --TODO: jabber notify
        end
      end
      return 1
    end
    
    -- !SPEC999    
    if arg1 == "!spec999" then
      local gamestate = tonumber(et.trap_Cvar_Get("gamestate"))
      if gamestate ~= 1 and gamestate ~= 2 then
        for i=0,sv_maxclients-1,1 do
          local player_guid = GetPlayerGUID(i)
          if player_guid ~= "" and et.gentity_get(i, "sess.SessionTeam") ~= 3 then
            local position = et.gentity_get(i, "origin")
            local origin = players[player_guid]["origin"]
            if math.abs(position[1] - origin[1]) < 50 and math.abs(position[2] - origin[2]) < 50 and math.abs(position[3] - origin[3]) < 50 and et.gentity_get(client, "sess.damage_given") == players[player_guid]["damage_given"] and level_time - players[player_guid]["lastspawn"] > 30000 then
              et.trap_SendConsoleCommand(et.EXEC_NOW, "ref remove \"".. GetPlayerName(client) .."\"")
            end
          end
        end
      end
      return 1
    end
    
    -- !INFO
    if arg1 == "!info" then
      ShowInfo(client)
      return 1
    end
    
    -- !MAPS
    if arg1 == "!maps" then
      ShowMaps(client)
      return 1
    end
    
    -- !HELP
    if arg1 == "!help" then
      arg2 = string.lower(arg2)
      
      -- player's functions
      if arg2 == "rules" or arg2 == "!rules" then
        et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."help for !rules\"")
        et.trap_SendServerCommand(client, "chat \" displays server rules for a player\"")
        return 1
      end
        
      if arg2 == "time" or arg2 == "!time" then
        et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."help for !time\"")
        et.trap_SendServerCommand(client, "chat \" displays local server time for a player\"")
        return 1
      end
       
      if arg2 == "notify" or arg2 == "!notify" then
        et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."help for !notify\"")
        et.trap_SendServerCommand(client, "chat \" sends a message to referees\"")
        return 1
      end
        
      et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."!help <command>\"")
        
      return 1
    end

    -- anything else said with "!"
    if string.sub(arg1, 1, 1) == "!" then
      ShowCommands(client)
      return 1
    end
    
    return 0
  end
  
  -------------------
  -- ADMINS functions
  if string.sub(command, 1, 1) == "!" then
    args = et.ConcatArgs(0)
    
    if ref == 0 then
      return 0
    end
  
    -- !RULES
    if command == "!rules" then   
      if arg1 ~= "" then
        --for all
        if arg1 == "all" then
          et.G_Sound(send_to, et.G_SoundIndex("/sound/misc/referee.wav"))
          send_to = -1
        elseif arg1 == "obj" then
          send_to = -1
          et.trap_SendServerCommand(send_to, "cp \"^3objective gameplay\"")
          return 1
        --for one user
        else
          --checks ID
          send_to = GetPlayerID(client, arg1)
          if send_to == nil then
            return 1
          end
          
          et.trap_SendConsoleCommand(et.EXEC_NOW, "ref warn \"".. GetPlayerName(send_to) .."\" \"Respect server rules\"")
          et.G_Sound(send_to, et.G_SoundIndex("/sound/misc/referee.wav"))
        end
        SaveLog(client, "ref", args)
      end
      
      ShowRules(send_to)
      return 1
    end
    
    -- !WARN
    if command == "!warn" then
      send_to = GetPlayerID(client, arg1)
      if send_to == nil then
        return 1
      end
      
      if arg2 == "sk" then
        et.trap_SendConsoleCommand(et.EXEC_NOW, "ref warn \"".. GetPlayerName(send_to) .."\" \"Spawnkills\"")
        et.trap_SendServerCommand(send_to, "chat \"".. PLAYER_PREFIX .."Spawnkills are NOT allowed!\"")
      elseif arg2 == "skif" then
        et.trap_SendConsoleCommand(et.EXEC_NOW, "ref warn \"\"".. GetPlayerName(send_to) .."\" \"Selfkills in fight\"")
        et.trap_SendServerCommand(send_to, "chat \"".. PLAYER_PREFIX .."Selfkills in fight are NOT allowed!\"")
      elseif arg2 == "spam" then
        et.trap_SendConsoleCommand(et.EXEC_NOW, "ref warn ".. GetPlayerName(send_to) .."\" \"Spam\"")
        et.trap_SendServerCommand(send_to, "chat \"".. PLAYER_PREFIX .."Spam is NOT allowed!\"")
      elseif arg2 == "obj" then
        et.trap_SendConsoleCommand(et.EXEC_NOW, "ref warn \"".. GetPlayerName(send_to) .."\" \"Objective gameplay\"")
        et.trap_SendServerCommand(send_to, "chat \"".. PLAYER_PREFIX .."It IS the objective gameplay server!\"")
      elseif arg2 == "abuse" or arg2 == "abusive" then
        et.trap_SendConsoleCommand(et.EXEC_NOW, "ref warn \"".. GetPlayerName(send_to) .."\" \"Abusive language\"")
        et.trap_SendServerCommand(send_to, "chat \"".. PLAYER_PREFIX .."Do NOT use abusive language!\"")
      else
        et.trap_SendConsoleCommand(et.EXEC_NOW, "ref warn \"".. GetPlayerName(send_to) .."\" \"".. et.ConcatArgs(2) .."\"")
        if arg2 ~= "" then
          et.trap_SendServerCommand(send_to, "chat \"".. PLAYER_PREFIX .. et.ConcatArgs(2) .."\"")
        end
      end
      
      et.G_Sound(send_to, et.G_SoundIndex("/sound/misc/referee.wav"))
      SaveLog(client, "ref", args)
      return 1
    end
    
    -- !MUTE
    if command == "!mute" then
      if arg1 == "all" then
        players["mute"] = true
        et.trap_SendServerCommand(-1, "chat \"".. PLAYER_PREFIX .."STFU! :)\"")
        SaveLog(client, "ref", args)
        return 1
      end
      
      send_to = GetPlayerID(client, arg1)
      if send_to == nil then
        return 1
      end
      
      et.trap_SendConsoleCommand(et.EXEC_NOW, "ref mute ".. send_to)
      SaveLog(client, "ref", args)
      return 1
    end
    
    -- !UNMUTE
    if command == "!unmute" then
    
      if arg1 == "all" then
        players["mute"] = false
        SaveLog(client, "ref", args)
        return 1
      end
      
      send_to = GetPlayerID(client, arg1)
      if send_to == nil then
        return 1
      end
      
      et.trap_SendConsoleCommand(et.EXEC_NOW, "ref unmute ".. send_to)
      SaveLog(client, "ref", args)
      return 1
    end
    
    -- !KICK
    if command == "!kick" then
      send_to = GetPlayerID(client, arg1)
      if send_to == nil then
        return 1
      end
      
      et.trap_SendConsoleCommand(et.EXEC_NOW, "PB_SV_Kick ".. send_to+1 .." 30 \"".. et.ConcatArgs(2) .."\"")
      SaveLog(client, "ref", args)
      return 1
    end
    
    -- !GETSS
    if command == "!getss" then
      if ref == 1 then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."You don not have a permission to this command.\n\"")
        SaveLog(client, "ref", args)
        return 1
      end
      
      send_to = GetPlayerID(client, arg1)
      if send_to == nil then
        return 1
      end
      
      et.trap_SendConsoleCommand(et.EXEC_NOW, "pb_sv_getss ".. send_to+1)
      SaveLog(client, "ref", args)
      return 1
    end

    -- !PROTECT
    if command == "!protect" then
      if ref == 1 then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."You don not have a permission to this command.\n\"")
        SaveLog(client, "ref", args)
        return 1
      end

      send_to = GetPlayerID(client, arg1)
      if send_to == nil then
        return 1
      end
      
      if CheckProtectedPlayer(send_to) and arg2 ~= "@" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .. GetPlayerName(send_to) .." is a protected player.\n\"")
        SaveLog(client, "ref", args)
        return 1
      end
      
      protected_players[GetPlayerName(send_to)] = GetPlayerGUID(send_to)
      WriteProtectedPlayers()
      
      et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .. GetPlayerName(send_to) .." is now protected.\n\"")
      if et.trap_Argv(2) == "!" then et.trap_SendServerCommand(send_to, "chat \"".. PLAYER_PREFIX .. "You are a protected player now.\"") end
      SaveLog(client, "ref", args)
      return 1
    end
    
    -- !UNPROTECT
    if command == "!unprotect" then
      if ref == 1 then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."You don not have a permission to this command.\n\"")
        SaveLog(client, "ref", args)
        return 1
      end
      
      send_to = GetPlayerID(client, arg1)
      if send_to == nil then
        return 1
      end
      
      if not CheckProtectedUser(send_to) then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .. GetPlayerName(send_to) .." is not a protected player.\n\"")
        SaveLog(client, "ref", args)
        return 1
      end

      local player_guid = GetPlayerGUID(send_to)
      local found = false
      
      for name, guid in pairs(protected_users) do
        if guid == player_guid then
          protected_users[name] = nil
          et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .. name .." is now unprotected\n\"")
          found = true
        end
      end

      -- notify if "!" is supplied
      if found and et.trap_Argv(2) == "!" then
        et.trap_SendServerCommand(send_to, "chat \"".. PLAYER_PREFIX .. "You are not a protected player anymore\"")
      end

      WriteProtectedPlayers()
      SaveLog(client, "ref", args)
      return 1
    end

    -- !PASSVOTE
    if command == "!passvote" then
      et.trap_SendConsoleCommand(et.EXEC_NOW, "passvote")
      
      NotifyAdmins(GetPlayerName(client) .." has passed the vote.")
      SaveLog(client, "ref", args)
      return 1
    end
    
    -- !CANCELVOTE
    if command == "!cancelvote" then
      et.trap_SendConsoleCommand(et.EXEC_NOW, "cancelvote")
      
      NotifyAdmins(GetPlayerName(client) .." has canceled the vote.")
      SaveLog(client, "ref", args)
      return 1
    end

    -- !NOTIFY
    if command == "!notify" then
      if arg1 == "" then
        et.trap_SendServerCommand(client, "chat \"".. ADMIN_PREFIX .."Usage: !notify <message>\"")
        return 1
      end
    
      -- more admins than 1
      if players["admins"] > 1 then
        NotifyAdmins("^3(".. GetPlayerName(client) ..")^7 ".. et.ConcatArgs(1))
      else
        et.trap_SendServerCommand(client, "chat \"".. ADMIN_PREFIX .."There is no other referees.\"")
      end
      SaveLog(client, "ref", args)
      return 1
    end
    
    -- !ADMIN
    if command == "!admin" then
      if ref == 1 then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."You don not have a permission to this command.\n\"")
        SaveLog(client, "ref", args)
        return 1
      else
        if arg1 == "" then
          et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."Usage: !admin <message>\n\"")
          return 1
        else
          NotifyAdmins(GetPlayerName(client) .." says:")
          et.trap_SendServerCommand(-1, "chat \"".. PLAYER_PREFIX .. et.ConcatArgs(1))
          SaveLog(client, "ref", args)
          return 1
        end
      end
    end
    
    -- !HELP
    if command == "!help" then
    
      if arg1 == "rules" or arg1 == "!rules" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!rules [all|obj|player]\n\"")
        return 1
      end
      
      if arg1 == "warn" or arg2 == "!warn" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!warn <player> [reason]\n\"")
        return 1
      end
      
      if arg1 == "kick" or arg2 == "!kick" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!kick <player>\n\"")
        return 1
      end
      
      if arg1 == "getss" or arg1 == "!getss" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!getss <player>\n\"")
        return 1
      end
      
      if arg1 == "protect" or arg1 == "!protect" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!protect <player>\n\"")
        return 1
      end
      
      if arg1 == "unprotect" or arg1 == "!unprotect" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!unprotect <player>\n\"")
        return 1
      end
      
      if arg1 == "passvote" or arg1 == "!passvote" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!passvote\n\"")
        return 1
      end
      
      if arg1 == "cancelvote" or arg1 == "!cancelvote" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!cancelvote\n\"")
        return 1
      end
      
      if arg1 == "vote" or arg1 == "!vote" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!vote\n\"")
        return 1
      end
      
      if arg1 == "notify" or arg1 == "!notify" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!notify <message>\n\"")
        return 1
      end
      
      if arg1 == "admin" or arg1 == "!admin" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!admin <message>\n\"")
        return 1
      end
      
      et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."!help <command>\n\"")
      return 1
    end
    
    ShowCommands(client)
    return 1
  end
  
  -----------
  -- CALLVOTE
  if command == "callvote" then
  
    -- LOG
    SaveLog(client, "game", et.ConcatArgs(0))
  
    arg1 = string.lower(arg1)
  
    -- MUTE or KICK
    if arg1 == "mute" or arg1 == "kick" then
    
      -- PLAYERS protection
      local player_id

      if tonumber(arg2) ~= nil then
        player_id = arg2
      else
        player_id = GetPlayerID(client, arg2)
      end
      if player_id == nil then
        return 1
      end
    
      if CheckProtectedPlayer(player_id) then
        et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."You can not ".. arg1 .." a protected player.\"")

        if IsAdmin(player_id) > 1 then
          et.trap_SendServerCommand(player_id, "chat \"".. ADMIN_PREFIX .. GetPlayerName(client) .." was trying to ".. arg1 .." you.\"")
        else
          NotifyAdmins(GetPlayerName(client) .. " was trying to ".. arg1 .." ".. GetPlayerName(player_id) ..".")
        end
        
        SaveLog(client, "game", et.ConcatArgs(0) .. " - protection")
        return 1
      end
      
      if players["admins"] > 0 then
        et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."Use !notify <message> to complain.\"")
        return 1
      end
      
      -- pre UNMUTE protection
      if arg1 == "mute" then
        local player_guid = GetPlayerGUID(player_id)
        
        players[player_guid]["mute"] = level_time
      end

      return 0
    end
    
    -- UNMUTE protection
    if arg1 == "unmute" then
      local player_id
      local player_guid

      -- get player_id and player_guid
      if tonumber(arg2) ~= nil then
        player_id = arg2
      else
        player_id = GetPlayerID(client, arg2)
      end
      if player_id == nil then
        return 1
      end
      player_guid = GetPlayerGUID(player_id)

      -- prepare table
      if players[player_guid]["unmute_time"] == nil then
        players[player_guid]["unmute_time"] = 0
      end
      
      -- request for admins
      if players["admins"] > 0 then
        -- only muted players can vote to unmute themselves
        if et.gentity_get(player_id, "sess.muted") and player_id ~= client then
          et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."You can not unmute this player.\"")
          
          NotifyAdmins(GetPlayerName(client) .." was trying to unmute ".. GetPlayerName(player_id))
          return 1
        end

        -- allow to send a request
        if ( level_time - players[player_guid]["unmute_time"] ) > CONFIG["UNMUTE_DELAY"] then
          players[player_guid]["unmute_time"] = level_time
      
          et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."Your request for unmute has been sent to a referee.\"")
        
          NotifyAdmins(GetPlayerName(client) .." is trying to unmute himself.")
        -- ignore a request
        else
          et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."Your request has been ignored.\"")
        end
        return 1
      -- use time restriction if there is no admins
      else
        if et.gentity_get(player_id, "sess.muted") and ( level_time - players[player_guid]["mute"] ) < CONFIG["MUTE_TIME"] then
          et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."You are temporary muted. Try later.\"")
          return 1
        end
      end

      return 0
    end
    
    -- DISABLE VOTING 5min before end of map
    -- if ( arg1 == "maprestart" or arg1 == "matchreset" or arg1 == "swapteams" or arg1 == "nextmap" or arg1 == "shuffleteamsxp" or arg1 == "shuffleteamsxp_norestart" ) and ( et.trap_Cvar_Get("timelimit")*1000000 - level_time < 500000 ) then
    --  local vote_names = { maprestart = "Map Restart", matchreset = "Match Restart", swapteams = "Swap Teams", nextmap = "New Campaign", shuffleteamsxp = "Shuffle Teams by XP", shuffleteamsxp_norestart = "Shuffle Teams by XP wihtout Map Restart" }
    --  
    --  et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .." ".. vote_names[arg1] .."votings is now DISABLED")
    --  return 1
    --end
    
    return 0
  end
  
  ----------
  -- REF log
  if command == "ref" then
  
    local password = et.trap_Cvar_Get("refereePassword")
    
    if ref == 0 then
      local player_guid = GetPlayerGUID(client)
      if arg1 == password and VeryfiAdmin(client, arg2, true) == true then
        --ref login pass

        -- login options
        if arg3 == "!" then
          IsAdmin(client, true)
          return 0
        end
        
        -- set referee status
        et.gentity_set(client, "sess.referee", 1)
        local client_string = et.trap_GetConfigstring(689 + client)
        client_string = et.Info_SetValueForKey(client_string, "ref", 1)
        et.trap_SetConfigstring(689 + client, client_string)
        
        -- show information about referee login to other referees
        NotifyAdmins(GetPlayerName(client) .." has become a referee")
        
        -- set referee status
        IsAdmin(client, true)
        
        SaveLog(client, "ref", "[".. GetPlayerGUID(client) .."] ".. GetPlayerIP(client) .. " ".. et.ConcatArgs(0))
        return 1
      --ref login fail (exclude logout mistakes)
      elseif arg1 ~= "logout" or arg1 ~= "reflogout" then
        local player_guid = GetPlayerGUID(client)
        if violations[player_guid]["ref"] == nil then
          violations[player_guid]["ref"] = 0
        else
          violations[player_guid]["ref"] = violations[player_guid]["ref"] + 1
        end

        if players["admins"] > 0 then
          NotifyAdmins(GetPlayerName(client) .." is trying to login as a referee!")
        end

        if violations[player_guid]["ref"] >= 3 then
          et.trap_SendConsoleCommand(et.EXEC_NOW, "PB_SV_Ban ".. client+1 .." \"Server access violation\"")
        end
        
        et.trap_SendServerCommand(client, "cpm \"Invalid referee password!\n\"")
        SaveLog(client, "ref", "[".. GetPlayerGUID(client) .."] ".. GetPlayerIP(client) .. " ".. et.ConcatArgs(0))
        return 1
      end
    --ref is executing a command
    else
    
      SaveLog(client, "ref", et.ConcatArgs(0))
    
      -- ref logout
      if arg1 == "reflogout" or arg1 == "logout" then
        IsAdmin(client, false)
        return 0
      end
      
      -- REF WARN workaround
      if arg1 == "warn" then
        local player_id
        if tonumber(arg2) ~= nil then
          player_id = arg2
        else
          player_id = GetPlayerID(client, arg2)
        end
        if player_id == nil then
          return 1
        end
        
        et.G_Sound(send_to, et.G_SoundIndex("/sound/misc/referee.wav"))
        return 0
      end
      
      -- SOLDIERS restriction workaround
      if (arg1 == "putaxis" or arg1 == "putallies") then
        local player_id
        if tonumber(arg2) ~= nil then
          player_id = arg2
        else
          player_id = GetPlayerID(client, arg2)
        end
        if player_id == nil then
          return 1
        end
        
        if tonumber(et.trap_Cvar_Get("team_maxSoldiers")) == 0 and et.gentity_get(client, "sess.latchPlayerType") == 0 then
          if et.gentity_get(client, "sess.PlayerType") ~= 0 then
            et.gentity_set(client, "sess.latchPlayerType", et.gentity_get(client, "sess.PlayerType"))
          else
            et.gentity_set(client, "sess.latchPlayerType", 1)
          end
        end
        return 0
      end
      
      
      -- DISABLE some ref's command
      if arg1 == "comp" or arg1 == "pub" then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."This command is disabled.\n\"")
        return 1
      end
      
      if ref == 1 and (arg1 == "config" or arg1 == "gametype" or arg1 == "timelimit" or arg1 == "map") then
        et.trap_SendServerCommand(client, "print \"".. ADMIN_PREFIX .."This command is disabled.\n\"")
      end
      
    end
    return 0
  end
  
  -----------------------
  -- SELFKILL restriction
  if command == "kill" then
    local game_state = tonumber(et.trap_Cvar_Get("gamestate"))

    if game_state ~= 1 and game_state ~= 2 then
      local player_guid = GetPlayerGUID(client)
      local player_ingame = level_time - players[player_guid]["lastspawn"]
      local player_team = et.gentity_get(client, "sess.sessionTeam")
      local player_respawn;
      
      if player_team == 1 then
        player_respawn = tonumber(et.trap_Cvar_Get("g_redlimbotime"))
      elseif player_team == 2 then
        player_respawn = tonumber(et.trap_Cvar_Get("g_bluelimbotime"))
      end
      
      player_ingame = math.mod(player_ingame, player_respawn) --TODO: lua 5.1?
      
      if ( player_respawn - player_ingame ) > 3000 and ( players[player_guid]["lastspawn"] - init_time ) > player_respawn then
        et.trap_SendServerCommand(client, "chat \"".. PLAYER_PREFIX .."SELFKILLS are allowed only before respawn.\"")
        return 1
      end
    end

    return 0
  end
  
  ------------------
  -- NAME protection
  if command == "name" then
    CheckProtectedNames(client)
  end
  
  return 0
end

function et_RunFrame(levelTime)
  level_time = levelTime
end
