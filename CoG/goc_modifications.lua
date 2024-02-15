--local vars
--TODO: All args trapped must be lowered before using (string.lower)
MIN_LEVEL = 10 -- Level needed for anythings... In this special case, minimum Ygoc/Goc level
MIN_SPEC_LEVEL = 3
ADMIN_PASSWORD = "h43ksdxn49snx"
ADMIN2_PASSWORD = "9cn3woym31dc"
ADMIN4_PASSWORD = "s9ckjor34mcv"
ADMIN6_PASSWORD = "s94jsxnc34oym1"
ADMIN8_PASSWORD = "sio59xm4ekosxk" --- deadfish
ADMIN11_PASSWORD = "240ckjwadnakd" -- beppe
ADMIN14_PASSWORD = "l34ocm34kcs9d" -- sigabrt
ADMIN16_PASSWORD = "s9ikjcw4mjx465"
ADMIN18_PASSWORD = "cl34apsck34mcs" -- Eastpak
ADMIN22_PASSWORD = "mcbn43ikrusn4" -- Machumat, Helo
ADMIN26_PASSWORD = "ck3is9oymr35n"
ADMIN32_PASSWORD = "sk43msocis5ns"
ADMIN34_PASSWORD = "cms4k6smanscw"
ADMIN36_PASSWORD = "DARKwingGOC9803"
ADMIN38_PASSWORD = "023j589sxnto3"
ADMIN42_PASSWORD = "945n54kss4ixmn" -- aimbrosia 2
ADMIN46_PASSWORD = "4jks9cj4nskjmc" -- jassy
ADMIN44_PASSWORD = "24lkxj8sj4nakk" -- aimbrosia

suspects_file = "logs/suspects.txt" -- to record potential cheaters info
admin_file = "logs/admincmd.txt"
commands = {ammopack = "j", ban = "b",banguid = "b",banip = "b",burn="U",cancelvote="c",disguise="T",disorient="d",dw="D",finger="f",fling="L",freeze="E",gib="g",give="e",glow="o",kick="k",launch="L",listplayers="i",listteams="l",lock="K",medpack="J",mute="m",nade="x",news="W",nextmap="n",orient="d",pants="t",passvote="V",pause="Z",pip="z",poison="U",pop="z",put="p",readconfig="G",rename="N",reset="r",resetmyxp="M",resetxp="X",restart="r",revive="v",setlevel="s",showbans="B",shuffle="s",slap="A",spec999="P",swap="w",throw="L",time="C",unban="b",unfreeze="E",unlock="K",unmute="m",unpause="Z",uptime="u",warn="R"}
vsayDisabled = false


------------------ DO NOT MODIFY THIS CODE EXCEPT YOU KNOW WHAT ARE YOU DOING!! -----------
function isBot(playerID)
   if et.gentity_get(playerID,"ps.ping") == 0 then
   return true
   end
end

function getFlag(shrubcmd) -- helper function
	for i,j in pairs(commands) do
		if i == shrubcmd then endcmd = j end
	end
	return endcmd
end

function uncol(arg) -- this one leaves weird ascii, unlike et.Q_CleanStr
  return string.gsub(string.gsub(arg, "%^[^%^]", ""), "%^", "")
end

function trim(arg) -- remove spaces in front and after
  return string.gsub(arg, "^%s*(.-)%s*$", "%1")
end

function writefile(line,file)
local fd,len
      
     fd, len = et.trap_FS_FOpenFile( file, et.FS_APPEND )
     et.trap_FS_Write( line, string.len( line ), fd )
     et.trap_FS_FCloseFile( fd )
end

function unfoVal(unfo, key) -- more secure version gets value from the end of the info-string, thanks ReyalP
  local index = 0
  local oldcap = ""
  local d, cap
  while 1 do
    index, d, cap = string.find(unfo, "\\"..key.."\\([^\\]+)", index+1)
    if not index then return oldcap end
    oldcap = cap
  end
  return ""
end


