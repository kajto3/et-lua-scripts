--When should it shuffle?
--Set one "true":
warmup = true
intermission = false

--Shuffle_Norestart or ShuffleTeamsXP ?
norestart = false
--

spamblock = 0
samplerate = 200

function et_RunFrame( levelTime )
	if math.mod(levelTime, samplerate) ~= 0 then return end
	local gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))
	local maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
	if gamestate == 0 then
		spamblock = 0
	elseif gamestate == 2 or gamestate == 3 then
		spamblock = spamblock + 1
		if spamblock == 24 then
			if warmup and gamestate == 2 and not intermission then
				if norestart then
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "shufflenorestart" )
					et.trap_SendServerCommand(-1, "chat \"^w*** ^.Teams have been shuffled!\"" )
				else
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref shuffleteamsxp" )
					et.trap_SendServerCommand(-1, "chat \"^w*** ^.Teams have been shuffled by XP!\"" )
				end
			end
			if intermission and gamestate == 3 and not warmup then
				if norestart then
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref shufflenorestart" )
					et.trap_SendServerCommand(-1, "chat \"^w*** ^.Teams have been shuffled!\"" )
				else
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref shuffleteamsxp" )
					et.trap_SendServerCommand(-1, "chat \"^w*** ^.Teams have been shuffled by XP!\"" )
				end
			end
		end
	end
end