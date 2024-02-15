-- author: reyalp@gmail.com
-- client command checks, formerly wsfix
-- prevent ws overrun exploit, crlf abuse
-- history: 
--  2 - bugfix
-- TY McSteve for reporting this to us.


Modname = "combinedglobalz"
Version = "0.1"
--Updated Aug.2011

et.trap_Cvar_Set( "b_gameformat", "" ) --default "" (none)
tzacserveraddon = 1 --enables tzac server addon support

function et_InitGame( levelTime,randomSeed,restart )
	et.RegisterModname(Modname .. " " .. Version)
	config = et.trap_Cvar_Get( "b_gameformat" )
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxclients" ) )
	sniperaxis = 0
	sniperallies = 0
end

function et_ClientCommand(cno,cmd)
local cmd = string.lower(cmd)
local arg1 = string.lower(et.trap_Argv(1))

if cmd == "forcetapout" then ---forcetapout bugfix
	if et.gentity_get(cno, "r.contents") == 0 then  --contents 0 =nobody
		return 1 --prevent it
	end
end

if cmd == "ws" then
	local n = tonumber(et.trap_Argv(1))
	if not n then
		et.G_LogPrint(string.format(""..Modname..": client %d bad ws not a number [%s]\n",cno,tostring(et.trap_Argv(1))))
		return 1
	end
		
	if n < 0 or n > 21 then
		et.G_LogPrint(string.format(""..Modname..": client %d bad ws %d\n",cno,n))
		return 1
	end
	return 0
end

if cmd == "callvote" or cmd == "ref" or cmd == "sa" or cmd == "semiadmin" then
	local args=et.ConcatArgs(1) 
	if string.find(args,"[\r\n]") then
		et.G_LogPrint(string.format(""..Modname..": client %d bad %s [%s]\n",cno,cmd,args))
		return 1;
	end
	return 0
end

if config ~= "6" and config ~= "" and config ~= nil then
 if cmd == "class" then
	if arg1 == "c" then
		if et.trap_Argv(2) == "3" then
			for j = 0, (maxclients - 1) do
				if getTeam(j) == 2 and getWeapon(j) == 41 then
					sniperallies = sniperallies +1
				elseif getTeam(j) == 1 and getWeapon(j) == 32 then
					sniperaxis = sniperaxis +1
				end
				if getWeapon(cno) == 41 then
					sniperallies = sniperallies -1
				elseif getWeapon(cno) == 32 then
					sniperaxis = sniperaxis -1
				end
				if sniperallies > 0 then
					sniperallies = 0
					setPlayerWeapon(cno , 10)  -- Set Weapon to Sten
					return 1
				end
				if sniperaxis > 0 then
					sniperaxis = 0
					setPlayerWeapon(cno , 10)  -- Set Weapon to Sten
					return 1
				end
			end
		end
	end
 end

 if cmd == "team" then
	if arg1 == "b" then
		if et.trap_Argv(2) == "4" then
			if et.trap_Argv(3) == "25" then
				for j = 0, (maxclients - 1) do
					if getTeam(j) == 2 and getWeapon(j) == 25 then
						sniperallies = sniperallies +1
					end
				end
				if getWeapon(cno) == 25 then
					sniperallies = sniperallies -1
				end
				if sniperallies > 0 then
					sniperallies = 0
					setPlayerWeapon(cno , 10)  -- Set Weapon to Sten
					return 1
				end
			end
	    end

	elseif arg1 == "r" then
		if et.trap_Argv(2) == "4" then
			if et.trap_Argv(3) == "32" then
				for j = 0, (maxclients - 1) do
					if getTeam(j) == 1 and getWeapon(j) == 32 then
						sniperaxis = sniperaxis +1
					end
				end
				if getWeapon(cno) == 32 then
					sniperaxis = sniperaxis -1
				end
				if sniperaxis > 0 then
					sniperaxis = 0
					setPlayerWeapon(cno , 10)  -- Set Weapon to Sten
					return 1
				end
			end
		end
	end
 end
