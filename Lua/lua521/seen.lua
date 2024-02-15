--[[

	seen.lua
	===================
	by Micha!

	Further information:
	--------------------
	This lua saves the date, guid and name to a file. 
	User can use the seen_cmd to lookup when a players was last time online.
	It wont save users without a guid.
	
	
	Contact:
	--------------------
	http://www.teammuppet.eu
	
	
	Info:
	--------------------
	Command usage: 	!seen name/id
					!lastseen
					
	Note:
	--------------------
	This version was made for lua 5.2.1

--]]---------------------------------------------------------------------------------
---------------------------------CONFIG START----------------------------------------
-------------------------------------------------------------------------------------

seenfile = 				"seen.cfg"			--file data base

commandprefix = 		"!"					--command prefix (! shrubbot like)
seen_cmd = 				"seen"				--shrubbot command name
lastseen_cmd = 			"lastseen"			--prints players last seen on server

numlastseen = 			5					--num players shown on lastseen cmd

printposition = 		"chat"				--message position

date_fmt     = 			"%x %I:%M:%S %p"	--date format

expire		= 			60*60*24*100  		--in seconds! 60*60*24*1 == 1 day (0 to disable)
											--default 100 days
									
antispamtime = 			100					--anti message spam (time in ms)

-------------------------------------------------------------------------------------
-------------------------------CONFIG END--------------------------------------------
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
----------DO NOT CHANGE THE FOLLOWING IF YOU DO NOT KNOW WHAT YOU ARE DOING----------
-------------------------------------------------------------------------------------

luaname = 				"Seen"
version = 				"0.7"
-------------global vars----------------
local seen_table = {}
local spamstop = {}

local playertable = {}
local playercount = 0
local spaces = 2
local string_out = "" -- will hold up to "numlastseen" players
----------------------------------------

function et_InitGame(levelTime, randomSeed, restart)
	et.RegisterModname(""..luaname.."   "..version.."   "..et.FindSelf())
	
	local func_start = et.trap_Milliseconds()
	et.G_Print(string.format(""..luaname..".lua: startup: %d ms\n", et.trap_Milliseconds() - func_start))

	readdatabase(seenfile)
	
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
	for cno = 0, (maxclients - 1) do
		spamstop[cno] = 0
		counter = 0
	end
	
end

function et_ClientCommand(client, command)
    local cmd = string.lower(command)
    local argv1 = string.lower(et.trap_Argv(1))
	local clientID = tonumber(et.trap_Argv(2))
	
	if string.find(argv1, "^"..commandprefix.."" .. seen_cmd .. "") then
		if clientID then
			if (clientID >= 0) and (clientID < 64) then 
				if et.gentity_get(clientID,"pers.connected") ~= 2 then 
					et.trap_SendServerCommand( client, ""..printposition.." \"^3"..luaname.."^w: ^fThere is no client associated with this slot number \"" )
					return 
				end
			else              
				et.trap_SendServerCommand( client, ""..printposition.." \"^3"..luaname.."^w: ^fPlease enter a slot number between 0 and 63 \"" )
				return 
			end
			
			local tempname = et.Info_ValueForKey( et.trap_GetUserinfo( clientID ), "name" )
			local clientID = et.Q_CleanStr( tempname )
			local clientID = string.lower(clientID)

			if spamstop[client] == 3 then
				et.trap_SendServerCommand( client, "print \"^1Spam Protection: ^wdropping say\n\"" )
				return 1
			else
				seen(client,clientID)
			end
		else
		
			cleanname = et.Q_CleanStr(et.trap_Argv(2))
			if et.trap_Argv(2) then
				s,e=string.find(cleanname, cleanname)
				if e <= 2 then
					et.trap_SendServerCommand( client, ""..printposition.." \"^3"..luaname.."^w: ^fPlayer name requires more than 2 characters \"" )
					return
				else	
					clientID = NameToSlot(cleanname) --outputs a player table
				end
			end
		
			if clientID == nil then -- matches no1
				et.trap_SendServerCommand( client, ""..printposition.." \"^3"..luaname.."^w: ^fTry name again or use slot number \"" )
				return 
			end
			
		
			local clientID = clientID[1] --strips the table
			local clientID = cleanname
			local clientID = string.lower(clientID)
			
			if spamstop[client] == 3 then
				et.trap_SendServerCommand( client, "print \"^1Spam Protection: ^wdropping say\n\"" )
				return 1
			else
				seen(client,clientID)
			end
		end
		
	end
	
	if string.find(argv1, "^"..commandprefix.."" .. lastseen_cmd .. "") then
		if spamstop[client] == 3 then
			et.trap_SendServerCommand( client, "print \"^1Spam Protection: ^wdropping say\n\"" )
			return 1
		else
			lastseen(client,seenfile)
		end
	end
	
	return 0
