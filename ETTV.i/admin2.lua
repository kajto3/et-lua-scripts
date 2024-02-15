version = "0.8"

shrubbot			= "/home/et/etpro/shrubbot.cfg"
etproguid_logging	= true
guidfilename		= "guid_faker.txt"
EV_GLOBAL_CLIENT_SOUND = 54

function et.G_Printf(...)
    et.G_Print(string.format(unpack(arg)))
end


function et_InitGame( levelTime, randomSeed, restart )
	et.RegisterModname("admin2.lua "..version.." "..et.FindSelf())
	sv_maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
	admins		= {}
	bonus_table	= {}

end

function sayClients(pos, msg)
    et.G_Printf("kspree.lua: sayClients('%s', '%s')\n", pos, msg)
    et.trap_SendServerCommand(-1, pos.." \""..msg.."^7\"\n")
end

function et.G_ClientSound(clientnum, soundfile)
	local tempentity = et.G_TempEntity(et.gentity_get(clientnum, "r.currentOrigin"), EV_GLOBAL_CLIENT_SOUND)
	et.gentity_set(tempentity, "s.teamNum", clientnum)
	et.gentity_set(tempentity, "s.eventParm", et.G_SoundIndex(soundfile))
end

function getGuid (id)
    return(string.lower(et.Info_ValueForKey(et.trap_GetUserinfo(id), "cl_guid")))
end

function playerName(id)
    return(et.Info_ValueForKey(et.trap_GetUserinfo(id), "name"))
end

function playerIp(id)
    return(et.Info_ValueForKey(et.trap_GetUserinfo(id), "ip"))
end