end --end config check

return 0
end --end et_ClientCommand


--  prevent various borkage by invalid userinfo
-- version: 4
-- history:
--  4 - check length and IP
--  3 - check for name exploit against guidcheck
--  2 - fix nil var ref if kicked in RunFrame
--      fix incorrect cno in log message for ClientConnect kick
--  1 - initial release

-- names that can be used to exploit some log parsers 
--  note: only console log parsers or print hooks should be affected, 
--  game log parsers don't see these at the start of a line
-- "^etpro IAC" check is required for guid checking
-- comment/uncomment others as desired, or add your own
-- NOTE: these are patterns for string.find
badnames = {
	'^ShutdownGame',
	'^ClientBegin',
	'^ClientDisconnect',
	'^ExitLevel',
	'^Timelimit',
	'^EndRound',
	'^etpro IAC',
	'^Vote',
	'^etpro privmsg',
-- "say" is relatively likely to have false positives
-- but can potentially be used to exploit things that use etadmin_mod style !commands
--	'^say',
	'^Callvote',
	'^broadcast',
}

-- returns nil if ok, or reason
function check_userinfo( cno )
	local userinfo = et.trap_GetUserinfo(cno)
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
	-- string.match 5.1.x
	-- string.find 5.0.x
	if string.find(ip,"^%d+%.%d+%.%d+%.%d+:%d+$") == nil then
		return "malformed ip"
	end

	-- check for this to prevent exploitation of guidcheck
	-- note the proper solution would be for chats to always have a prefix in the console. 
	-- Why the fuck does the server console need both
	-- say: [NW]reyalP: blah
	-- [NW]reyalP: blah
	
	local name = et.Info_ValueForKey( userinfo, "name" )
	if name == "" then
		return "missing name"
	end
--	printf("checkuserinfo %d name %s\n",cno,name)
	for _, badnamepat in ipairs(badnames) do
		local mstart,mend,cno = string.find(name,badnamepat)
		if mstart then
			return "name abuse"
		end
	end
	-- return nil
end

-- 3.2.6 and earlier doesn't actually call et_ClientUserinfoChanged 
-- every time the userinfo changes, 
-- so we use et_RunFrame to check every so often
-- comment this out or adjust to taste
infocheck_lasttime=0
infocheck_client=0
-- check a client every 5 sec
infocheck_freq=5000

function et_RunFrame( leveltime )
	if ( infocheck_lasttime + infocheck_freq > leveltime ) then
		return
	end

--	printf("infocheck %d %d\n", infocheck_client, leveltime)
	infocheck_lasttime = leveltime
	if ( et.gentity_get( infocheck_client, "inuse" ) ) then
		local reason = check_userinfo( infocheck_client )
		if ( reason ) then
			et.G_LogPrint(string.format("userinfocheck frame: client %d bad userinfo %s\n",infocheck_client,reason))
			et.trap_SetUserinfo( infocheck_client, "name\\badinfo" )
			et.trap_DropClient( infocheck_client, "bad userinfo", 0 )
		end
	end

	infocheck_client = infocheck_client + 1
	if ( infocheck_client >= maxclients ) then
		infocheck_client = 0
	end
end

function et_ClientUserinfoChanged( cno )
--	printf("clientuserinfochanged %d\n",cno)
	local reason = check_userinfo( cno )
	if ( reason ) then
		et.G_LogPrint(string.format("userinfocheck infochanged: client %d bad userinfo %s\n",cno,reason))
		et.trap_SetUserinfo( cno, "name\\badinfo" )
		et.trap_DropClient( cno, "bad userinfo", 0 )
	end
end



-- prevent etpro guid borkage
-- version: 1
-- TY pants

-- default to kick with no temp ban for now
DEF_GUIDCHECK_BANTIME = 0

