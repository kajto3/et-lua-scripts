--[[

-------------------------------------
---------- loading functions --------
-------------------------------------

load_mutes()
loadspreerecord() -- loads the spree record
loadmapspreerecord() -- loads the map spree records
loadlevels() -- loads the levels from the levels.dat file
loadbanners() -- loads the banners from the banners.cfg file
loadAdmins() -- loads the admins from the shrubbot.dat file
write_shrubbot() -- writes the admins to the shrubbot.dat file




--]]



function loadspree()
	local spree = readFile('kmod+/misc/spree.dat')
	if not spree then return end
	local name,kills,time,s,e

	server.spree = {}
	server.spree.record = {}
	server.spree.map = {}
	server.spree.best = {}

	-- TODO: set fields to 0 if not available

	-- all time best killing spree record
	local temp = spree.get("spree_record")
	if not temp then
		server.spree.record.name = ""
		server.spree.record.kills = 0 
		server.spree.record.time = 0
	else
		s,e,kills,time,name = string.find(temp, "(%d+)%@(%d+)%@([^%\n]*)")
		time = os.date('%d/%m/%y %H:%M',time)

		
		server.spree.record.name = name
		server.spree.record.kills = kills 
		server.spree.record.time = time
	end

	-- best killing spree achived on this map
	map = et.trap_cvarGet("mapname")
	temp = spree.get(map)
	if not temp then
		server.spree.map.name = ""
		server.spree.map.kills = 0
		server.spree.map.time = 0
	else
		s,e,kills,time,name = string.find(temp, "(%d+)%@(%d+)%@([^%\n]*)")
		time = os.date('%d/%m/%y %H:%M',time)
		
		server.spree.map.name = name
		server.spree.map.kills = kills
		server.spree.map.time = time
	end

	-- best killing spree this match
	server.spree.best.kills = 0
	server.spree.best.name = 0
	server.spree.best.time = 0
end


function writespree()
	local db = readFile('kmod+/misc/spree.dat')
	local line
	if server.spree.record.time > 0 then
		line = server.spree.record.kills.."@"..server.spree.record.time.."@"..server.spree.record.name..'\n'
		db.set("spree_record",line)
	end
	local map = et.trap_cvarGet("mapname")
	if server.spree.map.time > 0 then
		line =  server.spree.map.kills.."@"..server.spree.map.time.."@"..server.spree.map.name..'\n'
		db.set(map,line)
	end
	db.writeFile('kmod+/misc/spree.dat')
end



function load_mutes()

	global_mute_table = nil
	global_mute_table = {}
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/mute.dat', et.FS_READ )
	if len == - 1 then
		-- error - mute.dat does not exist or unable to open
		return
	end

	local filestr = et.trap_FS_Read( fd, len )
	et.trap_FS_FCloseFile( fd )

	local name,guid,expires,muter
	for name,guid,expires,muter in string.gfind(filestr, "%s*\%[mute%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*expires%s*=%s*(%d+)%s*muter%s*=%s*([^%\n]*)%s*") do
		global_mute_table[guid] = {}
		global_mute_table[guid]["expires"] = expires
		global_mute_table[guid]["muter_guid"] = muter	
		

	end
	et.trap_FS_FCloseFile( fd )
	


end



function loadspreerecord()
	local fd,len = et.trap_FS_FOpenFile( "kmod+/sprees/spree_record.dat", et.FS_READ )
	local kills = 0
	local date = ""
	local name = ""

	if len <= 0 then
		et.G_Print("WARNING: No spree record found! \n")
		oldspree = "^3[Old: ^7N/A^3]"
		oldspree2 = "^3Spree Record: ^7There is no current spree record"
		spreerecordkills = 0
	else
		local filestr = et.trap_FS_Read( fd, len )

		s,e,kills,date,name = string.find(filestr, "(%d+)%@(%d+%/%d+%/%d+%s%d+%:%d+%:%d+%a+)%@([^%\n]*)")
		
		spreerecordkills = tonumber(kills)
		oldspree = "^3[Old: ^7" ..name.. "^3 " .. kills .. "^7 @ " ..date.. "^3]"
		oldspree2 = "^3Spree Record: ^7" ..name.. "^7 with ^3" .. kills .. "^7 kills at " ..date
		intmrecord = "Current spree record: ^7" ..name.. "^7 with ^3" .. kills .. "^7 kills at " ..date

	end

	et.trap_FS_FCloseFile( fd ) 