function et_ClientCommand(id, command)

	if string.find(et.trap_Argv(1), "##") ~= nil then
	   		if et.trap_Argv(0) == "say_team" then
				colar = "^5"
			elseif et.trap_Argv(0) == "say" then
				colar = "^r"
			elseif et.trap_Argv(0) == "say_buddy"  then
		   		colar = "^3"
			else
				colar = "^7"
			end

			to_say = et.trap_Argv(1)
			-- replace id with name
			for wox in string.gfind(to_say, "%#%#(%d*)") do
				if tonumber(wox) ~= nil then
					wox = tonumber(wox)
					if wox < sv_maxclients and wox >= 0 then
						to_say = string.gsub (to_say, "##"..wox, "^7"..playerName(wox)..colar)
					end
				end
  			end

			-- replace partofname with name
			for wox2 in string.gfind(to_say, "%#%#([^%s]*)") do
				if inSlot(wox2) ~= nil then
				   local parttoid = inSlot(wox2)
				   if parttoid < sv_maxclients and parttoid >= 0 then
				   		to_say = string.gsub (to_say, "##"..wox2, "^7"..playerName(parttoid)..colar)
				   end
				end
  			end

			to_say = string.gsub (to_say, "##", "")
			if et.trap_Argv(0) == "say" then
				et.G_Say( id, et.SAY_ALL, to_say)
			elseif et.trap_Argv(0) == "say_team" then
		   		et.G_Say( id, et.SAY_TEAM, to_say)
		   	elseif et.trap_Argv(0) == "say_buddy" then
		   		et.G_Say( id, et.SAY_BUDDY, to_say)
		   	end
	return(1)
	end

    if et.trap_Argv(0) == "say" then

        if et.trap_Argv(1) == "!regs" then
    		readAdmins(shrubbot)
    		local regs_on   = {}
    		local vips_on   = {}
    		local more_on	= {}
    		local is_allowed_to	= true
   			for i=0, sv_maxclients-1, 1 do
				if admins[getGuid(i)] ~= nil then
					if admins[getGuid(i)] == 1 then
			 		table.insert(regs_on, string.format("^7%s^7", playerName(i)))
					elseif admins[getGuid(i)] == 2 then
						table.insert(vips_on, string.format("^7%s^7", playerName(i)))
					elseif admins[getGuid(i)] == 3 then
						table.insert(more_on, string.format("^7%s^7", playerName(i)))
					--elseif admins[getGuid(i)] >= 4 and getGuid(i) == getGuid(id) then
					--	is_allowed_to = true
					end
				end
    		end
    		if is_allowed_to then
	    		if table.getn(regs_on) ~= 0 then
	    			regs = string.format("^fRegulars: ^7"..table.concat(regs_on, ", ").."" )
	    			et.trap_SendServerCommand( id, "b 8 \""..tostring(et.trap_Cvar_Get("sv_hostname")).."^7: "..regs.."^7\"\n")
	    		else
	    			et.trap_SendServerCommand( id, "b 8 \""..tostring(et.trap_Cvar_Get("sv_hostname")).."^7: No ^fRegulars ^7online.^7\"\n")
	   			end
	    		if table.getn(vips_on) ~= 0 then
	    			vips = string.format("^fVIPs: ^7"..table.concat(vips_on, ", ").."" )
	    			et.trap_SendServerCommand( id, "b 8 \""..tostring(et.trap_Cvar_Get("sv_hostname")).."^7: "..vips.."^7\"\n")
	    		else
	    			et.trap_SendServerCommand( id, "b 8 \""..tostring(et.trap_Cvar_Get("sv_hostname")).."^7: No ^fVIPs ^7online.^7\"\n")
	    		end
	    		if table.getn(more_on) ~= 0 then
	    			more = string.format("^fMore then VIP: ^7"..table.concat(more_on, ", ").."" )
	    			et.trap_SendServerCommand( id, "b 8 \""..tostring(et.trap_Cvar_Get("sv_hostname")).."^7: "..more.."^7\"\n")
	    		else
	    			et.trap_SendServerCommand( id, "b 8 \""..tostring(et.trap_Cvar_Get("sv_hostname")).."^7: No ^fMore then VIPs ^7online.^7\"\n")
	   			end
				return(1)
			end

		elseif string.find(et.trap_Argv(1), "!warn") ~= nil or string.find(et.trap_Argv(1), "!passvote") or
					string.find(et.trap_Argv(1), "!cancelvote") or string.find(et.trap_Argv(1), "!putspec")
					 or string.find(et.trap_Argv(1), "!dewarn") then

			readAdmins(shrubbot)
			local sended  = ""
			if string.find(et.trap_Argv(1), "!warn") ~= nil then
				sended = "!warn"
			elseif string.find(et.trap_Argv(1), "!passvote") ~= nil then
				sended = "!passvote"
			elseif string.find(et.trap_Argv(1), "!cancelvote") ~= nil then
				sended = "!cancelvote"
			elseif string.find(et.trap_Argv(1), "!putspec") ~= nil then
				sended = "!putspec"
			elseif string.find(et.trap_Argv(1), "!dewarn") ~= nil then
				sended = "!dewarn"
			end
			local isAdmin = false
			local admins_on = {}
	   			for i=0, sv_maxclients-1, 1 do
				if admins[getGuid(i)] ~= nil then
					if admins[getGuid(i)] >= 4 then
						table.insert(admins_on, i)
						if getGuid(i) == getGuid(id) then
							isAdmin = true
						end
					end
				end
    			end
    			if table.getn(admins_on) > 0 and not isAdmin then
    				table.foreach(admins_on,
        				function (kling, klang)
        				et.G_ClientSound(id, "sound/misc/referee.wav")
						et.trap_SendServerCommand( klang, "b 8 \""..playerName(klang).."^7: ^1"..sended.." ^7issued by: "
									..playerName(id).." ^7--> "..et.trap_Argv(1).." ^7\"\n")

                		end)
            		et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1"
            					..table.getn(admins_on).." admins ^7have been informed about your request!\"\n")
                	et.G_ClientSound(id, "sound/misc/referee.wav")
                	admins_on = nil
    			return(1)
    			end
		end -- end elseif...
    end -- et.trap_Argv(0) == "say"

	if string.find(string.lower(et.trap_Argv(1)), "!getss") ~= nil then

		readAdmins(shrubbot)
		local isAdmin = false
		local isuberAdmin = false
		local admins_on = {}
		local mhmh 	= ParseString(et.trap_Argv(1))
		local send_to = false
	   	for i=0, sv_maxclients-1, 1 do
			if admins[getGuid(i)] ~= nil then
			   	if admins[getGuid(i)] == 2 or admins[getGuid(i)] == 3 then
			   	     if getGuid(i) == getGuid(id) then
				  		isAdmin = true
			   	     end
				elseif admins[getGuid(i)] >= 4 then
					table.insert(admins_on, i)
					if getGuid(i) == getGuid(id) then
				  		isAdmin = true
				  		isuberAdmin = true
			   	    end
				end
			end
    	end

		if isAdmin then
			if tonumber(mhmh[2]) ~= nil then
    		   	local sloot = tonumber(mhmh[2])
    		   	if sloot < sv_maxclients and sloot >= 0 then
    			   	local pid = sloot + 1
    			   	local pb_name = playerName(sloot)
    				if pb_name ~= "" then
    				   	et.trap_SendConsoleCommand( et.EXEC_NOW, "pb_sv_getss "..pid.." ")
						et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1Screenshot request ^7("..playerName(sloot).."^7) ^1has been sent!\"\n")
						if not isuberAdmin then
							send_to = true
						end
					else
						et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1No player on this slot!\"\n")
					end
				end
			else
				if nil ~= inSlot(mhmh[2]) then
				   local schloot = inSlot(mhmh[2])
				   if schloot == 88 then
				   		et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1You had no matches to that name!\"\n")
				   elseif schloot == 666 then
				   		et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1Partial playername got more than 1 match!\"\n")
				   elseif schloot < sv_maxclients and schloot >= 0 then
				   		local piid = schloot + 1
				   		et.trap_SendConsoleCommand( et.EXEC_NOW, "pb_sv_getss "..piid.." ")
						et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1Screenshot request ^7("..playerName(schloot).."^7) ^1has been sent!\"\n")
						if not isuberAdmin then
							send_to = true
						end
				   end
				end
			end

			if table.getn(admins_on) > 0 and send_to then
    	   		table.foreach(admins_on,
           			function (kling, klang)
           				et.G_ClientSound(id, "sound/misc/referee.wav")
						et.trap_SendServerCommand( klang, "b 8 \""..playerName(klang).."^7: ^1Screenshot ^3request by: ^7"
									..playerName(id).." ^3--> ^7"..table.concat(mhmh, " ").." ^7\"\n")

                	end
                )
           		et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1"
            					..table.getn(admins_on).." admins ^7have been informed about your request!\"\n")
           		admins_on = nil
			end
    	end
    	return(1)
	end -- end getss

	if string.lower(et.trap_Argv(0)) == "getss" then

		readAdmins(shrubbot)
		local arg1 = et.trap_Argv(1)
		local isAdmin = false
		local isuberAdmin = false
		local admins_on = {}
		local send_to = false
	   	for i=0, sv_maxclients-1, 1 do
			if admins[getGuid(i)] ~= nil then
			   	if admins[getGuid(i)] == 2 or admins[getGuid(i)] == 3 then
			   	     if getGuid(i) == getGuid(id) then
				  		isAdmin = true
			   	     end
				elseif admins[getGuid(i)] >= 4 then
					table.insert(admins_on, i)
					if getGuid(i) == getGuid(id) then
				  		isAdmin = true
				  		isuberAdmin = true
			   	    end
				end
			end
    	end

		if isAdmin then
			if tonumber(et.trap_Argv(1)) ~= nil then
    		   	local sloot = tonumber(et.trap_Argv(1))
    		   	if sloot < sv_maxclients and sloot >= 0 then
    			   	local pid = sloot + 1
    			   	local pb_name = playerName(sloot)
    				if pb_name ~= "" then
    				   	et.trap_SendConsoleCommand( et.EXEC_NOW, "pb_sv_getss "..pid.." ")
						et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1Screenshot request ^7("..playerName(sloot).."^7) ^1has been sent!\"\n")
						if not isuberAdmin then
							send_to = true
						end
					else
						et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1No player on this slot!\"\n")
					end
				end
			else
				if nil ~= inSlot(et.trap_Argv(1)) then
				   local schloot = inSlot(et.trap_Argv(1))
				   if schloot == 88 then
				   		et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1You had no matches to that name!\"\n")
				   elseif schloot == 666 then
				   		et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1Partial playername got more than 1 match!\"\n")
				   elseif schloot < sv_maxclients and schloot >= 0 then
				   		local piid = schloot + 1
				   		et.trap_SendConsoleCommand( et.EXEC_NOW, "pb_sv_getss "..piid.." ")
						et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1Screenshot request ^7("..playerName(schloot).."^7) ^1has been sent!\"\n")
						if not isuberAdmin then
							send_to = true
						end
				   end
				end
			end

			if table.getn(admins_on) > 0 and send_to then
    	   		table.foreach(admins_on,
           			function (kling, klang)
           				et.G_ClientSound(id, "sound/misc/referee.wav")
						et.trap_SendServerCommand( klang, "b 8 \""..playerName(klang).."^7: ^1Screenshot ^3request by: ^7"
									..playerName(id).." ^3--> ^7/getss "..arg1.."\"\n")

                	end
                )
           		et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1"
            					..table.getn(admins_on).." admins ^7have been informed about your request!\"\n")
           		admins_on = nil
			end
    	end
    	return(1)
	end -- edn getss 0

	if string.find(string.lower(et.trap_Argv(1)), "!burn") ~= nil then

		readAdmins(shrubbot)
		local isAdmin = false
	   	for i=0, sv_maxclients-1, 1 do
			if admins[getGuid(i)] ~= nil then
			   	if admins[getGuid(i)] >= 6 then
			   	     if getGuid(i) == getGuid(id) then
				  		isAdmin = true
			   	     end
				end
			end
    	end

		if isAdmin then
    	   local mhmh 	= ParseString(et.trap_Argv(1))
     	   if tonumber(mhmh[2]) ~= nil then
    		  	local sloot = tonumber(mhmh[2])
    		  	if sloot < sv_maxclients and sloot >= 0 then
    			   	local burn_time = tonumber(mhmh[3])
					if burn_time then
						if burn_time < 20 then
							burn_time = 20
						end
						et.gentity_set(sloot, "s.onFireStart", et.trap_Milliseconds())
						et.gentity_set(sloot, "s.onFireEnd", (et.trap_Milliseconds() + (burn_time*1000)))
					else
						et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1!burn PartOfName|SLOT Burn_time\"\n")
						return(1)
					end
				end
		   else
		   		if nil ~= inSlot(mhmh[2]) then
					   local schloot = inSlot(mhmh[2])
					   if schloot == 88 then
					   		 et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1You had no matches to that name!\"\n")
					   		 return(1)
					   elseif schloot == 666 then
					  		 et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1Partial playername got more than 1 match!\"\n")
					  		 return(1)
					   elseif schloot < sv_maxclients and schloot >= 0 then
					   		local burn_time = tonumber(mhmh[3])
					   		if burn_time then
					   			if burn_time < 20 then
									burn_time = 20
								end
					   			et.gentity_set(schloot, "s.onFireStart", et.trap_Milliseconds())
								et.gentity_set(schloot, "s.onFireEnd", (et.trap_Milliseconds() + (burn_time*1000)))
							else
					  		 	et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1!burn PartOfName|SLOT Burn_time\"\n")
					  		 	return(1)
					   		end
					   end
				end
		   end
    	end

	end -- end burn

	if string.find(string.lower(et.trap_Argv(1)), "!admin") ~= nil then

		if string.find(string.lower(et.trap_Argv(1)), "!admintest") ~= nil then return end
		readAdmins(shrubbot)
		local isAdmin = false
		local admins_on = {}
	   	for i=0, sv_maxclients-1, 1 do
			if admins[getGuid(i)] ~= nil then
			   	if admins[getGuid(i)] >= 4 then
					table.insert(admins_on, i)
					if getGuid(i) == getGuid(id) then
						isAdmin = true
					end
				end
			end
    	end

		if table.getn(admins_on) > 0 and not isAdmin then
    	   table.foreach(admins_on,
           		function (kling, klang)
           		et.G_ClientSound(id, "sound/misc/referee.wav")
				et.trap_SendServerCommand( klang, "b 8 \""..playerName(klang).."^7: ^1!admin command ^7issued by: ^7"
									..playerName(id).." ^7--> "..et.trap_Argv(1).." ^7\"\n")

                end
            )
           	et.trap_SendServerCommand( id, "b 8 \""..playerName(id).."^7: ^1"
            					..table.getn(admins_on).." admins ^7have been informed about your request!\"\n")
           	et.G_ClientSound(id, "sound/misc/referee.wav")
           	admins_on = nil
  		else	-- das müsste alles mal ordentlich geschrieben werden, hoffe Vetinari is eher fertig =)
  			if et.trap_Argc() == 2 then
  	   			et.G_Printf("say: %s: %s\n", playerName(id), et.trap_Argv(1))
  	   			 et.trap_SendServerCommand( id, "b 8 \"^7"..playerName(id).."^7: ^3The ^1!admin command ^3has been issued!^7\"\n")
  	   		else
  	   			local words = ""
  	   			for i=1, et.trap_Argc(), 1 do
				words = words.." "..et.trap_Argv(i)
				end
				et.G_Printf("say: %s: %s\n", playerName(id), words)
				et.trap_SendServerCommand( id, "b 8 \"^7"..playerName(id).."^7: ^3The ^1!admin command ^3has been issued!^7\"\n")
  	   		end
  		end
  		return(1)
	end -- end !admin

    return(0)
