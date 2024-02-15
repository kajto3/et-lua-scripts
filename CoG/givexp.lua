

function giveXP(target, xp)
	local target = target
	local xp = tonumber(xp)
	local XPbyLevel = (xp/7)
	for i=0,6,1 do
		et.G_XP_Set ( target , XPbyLevel, i, 1 )
	end
end

function et_clientCommand(clientNum, command)

	arg = string.lower(et.trap_Argv(0))
	cmd = string.lower(et.trap_Argv(1))
	arg1 = string.lower(et.trap_Argv(2))
	afterMain = et.ConcatArgs(1)
	adminlvl = et.G_shrubbot_level(clientNum)

		if arg == "givexp" then
			local maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))-1
			tID = tonumber(cmd)
			if tID == nil then
				tID = et.ClientNumberFromString (cmd)
			end
			if tID == nil or tID < 0 then
				et.trap_SendServerCommand(clientNum,string.format("chat \" %s: Please use a slot number from the list below: \n\"",cmd))
				printSlotbyName(cmd, clientNum)
				return 
			end
	
			if tID > maxclients then 
				et.trap_SendServerCommand(clientNum,string.format("chat \" Invalid slot number #%s: Insert a slot number between 0 and %s\n\"",cmd, maxclients))
				return
			end	
	
			if et.gentity_get(tID,"pers.connected") ~= 2 then
				et.trap_SendServerCommand(clientNum,string.format("chat \" %s: Client not connected!: \n\"",tID))
				return
			end
			if adminlvl >= 13 then
				giveXP (tID,arg1)
				et.trap_SendServerCommand(clientNum, string.format("chat \"^3Added "..arg1.." xp to client slot "..tID.."\n"))
				return 1
			else
				return 0
			end
		end   
end
