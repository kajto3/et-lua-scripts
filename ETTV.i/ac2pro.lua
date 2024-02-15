	
	modname    	=   "ACpro"
	modver 		= 	"2.1"
	modupdate   =   "2014-01-08"
	modauthor  	=   "Luk4ward"
	modtester   =   "rEhearsal"
	modinfo     =   "AC.mod for etpro"

--[[---------------------------------------------------[[--

	README, DOWNLOAD, CONTACT, INFO WITH SCREENIES: 
	http://wolfwiki.anime.net/index.php/User:Luk4ward
  
-----------------------Credits:----------------------------

	GamesNet.pl for hosting & all people connected with eT.Team.pro,
	Reyalp (for the codes and fixes),
	=FF=im2good4u (for the ip idea and help on bani's board),
	McSteve (for all the help and scripts),
	Clutch (Kmod: advanced players),
	Hadro (MiniPB Extension: name limit)
	Deus
	Smileman. (for giving us info about etadmin mod level exploit)
	
	and other people who posted their codes

------------------------RCON commands:------------------

	add <guid/mask> <nick> <ip> <admin>
	ping2spec <ping>
	rename <ID> <newnick/clean/cutnick>
	players
	checkuserinfo <id>
	
	for more info check my profile @ wolfwiki

--]]---------------------------------------------------]]--

-----------------------Settings editable:----------------------------

----------------------------admins tag----------------------------------------------
-- if your clan tag (must be > 3) is not protected via etadmin or punkbuster then leave this empty
-- 		coz players with this tag will not be checked at all

admins_tag = ""

------------------------------------------------------------------------------------

----------------------START OF FILTERLOG-------------------------------------- 

--bantime = tonumber(et.trap_Cvar_Get("b_defaultbantime")) (comment this out to get the bantime from your etpro server settings)
bantime = 0
contact_reason = "Contact Admin with Your /pb_myguid and IP"

-- mode 1 will check against the first part of IP (like 83.)
-- mode 2 will check against the first two parts of IP (like 83.60.)
-- mode 4 will check against the first part of IP (like 83.)
--             and allow to join only from the added players of your added FilterMasks
--             example:
--             1) player from 1.2.3.4 is connecting
--             2) script not found a filename [1_.dat] from ipbans/ with his IP
--			   3) script refused entry
--             4) admin is adding FilterMask for ip 1.2.3.4 via rcon
--             5) player from 1.2.3.4 is connecting
--             6) script not found his GUID in the filename [1_.dat] from ipbans/ of his IP
--			   7) script refused entry
--             8) admin is adding his guid for ip 1.2.3.4 via rcon
--             9) player from 1.2.3.4 is connecting
--             10) script found his GUID in the filename [1_.dat] from ipbans/ of his IP
--			   11) script allowed to join the sever

filter_mode = 2

----------------------END OF FILTERLOG-------------------------------------- 	  

----------------------START OF NAME------------------------------------- 

-- per map name changes
-- if player reached a limit then his nick will be set to the original nick from the beginning 
--    instead of kicking and info will be shown
-- set to unlimited: -1

max_name_changes = 3 

-- u can set the number after reaching the max_name_changes limit 
--       of changing nicks after which the player will be kicked 
--                                           (useful if u dnt want the spam @ console about name changes)

kick_limit_name_changes = 3

-- set min and max length of player's nick allowed on your server 
--             (length is based on the number of chars, will not count spaces or color codes):

min_nick_len = 3
max_nick_len = 25

----------------------END OF NAME-------------------------------------- 

----------------------START OF EXEC MODE-------------------------------------- 

-- execmod (enabling aggresive mode on warmup and normal mode while playing):

execmod = true

warmup_antiloop = true
warmup_exec_cfg = "pb_aggressive.cfg"
playing_antiloop = true
playing_exec_cfg = "pb_normal.cfg"

----------------------END OF EXEC MODE-------------------------------------- 

----------------------START OF LOGDATE MODE-------------------------------------- 

-- date&time mod: will print to the console log file every map a line with date and time
--                also creating new etserver log each day with the data at the end, example: etserver_02_21_2008.log
--                remember its a server log not console log which is using by etadmin mod !

datemod = true

logfile = "logs/etserver_" -- without extension !

----------------------END OF LOGDATE MODE-------------------------------------- 

----------------------START OF HI MODE-------------------------------------- 

himod = false

-- its running once only when player connected to the server:

hi_msg = "^3Server is running^7: " .. modauthor .. "'s ^5" .. modname .. " ^7Version ^1" ..  modver .. "\n updated @ " .. modupdate .. "" 

----------------------END OF HI MODE-------------------------------------- 

----------------------START OF /PLAYERS MODE-------------------------------------- 

-- /players mod:
players_mod = false
max_nick = 15

--------------------------if u do not force netsettings then leave notes5 empty (notes5 = "")---------

forcedTO_timenudge = 0
forcedTO_snaps = 20
forcedFrom_maxpackets = 76 
forcedFrom_rate = 15000
------------------------------------------------------------------------------------------------------

privpass = et.trap_Cvar_Get("sv_privatepassword")
notes1 = "^2NOTES:\n^2Use Client id to kick a player from your team by typing in console: /callvote kick id\n"
notes2 = "^2Use PBid to kick a player via Power Points by typing in console: /pb_kick PBid\n"
notes3 = "^2To see ETPRO GUID type in console: /guids or /cheaters\n"
notes4 = "^2Always remember to compare the data with /yawn and /pb_plist results !\n\n"
notes5 = "^2CL_TIMENUDGE is forced to " .. forcedTO_timenudge .. ", SNAPS to " .. forcedTO_snaps .. ", CL_MAXPACKETS from " .. forcedFrom_maxpackets .. " and RATE from " .. forcedFrom_rate .. " so do not blame others about net settings!\n"
notes6 = "^2To condump all info type in console: /condump players.txt\n\n"
warn1 = "^iWARNINGS:\n^iThe data can be SPOOFED, if you spot this situation contact administration as soon as possible!\n"
warn2 = "^iThe only GUID which is NOT SPOOFABLE is from /pb_plist!\n\n"
players_msg = "" .. notes1 .. "" .. notes2 .. "" .. notes3 .. "" ..notes4 .. "" .. notes5 .. "" .. notes6 .. "" .. warn1 .. "" .. warn2 .. "\n"

