-- lua module to prevent various borkage by invalid userinfo
-- version: 3
-- author: reyalp@gmail.com
-- confugration:
--  add userinfocheck.lua to lua_modules, or merge into your existing module
-- history:
--  3 - check for name exploit against guidcheck
--  2 - fix nil var ref if kicked in RunFrame
--      fix incorrect clientNum in log message for ClientConnect kick
--  1 - initial release
-- require("rllib/vstrict").init()
-- AutoDeclare()

-- names that can be used to exploit some log parsers
-- etpro IAC check is required for guidfix.lua
-- comment/uncomment others as desired, or add your own
-- NOTE: these are patterns for string.find
badnames = {
--	'^ShutdownGame',
--	'^ClientBegin',
--	'^ClientDisconnect',
--	'^ExitLevel',
--	'^Timelimit',
--	'^EndRound',
	'^etpro IAC',
--	'^etpro privmsg',
-- "say" is relatively likely to have false positives
-- but can potentially be used to exploit things that use etadmin_mod style !commands
--	'^say',
--	'^Callvote',
--	'^broadcast'
}

-- returns nil if ok, or reason
function check_userinfo( cno )
	local userinfo = et.trap_GetUserinfo(cno)
--	printf("check_userinfo: [%s]\n",userinfo)

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
	-- check for this to prevent exploitation of guidcheck
	-- note the proper solution would be for chats to always have a prefix in the console. 
	-- Why the fuck does the server console need both
	-- say: [NW]reyalP: blah
	-- [NW]reyalP: blah
	
	local name = et.Info_ValueForKey( userinfo, "name" )
--	printf("checkuserinfo %d name %s\n",cno,name)
	for _, badnamepat in ipairs(badnames) do
		local mstart,mend,cno = string.find(name,badnamepat)
		if mstart then
			return "name abuse"
		end
	end
	-- return nil
end

-- check in et_ClientConnect since kicking in
-- the initial et_ClientUserinfoChanged is a bit screwy
function et_ClientConnect( cno, firsttime, isbot )
--	printf("connect %d\n",cno)
	local reason = check_userinfo( cno )
	if ( reason ) then
		et.G_LogPrint(string.format("userinfocheck connect: client %d bad userinfo %s\n",cno,reason))
		return "bad userinfo"
	end
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
	if ( infocheck_client >= tonumber(et.trap_Cvar_Get("sv_maxclients")) ) then
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

--NoAutoDeclare()

