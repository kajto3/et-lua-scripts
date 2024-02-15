--Script made for Kodes needs :P

--Setlevel command (!setlevel will work with this too)
setlevel_cmd 	= "!set"

--Maximal level to set if your level isn't in level_table
maxlevelrest 	= 8

--Admins over/same level are allowed to setlevel each value
allowedadmins 	= 18

--getadminlevel is the level of the executing admin
--maxlevel is the maximal level he is allowed to set
level_table = {
    { getadminlevel = 12, 			maxlevel = 8, },
	{ getadminlevel = 13, 			maxlevel = 10, },
	{ getadminlevel = 14, 			maxlevel = 11, },
	{ getadminlevel = 15, 			maxlevel = 11, },  
	{ getadminlevel = 16, 			maxlevel = 12, },  
	{ getadminlevel = 17, 			maxlevel = 14, },     	
}

--Text which is shown to the admins
text = "^1WARNING: ^3You are just allowed to use "..setlevel_cmd.." till^1"

----------------------end of config-----------------------------


function et_ClientCommand(clientNum, command)
    local cmd = string.lower(command)
	local arg0 = string.lower(et.trap_Argv(0))
	if arg0 == "say" or arg0 == "say_team" or arg0 == "say_buddy" or arg0 == "say_teamnl" then
		if string.find(et.trap_Argv(1), "^" .. setlevel_cmd .. "") then
			if et.trap_Argv(2) and tonumber(et.trap_Argv(3)) then --if admin typed in console
				for _, line in ipairs(level_table) do
					if tonumber(et.G_shrubbot_level(clientNum)) == line.getadminlevel then
						local maxlevel = line.maxlevel
						if tonumber(et.trap_Argv(3)) > maxlevel then
							et.trap_SendServerCommand(clientNum,"chat \""..text.." "..maxlevel.."\"")
							return 1
						end
					elseif tonumber(et.trap_Argv(3)) <= maxlevelrest and tonumber(et.G_shrubbot_level(clientNum)) < allowedadmins then
							et.trap_SendServerCommand(clientNum,"chat \""..text.." "..maxlevelrest.."\"")
							return 1
					end
				end
			else --if admin typed in chat window
				for _, line in ipairs(level_table) do
					local findnumber = string.gfind(et.trap_Argv(1), "%s"..line.maxlevel.."") --need a way to find the number. "et.trap_Argv(1)" is always the whole text (!set name number).
					if findnumer == nil then et.trap_SendServerCommand(clientNum,"chat \"^3Use console to use '"..setlevel_cmd.."' command, please. Open it with ^\"") return 1 end
					--[[ --Took it out since I don't know a way to find out the number
					if tonumber(et.G_shrubbot_level(clientNum)) == line.getadminlevel then
						local maxlevel = line.maxlevel
						if tonumber(findnumber) > maxlevel then
							et.trap_SendServerCommand(clientNum,"chat \""..text.." "..maxlevel.."\"")
							return 1
						end
					elseif tonumber(findnumber) <= maxlevelrest and tonumber(et.G_shrubbot_level(clientNum)) < allowedadmins then
							et.trap_SendServerCommand(clientNum,"chat \""..text.." "..maxlevelrest.."\"")
							return 1
					end
					--]]
				end
			end
		end
	elseif string.find(cmd, "^" .. setlevel_cmd .. "") then --in case admin used a slash (/) before ! -> /!set player 4
		if et.trap_Argv(1) then
			for _, line in ipairs(level_table) do
				if tonumber(et.G_shrubbot_level(clientNum)) == line.getadminlevel then
					local maxlevel = line.maxlevel
					if tonumber(et.trap_Argv(2)) > maxlevel then
						et.trap_SendServerCommand(clientNum,"chat \""..text.." "..maxlevel.."\"")
						return 1
					end
				elseif tonumber(et.trap_Argv(2)) <= maxlevelrest and tonumber(et.G_shrubbot_level(clientNum)) < allowedadmins then
						et.trap_SendServerCommand(clientNum,"chat \""..text.." "..maxlevelrest.."\"")
						return 1
				end
			end
		end
	end
	return 0
end
---------------------------------------------------------------------