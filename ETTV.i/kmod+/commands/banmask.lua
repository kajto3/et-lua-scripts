-- !ban necro 20 you suck!
function dolua(params)

	if params.slot ~= CONSOLE then
		-- make it look like the player has used the command in chat
		userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)	
	end

	COMMAND = "banmask"
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR
	local define = {}
	local victim

	define["msg_syntax"] = HEADING .. " !" .. COMMAND .. " [name|slot]"
	define["msg_no_target"] =  HEADING .."<PARAM>" .. COMMAND_COLOR.. " is not on the server!"
	define["msg_higher_admin"] = HEADING .. "cannot target a higher level"
	define["reqired_params"] = 1
	victim = readyCommand(params,define)

	if victim ~= -1 then
		runcommand("ban",params)
		local fd, len = et.trap_FS_FOpenFile('kmod+/misc/banmask.dat', et.FS_APPEND )
		if len == -1 then -- file does not exist
			et.trap_FS_FCloseFile( fd )	
			fd, len = et.trap_FS_FOpenFile('kmod+/misc/banmask.dat', et.FS_WRITE )
			if len == -1 then
				et.G_Print("K_ERROR: unable to open/create banmask.dat\n")
				et.trap_FS_FCloseFile( fd )	
				return
			end
		end
		


		local name = et.Info_ValueForKey( et.trap_GetUserinfo( victim ), "name" )
		local ip = {}
		ip[0] = string.gsub(et.Info_ValueForKey( et.trap_GetUserinfo( victim ), "ip" ), "%:%d+", "")

		
		s,e,ip[1],ip[2],ip[3],ip[4] = string.find(ip[0], "(%d+).(%d+).(%d+).(%d+)")
		ip = ip[1] .. "." .. ip[2]
		local admin 
		if params["slot"] == "console" then 
			admin = "^wconsole" 
		else
			admin = et.Info_ValueForKey( et.trap_GetUserinfo( params["slot"] ), "name" )
		end
		local ban = ip ..  " - " .. name .. "\n"
		global_banmask_table[ip] = name

		if ( len > -1 ) then
			et.trap_FS_Write( ban, string.len(ban) ,fd )
		end

		et.trap_FS_FCloseFile( fd )
		et.trap_DropClient( victim, "you are banned from this server")
		et.G_Print("Banmask: " .. name .. " - " .. ip .. "\n")
		-- announce the player has been banned!
		et.trap_SendServerCommand( -1 , string.format('%s \"%s"',params["say"],HEADING .. name ..COMMAND_COLOR.. " ip mask has been banned" ))
		et.trap_SendServerCommand( -1 , string.format('%s \"%s"',"cpm",HEADING .. name ..COMMAND_COLOR.. " ip mask has been banned" ))
	
	end


end

