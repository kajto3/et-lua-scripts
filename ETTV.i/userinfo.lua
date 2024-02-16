--[[

	userinfo.lua
	===================
	by Micha!

	
	Contact:
	--------------------
	http://www.teammuppet.eu
	
	
	Info:
	--------------------
	This lua was made to give a certain level the power to use silent !userinfo and !listplayers (/!userinfo /!listplayers)
	
	This lua was reworked for etpro mod.
	
--]]

Modname = "Userinfo"
Version = "0.7"

--[[
-------------------------------------------------------------------------------------
---------------------------------CONFIG START----------------------------------------
-------------------------------------------------------------------------------------

true means on
false means off

changeable values:
--]]
							
showfullip	=		true	--set true to show full ip of user. set false to show just the first three numbers.

cleanlevelname = 	false	--remove the color codes out of the shrubbot level name using /!userinfo

uncolname = 		false	--remove the color codes out of the player name using /!list and /!userinfo

--shortened listplayers commands
listplayers_cmd = 	"!list"	--(!list !listp !listpl !listpla !listplay !listplaye) will work now. !listplayers shows normal mod list

-------------------------------------------------------------------------------------
-------------------------------CONFIG END--------------------------------------------
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
----------DO NOT CHANGE THE FOLLOWING IF YOU DO NOT KNOW WHAT YOU ARE DOING----------
-------------------------------------------------------------------------------------

et.CS_PLAYERS = 689
clientversion = {}

function et_InitGame(levelTime,randomSeed,restart)
	et.G_Print("["..Modname.."] Version: "..Version.." Loaded\n")
    et.RegisterModname(et.Q_CleanStr(Modname).."   "..Version.."   "..et.FindSelf())
	
	for cno = 0, tonumber( et.trap_Cvar_Get( "sv_maxClients" ) ) - 1 do
		clientversion[cno] = "*unknown*"
	end
end

function et_ClientCommand(client, command)
    local cmd = string.lower(command)
	
		if cmd == "!userinfo" then
			userinfo(cmd,client)
			return 1
		end
	
		if string.find(cmd, "^!list") then
			listplayers(client)
			return 1
		end
	
	if (string.find(et.trap_Argv(0), "^" .. listplayers_cmd .. "") or string.find(et.trap_Argv(1), "^" .. listplayers_cmd .. "") or string.find(et.trap_Argv(1), "^/" .. listplayers_cmd .. "")) and not string.find(et.trap_Argv(1), "^!listplayers") then
		listplayers(client)
		if string.find(et.trap_Argv(1), "^/" .. listplayers_cmd .. "") then
			return 1
		end
	end
	
	return 0
end

function et_ClientConnect( cno, firstTime )
	local userinfo = et.trap_GetUserinfo(cno)
	local protocol = tostring(et.Info_ValueForKey(userinfo, "protocol"))
    if protocol == nil or protocol == "" then
		clientversion[cno] = "*unknown*"
	elseif protocol == "82" then
		clientversion[cno] = "2.55"
	elseif protocol == "83" then
		clientversion[cno] = "2.56"
	elseif protocol == "84" then
		clientversion[cno] = "2.6b"
	end				
end

