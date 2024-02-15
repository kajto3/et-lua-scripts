dump_cfg 	= "recruitment.txt"
report_cfg 	= "report.txt"
join_cmd = "!joinclan"
report_cmd = "!report"
adminlvl = 12
joinname = "^7Hide^8&^7Seek"


date_fmt 	= "%Y-%m-%d, %H:%M:%S"
version 	= "0.3"
samplerate = 200
antispam = {}
antispam2 = {}
request = {}
report = {}
tempname = {}
cnoname = {}
tempcl_guid = {}
tempip = {}
message = {}

function et_InitGame(levelTime, randomSeed, restart)

    et.RegisterModname("dump.lua "..version.." "..et.FindSelf())
    maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))
	for i = 0, maxclients - 1 do
		antispam[i] = 0
		antispam2[i] = 0
		request[i] = 0
		report[i] = 0
		message[i] = ""
	end
end

function et_ClientBegin( cno )
	-- when client begins, pickup and clean his name, store it in cnoname (activates et_print when != nil)
	tempname[cno] = et.Info_ValueForKey( et.trap_GetUserinfo( cno ), "name" )
	cnoname[cno] = et.Q_CleanStr( tempname[cno] )	

	tempcl_guid[cno] = et.Info_ValueForKey( et.trap_GetUserinfo( cno ), "cl_guid" )
	tempip[cno] = et.Info_ValueForKey( et.trap_GetUserinfo( cno ), "ip" )
	
	if et.G_shrubbot_level(cno) >= adminlvl and request[cno] == 1 then
		et.trap_SendServerCommand(cno, "chat \"^1Recruitment: ^wCheck out ^3"..dump_cfg.." ^wfor new requests! \"" )
		et.trap_SendServerCommand(cno, "cpm \"^1Recruitment: ^wCheck out ^3"..dump_cfg.." ^wfor new requests! \"" )
		request[cno] = 0
	elseif et.G_shrubbot_level(cno) >= adminlvl and report[cno] == 1 then
		et.trap_SendServerCommand(cno, "chat \"^1Report: ^wCheck out ^3"..report_cfg.." ^wfor new reports! \"" )
		et.trap_SendServerCommand(cno, "cpm \"^1Report: ^wCheck out ^3"..report_cfg.." ^wfor new reports! \"" )
		report[cno] = 0
	end
end

function et_RunFrame( levelTime )
if math.mod(levelTime, samplerate) ~= 0 then return end
 for cno = 0, maxclients - 1 do
	if et.G_shrubbot_level(cno) >= adminlvl and request[cno] == 1 then
		et.trap_SendServerCommand(cno, "chat \"^1Recruitment: ^wCheck out ^3"..dump_cfg.." ^wfor new requests! \"" )
		et.trap_SendServerCommand(cno, "cpm \"^1Recruitment: ^wCheck out ^3"..dump_cfg.." ^wfor new requests! \"" )
		request[cno] = 0
	elseif et.G_shrubbot_level(cno) >= adminlvl and report[cno] == 1 then
		et.trap_SendServerCommand(cno, "chat \"^1Report: ^wCheck out ^3"..report_cfg.." ^wfor new reports! \"" )
		et.trap_SendServerCommand(cno, "cpm \"^1Report: ^wCheck out ^3"..report_cfg.." ^wfor new reports! \"" )
		report[cno] = 0
	end
 end
end