----------------------END OF /PLAYERS MODE-------------------------------------- 

----------------------START OF combinedfixes.lua-------------------------------- 
-- source: http://bani.anime.net/banimod/forums/viewtopic.php?t=6777
----------------------------------------------------------------------

--  prevent various borkage by invalid userinfo
-- version: 4
-- history:
--  4 - check length and IP
--  3 - check for name exploit against guidcheck
--  2 - fix nil var ref if kicked in RunFrame
--      fix incorrect clientNum in log message for ClientConnect kick
--  1 - initial release

-- names that can be used to exploit some log parsers 
--  note: only console log parsers or print hooks should be affected, 
--  game log parsers don't see these at the start of a line
-- "^etpro IAC" check is required for guid checking
-- comment/uncomment others as desired, or add your own
-- added names, len checking and searching for extra carat char
-- NOTE: these are patterns for string.find

badnames = {
	'^ShutdownGame',
	'^ClientBegin',
	'^ClientDisconnect',
	'^ExitLevel',
	'^Timelimit',
	'^EndRound',
    '^etpro IAC',     -- <-- DO NOT REMOVE THIS
	'^etpro privmsg',
-- "say" is relatively likely to have false positives
-- but can potentially be used to exploit things that use etadmin_mod style !commands
	'^say',
	'^Callvote',
	'^broadcast',
-- do not want default, stupid, nazi names like
	'player',
	'name',
	'hitl',
	'lenin',
	'stalin',
	'adol',
	'bot',
	'hax',
	'cock',
	'dick',
	'cunt',
	'gay',
	'nazi',
	'satan',
	'fuck',
	'suck',
	'hack',
	'wall',
	'count',
	'penis',
	'vagina',
	'bitch',
	'piss',
	'cheat',
	'netcoder',
	'hrer',
	'jew',
	'kike',
	'nigg',
	'genocide',
	'teammate',
	'test',
	'tit',
	'ref',
	'root',
	'server',
	'lol',
	'rotfl',
	'omg',
	'omfg',
	'stfu',
-- do not want random names with 3 same chars in the nick (prevents from name generators)	
	'!!!',
	'"""',
	'###',
	'$$$',
	'&&&',
	')))',
	'+++',
	',,,',
	'000',
	'111',
	'222',
	'333',
	'444',
	'555',
	'666',
	'777',
	'888',
	'999',
	':::',
	';;;',
	'<<<',
	'===',
	'>>>',
	'@@@',
	'___',
	'```',
	'aaa',
	'abc',
	'bbb',
	'ccc',
	'ddd',
	'eee',
	'fff',
	'ggg',
	'hhh',
	'iii',
	'jjj',
	'kkk',
	'lll',
	'mmm',
	'nnn',
	'ooo',
	'ppp',
	'qqq',
	'rrr',
	'sss',
	'ttt',
	'uuu',
	'vvv',
	'www',
	'xxx',
	'yyy',
	'zzz',
	'{{{',
	'|||',
	'}}}',
	'~~~',
-- polish bad names
    'cip',
	'czit',
	'dziwka',
	'gej',
	'gram',
	'huj',
	'jeb',
	'kloc',
	'kup',
	'kurw',
	'kutafon',
	'menda',
	'penis',
	'pier',
	'pizd',
	'pleb',
	'pyr',
	'qrwa',
	'qtas',
	'rucha',
	'ryp',
	'serwer',
	'szma',
	'szukam',
	'tampon',
	'ucze',
	'wydym',
	'warzyw',
	'zal'
  }

-- 3.2.6 and earlier doesn't actually call et_ClientUserinfoChanged 
-- every time the userinfo changes, 
-- so we use et_RunFrame to check every so often
-- comment this out or adjust to taste

-- set it to false if u want to manually check userinfo
-- remember that user info is checking @ client connect and @ client user info changed so quite often
--                   and u can do it manually via rcon: checkuserinfo <id>

auto_userinfocheck = false 

-- if auto is enabled then set how often script will check a client (default 5 seconds)

infocheck_freq = 5000 -- 5 seconds

-- lua module to prevent guid borkage
-- version: 1
-- author: reyalp@gmail.com
-- TY pants
-- lua module to limit fakeplayers DOS
-- http://aluigi.altervista.org/fakep.htm
-- used if cvar is not set
-- author: reyalp@gmail.com
-- confugration:
-- set ip_max_clients cvar as desired. If not set, defaults to the value below.
--FAKEPLIMIT_VERSION = "1.0"

DEF_IP_MAX_CLIENTS = 2

-------------------------------------changed by Luk4ward:---------------------------------------------------------------
log_badguids = true -- includes cl_guid
log_okeguids = true -- only eguids

logfile_badguids = "logs/bad_guids.log"
logfile_okeguids = "logs/ok_eguids.log"

-- check file logfile_badguids for the names, date and IPs of people with spoofed guids (cl_guids and etpro guids)
-- check file okeguids for the names, date and IPs of people with ok etpro guids (no etadmin format)

----------------------END OF combinedfixes.lua-------------------------------- 

----------------------DO NOT EDIT ANYTHING UNDER THIS LINE !!!-------------------------------------- 
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

et.RegisterModname( "" .. modname .. ":" .. modver .. "slot:" .. et.FindSelf())
et.G_Print(modauthor .. "'s " .. modname .. " Version " ..  modver .. " (updated @ " .. modupdate .. "): " .. modinfo .. " \n")
et.trap_SendConsoleCommand(et.EXEC_APPEND,string.format("forcecvar mod_version \"%s ^%%" .. modname .. " %s\"",et.trap_Cvar_Get("mod_version"),modver))

end

function et_RunFrame(leveltime) 

