---------------------
--  etproguidlog lua script
---------------------
--  DESCRIPTION:
--  Logs etproguids to a file (user can define).

--  INSTRUCTIONS:
--  Place this file in your etpro folder.  
--  Add the line:  set lua_modules "etproguidlog_v2.lua" to your server cfg.
--  Restart your server (or load a map or config).
--  The file will be written into your working etpro folder on the server.

--  GhosT:McSteve
--  www.ghostworks.co.uk
--  #ghostworks, #pbbans @quakenet
--  Version 2, 10/2/07


-----------------------------------------------------------------------------
-- ADMIN - SET OPTIONS HERE
etproguid_logging = 1	-- 1/0 = on/off
guidfilename = "etproguids.txt"		-- set the name of the file to capture etproguids (will be created in etpro folder)


-- called when a client enters the game world
function et_ClientBegin( cno )
	-- when client begins, pickup and clean his name, store it in cnoname (activates et_print when != nil)
	tempname = et.Info_ValueForKey( et.trap_GetUserinfo( cno ), "name" )
	cnoname = et.Q_CleanStr( tempname )	

	tempcl_guid = et.Info_ValueForKey( et.trap_GetUserinfo( cno ), "cl_guid" )
	tempip = et.Info_ValueForKey( et.trap_GetUserinfo( cno ), "ip" )
end

function et_Print(text)

	if cnoname == nil then return end
	
	cleantext = et.Q_CleanStr( text )

	tempvar1 = string.find(cleantext,"etpro IAC:")
	if tempvar1 then
		
		tempvar2 = string.find(cleantext, "GUID")
		if tempvar2 then
			--et.G_Print( )
			-- write the string (cleantext) to a file
			
			if etproguid_logging == 1 then

				--tempuserinfo = et.Q_CleanStr((et.trap_GetUserinfo( cno ))
				--et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay \"^3runtime "  .. tempuserinfo .. "\"\n")

				info = os.date("%x %I:%M:%S%p") .. " " .. cleantext .. " CL_GUID [" .. tempcl_guid .. "] IP [" .. tempip ..  "]" .."\n"

				fd,len = et.trap_FS_FOpenFile(guidfilename, et.FS_APPEND)
				count = et.trap_FS_Write(info, string.len(info), fd)
				et.trap_FS_FCloseFile(fd)
				fd = nil
			end

		cnoname = nil
		tempcl_guid = nil
		tempip = nil
		end		
	end
end

