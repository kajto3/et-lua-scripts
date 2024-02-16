function dolua(params)
	if (string.lower(et.trap_Argv(1)) == "map") then
		return 1 -- intercept
	end
	
	if (string.lower(et.trap_Argv(1)) == "kick") then
		local slot = getPlayernameToId(et.trap_Argv(2))
		if slot ~= nil then
			if params.slot < AdminUserLevel(slot) then
				return 1 -- ref is trying to kick a higher level admin, abort!
			end
		end
	end

end

