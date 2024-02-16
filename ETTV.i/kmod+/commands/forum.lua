
-- make it look like the player has used the command in chat
userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)	
et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^:et.Splatterladder.com"))
return 1