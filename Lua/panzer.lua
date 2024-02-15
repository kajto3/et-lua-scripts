------------------------------------------
----------- Panzer Time Limit ------------
-----------  By Necromancer   ------------
-----------     3/26/2009     ------------
-----------  www.usef-et.org  ------------
------------------------------------------

-- A player may only use the panzer for a maximum of PANZER_TIME before being forced to drop it.
-- he may take the panzer again, after someone else used his panzer, or if the COOL_TIME passed. whatever comes first.

-- this module may, but should not enterfere with !panzerwar or other stuff.
-- please note that the panzer time is always limiting the players, thus might lead to a situation where there are 2 panzers available, 
-- and 2 players on the team, but after PANZER_TIME exceeds they will both be forced to drop their panzers. even though there is no one else who might use it.
-- although it should not be a problem, as most servers have a rate of at least 6 players per panzer.


PANZER_TIME = 600 -- 10 min

--PANZER_TIME = ((tonumber(et.trap_Cvar_Get("timelimit"))*60) / 2) -- maptime / 2 == half of the map
--if PANZER_TIME > 1800 then PANZER_TIME = 1080 end -- if its bigger then 18 min, then set it to 18 min (time limit changes and gets high values on maps like LOTR, MLBs etc...)

COOL_TIME = 300 -- 5 min ||| time the panzer user must wait before being able to grab the panzer again (if no one takes the panzer)
LEVEL = 0 -- will only run the timer for people with this heavy weapon level or higher, set to 5 to disable the panzer time completely.



-- constans
PANZER = 5

PANZERS = {}

OCCUPIED = 1
UNOCCUPIED = 0
ALLIES = 2
AXIS = 1
THOMPSON = 8
MP40 = 3
HEAVY_WEAPONS = 5

function et_InitGame( levelTime, randomSeed, restart )
	init_panzers()
end

function init_panzers()
	PANZERS = {}
	for i=1, tonumber(et.trap_Cvar_Get("team_maxPanzers"))*2, 1 do -- *2 - every team has team_maxpanzers panzers
		PANZERS[i] = {}
	end
	-- update
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		if et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" )~= "" then  -- an empty player name ==> no player in this slot
		
			--et.G_LogPrint("weapon: " .. et.gentity_get(i,"sess.playerWeapon") .. "\n")
			if tonumber(et.gentity_get(i,"sess.playerWeapon")) == PANZER then
				if not panzerSet(i) then
					local panz = panzer_slot()
					PANZERS[panz]["time"] = os.time()
					PANZERS[panz]["slot"] = i
					PANZERS[panz]["available"] = OCCUPIED
					--et.G_LogPrint("PANZER TAKING \n")
				end
			end
		end
	end	
end

function et_RunFrame( levelTime )
	if tonumber(et.trap_Cvar_Get("team_maxPanzers")) == -1 or tonumber(et.trap_Cvar_Get("team_maxPanzers")) == 0 then return end -- unlimited panzers, abort!!!

	update()
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		if et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" )~= "" then  -- an empty player name ==> no player in this slot
		
			if tonumber(et.gentity_get(i,"sess.latchPlayerWeapon")) == PANZER then
				if not panzerSet(i) then
					local panz = panzer_slot()
					if panz == nil then return end -- error
					--et.G_LogPrint("panz: " .. panz .. "\n")
					PANZERS[panz]["time"] = os.time()
					PANZERS[panz]["slot"] = i
					PANZERS[panz]["available"] = OCCUPIED
					--et.G_LogPrint("PANZER TAKING \n")
				end

			end
		end
	end
	

end

function et_Obituary( victim, killer, meansOfDeath)
	if tonumber(et.trap_Cvar_Get("team_maxPanzers")) == -1 then return end -- unlimited panzers, abort!!!
	if tonumber(et.gentity_get( victim, "sess.skill", HEAVY_WEAPONS )) < LEVEL then return end 
	if tonumber(et.gentity_get(victim,"sess.playerWeapon")) == PANZER then checktime(victim) end
end