if execmod then	

	gstate = tonumber(et.trap_Cvar_Get( "gamestate" ))
	
		if (gstate == 0) then
		   
		   if playing_antiloop then              
		         
					   et.trap_SendConsoleCommand(et.EXEC_NOW, "exec " .. playing_exec_cfg .. "")
         	   playing_antiloop = false
		   end               	   
		            	   
		 elseif (gstate == 1) or (gstate == 2) or (gstate == 4) then   
		 
		      if warmup_antiloop then           
		      		et.trap_SendConsoleCommand(et.EXEC_NOW, "exec " .. warmup_exec_cfg .. "")    
		          warmup_antiloop = false
		      end
		end     	   	   
end

	if auto_userinfocheck then
	
	--et.G_LogPrint(string.format("infocheck %d %d\n", infocheck_client, leveltime))

		if ( infocheck_lasttime + infocheck_freq > leveltime ) then
				return
			end
		
		  --printf("infocheck %d %d\n", infocheck_client, leveltime)
		  
			infocheck_lasttime = leveltime
			if ( et.gentity_get( infocheck_client, "inuse" ) ) then
			  local freq_userinfo = et.trap_GetUserinfo( infocheck_client )
			  if freq_userinfo ~= nil then
			      local name = trim(string.lower( uncol (unfoVal( freq_userinfo, "name" ) ) ) )
			         if ((string.find( name, admins_tag )) == nil) or (string.len(admins_tag) < 1) then 
									local reason = check_userinfo( infocheck_client, freq_userinfo )
									if ( reason ) then
										et.G_LogPrint(string.format("userinfocheck frame: %d ) client [ %s ] bad userinfo %s\n",infocheck_client,name,uncol(reason)))
										et.trap_SetUserinfo( infocheck_client, "name\\badinfo" )
										--et.trap_DropClient( infocheck_client, "bad userinfo", 0 )
										DropClient4reason (infocheck_client,reason,bantime)
									--else	
									--et.G_LogPrint(string.format("userinfocheck frame: %d ) client [ %s ] OK userinfo \n",infocheck_client,name))
									end
							 end	
				 else
				 et.G_LogPrint(string.format("userinfocheck frame: client %d no userinfo %s\n",infocheck_client,reason))
				 return
				end 		
			end
			
			infocheck_client = infocheck_client + 1
	    if ( infocheck_client >= tonumber(et.trap_Cvar_Get("sv_maxclients")) ) then
		  infocheck_client = 0
	    end

	end
	   
end  

function et_ClientConnect( clientNum, firstTime, isBot )

	local conn_userinfo = et.trap_GetUserinfo( clientNum )
	
 if conn_userinfo ~= nil then
	
	local name = unfoVal( conn_userinfo, "name" )
	local stripped_name = trim(string.lower( uncol (name) ))
		 
  		 first_t[clientNum] = firstTime

  		 if max_name_changes > 0 then
  
  		 origin_name[clientNum] = 	name
  		 prevbname[clientNum] = stripped_name
  		 nameChangeCount[clientNum] = 0
  
  		 --et.G_LogPrint(string.format("userinfocheck connect: client %d cnt @ " .. os.date(time) .. " \n",clientNum))
  
  		 end
  
	if ((string.find( stripped_name, admins_tag )) == nil) or (string.len(admins_tag) < 4) then
	
			local reason = check_userinfo( clientNum, conn_userinfo )
			if ( reason ) then
				et.G_LogPrint(string.format("userinfocheck connect: %d ) client [ %s ] bad userinfo %s\n",clientNum,name,uncol(reason)))
				return reason
			--else	
	        --et.G_LogPrint(string.format("userinfocheck connect: %d ) client [ %s ] OK userinfo \n",infocheck_client,name))	
			end
		
			-- note IP validity should be enforced by userinfocheck stuff
			local ip = IPForClient( clientNum )
			
			if not ip then
			   et.G_LogPrint(string.format("userinfocheck connect: %d ) client [ %s ] missing IP or userinfo\n",clientNum,name))
			   return "missing IP or userinfo"
			else   
			
			local count = 1 -- we count as the first one
			local max = DEF_IP_MAX_CLIENTS
			-- et.G_Printf("firstTime %d\n",firstTime);
			-- it's probably safe to only do this on firsttime, but checking
			-- every time doesn't hurt much
			
			-- validate userinfo to filter out the people blindly using luigi's code
			local userinfo = et.trap_GetUserinfo( clientNum )
			-- et.G_Printf("userinfo: [%s]\n",userinfo)
			if et.Info_ValueForKey( userinfo, "rate" ) == "" then 
				et.G_Printf("fakeplimit.lua: invalid userinfo from %s\n",ip)
				return "invalid connection"
			end
		
			for i = 0, et.trap_Cvar_Get("sv_maxclients") - 1 do
				-- pers.connected is set correctly for fake players
				-- can't rely on userinfo being empty
				if i ~= clientNum and et.gentity_get(i,"pers.connected") > 0 and ip == IPForClient(i) then
					count = count + 1
					if count > max then
						et.G_Printf("fakeplimit.lua: too many connections from %s\n",ip)
						-- TODO should we drop / ban all connections from this IP ?
						return string.format("only %d connections per IP are allowed on this server",max)
					end
				end
			end
			
			--filtercheck
			if (first_t[clientNum] == 1) then
		         et.G_LogPrint(string.format("filtercheck: client %d cnt 1st time @ " .. os.date(time) .. " \n",clientNum)) 
		         local filter_reason = Filter( clientNum, conn_userinfo )
		                	
								if ( filter_reason ) then
								return filter_reason
								end
		    end  
          end
    end
  
 else
 return "bot"
 end

end

function et_Print( text )

	check_guid_line(text) 

end

function Filter( clientNum, userinfo )

