sv_maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))

function et_RunFrame(levelTime)
    for i=0, sv_maxclients-1 do
           et.gentity_set(i, "ps.powerups", 12, levelTime + 10000 )
    end
end 