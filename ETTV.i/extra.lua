function et_ClientCommand( slot, command )
	if et.trap_Argv(0) == "callvote" then
		if et.G_shrubbot_level( slot ) < 0 then
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "cancelvote ; qsay you are not allowed to vote!\n")
		end
	end
end


-- LUA Banmask
-- write here all the banned ip masks (currently supprts 2 stages. i.e: 192.168  only)
BANMASK = {}
--BANMASK["80.178"] = 1
--BANMASK["82.80"] = 1
--BANMASK["85.250"] = 1
--BANMASK["79.181"] = 1
BANMASK["82.80"] = 1 -- wazzza???!!  ==> admin guid faker/stealer
--BANMASK["82.80.144.102"] = 1 -- wazzza???!!  ==> admin guid faker/stealer

-- write here guids that allowed to connect from the banned range
GUID_EXCEPTION = {}
GUID_EXCEPTION["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"] = 1 -- Necromancer
GUID_EXCEPTION["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"] = 1 -- FootMassage
GUID_EXCEPTION["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"] = 1 -- Banana
GUID_EXCEPTION["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"] = 1 -- ^0A^4,^7Creed
GUID_EXCEPTION["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"] = 1 -- HELL
GUID_EXCEPTION["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"] = 1 -- Kenny
GUID_EXCEPTION["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"] = 1 -- aylon
GUID_EXCEPTION["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"] = 1 -- a smooth criminal
GUID_EXCEPTION["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"] = 1 -- JoJo Jr
GUID_EXCEPTION["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"] = 1 -- snake

-- write here ip's that allowed to connect from the banned range
IP_EXCEPTION = {}
IP_EXCEPTION["84.108.61.32"] = 1

-- post here your website (free text)
WEB = "^3www.site.com"


BAN = {}

function et_ClientBegin( slot )

	if tonumber(et.gentity_get(slot,"sess.sessionTeam")) == 3 then return end -- he's a spectator, ignore!

	local name = et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "name" )
	local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "cl_guid" ))
	local ip = string.gsub(et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "ip" ), "%:%d+", "") -- gsub removed the :port from the ip
	if ip == "localhost" then return end -- its a bot.

	if GUID_EXCEPTION[guid] then return end
	if IP_EXCEPTION[ip] then return end
	if et.G_shrubbot_level( slot ) ~= 0 then return end -- he got admin level, he's clear

	-- check if the player isnt ban-masked
	local temp_ip = {}
	
	s,e,temp_ip[1],temp_ip[2],temp_ip[3],temp_ip[4] = string.find(ip, "(%d+).(%d+).(%d+).(%d+)")
	if et.gentity_get(slot,"sess.sessionTeam") == 0 and not temp_ip[1] then return end -- abort! player has already been kicked!

	temp_ip = temp_ip[1] .. "." .. temp_ip[2]
	if BANMASK[temp_ip] ~= nil then -- the player has been banned
			--[[
			BAN[slot] = {}
			BAN[slot]["name"] = name
			BAN[slot]["guid"] = guid
			BAN[slot]["ip"] = ip
			BAN[slot]["mask"] = temp_ip
			BAN[slot]["time"] = os.time()
			--]]
			et.G_LogPrint("banmask - " .. temp_ip .. " : client ".. slot .. " - "  .. ip .. " - " .. guid .. " - " .. name .. " has been kicked \n")
			et.trap_DropClient( slot, "you are banned from this server.\n" .. WEB)
			
	end
end

--[[
function et_ClientUserinfoChanged( slot )
	--et.G_LogPrint("banmask test: " .. et.gentity_get(slot,"sess.sessionTeam") .. "\n")
	if tonumber(et.gentity_get(slot,"sess.sessionTeam")) ~= 3 then -- he's not a spectator --> he joined a team
		if BAN[slot] then -- the player has a ban over his head, kick him!
			et.G_LogPrint("banmask - " .. BAN[slot]["mask"] .. " : client ".. slot .. " - "  .. BAN[slot]["ip"] .. " - " .. BAN[slot]["guid"] .. " - " .. et.Q_CleanStr(BAN[slot]["name"]) .. " has been kicked \n")
			et.trap_DropClient( slot, "you are banned from this server.\n" .. WEB)
		end
	end
end
--]]
		