et.G_LogPrint(string.format("running script for client %d @ " .. os.date(time) .. " \n",clientNum)) 

  matched_guids[clientNum] = 0  

  local s, e, i, cname, name, pbguid, ip, fd, len, line
  
  pbguid = string.upper( et.Info_ValueForKey( userinfo, "cl_guid" ) )
  
  ip = et.Info_ValueForKey( userinfo, "ip" )
  
    s, e, ip = string.find( ip, "(%d+%.%d+%.%d+%.%d+)" )
    
    if filter_mode == 2 then
    s, e, ip_pub = string.find( ip, "(%d+%.%d+%.)" )
    elseif filter_mode ~= 2 then
    s, e, ip_pub = string.find( ip, "(%d+%.)" )
    ip_pub = "" .. ip_pub .. "*."
    end
  
  cname = et.Info_ValueForKey( userinfo, "name" )
  name = uncol ( cname )
   
local cl_guid, comment, filename, filestr

et.G_LogPrint(string.format("filtercheck: mode " .. filter_mode .. " \n"))

convert_ip = ip2filename(ip_pub)

filename = "ipbans/" .. convert_ip .. ".dat"

  fd, len = et.trap_FS_FOpenFile( filename, et.FS_READ )
  
  et.G_LogPrint(string.format("filtercheck: opening " .. filename .. " \n"))
  
  if len ~= -1  then 
  
  et.G_LogPrint(string.format("filtercheck: found file for the IP of this client %d !\n",clientNum))
      
      matched_guids[clientNum] = matched_guids[clientNum] - 1
             
        filestr = et.trap_FS_Read(fd, len)
                                                                          
          for cl_guid, comment in string.gfind(filestr, "([^\r\n#=]%x+)=([^\r\n#=]+)") do                                             
           
            if ( pbguid == string.upper(cl_guid) ) then 
            
            matched_guids[clientNum] = matched_guids[clientNum] + 2 
            break  
            end
            
        end          
        
  elseif len == -1 and filter_mode == 4 then
        
  matched_guids[clientNum] = matched_guids[clientNum] - 1
  et.G_LogPrint(string.format("filtercheck: not found file for the IP of this client %d, refuse entry ! \n",clientNum))
        
  end
  
  et.trap_FS_FCloseFile(fd)
  et.G_LogPrint(string.format("filtercheck: closing " .. filename .. " \n"))
  
  local filter_file, filter_line, print_line, filter_reason
  
  if matched_guids[clientNum] == 0 then
  
     filter_file = "logs/players.log"  
     filter_line = "\n[logged @ " .. os.date("%c") .. "]\nname    = " .. name .. "\nguid    = " .. pbguid .. "\nyawn    = http://www.yawn.be/findPlayer.yawn?gamecode=ET&pbGuid=" .. (string.sub (pbguid, 25,32 )) .. "\nip      = " .. ip .. "\nreason  = data logged\nmade    = " .. os.date("%x %X") .. "\nexpires = 0\nbanner  = admin\n"
     print_line = "filtercheck: client " .. clientNum .. " ok, more info @ " .. filter_file .. " !\n"
          
     elseif matched_guids[clientNum] > 0 then
     
     filter_file = "logs/accepted_players.log"
     print_line = "filtercheck: client " .. name .. " accepted with cl_guid [ " .. pbguid .. " ] @ ip [ " .. ip .. " ] | more info @ " .. filter_file .."\n"
     filter_line = "\n[Guid accepted from banned IP @ " .. os.date("%c") .. "]\nname    = " .. name .. "\nguid    = " .. pbguid .. "\nyawn    = http://www.yawn.be/findPlayer.yawn?gamecode=ET&pbGuid=" .. (string.sub (pbguid, 25,32 )) .. "\nip      = " .. ip .. "\nmade    = " .. os.date("%x %X") .. "\n"
     msg = string.format("cpmsay  \"" .. cname ..  " ^7was ^2accepted ^7from IP [ " .. ip_pub .. "*.* ]\n")
     et.trap_SendConsoleCommand(et.EXEC_APPEND, msg)
        
     elseif matched_guids[clientNum] < 0 then
     
     filter_file = "logs/not_accepted_players.log"
     print_line = "filtercheck: client " .. name .. " NOT accepted with cl_guid [ " .. pbguid .. " ] @ ip [ " .. ip .. " ] | more info @ " .. filter_file .."\n"
     et.G_LogPrint(string.format(print_line))
     filter_line = "\n[Guid NOT accepted from banned IP @ " .. os.date("%c") .. "]\nname    = " .. name .. "\nguid    = " .. pbguid .. "\nyawn    = http://www.yawn.be/findPlayer.yawn?gamecode=ET&pbGuid=" .. (string.sub (pbguid, 25,32 )) .. "\nip      = " .. ip .. "\nmade    = " .. os.date("%x %X") .. "\n"
     writefile(filter_line,filter_file)
     filter_reason = "    ^7You are ^1NOT ^1accepted ^7from banned IP ^g[ " .. ip_pub .. "*.* ]^7 - " .. contact_reason .. "\n"
     
     return filter_reason            
   
  end 
  
  if himod then
  et.trap_SendServerCommand(clientNum,"cp \" "..hi_msg.." \n\"")
  end
  
  et.G_LogPrint(string.format(print_line))
  writefile(filter_line,filter_file)
  
end

function ip2filename(ip)

local s,e,ip_find,convert_ip, pattern = nil

	if filter_mode == 2 then
	   pattern = "(%d+%.%d+%.)"
	elseif filter_mode ~= 2 then
	   pattern = "(%d+%.)"
	end

			if ((string.find( ip, pattern )) ~= nil) then
			
 			    s, e, ip_find = string.find( ip, pattern )

					if ip_find ~= nil then
					--et.G_LogPrint(string.format("ip " .. ip .." \n"))
    		        convert_ip = string.gsub(ip_find, "%.+", "_")
    		        --et.G_LogPrint(string.format("ip after convert " .. string.gsub(ip, "%.+", "_") .." \n"))
					else
					et.G_LogPrint("\nThe Command (check for spaces) or IP (check for dots) You entered is wrong!\n")
					et.G_LogPrint("Examples by typing: add\n")
					convert_ip = "badIP#1_badIP#2_"
             		end

			else

            et.G_LogPrint("\nThe Command (check for spaces) or IP (check for dots) You entered is wrong!\n")
			et.G_LogPrint("Examples by typing: add\n")
			convert_ip = "badIP#1_badIP#2_"

			end


