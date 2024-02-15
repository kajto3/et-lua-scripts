function et_InitGame(levelTime, randomSeed, restart)
	et.RegisterModname("Anti Teamswitch")

end

function et_ClientCommand( clientNum, command )
	local arg0 = string.lower(et.trap_Argv(0))
	local arg1 = string.lower(et.trap_Argv(1))
	local arg2 = string.lower(et.trap_Argv(2))
        gamestate = tonumber(et.trap_Cvar_Get("gamestate"))
	if gamestate == 3 then
                if arg0 == "team" then
		et.trap_SendServerCommand(clientNum, "chat \"No team switch allowed during intermission (Map-voting bug disabled :-) ).")
                return 1
        end
	end
end



--function et_RunFrame(levelTime)
--	gamestate = tonumber(et.trap_Cvar_Get("gamestate"))
--	et.trap_SendServerCommand(-1, "chat \"Gamestate is .".. gamestate .."\n")
--end























