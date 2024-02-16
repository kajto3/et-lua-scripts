--[[
-------------------------------------
---------- utility functions --------
-------------------------------------


ParseString(string)
getPlayernameToId(name)
part2id(client) 
nameforID(name) 
randomClientFinder()
name2IDPM(name) 
crop_text(text,len)
DeleteFileLine(filename, del)
LoadFileToTable(filename)
chop(text)
level_flag(level, flag)
levelcommand(level,command)
AdminUserLevel(PlayerID)
disablewars()
check_restriction()
guidtoslot(guid) -- guid to slot (slot from guid)
explode(delimiter,string)
deepcopy(object)
getMapNickFromName(name,mapList)
table.getm(t) -- returns the number of elemts in table regardless of numrical keys


-- ParseString(string)
	recives: string
	returns: table where table[i] = word 
	explodes the string into single words

-- getPlayernameToId(name)

	recives: player name
	returns: player's slot 
	if name maches more then 1 player, retuns nil

-- part2id(client) 

-- nameforID(name) 
	not sure (propobly returns the player's slot)

-- randomClientFinder()

-- name2IDPM(name) 

-- crop_text(text,len)
	recives: string and a the desired string's length
	returns: it crops the text from the end, until the string fits the length 
	note: this function ignores color-codes - so that color-codes does not effect the strings length (color codes are omitted fromm the string length)


-- DeleteFileLine(filename, del)
	recives: filename, the index of the line to delete
	returns: deletes the line from the file

-- LoadFileToTable(filename)
	recives: file name
	returns: table containing the file lines, where table[i] = line

-- chop(text) -- chops spaces from the end of the string

-- level_flag(level, flag) -- returns 1 if the current level has this flag, or nil otherwise

-- levelcommand(level,command) -- returns ture if this level has the command, or false if it doesnt (if this level is authorized to use this command)

-- AdminUserLevel(slot) -- returns the slot's admin-level

-- disablewars() -- runs the !<something>war off command
-- to turn off any !war commands that are on

-- check_restriction()
-- checks that all the classes/weapons restrictions are forced
-- in ETpro, theres 1 panzer available, and yet 3 players grabbed a panzer (i.e leftover from !panzerwar) they
-- can hold to it. this function forces them to take a thomson.


--]]






function ParseString(inputString)
	-- Rany
	inputString = inputString or ""
	local i = 1
	local t = {}
	for w in string.gfind(inputString, "([%S]+)%s*") do
		t[i]=w
		i=i+1
	end
	return t
 end

function ParseAdmins(inputString)
	-- Rany
	inputString = inputString or ""
	local i = 1
	local t = {}
	for w in string.gfind(inputString, "(%d+)") do
		t[i]=w
		i=i+1
	end
	return t
 end







function getPlayernameToId(name) 
	local i = 0
	local slot = nil
	local matchcount = 0
	local name = string.lower(et.Q_CleanStr( name ))
	local temp
	for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do 
		if global_players_table[i] ~= nil then
 			temp = string.lower(et.Q_CleanStr( global_players_table[i]["name"] ))
 			s,e=string.find(temp, name)
     				if s and e then 
					matchcount = matchcount + 1
						slot = i
        			end 
		end 
	end 
	if matchcount >= 2 then
		return nil
	else
		return slot
	end
end






function part2id(client) 
	local clientnum = tonumber(client) 
	if clientnum then 
		if (clientnum >= 0) and (clientnum < 64) then 
      			if et.gentity_get(clientnum,"pers.connected") ~= 2 then 
      				return nil
         		end 	
		return clientnum
      		end 
	else 
		-- Rany B
		client = client or ""
		-- Rany E
		local client = string.lower(et.Q_CleanStr( client ))
      		if client then 
			s,e=string.find(client, client)
				if e <= 2 then
		   			return nil
				else
			         clientnum = nameforID(client)
				end
      		end 
         		if not clientnum then 
	         		return nil
         		end 
   	end 

	return clientnum

end 


function nameforID(name) 
   local i = 0
   local slot = nil
   local matchcount = 0
   local cleanname = string.lower(et.Q_CleanStr( name ))
   local playerp = ""
   for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do 
	if PlayerName[i] then
 	   playerp = string.lower(et.Q_CleanStr( PlayerName[i] ))
 	   s,e=string.find(playerp, cleanname)
     		 if s and e then 
			matchcount = matchcount + 1
				slot = i
        	 end 
      end 
   end 
   if matchcount >= 2 then
	return nil
   else
	return slot
   end
end


function randomClientFinder()
	randomClient = {}
	local m = 0
	
	for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do
		if et.gentity_get(i,"pers.connected") == 2 then
			randomClient[m] = i
			m = m + 1
		end
	end

	local dv1 = m - 1 

	local dv = math.random(0, dv1)
	local dv2 = randomClient[dv]

	return dv2
end



function name2IDPM(name) 
   local i = 0
   local slot = nil
   local matchcount = 0
   local cleanname = string.lower(et.Q_CleanStr( name ))
   local playerp = ""
   for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do 
	if PlayerName[i] then
 	   playerp = string.lower(et.Q_CleanStr( PlayerName[i] ))
 	   s,e=string.find(playerp, cleanname)
     		 if s and e then 
			matchcount = matchcount + 1
				slot = i
        	 end 
      end 
   end 
   if matchcount >= 2 then
	return nil
   else
	return slot
   end
end


function NameToSlot(name) -- this function is a remake of getPlayernameToId function, the diffrance is this function returns a table containing all players found, and not nil if found more then 1
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


function crop_text(text,len) -- crops colored string untill it fits the len (without counting the colors as charactars)
	while string.len(et.Q_CleanStr(text)) > len do
		text = string.sub(text,1,string.len(text)-1)
	end
	return (text)
end


function DeleteFileLine(filename, del) -- deletes a certain line from file
	
	local fd, len = et.trap_FS_FOpenFile( filename , et.FS_READ )
	if (len < 0 or tonumber(del) == nil) then
		et.G_Print("K_ERROR: DeleteFileLine function error")
		return
	end
	
	local i=1
	local file = {}
	local line = ""
	local filestr = et.trap_FS_Read( fd, len )
	for line in string.gfind(filestr, "([^%\n]*)\n") do
		file[i] = line
		i=i+1
	end
	et.trap_FS_FCloseFile( fd )
	-- we got the file and broke it into lines, now we just need to delete the line and flush everything back
	table.remove (file , del)
	fd, len = et.trap_FS_FOpenFile( filename , et.FS_WRITE )
	if (len < 0 ) then
		et.G_Print("K_ERROR: DeleteFileLine - unable to flush")
		return
	else
		i=1
		while file[i] ~= nil do
			file[i] = file[i] .. "\n"
			et.trap_FS_Write(file[i],string.len(file[i]), fd)
			i=i+1
		end
		et.trap_FS_FCloseFile( fd )
	end		
end



function LoadFileToTable(filename) -- loads a file into a table where table[i] = line
	
	local fd, len = et.trap_FS_FOpenFile( filename , et.FS_READ )
	if (len < 0 or len == nil) then
		--et.G_Print("K_ERROR: LoadFileToTable function error! unable to open " .. filename .."\n")
		return
	end
	
	local i=1
	local file = {}
	local line = ""
	local filestr = et.trap_FS_Read( fd, len )
	for line in string.gfind(filestr, "([^%\n]*)\n") do
		file[i] = line
		i=i+1
	end
	et.trap_FS_FCloseFile( fd )
	return (file)	
end

function WriteTableToFile(filename,t) -- writes a table into a file, each element on a line, reutrns 1 on seccess, nil otherwise
	local fd, len = et.trap_FS_FOpenFile( filename , et.FS_WRITE )
	if (len < 0 or len == nil) then
		et.G_Print("K_ERROR: WriteTableToFile function error! unable to open " .. filename .."\n")
		return
	end
	
	local i=1
	local filestr = ""
	for i=1,table.getn(t),1 do
		filestr = filestr .. t[i] .. '\n'
	end
	et.trap_FS_Write(filestr,string.len(filestr), fd)
	--et.G_Print("K_ERROR: WriteTableToFile wrote: " .. filestr .."\n")
	et.trap_FS_FCloseFile( fd )
	return 1
end	


function chop(text) -- chops spaces from the end of the string
	local flag = true
	while flag do
		local s,e,c = string.find(string.sub(text,-1),"(%s)")
		if c then
			text = string.sub(text,1,-2)
		else
			flag = false
		end
	end
	return (text)
end


function level_flag(level, flag) -- returns 1 if the current level has this flag, or nil otherwise
-- if you have a problem with this function, make sure the level you submit is a number, and not a string!

	--et.G_Print("checking flag: " .. flag .. " level: " .. level .. "\n") 
	if global_level_table[level] == nil then
		et.G_Print("K_ERROR: function level_flag - undefind level " .. level .. "\n")
		return
	end
	local temp_flag
	if global_level_table[level]["flags"] ~= nil then
		for temp_flag in string.gfind(global_level_table[level]["flags"], "(.)") do
			if temp_flag == flag then
				return 1
			end
		end
	end
	return 
end
	

function levelcommand(level,command) -- returns ture if this level has the command, or false if it doesnt (if this level is authorized to use this command)
	local i
	for i=1, table.getn(global_level_table[level]["commands"]), 1 do
		if (string.lower(command) == string.lower(global_level_table[level]["commands"][i])) then
			return true
		end
	end
	return false
end


function AdminUserLevel(PlayerID)
	local guid = ""
	if(PlayerID~=-1) then
		guid = global_players_table[PlayerID]["guid"]
	else
		guid=-1
	end

	if (global_admin_table[guid] ~= nil) then
		return (global_admin_table[guid]["level"])
	end

	return 0
end

function disablewars() -- runs a "disable" command, to disable any !war command
	if global_weapons_table ~= nil then
		global_weapons_table["disable"]["slot"] = "console"
		global_weapons_table["disable"]["say"] = "b 8"
		global_weapons_table["disable"]["broadcast"] = -1
		runcommand(global_weapons_table["command"], global_weapons_table["disable"])
	end
end

function check_restriction() -- checks the heavy weapons/classes restrictions, and forces players accordingly
	local i

	local max_panzers = tonumber(et.trap_Cvar_Get("team_maxpanzers"))
	local axis_panzers = 0
	local allies_panzers = 0
	local max_mortars = tonumber(et.trap_Cvar_Get("team_maxmortars"))
	local axis_mortars = 0
	local allies_mortars = 0
	local max_mg42 = tonumber(et.trap_Cvar_Get("team_maxmg42s"))
	local axis_mg42 = 0
	local allies_mg42 = 0
	local max_flamers = tonumber(et.trap_Cvar_Get("team_maxflamers"))
	local axis_flamers = 0
	local allies_flamers = 0
	local max_riflenades = tonumber(et.trap_Cvar_Get("team_maxriflegrenades"))
	local axis_riflenades = 0
	local allies_riflenades = 0


	local max_medics = tonumber(et.trap_Cvar_Get("team_maxMedics"))
	local axis_medics = 0
	local allies_medics = 0
	local max_engineers = tonumber(et.trap_Cvar_Get("team_maxEngineers"))
	local axis_engineers = 0
	local allies_engineers = 0
	local max_fields = tonumber(et.trap_Cvar_Get("team_maxFieldops"))
	local axis_fields = 0
	local allies_fields = 0
	local max_coverts = tonumber(et.trap_Cvar_Get("team_maxCovertops"))
	local axis_coverts = 0
	local allies_coverts = 0


	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
	-- weapon restrictions
		if max_panzers > -1 then
			if tonumber(et.gentity_get(i,"sess.latchPlayerWeapon")) == 5 then -- panzer
				if global_players_table[i]["team"] == 1 then -- axis 
					axis_panzers = axis_panzers + 1
					if axis_panzers > max_panzers then
						et.gentity_set(i,"sess.latchPlayerWeapon",8) -- tommy gun
					end
				elseif global_players_table[i]["team"] == 2 then -- allies 
					allies_panzers = allies_panzers + 1
					if allies_panzers > max_panzers then
						et.gentity_set(i,"sess.latchPlayerWeapon",8) -- tommy gun
					end
				end
			end
		end

		if max_mortars > -1 then
			if tonumber(et.gentity_get(i,"sess.latchPlayerWeapon")) == 5 then -- panzer
				if global_players_table[i]["team"] == 1 then -- axis 
					axis_mortars = axis_mortars + 1
					if axis_mortars > max_mortars then
						et.gentity_set(i,"sess.latchPlayerWeapon",8) -- tommy gun
					end
				elseif global_players_table[i]["team"] == 2 then -- allies 
					allies_mortars = allies_mortars + 1
					if allies_mortars > max_mortars then
						et.gentity_set(i,"sess.latchPlayerWeapon",8) -- tommy gun
					end
				end
			end
		end

		if max_mg42 > -1 then
			if tonumber(et.gentity_get(i,"sess.latchPlayerWeapon")) == 5 then -- panzer
				if global_players_table[i]["team"] == 1 then -- axis 
					axis_mg42 = axis_mg42 + 1
					if axis_mg42 > max_mg42 then
						et.gentity_set(i,"sess.latchPlayerWeapon",8) -- tommy gun
					end
				elseif global_players_table[i]["team"] == 2 then -- allies 
					allies_mg42 = allies_mg42 + 1
					if allies_mg42 > max_mg42 then
						et.gentity_set(i,"sess.latchPlayerWeapon",8) -- tommy gun
					end
				end
			end
		end

		if max_flamers > -1 then
			if tonumber(et.gentity_get(i,"sess.latchPlayerWeapon")) == 5 then -- panzer
				if global_players_table[i]["team"] == 1 then -- axis 
					axis_flamers = axis_flamers + 1
					if axis_flamers > max_flamers then
						et.gentity_set(i,"sess.latchPlayerWeapon",8) -- tommy gun
					end
				elseif global_players_table[i]["team"] == 2 then -- allies 
					allies_flamers = allies_flamers + 1
					if allies_flamers > max_flamers then
						et.gentity_set(i,"sess.latchPlayerWeapon",8) -- tommy gun
					end
				end
			end
		end

		if max_riflenades > -1 then
			if tonumber(et.gentity_get(i,"sess.latchPlayerWeapon")) == 5 then -- panzer
				if global_players_table[i]["team"] == 1 then -- axis 
					axis_riflenades = axis_riflenades + 1
					if axis_riflenades > max_riflenades then
						et.gentity_set(i,"sess.latchPlayerWeapon",8) -- tommy gun
					end
				elseif global_players_table[i]["team"] == 2 then -- allies 
					allies_riflenades = allies_riflenades + 1
					if allies_riflenades > max_riflenades then
						et.gentity_set(i,"sess.latchPlayerWeapon",8) -- tommy gun
					end
				end
			end
		end


		-- class restrictions
		if max_medics > -1 then
			if tonumber(et.gentity_get(i,"sess.latchPlayerType")) == 1 then -- medic
				if global_players_table[i]["team"] == 1 then -- axis 
					axis_medics = axis_medics + 1
					if axis_medics > max_medics then
						et.gentity_set(i,"sess.latchPlayerType",0) -- set him as a soldier
					end
				elseif global_players_table[i]["team"] == 2 then -- allies
					allies_medics = allies_medics + 1
					if allies_medics > max_medics then
						et.gentity_set(i,"sess.latchPlayerType",0) -- set him as a soldier
					end
				end
				
			end
		end
		if max_engineers > -1 then
			if tonumber(et.gentity_get(i,"sess.latchPlayerType")) == 2 then -- eng
				if global_players_table[i]["team"] == 1 then -- axis 
					axis_engineers = axis_engineers + 1
					if axis_engineers > max_engineers then
						et.gentity_set(i,"sess.latchPlayerType",0) -- set him as a soldier
					end
				elseif global_players_table[i]["team"] == 2 then -- allies
					allies_engineers = allies_engineers + 1
					if allies_engineers > max_engineers then
						et.gentity_set(i,"sess.latchPlayerType",0) -- set him as a soldier
					end
				end
				
			end
		end
		if max_fields > -1 then
			if tonumber(et.gentity_get(i,"sess.latchPlayerType")) == 3 then -- fieldop
				if global_players_table[i]["team"] == 1 then -- axis 
					axis_fields = axis_fields + 1
					if axis_fields > max_fields then
						et.gentity_set(i,"sess.latchPlayerType",0) -- set him as a soldier
					end
				elseif global_players_table[i]["team"] == 2 then -- allies
					allies_fields = allies_fields + 1
					if allies_fields > max_fields then
						et.gentity_set(i,"sess.latchPlayerType",0) -- set him as a soldier
					end
				end
				
			end
		end	
		if max_coverts > -1 then
			if tonumber(et.gentity_get(i,"sess.latchPlayerType")) == 4 then -- cov
				if global_players_table[i]["team"] == 1 then -- axis 
					axis_coverts = axis_coverts + 1
					if axis_coverts > max_coverts then
						et.gentity_set(i,"sess.latchPlayerType",0) -- set him as a soldier
					end
				elseif global_players_table[i]["team"] == 2 then -- allies
					allies_coverts = allies_coverts + 1
					if allies_coverts > max_coverts then
						et.gentity_set(i,"sess.latchPlayerType",0) -- set him as a soldier
					end
				end
				
			end
		end
	end
end

function bitflag(number,top) -- function recives the cvar value, and the top bitflag number (i.e 1,2,4,8,16,32 -> top bitflag is 32)
			     -- the function returns a table where table[flag] = 1 if the flag is "on", or nil if its off
	if number == nil or top == nil then 
		et.G_LogPrint("k_error: bitflag error! arg #1 or #2 is nil!\n")
		return
	end

	local flags = {}
	local temp_top = 1
	-- initialize all flag values to 0
	flags[temp_top] = 0
	-- check that top is a multiple of 2 (2^x)
	while temp_top < top do
		temp_top = temp_top * 2
		flags[temp_top] = 0
	end
	if temp_top ~= top then
		et.G_Print("k_error: bitflag error! arg #2 (top) must be a multiple of 2 (2^x)\n")
		return
	end
		
	
	while number >0 do
		if math.ceil(top) ~= top then -- checking the bitflag (bitflag should NOT go float)
			et.G_Print("k_error: bitflag error!\n") -- if you get this error, check that the number isnt bigger then the top you entered.
			return
		end
		if top > number then
			top = top/2
		else
			number = number - top
			flags[top] = 1
			top = top/2
		end

		--et.G_Print("num = " .. number .. " top = " .. top .. "\n")
	end
	return flags
end

function guidtoslot(guid) -- guid to slot
	local slot,v
	for slot,v in pairs(global_players_table) do
		if global_players_table[slot]["guid"] == guid then
			return slot
		end
	end
	return 
end


function ismuteron(guid) -- is muter on? if the muter-admin is on the server, resturs his slot, if not, returns -1 (function recives the guid of the admin, its kinda like guid-to-slot func)
	local slot,v
	for slot,v in pairs(global_players_table) do
		if global_players_table[slot]["guid"] == guid then
			
			return slot
		end
	end
	return -1
end


function findVMslot( name )
	local admin_vm = -1
	local mod = ""
	local sig = ""
	local i = 1
	while sig ~= nil do -- not all loaded mods got names (if the mod wasnt registered, it has no name), but all mods got signatures
		mod, sig = et.FindMod(i)
		if mod ~= nil then
			if string.find(mod, name) == 1 then
				return i
			end
		end
		i = i + 1
	end
	return nil
end


function readyCommand(params, predifind) -- params = command params.   Function returns -1 if didnt pass checks, or slot number if all is good
-- predifind["reqired_params"] = 2   number of required parameters for the command
-- predifind["msg_syntax"] = "usage: !command bla1 bla2 bla3"
-- predifind["msg_no_target"] = "cannot find target: <PARAM>"
-- predifind["msg_higher_admin"] = "cannot target a higher admin

-- param[1] assumes to be the target
	local i=1 -- i want to number only the command arguments inputed by the player (without params["slot"] etc..)
	local sum = 0
	local end_fix = ""
	if params["say"] == "print" then
		end_fix = "\n"
	end
	while params[i] ~= nil do
		sum = sum +1
		i = i+1
	end
	if sum < predifind["reqired_params"] then 
		if params["slot"] == "console" then 
			et.G_Print(predifind["msg_syntax"].. "\n")
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],predifind["msg_syntax"] .. end_fix))
		end
		return -1
	end
	
	local slot = tonumber(params[1])
	if slot == nil then
		local temp = NameToSlot(params[1])
		if table.getn(temp) < 1 then
			
			predifind["msg_no_target"] = string.gsub(predifind["msg_no_target"], "<PARAM>", params[1])
			if params["slot"] == "console" then 
				et.G_Print(predifind["msg_no_target"].. "\n")
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],predifind["msg_no_target"] .. end_fix))
			end
			return -1
		elseif table.getn(temp) > 1 then
			if params["slot"] == "console" then 
				et.G_Print("^w".. params[1] .. " ^fmatches more then one player:\n")
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^w".. params[1] .. " ^fmatches more then one player:" .. end_fix))
			end
			for i=1,table.getn(temp),1 do -- list all matching clients
				if params["slot"] == "console" then 
					et.G_Print("^f"..  temp[i] .. " - " ..  et.gentity_get(temp[i],"pers.netname") .. "\n")
				else
					et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],"^f"..  temp[i] .. " - " ..  et.gentity_get(temp[i],"pers.netname") .. end_fix)) 
				end
			end 
			return -1
		else slot = temp[1] end
	end
	if slot < 0 or slot > 64 then -- people tried to enter 325393 as slot number... wtf?!
		return -1
	end
	if params["slot"] ~= "console" then 
		if AdminUserLevel(params["slot"]) < AdminUserLevel(slot) then
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s\"',params["say"],predifind["msg_higher_admin"] .. end_fix))
			return -1
		end
	end
	return slot
