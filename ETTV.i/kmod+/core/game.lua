--[[

-------------------------------------
---------- game functions --------
-------------------------------------


time_based()
mutechange(PlayerID, muteTime)
MuteCheck(PlayerID)
killingspreereset()
dspreereset()
flakreset()
spreerecord(PlayerID, kills2)
spreerecord_reset()
mapspreerecord(PlayerID, kills2)
setAdmin(PlayerID, level)
advPlayers(PlayerID)
private_message(PlayerID,client,message) 
curse_filter( PlayerID )
log_chat( PlayerID, mode, text, PMID )
mute_expire() -- checks for expired mutes
generateRandomMap(mapList,players)
Krotation(init) -- kmod+ rotation handle function


-- time_based()
	anything that based on time is here (banners, scans, updates etc..)

-- setAdmin(PlayerID, level)
	recives: slot, level
	returs: sets the slot to level, and updates the shrubbot.dat file

-- private_message(PlayerID,client,message) 
	recives: calling player slot, client to send message to, and message
	returns: sends the message to the client/clients



--]]











function time_based()
	
	local old_time = tonumber( et.trap_Cvar_Get("k_old_time") )
	if old_time == nil then
		et.trap_Cvar_Set( "k_old_time", tostring(os.time()) )
		
	else
		if os.time() - old_time > 1 then -- 1 sec passed
			mute_expire()
			ban_expire()
		end
	end

-------------------------------------------------------------
--------------- Console Log ---------------------------------
-------------------------------------------------------------
	-- console log stuff
	local works, plines -- works = did the function ran without problems (true)
	
	works, plines = pcall(read_etconsole_log)

	if works == false then
		-- LOG read_etconsole_log ERROR
	else 
		if plines ~= nil then
			local flag

			works, flag = assert(pcall(update,plines))
			-- TZAC here

			-- PB
			works, flag = pcall(guid_age,plines)
			if works == true then
				if flag then
					--et.G_Print("\n lets see: we got it!!! \n")
					local i
					local guid_age = tonumber(et.trap_Cvar_Get("k_min_guid_age"))
					if guid_age ~= nil and guid_age ~= 0 then
						for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
							if global_players_table[i] ~= nil then
								if global_players_table[i]["guid_age"] ~= nil then
									et.G_Print("guid age - checking player ".. global_players_table[i]["name"] .. "\n")
									if (global_players_table[i]["guid_age"] < math.abs(guid_age)) then
										et.G_LogPrint("KMOD+ player kicked: " .. i .. " guid is too new\n")
										if guid_age > 0 then
											--et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. i+1 .. " " .. 2 .. " ^9reason: " ..  "your guid is too new, please come back in ^1" .. guid_age-global_players_table[i]["guid_age"] .. "^9 days\n") 
											et.trap_DropClient( i,  "your guid is too new, please come back in ^1" .. guid_age-global_players_table[i]["guid_age"] .. "^9 days\n", 2 )
										else
											--et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. i+1 .. " " .. (math.abs(guid_age)-global_players_table[i]["guid_age"])*1440 .. " ^9reason: " ..  "^9your guid is too new, please come back in ^1" .. math.abs(guid_age)-global_players_table[i]["guid_age"] .. "^9 days\n") 
											et.trap_DropClient( i,  "^9reason: " ..  "^9your guid is too new, please come back in ^1" .. math.abs(guid_age)-global_players_table[i]["guid_age"] .. "^9 days\n", (math.abs(guid_age)-global_players_table[i]["guid_age"])*1440 )
										end
									end
								end
							end
						end
					end

				end
			end
			if TZAC <= 0 then -- PB!
				pcall(guid_spoof_check,plines)
			end

			
			if tonumber(et.trap_Cvar_Get("k_etconsole_lines")) then
				if tonumber(et.trap_Cvar_Get("k_etconsole_lines")) > 40000  then
					et.trap_SendServerCommand( -1 , string.format('%s \"%s\n\"',"b 128","^8This server is running ^1K^2MOD^3+ ^3v" .. global_kversion_var))
					et.trap_Cvar_Set( "k_etconsole_lines", "0" )
				else
					et.trap_Cvar_Set( "k_etconsole_lines", tostring(tonumber(et.trap_Cvar_Get("k_etconsole_lines")) + table.getn(plines)) )
				end
			else
				et.trap_Cvar_Set( "k_etconsole_lines", table.getn(plines) )
			end
		end
	end


	local old_plist =  tonumber( et.trap_Cvar_Get("k_plist") )
	if old_plist == nil then
		et.trap_Cvar_Set( "k_plist", tostring(os.time()) )
	else
		if countAxis() + countAllies() + countSpectators() > 0 then
			if (os.time() > old_plist+300) then -- 5 min passed since last pb_sv_plist
				if TZAC > 0 then
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "ac_sv_listplayers" )
				else
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "pb_sv_plist" )
				end
				et.trap_Cvar_Set( "k_plist", tostring(os.time()) )
--[[

				-- lets check the guid_age of all clients too
				local i
				local guid_age = tonumber(et.trap_Cvar_Get("k_min_guid_age"))
				if guid_age ~= nil then
					if guid_age ~= 0 then
						for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
							et.G_Print("guid age - runing on all clients\n")
							if global_players_table[i] ~= nil then
								if global_players_table[i]["guid_age"] ~= nil then
									et.G_Print("guid age - checking player ".. global_players_table[i]["name"] .. "\n")
									if (global_players_table[i]["guid_age"] < math.abs(guid_age)) then
										et.G_LogPrint("KMOD+ player kicked: " .. i .. " guid is too new\n")
										if guid_age > 0 then
											et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. i+1 .. " " .. 2 .. " reason: " ..  "your guid is too new, please come back in ^1" .. guid_age-global_players_table[i]["guid_age"] .. "^w days\n") 
										else
											et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. i+1 .. " " .. (math.abs(guid_age)-global_players_table[i]["guid_age"])*1440 .. " reason: " ..  "^wyour guid is too new, please come back in ^1" .. math.abs(guid_age)-global_players_table[clientNum]["i"] .. "^w days\n") 
										end
									end
								end
							end
						end
					end
				end
--]]		
			end
		end

	end

	-- banners
	if (type(global_banners_table) == "table") then -- defind (otherwise lua error)
		if ( global_banners_table["print_banner_time"] ~= nil ) then
			if ( os.time() >= tonumber(et.trap_Cvar_Get("k_banner")) ) then
				-- print the banner
				if (global_banners_table["next_banner_index"] ~= nil) then
				
					local i = global_banners_table["next_banner_index"]
					if global_banners_table[i] ~= nil then -- at least one banner is defined
						local message = global_banners_table[i]["message"]
						local position = "b " .. global_banners_table[i]["position"]
						if et.trap_Cvar_Get("gamename") == "etpub" then 
							position = global_banners_table[i]["position"]
						end

						et.trap_SendServerCommand( -1 , string.format('%s %s',position, message))
						--et.G_Print("Banner: " .. message)

						et.trap_Cvar_Set("k_banner", os.time() + global_banners_table[i]["wait"]) 
						if (global_banners_table[i+1]~= nil) then
							global_banners_table["next_banner_index"] = i+1
						else	
							global_banners_table["next_banner_index"] = 1 -- we're at the end of the array, need to reverese back to the start
						end
					end
				end
			end
		end
	end
	-- end of banners





	--et.G_Print("hello\n")

end


function mute(slot)
	local fd, len = et.trap_FS_FOpenFile('kmod+/misc/mute.dat', et.FS_APPEND )
	if len == -1 then -- file does not exist
		fd, len = et.trap_FS_FOpenFile('kmod+/misc/mute.dat', et.FS_WRITE )
		if len == -1 then
			et.G_Print("K_ERROR: unable to open/create mute.dat\n")
			return
		end
	end
	et.trap_FS_FCloseFile( fd )

	local name = et.gentity_get(slot,"pers.netname")
	local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "cl_guid" ))

	fd, len = et.trap_FS_FOpenFile( 'kmod+/misc/mute.dat', et.FS_APPEND ) 
	local mute = "\n"
	mute = mute .. "[mute]" .. "\n"
	mute = mute .. "name	= " .. name .. "\n"
	mute = mute .. "guid	= " .. guid .. "\n"
	mute = mute .. "expires	= " .. "0" .. "\n"
	mute = mute .. "muter	= " .. "public" .. "\n"
	if ( len > -1 ) then
		et.trap_FS_Write( mute, string.len(mute) ,fd )
	end
	et.trap_FS_FCloseFile( fd )
	load_mutes()
end

function unmute(client_guid) -- KMOD's internal unmute function, to unmute when the mute expires (not admin !unmute)
	--local client_guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( client ), "cl_guid" ))
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/mute.dat', et.FS_READ )
	if len == - 1 then
		-- error - mute.dat does not exist or unable to open
		return
	end
	local filestr = et.trap_FS_Read( fd, len )
	et.trap_FS_FCloseFile( fd )
	-- done reading, parse the mute list, and re-write back all mutes *exept* the specified mute
	local name,guid,expires,muter
	fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/mute.dat', et.FS_WRITE )
	for name,guid,expires,muter in string.gfind(filestr, "%s*\%[mute%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*expires%s*=%s*(%d+)%s*muter%s*=%s*([^%\n]*)%s*") do
		if (guid == client_guid) then 
			
			local slot = guidtoslot(guid)
			if slot ~= nil then
				--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref unmute " .. slot)
				et.gentity_set(slot, "sess.muted", 0)
				et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',MOD["CHAT"],"^3Unmute^w: ^1" ..name.. " ^fhas been auto-unmuted" ))
			end
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
	end
	et.trap_FS_FCloseFile( fd )
	load_mutes()


