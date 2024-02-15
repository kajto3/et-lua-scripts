--Do not change--
Modname = "HealthBoost2"
Version = "1.0"
Author  = "Perlo_0ung?!"
Description = "^7HealthBoost2"
Homepage = "www.gs2175.fastdl.de"
Text = "^1| ^7Maximal: ^3160 ^1| ^7Increase: ^32"
--
 
--global vars
samplerate = 6000 --30000
et.CS_PLAYERS = 689
--

function et_InitGame(levelTime,randomSeed,restart)
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )	--gets the maxclients
	et.G_Print("[HealthBoost2] Version:1.0 Loaded\n")
   	et.RegisterModname(Modname .. " " .. Version)
	et.trap_SendServerCommand(-1, "b 8 \""..Description.." ^0[^7LUA^0] "..Text.." \n\"" )
		count = {}
			for i = 0, mclients - 1 do
			count[i] = 0	
	end	

end	

function et_RunFrame( levelTime )
	if math.mod(levelTime, samplerate) ~= 0 then return end
	for j = 0, (maxclients - 1) do
	hp = tonumber(et.gentity_get(j,"health"))

   ---------------2: HP increase----------------

	shp = (tonumber(et.gentity_get(j,"health")) + 2 )

   ----------160: Maximal Healthpoints-----------

	if hp > 159 then return end
	if hp < 130 then return end
	if hp < 159 then 

   ----------------------------------------------

		et.gentity_set(j, "health", shp)
   end
end
end