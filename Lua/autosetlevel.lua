Description = "Autosetlevel"
Version =     "0.4"

--[[
Original Author: Perlo_0ung?!
www.ef-clan.org
--]]

--Micha!s edits:
--v.03b: added name function
--v0.3c: added more levels
--v0.3d: added TheSilencerPL suggestion
--		 added more detection ways
--v0.4:  setlevel command detecttion depending on mod

----------------------------------------------------------------------
-- CONFIGURATION
----------------------------------------------------------------------

lvl1xp = 2000
lvl2xp = 8000
lvl3xp = 14000
lvl4xp = 24000
lvl5xp = 34000
lvl6xp = 50000

----------------------------------------------------------------------
-- DO NOT EDIT BELOW THIS LINE
-- UNLESS YOU KNOW WHAT YOU'RE DOING
----------------------------------------------------------------------

function et_InitGame(levelTime,randomSeed,restart)
	et.G_Print(""..Description.." Version: ".. Version .." Loaded\n")
    et.RegisterModname(et.Q_CleanStr(Description).."   "..Version.."   "..et.FindSelf())
end

function et_ClientSpawn( clientNum, revived, teamChange, restoreHealth )
	local valXP = getXP(clientNum)
	if valXP >=  lvl1xp and valXP < lvl2xp then    
		setlevel(clientNum,1,lvl1xp)
	elseif valXP >=  lvl2xp and valXP < lvl3xp then    
		setlevel(clientNum,2,lvl2xp)
	elseif valXP >=  lvl3xp and valXP < lvl4xp then    
		setlevel(clientNum,3,lvl3xp)
	elseif valXP >=  lvl4xp and valXP < lvl5xp then    
		setlevel(clientNum,4,lvl4xp)
	elseif valXP >=  lvl5xp and valXP < lvl6xp then   
		setlevel(clientNum,5,lvl5xp)
	elseif getXP(clientNum) >= lvl6xp then
        setlevel(clientNum,6,lvl6xp)
    end 
end

function et_ClientBegin( clientNum )
	local valXP = getXP(clientNum)
	if valXP >=  lvl1xp and valXP < lvl2xp then    
		setlevel(clientNum,1,lvl1xp)
	elseif valXP >=  lvl2xp and valXP < lvl3xp then    
		setlevel(clientNum,2,lvl2xp)
	elseif valXP >=  lvl3xp and valXP < lvl4xp then    
		setlevel(clientNum,3,lvl3xp)
	elseif valXP >=  lvl4xp and valXP < lvl5xp then    
		setlevel(clientNum,4,lvl4xp)
	elseif valXP >=  lvl5xp and valXP < lvl6xp then   
		setlevel(clientNum,5,lvl5xp)
	elseif getXP(clientNum) >= lvl6xp then
        setlevel(clientNum,6,lvl6xp)
    end 
end

function checkteam(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client)
	return tonumber(et.Info_ValueForKey(cs, "t"))
end

function getXP(playerID)
	local totalxp = et.gentity_get(playerID, "sess.skillpoints",1) + et.gentity_get(playerID, "sess.skillpoints",2) + et.gentity_get(playerID, "sess.skillpoints",3) + et.gentity_get(playerID, "sess.skillpoints",4) + et.gentity_get(playerID, "sess.skillpoints",5) + et.gentity_get(playerID, "sess.skillpoints",6) + et.gentity_get(playerID, "sess.skillpoints",7)
    return totalxp  
end 

function getlevel(playerID)
    return et.G_shrubbot_level(playerID)
end 

function setlevel(playerID, newlevel, xp)
    if isBot(playerID) or noGuid(playerID) then 
	return end
    if newlevel <= getlevel(playerID) then return end 
        et.trap_SendServerCommand(-1,"chat \"^nCongratulations ^7"..name(playerID).."^n, ^nyou have been promoted to a level ^7"..newlevel.." ^nuser!\"")
		local gamename = et.trap_Cvar_Get( "gamename" )
		if gamename == "infected" or gamename == "jaymod" or gamename == "blight" then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "!set ".. playerID.." "..newlevel.." \n" )
		else
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "!setlevel ".. playerID.." "..newlevel.." \n" )
		end
        et.trap_SendConsoleCommand( et.EXEC_APPEND, "!readconfig\n" ) 
end

function noGuid(playerID)
    local userinfo = et.trap_GetUserinfo( playerID )
    local guid = et.Info_ValueForKey( userinfo, "cl_guid" )
    if guid == "NO_GUID" or guid == "unknown" then  
		return true
    end
end

function name(id) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(id), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end

function isBot(playerID)
	local guid = et.Info_ValueForKey(et.trap_GetUserinfo(playerID),"cl_guid")
    if et.gentity_get(playerID,"pers.connected") == 2 and et.gentity_get(playerID,"ps.ping") == 0 and (string.sub (guid, 25,32 )) == "00000000" then
		return true
    end
end