end


function MuteCheck(PlayerID) -- checks if the client supposed to be muted, used in the clientbegin function (on client connection)
	local k_mute = tonumber(et.trap_Cvar_Get("k_mute"))
	local bit = bitflag(k_mute,32)
	if bit[1] == 1 then -- persistant mute
		local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "cl_guid" ))
		for k,v in pairs(global_mute_table) do
			if guid == k then -- mute him!
				--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute " .. PlayerID .. "\n" )
				et.gentity_set(PlayerID, "sess.muted", MOD["MUTE"])
			end
		end
	end


	 -- check that all players who needs to be unmuted are really unmuted (etpro somethims doesnt unmute on map restart/change)
	if et.gentity_get(PlayerID, "sess.muted") == 1 and global_mute_table[global_players_table[PlayerID]["guid"]] == nil then
		--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref unmute " .. PlayerID)
		et.gentity_set(PlayerID, "sess.muted", 0)
	end
	
end

function mute_expire() -- checks and unmutes expired mutes
	local guid
	local expire
	for guid,v in pairs(global_mute_table) do
		if tonumber(global_mute_table[guid]["expires"]) ~= 0 then -- 0 = permanant mute, dont unmute
			--et.G_Print("check - " .. global_mute_table[guid]["expires"] .. "\n")
			if global_mute_table[guid]["expires"] - os.time() < 0 then -- mute expired!
				--et.G_Print("check -mute expired!\n")
				unmute(guid)
			end
		end
		--for k,u in pairs (v) do
		--	et.G_Print("check - " .. guid .. " | " .. k .. " | " .. u .. "\n")
		--end
	end
end

--[[
function ban_expire()
	local index,expire
	for index,expire in pairs(global_temp_ban_table) do
		if tonumber(expire) ~= 0 then -- 0 = permanant ban, dont unban
			if tonumber(expire) - os.time() < 0 then -- ban expired!
				unban(index)
			end
		end
	end
end
--]]
function ban_expire()
	for guid,v in pairs(global_ban_table) do
		--et.G_Print("check - " ..global_ban_table[guid]["expire"] .. "\n")
		if global_ban_table[guid]["expires"] ~= nil and global_ban_table[guid]["expire"] ~= 0 then
			if (tonumber(global_ban_table[guid]["expires"]) - os.time()) < 0 then -- ban expired!
				unban(guid)
			end
		end
	end
end

function killingspreereset()
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		local name = et.gentity_get(i,"pers.netname")
		if killingspree[i] >= 5 then
--			et.trap_SendConsoleCommand( et.EXEC_APPEND, ""..ks_location.." ^7" ..name.. "^1's Killing spree was ended! Sprees Disabled!\n" )
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^1Killingspree's disabled.  All sprees reset.\n" )
		end

		killingspree[i] = 0
	end
end

function dspreereset()
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		deathspree[i] = 0
	end
end

function flakreset()
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		flakmonkey[i] = 0
	end
end

function floodprotector()
	floodprotect = 1
	fpProt = tonumber(mtime)
end


function spreerecord(PlayerID, kills2)
	local fdadm,len = et.trap_FS_FOpenFile( "kmod+/sprees/spree_record.dat", et.FS_WRITE )
	local Name = et.Q_CleanStr(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "name" ))
	local date = os.date("%x %I:%M:%S%p")
	local kills = tonumber(kills2)

	SPREE = kills .. "@" .. date .. "@" .. Name

	et.trap_FS_Write( SPREE, string.len(SPREE) ,fdadm )
	et.trap_FS_FCloseFile( fdadm )
	et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^1New spree record: ^7" ..Name.. " ^7with^3 " ..kills.. "^7 kills  ^7" ..tostring(oldspree).. "\n" )
	loadspreerecord()
end

function spreerecord_reset()
--spree_restart.lua
end


function mapspreerecord(PlayerID, kills2)
	local mapname = tostring(et.trap_Cvar_Get("mapname"))
	local fdadm,len = et.trap_FS_FOpenFile( "kmod+/sprees/"..mapname..".record", et.FS_WRITE )
	local Name = et.Q_CleanStr(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "name" ))
	local date = os.date("%x %I:%M:%S%p")
	local kills = tonumber(kills2)

	SPREE = kills .. "@" .. date .. "@" .. Name

	et.trap_FS_Write( SPREE, string.len(SPREE) ,fdadm )
	et.trap_FS_FCloseFile( fdadm )
	et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^1New Map spree record: ^7" ..Name.. " ^7with^3 " ..kills.. "^7 kills on "..mapname.."  ^7" ..tostring(oldmapspree).. "\n" )
	loadmapspreerecord()
end


--[[
function setAdmin(PlayerID, level)

	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/shrubbot.dat', et.FS_READ )
	et.trap_FS_FCloseFile( fd )

	if (len == -1) then
		et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',"qsay","^fERROR: unable to open/create file" ))
		et.G_Print("k_ERROR: unable to open/create file\n")
	end

	local level = tonumber(level)
	local name = et.Q_CleanStr(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "name" ))
	local guid = global_players_table[PlayerID]["guid"]

	if ( level == nil or name == nil or guid == nil or guid == "" or guid == "UNKNOWN" ) then
		et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',"qsay","^fERROR: unable to set admin - no info" ))
		--et.G_Print("ERROR: 2\n")
		return
	end

	if (global_admin_table[guid] == nil) then -- new admin
		global_admin_table[guid] = {}
		global_admin_table[guid]["level"] = level
		global_admin_table[guid]["name"] = name
		global_players_table[PlayerID]["level"] = level
		write_shrubbot()
		return 
	end

	if (level == 0) then -- delete the admin off the file
		global_admin_table[guid] = nil
		global_players_table[PlayerID]["level"] = 0
		write_shrubbot()
		return 		
	end

	-- admin exists, and we change his admin level (and not to 0)
	-- recursion : we'll set the player to 0 (deleting his status), and then set him to the where he should be (like he's a new admin)
	setAdmin(PlayerID, 0)
	setAdmin(PlayerID, level)



end
--]]

function setAdmin(PlayerID, level)
	-- first of all, reload all the current admins (other servers might made some changes)
	

	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/shrubbot.dat', et.FS_READ )
	et.trap_FS_FCloseFile( fd )

	if (len == -1) then
		local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/shrubbot.dat', et.FS_WRITE )
		et.trap_FS_FCloseFile( fd )
		if (len == -1) then
			et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',"qsay","^fERROR: unable to open/create file (setAdmin)" ))
			et.G_Print("k_ERROR: unable to open/create file (setAdmin)\n")
			return
		end
	end

	local level = tonumber(level)
	local name = et.Q_CleanStr(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "name" ))
	local guid = global_players_table[PlayerID]["guid"]
	--et.G_Print(guid .. "\n") 
	if guid == "UNKNOWN" or guid == "" or guid == " " or guid == "NO_GUID" then
		--et.G_Print("^3Setlevel^w: player's guid is unknown!\n" )
		guid = nil
		return
	end	

	if ( level == nil or name == nil or guid == nil ) then
		et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',"qsay","^fERROR: unable to set admin - no info" ))
		--et.G_Print("ERROR: 2\n")
		return
	end

	if (global_admin_table[guid] == nil) then -- new admin
		global_admin_table[guid] = {}
		global_admin_table[guid]["name"] = name
		global_admin_table[guid]["level"] = level
		global_admin_table[guid]["flags"] = ""
		global_admin_table[guid]["greeting"] = ""
		global_players_table[PlayerID]["level"] = level
		write_shrubbot()
		
		return 
	end

	if (level == 0) then -- delete the admin off the file
		global_admin_table[guid] = nil
		global_players_table[PlayerID]["level"] = level
		write_shrubbot()
		
		return 		
	end

	-- admin exists, and we change his admin level (and not to 0)
	-- recursion : we'll set the player to 0 (deleting his status), and then set him to the where he should be (like he's a new admin)
	setAdmin(PlayerID, 0)
	setAdmin(PlayerID, level)

	

end

