
-- guid_spoof_check(line) -- checking the cl_guid against the pb_guid and kicks if not mach
-- pb_line(line) -- returns a table containing words if its a punkbuster line
-- guid_age(line) -- updates the global_players_table[slot]["guid_age"] or global_ghost_table[slot]["guid_age"] with the guid_age
-- get_guid_age(line , plist) -- gets the guid_age out of the console line, plist is a flag (is it a pb_sv_plist chunk?)
-- read_etconsole_log() -- reads the new lines from the log

PB_PREFIX = "^3PunkBuster Server" .. ":"
TZAC_PREFIX = '[TZAC]'


global_wait = os.time()
function baa() -- function to not spam the console when testing
	if global_wait == nil then
		global_wait = os.time()
	end
	if os.time () - global_wait > 1 then
		global_wait = os.time()
		return 1
	else
		return nil
		
	end
end

function guid_spoof_check(line)
		if type(line) == "table" then -- there is something new in the console log
			local guid_spoof = tonumber(et.trap_Cvar_Get("k_spoof_check"))
			if guid_spoof == 1   then
				local i
				local s,e 
				local plist = false
				for i=1, table.getn(line), 1 do
					local pb_prefix = PB_PREFIX
					s, e = string.find(line[i],pb_prefix,1,true)
					--et.G_Print("searching line " .. i .. ": " .. line[i] .. "\n")
					if s==1 and e then
						local slot
						local pb_guid
						local tokens = ParseString(line[i])
						-- PunkBuster Server: Player GUID Computed GUID(-) (slot #3) ip.xxx.xx.xx:27960player_name
						if tokens[3] == "Player" and tokens[4] == "GUID" and tokens[5] == "Computed"   then
							s,e,pb_guid = string.find(tokens[6],"([^%(]+)")
							s,e,slot= string.find(tokens[8],"#(%d+)")
						elseif (tokens[3] == "Player" and tokens[4] == "List:") then
							plist = 1


						--^3PunkBuster Server: Player List: [Slot #] [GUID] [Address] [Status] [Power] [Auth Rate] [Recent SS] [O/S] [Name]
						--^3PunkBuster Server: 3  GUID(?) ip.xxx.xx.xx:27960 OK   1 3.0 0 (W) "player_name"
						elseif (tokens[6] == "OK" and plist) then
							slot = tonumber(tokens[3])
							s,e, pb_guid = string.find(tokens[4],"([^%(]+)")
						end
						
						if pb_guid ~= nil then
							pb_guid = string.upper(pb_guid)
							if string.len(pb_guid) == 32 then
								slot = slot -1
								local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "cl_guid" ))

								--et.G_Print("checking spoof\n")
								--et.G_Print("slot: " .. slot .. "pb guid: " .. pb_guid .. " guid: " .. guid .. "\n")
								if guid ~= pb_guid then
									--et.G_Print("pb_guid: " .. pb_guid .. " guid: ".. guid .. "\n")
									et.G_LogPrint("KMOD+ player kicked: " .. slot .. " guid spoof\n")
									et.trap_SendConsoleCommand(et.EXEC_APPEND , "pb_sv_kick " .. slot+1 .. " " .. 2 .. " reason: " ..  "guid spoof!") 
								end

							end
						end
						
					end
				end
			end
		end
	
end

						
--[[
function pb_line(line) -- checks if this is a punkbuster line, retuns a table containing words on seccess (word[1],word[2] etc..., nil if fail)
	local pb_prefix = "^3PunkBuster Server" .. ":"
	s, e = string.find(line,pb_prefix,1,true)
	if s==1 and e then
		return ParseString(line)
	end
end
--]]

function pb_line(line) -- checks if this is a punkbuster line, retuns a table containing words on seccess (word[1],word[2] etc..., nil if fail)
	--local pb_prefix = "^3PunkBuster Server" .. ":"
	local prefix

	if (et.trap_Cvar_Get("pb_sv_ver") ~= nil and et.trap_Cvar_Get("pb_sv_ver") ~= "") then
		prefix = PB_PREFIX
	elseif (et.trap_Cvar_Get("ac_sv_version") ~= nil and et.trap_Cvar_Get("ac_sv_version") ~= "") then -- slac/tzac
		prefix = TZAC_PREFIX

	else 
		return -- pb/TZAC is not running on this server
	end
	s, e = string.find(line,prefix,1,true)

	if s==1 and e then
		--[SLSV] Client #3 00027713 Necromancer3 connected from 87.69.125.74:64430 - ^wNe^zcr^9o^0m^9a^znc^wer
		return ParseString(line)
	end