end


function loadmapspreerecord()
	local mapname = tostring(et.trap_Cvar_Get("mapname"))
	local fd,len = et.trap_FS_FOpenFile( "kmod+/sprees/"..mapname..".record", et.FS_READ )
	local kills = 0
	local date = ""
	local name = ""

	if len <= 0 then
		et.G_Print("WARNING: No spree record found! \n")
		oldmapspree = "^3[Old: ^7N/A^3]"
		oldmapspree2 = "^3Map Spree Record: ^7There is no current spree record"
		mapspreerecordkills = 0
	else
		local filestr = et.trap_FS_Read( fd, len )

		s,e,kills,date,name = string.find(filestr, "(%d+)%@(%d+%/%d+%/%d+%s%d+%:%d+%:%d+%a+)%@([^%\n]*)")
		
		mapspreerecordkills = tonumber(kills)
		oldmapspree = "^3[Old: ^7" ..name.. "^3 " .. kills .. "^7 @ " ..date.. "^3]"
		oldmapspree2 = "^3Map Spree Record: ^7" ..name.. "^7 with ^3" .. kills .. "^7 kills at " ..date.. " on the map of " ..mapname
		intmMaprecord = "Current Map spree record: ^7" ..name.. "^7 with ^3" .. kills .. "^7 kills at " ..date

	end

	et.trap_FS_FCloseFile( fd ) 
end


function loadlevels()

--	local fd, len = et.trap_FS_FOpenFile( "kmod+/levels.dat" , et.FS_READ )
--	if (len < 0 or len == nil) then
--		et.G_Print("K_ERROR: unable to open kmod+/levels.dat file")
--		return
--	end
--	local filestr = et.trap_FS_Read( fd, len )
--	for line in string.gfind(filestr, "([^%\n]*)\n") do



