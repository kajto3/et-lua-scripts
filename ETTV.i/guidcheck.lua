-- lua module to prevent guid borkage
-- version: 1
-- author: reyalp@gmail.com
-- confugration:
--  add guidcheck.lua to lua_modules, or merge into your existing et_Print() callback.
-- TY pants
-- NOTE: you MUST use userinfocheck.lua, or the this module is subject
--       and exploit that allows users to cause others to be kicked
--require("rllib/vstrict").init()
--AutoDeclare()

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

--NoAutoDeclare()

