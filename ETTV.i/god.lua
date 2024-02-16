HSP_TJmod_Verison=0.4
godmode = {}

function et_InitGame(levelTime,randomSeed,restart)
maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )   --gets the maxclients
for i = 0, maxclients - 1 do
	godmode[i] = 0
end

		if cmd == "god" then
			if godmode[clientNum] == 0 then
				godmode[clientNum] = 1
				et.trap_SendServerCommand( clientNum, "chat \"^wGodmode enabled \"" )
				return 1
			elseif godmode[clientNum] == 1 then
				local class = et.gentity_get(clientNum,"sess.playertype")
				godmode[clientNum] = 0
				et.trap_SendServerCommand( clientNum, "chat \"^wGodmode disabled \"" )
				if class ~= 1 then
					et.gentity_set(clientNum, "ps.stats", 4,100)
					et.gentity_set(clientNum, "health", 100)
				end
				if class == 1 then
					et.gentity_set(clientNum, "ps.stats", 4,109)
					et.gentity_set(clientNum, "health", 123)
				end
				return 1
			end
		end
		return 0
end

samplerate = 200

function et_RunFrame( levelTime )
if math.mod(levelTime, samplerate) ~= 0 then return end
	for clientNum = 0, maxclients - 1 do
		class = et.gentity_get(clientNum,"sess.playertype")
		if godmode[clientNum] == 1 then
			if class ~= 1 then
				et.gentity_set(clientNum, "ps.stats", 4,999)
				et.gentity_set(clientNum, "health", 999)
			elseif class == 1 then
				et.gentity_set(clientNum, "ps.stats", 4,876)
				et.gentity_set(clientNum, "health", 999)
			end
		