--[[ Micha! - removed original kmod+ function
function advPlayers(PlayerID)
	et.trap_SendServerCommand(PlayerID, string.format("print \"^3 ID ^1: ^3Player                     Rate  Snaps\n"))
	et.trap_SendServerCommand(PlayerID, string.format("print \"^1--------------------------------------------\n"))
	local pteam = { "^1X" , "^4L" , " " }
	local playercount = 0
	local spa = 24

	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		local teamnumber = tonumber(et.gentity_get(i,"sess.sessionTeam"))
		local cname = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" )
		local rate = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "rate" )
		local snaps = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "snaps" )
		local name = string.lower(et.Q_CleanStr( cname ))
		local namel = tonumber(string.len(name))-1
		local namespa = spa - namel
		local space = string.rep( " ", namespa)
		local ref = tonumber(et.gentity_get(PlayerID,"sess.referee"))
		if ref == 0 then
			ref = ""
		else
			ref = "^3REF"
		end

		if et.gentity_get(i,"pers.connected") ~= 2 then
		else
			et.trap_SendServerCommand(PlayerID, string.format('print "%s^7%2s ^1:^7 %s%s %5s  %5s %s\n"',pteam[teamnumber], i, name, space, rate, snaps, ref))
			playercount = playercount + 1
		end
	end

		et.trap_SendServerCommand(PlayerID, string.format("print \"\n^3 " ..playercount.. " ^7total players\n"))
end
--]]

-- Micha! - added new advancedplayer function
function advPlayers(PlayerID)
  
	  if PlayerID == 1022 then
	  et.G_LogPrint(string.format("\n ID |          Player          | PBid |               PBguid             |  Team  |     IP     \n-------------------------------------------------------------------------------------------------------\n"))	
	  else	
	  et.trap_SendServerCommand(PlayerID, 'print "\n ^3ID ^1\t          ^3Player          ^1\t ^5PBid ^1\t   ^5PBguid  ^1\t     ^3Team     ^1\t     ^3IP     \n^1---------------------------------------------------------------------------------\n"')
	  end
	
	local playercount = 0
	local speccount = 0
	local cntcount = 0
	--local passcount = 0
	local state = ""
	
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxClients"))-1, 1 do
	  
	  if (et.gentity_get(i,"pers.connected") ~= 0) then
	  
		local team = tonumber(et.gentity_get(i,"sess.sessionTeam"))
		local ref = tonumber(et.gentity_get(i,"sess.referee"))
		local muted = tonumber(et.gentity_get(i,'sess.muted'))
    	local spawnpnt = tonumber(et.gentity_get(i,'sess.spawnObjectiveIndex'))
    
    	local userinfo = et.trap_GetUserinfo(i)
    
			    if (userinfo ~= "") then
					
					local cname = trim(uncol(et.Info_ValueForKey(userinfo, "name" )))
					local ip = et.Info_ValueForKey(userinfo,"ip")
					if PlayerID ~= 1022 then    
			    	s, e, ip = string.find( ip, "(%d+%.%d+%.%d+%.)" )
			    	end
			    
		local privpass = et.trap_Cvar_Get("sv_privatepassword")
    	local guid = et.Info_ValueForKey(userinfo,"cl_guid")
		local pass = et.Info_ValueForKey(userinfo,"password")
       
    	cname = cut_nick(cname)
    					
						if ref == 1 then
							state = " ^3REF "
						elseif muted == 1 then
							state = "^5muted"
						elseif pass == privpass and privpass ~= nil and privpass ~= "" then
						  state = " ^3PRV "
						end
		
								if team == 1 then
						               team = "^1 axis "
						            elseif team == 2 then
						               --team = "^4allies"
						               team = "^fallies"
						            else
						               team = "^3 spec "
						               
						               if et.gentity_get(i,"pers.connected") == 2 then
						               speccount = speccount + 1
						               end
						               
						    end   

							if et.gentity_get(i,"pers.connected") < 2 then
							   if PlayerID ~= 1022 then
							   et.trap_SendServerCommand( PlayerID, string.format('print "^3 %2d ^1\t ^7%18s %5s ^1\t  ^5%2d  ^1\t ^5*%8s ^1\t ^3>>>>>>>> Connecting <<<<<<<< \n"', i, cname,state, i+1, (string.sub (guid, 25,32 ))  ))
							   else
							   et.G_LogPrint(string.format(" %2d | %18s %5s |  %2d  | %s | >>>>>>>> Connecting <<<<<<<< \n", i, cname,uncol(state), i+1,guid))
							   end
							cntcount = cntcount + 1
							
							else
							  if PlayerID ~= 1022 then
								et.trap_SendServerCommand( PlayerID, string.format('print "^3 %2d ^1\t ^7%18s %5s ^1\t  ^5%2d  ^1\t ^5*%8s ^1\t %s ^7pt: %s ^1\t ^3%12s* \n"', i, cname, state,i+1, (string.sub (guid, 25,32 )), team, spawnpnt, ip  ))
								else
								et.G_LogPrint(string.format("%2d  | %18s %5s |  %2d  | %s | %s | %s \n", i, cname, uncol(state),i+1, guid, uncol(team), ip))	
								end
								playercount = playercount + 1
								
							end
		
		 end
	 end
		 state = ""
	end
	
	local notes1 = "\n"
	local notes2 = "\n"
	local notes3 = ""
	local notes4 = ""
	local notes5 = ""
	local notes6 = ""
	local warn1 = ""
	local warn2 = ""
	local players_msg = "" .. notes1 .. "" .. notes2 .. "" .. notes3 .. "" ..notes4 .. "" .. notes5 .. "" .. notes6 .. "" .. warn1 .. "" .. warn2 .. "\n"
	
    local playing = playercount-speccount
		    if PlayerID ~= 1022 then
		    et.trap_SendServerCommand(PlayerID, string.format("print \"^1---------------------------------------------------------------------------------\n\n"))
		  	et.trap_SendServerCommand(PlayerID, string.format('print " ^3%2d     ^7Total    [ ^3%2d ^7playing  ^7\t ^3%3d  ^7spectating  ^7\t ^3%3d   ^7connecting.........  ]\n"',playercount+cntcount,playing,speccount,cntcount))
			et.trap_SendServerCommand(PlayerID, string.format('print "\n^1---------------------------------------------------------------------------------\n\n%s"',players_msg))
				else
				et.G_LogPrint(string.format("-------------------------------------------------------------------------------------------------------\n %2d     Total    [ %2d playing  | %3d  spectating  | %3d   connecting.........  ]\n",playercount+cntcount,playing,speccount,cntcount))	
				end
end

-- func from minipb by Hadro
function uncol(arg) -- this one leaves weird ascii, unlike et.Q_CleanStr
  return string.gsub(string.gsub(arg, "%^[^%^]", ""), "%^", "")
end

-- func from minipb by Hadro
function trim(arg) -- remove spaces in front and after
  return string.gsub(arg, "^%s*(.-)%s*$", "%1")
end

function cut_nick(oldname)

local max_nick = 99
local clean_oldname = trim ( uncol ( oldname ) )
local nick_len = string.len(clean_oldname)
local newname_aftercut

	if (nick_len > max_nick) then
    
	local name = string.sub (oldname, 0, max_nick )
	newname_aftercut = "" .. name .. "^7..."
	return newname_aftercut	
	else
	return oldname	
	end		

end

function et_ConsoleCommand()
	local con_cmd = string.lower(et.trap_Argv(0))
  
     if con_cmd == "players" then
       advPlayers(1022)
       return 1
	end
	
	return 0
end
-- end of advPlayers

