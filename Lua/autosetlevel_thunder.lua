Description = "Autosetlevel"
Version =     "0.3d-1"

--[[
Original Author: Perlo_0ung?!
www.ef-clan.org
--]]

-- This lua requies the 'seen.lua'
-- http://forums.warchest.com/showthread.php/38996-shrubbot-command-!seen

--Micha!s edits:
--v.03b: added name function
--v0.3c: added more levels
--v0.3d: added TheSilencerPL suggestion
--		 added more detection ways
--v0.3d-1 changed level 1 from xp to seen

----------------------------------------------------------------------
-- CONFIGURATION
----------------------------------------------------------------------

seenfile = 				"seen.cfg"			--file data base

lvl2xp = 1000
lvl3xp = 1500
lvl4xp = 2000
lvl5xp = 4000
lvl6xp = 8000

----------------------------------------------------------------------
-- DO NOT EDIT BELOW THIS LINE
-- UNLESS YOU KNOW WHAT YOU'RE DOING
----------------------------------------------------------------------

function et_InitGame(levelTime,randomSeed,restart)
	et.G_Print(""..Description.." Version:".. Version .." Loaded\n")
	et.RegisterModname(""..Description..":".. Version .." slot:".. et.FindSelf())
end

function et_ClientSpawn( clientNum, revived, teamChange, restoreHealth )

	local tempname = et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "name" )
	local cnoname = et.Q_CleanStr( tempname )
	local clientguid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "cl_guid" ))
	
	local valXP = getXP(clientNum)
	if checkseen(clientNum,cnoname,clientguid) and valXP < lvl2xp then    
		setlevel(clientNum,1,0)
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
	if checkseen(clientNum,cnoname,clientguid) and valXP < lvl2xp then    
		setlevel(clientNum,1,0)
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
    return et.gentity_get(playerID, "ps.persistant", 0)   
end 

function getlevel(playerID)
    return et.G_shrubbot_level(playerID)
end 

function setlevel(playerID, newlevel, xp)
    if isBot(playerID) or noGuid(playerID) then return end
    if newlevel <= getlevel(playerID) then return end 
        et.trap_SendServerCommand(-1,"chat \"^nCongratulations ^7"..name(playerID).."^n, ^nyou have ^nbeen ^npromoted ^nto ^na ^nlevel ^7"..newlevel.." ^nuser!\"")
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "setlevel ".. playerID.." "..newlevel.."\n" )
        et.trap_SendConsoleCommand( et.EXEC_APPEND, "readconfig\n" ) 
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
    if et.gentity_get(playerID,"ps.ping") == 0 then
    return true
    end
end

function checkseen(client,clientname,clientguid) 
	local fd,len = et.trap_FS_FOpenFile( ""..seenfile.."", et.FS_READ )
	--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay ^3length: " ..len.. "^7\n" ) --debug
		
		local filestr = et.trap_FS_Read( fd, len )
		
		local Guid
		local Name
		
		for Guid, Name in string.gfind(filestr, "%s%-%s(%x+)%s%-%s*([^%\n]*)") do
			if clientname == Name and clientguid == Guid then
				return true
			end
		end
	et.trap_FS_FCloseFile( fd )
	return false

end