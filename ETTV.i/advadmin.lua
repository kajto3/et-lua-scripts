modname = "AdvancedAdmin"
version = "0.5.8"

min_level 		= 8 			--minimum level needed to use advanced admin commands, private message and clan chat
								
reflvl			= 9				--minimum level needed to use ref_cmd

--advanced admin commands
clanchat_cmd		= "mc"		--/mc text
admin_cmd 			= "!ad"		--!admintest
cancel_cmd 			= "!cancel"	--!cancelvote
pass_cmd 			= "!pass"	--!passvote
start_cmd 			= "!start"	--start match
ref_cmd				= "!ref"	--referee login

----------------------------------------------------------------------------------------------
et.CS_PLAYERS = 689

function et_InitGame(levelTime, randomSeed, restart)
  et.RegisterModname(modname .. " " .. version)
  gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
  
  maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))-1
end

local helpa_cmd
helpa_cmd = "!helpa"

function et_ClientCommand(clientNum, command) -- get client commands
	local arg0 = string.lower(et.trap_Argv(0))
    local arg1 = et.trap_Argv(1)
	local cmd = string.lower(command)
	
    if arg0 == "say" then
		if arg1 == helpa_cmd then
			if getlevel(clientNum) then
				et.trap_SendServerCommand( clientNum, "cpm \"^1Commands^3:\n\"" )
				et.trap_SendServerCommand( clientNum, "cpm \" ^7/gib name  ^1-^nkills someone ^7/get name\n\"" )
				et.trap_SendServerCommand( clientNum, "cpm \" ^1-^nteleports someone to you\n\"" )
				et.trap_SendServerCommand( clientNum, "cpm \" ^7/goto name  ^1-^nteleports you to someone\n\"" )
				et.trap_SendServerCommand( clientNum, "cpm \" ^7/"..clanchat_cmd.."  ^1-^nclan chat\n\"" )
				et.trap_SendServerCommand( clientNum, "cpm \" ^7/tp 0/1/2  ^1-^ncycles the thirdperson (it's limited)\n\"" )
				if et.G_shrubbot_level(clientNum) >= reflvl then
					et.trap_SendServerCommand( clientNum, "cpm \" ^7"..ref_cmd.."  ^1-^nreferee login\n\"" )
				end
				return 1
			end
		end
	end

	-- check if client is in list of allowed clan members
    if cmd == clanchat_cmd and getlevel(clientNum) then
		if et.trap_Argc() > 1 then
			-- build message
			local message = ""
			for i = 1, et.trap_Argc() - 1, 1 do
			message = message .. et.trap_Argv(i) .. " "
			end
			-- send message to all other clan members
			for i = 0, maxclients, 1 do
				sendstring = playerName(clientNum) .. " ^w(^8clan chat^w)^8: ^2" .. message
				et.trap_SendServerCommand(i, "chat \"" .. sendstring .. "\"")
				return 1
			end
		end
	elseif cmd == clanchat_cmd and not getlevel(clientNum) then
		et.trap_SendServerCommand(clientNum, "cpm \"^3Sorry, you can't use ^1clan chat\n\" " )
		return 1
    end
  if cmd == "get" then
	if getlevel(clientNum) then
		local getplayer = getPlayerId(et.trap_Argv(1))
		if getplayer == nil then et.trap_SendServerCommand(clientNum, "cpm \"^3Couldn't find the player\n\" " ) return 1 end
		local team = checkteam(clientNum)
		if team == 3 then
			pos = et.gentity_get(clientNum, "s.origin")
		elseif team == 1 or team == 2 then
			pos = et.gentity_get(clientNum, "origin")
		end
		et.gentity_set(getplayer, "origin", pos)
		et.trap_SendServerCommand(clientNum, "cpm \"^7"..playerName(getplayer).." ^3has been moved to ur position!\n\" " )
		return 1
		end
	end
	if cmd == "goto" then
		if getlevel(clientNum) then
			local getplayer = getPlayerId(et.trap_Argv(1))
			if getplayer == nil then et.trap_SendServerCommand(clientNum, "cpm \"^3Couldn't find the player\n\" " ) return 1 end
			local team = checkteam(getplayer)
			if team == 3 then
				gpos = et.gentity_get(getplayer, "s.origin")
			elseif team == 1 or team == 2 then
				gpos = et.gentity_get(getplayer, "origin")
			end
			et.gentity_set(clientNum, "origin", gpos)
			et.trap_SendServerCommand(clientNum, "cpm \"^3You have been moved to ^7"..playerName(getplayer).." ^3position!\n\" " )
			return 1
		end
	end
  if cmd == "gib" then
	 if getlevel(clientNum) then
	   	local getplayer = getPlayerId(et.trap_Argv(1))
		if getplayer == nil then et.trap_SendServerCommand(clientNum, "cpm \"^3Couldn't find the player\n\" " ) return 1 end
        gotohell(getplayer)
		return 1
	  end
  end
    if cmd == "m" then
          if getlevel(clientNum) then
			return 0
          end
			if not getlevel(clientNum) then
				et.trap_SendServerCommand(clientNum, "cpm \"^3Sorry, you can't use ^1private chat\n\" " )
				return 1
			end
    end
		if (string.find(et.trap_Argv(0), "^" .. cancel_cmd .. "") or string.find(et.trap_Argv(1), "^" .. cancel_cmd .. "")) and not string.find(et.trap_Argv(1), "^!cancelvote") then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote" )
		elseif (string.find(et.trap_Argv(0), "^" .. pass_cmd .. "") or string.find(et.trap_Argv(1), "^" .. pass_cmd .. "")) and getlevel(clientNum) and not string.find(et.trap_Argv(1), "^!passvote") then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "passvote" )
		elseif (string.find(et.trap_Argv(0), "^" .. start_cmd .. "") or string.find(et.trap_Argv(1), "^" .. start_cmd .. "")) and et.G_shrubbot_level(clientNum) >= 6 then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref startmatch\n" )
		elseif (string.find(et.trap_Argv(0), "^" .. admin_cmd .. "") or string.find(et.trap_Argv(1), "^" .. admin_cmd .. "")) and not string.find(et.trap_Argv(1), "^!admintest") then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "admintest ".. clientNum.."\n" )
		elseif (string.find(et.trap_Argv(0), "^" .. ref_cmd .. "") or string.find(et.trap_Argv(1), "^" .. ref_cmd .. "")) and et.G_shrubbot_level(clientNum) >= reflvl then
			if et.gentity_get(clientNum, "sess.referee") == 0 then
				et.trap_SendConsoleCommand(et.EXEC_APPEND, "ref referee "..clientNum.."" )
			--else
				--et.trap_SendServerCommand(clientNum, "cpm \"Type: ^3/ref^7 (by itself) for a list of referee commands.\" " )
			end
		end
	return 0
