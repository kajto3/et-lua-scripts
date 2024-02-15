
-- This script scans each player for damage taken every <samplerate> milliseconds.
-- It then starts a countdown that counts down to 0.  If countdown is != 0, then player is warned for selfkill.
-- The time before a selfkill is not considered infight is calculated by: samplerate x counter (= 1 seconds in this example)

--  GhosT:McSteve
--  www.ghostworks.co.uk
--  #ghostworks, #pbbans @quakenet
--  Version 1, 25/1/07

Modname = "NoInfightSK"
Version = 	"1.0"

--GLOBALS
samplerate = 100
counter = 3

-- counter = 10

-- on game initialise, get the maxclients and initialise the arrays (holds 1 or 0 for each client)
function et_InitGame( levelTime, randomSeed, restart )	
	et.G_Print("[NoInfightSK] Version:"..Version.." Loaded\n")
   	et.RegisterModname(Modname .. " " .. Version)	
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )

	d_switch = {}
	damage_received_temp = {}

	for i = 0, (maxclients - 1) do
		d_switch[i] = 0
		damage_received_temp[i] = 0
	end
end

-- called every server frame
function et_RunFrame( levelTime )
 	
	if math.mod(levelTime, samplerate) ~= 0 then return end
	
	-- for all clients, check the client's damage received
	for i = 0, (maxclients - 1) do

		--compare damage to the last value (check if ~= 0)
		
		--current value = et.gentity_get(i, "sess.damage_received")
		if (et.gentity_get(i, "sess.damage_received")) > (damage_received_temp[i]) then
			--damage has been taken in the last <samplerate> milliseconds -> set switch to 10
	 		d_switch[i] = counter
	 		--save the current damage value to carry across to next iteration
	 		damage_received_temp[i] = et.gentity_get(i, "sess.damage_received")
	 	else
	 		if d_switch[i] ~= 0 then
	 			d_switch[i] = d_switch[i] - 1
	 		end
		end
		
	end
	
end


function et_ClientCommand(cno, cmd)
	if string.lower(cmd) == "kill" then
		--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3kill\"\n")

		if et.gentity_get(cno, "health") > 0 then

			--if d_switch = 1, then client is taking damage and should not be able to selfkill
			if d_switch[cno] >= 1 then
				--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3d_switch == 1\"\n")
				tempname = et.Info_ValueForKey( et.trap_GetUserinfo( cno ), "name" )
				--et.trap_SendServerCommand(-1, string.format("cp  \"" .. tempname ..  " ^3selfkilled in battle.  \n"))
				et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^1WARNING! ^3No infight selfkill " .. tempname ..  "^3.  \n")
				return 1
			end
		end 
	end
	return 0
end