end

function isIgnored(client,slot) -- returns 1 if the client is ignoring the slot, or nil otherwise
	local i,k,v,flag = false
	if global_players_table[client]["ignoreClients"] == nil then return nil end -- no clients to ignore!

	for k,v in pairs(global_players_table[client]["ignoreClients"]) do
		if k == slot then
			flag = true
			break
		end
	end
	if flag == true then return 1 
	else return nil end
end



				
function player_info_isIpExist(ip_table,ip) -- returns 1 if the ip exists in the ip_table, or nil otherwise
	local i,k,v,flag = false

	for k,v in pairs(ip_table) do
		if v == ip then
			flag = true
			--et.G_Print("**-*** ip found in ip table!\n")
			break
		end
	end
	if flag == true then return 1 
	else return nil end	
end

function player_info_isAliasExist(alias_table,name) -- returns 1 if the name exists in the alias_table, or nil otherwise
	local i,k,v,flag = false

	if type(alias_table) ~= "table" then return nil end
	for k,v in pairs(alias_table) do
		if v == name then
			flag = true
			--et.G_Print("**-*** name found in name table!\n")
			break
		end
	end
	if flag == true then return 1 
	else return nil end	
end


function countAxis()
	local axis=0
	local i
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		if global_players_table[i] ~= nil then
			if global_players_table[i]["team"] == 1 then -- axis
				axis = axis +1
			end
		end
	end
	return axis
