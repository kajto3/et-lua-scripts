Modname = "CMPGNblock"
Version = "1.0"
Author  = "^wMNwa^0!"
Description = "^wPublic Settings"
Homepage = "www.gs2175.fastdl.de "
 
--global vars
samplerate = 200
--


function et_InitGame(levelTime,randomSeed,restart)
	et.G_Print("[CMPGNblock] Version:"..Version.." Loaded\n")
	et.RegisterModname(Modname .. " " .. Version)  
end

function et_ClientCommand(client, command)
	if string.lower(command) == "callvote" then
		if et.trap_Argv(1) == "campaign" then
			if et.trap_Argv(2) == "cmpgn_centraleurope" or et.trap_Argv(2) == "cmpgn_northafrica" then
				et.trap_SendServerCommand(client, "chat \"^1Console: ^3Campaign has been disabled\"" ) 
				return 1
			end
		end
	end
end