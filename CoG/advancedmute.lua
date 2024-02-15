mute_logfile = 'gocmod/advmute_log.txt'
mutes = {}
NEEDED_LEVEL = 14
function mutePlayer(targetName,seconds,callerName)
	local maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))-1

	targetID = targetName	-- player to be muted slot or name
	cID = et.ClientNumberFromString (callerName) -- "muter" slot
	-- Begin some tests to make sure we get the slot number we want	
	tID = tonumber(targetID)
	if tID == nil then
		tID = et.ClientNumberFromString (targetID)
	end
	if tID == nil or tID < 0 then
		et.trap_SendServerCommand(callerID,string.format("chat \" %s: Please use a slot number from the list below: \n\"",tID))
		printSlotbyName(targetID, callerID)
		return 0
	end
	if tID > maxclients then 
		et.trap_SendServerCommand(cID,string.format("chat \" Invalid slot number #%s: Insert a slot number between 0 and %s\n\"",tID, maxclients))
		return 0
	end	
	if et.gentity_get(tID,"pers.connected") ~= 2 then
		et.trap_SendServerCommand(cID,string.format("chat \" %s: Client not connected!: \n\"",tID))
		return 0
	end
	-- End the tests
	
	-- Check if player is already muted
	local muted = et.gentity_get(tID, "sess.muted")
	local name = et.gentity_get(tID,"pers.netname")
	if (muted == 1) then
		et.trap_SendServerCommand( cID , string.format("chat \" ^$Mute: ^9Player ^7%s ^9is already muted\"",name))
	else
		local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( tID ), "cl_guid" ))
		local expires = 0
		local muter = et.gentity_get(cID,"pers.netname")
		seconds = seconds or nil
		if tonumber(seconds) ~= nil then
			expires = os.time() + tonumber(seconds)
		end
			
		fd, len = et.trap_FS_FOpenFile( 'gocmod/mute.dat', et.FS_APPEND ) 
		local mute = "\n"
		mute = mute .. "[mute]" .. "\n"
		mute = mute .. "name	= " .. name .. "\n"
		mute = mute .. "guid	= " .. guid .. "\n"
		mute = mute .. "expires	= " .. expires .. "\n"
		mute = mute .. "muter	= " .. muter .. "\n"
		if ( len > -1 ) then
			et.trap_FS_Write( mute, string.len(mute) ,fd )
		end
		et.trap_FS_FCloseFile( fd )
		--load_mutes()

		--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute " .. client .. "\n" )
		et.gentity_set(tID, "sess.muted", 1)
		et.ClientUserinfoChanged(tID)
		--et.trap_SetUserinfo(tID, userinfo )
		et.trap_SendServerCommand( -1 , string.format("chat \" ^$Mute: ^9Player ^7%s ^9has been muted\"",name))
		logTheAction("!pmute", muter, name, guid)
	end
	--et.G_Say( cID, et.SAY_ALL, string.format("chat \" ^2!mute "..name.." ^2"..seconds.."\"" ))
	
	loadMutes()
end