function userinfo(params,PlayerID)

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
						et.trap_SendServerCommand(PlayerID, 'print "^3Userinfo^w: ^fThere is no client associated with this slot number\n"' )
						return 
					end 
	
				else              
					et.trap_SendServerCommand(PlayerID, 'print "^3Userinfo^w: ^fPlease enter a slot number between 0 and 63\n"' )
					return 
				end 
			end
			if client == nil then -- its a player's name
				s,e=string.find(params[1], params[1])
				e = e or 0
				if e <= 2 then
					et.trap_SendServerCommand(PlayerID, 'print "^3Userinfo^w: ^fPlayer name requires more than 2 characters\n"' )
					return
				else
					client = getPlayernameToId(params[1])
				end
			end
			-- either a slot or the victim doesnt exist
			if client ~= nil then
				if tonumber(client) == nil then
					et.trap_SendServerCommand(PlayerID, 'print "^3Userinfo^w: ^fMore then 1 Player with name ^w'..params[1]..' ^fon the server!^7\n"')
					return
				end
					local userinfo = et.trap_GetUserinfo(client)
    
					if (userinfo ~= "") then
							local ip = et.Info_ValueForKey(userinfo,"ip")
							if PlayerID ~= 1022 and showfullip == false then    
								s, e, ip = string.find( ip, "(%d+%.%d+%.%d+%.)" )
								ip = ""..ip.."*"
							end
						if uncolname then
							name = uncol(et.Info_ValueForKey(userinfo,"name"))
						else
							name = et.Info_ValueForKey(userinfo,"name")
						end
						
						local guid = string.sub(et.Info_ValueForKey(userinfo,"cl_guid"),-8)
						if guid == nil then
							guid = "None"
						end
						local punkbuster = et.Info_ValueForKey(userinfo,"cl_punkbuster")
						if punkbuster == nil then
							punkbuster = "None"
						elseif punkbuster == "1" then
							punkbuster = "Yes"
						else
							punkbuster = "No"
						end
						local protocol = tostring(et.Info_ValueForKey(userinfo, "protocol"))
						if protocol == nil then
							clientversion[client] = "*unknown*"
						end
						local etversion = et.Info_ValueForKey(userinfo,"cg_etVersion")
						if etversion == nil then
							etversion = "None"
						elseif etversion == "" then
							etversion = "*unknown*"
						elseif etversion == 0 then
							etversion = "*OMNIBOT*"
						end
						
						if PlayerID == 1022 then
							et.G_LogPrint(string.format("^/^LUA Userinfo of user ^f"..name.." \n^/Slot Number: ^f"..client.." \n^/ET Version:  ^f"..etversion.."   ^/Client Version: ^f"..clientversion[client].." \n^/Punkbuster:  ^f"..punkbuster.."   ^/GUID: ^f*"..guid.." \n^/IP:   ^f"..ip.." ^7\n"))	
						else	
							et.trap_SendServerCommand(PlayerID, 'print "^/LUA Userinfo of user ^f'..name..' \n^/Slot Number: ^f'..client..' \n^/ET Version:  ^f'..etversion..'   ^/Client Version: ^f'..clientversion[client]..' \n^/Punkbuster:  ^f'..punkbuster..' \n^/GUID: ^f*'..guid..' \n^/IP:^    ^f'..ip..' ^7\n"')
						end
						return
					end
				
			else
				if getPlayernameToId(client) == nil then
					et.trap_SendServerCommand(PlayerID, 'print "^3Userinfo^w: '..params[1]..'^f is not on the server!^7\n"')
					return
				end
			end
		else
		
			et.trap_SendServerCommand(PlayerID, 'print "^3Userinfo: ^7Usage: ^f/!userinfo [name]\n"' )
			et.trap_SendServerCommand(PlayerID, 'print "                 ^f/!userinfo [ID]\n"' )
			return
		end
end


function listplayers(PlayerID)
	
	local playercount = 0
	local speccount = 0
	local cntcount = 0
	local state = ""
	
	if PlayerID ~= 1022 then
		et.trap_SendServerCommand(PlayerID, 'print "^/LUA listplayers:^7\n"')
	end
	
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxClients"))-1, 1 do
	  
		if (et.gentity_get(i,"pers.connected") ~= 0) then
	  
		local team = tonumber(et.gentity_get(i,"sess.sessionTeam"))
		local ref = tonumber(et.gentity_get(i,"sess.referee"))
		local muted = tonumber(et.gentity_get(i,'sess.muted'))
		
    	local userinfo = et.trap_GetUserinfo(i)
    
		if (userinfo ~= "") then
			local privpass = et.trap_Cvar_Get("sv_privatepassword")
			local guid = et.Info_ValueForKey(userinfo,"cl_guid")
			local pass = et.Info_ValueForKey(userinfo,"password")
			if uncolname then
				cname = trim(uncol(et.Info_ValueForKey(userinfo, "name" )))
			else
				cname = trim(et.Info_ValueForKey(userinfo, "name" ))
			end
			
			cname = cut_nick(cname)
    					
			if ref == 1 then
				state = " ^3REF "
			elseif muted == 1 then
				state = "^5muted"
			elseif pass == privpass and privpass ~= nil and privpass ~= "" then
				state = " ^3PRV "
			end
		
			if team == 1 then
				team = "^1R"
			elseif team == 2 then
				team = "^4B"
			else
				team = "^3S"
						               
				if et.gentity_get(i,"pers.connected") == 2 then
					speccount = speccount + 1
				end
						               
			end
			
			if (string.sub (guid, 25,32 )) == "00000000" then
				guid = "000000000000000000000000OMNIBOT*"
			end

			if et.gentity_get(i,"pers.connected") < 2 then
				if PlayerID ~= 1022 then
					et.trap_SendServerCommand( PlayerID, string.format('print "^7%2d ^3>>>>>>>> Connecting <<<<<<<<   ^7(^7*%8s^7)  ^7%-18s %-5s\n"', i, (string.sub (guid, 25,32 )), cname,state  ))
				end
				cntcount = cntcount + 1
							
			else
				if PlayerID ~= 1022 then
					et.trap_SendServerCommand( PlayerID, string.format('print "^7%2d ^7%s ^7(^7*%8s^7)  ^7%-18s %-5s\n"', i, team, (string.sub (guid, 25,32 )), cname, state  ))
				end
				playercount = playercount + 1
								
			end
		
		end
		end
	state = ""
	end

    local playing = playercount-speccount
	if PlayerID ~= 1022 then
		et.trap_SendServerCommand(PlayerID, string.format('print "\n^/%2d ^7Total [ ^/%2d ^7playing, ^/%3d ^7spectating, ^/%3d ^7connecting  ]\n\n"',playercount+cntcount,playing,speccount,cntcount))
	end

end

--helper functions listplayers

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
--

--helper functions userinfo

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