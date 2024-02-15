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
	without granting them to use all commands silently. This may help to get infos about suspicious players.
	
	This lua was tested on etpub and infected mod.
	
--]]

Modname = "Userinfo"
Version = "0.4"

--[[
-------------------------------------------------------------------------------------
---------------------------------CONFIG START----------------------------------------
-------------------------------------------------------------------------------------

true means on
false means off

changeable values:
--]]

useautodetect = true		--use auto detecting (meaning it grants the rights if user is allowed to use flag e/i but not flag 3)
adminlevel = 	6			--gets activated if 'useautodetect = false'
							--grant silent !userinfo and !listplayers at greater/same level as 'adminlevel' value
							
showfullip	=	true		--set true to show full ip of user. set false to show just the first three numbers.

cleanlevelname = false		--remove the color codes out of the shrubbot level name using /!userinfo

-------------------------------------------------------------------------------------
-------------------------------CONFIG END--------------------------------------------
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
----------DO NOT CHANGE THE FOLLOWING IF YOU DO NOT KNOW WHAT YOU ARE DOING----------
-------------------------------------------------------------------------------------

et.CS_PLAYERS = 689
clientversion = {}
local shrubbotfile = et.trap_Cvar_Get( "g_shrubbot" )

function et_InitGame(levelTime,randomSeed,restart)
	et.G_Print("["..Modname.."] Version: "..Version.." Loaded\n")
    et.RegisterModname(et.Q_CleanStr(Modname).."   "..Version.."   "..et.FindSelf())
	
	for cno = 0, tonumber( et.trap_Cvar_Get( "sv_maxClients" ) ) - 1 do
		clientversion[cno] = "*unknown*"
	end
end

function et_ClientCommand(client, command)
    local cmd = string.lower(command)
	
	if et.G_shrubbot_level(client) >= adminlevel and useautodetect == false then
		if cmd == "!userinfo" and et.G_shrubbot_permission( client, "3" ) == 0 and et.G_shrubbot_permission( client, "e" ) == 1 then
			userinfo(cmd,client)
			return 1
		end
	
		if string.find(cmd, "^!list") and et.G_shrubbot_permission( client, "3" ) == 0 and et.G_shrubbot_permission( client, "i" ) == 1 then
			listplayers(client)
			return 1
		end
	elseif useautodetect == true then
		if cmd == "!userinfo" and et.G_shrubbot_permission( client, "3" ) == 0 and et.G_shrubbot_permission( client, "e" ) == 1 then
			userinfo(cmd,client)
			return 1
		end
	
		if string.find(cmd, "^!list") and et.G_shrubbot_permission( client, "3" ) == 0 and et.G_shrubbot_permission( client, "i" ) == 1 then
			listplayers(client)
			return 1
		end
	end
	
	return 0
end

