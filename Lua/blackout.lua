Modname = "Speclock"
Version = "0.1"
Author  = "^wMNwa^0!"
Homepage = "^7www^1.^7gs2175^1.^7fastdl^1.^7de "
--Thanks to Perlo_0ung?!

 
--global vars
et.CS_PLAYERS = 689
samplerate = 50
blackout = {}
--

function et_InitGame(levelTime,randomSeed,restart)
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )   --gets the maxclients
	et.G_Print("[Speclock] Version:"..Version.." Loaded\n")
	et.RegisterModname(Modname.. " " ..Version)
	--et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref speclock\n" )
	for i=0, maxclients - 1 do
		blackout[i] = 0
	end
end

function et_ClientCommand(client, command)
	if string.lower(command) == "slock" then
		blackout[client] = 1
		et.trap_SendServerCommand(client, "chat \"^1Console: ^3You speclocked yourself\"" )
		return 1
	end
	if string.lower(command) == "sunlock" then
		blackout[client] = 0
		et.trap_SendServerCommand(client, "chat \"^1Console: ^3You specunlocked yourself\"" )
		return 1
	end
	return 0 
end

function et_ClientConnect( i, firstTime, isBot )
	blackout[i] = 0
end

function et_RunFrame( levelTime )
 if math.mod(levelTime, samplerate) ~= 0 then return end
 	for cno=0, maxclients - 1 do
		local team = et.gentity_get(cno,"sess.sessionTeam")
		if team == 3 then
			for i=0, maxclients - 1 do
				if blackout[i] == 1 then
					et.gentity_set(cno, "ps.powerups", 14, 1 )		--pw_blackout
				end
			end
		end
	end
end