function private_message(PlayerID,client,message)
	--et.G_Print("console PM : ".. PlayerID.. " - " ..client .. " - " ..message ..   "\n")
	-- gonna produce an error if server console uses slot number: /m 8 hello
	local clientnum = ""
	local clientnum = tonumber(client) 
	if clientnum then 
		if (clientnum >= 0) and (clientnum < 64) then 
			if et.gentity_get(clientnum,"pers.connected") ~= 2 then 
				et.trap_SendServerCommand(PlayerID, string.format("print \"There is no client associated with this slot number\n"))
				return 
			end 
			if isIgnored(clientnum, PlayerID) then 
				et.trap_SendServerCommand(PlayerID, string.format('%s \"%s\n\"',"print",et.gentity_get(clientnum,"pers.netname") .. "^f is ignoring you"))
				return
			end
			
			if PlayerID ~= 1022 then -- if not sent by server
				local sender_name = et.gentity_get(PlayerID,"pers.netname")
				et.trap_SendServerCommand(PlayerID, string.format('%s \"%s\"',MOD["CHAT"],"^fPrivate message sent to 1 recipients:^w " ..  et.gentity_get(clientnum,"pers.netname") ) )
				et.trap_SendServerCommand(PlayerID, string.format('%s \"%s\n\"',"print","^fMessage:^3 ".. message))
				et.G_ClientSound(PlayerID, pmsound)


				et.trap_SendServerCommand(clientnum, string.format('%s \"%s\"',MOD["CHAT"],"^fPrivate message from: " .. sender_name))
				et.trap_SendServerCommand(clientnum, string.format('%s \"%s\n\"',"print","^fTo 1 recipients: " .. et.gentity_get(clientnum,"pers.netname")))
			end
			et.trap_SendServerCommand(clientnum, string.format('%s \"%s\"',MOD["CHAT"],"^fMessage:^3 ".. message))
			et.G_ClientSound(clientnum, pmsound)
			return
		else    
			et.trap_SendServerCommand(PlayerID, string.format("print \"Please enter a slot number between 0 and 63\n"))
			return 
		end 
	else 
		if client then 
			if string.len(client) <= 2 then
				et.trap_SendServerCommand(PlayerID, string.format("print \"Player name requires more than 2 characters\n"))
				return
			else
         			clientnum = NameToSlot(client)
			end
		end 
		if table.getn(clientnum) <1 then
			et.trap_SendServerCommand(PlayerID, string.format("print \"Try name again or use slot number\n"))
			return 
		end 
	end 


	if (message == "" or message == nil) then 
		et.trap_SendServerCommand(PlayerID, string.format("print \"empty message\n"))
		return
	end -- empty message

	local sender_name = et.gentity_get(PlayerID,"pers.netname")
	--local rname = et.gentity_get(clientnum,"pers.netname")
	if PlayerID == 1022 then
			sender_name = "^1SERVER"
	end

	local numberOfRecipients = table.getn(clientnum)
	local recipients =""
	for i=1,numberOfRecipients,1 do
		recipients = recipients .. et.gentity_get(clientnum[i],"pers.netname") .. " "
	end

	if PlayerID ~= 1022 then

		et.trap_SendServerCommand(PlayerID, string.format('%s \"%s\"',MOD["CHAT"],"^fPrivate message sent to " .. numberOfRecipients .. " recipients:^w " .. recipients))
		et.trap_SendServerCommand(PlayerID, string.format('%s \"%s\n\"',"print","^fMessage:^3 ".. message))
	   	et.G_ClientSound(PlayerID, pmsound)
	else 

	  	et.G_Print("^fPrivate message sent to "  .. numberOfRecipients .. " recipients:^w ".. recipients .. "\n")
		et.G_Print("^fmessage:^3 ".. message)
	end
	et.G_Print("console: ".. type(table.getn(clientnum)).. "\n")
	et.G_Print("console2: ".. numberOfRecipients.. "\n")
	for i=1,numberOfRecipients,1 do
		if isIgnored(clientnum[i], PlayerID) then 
			et.trap_SendServerCommand(PlayerID, string.format('%s \"%s\n\"',"print",et.gentity_get(clientnum[i],"pers.netname") .. "^f is ignoring you"))
		else
			et.trap_SendServerCommand(clientnum[i], string.format('%s \"%s\"',MOD["CHAT"],"^fPrivate message from: " .. sender_name))
			et.trap_SendServerCommand(clientnum[i], string.format('%s \"%s\n\"',"print","^fTo " .. numberOfRecipients .. " recipients: " .. recipients))
			et.trap_SendServerCommand(clientnum[i], string.format('%s \"%s\"',MOD["CHAT"],"^fMessage:^3 ".. message))
			et.G_ClientSound(clientnum[i], pmsound)
		end
	end
end 

--[[
function curse_filter( PlayerID ) -- more like a curse-punisher --- this function only "punishes" the player
--	local k_cursemode = 1
	local k_cursemode = tonumber(et.trap_Cvar_Get("k_cursemode"))
	local name = et.gentity_get(PlayerID,"pers.netname")
	local ref = tonumber(et.gentity_get(PlayerID,"sess.referee"))

	if (k_cursemode - 32) >= 0 then -- gib the player
		-- Override kill and slap
		if (k_cursemode - 32) > 7 then
			k_cursemode = 7
		else
			k_cursemode = k_cursemode - 32
		end
		if et.gentity_get(PlayerID,"pers.connected") == 2 then
			if et.gentity_get(PlayerID,"sess.sessionTeam") >= 3 or et.gentity_get(PlayerID,"sess.sessionTeam") < 1 then
			else
				et.gentity_set(PlayerID, "health", -600)
				et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3CurseFilter: ^7"..name.." ^7has been auto gibbed for language!\n" )
			end
		end
	end
	if (k_cursemode - 16) >= 0 then -- kill the player
		-- Override slap
		if (k_cursemode - 16) > 7 then
			k_cursemode = 7
		else
			k_cursemode = k_cursemode - 16
		end
		if et.gentity_get(PlayerID,"pers.connected") == 2 then
			if et.gentity_get(PlayerID,"sess.sessionTeam") >= 3 or et.gentity_get(PlayerID,"sess.sessionTeam") < 1 then
			else
				et.gentity_get(PlayerID,"health",-1)
				et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3CurseFilter: ^7"..name.." ^7has been auto killed for language!\n" )
			end
		end
	end
	if (k_cursemode - 8) >= 0 then -- slap the player
		k_cursemode = k_cursemode - 16
		if et.gentity_get(PlayerID,"pers.connected") == 2 then
			if et.gentity_get(PlayerID,"sess.sessionTeam") >= 3 or et.gentity_get(PlayerID,"sess.sessionTeam") < 1 then
			else
				et.gentity_set(PlayerID,"health",(et.gentity_get(PlayerID,"health")-5))
				local	slapsound = "sound/player/hurt_barbwire.wav"
				soundindex = et.G_SoundIndex(slapsound)
				et.G_Sound( PlayerID,  soundindex)
				et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3CurseFilter: ^7"..name.." ^7has been auto slapped for language!\n" )
			end
		end
	end
	if (k_cursemode - 4) >= 0 then -- mute for ever
		-- Override timed mute and mute
		if (k_cursemode - 4) > 0 then
			k_cursemode = 0
		end
		if ref == 0 then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute " .. PlayerID .. "\n" )
			local mute = "-1"
			muted[PlayerID] = -1
			setMute(PlayerID, mute)
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3CurseFilter: ^7"..name.." ^7has been permanently muted for language!\n" )
		end
	end
	if (k_cursemode - 2) >= 0 then -- mute for some time
		-- Override kill and slap
		if (k_cursemode - 2) > 0 then
			k_cursemode = 0
		end
		--Mute time starts at one then doubles each time thereafter
		if ref == 0 then
			if nummutes[PlayerID] == 0 then
				nummutes[PlayerID] = 1
				muted[PlayerID] = mtime + (1*60*1000)
			else
				nummutes[PlayerID] = nummutes[PlayerID] + nummutes[PlayerID]
				muted[PlayerID] = mtime + (nummutes[PlayerID]*60*1000)
			end
			--muted[PlayerID] = mtime + 300000         --5 minutes in milliseconds
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute "..PlayerID.."\n" )
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3CurseFilter: ^7"..name.." ^7has been auto muted for ^1".. nummutes[PlayerID] .."^7 minute(s)!\n" )
		end
	end
	if k_cursemode == 1 then -- mute
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute " .. PlayerID .. "\n" )
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3CurseFilter: ^7"..name.." ^7has been auto muted!\n" )
	end



--	if k_cursemode == 1 then
--		--Mute time starts at one then doubles each time thereafter
--		if ref > 0 then
--			if nummutes[PlayerID] == 0 then
--				nummutes[PlayerID] = 1
--				muted[PlayerID] = mtime + (1*60*1000)
--			else
--				nummutes[PlayerID] = nummutes[PlayerID] + nummutes[PlayerID]
--				muted[PlayerID] = mtime + (nummutes[PlayerID]*60*1000)
--			end
--			--muted[PlayerID] = mtime + 300000         --5 minutes in milliseconds
--			et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute "..PlayerID.."\n" )
--			et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3CurseFilter: ^7"..name.." ^7has been auto muted for ^1".. nummutes[PlayerID] .."^7 minute(s)!\n" )
--		end
--	end
end
--]]










function curse_filter( PlayerID ) -- more like a curse-punisher --- this function only "punishes" the player

--[[
// 1  - mute           
// 2  - slap player    (like removes a small amount of hp from player *OVERRIDEABLE BY NEXT TWO OPTIONS)
// 4 - kill player    (kills player but is still reviveable *OVERRIDEABLE BY NEXT OPTION)
// 8 - GIB            (makes player explode into pieces )
--]]
	local k_cursemode = tonumber(et.trap_Cvar_Get("k_cursemode"))
	if k_cursemode == nil then return end -- dont do shit if wrong cvar
	local ref = tonumber(et.gentity_get(PlayerID,"sess.referee"))
	if ref == 1 then return end -- cannot mute ref's
	local flags = bitflag(k_cursemode, 32)

	local name = global_players_table[PlayerID]["name"]
	local guid = global_players_table[PlayerID]["guid"]

	et.G_Print("hello...\n")


	if global_admin_table[guid] ~= nil then
		if level_flag(global_admin_table[guid]["level"],"2") ~= nil then -- this level has the "2" flag - cannot be censored
			return
		end
	end


	if flags[1] == 1 then -- auto mute the player for g_censorMuteTime seconds
		
		local expires = 0
		local muter = "CurseFilter" -- "console"
		local mute_time = tonumber(et.trap_Cvar_Get("g_censorMuteTime"))
		if mute_time == nil then 
			mute_time = 60
		end
		expires = os.time() + mute_time
		
		fd, len = et.trap_FS_FOpenFile( 'kmod+/misc/mute.dat', et.FS_APPEND ) 
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
		load_mutes()
		--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute " .. PlayerID .. "\n" )
		et.gentity_set(PlayerID, "sess.muted", MOD["MUTE"])
		et.G_Print("^3CurseFilter^w: ^1" ..name.. " ^fhas been muted for " ..mute_time .." seconds!\n" )
		et.trap_SendServerCommand( -1 , string.format("%s \"%s\n\"",MOD["CHAT"],"^3CurseFilter^w: ^1" ..name.. " ^fhas been muted for " ..mute_time .." seconds!\n"))
	end

	if flags[8] == 1 then -- gib the player
		et.gentity_set(PlayerID, "health", -600)
	elseif flags[4] == 1 then -- burn the player 
		et.gentity_set(PlayerID, "health", -1)
	elseif flags[2] == 1 then -- slap the player
		et.gentity_set(PlayerID,"health",(et.gentity_get(PlayerID,"health")-5))
		local	slapsound = "sound/player/hurt_barbwire.wav"
		local soundindex = et.G_SoundIndex(slapsound)
		et.G_Sound( PlayerID,  soundindex)		
	end