end

-- gets user's guid
-- returns nil if not applicable to entity number
function getguid(targetID)
    if (targetID == nil) or (targetID > maxclients) then
      return nil
    end

    local userinfo = et.trap_GetUserinfo( targetID )
    local guid = et.Info_ValueForKey( userinfo, "cl_guid" )
    -- upcase for exact matches
    guid = string.upper(guid)

    return guid
end
function getlevel(client)
	local lvl = et.G_shrubbot_level(client)
	if lvl >= min_level then
		return true
	end
		return nil
end

function checkteam(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client)
	return tonumber(et.Info_ValueForKey(cs, "t"))
end

function playerName(id) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(id), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end

function gotohell(targetID)
    -- test parameters
    if not targetID then
        return
    end
for j = 0, maxclients do
	if checkteam(j) == 2 or checkteam(j) == 1 then
	local getplayer = getPlayerId(et.trap_Argv(1))
		et.gentity_set(targetID, "health", -200)
		soundindex = et.G_SoundIndex("sound/player/hurt_barbwire.wav" )
		et.G_Sound(targetID, soundindex )
		et.trap_SendServerCommand(-1, "cpm \"^w"..playerName(getplayer).." ^3has been gibbed!\n\" " )
		return 1
		end
	end
end

function printmsg(message, clientID)
    if not message then
        return
    end

    -- replace "s in message with 's
    local dummy
    message, dummy = string.gsub(message, "\"", "'")

    if clientID then
        et.trap_SendServerCommand(clientID, "print \"".. message .."^7\n\"")
    else
        et.G_Print(message .."^7\n")
    end
end

function getPlayerId(name, clientID)
    local i
    -- if it's nil, return nil and throw error
    if (name == "") then
        return
    end
    -- if it's a number, interpret as slot number
    local clientnum = tonumber(name)
    if clientnum then
        if (clientnum <= tonumber(et.trap_Cvar_Get("sv_maxclients"))) and et.gentity_get(clientnum,"inuse") then
            return clientnum
        else
            return
        end
    end
    for i=0,et.trap_Cvar_Get("sv_maxclients"),1 do
		playeri = et.Info_ValueForKey(et.trap_GetUserinfo(i), "name")
		if playeri == nil or playeri == "" then return "unknown" end
        if playeri then
			-- exact match first
            if et.Q_CleanStr( playeri ) == et.Q_CleanStr( name ) then
                return i
			-- partial match
            elseif (string.find(string.lower(et.Q_CleanStr( playeri )), string.lower(et.Q_CleanStr( name )), 1, true)) then
                return i
            end
        end
    end
end