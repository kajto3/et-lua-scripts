function dolua(params)

	
	COMMAND = "showmask"
	HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR
	-- banner line supports up to 97 charactars in 1 line
	local i = 1
	local name
	local ip1,ip2
	local fd,len = et.trap_FS_FOpenFile( 'kmod+/misc/banmask.dat', et.FS_READ )
	--local spaces = 20
	local spaces = 15
	local message

	
	if len <= 0 then
		if params["slot"] == "console" then
			et.G_Print(HEADING .. "no bans defined \n")
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],HEADING .. "no bans defined"))
		end
	else
		local filestr = et.trap_FS_Read( fd, len ) --        ip " - " name
		message = COMMAND_COLOR .. "# " .. "ip adress" .. string.rep(" ", spaces - string.len("ip adress")) 
		message = message .. "player" .. string.rep(" ", spaces - string.len("player")) 
		if params["slot"] == "console" then
			et.G_Print(message .. "\n")
		else
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],message)) 
		end
		for ip1,ip2,name in string.gfind(filestr, "%s*(%d+).(%d+)%s*-%s*([^%\n]*)%s*") do
			--et.G_Print(name .. " " .. guid .. " " .. admin .. " " .. reason .. "\n")
			--et.G_Print("crap - " .. name .. " | " .. guid .. " | " .. ip .. " | " .. reason .. "\n");
			message = COMMAND_COLOR .. i .. " "
			message = message .. ip1 .. "." .. ip2 .. string.rep(" ", spaces - string.len(ip1 .. "." .. ip2))
			message = message .. "^w" .. name 
			if params["slot"] == "console" then
				et.G_Print(message.. "\n")
			else
				et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],message))
			end
			i = i+1
		end
	end
	return 1
end