--		i = level index
--	global_level_table[i][greeting] = message
--	global_level_table[i][sound] = path
--	global_level_table[i][name] = name
--	global_level_table[i]["commands"][command_index] = command
	
	local level
	local name 
	local commands_string 
	local flags
	local greeting 
	local sound 

	-- i could continue doing it this way, with a huge capture line that will capture the whole block, but it sucks
	--for level,name,commands_string,greeting,sound in string.gfind(filestr, "%s*level%s*=%s*(%d)[%s\n]*          ") do
	

	--i think it will be better to load it all into a table and parse it line by line, and not block by block.
	line = {}
	line = LoadFileToTable('kmod+/levels.dat')
	global_level_table = nil -- destroy everything previusly defind!
	global_level_table = {}
	local s,e
	local i

	local r
	local level_count = 0
	for r=1,table.getn(line),1 do
		--if (string.gfind(line[r], "([%s]*\n)") ~= nil) then -- the string is completly empty
		--	et.G_Print("checkpoing - -1\n")
			--continue (lua doesnt have 'continue' construct)

		s,e,i = string.find(line[r], "%s*level%s*=%s*(-?%d+)%s*")

		if (i ~= nil) then -- its a 'level = k' line
			level = tonumber(i)
			--et.G_Print("checkpoing - 1\n")
			if (level == nil) then
				level = string.gfind(line[r], "%s*level%s*=%s*(%d+)%s*")
				et.G_LogPrint("K_ERROR: loading levels error (levels.dat), line " .. r .." - the level must be a number!\n")
				et.G_LogPrint("level = " .. level .. "\n")
				break
			else
				level_count = level_count +1
				global_level_table[level] = {}
				global_level_table[level]["name"] = ""
				global_level_table[level]["flags"] = ""
				global_level_table[level]["greeting"] = ""
				global_level_table[level]["sound"] = ""
				commands_string = ""
				global_level_table[level]["commands"] = {}

				local command
				local k=1
				for command in string.gfind(commands_string, "([^%s]+)%s*") do
					global_level_table[level]["commands"][k] = command
					k=k+1
				end


			end
		end

		s,e,name = string.find(line[r], "%s*name%s*=%s*(.+)")
		if (name ~= nil) then -- name line
			--et.G_Print("checkpoing - 2\n")
			--name = string.sub(name,1,-1) -- for some reason theres some white-space charactar at the end, that appears as a little cube in-game
			name = chop(name)
			if (name ~= nil and level ~= nil) then -- update the level's name
				if (global_level_table[level]["name"] ~= "") then
					et.G_LogPrint("K_ERROR: loading levels error (levels.dat), line " .. r .." - the name of level " .. i .. " is already defind elsewere\n")
				else
					global_level_table[level]["name"] = name
					name = nil -- reset the name
				end
			end
		end

		s,e,commands_string = string.find(line[r], "%s*commands%s*=%s*\"(.+)\"%s*")
		if (commands_string ~= nil) then -- commands line
			--et.G_Print("checkpoing - 3\n")
			commands_string = string.sub(commands_string,1,-1)
			if (commands_string ~= nil and level ~= nil) then -- update the level's commands
				-- it is ok to have more then 1 commands = "bla bla bla" line for a single level, so it wont have a string 42594382 charactars long (and if it does, then something will eventually crash)
				--if (global_level_table[level]["commands"][1] ~= nil) then -- theres at least 1 command set already!
				--	et.G_Print("K_ERROR: loading levels error (levels.dat), line " .. r .." - commands for level " .. i .. " are already defind elsewere\n")
				--else

				local command
				-- set k to the next empty spot in the command array
				local k = table.getn( global_level_table[level]["commands"])+1
				for command in string.gfind(commands_string, "([^%s]+)%s*") do
					global_level_table[level]["commands"][k] = command
					k=k+1
				end
				commands_string = nil -- reset the commands_string
			end
		end


		s,e,flags = string.find(line[r], "%s*flags%s*=%s*(.+)")
		if (flags ~= nil) then -- flags line
			--flags = string.sub(flags,1,-1) -- for some reason theres some white-space charactar at the end, that appears as a little cube in-game
			flags = chop(flags)
			if (flags ~= nil and level ~= nil) then -- update the level's flags
				if (global_level_table[level]["flags"] ~= "") then
					et.G_LogPrint("K_ERROR: loading levels error (levels.dat), line " .. r .." - the flags of level " .. i .. " is already defind elsewere\n")
				else
					global_level_table[level]["flags"] = flags
					flags = nil -- reset the flags
				end
			end
		end


		s,e,greeting = string.find(line[r], "%s*greeting%s*=%s*(.+)")
		if (greeting ~= nil) then -- greeting line
			--et.G_Print("checkpoing - 4\n")
			--greeting = string.sub(greeting,1,-2)
			greeting = chop(greeting)
			if (greeting ~= "" and level ~= nil) then -- update the level's greeting
				if (global_level_table[level]["greeting"] ~= "") then
					et.G_LogPrint("K_ERROR: loading levels error (levels.dat), line " .. r .." - the greeting of level " .. i .. " is already defind elsewere\n")
				else
					global_level_table[level]["greeting"] = greeting
					greeting = nil -- reset the greeting
				end
			end
		end

		s,e,sound = string.find(line[r], "%s*sound%s*=%s*(.+)")
		if (sound ~= nil) then
			--et.G_Print("checkpoing - 5\n")
			--sound = string.sub(sound,1,-2)
			sound = chop(sound)
			if (sound ~= "" and level ~= nil) then -- update the level's sound
				if (global_level_table[level]["sound"] ~= "") then
					et.G_LogPrint("K_ERROR: loading levels error (levels.dat), line " .. r .." - the sound of level " .. i .. " is already defind elsewere\n")
				else
					global_level_table[level]["sound"] = sound
					--et.G_Print("level " .. level .. " sound: " .. global_level_table[level]["sound"] .. "\n")
					sound = nil -- reset the greeting
				end
			end
		end





	end

	et.G_Print("KMOD+: " .. level_count .." levels loaded!\n")
--	for k,v in pairs(global_level_table) do
--		et.G_Print("defind level " .. k .. "\n")
--	end


end



