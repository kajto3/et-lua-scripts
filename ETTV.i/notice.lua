	

    --Register the mod
    function et_InitGame(levelTime,randomSeed,restart)
            et.RegisterModname("info")
    end
     
    -- Number of rules
    NUMRULES = 4
     
    rules = {
            "Data.hourb.com",
            "Play fair!",
            "Respect other people",
            "No Glitching"
    }
     
    -- Website url
    WEBSITE = "http://data.hourb.com"
    EVENTS = "http://facebook.com/nrtj"
     
    function et_ClientCommand(clientNum, command)
            command = string.lower(command)
                    -- /rules
                    if (command == "rules") then
                            for i=1,(NUMRULES),1 do
                           
                                    et.trap_SendServerCommand(clientNum, "print \"" .. rules[i] .."^7\n\"")
                                   
                    end
                    return 1
                   
                    -- /website
                    elseif (command == "website") then
                   
                            et.trap_SendServerCommand(clientNum, "print \"" .. WEBSITE .."^7\n\"")
                           
                    return 1
                    end
                   
                    -- /forum
                    elseif (command == "events") then
                   
                            et.trap_SendServerCommand(clientNum, "print \"" .. EVENTS .."^7\n\"")
                           
                    return 1
                    end
    end
