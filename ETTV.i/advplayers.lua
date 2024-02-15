----------------------START OF /PLAYERS MODE-------------------------------------- 

-- /players mod:
players_mod = true 
max_nick = 999

--------------------------if u do not force netsettings then leave notes5 empty (notes5 = "")---------

forcedTO_timenudge = 0
forcedTO_snaps = 20
forcedFrom_maxpackets = 100
forcedFrom_rate = 25000
------------------------------------------------------------------------------------------------------

privpass = et.trap_Cvar_Get("sv_privatepassword")
notes1 = "^:#imaFieldop!! [::] (et.splatterLadder.com)\n"
notes2 = "^:This server is running Qmm version 1.1.3\n"
notes3 = "^:ETPro 3.2.6 [ETTV 1.0 linux-i386*]\n"
notes4 = "^:Always remember,KIDS.. the Internet is serious buisness !!\n"
notes5 = "^:TIMENUDGE is forced to " .. forcedTO_timenudge .. ", SNAPS to " .. forcedTO_snaps .. ", MAXPACKETS " .. forcedFrom_maxpackets .. " and RATE " .. forcedFrom_rate .. "\n"
players_msg = "" .. notes1 .. "" .. notes2 .. "" .. notes3 .. "" ..notes4 .. "" .. notes5 .. "\n"

----------------------END OF /PLAYERS MODE-------------------------------------- 


function et_InitGame( levelTime, randomSeed, restart )

----start of vars:
maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )

matched_guids = {}
first_t = {}

prevbname       = {}
nameChangeCount = {}
origin_name     = {}

if auto_userinfocheck then
infocheck_lasttime = 0
infocheck_client = 0
end

----end of vars

if datemod then
et.G_LogPrint(string.format("etpro lua fixed started gametime: %s\n", os.date(time)))
et.trap_SendConsoleCommand( et.EXEC_APPEND, "g_log " .. logfile .. "" .. os.date("%m_%d_%Y") .. ".log\n" ) 
end

end

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
	
	for i=0, maxclients-1, 1 do
	  
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
			    
    	local guid = et.Info_ValueForKey(userinfo,"cl_guid")
		local pass = et.Info_ValueForKey(userinfo,"password")
       
    	cname = cut_nick (cname)
    					
						if ref == 1 then
							state = " ^3REF "
						elseif muted == 1 then
							state = "^5muted"
						elseif pass == privpass and privpass ~= nil	then
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
    local playing = playercount-speccount
		    if PlayerID ~= 1022 then
		    et.trap_SendServerCommand(PlayerID, string.format("print \"^1---------------------------------------------------------------------------------\n\n"))
		  	et.trap_SendServerCommand(PlayerID, string.format('print " ^3%2d     ^7Total    [ ^3%2d ^7playing  ^7\t ^3%3d  ^7spectating  ^7\t ^3%3d   ^7connecting.........  ]\n"',playercount+cntcount,playing,speccount,cntcount))
				et.trap_SendServerCommand(PlayerID, string.format('print "\n^1---------------------------------------------------------------------------------\n\n%s"',players_msg))
				else
				et.G_LogPrint(string.format("\n-------------------------------------------------------------------------------------------------------\n %2d     Total    [ %2d playing  | %3d  spectating  | %3d   connecting.........  ]\n",playercount+cntcount,playing,speccount,cntcount))	
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

function cut_nick (oldname)

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

function et_ClientCommand(cno, cmd)

	-- start of client's cmds mod:

	local  entered_command = string.lower(et.trap_Argv(0))
	
	-- start of /players mod:
	if players_mod then

		if entered_command == "players" then
			advPlayers(cno)
			return 1
		end
	   
	end
	
	return 0
end

function et_ConsoleCommand()
	local con_cmd = string.lower(et.trap_Argv(0))
  
     if con_cmd == "players" and players_mod then
       advPlayers(1022)
       return 1
	end
	
	return 0
end