function loadbanners()

	local fd, len = et.trap_FS_FOpenFile( "kmod+/banners.cfg" , et.FS_READ )
	if (len < 0 or len == nil) then
		return
	end
	
	local i=1
	local message =""
	local wait 
	local position = ""
	global_banners_table = nil
	global_banners_table = {} -- create/delete the table
	local filestr = et.trap_FS_Read( fd, len )

	for message,wait,position in string.gfind(filestr, "%s*\%[banner%]%s*message%s*=%s*([^%\n]*)%s*wait%s*=%s*(%d+)%s*position%s*=%s*([%S]*)%s*") do

		global_banners_table[i] = {}
		global_banners_table[i]["message"] = message
		global_banners_table[i]["wait"] = tonumber(wait)
		if (tonumber(position) == nil) then -- its a string, change it
			--position = string.sub(position,1,-2)
			if et.trap_Cvar_Get("gamename") ~= "etpub" then 
				if (position == "chat") then
					position = "8"
				elseif (position == "cpm") then
					position = "16"
				elseif (position == "cp") then
					position = "32"
				elseif (position == "bp") then
					position = "128"
				else 
					et.G_LogPrint("K_ERROR: banner ".. i .. " uknown position " .. position .. "\n")
					return
				end
			end
		end
		global_banners_table[i]["position"] = position




			--et.G_Print("[banner]\n") 
			--et.G_Print("banner: " .. global_banners_table[i]["message"])
			--et.G_Print("banner - time: " .. global_banners_table[i]["wait"] .. "\n")
			--et.G_Print("banner - pos: " .. global_banners_table[i]["position"] .."\n")

		i=i+1
	end
	
	global_banners_table["print_banner_time"] = tonumber(et.trap_Cvar_Get("k_banner"))
	if global_banners_table["print_banner_time"] == nil or global_banners_table["print_banner_time"] == "" then
		et.trap_Cvar_Set("k_banner", os.time())
	end
	global_banners_table["next_banner_index"] = tonumber(et.trap_Cvar_Get("k_banneri"))
	if global_banners_table["next_banner_index"] == nil or global_banners_table["next_banner_index"] == "" then
		et.trap_Cvar_Set("k_banneri", "1")
		global_banners_table["next_banner_index"] = 1
		if (type(global_banners_table[1]) == "table") then
			global_banners_table["next_banner_index"] = 1
		else
			et.G_Print("WARNING: no banners defind!\n")
		end	
	end

	et.trap_FS_FCloseFile( fd )

end

function loadAdmins()

	if et.trap_Cvar_Get("k_shrubbot") ~= "" then -- using external shrubbot.cfg file
		
		local fd,len = et.trap_FS_FOpenFile( et.trap_Cvar_Get("k_shrubbot"), et.FS_READ )
		local guid, level, name, flags, greeting, greeting_sound
		local i
		i=0
		if len <= 0 then
			et.G_LogPrint("KMOD+ ERROR: cannot find shrubbot file\n")
		else
			local filestr = et.trap_FS_Read( fd, len )
			global_admin_table = {} -- reset
			-- get the level and the guid out of the shrubbot.cfg
			if MOD["NAME"] == ETPRO or MOD["NAME"] == NOQUARTER then -- assuming etadmin shrubbot file
				
				--et.G_LogPrint("loading admins\n")
				--et.G_LogPrint(filestr .. "\n")
				-- \n --> \r , the \r charecter preceeds the \n one, and looks like it acts the same as \n
				for name,guid,level,flags in string.gfind(filestr, "\%[admin%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%x+)%s*level%s*=%s*(-?%d+)%s*flags%s*=([^%\n]*)") do
					--et.G_LogPrint("Admin: " ..name .. " - " .. level .. " \n")
					-- upcase for exact matches  
					--et.G_LogPrint("loading admins - admin " ..name .. "\n")
					--et.G_LogPrint("loading admins - guid " ..guid .. "\n")
					--et.G_LogPrint("loading flags - " ..flags .. "\n")
					if (global_level_table[tonumber(level)] ~= nil) then
						
						-- TZAC workaround
						if string.len(guid) < 32 then
							guid = string.format('%032d',guid)
						end
						if guid ~= "UNKNOWN" then
							global_admin_table[guid] = {}
							global_admin_table[guid]["level"] = tonumber(level)
							global_admin_table[guid]["name"] = name
							i = i + 1
						end
					else
						et.G_LogPrint("KMOD+ loading admins error: level " .. level .. " is not defind!\n")
					end

				end
				et.G_LogPrint("KMOD+: " .. i .. " admins loaded!\n")
			else -- etpub one
				for name,guid,level,flags,greeting,greeting_sound in string.gfind(filestr, "%s*\%[admin%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%x+)%s*level%s*=%s*(-?%d+)%s*flags%s*=%s*([^%\n]*)%s*greeting%s*=%s*([^%\n]*)%s*greeting_sound%s*=%s*([^%\n]*)%s*") do
					-- upcase for exact matches  
					if (global_level_table[tonumber(level)] ~= nil) then
						global_admin_table[guid] = {}
						global_admin_table[guid]["level"] = tonumber(level)
						global_admin_table[guid]["name"] = name
					else
						et.G_LogPrint("KMOD+ loading admins error: level " .. level .. " is not defind!\n")
					end

				end
			end
		end
		et.trap_FS_FCloseFile( fd )

	else 
		local i = 0
		local guid 
		local level
		local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/shrubbot.dat', et.FS_READ )


		if len <= 0 then
			et.G_Print("WARNING: No Admins Defined! \n")
		else
			local filestr = et.trap_FS_Read( fd, len )
			local i = 0
			global_admin_table = {} -- reset
			-- get the level and the guid out of the shrubbot.dat
			
			for level,guid,name in string.gfind(filestr, "(-?%d+) %- (%x+) %- ([^%\n]*)\n") do
				-- upcase for exact matches
				if (global_level_table[tonumber(level)] ~= nil) then
					global_admin_table[guid] = {}
					global_admin_table[guid]["level"] = tonumber(level)
					global_admin_table[guid]["name"] = name
				else
					et.G_LogPrint("loading admins error: level " .. level .. " is not defind!\n")
				end

			end
		end
		et.trap_FS_FCloseFile( fd ) 
	end