return convert_ip

end

function et_ClientUserinfoChanged(cn)

local changed_userinfo = et.trap_GetUserinfo( cn )
	 if changed_userinfo ~= nil then
		local name = trim(string.lower( uncol (et.Info_ValueForKey(changed_userinfo, "name" ) ) ) )

			if ((string.find( name, admins_tag )) == nil) or (string.len(admins_tag) < 1) then
			   local reason = check_userinfo( cn, changed_userinfo )

						if ( reason ) then
						et.G_LogPrint(string.format("userinfocheck infochanged: %d ) client [ %s ] bad userinfo %s\n",cn,name,uncol(reason)))
						et.trap_SetUserinfo( cn, "name\\badinfo" )
						DropClient4reason (cn,reason,bantime)
						return
						--else
						--et.G_LogPrint(string.format("userinfocheck infochanged: %d ) client [ %s ] OK userinfo \n",infocheck_client,name))
						end

						if max_name_changes > 0 then
						  local name = unfoVal(changed_userinfo, "name")
						  et.G_LogPrint(string.format("userinfocheck infochanged: %d ) client [ %s ] \n",cn,name))
						  verifyName(cn, name)
						end

			end
	end
	
end

function et_ClientDisconnect(clientNum)

matched_guids[clientNum] = 0
	 
	 if max_name_changes > 0 then
	 prevbname[clientNum] = nil
   	 nameChangeCount[clientNum] = 0
     origin_name[clientNum] = nil
     end
   
end

function et_ConsoleCommand()

local con_cmd = string.lower(et.trap_Argv(0))
local arg1 = et.trap_Argv(1)
local arg2 = et.trap_Argv(2)
local arg3 = et.trap_Argv(3)
local arg4 = et.trap_Argv(4)
local argcount = et.trap_Argc()
local arg_from2 = et.ConcatArgs(2)
local ret
  
       if con_cmd == "add" then 
       
          if argcount < 4  then
                if filter_mode == 2 then
                et.G_LogPrint(string.format("Examples depend on filter_mode [activated: " .. filter_mode .. "] -> enter 2 first parts of IP (with 2 dots: one after each number) !\n"))
                elseif filter_mode ~= 2 then
                et.G_LogPrint(string.format("Examples depend on filter_mode [activated: " .. filter_mode .. "] -> enter 1st part of IP (with 1 dot after the number) !\n"))
                end
     			et.G_LogPrint("\nUsage:     add             cl_guid                 nick        ip           by\n")
   	  			   if filter_mode == 2 then
	  			   et.G_LogPrint("Example#1: add GUIDGUIDGUIDGUIDGUIDGUIDGUIDGUID clean_player 83.100.      admin\n")
	  			   et.G_LogPrint("Example#2: add GuidGuidGUIDGUIDGUIDGuidGUIDGUID clean_player 83.100.123.  admin\n")
	  			   et.G_LogPrint("Example#3: add GUIDGUIDGUIDGUIDGUIDGUIDGUIDGUID clean_player 83.100.100.5 admin\n")
	  			   elseif filter_mode ~= 2 then
	  			   et.G_LogPrint("Example#1: add GUIDGUIDGUIDGUIDGUIDGUIDGUIDGUID clean_player 83.          admin\n")
	  			   et.G_LogPrint("Example#2: add GuidGuidGUIDGUIDGUIDGuidGUIDGUID clean_player 83.100.      admin\n")
	  			   et.G_LogPrint("Example#3: add GUIDGUIDGUIDGUIDGUIDGUIDGUIDGUID clean_player 83.100.123.  admin\n")
	  			   et.G_LogPrint("Example#4: add GuidGuidGUIDGUIDGUIDGuidGUIDGUID clean_player 83.100.100.5 admin\n")
	  			   end
	  			et.G_LogPrint("\nUsage:     add mask cheater     ip        by\n")
              	   if filter_mode == 2 then
	  			   et.G_LogPrint("Example#1: add mask cheater 83.100.      admin\n")
	  			   et.G_LogPrint("Example#2: add mask cheater 83.100.123.  admin\n")
	  			   et.G_LogPrint("Example#3: add mask cheater 83.100.100.5 admin\n")
	  			   elseif filter_mode ~= 2 then
	  			   et.G_LogPrint("Example#1: add mask cheater 83.          admin\n")
	  			   et.G_LogPrint("Example#2: add mask cheater 83.100.      admin\n")
	  			   et.G_LogPrint("Example#3: add mask cheater 83.100.123.  admin\n")
	  			   et.G_LogPrint("Example#4: add mask cheater 83.100.100.5 admin\n")
	  			   end
	  			else
	  			add(arg1,arg2,arg3,arg4)
	  	 		end
          return 1
          
       elseif con_cmd == "rename" then 
       
           if (argcount < 2) or (arg1 == "") then
              et.G_LogPrint("Usage: rename ID newnick\n")
              et.G_LogPrint("Example#1 (to clean the nick): rename ID clean\n")
              et.G_LogPrint("Example#2 (to cut the nick): rename ID cutnick\n")
           else
				ret = getclient (arg1)
				if ret then
				et.G_LogPrint(ret)
				else
				RenameUser(arg1,arg_from2)
                end
           end
           return 1
           
       elseif con_cmd == "players" and players_mod then
       advPlayers(1022)
       return 1
       
       elseif con_cmd == "ping2spec" then
       
              if (arg1 == "0") or (arg1 == "") then
              et.G_LogPrint("Usage: ping2spec [ ping >0 ]\n")
              else
              arg1 = tonumber(arg1)
              ping2spec(arg1)       
   		  	  end
   		  	  return 1
   		  		  
   		 elseif con_cmd == "checkuserinfo" then
   		      if (argcount < 2) or (arg1 == "") then
   		        et.G_LogPrint("Usage: checkuserinfo [etpro id]\n")
              else
              arg1 = tonumber(arg1)
              ret = getclient (arg1)
                if ret then
				et.G_LogPrint(ret)
				else
				local rcon_userinfo = et.trap_GetUserinfo( arg1 )
    	        local reason = check_userinfo( arg1, rcon_userinfo )
    	        
			             if ( reason ) then
			             et.G_LogPrint(string.format("userinfocheck via rcon: client %d bad userinfo %s\n",arg1,uncol(reason)))
									 et.trap_SetUserinfo( arg1, "name\\badinfo" )
									 DropClient4reason (arg1,reason,bantime)
									 else
									 et.G_LogPrint(string.format("userinfocheck via rcon: client %d OK userinfo: %s\n",arg1,rcon_userinfo))
			             end

			    end
			  end
			     return 1
       else -- for all other cmds
       return 0
       end
  
