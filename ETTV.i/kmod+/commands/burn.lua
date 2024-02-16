-- !burn slot or name, amount, reason
function dolua(params) 
	COMMAND = "burn"
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR

	local say_parms = "qsay"
	local slot = tonumber(params.slot)
	local PID = params[1]
	local clientnum = tonumber(PID) 
	if clientnum then 
		if (clientnum >= 0) and (clientnum < 64) then 
			if et.gentity_get(clientnum,"pers.connected") ~= 2 then 
				et.trap_SendServerCommand(slot, "b 8 \"^3Burn: ^gThere is no client associated with this slot number^7\"") 
				return 
			end 
			if et.gentity_get(clientnum,"sess.sessionTeam") >= 3 or et.gentity_get(clientnum,"sess.sessionTeam") < 1 then
				et.trap_SendServerCommand(slot, "b 8 \"^3Burn: ^gClient is not actively playing^7\"") 
				return 
			end 
			if et.gentity_get(clientnum,"health") <= 0 then
				et.trap_SendServerCommand(slot, "b 8 \"^3Burn: ^gClient is currently dead^7\"") 
				return
			end
		else
			et.trap_SendServerCommand(slot, "b 8 \"^3Burn: ^gPlease enter a slot number between 0 and 63^7\"") 
			return 
		end 
   	else 
      		if PID then 
			local s,e
			s,e=string.find(PID, PID)
			if e <= 2 then
				et.trap_SendServerCommand(slot, "b 8 \"^3Burn: ^gPlayer name requires more than 2 characters^7\"") 
				return
			end
			clientnum = getPlayernameToId(PID)
      		end 
		if not clientnum then 
			et.trap_SendServerCommand(slot, "b 8 \"^3Burn: ^gTry name again or use slot number^7\"") 
			return 
		end 
	end 
	if et.gentity_get(clientnum,"sess.sessionTeam") >= 3 or et.gentity_get(clientnum,"sess.sessionTeam") < 1 then 
		et.trap_SendServerCommand(slot, "b 8 \"^3Burn: ^gClient is not actively playing^7\"") 
		return 
	end 
	if et.gentity_get(clientnum,"health") <= 0 then
		et.trap_SendServerCommand(slot, "b 8 \"^3Burn: ^gClient is currently dead^7\"") 
		return
	end
	-- Rany B get all params of the reason
	local i 
	local param2 = tonumber(params[2]) 
	local param3 = ""
	if (param2 == nil) then	param2 = 15
				i = 2
	else	i = 3
	end
	while (params[i] ~= nil) do
		param3 = param3 .. params[i] .." "
		i = i + 1
	end
	-- Rany E get all params of the reason
	if (param3 == "" or param3 == " ") then
		et.trap_SendServerCommand(slot, "b 8 \"^2Please enter a reason^7\"") 
		return 
	end 

	if (et.gentity_get(clientnum,"health") - param2 < 1) then
		et.trap_SendServerCommand(slot, "b 8 \"^3Burn: ^1You're not allowed to kill the client using ^g!burn^7\"") 
	else
		et.gentity_set(clientnum,"health",(et.gentity_get(clientnum,"health")-param2))
		local	slapsound = "sound/player/hurt_barbwire.wav"
		soundindex = et.G_SoundIndex(slapsound)
		et.G_Sound( clientnum,  soundindex)
		et.trap_SendServerCommand(-1, "b 8 \"^7" .. et.gentity_get(clientnum,"pers.netname") .. " ^7was ^1Burned^7.\"")
		et.trap_SendServerCommand(-1, "b 8 \"^2Reason: ^g" ..param3.. "^7\"") 
	end
end