end




















function log_chat( PlayerID, mode, text, PMID )
	local text = et.Q_CleanStr(text)
	local fdadm,len = et.trap_FS_FOpenFile( 'kmod+/misc/chat_log.log', et.FS_APPEND )
	local time = os.date("%x %I:%M:%S%p")
	local ip 
	local guid
	if mode == et.SAY_ALL then
		ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "ip" ))
		guid = global_players_table[PlayerID]["guid"]
		local name = global_players_table[PlayerID]["name"]
		local name = et.Q_CleanStr( name )
		LOG = string.format("%s %5s %32s: %s\n",time,"(ALL)",name,text)
	elseif mode == et.SAY_TEAM then
		ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "ip" ))
		guid = global_players_table[PlayerID]["guid"]
		local name = global_players_table[PlayerID]["name"]
		local name = et.Q_CleanStr( name )
		LOG = string.format("%s %5s %32s: %s\n",time,"(TEAM)",name,text)
	elseif mode == et.SAY_BUDDY then
		ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "ip" ))
		guid = global_players_table[PlayerID]["guid"]
		local name = global_players_table[PlayerID]["name"]
		local name = et.Q_CleanStr( name )
		LOG = string.format("%s %5s %32s: %s\n",time,"(FIRETEAM)",name,text)
	elseif mode == et.SAY_TEAMNL then
		ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "ip" ))
		guid = global_players_table[PlayerID]["guid"]
		local name = global_players_table[PlayerID]["name"]
		local name = et.Q_CleanStr( name )
		LOG = string.format("%s %5s %32s: %s\n",time,"(TEAM)",name,text)
	elseif mode == "VSAY_TEAM" then
		ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "ip" ))
		guid = global_players_table[PlayerID]["guid"]
		local name = global_players_table[PlayerID]["name"]
		local name = et.Q_CleanStr( name )
		LOG = "("..time..")(VSAY_TEAM) "..name.. ": " ..text.. "\n"
	elseif mode == "VSAY_BUDDY" then
		ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "ip" ))
		guid = global_players_table[PlayerID]["guid"]
		local name = global_players_table[PlayerID]["name"]
		local name = et.Q_CleanStr( name )
		LOG = "("..time..")(VSAY_BUDDY) "..name.. ": " ..text.. "\n"
	elseif mode == "VSAY_ALL" then
		ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "ip" ))
		guid = global_players_table[PlayerID]["guid"]
		local name = global_players_table[PlayerID]["name"]
		local name = et.Q_CleanStr( name )
		LOG = "("..time..")(VSAY) "..name.. ": " ..text.. "\n"
	elseif mode == "PMESSAGE" then
		local from = "SERVER"
		if PlayerID ~= 1022 then
			from = global_players_table[PlayerID]["name"]
			ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "ip" ))
			guid = global_players_table[PlayerID]["guid"]
		end
		local rec1 = part2id(PMID)
		if rec1 then
			local recipiant = et.gentity_get(rec1,"pers.netname")
			LOG = "("..time..")(PRIVATE: "..from.." -> "..recipiant.."): " ..text.. "\n"
		end
	elseif mode == "PMADMINS" then
		local from = "SERVER"
		if PlayerID ~= 1022 then
			ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "ip" ))
			guid = global_players_table[PlayerID]["guid"]
			from = global_players_table[PlayerID]["name"]
		else
			ip = "127.0.0.1"
			guid = "NONE!"
		end
		local recipiant = "ADMINS"
		LOG = "("..time..")(PRIVATE: "..from.." -> "..recipiant.."): " ..text.. "\n"
	elseif mode == "ADMIN_COMMAND" then
		local admin = "SERVER"
		if tonumber(PlayerID) ~= nil then
			admin = global_players_table[PlayerID]["name"]
			admin = et.Q_CleanStr( admin )
		end
		LOG = "("..time..")(ADMIN_COMMAND - "..PMID.." ) "..admin.." : !" ..PMID.. " "..text.. "\n"

	elseif mode == "CONN" then
		ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "ip" ))
		guid = global_players_table[PlayerID]["guid"]
		local name = global_players_table[PlayerID]["name"]
		local name = et.Q_CleanStr( name )
		LOG = "*** ("..time..") " ..name.. " HAS ENTERED THE GAME  (IP: " .. ip .. " GUID: " .. guid .. ") ***\n"
	elseif mode == "NAME_CHANGE" then
		LOG = "*** ("..time..") " ..PlayerID.. " HAS RENAMED TO "..text.." ***\n"
	elseif mode == "DISCONNECT" then
		local name = global_players_table[PlayerID]["name"]
		local name = et.Q_CleanStr( name )
		LOG = "*** ("..time..") " ..name.. " HAS DISCONNECTED ***\n"
	elseif mode == "START" then
		LOG = "\n("..time..")	***SERVER RESTART OR MAP CHANGE***\n\n"
	end

	et.trap_FS_Write( LOG, string.len(LOG) ,fdadm )
	et.trap_FS_FCloseFile( fdadm )
end

--[[
function unban(index) -- internal kmod unban function, used to auto-unban expired bans
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banlist.dat', et.FS_READ )
	if (len <= 0) then
		-- no bans defind
		return
	end
		local filestr = et.trap_FS_Read( fd, len )
		et.trap_FS_FCloseFile( fd )
		-- done reading, parse the banlist, and re-write back all bans *exept* the specified ban
		-- open new banlist
		local i = 1
		local name,guid,ip,reason,made,expires,banner
		fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banlist.dat', et.FS_WRITE )
		for name,guid,ip,reason,made,expires,banner in string.gfind(filestr, "%s*\%[ban%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*ip%s*=%s*([^%\n]*)%s*reason%s*=%s*([^%\n]*)%s*made%s*=%s*([^%\n]*)%s*expires%s*=%s*(%d+)%s*banner%s*=%s*([^%\n]*)%s*") do
			if (i == index) then -- pb_unban and announce, dont copy the ban back to the banlist
				flag = true
				et.trap_SendConsoleCommand(et.EXEC_APPEND , "PB_SV_UnBanGuid " .. guid ) 
				et.trap_SendConsoleCommand(et.EXEC_INSERT , "pb_sv_updbanfile" ) 
				et.G_Print("^3unban^w: " .. name .. "^f has been auto-unbanned\n")
				et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',MOD["CHAT"],"^3unban^w: " .. name .. "^f has been auto-unbanned"))
			else -- copy the ban back to the banlist
					
				ban = "\n"
				ban = ban .. "[ban]" .. "\n"
				ban = ban .. "name	= " .. name .. "\n"
				ban = ban .. "guid	= " .. guid .. "\n"
				ban = ban .. "ip	= " .. ip .. "\n"
				ban = ban .. "reason	= " .. reason .. "\n"
				ban = ban .. "made	= " .. made .. "\n"
				ban = ban .. "expires	= " .. expires .. "\n" 
				ban = ban .. "banner	= " .. banner .. "\n"
				et.trap_FS_Write( ban, string.len(ban) ,fd )
			end
			i=i+1
		end
	et.trap_FS_FCloseFile( fd )
	loadtempbans()
					

end
--]]

function unban(guid) -- internal kmod unban function, used to auto-unban expired bans
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banlist.dat', et.FS_READ )
	if (len <= 0) then
		-- no bans defind
		return
	end
	local filestr = et.trap_FS_Read( fd, len )
	et.trap_FS_FCloseFile( fd )
	-- done reading, parse the banlist, and re-write back all bans *exept* the specified ban
	-- open new banlist
	local i = 1
	local name,index,ip,reason,made,expires,banner
	fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banlist.dat', et.FS_WRITE )
	for name,index,ip,reason,made,expires,banner in string.gfind(filestr, "%s*\%[ban%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*ip%s*=%s*([^%\n]*)%s*reason%s*=%s*([^%\n]*)%s*made%s*=%s*([^%\n]*)%s*expires%s*=%s*(%d+)%s*banner%s*=%s*([^%\n]*)%s*") do
		if (guid == index) then -- pb_unban and announce, dont copy the ban back to the banlist
			flag = true

			global_ban_table[guid] = nil -- unbanned!

			et.trap_SendConsoleCommand(et.EXEC_APPEND , "PB_SV_UnBanGuid " .. guid ) 
			et.trap_SendConsoleCommand(et.EXEC_INSERT , "pb_sv_updbanfile" ) 
			
			et.G_Print("^3unban^w: " .. name .. "^f has been auto-unbanned\n")
			et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',MOD["CHAT"],"^3unban^w: " .. name .. "^f has been auto-unbanned"))
		else -- copy the ban back to the banlist
				
			ban = "\n"
			ban = ban .. "[ban]" .. "\n"
			ban = ban .. "name	= " .. name .. "\n"
			ban = ban .. "guid	= " .. index .. "\n"
			ban = ban .. "ip	= " .. ip .. "\n"
			ban = ban .. "reason	= " .. reason .. "\n"
			ban = ban .. "made	= " .. made .. "\n"
			ban = ban .. "expires	= " .. expires .. "\n" 
			ban = ban .. "banner	= " .. banner .. "\n"
			et.trap_FS_Write( ban, string.len(ban) ,fd )
		end
		i=i+1
	end
	et.trap_FS_FCloseFile( fd )
	--loadbans()
					