function et_ClientConnect( cno, firstTime, isBot )
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
						if isBot(client) == true then
							ip = "*OMNIBOT*"
						else
							ip = et.Info_ValueForKey(userinfo,"ip")
							if PlayerID ~= 1022 and showfullip == false then    
								s, e, ip = string.find( ip, "(%d+%.%d+%.%d+%.)" )
								ip = ""..ip.."*"
							end
						end
						local name = et.Info_ValueForKey(userinfo,"name")
						local guid = string.sub(et.Info_ValueForKey(userinfo,"cl_guid"),-8)
						if guid == nil then
							guid = "None"
						end
						local mac = et.Info_ValueForKey(userinfo,"mac")
						if mac == nil or mac == "" then
							mac = "None"
						elseif mac == "" then
							mac = "*OMNIBOT*"
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
						local gamename = string.lower(et.trap_Cvar_Get( "gamename"))
						if gamename == "etpub" or gamename == "infected" or gamename == "hideNseek" then
							etversion = et.gentity_get(client,"pers.etpubc")
						else
							etversion = et.Info_ValueForKey(userinfo,"cg_etVersion")
						end
						if etversion == nil then
							etversion = "None"
						elseif etversion == "" then
							etversion = "*unknown*"
						elseif etversion == 0 then
							etversion = "*OMNIBOT*"
						end
						
						local countryCode = et.gentity_get( client, "sess.uci" )
						local countryName = countries[countryCode]

						if countryName then
							country = countryName
						else
							country = countryCode
						end
						
						local level = tonumber(et.G_shrubbot_level(client))
						local levelname = "^/'^f"..shrubbotname(level).."^/'"
						
						if PlayerID == 1022 then
							et.G_LogPrint(string.format("^/^LUA Userinfo of user ^f"..name.."\n^/Slot Number: ^f"..client.." \n^/ET Version:  ^f"..etversion.."   ^/Client Version: ^f"..clientversion[client].." \n^/Punkbuster:  ^f"..punkbuster.."   ^/GUID: ^f*"..guid.." \n^/IP:   ^f"..ip.." \n^/MAC:  ^f"..mac.."  \n^/Country:  ^f"..country.." \n^/Level:    ^f"..level.." ^/- ^f"..levelname.." ^7\n"))	
						else	
							et.trap_SendServerCommand(PlayerID, 'print "^/LUA Userinfo of user ^f'..name..'\n^/Slot Number: ^f'..client..' \n^/ET Version:  ^f'..etversion..'   ^/Client Version: ^f'..clientversion[client]..' \n^/Punkbuster:  ^f'..punkbuster..' \n^/GUID: ^f*'..guid..' \n^/IP:^    ^f'..ip..' \n^/MAC:  ^f'..mac..' \n^/Country:  ^f'..country..' \n^/Level:    ^f'..level..' ^/- ^f'..levelname..' ^7\n"')
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
	local countbots = 0
	local state = ""
	
	if PlayerID ~= 1022 then
		et.trap_SendServerCommand(PlayerID, 'print "^/LUA listplayers:^7\n"')
	end
	
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxClients"))-1, 1 do
	  
		if (et.gentity_get(i,"pers.connected") ~= 0) then
	  
		local team = tonumber(et.gentity_get(i,"sess.sessionTeam"))
		local ref = tonumber(et.gentity_get(i,"sess.referee"))
		local muted = tonumber(et.gentity_get(i,'sess.muted'))
		local level = tonumber(et.G_shrubbot_level(i))
		local levelname = "^/'^7"..et.Q_CleanStr(shrubbotname(level)).."^/'"
		
    	local userinfo = et.trap_GetUserinfo(i)
    
		if (userinfo ~= "") then
					
			local cname = trim(uncol(et.Info_ValueForKey(userinfo, "name" )))
			    
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
					et.trap_SendServerCommand( PlayerID, string.format('print "^7%2d         ^3>>>>>>>> Connecting <<<<<<<<  ^7(^7*%8s^7)  ^7%-18s %5s\n"', i, (string.sub (guid, 25,32 )), cname,state  ))
				end
				cntcount = cntcount + 1
							
			else
				if PlayerID ~= 1022 then
					et.trap_SendServerCommand( PlayerID, string.format('print "^7%2d ^7%s ^7%3s ^7%-30s ^7(^7*%8s^7)  ^7%-18s %5s\n"', i, team, level, levelname, (string.sub (guid, 25,32 )), cname, state  ))
				end
				playercount = playercount + 1
								
			end
			
			if isBot(PlayerID) then
				countbots = countbots + 1
			end
		
		end
		end
	state = ""
	end

    local playing = playercount-speccount
	if PlayerID ~= 1022 then
		et.trap_SendServerCommand(PlayerID, string.format('print "\n^/%2d ^7Total [ ^/%2d ^7playing, ^/%3d ^7spectating, ^/%3d ^7connecting, ^/%3d ^7bots ]\n\n"',playercount+cntcount,playing,speccount,cntcount,countbots))
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

--bot detection
function isBot(playerID)
	local guid = et.Info_ValueForKey(et.trap_GetUserinfo(playerID),"cl_guid")
    if et.gentity_get(playerID,"pers.connected") == 2 and et.gentity_get(playerID,"ps.ping") == 0  and (string.sub (guid, 25,32 )) == "00000000" then
		return true
    end
end

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

function shrubbotname(level)
	local fd,len = et.trap_FS_FOpenFile( ""..shrubbotfile.."", et.FS_READ )
	if len <= 0 then
		et.G_Print("WARNING: No Data Defined! \n")
	else
		
		local filestr = et.trap_FS_Read( fd, len )
		et.trap_FS_FCloseFile( fd )
		
		local getlevel
		local name
		local levelname

		for getlevel, name, levelname in string.gmatch(filestr, "%s%=%s(%d)%s(%a+)%s%s%s%s%s%=%s*([^%\n]*)") do
			if string.find(getlevel, level) then
				if cleanlevelname then
					local levelname = et.Q_CleanStr(levelname)
					return ""..levelname..""
				else
					return ""..levelname..""
				end
			end
		end
	end
	return "*Unknown*"
end

