--[[

	advancedadmin.lua
	===================
	by Micha!

	
	Contact:
	--------------------
	http://www.teammuppet.eu
	
	
	Info:
	--------------------
	This lua shortens some admin commands and adds /goto and /get
	
	This lua need the api "et.G_shrubbot_permission" and "et.G_shrubbot_level"
	
--]]

Modname = "AdvancedAdmin"
Version = "0.6"

min_level 		= 9 			--minimum level needed to use /get and /goto
							
reflvl			= 12			--minimum level needed to use ref_cmd

--shortened admin commands
admin_cmd 			= "!ad"		--!admintest
cancel_cmd 			= "!cancel"	--!cancelvote
pass_cmd 			= "!pass"	--!passvote
start_cmd 			= "!start"	--start match
ref_cmd				= "!ref"	--referee login

----------------------------------------------------------------------------------------------
et.CS_PLAYERS = 689

function et_InitGame(levelTime, randomSeed, restart)
	et.G_Print("["..Modname.."] Version: "..Version.." Loaded\n")
    et.RegisterModname(et.Q_CleanStr(Modname).."   "..Version.."   "..et.FindSelf())
end

function et_ClientCommand(clientNum, command) -- get client commands
	local arg0 = string.lower(et.trap_Argv(0))
    local arg1 = et.trap_Argv(1)
	local cmd = string.lower(command)

	if cmd == "get" then
		if getlevel(clientNum) then
			clientcommand(cmd,clientNum)
			return 1
		end
	end
	if cmd == "goto" then
		if getlevel(clientNum) then
			clientcommand(cmd,clientNum)
			return 1
		end
	end
		if (string.find(et.trap_Argv(0), "^" .. cancel_cmd .. "") or string.find(et.trap_Argv(1), "^" .. cancel_cmd .. "")) and not string.find(et.trap_Argv(1), "^!cancelvote") and et.G_shrubbot_permission( clientNum, "c" ) == 1 then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote" )
		elseif (string.find(et.trap_Argv(0), "^" .. pass_cmd .. "") or string.find(et.trap_Argv(1), "^" .. pass_cmd .. "")) and getlevel(clientNum) and not string.find(et.trap_Argv(1), "^!passvote") and et.G_shrubbot_permission( clientNum, "V" ) == 1 then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "passvote" )
		elseif (string.find(et.trap_Argv(0), "^" .. start_cmd .. "") or string.find(et.trap_Argv(1), "^" .. start_cmd .. ""))  and et.G_shrubbot_permission( clientNum, "r" ) == 1 then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref startmatch\n" )
		elseif (string.find(et.trap_Argv(0), "^" .. admin_cmd .. "") or string.find(et.trap_Argv(1), "^" .. admin_cmd .. "")) and not string.find(et.trap_Argv(1), "^!admintest")  and et.G_shrubbot_permission( clientNum, "a" ) == 1 then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "admintest ".. clientNum.."\n" )
		elseif (string.find(et.trap_Argv(0), "^" .. ref_cmd .. "") or string.find(et.trap_Argv(1), "^" .. ref_cmd .. "")) and et.G_shrubbot_level(clientNum) >= reflvl then
			if et.gentity_get(clientNum, "sess.referee") == 0 then
				et.trap_SendConsoleCommand(et.EXEC_APPEND, "ref referee "..clientNum.."" )
			end
		end
	return 0
end

function getlevel(client)
	local lvl = et.G_shrubbot_level(client)
	if lvl >= min_level then
		return true
	end
		return nil
end

function checkteam(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client)
	return tonumber(et.Info_ValueForKey(cs, "t"))
end

function playerName(id) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(id), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end

function clientcommand(params,PlayerID)

	local cmd = params
	local params = {}
	local i=1
	-- if et.trap_Argv(i) is empty, it returns "" (and not nil!)
	while string.lower(et.trap_Argv(i)) ~= "" do
		params[i] =  string.lower(et.trap_Argv(i))
		i=i+1
	end
	
		if ( params[1] ~= nil ) then
		
			local client = tonumber(params[1])
			if client then
				if (client >= 0) and (client < 64) then 
					if et.gentity_get(client,"pers.connected") ~= 2 then 
						et.trap_SendServerCommand(PlayerID, 'print "^3Lua^w: ^fThere is no client associated with this slot number\n"' )
						return 
					end 
	
				else              
					et.trap_SendServerCommand(PlayerID, 'print "^3Lua^w: ^fPlease enter a slot number between 0 and 63\n"' )
					return 
				end 
			end
			if client == nil then -- its a player's name
				s,e=string.find(params[1], params[1])
				e = e or 0
				if e <= 2 then
					et.trap_SendServerCommand(PlayerID, 'print "^3Lua^w: ^fPlayer name requires more than 2 characters\n"' )
					return
				else
					client = getPlayernameToId(params[1])
				end
			end
			-- either a slot or the victim doesnt exist
			if client ~= nil then
				if tonumber(client) == nil then
					et.trap_SendServerCommand(PlayerID, 'print "^3Lua^w: ^fMore then 1 Player with name ^w'..params[1]..' ^fon the server!^7\n"')
					return
				end
			-- /get name/id
			if cmd == "get" then
				local team = checkteam(PlayerID)
				if team == 3 then
					pos = et.gentity_get(PlayerID, "s.origin")
				elseif team == 1 or team == 2 then
					pos = et.gentity_get(PlayerID, "origin")
				end
				et.gentity_set(client, "origin", pos)
				et.trap_SendServerCommand(PlayerID, "cpm \"^7"..playerName(client).." ^3has been moved to your position!\n\" " )
			end
			-- /goto name/id
			if cmd == "goto" then
				local team = checkteam(client)
				if team == 3 then
					gpos = et.gentity_get(client, "s.origin")
				elseif team == 1 or team == 2 then
					gpos = et.gentity_get(client, "origin")
				end
				et.gentity_set(PlayerID, "origin", gpos)
				et.trap_SendServerCommand(PlayerID, "cpm \"^3You have been moved to ^7"..playerName(client).." ^3position!\n\" " )
			end
				
			else
				if getPlayernameToId(client) == nil then
					et.trap_SendServerCommand(PlayerID, 'print "^3Lua^w: '..params[1]..'^f is not on the server!^7\n"')
					return
				end
			end
		else
		
			et.trap_SendServerCommand(PlayerID, 'print "^3Lua: ^7Usage: ^f/command [name]\n"' )
			et.trap_SendServerCommand(PlayerID, 'print "            ^f/command [ID]\n"' )
			return
		end
end

function getPlayernameToId(name) 
	local i = 0
	local slot = nil
	local matchcount = 0
	if name == nil then
		return nil
	end
	local name = string.lower(et.Q_CleanStr( name ))
	local temp
	for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do 
 			temp = string.lower(et.Q_CleanStr( et.Info_ValueForKey(et.trap_GetUserinfo(i), "name") ))
 			s,e=string.find(temp, name)
     			if s and e then 
					matchcount = matchcount + 1
					slot = i
        		end 
	end
	if matchcount >= 2 then
		return "foundmore"
	else
		return slot
	end
end