end

function isBanned(slot) -- if the guid or the ip of the server is in the global_ban_table, kick him! return false otherwise.
	if global_players_table[slot] == nil then return end
	guid = global_players_table[slot]["guid"]
	if global_ban_table[guid] ~= nil then
		et.G_LogPrint("KMOD+ Banned(GUID): " ..global_players_table[slot]['name'] .. " tried to enter the server.\n") 
		et.trap_DropClient( slot, global_ban_table[guid]["reason"] )
	end

	for index,v in pairs(global_ban_table) do
		if global_players_table[slot]["ip"] == global_ban_table[index]["ip"] then
			et.G_LogPrint("KMOD+ Banned(IP): " ..global_players_table[slot]['name'] .. " tried to enter the server.\n") 
			et.trap_DropClient( slot, global_ban_table[index]["reason"] )
		end
	end
	return false
end

function ignore(slot,victim) -- keeps our own record about ignored clients
	local ignored_clients = tonumber(victim)
	if ignored_clients == nil then -- its a player's name
		--et.G_Print("hello " .. victim .. "\n")
		ignored_clients = NameToSlot(victim)
	end
	-- either a slot or the victim doesnt exist
	if table.getn(ignored_clients) >=1 then 
		for i=1,table.getn(ignored_clients), 1 do
			global_players_table[slot]["ignoreClients"][ignored_clients[i]] = 1
		end
		write_ignores()
	end
end

function unignore(slot,victim) -- keeps our own record about ignored clients
	local ignored_clients = tonumber(victim)
	if ignored_clients == nil then -- its a player's name
		ignored_clients = NameToSlot(victim)
	end
	-- either a slot or the victim doesnt exist
	if table.getn(ignored_clients) >=1 then 
		for i=1,table.getn(ignored_clients), 1 do
			et.G_Print("ignore - we're in 1!\n")
			if global_players_table[slot]["ignoreClients"][ignored_clients[i]] ~= nil then
				et.G_Print("ignore - we're in 2!\n")
				global_players_table[slot]["ignoreClients"][ignored_clients[i]] = nil
				
			end
		end
		write_ignores()
	end
end

function balance_teams()
	local command, team
	local i = 0
	if countAxis() > countAllies() then 
	-- more axis then allies
		fullteam = "^4ALLIES"
		command = "putallies"
		fromteam = 1 -- what team you need to be to be moved (the opposite team)
		toteam = 2
		
	else -- more allies then axis
		fullteam = "^1AXIS"
		command = "putaxis" 
		fromteam = 2
		toteam = 1
	end


	-- while teams unbalanced and (we didnt move through all players yet)

	while ( (math.abs(countAllies() - countAxis() )  >  1 )  and (i < tonumber(et.trap_Cvar_Get("sv_maxclients"))) ) do
		if global_players_table[i] ~= nil then 
			if  global_players_table[i]['team'] == fromteam then
				et.G_Print("allies " ..countAllies() .. " \n") 
				et.G_Print("axis " ..countAxis() .. " \n") 
				et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref " .. command .. " ".. i .. "\n")
				et.G_LogPrint("Balance: " ..global_players_table[i]['name'] .. " has been moved to " .. fullteam ..  "\n") 
				-- we must update the player's team manual, because it does not updated anywhere else (ClientUserinfoChanged / et_Obituary run AFTER this function, not during it)
				-- or we get into infinite loop
				global_players_table[i]['team'] = toteam
				et.trap_SendServerCommand( -1 , string.format('%s \"%s\"\n',MOD["CHAT"],COMMAND_COLOR .. "Balance^w: " ..global_players_table[i]['name']..COMMAND_COLOR.. " has been moved to " .. fullteam))
				--et.ClientUserinfoChanged(i)
			end
		end
		i=i+1
	end
end
		

function killingSpree(player)
	local spree,flag = nil -- no spree found
	local message, recipients, play, flag
	if not global_spree_table then return end
	for spree,value in pairs(global_spree_table) do
		--et.G_Print("pairs: " ..global_players_table[player][KILL]["spree"] .. " = " .. spree .. " \n") 
		if global_players_table[player][KILL]["spree"] == spree then
			flag = 1 -- spree found!
			message = global_spree_table[spree]["message"]
			message = string.gsub(message,"\%[n%]",global_players_table[player]["name"])
			message = string.gsub(message,"\%[k%]",math.abs(global_players_table[player][KILL]["spree"]))
			message = string.gsub(message,"\%[v%]",global_players_table[player][KILL]["victim_name"])
			message = string.gsub(message,"\%[a%]",global_players_table[player][KILL]["killer_name"])
			if string.lower(global_spree_table[spree]["display"]) == "all" then
				recipients = -1
			else
				recipients = player
			end
			-- print the message, play the sound
			--et.G_Print("message: " ..message .. " - " .. spree .. " \n") 
			et.trap_SendServerCommand( recipients , string.format('%s \"%s"',getMessagePosition(global_spree_table[spree]["position"]), message))
			if et.trap_Cvar_Get("gamename") == "etpub" then 
				et.trap_SendConsoleCommand( et.EXEC_APPEND, string.format('%s %s',getSoundPosition(global_spree_table[spree]["play"],player), global_spree_table[spree]["sound"] ))
			else -- etpro mod
				if getSoundPosition(global_spree_table[spree]["play"],player) == "playsound" then
					et.G_globalSound(global_spree_table[spree]["sound"])
				else
					et.G_ClientSound(player, global_spree_table[spree]["sound"])
				end
			end
				
			break
		end
	end
	return flag
end

function getSpreeEnd(kills)
	local spree = 0
	if global_spree_end_table == nil then return end -- no spree defind (propobly because its 0)
	if kills > 0 then
		for key,value in pairs(global_spree_end_table) do
			if kills >= key then
				if spree < key then
					spree = key
				end
			end
		end
	else -- negative/death spree
		for key,value in pairs(global_spree_end_table) do
			if kills <= key then
				if spree > key then
					spree = key
				end
			end
		end
	end
	return spree
end

function killingSpreeEnd(victim, killer)
	local spree = getSpreeEnd(global_players_table[victim][KILL]["spree"])
	local killer_name, message_type, play_type, sound_type

	if killer ~= 1022 then
		killer_name = global_players_table[killer]["name"] 
	end
	local message_type = "message"
	local message_display = "display"
	local play_type = "play"
	local sound_type = "sound"

	local tmessage = "message"
	local tdisplay = "display"
	local tplay = "play"
	local tsound = "sound"
	if killer == 1022 then -- world kill
		killer_name = "" 
		tmessage = "wkmessage"
		tdisplay = "wkdisplay"
		tplay = "wkplay"
		tsound = "wksound"
	elseif killer == victim then -- self kill / sucide
		tmessage = "skmessage"
		tdisplay = "skdisplay"
		tplay = "skplay"
		tsound = "sksound"
	elseif tonumber(et.gentity_get(victim, "sess.sessionTeam")) == tonumber(et.gentity_get(killer, "sess.sessionTeam")) then -- team kill
		tmessage = "tkmessage"
		tdisplay = "tkdisplay"
		tplay = "tkplay"
		tsound = "tksound"
	end
	-- override the default values with any specific ones
	
	if spree == nil then return end
	if global_spree_end_table[spree] == nil then return end -- no spree defind (propobly because its 0)

	if global_spree_end_table[spree][tmessage] ~= nil and global_spree_end_table[spree][tmessage] ~= "" then
		message_type = tmessage
	end
	if global_spree_end_table[spree][tdisplay] ~= nil and global_spree_end_table[spree][tdisplay] ~= "" then
		message_display = tdisplay
	end
	if global_spree_end_table[spree][tplay] ~= nil and global_spree_end_table[spree][tplay] ~= "" then
		play_type = tplay
	end
	if global_spree_end_table[spree][tsound] ~= nil and global_spree_end_table[spree][tsound] ~= "" then
		sound_type = tsound
	end

	if spree < 0 then return end -- double check !?

	local message, recipients, play, flag
	--et.G_Print("test: " ..type(killer_name) .. " - " .. killer_name .. " \n") 
	message = global_spree_end_table[spree][message_type]
	message = string.gsub(message,"\%[n%]",global_players_table[victim]["name"])
	message = string.gsub(message,"\%[k%]",global_players_table[victim][KILL]["spree"])
	message = string.gsub(message,"\%[a%]",killer_name)
	if string.lower(global_spree_end_table[spree][message_display]) == "all" then
		recipients = -1
	else
		recipients = victim
	end
	-- print the message, play the sound
	et.trap_SendServerCommand( recipients , string.format('%s \"%s"',getMessagePosition(global_spree_end_table[spree]["position"]), message))
	if et.trap_Cvar_Get("gamename") == "etpub" then 
		et.trap_SendConsoleCommand( et.EXEC_APPEND, string.format('%s %s',getSoundPosition(global_spree_end_table[spree][play_type],victim), global_spree_end_table[spree][sound_type] ))
	else -- etpro mod
		if getSoundPosition(global_spree_end_table[spree][play_type],victim) == "playsound" then
			et.G_globalSound(global_spree_end_table[spree][sound_type])
		else
			et.G_ClientSound(victim, global_spree_end_table[spree][sound_type])
		end
	end

