-- 	a simple lua script,which will change cvars every new mapstart , without creating any map configs --
-- 	MODS : ETPRO , NOQUARTER --
-- 	Author : StoerFaktoR --
-- 	contact : stoerfaktor80@chris-s.de --
-- 	url : http://combat-funzone.de


	mod_version = "1.0"

-- 	CVARS to change

	fps = "com_maxfps 125"
-- 	fps = "com_maxfps IN 76 125"  -- alternative you can use punkbuster settings like "com_maxfps IN 76 125" (see in line 25)
	atmosphericeffects = "cg_atmosphericeffects 0"
	drawfoliage = "r_drawfoliage 0"
	maxpackets = "cl_maxpackets 100"
	rate = "rate 25000"
	snaps = "snaps 40"
	timenudge = "cl_timenudge 0"
	wolffog = "r_wolffog 0"
	wolfparticles = "cg_wolfparticles 0"


function et_ClientConnect( clientNum, firstTime, isBot )
	--[[  example
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "pb_sv_cvar\ " .. fps .. "\n")
	--]]
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "forcecvar\ " .. fps .. "\n")
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "forcecvar\ " .. atmosphericeffects .. "\n")
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "forcecvar\ " .. drawfoliage .. "\n")
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "forcecvar\ " .. maxpackets .. "\n")
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "forcecvar\ " .. rate .. "\n")
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "forcecvar\ " .. snaps .. "\n")
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "forcecvar\ " .. timenudge .. "\n")
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "forcecvar\ " .. wolffog .. "\n")
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "forcecvar\ " .. wolfparticles .. "\n")	
	
	-- Infos via center print and console
	
	et.trap_SendServerCommand(clientNum, "cp \"^7Your Settings has been ^1forced...\n ^7More infos you will find in your console\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^1******************************************\n\"")		
	et.trap_SendServerCommand(clientNum, "print \"^1********************************************\n\"")		
	et.trap_SendServerCommand(clientNum, "print \"^1**********************************************\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^1************************************************\n\"")
	et.trap_SendServerCommand(clientNum, "print \" \n\"")	
	et.trap_SendServerCommand(clientNum, "print \"^7Your Settings has been changed automatically\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7for a better and smoother\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7game experience\n\"")
	et.trap_SendServerCommand(clientNum, "print \" \n\"")
	et.trap_SendServerCommand(clientNum, "print \"^1CHANGED SETTINGS:\n\"")
	et.trap_SendServerCommand(clientNum, "print \" \n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7Atmosphericeffects = ^1OFF\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7Foliages = ^1OFF\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7FPS = ^3125\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7MaxPackets = ^3100\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7Rate = ^325000\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7Snaps = ^340\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7Timenudge = ^30\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7Fog = ^1OFF\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7Particles = ^1OFF\n\"")	
	et.trap_SendServerCommand(clientNum, "print \" \n\"")
	et.trap_SendServerCommand(clientNum, "print \"^7Please ^1do not change ^7any settings or you get\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^1KICKED ^7from this server\n\"")	
	et.trap_SendServerCommand(clientNum, "print \" \n\"")	
	et.trap_SendServerCommand(clientNum, "print \"^1************************************************\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^1**********************************************\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^1********************************************\n\"")
	et.trap_SendServerCommand(clientNum, "print \"^1******************************************\n\"")	
end	

function et_InitGame( levelTime, randomSeed, restart )
	et.RegisterModname( "force_cvars " .. mod_version .. " " .. et.FindSelf() )
end	