end

--[[
function loadAdmins()
	local name,guid,level,flags,greeting
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/shrubbot.cfg', et.FS_READ )

	if len <= 0 then
		et.G_Print("WARNING: No Admins Defined! \n")
	else
		local filestr = et.trap_FS_Read( fd, len )
		local i = 0
		global_admin_table = {} -- reset
		-- get the level and the guid out of the shrubbot.fat
		
		for name,guid,level,flags,greeting in string.gfind(filestr, "%s*\%[admin%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*level%s*=%s*(-?%d+)%s*flags%s*=%s*([^%\n]*)%s*greeting%s*= ([^%\n]*)\n") do
			-- upcase for exact matches
			if (global_level_table[tonumber(level)] ~= nil) then
				global_admin_table[guid] = {}
				global_admin_table[guid]["name"] = name
				global_admin_table[guid]["level"] = tonumber(level)
				global_admin_table[guid]["flags"] = flags
				global_admin_table[guid]["greeting"] = greeting
				
			else
				et.G_LogPrint("loading admins error: level " .. level .. " is not defind!\n")
			end

		end


	end
	et.trap_FS_FCloseFile( fd ) 
end
--]]

function write_shrubbot()
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/shrubbot.dat', et.FS_WRITE )
	local guid,token
	local level,name
	for guid,token in pairs(global_admin_table) do
		if guid ~= "UNKNOWN" then
			level = global_admin_table[guid]["level"]
			name = global_admin_table[guid]["name"]
			line = level .. " - " .. guid .. " - " .. name .. "\n"
			et.trap_FS_Write( line, string.len(line) ,fd )
		end
	end
	et.trap_FS_FCloseFile( fd )
end