end

function et_ClientDisconnect(id)
	et.gentity_set(id, "s.onFireEnd", (et.trap_Milliseconds() - 200))
    if bonus_table[id] ~= nil then
    	bonus_table[id] = nil
    end
end

function ParseString(inputString)
	local i = 1
	local t = {}
	for w in string.gfind(inputString, "([^%s]+)%s*") do
		t[i]=w
		i=i+1
	end
	return t
end

function readAdmins(file)
	local count = 0
    local f = assert(io.open(file, "r"), "kspree.lua: No shrubbot.cfg!")
    local t = f:read("*all")
    f:close()
    if t == "" then
    	et.G_Printf("kspree.lua: shrubbot.cfg empty! \n")
    else
        local l,m = string.find (t, "%[admin%]")
    	local n,o = string.find (t, "%[ban%]")
    	local last = ""
    	if n ~= nil then
   			tt = string.sub (t, l, n)
   		else
   			tt = string.sub (t, l)
   		end

    	for k, v in string.gfind( tt, "(%w+)%s%=%s([^%\n]*)") do
			if k == "guid" then
				last = string.lower(v)
				admins[last] = 0
				count = count + 1
			end
			if k == "level" then
				admins[last] = tonumber(v)
			end
		end
	end
	return(count)
end

function inSlot(PartName)
	local x=0
	local j=1
	local size=sv_maxclients
	local matches = {}
	while (x<size) do
		found = string.find(string.lower(et.Q_CleanStr( et.Info_ValueForKey( et.trap_GetUserinfo( x ), "name" ) )),string.lower(PartName))
		if(found~=nil) then
				matches[j]=x
				j=j+1
		end
		x=x+1
	end
	if (table.getn(matches)~=nil) then
		x=1
		while (x<=table.getn(matches)) do
		    matchingSlot = matches[x]
			x=x+1
		end
		if table.getn(matches) == 0 then
			--et.G_Print("You had no matches to that name.\n")
			matchingSlot = 88
		else
			if table.getn(matches) >= 2 then
				--et.G_Print("Partial playername got more than 1 match\n")
				matchingSlot = 666
			else
			end
		end
	end
	return matchingSlot
