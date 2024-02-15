--
-- slacstatsaver.lua by Phenomenon (http://www.force-opponents.de)
--
-- This ETPro Lua API script will fix the 'loosing XP/stats at reconnect' bug
-- on a SLAC addon running server.
--
-- Note: Don't use this Lua API script with PunkBuster! :)
--
--	Changelog:
--
--	1.0.1	+ Added SLAC server addon version check
--	1.0		  First release
--

MODVERSION  = '1.0.1'
SLACVERSION = string.sub(et.trap_Cvar_Get('sl_sv_version'), 2)

----------

if string.lower(et.trap_Cvar_Get('gamename')) ~= 'etpro' then
	et.G_Print('slacstatsaver: Error, use this Lua API script only on a '..
				'ETPro running server!\n')
	
	return
end

if tonumber(et.trap_Cvar_Get('sv_punkbuster')) ~= 0 then
	et.G_Print('slacstatsaver: Error, do not run this Lua API script with '..
				'enabled PunkBuster server!\n')
	
	return
end

if SLACVERSION == '' then
	et.G_Print('slacstatsaver: Error, your server is not running with the '..
				'SLAC server addon!\n')
	
	return
else
	if tonumber(SLACVERSION) < 0.06 then
		et.G_Print('slacstatsaver: Error, please update your SLAC server '..
					'addon version to 0.06 or higher!\n')
		
		return
	end
end

----------

function et_InitGame(leveltime, randseed, restart)
	et.RegisterModname(string.format('SLAC StatSaver %s', MODVERSION))
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
	local guid = et.Info_ValueForKey(cs, string.format('sl_g%d', clientnum))
	
	return string.format('%032d', tonumber(guid))
end