function getSlotbyGuid(guid)
	tGUID = guid
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		local cguid = string.upper( et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" ) )
		if cguid == tGUID then
			slot = i
		end
	end
	return slot
end

--et_ClientUserInfoChanged mutes the player when he reconnects
function unmutePlayer(targetName, who)
	local i = 1
	--tName = targetName
	--local tID = getSlotbyGuid(tGUID)
	--local name = et.gentity_get(tID, "pers.netname")
	--et.gentity_set(tID, "sess.muted", 0)
	--et.ClientUserinfoChanged(tID)
	local maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))-1

	targetID = targetName	-- player to be muted slot or name
	--cID = et.ClientNumberFromString (callerName) -- "muter" slot
	-- Begin some tests to make sure we get the slot number we want	
	tID = tonumber(targetID)
	if tID == nil then
		tID = et.ClientNumberFromString (targetID)
	end
	if tID == nil or tID < 0 then
		et.trap_SendServerCommand(callerID,string.format("chat \" %s: Please use a slot number from the list below: \n\"",tID))
		printSlotbyName(targetID, callerID)
		return 1
	end
	if tID > maxclients then 
		et.trap_SendServerCommand(cID,string.format("chat \" Invalid slot number #%s: Insert a slot number between 0 and %s\n\"",tID, maxclients))
		return
	end	
	if et.gentity_get(tID,"pers.connected") ~= 2 then
		et.trap_SendServerCommand(cID,string.format("chat \" %s: Client not connected!: \n\"",tID))
		return
	end
	-------
	local target_guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( tID ), "cl_guid" ))
	local target_name = et.gentity_get(tID,"pers.netname")
	if tonumber(who) == nil then
		who_name = "Auto-unmute"
	else
		who_name = et.gentity_get(who, "pers.netname")
	end
	logTheAction("!punmute", who_name, target_name, target_guid)
	fd,len = et.trap_FS_FOpenFile( "gocmod/mute.dat", et.FS_READ )
	local filestr = et.trap_FS_Read( fd, len )
	et.trap_FS_FCloseFile( fd )
	-- done reading, parse the mute list, and re-write back all mutes *exept* the specified mute
	fd,len = et.trap_FS_FOpenFile( "gocmod/mute.dat", et.FS_WRITE )
	for name,guid,expires,muter in string.gfind(filestr, "%s*\%[mute%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*expires%s*=%s*(%d+)%s*muter%s*=%s*([^%\n]*)%s*") do
		if (guid == target_guid) then 
			et.gentity_set(tID, "sess.muted", 0)
			et.ClientUserinfoChanged(tID)
			mutes[guid] = ""
			--et.trap_SendConsoleCommand( et.EXEC_APPEND, "!unmute " .. tID)
			--et.G_Print("^3Unmute^w: ^1" ..name.. " ^fhas been unmuted\n" )
			--et.trap_SendServerCommand(-1,string.format("chat \" %s: ^1UNMUTED LADODOASOCClient not connected!: \n\"",name))
		else -- copy the ban back to the mute list
		
			local mute = "\n"
			mute = mute .. "[mute]" .. "\n"
			mute = mute .. "name	= " .. name .. "\n"
			mute = mute .. "guid	= " .. guid .. "\n"
			mute = mute .. "expires	= " .. expires .. "\n"
			mute = mute .. "muter	= " .. muter .. "\n"
			if ( len > -1 ) then
				et.trap_FS_Write( mute, string.len(mute) ,fd )
			end
			
		end
		i=i+1
	end
	et.trap_FS_FCloseFile( fd )
	loadMutes()
	
	et.trap_SendServerCommand( -1 , string.format("chat \" ^$Advanced mute: ^9Player ^7%s ^9has been unmuted\"",target_name))
	
end
function loadMutes()
	fd,len = et.trap_FS_FOpenFile( "gocmod/mute.dat", et.FS_READ )
	local filestr = et.trap_FS_Read( fd, len )
	et.trap_FS_FCloseFile( fd )
	local datenow = os.date()
	local counter = 0
--	local clientGuid = string.upper( et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "cl_guid" ) )
	for name,guid,expires,muter in string.gfind(filestr, "%s*\%[mute%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*expires%s*=%s*(%d+)%s*muter%s*=%s*([^%\n]*)%s*") do
		mutes[guid] = expires
		counter = counter + 1
	end
	et.trap_SendServerCommand( -1 , string.format("chat \" ^$Advanced mute: ^9 Loaded %s mutes.\"", counter)	)
end
function writefile(line,file)
local fd,len
      
     fd, len = et.trap_FS_FOpenFile( file, et.FS_APPEND )
     et.trap_FS_Write( line, string.len( line ), fd )
     et.trap_FS_FCloseFile( fd )
end

function logTheAction(command, who, target, targetguid)
	local nowDate = os.date("%c")
	if command == "!pmute" then
		cmd = "Mute"
	else
		cmd = "Unmute"
	end
	fd, len = et.trap_FS_FOpenFile( 'gocmod/advmute_log.txt', et.FS_APPEND )
	log_line = "OS Date: ["..nowDate.."] || WHO: "..who.." || CMD: "..cmd.." || Target: "..target.." || TargetGUID: "..targetguid.."\n"
	et.trap_FS_Write( log_line, string.len( log_line ), fd )
	et.trap_FS_FCloseFile( fd )
