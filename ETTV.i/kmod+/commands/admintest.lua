-- !admintest
function dolua(params)

	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

	COMMAND = "admintest"
	HEADING = COMMAND_COLOR .. COMMAND .. "^:: " ..COMMAND_COLOR

	if params["slot"] ~= nil then
		local PlayerID = tonumber(params["slot"])
		if  PlayerID ~= nil then
			local name = et.gentity_get(PlayerID,"pers.netname")
			local GUID = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( PlayerID ), "cl_guid" ))
			if ( global_admin_table[GUID] ~= nil ) then
				local level = AdminUserLevel(PlayerID)
				if (level_flag(level,"@") )  then -- "incognito" - display admin as level 0
					--et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s\"',params["say"],HEADING .. name ..COMMAND_COLOR.. " is a level " .. 0 .. " user ( ".. global_level_table[0]["name"] ..COMMAND_COLOR .." )" ))
					et.trap_SendServerCommand(-1, "chat \""..HEADING .. name ..COMMAND_COLOR.. " is a level " .. 0 .. " user ( ".. global_level_table[0]["name"] ..COMMAND_COLOR .." ) \"" )
				else
					--et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s\"',params["say"],HEADING .. name ..COMMAND_COLOR.. " is a level " .. global_admin_table[GUID]["level"] .. " user ( ".. global_level_table[global_admin_table[GUID]["level"]]["name"] ..COMMAND_COLOR .. " )" ))
					et.trap_SendServerCommand(-1, "chat \""..HEADING .. name ..COMMAND_COLOR.. " is a level " .. global_admin_table[GUID]["level"] .. " user ( ".. global_level_table[global_admin_table[GUID]["level"]]["name"] ..COMMAND_COLOR .. " ) \"" )
				end

			else
				--et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s\"',params["say"],HEADING .. name .. COMMAND_COLOR.. " is a level " .. 0 .. " user ( ".. global_level_table[0]["name"] ..COMMAND_COLOR .." )" ))
				et.trap_SendServerCommand(-1, "chat \""..HEADING .. name .. COMMAND_COLOR.. " is a level " .. 0 .. " user ( ".. global_level_table[0]["name"] ..COMMAND_COLOR .." ) \"" )
			end
		end
	end
	return 1
end