end

function update(line)

	if type(line) == "table" then -- there is something new in the console log
		for i=1, table.getn(line), 1 do
			tzac(line[i])
		end
	end
end

function parsePlist(tokens,plist)
	local slot = false
	local valid = false
	local guid
	local slac_id
	local slac_name
	local name



	if TZAC > 0 then
		
		-- !!! >>> SLAC/TZAC line <<< !!! --
		-- [TZAC] Client #2 00027713 Necromancer3 connected from 87.69.125.74:63448 - ^wNe^zcr^9o^0m^9a^znc^wer
		if (tokens[2] == "Client" and tokens[6] == "connected:" and tokens[7] == "from") then
			s,e,slot= string.find(tokens[3],"#(%d+)")
			slac_id =  string.format('%032d', tonumber(tokens[3]))
			slac_name = tokens[4]
			ip = tokens[8]
			name = table.concat(tokens,"",10)
			global_players_table[slot]["tzac_name"] = slac_name

			local player_tracker = tonumber(et.trap_Cvar_Get("k_player_tracker"))
			if player_tracker ~= nil then
				if player_tracker > 0 then
					if not global_players_info_table[guid].get("tzac_name") then
						global_players_info_table[guid].set("tzac_name",slac_name)
					end
				end
			end
			return nil, nil, nil, plist -- currently doesnt do anything (not updating anything)
	--[[
		
		No. | Account Name     | IP              | TZAC GUID | GUID Age | Nick
		------------------------------------------------------------------------------------------------
		02  | Necromancer3     | 87.69.210.62    | 00027713  |      191 | ETPlayer
		-------------------------------------=[End Of Players List]=------------------------------------
	--]]
		elseif (tokens[1] == "No." and tokens[2] == "|" and tokens[3] == "Account" and tokens[4] == "Name" and tokens[6] == "IP" and tokens[8] == "TZAC" and tokens[11] == "GUID") then -- we got PLIST!
			plist = 1
			--et.G_Print("we got a Plist!\n")
			return nil, nil, nil, plist			
		elseif (tokens[2] == "|" and tokens[4] == "|" and tokens[6] == "|" and tokens[8] == "|" and tokens[10] == "|" and plist == 1 ) then -- extract the data
			slot = tonumber(tokens[1])
			slac_name = tokens[3]
			global_players_table[slot]["tzac_name"] = slac_name
			ip = tokens[5]
			guid = string.format('%032d', tonumber(tokens[7]))
			valid = (tokens[9])
			name = table.concat(tokens,"",11)
			--et.G_Print("\nTZAC name set!\n")
			--et.G_Print("\n lets see: " .. valid .. " " .. slot ..  " " .. guid .."\n")
		elseif (tokens[2] == "Of" and tokens[3] == "Players" and plist == 1 ) then -- End Of Players List
			plist = false
		end
		if slot and valid then
			--et.G_Print("\n lets see: " .. valid .. " " .. slot ..  " " .. guid .."\n")
			return slot, valid, guid, plist
		else
			return nil, nil, nil, plist
		end
	else -- using PunkBuster
		if (tokens[3] == "Player" and tokens[4] == "List:") then
			plist = 1
			return nil, nil, nil, plist
		elseif (tokens[6] == "OK" and plist) then
			slot = tonumber(tokens[3])
			s,e, valid = string.find(tokens[4],"VALID:(%d+)")
			s,e,guid = string.find(tokens[4],"([^%(]+)")
		end
		if slot and valid then
			--et.G_Print("\n lets see: " .. valid .. " " .. slot ..  " " .. guid .."\n")
			return slot-1, valid -1 , string.upper(guid), plist
		else  -- maybe PB didnt get the guid age from one of the users yet, but its not the end of the of the plist table yet
			return nil, nil, nil, plist
		end
	end
