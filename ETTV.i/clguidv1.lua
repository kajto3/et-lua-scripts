samplerate = 100

-- on game initialise, get the maxclients and initialise the arrays 
function et_InitGame( levelTime, randomSeed, restart )	
	maxclients = tonumber(et.trap_Cvar_Get( "sv_maxClients" ))
	guid = {}
	logged = {}
	slotactive = {}
	
	for i = 0, (maxclients - 1) do
		guid[i] = 0
		logged[i] = 0
		slotactive[i] = 0
	end
end

				
function et_ClientBegin( cno )
	-- get the player's GUID and store it in the guid array
	guid[cno] = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( cno ), "cl_guid" ))
	slotactive[cno] = 1
end

function et_ClientDisconnect( cno )
	-- the player has left, we need to clear the stored GUID
	guid[cno] = 0
	logged[cno] = 0
	slotactive[cno] = 0
end
								
function et_RunFrame( levelTime )
    if math.mod(levelTime, samplerate) ~= 0 then return end

    -- compare all the GUIDs
    for i = 0, (maxclients - 1) do
		if(slotactive[i] == 1) then
			local actualguid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" ));
			if(guid[i] ~= actualguid) then
				-- player faked his GUID
				local name = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" )
				local ipport = et.Info_ValueForKey(et.trap_GetUserinfo(i), "ip")
				local ip = string.sub(ipport, 1, string.find(ipport,":")-1)
				-- inform admin and players
				et.G_LogPrint(string.format("clguid: %s is faking his GUID.\n", name))
				et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("qsay \"^w%s^1 is faking his GUID.\"\n", name))
				-- ip ban
				et.G_LogPrint(string.format("clguid: IP %s is now banned.\n", ip))
				et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("qsay \"^wIP ^1%s ^wis now banned.\"\n", ip))
				et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("pb_sv_banmask %s\n", ip))
				-- kick
				et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("qsay pb_sv_kick %d 5 \"%s\"\n", i+1, "was booted off the Server"))
				-- fallback kick
				et.trap_DropClient(i, "^3Smth went wrrrong.")
				-- remove his entry in the arrays
				guid[i] = 0
				logged[i] = 0
				slotactive[i] = 0
			else
				if(logged[i] < 1) then
					local name = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" )
					--et.G_LogPrint(string.format("%s is not faking his GUID.\n", name))
					--et.trap_SendConsoleCommand(et.EXEC_APPEND, string.format("qsay \"^w%s^2 is not faking his GUID.\"\n", name))
					logged[i] = 1
				end
			end
		end
    end
end

function et_ClientCommand(cno,cmd)
    if string.lower(cmd) == "fuckme" then
		guid[cno] = 1234
		return 1
    end
    return 0
end
