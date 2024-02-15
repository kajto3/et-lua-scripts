evenerdist = 30

evener = 0
killcount = 0
lastevener = 0
team = { [0]="CONN","AXIS" , "ALLIES" , "SPECTATOR" }


function et_ClientCommand( clientNum, command )

-- get the first argument
arg1 = et.trap_Argv( 0 )
if arg1 == "even" then
	checkBalance (true)
end

end
function et_Obituary( _victim, _killer, _mod )
	if evenerdist ~= -1 then
		killcount = killcount +1
		seconds = (et.trap_Milliseconds() / 1000)
		if killcount % 2 == 0 and (seconds - lastevener ) >= evenerdist then
			checkBalance( true )
			lastevener = seconds
		end
	end

end
-------------------------------------------------------------------------------
-- checkBalance ( force )
-- Checks for uneven teams and tries to even them
-- force is a boolean controlling if there is only an announcement or a real action is taken.
-- Action is taken if its true.
-------------------------------------------------------------------------------
function checkBalance( _force )
	-- TODO: Do we need extra tables to store this kind of data ?
	local axis = {} -- is this a field required?
	local allies = {} -- is this a field required?
	local numclients = 0

	for i=0, et.trap_Cvar_Get( "sv_maxclients" ) -1, 1 do					
		local thisGuid = string.upper( et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" ))
		if string.sub(thisGuid, 1, 7) ~= "OMNIBOT" then	
		
			local team = tonumber(et.gentity_get(i,"sess.sessionTeam"))

			if team == 1 then
				table.insert(axis,i)
			end 
			if team == 2 then
				table.insert(allies,i)
			end
		end
		
		numclients = numclients + 1
		
	end
    

	local numaxis   = # axis
	local numallies = # allies
	local greaterteam = 3
	local smallerteam = 3
	local gtable = {}
	local teamchar = { "r" , "b" , "s" }

	if numaxis > numallies then
		greaterteam = 1
		smallerteam = 2
		gtable = axis
	end
	if numallies > numaxis then
		greaterteam = 2
		smallerteam = 1
		gtable = allies
	end


	--if math.abs(numaxis - numallies) >= 5 then
	--	evener = evener +1
	--	if _force == true and evener >= 4  then
	--		et.trap_SendConsoleCommand( et.EXEC_NOW, "!shuffle " )
	----		et.trap_SendConsoleCommand( et.EXEC_APPEND, "chat \"^2EVENER: ^1TEAMS SHUFFLED \" " )
	--	else
	--		et.trap_SendConsoleCommand( et.EXEC_APPEND, "chat \"^1EVEN TEAMS OR SHUFFLE \" " )
	--	end
	--	return
	--end

	if math.abs(numaxis - numallies) > 1 then
		evener = evener +1
		if _force == true and evener >= 2  then
			local rand = math.random(# gtable)
			local cmd =  "!put ".. gtable[rand] .." "..teamchar[smallerteam].." \n"  
			--et.G_Print( "CMD: ".. cmd .. "\n") 
			et.trap_SendConsoleCommand( et.EXEC_APPEND, cmd ) 
			local cname = et.Info_ValueForKey( et.trap_GetUserinfo( gtable[rand] ) , "name" )

			et.trap_SendServerCommand(-1 , "chat \"^2EVENER: ^7Thank you, ".. cname .." ^7for helping to even the teams. \" ")
		else
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "chat \"^2EVENER: ^3Teams are unfair, would someone from ^2".. team[greaterteam] .."^3 please switch to ^2"..team[smallerteam].."^3?  \" " )
		end
		
		return
	else
		evener = 0
	end
end