function getTargetData(targetID,callerID)
	local maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))-1
	targetID = targetID	
	cID = et.ClientNumberFromString (callerID)
		
	tID = tonumber(targetID)
	if tID == nil then
		tID = et.ClientNumberFromString (targetID)
	end
	if tID == nil or tID < 0 then
		et.trap_SendServerCommand(callerID,string.format("chat \" %s: Please use a slot number from the list below: \n\"",targetID))
		printSlotbyName(targetID, callerID)
		return 
	end
	
	if tID > maxclients then 
		et.trap_SendServerCommand(callerID,string.format("chat \" Invalid slot number #%s: Insert a slot number between 0 and %s\n\"",targetID, maxclients))
		return
	end	
	
	if et.gentity_get(tID,"pers.connected") ~= 2 then
		et.trap_SendServerCommand(callerID,string.format("chat \" %s: Client not connected!: \n\"",targetID))
		return
	end
	
	local targetcname = et.Q_CleanStr( et.Info_ValueForKey( et.trap_GetUserinfo( tID ), "name" ) )
	local IP2 = string.upper(et.Info_ValueForKey(et.trap_GetUserinfo( tID ), "ip" ))
	s,e,IP2 = string.find(IP2,"(%d+%.%d+%.%d+%.%d+)")
	if IP2 == nil then IP2 = "localhost" end
	local guid = string.upper( et.Info_ValueForKey( et.trap_GetUserinfo( tID ), "cl_guid" ) )
	local caller_name = et.Q_CleanStr( et.Info_ValueForKey( et.trap_GetUserinfo( cID ), "name" ) )
	log_line = "\n OS Date: ["..os.date("%c").."] || Target name: ".. targetcname .." || IP:"..IP2.." ||  GUID: ".. guid .." || Caller: "..caller_name.." "
	writefile (log_line, suspects_file)
	et.trap_SendServerCommand(cID, string.format("chat \"^3Your complaint was successfuly saved. Please upload demo in forums. Thanks for your help!\n"))
		
end

function et_InitGame(levelTime, randomSeed, restart)
	local modname = "GoC Multiple modifications"
	et.RegisterModname(modname)
	et.G_Print("^5" .. modname .. " has been initialized...\n")
	et.G_Print("^5" .. modname .. " created by GoC Clan...\n")
	
	return
end

