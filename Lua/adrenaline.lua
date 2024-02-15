--
-- More Adrenaline for Medics 0.1
-- by nano <nano@fooo.org>
--
-- This is a small module for trickjump servers. It gives
-- medics on spawn a specified amount of adrenaline needles.
--
-- To add adrenaline needles you have to use the ammoindex
-- 11 (WP_MEDIC_SYRINGE) and not 46 (WP_MEDIC_ADRENALINE)
-- since they belong together just like WP_LUGER and WP_MP40
-- (line 1396-1419 in game/bg_misc.c).
--

AMOUNT = 500 
et.CS_PLAYERS = 689

function et.GetPlayerCS(clientNum, key)
  local cs = et.trap_GetConfigstring(et.CS_PLAYERS + clientNum)
  return et.Info_ValueForKey(cs, key)
end

function et_ClientSpawn(clientNum, revived)
  if tonumber(et.GetPlayerCS(clientNum, "c")) == 1 then
    et.gentity_set(clientNum, "ps.ammoclip", 11, AMOUNT)
    et.gentity_set(clientNum, "ps.ammo", 11, AMOUNT)
  end
end