end

function countAllies()
	local allies=0
	local i
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		if global_players_table[i] ~= nil then
			if global_players_table[i]["team"] == 2 then -- allies
				allies = allies +1
			end
		end
	end
	return allies
end

function countSpectators()
	local specs=0
	local i
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		if global_players_table[i] ~= nil then
			if global_players_table[i]["team"] == 3 or global_players_table[i]["team"] == 0 then -- specs or connecting
				specs = specs +1
			end
		end
	end
	return specs
end

-- returns true if a curse (from b_cursefilter) found in the text, or nil otherwise
function isBadword(text)
	local word, curse
	local flag = false
	local capture = nil
	local flag = false
	local token = ParseString(text)
	local cvar = "b_cursefilter"
	if et.trap_Cvar_Get("gamename") == "etpub" then
		cvar = "g_censor"
	end
	for i=1 , table.getn(token), 1 do
		for curse in string.gfind(et.trap_Cvar_Get(cvar), "%S+") do
			if not excluded_word(et.Q_CleanStr(string.lower(token[i]))) then
				--for capture in string.gfind(et.Q_CleanStr(string.lower(token[i])), string.lower(curse)) do
				if string.find(et.Q_CleanStr(string.lower(token[i])), string.lower(curse),1,1) then
					return true
				end
			end
		end
	end	
	if heavyCensor() then return true end
	return nil -- no bad words were found