end

function add(cmd,nick,ip,by)

local filter_addguidline, filter_addmaskline

local convert_ip = ip2filename (ip) 

	  if (convert_ip ~= "badIP#1_badIP#2_") and (convert_ip ~= nil) then

			local filename = "ipbans/" .. convert_ip .. ".dat"
			local fd, length = et.trap_FS_FOpenFile( filename, et.FS_READ )

			et.trap_FS_FCloseFile( fd )
			et.G_LogPrint(string.format("Length of " .. filename ..": %d bytes\n",length))

			      if string.len(cmd) == 32 then
						local pbguid = string.upper(cmd)

									if (convert_ip ~= "badIP#1_badIP#2_") then

											if (length >= 0) then
								           	filter_addguidline = "" .. pbguid .. "=" .. nick .." @ " .. os.date("%c") .. " by " .. by .. "\n"
								      		writefile(filter_addguidline,filename)
								      		et.G_LogPrint(string.format("Guid [ %s ] of [ %s ] from banned IP [ %s ] added @ " .. os.date("%c") .. " by [ %s ] !\n",(string.sub (pbguid, 25,32 )),nick,convert_ip,by ))
								         	else
								         	et.G_LogPrint(string.format("File [ %s ] does not exist for this IP [ %s ] \nUse: add mask cheater " .. ip .." " .. by .. " -> to create new mask !\n",filename, ip ))

								      end

						      end

						elseif string.len(cmd) < 32 then

						    if (string.lower(cmd) ~= "mask") then

						   	et.G_LogPrint("Usage: add cl_guid nick ip by\n")
						    et.G_LogPrint("Example#1: add GUIDGUIDGUIDGUIDGUIDGUIDGUIDGUID luk4ward 83.100. admin\n")
						    et.G_LogPrint("Example#2: add GuidGuidGUIDGUIDGUIDGuidGUIDGUID luk4ward 83.100.100.5 admin\n")

						    elseif (string.lower(cmd) == "mask") then

						        if (nick == "") or (ip == "") or (by == "") then

						        et.G_LogPrint("Usage: add mask nick ip by\n")
						        et.G_LogPrint("Example#1: add mask cheater 83.5. admin\n")
						        et.G_LogPrint("Example#2: add mask cheater 83.5.100.5 admin\n")

						        else

						        local msg = "# FilterMask for IP " .. ip .. " of " .. nick .. " @ " .. os.date("%c") .. " created by " .. by .. " !\n"

									        if (length < 0) then
									        filter_addmaskline = "" .. msg .. "#             cl_guid           =nick     @ " .. os.date("%c") .. " by " .. by .. "\n"
						                    writefile(filter_addmaskline,filename)
						                    et.G_LogPrint(string.format("FilterMask for IP [ %s ] created by [ %s ] @ " .. os.date("%c") .. " !\n",ip,by ))
						                    elseif (length >= 0) then
						              	    et.G_LogPrint(string.format("FilterMask for IP [ %s ] is already created !\n",ip ))
						                    end
						        end
						 end
				    end
			end

return 1
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

-- lua module to prevent ws overrun exploit
-- version: 2
-- author: reyalp@gmail.com
-- TY McSteve

if string.lower(cmd) == "ws" then
		local n = tonumber(et.trap_Argv(1))
		if not n then
			et.G_LogPrint(string.format("wsfix: client %d bad ws not a number [%s]\n",cno,tostring(et.trap_Argv(1))))
			return 1
		end
		
		if n < 0 or n > 21 then
			et.G_LogPrint(string.format("wsfix: client %d bad ws %d\n",cno,n))
			return 1
		end
	end

  return 0
end

-- func from KMOD by Clutch, modified by me

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

-- func from minipb by Hadro, modified by me
function RenameUser(clientNum, newname)

local userinfo, bname, info, msg
userinfo = et.trap_GetUserinfo(clientNum)
bname = (unfoVal(et.trap_GetUserinfo(clientNum), "name"))

		if (newname == "clean") then
		newname = uncol ( bname )
		info = "Your nick has been cleaned ! ^1Use standard keys !"
		local msg = string.format("cpm  \"" .. info .. "\n")
		et.trap_SendServerCommand(clientNum, msg) 
			elseif (newname == "cutnick") then
			newname = cut_nick (bname)
			info = "Your nick has been cut ! ^1Use nick with normal length !"
			local msg = string.format("cpm  \"" .. info .. "\n")
			et.trap_SendServerCommand(clientNum, msg) 
			end

  userinfo = et.Info_SetValueForKey(userinfo, "name", newname)
  et.trap_SetUserinfo(clientNum, userinfo)
  et.ClientUserinfoChanged(clientNum)
       
end 

-- func from minipb by Hadro
function uncol(arg) -- this one leaves weird ascii, unlike et.Q_CleanStr
  return string.gsub(string.gsub(arg, "%^[^%^]", ""), "%^", "")
end

-- func from minipb by Hadro
function trim(arg) -- remove spaces in front and after
  return string.gsub(arg, "^%s*(.-)%s*$", "%1")
end

-- func from minipb by Hadro
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