function et_ClientCommand(clientNum, command) -- get client commands
	if string.lower(et.trap_Argv(0)) == "say" or string.lower(et.trap_Argv(0))  == "say_team" or string.lower(et.trap_Argv(0))  == "say_buddy" or et.trap_Argv(0) == string.lower(command) then
	--local s, e, reason = string.find(et.trap_Argv(1), "^" .. join_cmd .. " ([%w%s]+)$")
		if string.find(et.trap_Argv(1), "^" .. join_cmd .. "") and not string.find(et.trap_Argv(1), "^" .. report_cmd .. "") then
		--if string.lower(et.trap_Argv(1)) == join_cmd then
		if et.trap_Argc() > 1 then
        -- build message
       
        for i = 1, et.trap_Argc() - 1, 1 do
          message[clientNum]  = message[clientNum]  .. et.trap_Argv(i) .. " "
        end
		if antispam[clientNum] == 1 then
				et.trap_SendServerCommand(clientNum, "chat \"^wYou already requested to join "..joinname.." \"" )
				et.trap_SendServerCommand(clientNum, "chat \"^wWait till an admin replies please. \"" )
		else
		if message[clientNum] == "!join " then
				et.trap_SendServerCommand(clientNum, "chat \"^wAdd a join ^1reason^w, please! ^3-> ^w!join text \"" )
		else
			if antispam[clientNum] == 0 then
				et.G_Print("Player: - "..playerName(clientNum).." - requested to join.\n")
				et.trap_SendServerCommand(clientNum, "chat \"^wThank you for your request to join "..joinname.."\"" )
				et.trap_SendServerCommand(clientNum, "chat \"^wAn admin has been notified.\"" )
				info = os.date("%x %I:%M:%S%p") .. ", PLAYER: "..playerName(clientNum)..", PBGUID: [" .. tempcl_guid[clientNum] .. "], IP: [" .. tempip[clientNum] .. "], TEXT: [" .. message[clientNum] .. "] " .."\n"
						
				fd,len = et.trap_FS_FOpenFile(dump_cfg, et.FS_APPEND)
				count = et.trap_FS_Write(info, string.len(info), fd)
				et.trap_FS_FCloseFile(fd)
				fd = nil
				request[clientNum] = 1
				antispam[clientNum] = 1
			end
		end --end line 84
		return 1
		end --end line 80
		end --end line 74
		
		elseif string.find(et.trap_Argv(1), "^" .. report_cmd .. "") and not string.find(et.trap_Argv(1), "^" .. join_cmd .. "") then
		if et.trap_Argc() > 1 then
        -- build message
       
        for i = 1, et.trap_Argc() - 1, 1 do
          message[clientNum]  = message[clientNum]  .. et.trap_Argv(i) .. " "
        end
		if antispam2[clientNum] == 1 then
				et.trap_SendServerCommand(clientNum, "chat \"^wYou already filled out report. \"" )
				et.trap_SendServerCommand(clientNum, "chat \"^wWait till an admin replies please. \"" )
		else
		if message[clientNum] == "!report " then
				et.trap_SendServerCommand(clientNum, "chat \"^wAdd a ^1text^w, please! ^3-> ^w!report text \"" )
		else
			if antispam2[clientNum] == 0 then
				et.G_Print("Player: - "..playerName(clientNum).." - filled out a report.\n")
				et.trap_SendServerCommand(clientNum, "chat \"^wThank you for your report at "..joinname.."\"" )
				et.trap_SendServerCommand(clientNum, "chat \"^wAn admin has been notified.\"" )
				info = os.date("%x %I:%M:%S%p") .. ", PLAYER: "..playerName(clientNum)..", PBGUID: [" .. tempcl_guid[clientNum] .. "], IP: [" .. tempip[clientNum] .. "], TEXT: [" .. message[clientNum] .. "] " .."\n"
						
				fd,len = et.trap_FS_FOpenFile(report_cfg, et.FS_APPEND)
				count = et.trap_FS_Write(info, string.len(info), fd)
				et.trap_FS_FCloseFile(fd)
				fd = nil
				report[clientNum] = 1
				antispam2[clientNum] = 1
			end
		end
		return 1
		end
		end
		
		elseif string.find(et.trap_Argv(1), "^" .. report_cmd .. "") and string.find(et.trap_Argv(1), "^" .. join_cmd .. "") then
			et.trap_SendServerCommand(clientNum, "chat \"^w"..joinname.."^z: ^wYou can't use two commands at the same time. \"" )
			return 1
		end --end all string.find
	end
	return 0
end

function playerName(id) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(id), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end