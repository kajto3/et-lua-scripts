--Do not change--
Modname = "HealthBoost"
Version = "1.2"
Author  = "Perlo_0ung?!"
Description = "^7HealthBoost"
Homepage = "www.gs2175.fastdl.de"
Text = "^1| ^7Medic: ^3160 ^1| ^7Rest: ^3130 ^1| ^7HP Increase: ^32"
-- 
 
--global vars
et.CS_PLAYERS = 689
samplerate = 1   -- 1 second  
rechargerate = 30  -- 30 seconds
medic_max_hp = 160
class_max_hp = 130

-- 


function et_InitGame(levelTime,randomSeed,restart)
   maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )   --gets the maxclients
   et.G_Print("[HealthBoost] Version:1.2 Loaded\n")
      et.RegisterModname(Modname .. " " .. Version)
   et.trap_SendServerCommand(-1, "b 8 \""..Description.." ^0[^7LUA^0] "..Text.." \n\"" )
      count = {}
	timecounter = 0
         for cno = 0, maxclients - 1 do
         count[cno] = 1   
   end   

end  

--function et_Obituary( victim, killer, meansOfDeath ) 
--	count[victim] = 1
--end

function et_ClientSpawn(cno,revived)
	count[cno] = 1
end

function et_ClientDisconnect(cno) 
	count[cno] = 0
end

function et_RunFrame( levelTime )
   for cno = 0, (maxclients - 1) do
	if count[cno] == 1 then
  local hpreturn = tonumber(et.gentity_get(cno,"health"))
  local class = et.gentity_get(cno,"sess.playertype")
	  if class == 1 then 
		local mhp = ( medic_max_hp - (et.gentity_get(cno,"health")))
		local newmhp = (et.gentity_get(cno,"health") + mhp)
      		et.gentity_set(cno, "health", newmhp)
		count[cno] = 0
	  elseif class == 0 or class == 2 or class == 3 or class == 4 then 
		local chp = ( class_max_hp  - (et.gentity_get(cno,"health")))
		local newchp = (et.gentity_get(cno,"health") + chp)
      		et.gentity_set(cno, "health", newchp)
		count[cno] = 0
 	  end	
	end
    end
 if math.mod(levelTime, (samplerate*1000)) ~= 0 then return end
	if timecounter == rechargerate then
   for cno = 0, (maxclients - 1) do
	local hp = (tonumber(et.gentity_get(cno,"health")))
	local ghp = (tonumber(et.gentity_get(cno,"health")) + 2 )
	local class = et.gentity_get(cno,"sess.playertype")
	if class == 1 then
	 if hp > 160 then return end
	  if hp < 160 then 
		et.gentity_set(cno, "health", ghp)
	end
	  elseif class == 0 or class == 2 or class == 3 or class == 4 then 
	if hp > 130 then return end
	if hp < 130 then 
		et.gentity_set(cno, "health", ghp)
	end
	timecounter = 0
  end
end
end
	timecounter = timecounter + 1
  -- et.trap_SendServerCommand(-1, "b 8 \""..timecounter.." \n\"" )
   for cno = 0, (maxclients - 1) do
  local class = et.gentity_get(cno,"sess.playertype")
  local shp = (tonumber(et.gentity_get(cno,"health")) + 1 )
  local hpreturn = tonumber(et.gentity_get(cno,"health"))
	  if class == 0 or class == 2 or class == 3 or class == 4 then 
		if hpreturn < 100 then return end
  		 if shp > (class_max_hp + 1 ) then return end
   			if shp < (class_max_hp + 1 ) then 
			et.gentity_set(cno, "health", shp)
			end
	     end
	end
   end
