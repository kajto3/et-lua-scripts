-- lua module to limit fakeplayers DOS
-- http://aluigi.altervista.org/fakep.htm
-- used if cvar is not set
-- author: reyalp@gmail.com
-- confugration:
-- add fakeplimit.lua to lua_modules
-- set ip_max_clients cvar as desired. If not set, defaults to the value below.
FAKEPLIMIT_VERSION = "1.0"
DEF_IP_MAX_CLIENTS = 3

et.G_Printf = function(...)
		et.G_Print(string.format(unpack(arg)))
end

function IPForClient(clientNum)
-- TODO listen servers may be 'localhost'
	local userinfo = et.trap_GetUserinfo( clientNum ) 
	if userinfo == "" then
		return ""
	end
	local ip = et.Info_ValueForKey( userinfo, "ip" )
-- strip port
	ip = string.sub(ip,string.find(ip,"(%d+%.%d+%.%d+%.%d+)"))
--	et.G_Printf("IPForClient(%d) = [%s]\n",clientNum,ip)
	return ip
end

function et_ClientConnect( clientNum, firstTime, isBot )
	local ip = IPForClient( clientNum )
	local count = 1 -- we count as the first one
	local max = tonumber(et.trap_Cvar_Get( "ip_max_clients" ))
	if not max or max <= 0 then
		max = DEF_IP_MAX_CLIENTS
	end
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
end

function et_InitGame( levelTime, randomSeed, restart )
	et.G_Printf("fakeplimit.lua %s\n",FAKEPLIMIT_VERSION)
end