end

function et_Print(text)
    local s,e,id,guid,name = string.find(text, "^etpro%s+IAC:%s+(%d*)%s+GUID%s+%[(.*)%]%s+%[(.*)%]%s*$")
    if s ~= nil then

        local cl_name = et.Q_CleanStr( name )
    	local ip = ""
        if string.len(guid) == 40 and string.find(guid,"^[A-F0-9]+$") then
            --et.G_Printf("Valid ETPROGUID: >%s< Name: >%s<\n", guid, cl_name)
        else
        	id = tonumber(id)
        	ip = playerIp(id)
        	local pb_slot = id + 1
        	local info = string.format("Date: %s\nName: %s\nGUID: %s\nSlot: %d\n\n",
								os.date(), cl_name, guid, id)

        	et.trap_SendConsoleCommand( et.EXEC_NOW, "pb_sv_kick "..pb_slot.." 15 unknown reason ")

        	if ip ~= "" then
                info = string.format("Date: %s\nName: %s\nGUID: %s\nSlot: %d\n-IP-: %s\n\n",
								os.date(), cl_name, guid, id, ip)
			end

			--et.G_Printf("say: %s: !admin Invalid guid detected! Player %s kicked.\n",
            --    			tostring(et.trap_Cvar_Get("sv_hostname")), cl_name)

			if etproguid_logging then
			   local fd,len = et.trap_FS_FOpenFile(guidfilename, et.FS_APPEND)
			   et.trap_FS_Write(info, string.len(info), fd)
			   et.trap_FS_FCloseFile(fd)
			   fd = nil
			end
        end
    end
end