end
	
-- prints a text on behalf of the user, mode = et.SAY_ALL/et.SAY_TEAM/et.SAY_BUDDY
function userPrint(slot,mode,text,to)
	--et.G_LogPrint("hey2 " .. slot  .. " " .. mode .. " " .. text .. " " .. to .."\n")
	if et.trap_Cvar_Get("gamename") == "nq" then -- NoQuarter does not support any of it.
		return
	end

	if slot == CONSOLE then return end
	local pos = et.gentity_get(slot, "origin");
	if mode == et.SAY_ALL then
		et.trap_SendServerCommand(to, string.format("c %d \"%s\"",slot, text))
	elseif mode == et.SAY_TEAM then -- TODO: add x-y-z coordinates to print (to make it look real)
		--et.trap_SendServerCommand(tc, string.format("c %d \"%s\" X-%d Y-%d Z-%d",slot, text, x,y,z)
		--et.trap_SendServerCommand(slot, string.format("tc %d \"%s\"",slot, text))
		et.trap_SendServerCommand(to, string.format("tc %d \"%s\" %d %d %d",slot, text, pos[1],pos[2],pos[3]))
	elseif  mode == et.SAY_BUDDY then
		--et.trap_SendServerCommand(slot, string.format("bc %d \"%s\"",slot, text))
		et.trap_SendServerCommand(to, string.format("bc %d \"%s\" %d %d %d",slot, text, pos[1],pos[2],pos[3]))
	end

end

function checkPlayerName(slot) -- function checks for disallowed charectars in player's name, renaming him if found.
	local a1,a2,new
	a1,a2 = string.find(global_players_table[slot]["name"],"([\n]*[\r]*[\f]*[\t]*)")
	if a1 and a2 then
		new = string.gsub(global_players_table[slot]["name"],"([\n]*[\r]*[\f]*[\t]*)","")
		local userinfo = et.trap_GetUserinfo(slot)
		userinfo = et.Info_SetValueForKey(userinfo, "name", new)
		et.trap_SetUserinfo(slot, userinfo)
		et.ClientUserinfoChanged(slot)
	end
end

function getClientSay(text) -- function gets a client command ("say" or "say_team"  "say_buddy" then -- a chat command), and returns the right predefine
	text = string.lower(text)
	if text == "say" then	
		return et.SAY_ALL
	elseif text == "say_team" then
		return et.SAY_TEAM
	elseif text == "say_buddy" then
		return et.SAY_BUDDY
	elseif text == "say_teamnl" then
		return et.SAY_TEAMNL
	else return nil end
end

-- in order to save simple (on/off) status for players, im using a cvar.
-- the cvar is string of slot numbers, for example: "2 5 16 23" --> this means slot 2,5,16 and 23 has some feature enabled (or disabled)
-- and these functions control it.
Cvar = {}
function Cvar.Add_Slot(cvar,slot) -- adds the slot to the cvar, returns 1 on success, or nil otherwise (returns nil if its already in)
	--et.trap_Cvar_Set( cvar, et.trap_Cvar_Get(cvar) .. " " .. slot ) -- every time it appends a space to the start, eventually the cvar will explode.
	if Cvar.Slot_Exists(cvar,slot) then return nil end

	et.trap_Cvar_Set(cvar, table.concat(Cvar.Slots_Table(cvar), " ") .." " .. slot )
	return 1

end

function Cvar.Remove_Slot(cvar,slot) -- removes a slot, returns 1 on seccess, or nil otherwise (if it doesnt exist)
	local t = Cvar.Slots_Table(cvar)
	local i,index
	if type(t) == "table" then 
		index = Cvar.Slot_Exists(cvar,slot)
		if index == nil then return nil end -- slot doesnt exist.
		table.remove (t , index)
		et.trap_Cvar_Set(cvar, table.concat(t, " "))
		return 1
	else -- its already empty
		et.trap_Cvar_Set(cvar, "")
		return nil 
	end


end

function Cvar.Slot_Exists(cvar,slot) -- checks if the slot exists, returns its index position in the slots table, or nil otherwise
	local flag = nil
	local t = Cvar.Slots_Table(cvar)
	for i=1,table.getn(t), 1 do
		if ( slot == t[i] ) then
			return i
		end
	end
	return nil
end

function Cvar.Slots_Table(cvar) -- returns a table containing all slots 
	local cvar = et.trap_Cvar_Get(cvar)
	local slot
	local i = 1
	local t = {}
	for slot in string.gfind(cvar, "%s*(%d+)") do
		t[i]=tonumber(slot)
		i=i+1
	end
	return t
end

function getMessagePosition(position)
	if et.trap_Cvar_Get("gamename") ~= "etpub" then 
		position = string.lower(position)
		if (position == "chat") then
			position = "b 8"
		elseif (position == "cpm") then
			position = "b 16"
		elseif (position == "cp") then
			position = "b 32"
		elseif (position == "bp") then
			position = "b 128"
		else 
			return "b 8"
		end
	end
	return position
end

function getSoundPosition(position, player) -- player is optional value, need to be supplied only when playing for a certain player and not everyone
	position = string.lower(position)
	if (position == "all") then
		position = "playsound"
	elseif (position == "envi") then
		position = "playsound_env " .. player
	else -- playsound player (play for a specific player only)
		position = "playsound " .. player
	end
	return position
end

function weaponName(meansOfDeath)
	local weapon
	if (meansOfDeath==0) then
		weapon="UNKNOWN"
	elseif (meansOfDeath==1) then
		weapon="MACHINEGUN"
	elseif (meansOfDeath==2) then
		weapon="BROWNING"
	elseif (meansOfDeath==3) then
		weapon="MG42"
	elseif (meansOfDeath==4) then
		weapon="GRENADE"
	elseif (meansOfDeath==5) then
		weapon="ROCKET"
	elseif (meansOfDeath==6) then
		weapon="KNIFE"
	elseif (meansOfDeath==7) then
		weapon="LUGER"
	elseif (meansOfDeath==8) then
		weapon="COLT"
	elseif (meansOfDeath==9) then
		weapon="MP40"
	elseif (meansOfDeath==10) then
		weapon="THOMPSON"
	elseif (meansOfDeath==11) then
		weapon="STEN"
	elseif (meansOfDeath==12) then
		weapon="GARAND"
	elseif (meansOfDeath==13) then
		weapon="SNOOPERSCOPE"
	elseif (meansOfDeath==14) then
		weapon="SILENCER"
	elseif (meansOfDeath==15) then
		weapon="FG42"
	elseif (meansOfDeath==16) then
		weapon="FG42SCOPE"
	elseif (meansOfDeath==17) then
		weapon="PANZERFAUST"
	elseif (meansOfDeath==18) then
		weapon="GRENADE_LAUNCHER"
	elseif (meansOfDeath==19) then
		weapon="FLAMETHROWER"
	elseif (meansOfDeath==20) then
		weapon="GRENADE_PINEAPPLE"
	elseif (meansOfDeath==21) then
		weapon="CROSS"
	elseif (meansOfDeath==22) then
		weapon="MAPMORTAR"
	elseif (meansOfDeath==23) then
		weapon="MAPMORTAR_SPLASH"
	elseif (meansOfDeath==24) then
		weapon="KICKED"
	elseif (meansOfDeath==25) then
		weapon="GRABBER"
	elseif (meansOfDeath==26) then
		weapon="DYNAMITE"
	elseif (meansOfDeath==27) then
		weapon="AIRSTRIKE"
	elseif (meansOfDeath==28) then
		weapon="SYRINGE"
	elseif (meansOfDeath==29) then
		weapon="AMMO"
	elseif (meansOfDeath==30) then
		weapon="ARTY"
	elseif (meansOfDeath==31) then
		weapon="WATER"
	elseif (meansOfDeath==32) then
		weapon="SLIME"
	elseif (meansOfDeath==33) then
		weapon="LAVA"
	elseif (meansOfDeath==34) then
		weapon="CRUSH"
	elseif (meansOfDeath==35) then
		weapon="TELEFRAG"
	elseif (meansOfDeath==36) then
		weapon="FALLING"
	elseif (meansOfDeath==37) then
		weapon = "SUICIDE"
	elseif (meansOfDeath==38) then
		weapon="TARGET_LASER"
	elseif (meansOfDeath==39) then
		weapon="TRIGGER_HURT"
	elseif (meansOfDeath==40) then
		weapon="EXPLOSIVE"
	elseif (meansOfDeath==41) then
		weapon="CARBINE"
	elseif (meansOfDeath==42) then
		weapon="KAR98"
	elseif (meansOfDeath==43) then
		weapon="GPG40"
	elseif (meansOfDeath==44) then
		weapon="M7"
	elseif (meansOfDeath==45) then
		weapon="LANDMINE"
	elseif (meansOfDeath==46) then
		weapon="SATCHEL"
	elseif (meansOfDeath==47) then
		weapon="TRIPMINE"
	elseif (meansOfDeath==48) then
		weapon="SMOKEBOMB"
	elseif (meansOfDeath==49) then
		weapon="MOBILE_MG42"
	elseif (meansOfDeath==50) then
		weapon="SILENCED_COLT"
	elseif (meansOfDeath==51) then
		weapon="GARAND_SCOPE"
	elseif (meansOfDeath==52) then
		weapon="CRUSH_CONSTRUCTION"
	elseif (meansOfDeath==53) then
		weapon="CRUSH_CONSTRUCTIONDEATH"
	elseif (meansOfDeath==54) then
		weapon="CRUSH_CONSTRUCTIONDEATH_NOATTACKER"
	elseif (meansOfDeath==55) then
		weapon="K43"
	elseif (meansOfDeath==56) then
		weapon="K43_SCOPE"
	elseif (meansOfDeath==57) then
		weapon="MORTAR"
	elseif (meansOfDeath==58) then
		weapon="AKIMBO_COLT"
	elseif (meansOfDeath==59) then
		weapon="AKIMBO_LUGER"
	elseif (meansOfDeath==60) then
		weapon="AKIMBO_SILENCEDCOLT"
	elseif (meansOfDeath==61) then
		weapon="AKIMBO_SILENCEDLUGER"
	elseif (meansOfDeath==62) then
		weapon="SMOKEGRENADE"
	elseif (meansOfDeath==63) then
		weapon="SWAP_SPACES"
	elseif (meansOfDeath==64) then
		weapon="SWITCH_TEAM"
	else
		weapon="UNKNOWN" -- new weapon?
	end
	return weapon
end

function explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end


-- in order for the function to be able to manipulate the table without changing the original one (when passing a table to a function, LUA doesnt create a new table in the function, but passes a link to that same table, which means changing it inside the function will also change the table outside of the function)
-- from: http://lua-users.org/wiki/CopyTable
function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function getMapNickFromName(name,mapList)
	local nickname = ""
	for nickname,map in pairs(mapList) do
		if mapList[nickname]["name"] == name then
			return nickname
		end
	end
	-- its possible the original 6 maps are not included, but the server fell back to them, so search them too
	for nickname,map in pairs(ORIGINAL_6_MAPS_ROTATION) do
		if ORIGINAL_6_MAPS_ROTATION[nickname]["name"] == name then
			return nickname
		end
	end	
	if not name then name = "" end
	et.G_Print("KMOD+ Rotation ERROR: map " .. name .. " is not in the map list\n" )
	return nil
end

function table.getm(t) -- returns the number of elemts in table regardless of numrical keys
	local index = 0
	for k,v in pairs(t) do
		index = index +1
	end
	return index
end

function guidCheck(guid)
	if guid == "" or guid == " " or string.upper(guid) == "UNKNOWN" or string.upper(guid) == "NO_GUID" then
		return nil
	end
	return true
end