-------//---------------------Country table----------------------------
-------//------------------made by phisherman--------------------------
countries = {
[0]=    "Unknown",
[1]=    "Asia/Pacific Region", 
[2]=    "Europe", 
[3]=    "Andorra", 
[4]=    "United Arab Emirates",
[5]=    "Afghanistan", 
[6]=    "Antigua and Barbuda", 
[7]=    "Anguilla", 
[8]=    "Albania", 
[9]=    "Armenia",
[10]=    "Netherlands Antilles", 
[11]=    "Angola", 
[12]=    "Antarctica", 
[13]=    "Argentina", 
[14]=    "American Samoa",
[15]=    "Austria", 
[16]=    "Australia", 
[17]=    "Aruba", 
[18]=    "Azerbaijan", 
[19]=    "Bosnia and Herzegovina",
[20]=    "Barbados", 
[21]=    "Bangladesh", 
[22]=    "Belgium", 
[23]=    "Burkina Faso", 
[24]=    "Bulgaria", 
[25]=    "Bahrain",
[26]=    "Burundi", 
[27]=    "Benin", 
[28]=    "Bermuda", 
[29]=    "Brunei Darussalam", 
[30]=    "Bolivia", 
[31]=    "Brazil",
[32]=    "Bahamas", 
[33]=    "Bhutan", 
[34]=    "Bouvet Island", 
[35]=    "Botswana", 
[36]=    "Belarus", 
[37]=    "Belize",
[38]=    "Canada", 
[39]=    "Cocos (Keeling) Islands", 
[40]=    "Congo-Kinshasa",
[41]=    "Central African Republic", 
[42]=    "Congo-Brazzaville", 
[43]=    "Switzerland", 
[44]=    "Cote D'Ivoire", 
[45]=    "Cook Islands",
[46]=    "Chile", 
[47]=    "Cameroon", 
[48]=    "China", 
[49]=    "Colombia", 
[50]=    "Costa Rica", 
[51]=    "Cuba", 
[52]=    "Cape Verde",
[53]=    "Christmas Island", 
[54]=    "Cyprus", 
[55]=    "Czech Republic", 
[56]=    "Germany", 
[57]=    "Djibouti",
[58]=    "Denmark", 
[59]=    "Dominica", 
[60]=    "Dominican Republic", 
[61]=    "Algeria", 
[62]=    "Ecuador", 
[63]=    "Estonia",
[64]=    "Egypt", 
[65]=    "Western Sahara", 
[66]=    "Eritrea", 
[67]=    "Spain", 
[68]=    "Ethiopia", 
[69]=    "Finland", 
[70]=    "Fiji",
[71]=    "Falkland Islands (Malvinas)", 
[72]=    "Micronesia", 
[73]=    "Faroe Islands",
[74]=    "France", 
[75]=    "France, Metropolitan", 
[76]=    "Gabon", 
[77]=    "United Kingdom",
[78]=    "Grenada", 
[79]=    "Georgia", 
[80]=    "French Guiana", 
[81]=    "Ghana", 
[82]=    "Gibraltar", 
[83]=    "Greenland",
[84]=    "Gambia", 
[85]=    "Guinea", 
[86]=    "Guadeloupe", 
[87]=    "Equatorial Guinea", 
[88]=    "Greece", 
[89]=    "South Georgia and the South Sandwich Islands",
[90]=    "Guatemala", 
[91]=    "Guam", 
[92]=    "Guinea-Bissau",
[93]=    "Guyana", 
[94]=    "Hong Kong", 
[95]=    "Heard Island and McDonald Islands", 
[96]=    "Honduras",
[97]=    "Croatia", 
[98]=    "Haiti", 
[99]=    "Hungary", 
[100]=    "Indonesia", 
[101]=    "Ireland", 
[102]=    "Israel", 
[103]=    "India",
[104]=    "British Indian Ocean Territory", 
[105]=    "Iraq", 
[106]=    "Iran",
[107]=    "Iceland", 
[108]=    "Italy", 
[109]=    "Jamaica", 
[110]=    "Jordan", 
[111]=    "Japan", 
[112]=    "Kenya", 
[113]=    "Kyrgyzstan",
[114]=    "Cambodia", 
[115]=    "Kiribati", 
[116]=    "Comoros", 
[117]=    "Saint Kitts and Nevis", 
[118]=    "North Korea",
[119]=    "South Korea", 
[120]=    "Kuwait", 
[121]=    "Cayman Islands",
[122]=    "Kazakhstan", 
[123]=    "Laos", 
[124]=    "Lebanon", 
[125]=    "Saint Lucia",
[126]=    "Liechtenstein", 
[127]=    "Sri Lanka", 
[128]=    "Liberia", 
[129]=    "Lesotho", 
[130]=    "Lithuania", 
[131]=    "Luxembourg",
[132]=    "Latvia", 
[133]=    "Libya", 
[134]=    "Morocco", 
[135]=    "Monaco", 
[136]=    "Moldova",
[137]=    "Madagascar", 
[138]=    "Marshall Islands", 
[139]=    "Macedonia",
[140]=    "Mali", 
[141]=    "Burma", 
[142]=    "Mongolia", 
[143]=    "Macau", 
[144]=    "Northern Mariana Islands",
[145]=    "Martinique", 
[146]=    "Mauritania", 
[147]=    "Montserrat", 
[148]=    "Malta", 
[149]=    "Mauritius", 
[150]=    "Maldives",
[151]=    "Malawi", 
[152]=    "Mexico", 
[153]=    "Malaysia", 
[154]=    "Mozambique", 
[155]=    "Namibia", 
[156]=    "New Caledonia",
[157]=    "Niger", 
[158]=    "Norfolk Island", 
[159]=    "Nigeria", 
[160]=    "Nicaragua", 
[161]=    "Netherlands", 
[162]=    "Norway",
[163]=    "Nepal", 
[164]=    "Nauru", 
[165]=    "Niue", 
[166]=    "New Zealand", 
[167]=    "Oman", 
[168]=    "Panama", 
[169]=    "Peru", 
[170]=    "French Polynesia",
[171]=    "Papua New Guinea", 
[172]=    "Philippines", 
[173]=    "Pakistan", 
[174]=    "Poland", 
[175]=    "Saint Pierre and Miquelon",
[176]=    "Pitcairn Islands", 
[177]=    "Puerto Rico", 
[178]=    "Palestinian Territory",
[179]=    "Portugal", 
[180]=    "Palau", 
[181]=    "Paraguay", 
[182]=    "Qatar", 
[183]=    "Reunion", 
[184]=    "Romania",
[185]=    "Russian Federation", 
[186]=    "Rwanda", 
[187]=    "Saudi Arabia", 
[188]=    "Solomon Islands",
[189]=    "Seychelles", 
[190]=    "Sudan", 
[191]=    "Sweden", 
[192]=    "Singapore", 
[193]=    "Saint Helena", 
[194]=    "Slovenia",
[195]=    "Svalbard and Jan Mayen", 
[196]=    "Slovakia", 
[197]=    "Sierra Leone", 
[198]=    "San Marino", 
[199]=    "Senegal",
[200]=    "Somalia", 
[201]=    "Suriname", 
[202]=    "Sao Tome and Principe", 
[203]=    "El Salvador", 
[204]=    "Syria",
[205]=    "Swaziland", 
[206]=    "Turks and Caicos Islands", 
[207]=    "Chad", 
[208]=    "French Southern Territories",
[209]=    "Togo", 
[210]=    "Thailand", 
[211]=    "Tajikistan", 
[212]=    "Tokelau", 
[213]=    "Turkmenistan",
[214]=    "Tunisia", 
[215]=    "Tonga", 
[216]=    "Timor-Leste", 
[217]=    "Turkey", 
[218]=    "Trinidad and Tobago", 
[219]=    "Tuvalu",
[220]=    "Taiwan", 
[221]=    "Tanzania", 
[222]=    "Ukraine",
[223]=    "Uganda", 
[224]=    "United States Minor Outlying Islands", 
[225]=    "United States", 
[226]=    "Uruguay",
[227]=    "Uzbekistan", 
[228]=    "Holy See (Vatican City State)", 
[229]=    "Saint Vincent and the Grenadines",
[230]=    "Venezuela", 
[231]=    "Virgin Islands, British", 
[232]=    "Virgin Islands, U.S.",
[233]=    "Vietnam", 
[234]=    "Vanuatu", 
[235]=    "Wallis and Futuna", 
[236]=    "Samoa", 
[237]=    "Yemen", 
[238]=    "Mayotte",
[239]=    "Serbia", 
[240]=    "South Africa", 
[241]=    "Zambia", 
[242]=    "Montenegro", 
[243]=    "Zimbabwe",
[244]=    "Anonymous Proxy",
[245]=    "Satellite Provider",
[246]=    "Other",
[247]=    "Aland Islands",
[248]=    "Guernsey",
[249]=    "Isle of Man",
[250]=    "Jersey",
[251]=    "Saint Barthelemy",
[252]=    "Saint Martin",
[255]=    "Localhost",
}