end
function et_ClientBegin(clientNum)
		
	local guid = string.upper( et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "cl_guid" ) )
	local date = os.time()
	local name = et.gentity_get(clientNum, "pers.netname")
	local isMuted = et.gentity_get(clientNum, "sess.muted")
	if isMuted == 1 then
		if tonumber(mutes[guid]) ~= nil and tonumber(mutes[guid]) ~= 0 then
			if tonumber(date) > tonumber(mutes[guid]) then
				unmutePlayer(name, "Autounmute")
				et.trap_SendServerCommand( -1 , string.format("chat \" ^$Advanced mute: ^9Player ^7%s ^9has been auto-unmuted.\"",name))
			end
		end
	end
		if tonumber(mutes[guid]) ~= nil then
			
			if mutes[guid] ~= 0 then 
				et.gentity_set(clientNum, "sess.muted", 1)
				et.ClientUserinfoChanged(clientNum)
				et.trap_SendServerCommand( clientNum , string.format("chat \" ^3Welcome to GoC. Remember you are muted until %s\"",os.date("%c",mutes[guid])))	
			else
				et.gentity_set(clientNum, "sess.muted", 1)
				et.ClientUserinfoChanged(clientNum)
				et.trap_SendServerCommand( clientNum , string.format("chat \" ^3Welcome to GoC. Remember you are muted permanently\""))
			end
		end

end

function et_InitGame(levelTime, randomSeed, restart)
	local modname = "GoC Advanced mute"
	et.RegisterModname(modname)
	et.G_Print("^5" .. modname .. " has been initialized...\n")
	et.G_Print("^5" .. modname .. " created by GoC Clan...\n")
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		local guid = string.upper( et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" ) )
		mutes[guid] = "" -- initialize mute list for all guids connected to server 
	end
	
	loadMutes() -- load muted people connected to server
	return
end
function et_RunFrame(levelTime)
	--mtime = tonumber(levelTime)
	
	local date = os.time()
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		local guid = string.upper( et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" ) )
		local name = et.gentity_get(i, "pers.netname")
		local isMuted = et.gentity_get(i, "sess.muted")
		if isMuted == 1 then
			if tonumber(mutes[guid]) ~= nil and tonumber(mutes[guid]) ~= 0 then
				if tonumber(date) > tonumber(mutes[guid]) then
					unmutePlayer(name, "Autounmute")
					et.trap_SendServerCommand( -1 , string.format("chat \" ^$Advanced mute: ^9Player ^7%s ^9has been auto-unmuted.\"",name))
				end
			end
		end
	end

end

function et_ClientCommand (clientNum,command)

	arg = string.lower(et.trap_Argv(0))
	cmd = string.lower(et.trap_Argv(1))
	arg1 = string.lower(et.trap_Argv(2))
	arg2 = string.lower(et.trap_Argv(3))
	
	adminlvl = et.G_shrubbot_level(clientNum)
	silentFlag = et.G_shrubbot_permission(clientNum,"3")
	
	if adminlvl >= NEEDED_LEVEL then
		if arg == "!readmutes" then
			loadMutes()
			return 1
		end
		if arg == "say" and cmd == "!readmutes" then
			loadMutes()
		end
		
		if arg == "!pmute" and silentFlag == 1 then --Allows silent mute only to admins who have that flag
			mutePlayer(cmd, arg1, clientNum )	
			return 1
		end
		
		if arg == "!punmute" and silentFlag == 1 then --Allows silent mute only to admins who have that flag
			unmutePlayer(cmd, clientNum)	
			return 1
		end
		
		if arg == "say" and cmd == "!pmute" then
			mutePlayer(arg1, arg2, clientNum )
			return 1
		end
		
		if arg == "say" and cmd == "!punmute" then
			unmutePlayer(arg1, clientNum)
		end
	end
end