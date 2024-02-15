-- To use this script, first create a file called "hpstring.txt" and write 64 x 1s for the content (i.e. 1111111.....)
-- Then, place the file in your working etpro directory on your server.

--  GhosT:McSteve
--  www.ghostworks.co.uk
--  #ghostworks, #pbbans @quakenet
--  Version 4, 15/2/07

-- on game initialise, get the maxclients
function et_InitGame( levelTime, randomSeed, restart )		--called on game initialise
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )	--gets the maxclients	
	
	-- open up the file and get the hpstring
	fd,len = et.trap_FS_FOpenFile("hpstring.txt", et.FS_READ)
	hpstring = et.trap_FS_Read( fd, len )
	et.trap_FS_FCloseFile(fd)
	fd = nil

	-- initialise the array, step through the string, and set the values in the hp[i] array to the value in the string
	hp = {}
	for i = 1, 64 do
		-- string indexes start at 1, not 0, so start string search from i-1 to tie in with player slot numbers
		temp = string.sub(hpstring, i, i)
		hp[i-1] = tonumber(temp)
	end

end

-- called on client command
function et_ClientCommand(cno, cmd)

	--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3runtime\"\n")

	-- if the client calls "hp" then get the value and switch the array accordingly
	if string.lower(cmd) == "showhpleft" then
	
		-- set hp[cno] and announce it to the client
		if string.lower(et.trap_Argv(1)) == "on" then
			hp[cno] = 1
			et.trap_SendServerCommand( cno, "cpm \"^oHP notification ^dON  \n\" " )
		elseif string.lower(et.trap_Argv(1)) == "off" then
			hp[cno] = 0
			et.trap_SendServerCommand( cno, "cpm \"^oHP notification ^dOFF  \n\" " )
		end
		return 1
	end

	return 0
end

function et_Obituary(victimnum, killernum, meansofdeath)

	-- the the victim (victimnum) has turned off hp alerts, then do nothing
	if hp[victimnum] == 0 then return end
	
	local victimteam = tonumber(et.gentity_get(victimnum, "sess.sessionTeam"))
	local killerteam = tonumber(et.gentity_get(killernum, "sess.sessionTeam"))
	
	if victimteam ~= killerteam and killernum ~= 1022 then
		local killername = string.gsub(et.gentity_get(killernum, "pers.netname"), "%^$", "^^ ")
		local killerhp = et.gentity_get(killernum, "health")

		if tonumber(et.gentity_get(killernum,"ps.powerups", 12)) > 0 then
			--This detects the use of adrenaline.
			et.trap_SendServerCommand(victimnum, string.format("cpm  \"" .. killername ..  "^:( ^3 " .. killerhp .. "^:)\n"))
		else
			et.trap_SendServerCommand(victimnum, string.format("cpm  \"" .. killername ..  "^:( ^3 " .. killerhp .. "^:)\n"))
		end
	end
end

-- on client disconnect, set the hp[cno] back to default (1)
function et_ClientDisconnect( cno )
	hp[cno] = 1
end

function et_ShutdownGame( restart )

	--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3shutdown called\"\n")

	-- create the string to be written to file
	tempstring = ""
	for i = 0, 63 do
		tempstring = tempstring .. hp[i]
	end

	-- now write the string to file
	fd,len = et.trap_FS_FOpenFile("hpstring.txt", et.FS_WRITE)
	count = et.trap_FS_Write(tempstring, string.len(tempstring), fd)
	et.trap_FS_FCloseFile(fd)
	fd = nil

end

