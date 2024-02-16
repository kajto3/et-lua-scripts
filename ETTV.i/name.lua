-- this lua module prevents the kicks for "name too short" and duplicate name (caused when two players use the ultimate ET installer and do not change the default name)
-- renames short names to at least 4 charactars long
-- renames duplicate names


LENGTH = tonumber(et.trap_Cvar_Get("PB_SV_MinName")) or 4

function et_ClientBegin( slot ) 
	if check_short_name(slot) then
		rename_longer(slot)
	end
	if check_duplicated_name(slot) then
		rename_duplicate(slot)
	end
end

function et_ClientUserinfoChanged( slot ) -- run same checks as ClientBegin
	if check_short_name(slot) then
		rename_longer(slot)
	end
	if check_duplicated_name(slot) then
		rename_duplicate(slot)
	end
end

function check_short_name(slot) 
	local name = et.Q_CleanStr(et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "name" ))
	local long = string.len(name)
	if long < LENGTH then
		return 1
	end
	return
end

function rename_longer(slot)
	local name = et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "name" )
	local strip = et.Q_CleanStr(name)
	local long = string.len(strip)
	local diff = LENGTH - long
	local i
	for i=1,diff,1 do
		name = name .. i
	end
	-- apply name change
	local userinfo = et.trap_GetUserinfo(slot)
	userinfo = et.Info_SetValueForKey(userinfo, "name", name)
	et.trap_SetUserinfo(slot, userinfo)
	et.ClientUserinfoChanged(slot)
end

function check_duplicated_name(slot)
	
	local name = et.Q_CleanStr(et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "name" ))
	local i
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
		if i ~= slot then
			local temp = et.Q_CleanStr(et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" ))
			if string.lower(temp) == string.lower(name) then
				return 1
			end
		end
	end
	return
end

function rename_duplicate(slot)
	local name = et.Info_ValueForKey( et.trap_GetUserinfo( slot ), "name" )
	local strip = et.Q_CleanStr(name)
	local temp
	local j = 0
	local i
	local flag = 0
	repeat
		flag = 0
		j = j+1
		temp = name .. j
		for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
			if i ~= slot then
				local nick = et.Q_CleanStr(et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" ))
				if string.lower(nick) == string.lower(temp) then
					flag = 1
				end
			end
		end
	until flag == 0

	-- apply name change
	local userinfo = et.trap_GetUserinfo(slot)
	userinfo = et.Info_SetValueForKey(userinfo, "name", temp)
	et.trap_SetUserinfo(slot, userinfo)
	et.ClientUserinfoChanged(slot)	
end
