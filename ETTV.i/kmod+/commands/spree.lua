-- !spree_record
function dolua(params) 

	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
	end

	local slot = tonumber(params.slot) or -1
	local oldspree = tostring(oldspree2)
	local oldmapspree = tostring(oldmapspree2)
	et.trap_SendServerCommand(slot, ("b 8  \"^7"..oldspree .."^7\""))
	et.trap_SendServerCommand(slot, ("b 8  \"^7"..oldmapspree.."^7\""))
	return 1
end