end




function guid_age(line)
		flag = false -- was there any guid age captured? 
		
		--local line = 
		if type(line) == "table" then -- there is something new in the console log
			local i
			local s,e 
			local plist = false
			local slot, valid, guid
			for i=1, table.getn(line), 1 do
				slot,valid, guid, plist = get_guid_age(line[i] , plist)
				
				if slot ~= nil then
					--et.G_Print("\n lets see: we got it!!! \n")
					--et.G_Print("guid age - slot: " .. slot .. " valid: " .. valid .. " guid: " .. guid ..  "\n")
					if global_players_table[slot] ~= nil then
						global_players_table[slot]["guid_age"] = valid

						flag = true
						local player_tracker = tonumber(et.trap_Cvar_Get("k_player_tracker"))
						if player_tracker ~= nil then
							if player_tracker > 0 then
								if not global_players_info_table[guid].get("guid_age") then
									global_players_info_table[guid].set("guid_age",valid)
								end
							end
						end
						
					else
						if global_ghost_table[slot] == nil then
							global_ghost_table[slot] = {}
						end
						global_ghost_table[slot]["guid_age"] = valid
						global_ghost_table[slot]["guid"] = guid
					end

				end
			end				
			
		end
		
		return flag

end


function get_guid_age(line , plist) -- gets a line, and a plist flag (is it a pb_sv_plist?) ||| returns slot,valid and plist (1 if yes, false if not)
	--
	local works,tokens -- works = did the function work, or failed (error)
	local slot,valid, guid
	works, tokens = pcall(pb_line,line)

	
	
	if works == false then
		-- LOG get_guid_age problem
		return
	end
	
	--et.G_Print("test: " .. type(tokens) .. "\n")
	if tokens == nil then
		
		-- tzac server does not uses any prefix when printing to the console, we should not relay on pb_plist (which checks for prefix) when testing for plist!
		
		--works, tokens = pcall(plist(ParseString(line)))
		line = ParseString(line)

		
		works, slot,valid, guid, plist = pcall(parsePlist,line,plist)
		if works ~= false then
			if slot ~= nil then
				return slot,valid, guid, plist
			end
		end
