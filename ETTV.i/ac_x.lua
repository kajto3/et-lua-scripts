	

    fps             = 0
    maxclients      = 0
    function et_InitGame( levelTime, randomSeed, restart )
     
            maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
            fps = tonumber( et.trap_Cvar_Get( "sv_fps" ) ) * 60
           
    end
     
    function et_RunFrame( levelTime )
     
            if math.mod(levelTime, myTime) == 0 then
                   
                    for i = 0, (maxclients-1) do
                   
                            et.G_QueryClientCvar( i, "wl_wallhack" )
                   
                    end
     
            end
     
    end
     
    function et_CvarValue( clientNum, cvar, value )
     
            local nick = et.gentity_get(clientNum, "pers.netname")
            et.trap_SendConsoleCommand( et.EXEC_NOW, "^:ggwp \"^:!! ^:" .. nick .. " ^:(ID: ^3" .. clientNum .. "^8) ^:/" .. cvar  .. " " .. value .. " \" \n" )
           
            --[[
            if et.G_shrubbot_level( clientNum ) < 999 then
                    et.trap_SendConsoleCommand( et.EXEC_NOW, "!ban " .. clientNum .. " \"whitelight hack\"\n" )
            end
            ]]--
     
    end