function bad_guid(cno,reason)
	local bantime = tonumber(et.trap_Cvar_Get( "guidcheck_bantime" ))
	if not bantime or bantime < 0 then
		bantime = DEF_GUIDCHECK_BANTIME
	end

	et.G_LogPrint(string.format("guidcheck: client %d bad GUID %s\n",cno,reason))
	-- we don't send them the reason. They can figure it out for themselves.
	et.trap_DropClient(cno,"You are banned from this server",bantime)
end

function check_guid_line(text)
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
		bad_guid(cno,"couldn't parse guid")
		return
	end
	--NETNAME]\n
	text=string.sub(text,mend+1)

	netname = et.gentity_get(cno,"pers.netname")

	mstart,mend = string.find(text,netname,1,true)
	if not mstart or mstart ~= 1 then
		bad_guid(cno,"couldn't parse name")
		return
	end

	text=string.sub(text,mend+1)
	if text ~= "]\n" then
		bad_guid(cno,"trailing garbage")
		return
	end

--	printf("guidcheck: etpro GUID %d %s %s\n",cno,guid,netname)
		
	-- {N} is too complicated!
	mstart,mend = string.find(guid,"^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$")
	if not mstart then
		bad_guid(cno,"malformed")
		return
	end
--	printf("guidcheck: OK\n")
end

function et_Print(text)
	check_guid_line(text)
end


-- limit fakeplayers DOS
-- http://aluigi.altervista.org/fakep.htm
-- used if cvar is not set
-- confugration:
-- set ip_max_clients cvar as desired. If not set, defaults to the value below.
--FAKEPLIMIT_VERSION = "1.0"
DEF_IP_MAX_CLIENTS = 3

et.G_Printf = function(...)
		et.G_Print(string.format(unpack(arg)))
end

function IPForClient(cno)
-- TODO listen servers may be 'localhost'
	local userinfo = et.trap_GetUserinfo( cno ) 
	if userinfo == "" then
		return ""
	end
	local ip = et.Info_ValueForKey( userinfo, "ip" )
-- find IP and strip port
	local ipstart, ipend, ipmatch = string.find(ip,"(%d+%.%d+%.%d+%.%d+)")
	-- don't error out if we don't match an ip
	if not ipstart then
		return ""
	end
--	et.G_Printf("IPForClient(%d) = [%s]\n",cno,ipmatch)
	return ipmatch
end

function et_ClientConnect( cno, firstTime, isBot )
-- userinfocheck stuff. Do this before IP limit
--	printf("connect %d\n",cno)
	local reason = check_userinfo( cno )
	if ( reason ) then
		et.G_LogPrint(string.format("userinfocheck connect: client %d bad userinfo %s\n",cno,reason))
		return "bad userinfo"
	end

-- note IP validity should be enforced by userinfocheck stuff
	local ip = IPForClient( cno )
	local count = 1 -- we count as the first one
	local max = tonumber(et.trap_Cvar_Get( "ip_max_clients" ))
	if not max or max <= 0 then
		max = DEF_IP_MAX_CLIENTS
	end
	-- et.G_Printf("firstTime %d\n",firstTime);
	-- it's probably safe to only do this on firsttime, but checking
	-- every time doesn't hurt much
	
	-- validate userinfo to filter out the people blindly using luigi's code
	local userinfo = et.trap_GetUserinfo( cno )
	-- et.G_Printf("userinfo: [%s]\n",userinfo)
	if et.Info_ValueForKey( userinfo, "rate" ) == "" then 
		et.G_Printf(""..Modname..".lua: invalid userinfo from %s\n",ip)
		return "invalid connection"
	end

	for i = 0, (maxclients - 1) do
		-- pers.connected is set correctly for fake players
		-- can't rely on userinfo being empty
		if i ~= cno and et.gentity_get(i,"pers.connected") > 0 and ip == IPForClient(i) then
			count = count + 1
			if count > max then
				et.G_Printf(""..Modname..".lua: too many connections from %s\n",ip)
				-- TODO should we drop / ban all connections from this IP ?
				return string.format("only %d connections per IP are allowed on this server",max)
			end
		end
	end