-- func from minipb by Hadro, modified by me
function verifyName(cn, name)
  local bname = trim(string.lower(uncol(name)))
  local ret = "^1You have reached the name change limit on this map ! ^2Restoring original name !"
  local kick_max = max_name_changes+kick_limit_name_changes
    
     if bname ~= prevbname[cn] then -- detect name change or first connect
      	 nameChangeCount[cn] = nameChangeCount[cn] + 1
      	      
         if nameChangeCount[cn] < max_name_changes then 
         	local info = "You have changed your nick ^7(^1" .. max_name_changes-nameChangeCount[cn] .. "^7 left)!"
         	local msg = string.format("cpm  \"" .. info .. "\n")
         	et.trap_SendServerCommand(cn, msg) 
         	         
         elseif nameChangeCount[cn] == max_name_changes then
          local nick_ann = "^3ID: ^g" .. cn ..  "^1 reached the name change limit. ^2Restoring original name: ^7".. origin_name[cn] .. ""
	        local msg = string.format("cpmsay  \"" .. nick_ann .. "\n")
	        et.trap_SendConsoleCommand(et.EXEC_APPEND, msg)
	        RenameUser(cn, origin_name[cn])
	        	        
	       elseif nameChangeCount[cn] > max_name_changes then     
			          if nameChangeCount[cn] < kick_max then      
			       		et.trap_SendServerCommand(cn, string.format("cpm \"" .. ret .. "\n")) 
		         		RenameUser(cn, origin_name[cn])
		         	  elseif nameChangeCount[cn] == kick_max then
		            local nameabuse_reason = "^1Please DO NOT ^1abuse /name command !\n"
		            DropClient4reason (cn,nameabuse_reason,bantime)
		            end  
         end  
      prevbname[cn] = bname
     end
end  

-- lua module to prevent various borkage by invalid userinfo
-- version: 2
-- author: reyalp@gmail.com
-- modified by me

-- returns nil if ok, or reason
function check_userinfo( cno, userinfo )
  
 if userinfo ~= nil then
 
  --	printf("check_userinfo: [%s]\n",userinfo)

	-- bad things can happen if it's full
	if string.len(userinfo) > 980 then
		return "oversized"
	end
	
	-- newlines can confuse various log parsers, and should never be there
	-- note this DOES NOT protect your log parsers, as the userinfo may
	-- already have been sent to the log
	if string.find(userinfo,"\n") then
		return "new line"
	end

	-- the game never seems to make userinfos without a leading backslash, 
	-- or with a trailing backslash, so reject those from the start
	if (string.sub(userinfo,1,1) ~= "\\" ) then
		return "missing leading slash"
	end
	-- shouldn't really be possible, since the engine stuffs ip\ip:port on the end
	if (string.sub(userinfo,-1,1) == "\\" ) then
		return "trailing slash"
	end

	-- now that we know it is properly formed, count the slashes
	local n = 0
	for _ in string.gfind(userinfo,"\\") do
		n = n + 1
	end

	if math.mod(n,2) == 1 then
		return "unbalanced"
	end

	local m
	local t = {}

	-- right number of slashes, check for dupe keys
	for m in string.gfind(userinfo,"\\([^\\]*)\\") do
		if string.len(m) == 0 then
			return "empty key"
		end
		m = string.lower(m)
		if t[m] then
			return "duplicate key"
		end
		t[m] = true 
	end

	-- they might hose the userinfo in some way that prevents the ip from being
	-- obtained. If so -> dump
	local ip = et.Info_ValueForKey( userinfo, "ip" )
	if ip == "" then
		return "missing ip"
	end
--	printf("checkuserinfo: ip [%s]\n", ip)

	-- make sure whatever is there is roughly valid while we are at it
	-- "localhost" may be present on a listen server. This module is not intended for listen servers.
	if (string.find(ip,"^%d+%.%d+%.%d+%.%d+:%d+$") == nil) then
      return "malformed ip"
   end

	-- check for this to prevent exploitation of guidcheck
	-- note the proper solution would be for chats to always have a prefix in the console. 
	-- Why the fuck does the server console need both
	-- say: [NW]reyalP: blah
	-- [NW]reyalP: blah
	
-- modified by Luk4ward --

		local name = string.lower( unfoVal( userinfo, "name" ) )
		local stripped_name = trim ( uncol ( name ) )
		local len_nick = string.len(stripped_name)
		local len_fullnick = string.len(name)
 
			 if len_nick < min_nick_len or len_nick > max_nick_len then
			 local reason = "Your nick is ^g" .. len_nick .. " ^7length (allowed range: ^1" .. min_nick_len .. "^7-^1" .. max_nick_len .. "^7)!\n"
			 return reason
			 else
			    -- no extra ^
			    --local etadmin_name_exploit = "" .. uncol(name) .. "^"
			    
			    local etadmin_name_exploit = string.sub(name,len_fullnick)

			    --et.G_LogPrint(string.format("etadmin_name_exploit: %s\n",etadmin_name_exploit))
                --et.G_LogPrint(string.format("name: %s\n",name))
                
			    if string.find (name,"%^^") or etadmin_name_exploit == "^" then
			    local reason = "Your nick contains ^gextra ^1carat ^gcharacter ^1!\n"
				return reason
				end
				
				for _, badnamepat in ipairs(badnames) do
					local mstart,mend,cno = string.find(stripped_name,string.lower(badnamepat))
					if mstart then
					  local reason = "Your nick contains ^1bad ^1words [ ^g" .. uncol(badnamepat) .. " ^1] !\n"
						return reason
					end
				end
			 end
			 
		-- check for spoofing cl_guid:
		local pbguid = string.upper( et.Info_ValueForKey( userinfo, "cl_guid" ) )

		  mstart,mend = string.find(pbguid,"^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$")
		                                    --1-2-3-4-5-6-7-8-9-0-1-2-3-4-5-6-7-8-9-0-1-2-3-4-5-6-7-8-9-0-1-2
			if not mstart then
			  et.G_LogPrint(string.format("filtercheck: client %d with faked cl_guid !\n",cno))
				bad_guid(cno,"malformed",pbguid)
				local badguid_reason = "You are banned from this server!\n"
				return badguid_reason
			end
	end
  -- return nil
end