end

function et_ClientConnect( client, firstTime, isBot )
	if isBot ~= 1 then
	
		local tempname = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
		local cnoname = et.Q_CleanStr( tempname )
		local clientguid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( client ), "cl_guid" ))
		
		if clientguid == "" or clientguid == "UNKNOWN" or clientguid == "*UNKNOWN" or clientguid == nil then --do nothing on no guid
			return
		end
		
		local Name = cnoname
		local Guid = clientguid
		local First = seentime
		local seentime = tonumber(os.time())
		
		local fd,len = et.trap_FS_FOpenFile( seenfile, et.FS_READ )
		et.trap_FS_FCloseFile( fd )
		
		if checkseen(client,cnoname,clientguid) then
			seen_table[Guid] = {}
			seen_table[Guid]["Name"] = cnoname
			seen_table[Guid]["Guid"] = clientguid
			seen_table[Guid]["First"] = seentime
			write_seen(seenfile)
			if firstTime == 1 then --server will crash if to many players connect
				et.G_Print(""..luaname..".lua: '"..cnoname.."' updated to file '"..seenfile.."'\n")
			end
		elseif checkseen(client,cnoname,clientguid) == false then
			savefirstseen(seenfile,client)
			seen_table[Guid] = {}
			seen_table[Guid]["Name"] = cnoname
			seen_table[Guid]["Guid"] = clientguid
			seen_table[Guid]["First"] = seentime
			write_seen(seenfile)
			et.G_Print(""..luaname..".lua: '"..cnoname.."' saved to file '"..seenfile.."'\n")
		end
		
		if counter == 0 or counter < numlastseen then
			table.insert(playertable , tempname)
			counter = counter + 1
		end
	
	end
end

function et_ClientDisconnect( client )
	if isBot1(client) ~= true then
	
		local fd,len = et.trap_FS_FOpenFile( seenfile, et.FS_READ )
		et.trap_FS_FCloseFile( fd )
	
		local tempname = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
		local cnoname = et.Q_CleanStr( tempname )
		local clientguid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( client ), "cl_guid" ))
		
		if clientguid == "" or clientguid == "UNKNOWN" or clientguid == "*UNKNOWN" or clientguid == nil then --do nothing on no guid
			return
		end
		
			local Name = cnoname
			local Guid = clientguid
			local First = seentime
			local seentime = tonumber(os.time())
			seen_table[Guid] = {}
			seen_table[Guid]["Name"] = cnoname
			seen_table[Guid]["Guid"] = clientguid
			seen_table[Guid]["First"] = seentime
			write_seen(seenfile)
			et.G_Print(""..luaname..".lua: '"..cnoname.."' updated to file '"..seenfile.."' on disconnect\n")
			
		if counter == numlastseen then 
			table.remove(playertable , tonumber(tempname))
			counter = counter - 1
		end
			
	end
end

--Lua 5.2 API: et_ClientDisconnect error running lua script: [string "seen.lua"]:229: bad argument #2 to 'remove' (number expected, got string)

function et_RunFrame( levelTime )
	local maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
	for cno = 0, (maxclients - 1) do
		if spamstop[cno] == nil then return end
		if spamstop[cno] > 0 then
			counter = counter + 1
		end
		if counter > antispamtime then
			spamstop[cno] = 0
			counter = 0
		end
	end
end


function seen(client,clientID)
	local fd,len = et.trap_FS_FOpenFile( ""..seenfile.."", et.FS_READ )
	if len <= 0 then
		et.G_Print("WARNING: No Data Defined! \n")
	else
		
		local filestr = et.trap_FS_Read( fd, len )
		et.trap_FS_FCloseFile( fd )
		
		local First
		local Guid
		local Name
		
		for First, Guid, Name in string.gmatch(filestr, "(%x+)%s%-%s(%x+)%s%-%s*([^%\n]*)") do
			if string.find(string.lower(Name), clientID) then
				local Time = os.date(date_fmt,First)
				et.trap_SendServerCommand( -1, ""..printposition.." \"^3"..luaname.."^w: ^w"..Name.." ^fwas last seen on ^/"..Time.."\"" )
				spamstop[client] = spamstop[client] + 1
				return
			end
		end
	end
	return et.trap_SendServerCommand( client, ""..printposition.." \"^3"..luaname.."^w: ^w"..cleanname.." ^fis not in the data base.\"" )

end

