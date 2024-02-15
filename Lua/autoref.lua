modname = "autoref"
version = "0.1"
shrubbot = 1		--shrubbot in use? (cycles min_level protection on/off)
min_level     = 7 	--could help against guid spoofing

--only this guids can get auto referee
guid_table = {
	{ guids = "247781A58ED646151907D2B992DB8DA8" },
	{ guids = "SJSHNDBG83ß495233AAAAAAAAAAAAAA3" },
	{ guids = "DJHSADLJFHHASAAAAAAAAAAAAAAJ5684" },
}

----------------------------------------------------------------------------------------------

et.CS_PLAYERS = 689

function et_InitGame(levelTime, randomSeed, restart)
  et.RegisterModname(modname .. " " .. version)
  
  maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))
end

function et_ClientConnect( clientNum, firstTime, isBot )
	if getlevel(clientNum) then
		table.foreach(guid_table, function(k,v)
			if getguid(clientNum) == v.guids then
				et.trap_SendConsoleCommand(et.EXEC_APPEND, "ref referee "..clientNum.."" )
				et.gentity_set(clientNum, "sess.referee", 1)
				et.Info_SetValueForKey( et.trap_GetConfigstring( et.CS_PLAYERS + clientNum ), "ref", 1 )
				et.G_globalSound ( "sound/misc/referee.wav" )
				et.trap_SendServerCommand(clientNum, "cpm \"^3*** You have gained referee status ***\n\" " )
				et.trap_SendServerCommand(-1, "cp \"^3"..playerName(clientNum).." ^7has gained referee status\n\" " )
			end
		end) 
	end
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
	elseif shrubbot == 0 then
		return true
	end
		return nil
end

function playerName(id) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(id), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end