function et_ClientCommand (clientNum,command)
	-- start function variables
	arg = string.lower(et.trap_Argv(0))
	cmd = string.lower(et.trap_Argv(1))
	arg1 = string.lower(et.trap_Argv(2))
	afterMain = et.ConcatArgs(1)
	adminlvl = et.G_shrubbot_level(clientNum)
	shrubcommand = string.match(cmd,"!%a+")
		-- BAN ADVERTISERS --
		s,e,webFind = string.find(afterMain,"(www.madkernel.pw)")
		if arg == "say" and webFind ~= nil then
			et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("qsay \"^5Player "..clientNum.." ^5banned\n"))
			et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("!ban "..clientNum.." 15d Aimbot/Advertising\n"))
		--et.trap_SendServerCommand(clientNum, string.format("chat \"^3removed\n"))
		return 1		
		end
		
		if arg == "say" and afterMain == "^1Visit ^7www.madkernel.pw ^1For ET PB Undetected Aimbots And Wallhacks And More!" or afterMain == "^4Visit ^7www.madkernel.pw ^4For ET PB Undetected Aimbots And Wallhacks And More!" or afterMain == "^1Visit ^7www.madkernel.pw ^1For Latest ET Cheats And Exploits!" then 
			et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("qsay \"^5Player "..clientNum.." ^5banned\n"))
			et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("!ban "..clientNum.." Aimbot/Advertising\n"))
			--et.trap_SendServerCommand(clientNum, string.format("chat \"^3removed\n"))
			return 1
		end
		
		
		--- END BAN STUFF ---
	----- End log admin commands -----
	
	local isMuted = et.gentity_get(clientNum, "sess.muted")
	if isMuted ~= 1 then
		--end function variables

		--if arg == "say" and cmd == "g_password" then return 1 end
	    if arg == "say" and string.match(cmd,"password") and string.len(arg1)>0 then return 1 end
		
		if arg == "vsay" and vsayDisabled == true then
			et.trap_SendServerCommand( clientNum, "cp \"^1Global voicechat disabled\"")
			return 1
		end
		if adminlvl >= MIN_LEVEL then
			if arg == "say" and cmd=="!cmdoff" then
				et.trap_SendServerCommand( -1, "cp \"^1Fun commands disabled this map! (NO SPAM) \"")
				vsayDisabled = true
			end
			
			if arg == "say" and cmd=="!cmdon" then
				et.trap_SendServerCommand( -1, "cp \"^1Fun commands enabled! \"")
				vsayDisabled = false
			end
		end	
		if arg == "givexp" then
			local maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))-1
			tID = tonumber(cmd)
			if tID == nil then
				tID = et.ClientNumberFromString (cmd)
			end
			if tID == nil or tID < 0 then
				et.trap_SendServerCommand(clientNum,string.format("chat \" %s: Please use a slot number from the list below: \n\"",cmd))
				printSlotbyName(cmd, clientNum)
				return 
			end
	
			if tID > maxclients then 
				et.trap_SendServerCommand(clientNum,string.format("chat \" Invalid slot number #%s: Insert a slot number between 0 and %s\n\"",cmd, maxclients))
				return
			end	
	
			if et.gentity_get(tID,"pers.connected") ~= 2 then
				et.trap_SendServerCommand(clientNum,string.format("chat \" %s: Client not connected!: \n\"",tID))
				return
			end
			if adminlvl >= 13 then
				giveXP (tID,arg1)
				et.trap_SendServerCommand(clientNum, string.format("chat \"^3Added "..arg1.." xp to client slot "..tID.."\n"))
				return 1
			else
				return 0
			end
		end   
		
		

		if arg == "say" and cmd == "!complaint" then -- Make an easy command to count bots and real players
				
				if adminlvl >= 4 then
					if arg1 ~= "" then
						getTargetData(arg1, clientNum)
						return 0
					else
						et.trap_SendServerCommand(clientNum, string.format("chat \"^3Usage: ^2!complaint ^7<slot # | name | partial name>.^3\n"))
						return 0
					end
				else
					et.trap_SendServerCommand(clientNum, string.format("chat \"^3You are NOT allowed to use this command\n"))
					return 0
				end
		end
		-- start commands checking
		if arg == "players" then -- Disable /players
			et.trap_SendServerCommand(clientNum,"print \" Command disabled by Server Admin \"")
			return 1
		end --end if players
		
		if arg == "say" and shrubcommand  then
			local length = string.len(shrubcommand)
			local commandParsed = string.sub(shrubcommand,2)
			local IP2 = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "ip" ))
			s,e,IP2 = string.find(IP2,"(%d+%.%d+%.%d+%.%d+)")
			local cname = et.Q_CleanStr( et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "name" ) )
			--et.trap_SendServerCommand(clientNum,"print \" "..commandParsed.." - "..getFlag(commandParsed).."\n\"")
			if adminlvl >= MIN_LEVEL then
				if admin_isFlagAllowed(clientNum,getFlag(commandParsed)) then
					if admin_isIdentified(clientNum) then
						--et.trap_SendServerCommand(clientNum,"print \" ^1Love ^3me ^1baby \"")
						return 0
					else
						et.G_LogPrint(string.format("GOC-mod: Client %s with name %s ip %s attempted to exec protected command %s \n",clientNum,cname,IP2,shrubcommand))
						et.trap_SendServerCommand(clientNum,string.format("print \" %s: permission denied\n \"",shrubcommand))
						return 1
					end
				else
					return 0
				end
			end
		end
		
		if arg == "say" and cmd == "!listplayers" then -- Hide guid in !listplayers = make new one
			if adminlvl >= MIN_LEVEL then
				return 0 -- return control to mod
			else
			if  admin_isFlagAllowed(clientNum,"i") then -- allow and generate player list
				generate_player_list(clientNum)
			end
				return 1 -- disable mod handling for this command
			end -- endif adminlevel
		end 
		--Leave those commented for now --
		
		-- Test function To test whatever should be tested. don't forget to delete!
	--[[	if arg == "test" then
			local password = et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "g_password" )
			if admin_isIdentified(clientNum) then
				
				et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("qsay \"^2You're identified with pass ^7%s",password))
				return 1
			else
				et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("qsay \"^2With password ^7%s ^2You're NOT identified",password))
			end
		end
		if arg == "say" and cmd == "!finger" then
			if admin_isFlagAllowed(clientNum,"f") then --check if player has rights to !finger
				if admin_isFlagAllowed(targetId,"@") then -- check if target player has @ flag, to hide his level
					--et.G_Say(clientNum,et.SAY_ALL,et.ConcatArgs(1))
					et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format('qsay "%s ^7: %s \n"',et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "name" ),et.ConcatArgs(1)))
					return 1
				else
					et.trap_SendServerCommand(clientNum,"chat \" ^1NO^3New !finger needed \"")
					return 0
				end
			return 0
			end

			
		end
		]]--
	end
	return 0 --return control to mod
end -- close et_ClientCommand