--[[
		slot,valid, guid, plist = pcall(parsePlist(line,plist)
		if slot ~= nil then
			return slot,valid, guid, plist
		end
--]]
		return nil, nil, nil, plist
	
	end

	if (tokens ~= nil) then
		
		--local plist = false
		local s,e
		local slot
		local valid
		local guid

		-- #^3PunkBuster Server: [From #9 a9ea(VALID:397) player_name]  etc.. etc..
		--s,e, slot, valid= string.find(line[i],"From #(d+) [^%(]\(VALID:(d+)\) .*")
		if tokens[3] == "[From" then
			s,e,slot= string.find(tokens[4],"#(%d+)")
			s,e,valid = string.find(tokens[5],"VALID:(%d+)")
			guid = global_players_table[slot-1]["guid"] -- this is the only time i cannot get the guid from line (but i know 100% the player is on the server right now)
			-- ^3PunkBuster Server: Lost Connection (slot #3) ip.xxx.xxx.xx:27960 GUID(VALID:210) player_name
			-- pb losses connection to clients when they load a map, and its printed in the log AFTER the mapchange on the server, and even after KMOD+ is loaded back up
		elseif (tokens[3] == "Lost" and tokens[4] == "Connection") then
			--et.G_Print("\n does it work? \n")
			--et.G_Print("\n lets see: " .. tokens[6] .. " " .. tokens[8] ..  "\n")
			s,e,slot = string.find(tokens[6],"#(%d+)")
			s,e,valid = string.find(tokens[8],"VALID:(%d+)")
			s,e,guid = string.find(tokens[8],"([^%(]+)")
			--et.G_Print("\n lets see: " .. valid .. " " .. slot ..  "\n")
			-- pb_sv_plist
			--^3PunkBuster Server: Player List: [Slot #] [GUID] [Address] [Status] [Power] [Auth Rate] [Recent SS] [O/S] [Name]
			--^3PunkBuster Server: 3  GUID(?) ip.xxx.xx.xx:27960 OK   1 3.0 0 (W) "player_name"
		end
		return nil, nil, nil, plist

	end
end


function read_etconsole_log() -- returns table[i] that contains the new server lines.
	-- TODO: restet old_len counter if more then 1000 lines passed since last time ( it might be a mod-restart, we dont want it to start parsing the whole log )
	if ( tonumber(et.trap_Cvar_Get("logfile")) > 0) then -- loggins is enabled on this server

			local console =  et.trap_Cvar_Get("fs_homepath")
			local console = console .. '/etpro/etconsole.log'
			--local fd, len = et.trap_FS_FOpenFile( console, et.FS_READ )
			--local len = fsize(console)
			local old_len =  tonumber( et.trap_Cvar_Get("k_etconsole_len") )
			
			if old_len == nil or old_len == "" then
				
				console = io.open(console, "r")
				if console ~= nil then
					et.trap_Cvar_Set( "k_etconsole_len", tostring(console:seek("end")) )
					console:close()
				end
			else
				--et.G_Print("\nOLD_len: " ..tostring(old_len) .. "\n" )
				--if old_len > 20000 then
				--	et.G_Print("bigger\n")
					--return
				--end

				--io.input(console) --sets the filename as default input file
				--or
				console = io.open(console, "r") -- to open the file
				if console ~= nil then
					local len = console:seek("end") 

					if len ~= nil and len ~= console:seek("set",old_len) then
						--et.G_Print("\n\n\n whoohooo!!!\n\n")
						local filestr = console:read("*a")
						if filestr == "" or filestr == nil then
							return
						else
							local file = {}
							local i = 1
							local line
							for line in string.gfind(filestr, "([^%\n]*)\n") do
								file[i] = line
								i=i+1
							end

							et.trap_Cvar_Set( "k_etconsole_len", tostring(console:seek("end")) )
							console:close()
							return(file)
						end

					
					end
				end
	
				
				console:close()
			end
	end

end

function tzac(line)

	local works,tokens -- works = did the function work, or failed (error)
	works, tokens = pcall(pb_line,line)
	if works == false then
		
		return
	end
	if (tokens ~= nil) then	

		--[TZAC] Client #3 00066660 Vitaliy3 connected from 84.94.91.113:13249 - Vitaliy
		--[SLSV] Client #3 00027713 Necromancer3 connected from 87.69.125.74:64430 - ^wNe^zcr^9o^0m^9a^znc^wer
		if ((tokens[2] == "Client") and (tokens[6] == "connected") and (tokens[7] == "from")) then
			
			s,e,slot= string.find(tokens[3],"#(%d+)")
			slot = tonumber(slot)
			slac_id = tokens[4]
			slac_name = tokens[5]
			ip = tokens[8]
			name = table.concat(tokens,"",10)
			if global_players_table[slot] ~= nil then
				global_players_table[slot]["tzac_name"] = slac_name

				local player_tracker = tonumber(et.trap_Cvar_Get("k_player_tracker"))
				if player_tracker ~= nil then
					if player_tracker > 0 then
						if guid ~= "UNKNOWN" and global_players_info_table[guid] ~= nil then
							if not global_players_info_table[guid].get("tzac_name") then
								global_players_info_table[guid].set("tzac_name",slac_name)
								--et.G_Print("------------------->" .. slot .. " " .. slac_id .. " " .. slac_name .. "\n")
							end
						end
					end
				end

				--et.G_Print("\n got it: " .. slot .. " " .. slac_id .. " " .. slac_name .. "\n")
				if global_players_table[slot]["guid"] == "UNKNOWN" then -- pb disabled, couldnt retrive guid, use slac/tzac user id
					global_players_table[slot]["guid"] = string.format('%032d', tonumber(slac_id))
				end
			else
				if global_ghost_table[slot] == nil then
					global_ghost_table[slot] = {}
					global_ghost_table[slot]["tzac_name"] = slac_name
				end
			end
			isBanned(slot)
		end
	end
end




--[[
function fsize (file)
	local current = file:seek()      -- get current position
	local size = file:seek("end")    -- get file size
	file:seek("set", current)        -- restore position
	return size
end
--]]