end

function deathSpreeEnd(victim, killer)
	local spree = getSpreeEnd(global_players_table[killer][KILL]["spree"])
	local killer_name, message_type, play_type, sound_type

	killer_name = global_players_table[killer]["name"]
	local message_type = "message"
	local message_display = "display"
	local play_type = "play"
	local sound_type = "sound"

	local tmessage = "message"
	local tdisplay = "display"
	local tplay = "play"
	local tsound = "sound"
	if killer == 1022 then -- world kill
		killer_name = "" 
		tmessage = "wkmessage"
		tdisplay = "wkdisplay"
		tplay = "wkplay"
		tsound = "wksound"
	elseif killer == victim then -- self kill / sucide
		tmessage = "skmessage"
		tdisplay = "skdisplay"
		tplay = "skplay"
		tsound = "sksound"
	elseif tonumber(et.gentity_get(victim, "sess.sessionTeam")) == tonumber(et.gentity_get(killer, "sess.sessionTeam")) then -- team kill
		tmessage = "tkmessage"
		tdisplay = "tkdisplay"
		tplay = "tkplay"
		tsound = "tksound"
	end
	-- override the default values with any specific ones
	if global_spree_end_table[spree] == nil then return end -- no spree defind (propobly because its 0)

	if global_spree_end_table[spree][tmessage] ~= nil and global_spree_end_table[spree][tmessage] ~= "" then
		message_type = tmessage
	end
	if global_spree_end_table[spree][tdisplay] ~= nil and global_spree_end_table[spree][tdisplay] ~= "" then
		message_display = tdisplay
	end
	if global_spree_end_table[spree][tplay] ~= nil and global_spree_end_table[spree][tplay] ~= "" then
		play_type = tplay
	end
	if global_spree_end_table[spree][tsound] ~= nil and global_spree_end_table[spree][tsound] ~= "" then
		sound_type = tsound
	end

	if spree > 0 then return end -- double check !?
	local message, recipients, play, flag

	message = global_spree_end_table[spree][message_type]
	message = string.gsub(message,"\%[n%]",global_players_table[killer]["name"])
	message = string.gsub(message,"\%[k%]",math.abs(global_players_table[killer][KILL]["spree"]))
	message = string.gsub(message,"\%[v%]",global_players_table[victim]["name"])
	if string.lower(global_spree_end_table[spree][message_type]) == "all" then
		recipients = -1
	else
		recipients = victim
	end
	-- print the message, play the sound
	

	et.trap_SendServerCommand( recipients , string.format('%s \"%s"',getMessagePosition(global_spree_end_table[spree]["position"]), message))
	if et.trap_Cvar_Get("gamename") == "etpub" then 
		et.trap_SendConsoleCommand( et.EXEC_APPEND, string.format('%s %s',getSoundPosition(global_spree_end_table[spree][play_type],victim), global_spree_end_table[spree][sound_type] ))
	else -- etpro mod
		if getSoundPosition(global_spree_end_table[spree][play_type],victim) == "playsound" then
			et.G_globalSound(global_spree_end_table[spree][sound_type])
		else
			et.G_ClientSound(victim, global_spree_end_table[spree][sound_type])
		end
	end	
end

function heavyWeaponRestriction(weapon)
	local cvar = 0
	local cvarmax = 0
	local command = ""
	if weapon == PANZERFAUST then
		cvar = "k_panzers"
		cvarmax = "k_maxpanzers"
		command = "team_maxPanzers"
	elseif weapon == GRENADE_LAUNCHER then
		cvar = "k_grifle"
		cvarmax = "k_maxgrifle"
		command = "team_maxRiflegrenades"
	elseif weapon == FLAMETHROWER then
		cvar = "k_flame"
		cvarmax = "k_maxflame"
		command = "team_maxFlamers"
	elseif weapon == MOBILE_MG42 then
		cvar = "k_mg42"
		cvarmax = "k_maxmg42"
		command = "team_maxMG42s"
	elseif weapon == MORTAR then
		cvar = "k_mortar"
		cvarmax = "k_maxmortar"
		command = "team_maxMortars"
	elseif weapon == LANDMINE then
		cvar = "k_mines"
		cvarmax = "k_maxmines"
		command = "team_maxMines"
	else 
		et.G_LogPrint("K_ERROR: unknown weapon in heavyWeaponRestriction" )
		return
	end
	



	local heavy = tonumber(et.trap_Cvar_Get(cvar))
	if heavy == 0 then return end -- set 0 to disable
	local heavymax = tonumber(et.trap_Cvar_Get(cvarmax))
	local available = 0
	local change = 0
	
	if (heavy ~= nil) and ( heavymax ~= nil) then
		if heavy > 0 then
			available = et.trap_Cvar_Get(command)
			change = math.floor((countAxis()+countAllies())/heavy)
			if change > heavymax then
				change = heavymax
			end
			if k_heavyWeaponRestrictions[weapon] ~= change or k_heavyWeaponRestrictions[weapon] ~= available then
				k_heavyWeaponRestrictions[weapon] = change
				et.trap_SendConsoleCommand( et.EXEC_APPEND, command .. " " ..change .."\n" )
				if tonumber(et.trap_Cvar_Get("k_debug")) > 1 then et.G_LogPrint("KMOD+ heavy weapon restriction: " .. command .. " set to " .. change .. "\n" ) end
				if change == 0 then
					-- commented-out due to too much spam
					--et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3Panzerlimit: ^7Panzers have been auto-disabled." )
				end
			end
		end
	end

end

function checkForced(client)
	local force = newTDB()
	local forced_name
	force.readFile('kmod+/misc/names.dat')
	if force ~= nil then
		forced_name = force.get(global_players_table[client]["guid"])
		if forced_name ~= nil then -- we need to force the client to this name
			userinfo = et.trap_GetUserinfo(client)
			userinfo = et.Info_SetValueForKey(userinfo, "name", forced_name)
			et.trap_SetUserinfo(client, userinfo)
			et.ClientUserinfoChanged(client)
			global_players_table[client]['forced_name'] = forced_name
		end
	end
end

function generateRandomMap(mapList, players)
	local available_maps = deepcopy(mapList)
	local nickname = ""
	local i

	-- delete all the played maps and  explicitly set maps
	local rotation = et.trap_Cvar_Get("k_rotation")
	local played = et.trap_Cvar_Get("k_playedRotation")
	local index = tonumber(et.trap_Cvar_Get("k_current_map"))
	rotation = explode(";",rotation)
	played = explode(";",played)
	if played == nil then played[1] = et.trap_Cvar_Get("k_playedRotation") end
	for i=1, table.getn(rotation), 1 do
		if i <= index then
			if not played[1] or played[1] == "" or played[1] == " " then -- no played maps set, possible on first server start.
				nickname = rotation[i]
				if tonumber(et.trap_Cvar_Get("k_debug")) > 1 then  et.G_Print("KMOD+ Rotation debug: no maps played!\n" ) end
			else
				nickname = getMapNickFromName(played[i],mapList)
			end
		else
			nickname = rotation[i]
		end

		if nickname and nickname ~= "<random>" and nickname ~= "" then -- an empty string might be if theres a ; at the end: "battery;railgun;oasis;"
			if available_maps[nickname] then -- if it wasn't already deleted.
				available_maps[nickname]["available"] = available_maps[nickname]["available"] -1
				if available_maps[nickname]["available"] <= 0 then
					available_maps[nickname] = nil
					if tonumber(et.trap_Cvar_Get("k_debug")) > 1 then  et.G_Print("KMOD+ Rotation debug: deleting " .. nickname .. " from the available maps (played/explicit)!\n" ) end
				end
			end
		end
	end