-- func by reyalp, modified by me
function check_guid_line(text)
local reason = "You are banned from this server\n"

--find a GUID line
	local guid,netname
	local mstart,mend,cno = string.find(text,"^etpro IAC: (%d+) GUID %[")
	if not mstart then
		return
	end
	text=string.sub(text,mend+1)
	--GUID] [NETNAME]\n
	mstart,mend,guid = string.find(text,"^([^%]]*)%] %[")
	if not mstart then
		bad_guid(cno,"couldn't parse guid",guid)
		-- we don't send them the reason. They can figure it out for themselves.
	  	DropClient4reason (cno,reason,bantime)
		return
	end
	--NETNAME]\n
	text=string.sub(text,mend+1)

	netname = et.gentity_get(cno,"pers.netname")

	mstart,mend = string.find(text,netname,1,true)
	if not mstart or mstart ~= 1 then
		bad_guid(cno,"couldn't parse name",text)
		-- we don't send them the reason. They can figure it out for themselves.
	  	DropClient4reason (cno,reason,bantime)
		return
	end

	text=string.sub(text,mend+1)
	if text ~= "]\n" then
		bad_guid(cno,"trailing garbage",text)
		-- we don't send them the reason. They can figure it out for themselves.
	  	DropClient4reason (cno,reason,bantime)
		return
	end

--	printf("guidcheck: etpro GUID %d %s %s\n",cno,guid,netname)
		
	-- {N} is too complicated!
	mstart,mend = string.find(guid,"^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$")
	if not mstart then
		bad_guid(cno,"malformed",guid)
		-- we don't send them the reason. They can figure it out for themselves.
	  	DropClient4reason (cno,reason,bantime)
		return
	end
--	printf("guidcheck: OK\n")
 
  if log_okeguids then
  
  local ip = et.Info_ValueForKey( et.trap_GetUserinfo(cno), "ip" )
	local name = uncol(et.Info_ValueForKey( et.trap_GetUserinfo(cno), "name" ))	
	et.G_LogPrint(string.format("guidcheck: %d) client " .. name .. " from " .. ip .. " got ok eGUID: " .. guid .. " more info @ " .. logfile_okeguids .. " \n",cno))
	local eguidok_line = "[" .. guid .. "] @ " .. os.date("%c") .. " from " .. ip .. " [ " .. name .. " ] \n"
  	writefile(eguidok_line,logfile_okeguids)
  end
  return 
end

-- func by reyalp
et.G_Printf = function(...)
		et.G_Print(string.format(unpack(arg)))
end

function bad_guid(cno,reason,guid)
	
  if log_badguids then
  
  local ip = et.Info_ValueForKey( et.trap_GetUserinfo(cno), "ip" )
	local name = uncol(et.Info_ValueForKey( et.trap_GetUserinfo(cno), "name" ))	
	  et.G_LogPrint(string.format("guidcheck: %d) client " .. name .. " from " .. ip .. " got bad GUID: " .. guid .. " more info @ " .. logfile_badguids .. " \n",cno))   
	local badguid_line = "[" .. guid .. "] @ " .. os.date("%c") .. " from " .. ip .. " [ " .. name .. " ] \n"
  writefile(badguid_line,logfile_badguids)
  
  end   
 	

end

function writefile(line,file)
local fd,len
      
     fd, len = et.trap_FS_FOpenFile( file, et.FS_APPEND )
     et.trap_FS_Write( line, string.len( line ), fd )
     et.trap_FS_FCloseFile( fd )
end

-- func by reyalp
function IPForClient(clientNum)
-- TODO listen servers may be 'localhost'
	local userinfo = et.trap_GetUserinfo( clientNum ) 
	if userinfo == "" then
		return ""
	end
	local ip = et.Info_ValueForKey( userinfo, "ip" )
	-- find IP and strip port
	local ipstart, ipend, ipmatch = string.find(ip,"(%d+%.%d+%.%d+%.%d+)")
	-- don't error out if we don't match an ip
	if ipmatch == nil then
		return ""
	end
--	et.G_Printf("IPForClient(%d) = [%s]\n",clientNum,ipmatch)
	return ipmatch
end

function DropClient4reason (drop_cno,drop_reason,drop_bantime)

et.G_LogPrint(string.format("filtercheck: client " .. drop_cno .. " dropped due to: " .. drop_reason .. "\n"))
et.trap_DropClient(drop_cno,drop_reason,drop_bantime) 
et_ClientDisconnect(drop_cno)

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

-- func by Clutch, modified by me
function ping2spec(highping)
   local matches = 0
   local info = "^3Keep the ping below ^1" .. highping .. "^7!"
   local msg = string.format("cpm  \"" .. info .. "\n")

   for j=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
      local team = tonumber(et.gentity_get(j,"sess.sessionTeam"))
      local ping = tonumber(et.gentity_get(j,"ps.ping"))

      if team ~= 3 and team ~= 0 then
         if (ping >= highping) or (ping == 0) then
            matches = matches + 1
            et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref remove " .. j .. "\n" )
            et.trap_SendServerCommand(j, msg)            
         end
      end
   end
   et.trap_SendConsoleCommand( et.EXEC_APPEND, "qsay ^3Anti-Highping ^7(from ^1" .. highping .. "^7): Moving ^1" ..matches.. " ^7player/s to spectator\n" )
   et.G_LogPrint(string.format("Anti-Highping (from " .. highping .. "): Moving " ..matches.. " player/s to spectator\n"))
end

-- function by Deus, modified by me
function getclient(client)
   -- first check if client is a number
   local clientnum = tonumber(client)
   local ret = "You need to enter a valid Client slotnumber\n"
   if clientnum then
   -- If clientnum is not NIL then the number is real.
   -- Now check if its a valid client number. If not we cancel the operation.
      if (clientnum >= 0) and (clientnum < 64) then
      -- now its a valid client slot. Now we check if there is any client connected
         if et.gentity_get(clientnum,"pers.connected") == 0 then
            return ret
         end
         
      else
      -- print error
         return ret
      end
    end  
end
-- END OF FILE -- ACpro version 2.0 --