end
-- NoAutoDeclare()

-- added helper functions
function getWeapon(playerID)
    return et.gentity_get(playerID, "sess.playerWeapon")
end 

function getTeam(playerID)
    return et.gentity_get(playerID, "sess.sessionTeam")
end 

function setPlayerWeapon(playerID , weapon)
    et.gentity_set(playerID, "sess.latchPlayerWeapon", weapon)
end 


-- added rifle5v5 module of Perlo_0ung to let rifles spawn with 4 grenades

function et_ClientSpawn(cno,revived)
	if config ~= "6" and config ~= "" and config ~= nil then
		if revived == 0 and et.gentity_get(cno, "sess.playerType") == 2 then
			et.gentity_set(cno,"ps.ammo",39,3)
			et.gentity_set(cno,"ps.ammo",40,3)
		end
	end
end


--Perlo_0ung?!
--votefix
--lowers the mapname in "callvote map" command. This fixes the bug with the wrong mapscripthash of .script files.
--note mapscripts (.script) have to be lower caps

et.CS_VOTE_STRING = 7

function et_Print(text)
	local t = ParseString(text)  --Vote Passed: Change map to suppLY
	if t[2] == "Passed:" and t[4] == "map" then 
		if string.find(t[6],"%u") == nil or t[6] ~= getCS() then return 1 end
			local mapfixed = string.lower(t[6])
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref map " .. mapfixed .. "\n" )
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

function getCS()
	local cs = et.trap_GetConfigstring(et.CS_VOTE_STRING)
	local t = ParseString(cs)
	return t[4]
end


-- statssaver lua by Phenomenon (http://www.force-opponents.de)
--
-- This ETPro Lua API script will fix the 'loosing XP/stats at reconnect' bug
-- on a TZAC addon running server.
--
-- Note: Don't use this Lua API script with PunkBuster! :)
--
--	Changelog:
--
--	1.0.2	  Updated to TZAC
--	1.0.1	+ Added SLAC server addon version check
--	1.0		  First release
--

TZACVERSION = string.sub(et.trap_Cvar_Get('ac_sv_version'), 2)

if string.lower(et.trap_Cvar_Get('gamename')) ~= 'etpro' then
	et.G_Print('tzacstatsaver: Error, use this Lua API script only on a '..
				'ETPro running server!\n')	
	return
end

if tonumber(et.trap_Cvar_Get('sv_punkbuster')) ~= 0 then
	et.G_Print('tzacstatsaver: Error, do not run this Lua API script with '..
				'enabled PunkBuster server!\n')
	
	return
end

if tzacserveraddon == 1 then
	if TZACVERSION == '' then
		et.G_Print('tzacstatsaver: Error, your server is not running with the '..
				'TZAC server addon!\n')
	--return
	else
	if tonumber(TZACVERSION) < 0.15then
		et.G_Print('tzacstatsaver: Error, please update your TZAC server '..
					'addon version to 0.15 or higher!\n')
		
		return
	end
	end
end

function et_ClientConnect(clientnum, firsttime, isbot)
	changeClientsUserinfo(clientnum)
end

function et_ClientUserinfoChanged(clientnum)
	changeClientsUserinfo(clientnum)
end

function changeClientsUserinfo(clientnum)
	local userinfo = et.trap_GetUserinfo(clientnum)
	local guid     = getClientsGUID(clientnum)
	
	userinfo = et.Info_SetValueForKey(userinfo, 'cl_guid', guid)
	et.trap_SetUserinfo(clientnum, userinfo)
end

function getClientsGUID(clientnum)
	local cs   = et.trap_GetConfigstring(63)
	local guid = et.Info_ValueForKey(cs, string.format('ac_g%d', clientnum))
	
	return string.format('%032d', tonumber(guid))
end