function checktime(slot)
	if not find_panzer(slot) then return end -- no panzer
	if os.time() - PANZERS[find_panzer(slot)]["time"] >= PANZER_TIME then

		et.trap_SendServerCommand(slot, string.format("print \"^3You have been playing with the panzer for too long, therefor you decided to give it to someone else!\n"))


		local fallback -- default weapon
		if team == AXIS then fallback = THOMPSON
		else fallback = MP40 end

		-- now update the client (in order for the change to be immidieate, and not wait for the server, we need to update the client's configstring)
		local infostring  
		infostring  = et.trap_GetConfigstring(689 + slot)
		infostring = et.Info_SetValueForKey( infostring, "lw", fallback )
		et.trap_SetConfigstring(689 + slot, infostring)
		
		PANZERS[find_panzer(slot)]["COOL"] = os.time()
		PANZERS[find_panzer(slot)]["available"] = UNOCCUPIED

		et.gentity_set(slot,"sess.latchPlayerWeapon",fallback)


	end
end


function update() -- panzer cvar update
	if table.getn(PANZERS) ~= tonumber(et.trap_Cvar_Get("team_maxPanzers"))*2 then
		init_panzers()
	end
end


function panzerSet(slot) -- returns 1 if the panzer is already being tracked, or nil otherwise
	for i=1,table.getn(PANZERS),1 do
		if PANZERS[i]["slot"] == slot and PANZERS[i]["available"] == OCCUPIED then return 1 end
	end
	return nil
end

function panzer_slot() -- gives an available panzer slot
	for i=1, tonumber(et.trap_Cvar_Get("team_maxPanzers"))*2, 1 do
		if PANZERS[i]["slot"] == nil then return i end
		if PANZERS[i]["available"] == UNOCCUPIED then return i end
	end	
	et.G_LogPrint("PANZER ERROR #1: " .. tonumber(et.trap_Cvar_Get("team_maxPanzers"))*2 .. " out of " .. table.getn(PANZERS) .."\n")
end

function find_panzer(slot) -- returns the panzer number of the player
	for i=1,table.getn(PANZERS),1 do
		if PANZERS[i]["slot"] == slot then return i end
	end
	return nil
end

function et_ClientDisconnect(slot)
	if find_panzer(slot) then
		PANZERS[find_panzer(slot)] = {}
	end
end

function et_ClientCommand( slot, command )
    local cmd = string.lower(command) 
    if cmd == "panzer" then 	
        if find_panzer(slot) then
		local t = (PANZER_TIME - (os.time() -PANZERS[find_panzer(slot)]["time"]))/60
		if t>=0 then
			et.trap_SendServerCommand(slot, string.format("print \"^3You got another %0.2f minutes to play with the panzer!\n", (PANZER_TIME - (os.time() -PANZERS[find_panzer(slot)]["time"]))/60 ))	
		else
			if PANZERS[find_panzer(slot)]["COOL"] ~= nil and tonumber(et.gentity_get(slot,"sess.playerWeapon")) ~= PANZER then -- which means he swiched weapons and he checks if he can take the panzer again
				if os.time() - PANZERS[find_panzer(slot)]["COOL"] < COOL_TIME then
					et.trap_SendServerCommand(slot, string.format("print \"^3Your panzer time is over, you must let someone else use it before you can take it again\n" ))	
				end
			else
				et.trap_SendServerCommand(slot, string.format("print \"^3Your panzer time is over, you must let someone else use it before you can take it again\n" ))
			end
		end
	end
        return 1 
    end

	if command == "team" then
		--et.G_LogPrint("command: " .. command .. "\n")
		local weapon = tonumber(string.lower(et.trap_Argv(3)))
		local team = string.lower(et.trap_Argv(1))
		--et.G_LogPrint("weapon: " .. weapon .. "\n")
		--et.G_LogPrint("team: " .. team .. "\n")

		if team == "b" then team = ALLIES
		elseif team == "r" then team = AXIS
		else return end -- spectator or something
		
		if weapon ~= PANZER then 
			if find_panzer(slot) then
				PANZERS[find_panzer(slot)]["COOL"] = os.time()
				PANZERS[find_panzer(slot)]["available"] = UNOCCUPIED
				--et.G_LogPrint("PANZER DROPPED \n")
			end
		else -- he tried to take a panzer
			if tonumber(et.gentity_get( slot, "sess.skill", HEAVY_WEAPONS )) < LEVEL then return 0 end 
			if find_panzer(slot) then
				if PANZERS[find_panzer(slot)]["COOL"] == nil then return 0 end
				--et.G_LogPrint("PANZER : " .. os.time() - PANZERS[find_panzer(slot)]["COOL"] .. " \n")
				if os.time() - PANZERS[find_panzer(slot)]["COOL"] < COOL_TIME and  os.time() - PANZERS[find_panzer(slot)]["time"] > PANZER_TIME then
					et.trap_SendServerCommand(slot, string.format("print \"^3You cannot take a panzer! you must let someone else use it before you can take it again\n"))
					
					return 1 -- abort execution
					--[[
					local fallback -- default weapon
					if team == AXIS then fallback = THOMPSON
					else fallback = MP40 end

					-- now update the client (in order for the change to be immidieate, and not wait for the server, we need to update the client's configstring)
					local infostring  
					infostring  = et.trap_GetConfigstring(689 + slot)
					infostring = et.Info_SetValueForKey( infostring, "lw", fallback )
					et.trap_SetConfigstring(689 + slot, infostring)
					--]]
				end
			end
		end
	end
	return 0
end

				
			

	