--[[

function write_shrubbot()
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/shrubbot.cfg', et.FS_READ )
	local filestr = et.trap_FS_Read( fd, len )
	et.trap_FS_FCloseFile( fd )
	-- i only need the admin levels from the shrubbot.cfg
	-- in order to keep the shrubbot intact, im going to split it into 3
	-- first - everything above the admins (propobly admin levels)
	-- second - admins (recovered from the KMOD)
	-- third - everything after the admins (propobly bans, warnings, commands and other crap)
	local start,stop,s,e,above_admins,admins_string,after_admins
	start,e = string.find(filestr,"\%[admin%]")

	local temp
	stop = 1
	local i = 1
	while true do 
		temp = stop
		s,stop = string.find(filestr,"%s*\%[admin%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*level%s*=%s*(-?%d+)%s*flags%s*=%s*([^%\n]*)%s*greeting%s*= ([^%\n]*)\n",stop)
		if stop == nil then
			stop = temp
			break
		end
		et.G_LogPrint("repeat: " .. i .. "\n")
		i = i+1
	end


	above_admins = string.sub(filestr,1,start-1)
	after_admins = string.sub(filestr,stop,len)

	
	local token
	local name,guid,level,flags,greeting

	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/shrubbot.cfg', et.FS_WRITE )
	et.trap_FS_Write( above_admins, string.len(above_admins) ,fd )
	--et.trap_FS_Write( "\n", string.len("\n") ,fd )

	admins_string = ""
	

	for guid,token in pairs(global_admin_table) do
		admins_string = "\n[admin]\n"
		admins_string = admins_string .. "name     = " .. global_admin_table[guid]["name"]     .. "\n"
		admins_string = admins_string .. "guid     = " .. guid				       .. "\n"
		admins_string = admins_string .. "level    = " .. global_admin_table[guid]["level"]    .. "\n" 
		admins_string = admins_string .. "flags    = " .. global_admin_table[guid]["flags"]    .. "\n"
		admins_string = admins_string .. "greeting = " .. global_admin_table[guid]["greeting"] .. "\n"

		et.trap_FS_Write( admins_string, string.len(admins_string) ,fd )
		
		--et.G_LogPrint("guid: " .. guid .. " i: " .. i .. "\n")
		--i = i + 1
	end
	et.trap_FS_Write( after_admins, string.len(after_admins) ,fd )
	et.trap_FS_FCloseFile( fd )
end
--]]

function loadtempbans()
	global_temp_ban_table = {}

	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banlist.dat', et.FS_READ )
	 -- might cause an error of the file doesnt exist, no?
	if len <= 0 then
		et.trap_FS_FCloseFile( fd )
		--et.G_Print("^3Showbans: no bans defined \n")
		return
	end

	local filestr = et.trap_FS_Read( fd, len ) 
	et.trap_FS_FCloseFile( fd )
	local i=1
	local name,guid,ip,reason,made,expires,admin
	for name,guid,ip,reason,made,expires,admin in string.gfind(filestr, "%s*\%[ban%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*ip%s*=%s*([^%\n]*)%s*reason%s*=%s*([^%\n]*)%s*made%s*=%s*([^%\n]*)%s*expires%s*=%s*(%d+)%s*banner%s*=%s*([^%\n]*)%s*") do
		if tonumber(expires) ~= 0 then
			global_temp_ban_table[i] = tonumber(expires)
		end
		i = i+1
	end
end

function loadbans()
	global_ban_table = {}

	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banlist.dat', et.FS_READ )
	 -- might cause an error of the file doesnt exist, no?
	if len <= 0 then
		et.trap_FS_FCloseFile( fd )
		et.G_Print("KMOD+ bans: no bans defined \n")
		return
	end

	local i = 0
	local filestr = et.trap_FS_Read( fd, len ) 
	et.trap_FS_FCloseFile( fd )
	local name,guid,ip,reason,made,expires,admin
	for name,guid,ip,reason,made,expires,admin in string.gfind(filestr, "%s*\%[ban%]%s*name%s*=%s*([^%\n]*)%s*guid%s*=%s*(%w+)%s*ip%s*=%s*([^%\n]*)%s*reason%s*=%s*([^%\n]*)%s*made%s*=%s*([^%\n]*)%s*expires%s*=%s*(%d+)%s*banner%s*=%s*([^%\n]*)") do
		-- TZAC workaround
		if string.len(guid) < 32 and guid ~= "UNKNOWN" then
			guid = string.format('%032d',guid)
		end
		global_ban_table[guid] = {}
		global_ban_table[guid]["name"] = name
		global_ban_table[guid]["ip"] = ip
		global_ban_table[guid]["reason"] = reason
		global_ban_table[guid]["made"] = made
		global_ban_table[guid]["expires"] = expires
		global_ban_table[guid]["admin"] = admin
		i = i + 1
		--et.G_Print("KMOD+ bans: " .. name .. "\n")
	end
	et.G_Print("KMOD+ bans: " .. i .. " bans has been loaded!\n")
end

