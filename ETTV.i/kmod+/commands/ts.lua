
if params.slot ~= CONSOLE then
	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
end

et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3Join ^four TeamSpeak server: ^3109.70.149.30:9987"))

return 1