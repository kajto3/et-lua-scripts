-- Hide & Seek Gib
-- LUA by N!trox*
-- Requested by EA|Flex|FF
-- Aug 21st 2010
-- This script can be used on Hide&Seek servers to gib players if they kill an enemy.
-- This script should be compatible with ANY mod with LUA API Support.
-- If you find a bug, or want to submit ideas to improve this LUA module, visit www.nitmod.com and post in the "LUA Scripts" section.

--Removed checkteam because it is unnecessary

MODNAME = "H&S-Gib"
MODVERSION = "1.01"

--AXIS = 1
--ALLIES = 2

numconn = 0
function et_InitGame(leveltime, randomseed, restart)
	et.RegisterModname(string.format("%s %s", MODNAME, MODVERSION))
end

function et_Obituary( victim, attacker, mod )

		--local attackerTeam = tonumber(et.gentity_get(attacker, "sess.sessionTeam"))
		--local victimTeam = tonumber(et.gentity_get(victim, "sess.sessionTeam"))
		
		--if attackerTeam == AXIS and victimTeam == ALLIES then
			-- Inflict damage to the attacker using the et.G_Damage function : et.G_Damage( target, inflictor, attacker, damage, dflags, mod )
			-- target = attacker
			-- inflictor = 65 = <world> (not a client)
			-- attacker = 65  = <world> (not a client)
			-- damage = 999 (make sure we gib the target)
			-- mod = 0 = MOD_UNKNOWN
			
		et.G_Damage(attacker, 65, 65, 999, 20, 0)
			
	--	end
end