function write_ignores()
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/ignores.dat', et.FS_WRITE )
	for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do
		if global_players_table[i] ~= nil then
			local k,v, line
			line = i .. " -"
			local flag = false -- otherwise it writes empty ignore lines
			if global_players_table[i]["ignoreClients"] then
				for k,v in pairs(global_players_table[i]["ignoreClients"]) do
					line = line .. " " .. k
					flag = true
				end
				line = line .. "\n"
				if flag == true then
					et.trap_FS_Write( line, string.len(line) ,fd )
				end
			end
		end
	end
	et.trap_FS_FCloseFile( fd )
end


function load_ignores()
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/ignores.dat', et.FS_READ )
	if len <= 0 then
		et.trap_FS_FCloseFile( fd )
		--et.G_Print("^3ignores: no ignores defined \n")
		return
	end
	local filestr = et.trap_FS_Read( fd, len ) 
	et.trap_FS_FCloseFile( fd )
	local slot, ignores_string
	
	for slot,ignores_string in string.gfind(filestr, "%s*(%d+)%s*-%s*([^%\n]*)") do
		local ignores_table = ParseString(ignores_string)
		slot = tonumber(slot)
		if global_players_table[slot] ~= nil then
			for i=1, table.getn(ignores_table), 1 do
				global_players_table[slot]["ignoreClients"][tonumber(ignores_table[i])] = 1
			end
		end
	end

end


function load_players() -- loads all players into the global_players_table table (when they load-up, they overwrite it with clientBegin)
	for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do
		if global_players_table[i] == nil then
			-- if player has name and guid then load it up!
			if et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" ) ~= "" and string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" )) ~= "" and string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" )) ~= "NO_GUID" and string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" )) ~= "UNKNOWN" then
				global_players_table[i] = {}
				global_players_table[i]["name"] = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" )
				global_players_table[i]["guid"] = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" ))
				if et.gentity_get(i,"sess.sessionTeam") == 3 then
					global_players_table[i]["team"] = 0 -- client is still connecting
				else
					global_players_table[i]["team"] = et.gentity_get(i,"sess.sessionTeam")
				end
				global_players_table[i]["ip"] = string.gsub(et.Info_ValueForKey( et.trap_GetUserinfo( i ), "ip" ), "%:%d+", "") -- gsub removed the :port from the ip
				global_players_table[i]["ignoreClients"] = {}
			end
		end
	end
end


function load_player_info_table(guid) 
	if guid == nil or guid == "" or guid == "UNKNOWN" or guid == " " or guid == "NO_GUID" then return -2 end

	global_players_info_table[guid] = newTDB()
	if global_players_info_table[guid].readFile('kmod+/misc/player_tracker/data/' ..guid ..'.dat') == nil then
		--et.G_Print("no data!!!\n")
		--return -1
	end
	global_players_info_table[guid]["alias"] = {}
	global_players_info_table[guid]["alias"] = LoadFileToTable('kmod+/misc/player_tracker/alias/' .. guid ..'.dat')
	--et.G_Print("alias table loaded!\n")


--[[
	global_players_info_table[guid]["alias"] = {}
	global_players_info_table[guid]["ip"] = {}
	global_players_info_table[guid]["warnings"] = {}

	local fd, len = et.trap_FS_FOpenFile('kmod+/misc/player_tracker/alias/' ..guid ..'.dat', et.FS_READ )
	if len == -1 then -- no info for that player
		et.trap_FS_FCloseFile( fd )
		return -1 
	end 
	et.trap_FS_FCloseFile( fd )

	global_players_info_table[guid]["alias"] = LoadFileToTable('kmod+/misc/player_tracker/alias/' .. guid ..'.dat')



	fd, len = et.trap_FS_FOpenFile('kmod+/misc/player_tracker/data/' ..guid ..'.dat', et.FS_READ )
	if len == -1 then -- no info for that player
		et.trap_FS_FCloseFile( fd )
		return -1 
	end 
	et.trap_FS_FCloseFile( fd )
	local r=1
	local i=1
	while (r <= table.getn(line)) do
		-- we're in ip's now
		s,e = string.find(line[r], "%s*\%[warnings%]%s*")
		i=1
		r = r+1
		while not(s and e) and r <= table.getn(line) do 
			s,e, global_players_info_table[guid]["ip"][i] = string.find(line[r], "%s*([^%\n]*)%s*")
			i=i+1
			r=r+1
			if r > table.getn(line) then return end -- end of file = no warning line
			s,e = string.find(line[r], "%s*\%[warnings%]%s*")
		end
		s,e = string.find(line[r], "%s*\%[warnings%]%s*")
		r = r+1
		while r <= table.getn(line) do	
			s,e, global_players_info_table[guid]["warnings"] = string.find(line[r], "%s*([^%\n]*)%s*")
			r = r+1
		end
	end
--]]
end