--[[
	-- first of all, lets take out all the random maps that has been played already.
	played = explode(";",et.trap_Cvar_Get("k_playedRandom"))
	for i=1, table.getn(played), 1 do
		nickname = getMapNickFromName(played[i],mapList)
		if nickname and available_maps[nickname] then
			available_maps[nickname]["available"] = available_maps[nickname]["available"] - 1
			if available_maps[nickname]["available"] <= 0 then
				available_maps[nickname] = nil -- this map cannot be played anymore, destroy it!
			end
		end
	end
--]]
	-- k_played_random
	-- now, with the maps we have left, lets see which ones fit to the number of players we have
	local available = deepcopy(available_maps)
	--local players = countAxis() + countAllies()
	for nickname,map in next,available,nil do 
		--players > min_players  and players < max_players
		if tonumber(available[nickname]["min_players"]) > players or tonumber(available[nickname]["max_players"]) < players then -- either too few or too many players for this map
			available[nickname] = nil -- delete!
			if tonumber(et.trap_Cvar_Get("k_debug")) > 1 then  et.G_Print("KMOD+ Rotation debug: deleting " .. nickname .. " from the available maps (number of players)!\n" ) end
		end
	end


	if table.getm(available) <= 0 then
		et.G_Print("KMOD+ Rotation ERROR: no random maps left for " .. players .. " players! trying to generate a map without players restrictions\n")
		if table.getm(available_maps) <= 0 then
			et.G_Print("KMOD+ Rotation ERROR: no random maps left! trying to generate a map without availablity restriction\n")
			if table.getm(mapList) <= 0 then
				et.G_Print("KMOD+ Rotation ERROR: no maps! trying to generate a map from the original 6 maps!\n")
				available = ORIGINAL_6_MAPS_ROTATION
			else
				available = mapList
			end
		else
			available = available_maps
		end
	end

	-- now, we transform our available maps into a table were each map has "available" occurrences
	local j
	local index = 1
	local maps = {}
	local rand
	for nickname, map in pairs(available) do
		for j=1,tonumber(map["available"]),1 do
			maps[index] = {}
			maps[index]["nickname"] = nickname
			maps[index]["name"] = map["name"]
			maps[index]["min"] = map["min_players"]
			maps[index]["max"] = map["max_players"]
			index = index +1
		end
	end
	rand = math.random(table.getn(maps))
	--et.G_Print("KMOD+ Rotation: random " .. rand ..  " map " .. maps[rand]["nickname"] .. "\n")
	return maps[rand]["nickname"]
	


end

function Krotation(init) -- init -> true if its init of the map, or false otherwise
	local rotation = et.trap_Cvar_Get("k_rotation")
	local flag 
	if rotation ~= "" and rotation ~= " " then
		rotation = explode(";",rotation)
		if table.getn(rotation) <= 0 then 
			rotation[1] = et.trap_Cvar_Get("k_rotation")
			if rotation[1] == "" or  rotation[1] == " " then
				et.G_Print( "KMOD+ Rotation Error: no rotation defined!\n" )
				return
			end
		end
		if not global_maps_table then
			et.G_Print( "KMOD+ Rotation Error: no maps loaded! using original 6 maps.\n" ) -- kmod+/core/utils.lua:1170: bad argument #1 to 'pairs' (table expected, got nil)
			global_maps_table = ORIGINAL_6_MAPS_ROTATION
		end
		index = tonumber(et.trap_Cvar_Get("k_current_map"))

		

		if init == true then
			et.trap_Cvar_Set("k_initime",os.time())
			flag = checkMapSet(rotation, index) -- on fresh server start, the nextmap might not be set, this will fix it.
			if index+1 > table.getn(rotation) or rotation[index+1] == "" then -- an empty string might be if theres a ; at the end: "battery;railgun;oasis;"
				index = 0
				--et.trap_Cvar_Set("k_playedRotation","") -- the rotation was reset
			end

			if index == 1 then
				et.trap_Cvar_Set("k_playedRotation",et.trap_Cvar_Get("mapname")) -- the rotation was reset
			elseif not flag then
				et.trap_Cvar_Set("k_playedRotation",et.trap_Cvar_Get("k_playedRotation") .. ";" .. et.trap_Cvar_Get("mapname")) -- add the current map to the played random maps.
			end
		end

		if et.trap_Cvar_Get("k_adminmap") ~= "true" then
			

			if init == true and not flag then -- if flag (checkMapSet) ran, then it already set the next map right.
				if rotation[index+1] == "<random>" then	
					local map = generateRandomMap(global_maps_table, tonumber(et.trap_Cvar_Get("k_endroundPlayers")))
					if tonumber(et.trap_Cvar_Get("k_debug")) > 0 then  et.G_Print("KMOD+ Rotation: " .. global_maps_table[map]["name"] .. "\n" ) end
					et.trap_Cvar_Set("k_nextmap",'set g_gametype 2; map ' .. global_maps_table[map]["name"] .. "; set nextmap vstr k_nextmap")
				else
					if not global_maps_table[rotation[index+1]] then
						et.G_Print("KMOD+ Rotation: map " ..rotation[index+1] .. " is not configured!\n" )
					end
					if tonumber(et.trap_Cvar_Get("k_debug")) > 0 then et.G_Print("KMOD+ Rotation: " .. global_maps_table[rotation[index+1]]["name"] .. "\n" ) end
					et.trap_Cvar_Set("k_nextmap",'set g_gametype 2; map '.. global_maps_table[rotation[index+1]]["name"].. "; set nextmap vstr k_nextmap")
				end
			else
				if rotation[index+1] == "<random>" then	
					nextmap = getNextMap()
					if not nextmap then 
						nextmap = checkMapSet(rotation, index)
					end
					if tonumber(et.trap_Cvar_Get("k_debug")) > 1 then  et.G_Print("KMOD+ Rotation debug: |random| next map: " ..nextmap.. " nextmap cvar: " ..et.trap_Cvar_Get("k_nextmap").. "\n" ) end
					--et.G_Print("KMOD+ Rotation: " .. global_maps_table[nextmap]["name"] .. "\n" )
					local players = countAllies() + countAxis()
					if (tonumber(et.trap_Cvar_Get("k_initime")) + 30) > os.time() then -- less then 30 seconds passed since map change
						players = tonumber(et.trap_Cvar_Get("k_endroundPlayers"))
					end
						
					if not global_maps_table[nextmap] or tonumber(global_maps_table[nextmap]["min_players"]) > players or tonumber(global_maps_table[nextmap]["max_players"]) < players then
						local map = generateRandomMap(global_maps_table,players)
						if tonumber(et.trap_Cvar_Get("k_debug")) > 0 then  et.G_Print("KMOD+ Rotation: " .. global_maps_table[map]["name"] .. "\n" ) end
						et.trap_Cvar_Set("k_nextmap",'set g_gametype 2; map ' .. global_maps_table[map]["name"] .. "; set nextmap vstr k_nextmap")
					end
				end
			end




		end

		
	end
end

function getNextMap()
	local nextmap = {}
	local prefix = " map "
	nextmap = explode(";",et.trap_Cvar_Get("k_nextmap"))
	if not nextmap[2] then return nil end
	nextmap =  string.sub(nextmap[2],string.len(prefix)+1)
	nextmap = getMapNickFromName(nextmap,global_maps_table)
	return nextmap
end

function checkMapSet(rotation, index)
	-- check that the nextmap is set, problems accur of fresh server start.

	nextmap = getNextMap()

	local flag 
	if not nextmap then 
		if tonumber(et.trap_Cvar_Get("k_debug")) > 1 then  et.G_Print("KMOD+ Rotation debug: |check| next map isnt set! nextmap cvar: " ..et.trap_Cvar_Get("k_nextmap").. "\n" ) end
		if rotation[index+1] == "<random>" then	
			local map = generateRandomMap(global_maps_table,tonumber(et.trap_Cvar_Get("k_endroundPlayers")))
			if tonumber(et.trap_Cvar_Get("k_debug")) > 0 then  et.G_Print("KMOD+ Rotation: " .. global_maps_table[map]["name"] .. "\n" ) end
			et.trap_Cvar_Set("k_nextmap",'set g_gametype 2; map ' .. global_maps_table[map]["name"] .. "; set nextmap vstr k_nextmap")
			flag = map
		else
			if not global_maps_table[rotation[index+1]] then
				et.G_Print("KMOD+ Rotation: map " ..rotation[index+1] .. " is not configured!\n" )
			end
			if tonumber(et.trap_Cvar_Get("k_debug")) > 0 then et.G_Print("KMOD+ Rotation: " .. global_maps_table[rotation[index+1]]["name"] .. "\n" ) end
			et.trap_Cvar_Set("k_nextmap",'set g_gametype 2; map ' ..  global_maps_table[rotation[index+1]]["name"].. "; set nextmap vstr k_nextmap")
			flag = rotation[index+1]
		end

		--[[
		-- add the map only if its a new map, and not the "last" map (or restart).
		local played = explode(";",et.trap_Cvar_Get("k_playedRotation"))
		if table.getn(played) <= 0 then 
			played[1] = et.trap_Cvar_Get("k_playedRotation")
		end
		local temp = played[table.getn(played)]
		--temp = getMapNickFromName(temp,global_maps_table)
		if temp ~= et.trap_Cvar_Get("mapname") then
			et.trap_Cvar_Set("k_playedRotation",et.trap_Cvar_Get("mapname"))
		end
		--]]

		-- reset the rotation on error
		et.trap_Cvar_Set("k_playedRotation",et.trap_Cvar_Get("mapname"))
		et.trap_Cvar_Set("k_current_map","1")
	end
	-- done, the nextmap should be clearly set now
	return flag
end