function lastseen(client,file)
	local v
	local player_count = 0	
	for i=1, #(playertable), 1 do
		v = playertable[i]
		player_count = player_count + 1
		string_out = string_out .. "^7" .. v.."^o, "
		if ( player_count < numlastseen) then				    
			string_out = string_out .. string.rep(" ", spaces - string.len(v))
		end
		if ( player_count >= numlastseen ) then
			player_count = 0
			v = string.format(string_out)
			et.trap_SendServerCommand(client,"chat \"^3Last"..luaname.."^w: ^w"..v.."\"")
			string_out = ""
		end
	end
	if (string.len(string_out) > 0) then
		v = string.format(string_out)
		et.trap_SendServerCommand(client,"chat \"^3Last"..luaname.."^w: ^w"..v.."\"")
		string_out = ""
	end

end

function checkseen(client,clientname,clientguid) 
	local fd,len = et.trap_FS_FOpenFile( ""..seenfile.."", et.FS_READ )
	--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay ^3length: " ..len.. "^7\n" ) --debug
		
		local filestr = et.trap_FS_Read( fd, len )
		
		local Guid
		local Name
		
		for Guid, Name in string.gmatch(filestr, "%s%-%s(%x+)%s%-%s*([^%\n]*)") do
			if clientname == Name and clientguid == Guid then
				return true
			end
		end
	et.trap_FS_FCloseFile( fd )
	return false

end

function readdatabase(file)
	local i = 0
	
	local fd, len = et.trap_FS_FOpenFile(file, et.FS_READ)
    if len == -1 then
        et.G_Print(string.format(""..luaname..".lua: failed to open %s", file))
        return(0)
    end
	
	local filestr = et.trap_FS_Read( fd, len )
	et.trap_FS_FCloseFile( fd )

	local First, Guid, Name
		
	local now = tonumber(os.time())
	local exp_diff = now - expire
	for First, Guid, Name in string.gmatch(filestr, "(%x+)%s%-%s(%x+)%s%-%s*([^%\n]*)") do
		local First = tonumber(First)
		if (expire == 0) or (exp_diff < First) then
			seen_table[Guid] = {}
			seen_table[Guid]["First"] = First
			seen_table[Guid]["Guid"] = Guid
			seen_table[Guid]["Name"] = Name
			i = i + 1
		end
	end
	if i == 1 then
		et.G_LogPrint(string.format(""..luaname..".lua: loaded %d save from %s\n",i,file))
	else
		et.G_LogPrint(string.format(""..luaname..".lua: loaded %d saves from %s\n",i,file))
	end
end

function write_seen(file)
	local fd,len = et.trap_FS_FOpenFile( file, et.FS_WRITE )
	local Guid,Name,First
	for Guid,Name,First in pairs(seen_table) do
		First = seen_table[Guid]["First"]
		Guid = seen_table[Guid]["Guid"]
		Name = seen_table[Guid]["Name"]
		line = First .. " - " .. Guid .. " - " .. Name .. "\n"
		et.trap_FS_Write( line, string.len(line) ,fd )
	end
	et.trap_FS_FCloseFile( fd )
end

function savefirstseen(file,client)
	local tempname = et.Info_ValueForKey( et.trap_GetUserinfo( client ), "name" )
	local cnoname = et.Q_CleanStr( tempname )	

	local tempcl_guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( client ), "cl_guid" ))
	
	local seentime = tonumber(os.time())
	
	if cnoname == nil then return end
	if tempcl_guid == nil or tempcl_guid == "" or tempcl_guid == "NO_GUID" then tempcl_guid = "UNKNOWN" end

	info = "".. "" .. seentime .. " - " .. tempcl_guid .. " - " .. cnoname .. "" .."\n"
	
	local fd,len = et.trap_FS_FOpenFile(file, et.FS_APPEND)
	
	count = et.trap_FS_Write(info, string.len(info), fd)
	et.trap_FS_FCloseFile(fd)
end

function NameToSlot(name) -- this function is a remake of getPlayernameToId function, the difference is this function returns a table containing all players found, and not nil if found more then 1
   local i = 0
   local slot = nil
   local j = 0
   local name = string.lower(et.Q_CleanStr( name ))
   local arr = {}
   local temp = ""
   for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do 
	   if (et.gentity_get(i,"pers.netname") ~= nil) then
		
 		temp = string.lower(et.Q_CleanStr( et.gentity_get(i,"pers.netname") ))
		--et.G_Print("temp = " ..temp ..  "\n" .. "name = " .. name .. "\n\n")
		if (temp ~= "") then
 			s,e=string.find(temp, name, 1, true)
     			if s and e then 
				j = j + 1
				arr[j] =  i -- j = how many we found so far, i = slot number
				--et.G_Print("got it !\n")
			end
        	end 
	    end 
   end 
   return(arr)
   
end

function isBot1(playerID)
    if et.gentity_get(playerID,"pers.connected") == 2 and et.gentity_get(playerID,"ps.ping") == 0 then
    return true
    end
end