function dolua(params)
	if ( params[1] ~= nil ) then
	
		local client = tonumber(params[1])
		if client == nil then -- its a player's name
			client = getPlayernameToId(params[1])
		end
		-- either a slot or the victim doesnt exist
		if client ~= nil then
			et.gentity_set(params.slot,"sess.spectatorState", 2)
			et.gentity_set(params.slot,"sess.spectatorClient", client)
			et.gentity_set(params.slot,"sess.latchSpectatorClient", client)
			et.trap_SendServerCommand(params.slot, string.format('%s \"%s\n\"',"print","^wfollowing " .. et.gentity_get(client,"pers.netname")))
			return 1
		end
	end
end

 