function write_player_info_table(guid)
	if guid == nil or guid == "" or guid == " " then return end
	-- dont write empty files 
	if global_players_info_table[guid] == nil then return end
	--if global_players_info_table[guid]["alias"] == nil or global_players_info_table[guid]["ip"] == nil then return end
	if global_players_info_table[guid]["alias"] == nil then return end
	if global_players_info_table[guid]["alias"][1] == nil or global_players_info_table[guid]["alias"][1] == "" or global_players_info_table[guid]["alias"][1] == " " then return end
	--if global_players_info_table[guid]["ip"][1] == nil or global_players_info_table[guid]["ip"][1] == "" or global_players_info_table[guid]["ip"][1] == " " then return end


	local fd, len = et.trap_FS_FOpenFile('kmod+/misc/player_tracker/alias/' .. guid ..'.dat', et.FS_WRITE )	
	if len == -1 then
		et.G_LogPrint("K_ERROR: unable to open/create player's info file for guid " .. guid .. "\n")
		et.trap_FS_FCloseFile( fd )
		return
	end
	et.trap_FS_FCloseFile( fd )
	local i
	local text = ""
	for i=1, table.getn(global_players_info_table[guid]["alias"]),1 do
		text = text .. global_players_info_table[guid]["alias"][i] .. "\n"
		--et.G_Print("alias " .. i .. " " .. global_players_info_table[guid]["alias"][i] .. "\n")
	end
	local fd, len = et.trap_FS_FOpenFile('kmod+/misc/player_tracker/alias/' .. guid ..'.dat', et.FS_WRITE )	
	et.trap_FS_Write( text, string.len(text) ,fd )
	et.trap_FS_FCloseFile( fd )

	

	global_players_info_table[guid].writeFile('kmod+/misc/player_tracker/data/' .. guid ..'.dat')
--[[
	local fd, len = et.trap_FS_FOpenFile('kmod+/misc/player_tracker/data/' .. guid ..'.dat', et.FS_WRITE )	
	if len == -1 then
		et.G_LogPrint("K_ERROR: unable to open/create player's info file for guid " .. guid .. "\n")
		et.trap_FS_FCloseFile( fd )
		return
	end

	text = "[ip]\n"
	for i=1, table.getn(global_players_info_table[guid]["ip"]),1 do
		text = text .. global_players_info_table[guid]["ip"][i] .. "\n"
		--et.G_Print("ip " .. i .. " " .. global_players_info_table[guid]["ip"][i] .. "\n")
	end
	if global_players_info_table[guid]["warning"] ~= nil then
		text = text .. "[warning]\n"
		for i=1, table.getn(global_players_info_table[guid]["warning"]),1 do
			text = text .. global_players_info_table[guid]["warning"][i] .. "\n"
		end
	end
		
	local fd, len = et.trap_FS_FOpenFile('kmod+/misc/player_tracker/data/' .. guid ..'.dat', et.FS_WRITE )	
	et.trap_FS_Write( text, string.len(text) ,fd )
	et.trap_FS_FCloseFile( fd )
--]]
end

function load_banmask()
	local i = 0
	local ip1,ip2
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banmask.dat', et.FS_READ )


	if len <= 0 then
		--et.G_Print("WARNING: No banmasks Defined! \n")
	else
		local filestr = et.trap_FS_Read( fd, len )
		local i = 0
		global_banmask_table = {} -- reset
		
		for ip1,ip2,name in string.gfind(filestr, "(%d+).(%d+) %- ([^%\n]*)\n") do
			global_banmask_table[ip1 .. "." .. ip2] = name
		end


	end
	et.trap_FS_FCloseFile( fd ) 
end
