    spawndistance = 400
     
     
    function et_InitGame(levelTime,randomSeed,restart)
            mclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
            mapname = et.trap_Cvar_Get( "mapname" )
            local loadtable = loadfile(et.trap_Cvar_Get("fs_homepath") .. '/etpub/spawns/'..mapname..'.lua') --- load spawns table
            if loadtable ~= nil then
                    loadtable()
            else
                    --et.trap_SendServerCommand(-1, "chat \"^3LOADSPWANPOINTS^7: ^7No valid spawnsfile found for this map.\"" )
                    et.G_Print("WARNING: SPAWNPOINTS failed to load "..mapname..".lua\n")
                    quit = 1
            end
    end
     
    function dist(a ,b)
       local dx = math.abs(b[1] - a[1])
       local dy = math.abs(b[2] - a[2])
       local dz = math.abs(b[3] - a[3])
       local d = math.sqrt((dx ^ 2) + (dy ^ 2) + (dz ^ 2))
       return math.floor(d / 52.4934)
    end
     
    function et_ClientSpawn(cno,revived)
            execute = 1
            if quit ~= 1 then
                    while execute == 1 do
                            rpos = {}
                            spawn = randomspawn()
                                    for i=0, mclients-1, 1 do
                                            if et.gentity_get(i,"pers.connected") == 2 and cno ~= i then
                                                    CurrentPos(i)                  
                                            end
                                    end
                            table.sort(rpos)
                    if rpos[1] == nil then execute = 0 break end
                    end
            et.gentity_set(cno, "origin", spawn)
            end
    end
     
    function randomspawn()
            local random = SPAWN[math.random(table.getn(SPAWN))]
            return random
    end
     
    function CurrentPos(cno)
            local cnopos = et.gentity_get(cno,"r.currentOrigin")
            distance = dist(cnopos,spawn)
            if distance > spawndistance then
                    table.insert(rpos,distance)
            end
    end
