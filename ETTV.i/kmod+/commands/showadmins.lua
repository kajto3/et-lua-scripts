-- !showadmins
function dolua(params) 
	local fd,len = et.trap_FS_FOpenFile( "kmod+/misc/shrubbot.dat", et.FS_READ )
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay ^3length: " ..len.. "^7\n" )
	if len <= 0 then
		et.G_Print("WARNING: No Admins's Defined! \n")
	else
		local filestr = et.trap_FS_Read( fd, len )
	
		for level,guid,Name in string.gfind(filestr, "(%d)%s%-%s(%x+)%s%-%s*([^%\n]*)") do
			-- upcase for exact matches
			GUID = string.upper(guid)
			et.G_Print( "Name  = " ..Name.. "\nLevel = " ..level.. "\n\n")
		end
	end
	et.trap_FS_FCloseFile( fd ) 

end