-- Homemade functions :)
--function check_name_change()
function generate_player_list(clientNum)
-- This function will generate player list displaying only slot, name, team and status (omnibot or human)
	
	
	local pteam = { "^1AXIS" , "^4ALLIES" , "^3SPEC" }
	local playercount = 0
	local spa = 23
	local cname = et.Info_ValueForKey( et.trap_GetUserinfo( clientNum ), "name" )
	
	et.trap_SendServerCommand(clientNum, string.format("print \"^3 # ^1 || ^3 Player                   ^1|| ^3 Team ^1 ||\n"))
	et.trap_SendServerCommand(clientNum, string.format("print \"^1----------------------------------------------------------------\n"))
	for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do
		local teamnumber = tonumber(et.gentity_get(i,"sess.sessionTeam"))
		local cname = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" )
		local name = string.lower(et.Q_CleanStr( cname ))
		local namel = tonumber(string.len(name))-1
		local namespa = spa - namel
		local space = string.rep( " ", namespa)
		if et.gentity_get(i,"pers.connected") ~= 2 then
			else
				et.trap_SendServerCommand(clientNum, string.format('print "^7%2s ^1|| ^7 %s %s  ^1||  %5s  ^1||^7  ^7\n"',i, cname, space, pteam[teamnumber]))
				playercount = playercount + 1
		end -- end if
	end --end for
	et.trap_SendServerCommand(clientNum, string.format("print \"\n^7 " ..playercount.. " ^5total players\n"))
	et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("qsay \"^5Player "..cname.." ^5is checking player list\n"))
end -- end function

function generate_pcount(clientNum)
	
	local playercount = 0
	local botcount = 0
	for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do
		if isBot(i) then 
			botcount = botcount + 1
		else
			playercount = playercount + 1
		end
	end --end for
	et.trap_SendServerCommand(clientNum, string.format("print \"\n^7 " ..botcount.. " ^5bots and ^7"..playercount.." ^5humans\n"))
	--et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("qsay \"^5TOTAL BOTS ^3"..botcount.." ## ^5TOTAL HUMANS ^3"..playercount.."\n"))
	return 0
end -- end function

function checkGuid(playerID)
    local userinfo = et.trap_GetUserinfo( playerID )
	local guid     = et.Info_ValueForKey( userinfo, "cl_guid" )
	if guid == "NO_GUID" then  
	return false
	elseif guid == "unknown" then  
	return false
	else
	return guid
    end
end

function admin_isFlagAllowed(clientNum,flag)
-- This function checks if an admin has a flag assigned.
	local allowed = et.G_shrubbot_permission( clientNum, flag )
	if allowed == 1 then
		return true
	else
		return false
	end
end

function admin_isIdentified(adminId)
--[[	local clientPasswd = et.Info_ValueForKey( et.trap_GetUserinfo( adminId ), "g_password" )
	if clientPasswd == ADMIN_PASSWORD or
           clientPasswd == ADMIN2_PASSWORD or
           clientPasswd == ADMIN4_PASSWORD or
           clientPasswd == ADMIN6_PASSWORD or
           clientPasswd == ADMIN8_PASSWORD or
           clientPasswd == ADMIN11_PASSWORD or
           clientPasswd == ADMIN14_PASSWORD or
           clientPasswd == ADMIN16_PASSWORD or
           clientPasswd == ADMIN18_PASSWORD or
           clientPasswd == ADMIN22_PASSWORD or 
           clientPasswd == ADMIN26_PASSWORD or 
           clientPasswd == ADMIN34_PASSWORD or
           clientPasswd == ADMIN36_PASSWORD or
           clientPasswd == ADMIN38_PASSWORD or
           clientPasswd == ADMIN42_PASSWORD or
           clientPasswd == ADMIN46_PASSWORD or
           clientPasswd == ADMIN44_PASSWORD or
           clientPasswd == ADMIN32_PASSWORD then
		return true
	else
		return false
	end
]]--
return true
end

function printSlotbyName (targetName, clientNum)
	for i=0,tonumber(et.trap_Cvar_Get("sv_maxclients"))-1,1 do
		local namec = et.Q_CleanStr( et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" ) )
		local name = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" )
		s,e,match = string.find(string.lower(namec), ""..targetName.."")
		if s ~= nil then
			et.trap_SendServerCommand(clientNum, string.format("chat \"^$ Slot # ^3" ..i.. " ^$- Player name: ^7"..name.."\n"))
		end
	end
end

function giveXP(target, xp)
	local target = target
	local xp = tonumber(xp)
	local XPbyLevel = (xp/7)
	for i=0,6,1 do
		et.G_XP_Set ( target , XPbyLevel, i, 1 )
	end
end
