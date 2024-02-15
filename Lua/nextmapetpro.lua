--[[
	Nextmap Announce #1
	===================
	by Phishermans Phriend

	Further information:
	--------------------
	http://www.splashdamage.com/forums/showthread.php?p=376939#post376939

	Error Message:
	---------------
	If no mapname can be found, the script prints "ERROR" instead. This indicates that the name of the next map could not be
	read out of your mapcycle configuration. In this case assimilate your config file to objectivecycle.cfg and make sure
	the script can find the string "map <mapname>" in it. Also make sure the mapnames in your config file exactly (case sensitivity!!)
	match the corresponding scripts/*.ARENA file. If the error persists, add the faulty mapname to the mapnames{} table below.
--]]

-- CONFIG SECTION

	intermissionString = "^dNext Map is ^7%s^d."		-- Message line in intermission or if nextmap-vote is called.
								-- %s is replaced with the mapname
								-- NOTE: If you don't want to display the intermission message,
								-- set this variable to nil

	getNameOnce = true			-- If this variable is set to true, the script will import the
								-- name of the next map at the beginning of each map. Any change
								-- applied to the "nextmap" cvar will stay unrecognized.
								-- If you want the script to regard changes to the "nextmap" cvar
								-- during the running match, set this variable to false.
								-- This will import the name anew everytime it is called
								-- NOTE: This will use up more server resources

	cycleInterval = 80000		-- The interval in milliseconds (1000 millisec = 1 sec) in which
								-- the name of the next map will be printed to the players
								-- NOTE: The value must be a multiple of 20

	cycleString = "^5Next Map: ^7%s"			-- Message the cycle will print. %s is replaced with the mapname
								-- NOTE: If you don't want to display the cycle message,
								-- set this variable to nil

	cycleLocation = "cpm"		-- Location of the cycle message. Valid locations are:
								-- "cpm" for left notification/echo area
								-- "chat" for chat
								-- "cp" for center print

	clearColorcodes = false		-- Some mapnames contain color codes, e.g. "^1Castle Attack ^2B5".
								-- If you want to clear these color codes to use your own, set this variable to true

	mapnames = {						-- For some maps, rather raw-looking mapnames are printed, e.g. "lighthouse2"
		["frost2_final"]=	"Frost 2",	-- To print nicer names, you can define alternative names for those maps here
		["et_tank_beta3"]=	"The Tank",	-- NOTE: On the left, fill in the LOWER CASE (!!!) name of the .BSP file
		["lighthouse2"]=	"Lighthouse 2",
		["sw_goldrush_te"]=	"SW Goldrush",
		["sp_delivery_te"]=	"Delivery",
		["erdenberg_t1"]=	"Erdenberg",
		["sw_oasis_b3"]=	"SW Oasis",
		["braundorf_b4"]=	"Braundorf",
		["bremen_b3"]=		"Bremen",
	}

-- END OF CONFIG SECTION


-------------------------------------------------------------
--DONT CHANGE ANYTHING BELOW UNLESS YOU KNOW WHAT YOURE DOING
-------------------------------------------------------------

player = {}
wakeUp = 0
voteInProgress = false
nextmapname = ""

function et_Print(text)
	if text == "Exit: Timelimit hit.\n" or text == "Exit: Wolf EndRound.\n" then
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay " .. string.format(intermissionString,NextMapName()) .. ";")
	elseif string.sub(text,1,12) == "Vote Failed:" or string.sub(text,1,12) == "Vote Passed:" then
		voteInProgress = false
	end
end

function et_InitGame(levelTime, randomSeed, restart)
	et.RegisterModname("Nextmap Announce #1")

	local i = 0
	for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1 do
		player[i] = {}
		player[i].voteCount = 0
		player[i].keepEyeOn = false
	end
end

function et_RunFrame(levelTime)
	if cycleInterval and math.mod(levelTime,cycleInterval) == 0 then
		et.trap_SendServerCommand(-1, cycleLocation .. " \"" .. string.format(cycleString,NextMapName()))
	end

	if wakeUp > 0 then
		local i = 0
		for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1 do
			if player[i].keepEyeOn then
				if et.gentity_get( i, "pers.voteCount" ) > player[i].voteCount and et.gentity_get( i, "pers.connected" ) > 0 then
					voteInProgress = true
					player[i].voteCount = et.gentity_get( i, "pers.voteCount" )
					wakeUp = wakeUp - 1
					player[i].keepEyeOn = false
				end
			end
		end
	end
end

function et_ClientCommand( clientNum, command )
	if string.lower(et.trap_Argv(0)) == "callvote" then
		
		if string.lower(et.trap_Argv(1)) == "nextmap" and et.trap_Cvar_Get("vote_allow_nextmap") == "1" and not voteInProgress and allowedToCallVote(clientNum) then
			et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay " .. string.format(intermissionString,NextMapName()) .. ";")
		end
		

		player[clientNum].keepEyeOn = true
		wakeUp = wakeUp + 1
	end
	return 0
end

function isRef(id)
	if et.gentity_get( id, "sess.referee" ) == 1 then
		return true
	else
		return false
	end
end

function allowedToCallVote(id)

	if et.gentity_get( id, "sess.muted" ) == 1 then
		return false
	end

	if isRef(id) then
		return true
	end

	
	if et.gentity_get( id, "sess.sessionTeam" ) == 3 then
		return false
	end
	

	local votelimit = math.floor(tonumber(et.trap_Cvar_Get("vote_limit")))

	if votelimit <= 0 then	-- seems like vote_limit = 0 means unlimited, not completely disallowed
		return true
	end

	if et.gentity_get( id, "pers.voteCount" ) < votelimit then
		return true
	end

	return false
end

function NextMapName()
	if not getNameOnce or nextmapname == "" then
		local x,y,z = string.find(et.trap_Cvar_Get("nextmap"),"vstr%s+(%C+)")
		local a = ""

		if z == nil or et.trap_Cvar_Get(z) == "" then
			return "ERROR"
		end

		shortname = et.trap_Cvar_Get(z)

		x,y,z = string.find(shortname,"map%s+([^ ;%c]+)")

		if z == nil then
			return "ERROR"
		end

		shortname = z

		if mapnames[string.lower(shortname)] == nil then

			local fd, len = et.trap_FS_FOpenFile("scripts/" .. shortname .. ".arena", et.FS_READ)

			if len <= 1 then
				fd, len = et.trap_FS_FOpenFile("scripts/" .. string.lower(shortname) .. ".arena", et.FS_READ)
			end

			if len <= 1 then
				fd, len = et.trap_FS_FOpenFile("scripts/" .. string.upper(shortname) .. ".arena", et.FS_READ)
			end

			if len > 1 then
				for line in string.gfind(et.trap_FS_Read(fd, len), "([	%C]+)") do
					if string.sub(clearSpace(line),1,8) == "longname" then
						a = getAlienz(clearSpace(string.sub(clearSpace(line),9)))
					end
				end
			end

			et.trap_FS_FCloseFile(fd)
			if a == "" then
				a = getAlienz(elegantMapname(shortname))
			end
		else
			a = getAlienz(mapnames[string.lower(shortname)])
		end

		nextmapname = a
		if clearColorcodes then
			return et.Q_CleanStr(a)
		else
			return a
		end
	else
		return nextmapname
	end
end

--[[
function clearSpace(string)
	local output = ""
	local i = string.len(string)
	while (string.sub(string,i,i) == " " or string.sub(string,i,i) == "	") do
		string = string.sub(string,1,(i-1))
		i = i - 1
	end

	while (string.sub(string,1,1) == " " or string.sub(string,1,1) == "	") do
		string = string.sub(string,2)
	end

	i = 1
	while string.sub(string,i,i) ~= "" do
		if string.sub(string,i,i) ~= "\"" then
			output = output .. string.sub(string,i,i)
		end
		i = i + 1
	end

	return output
end
--]]

function clearSpace(input)
	local output = ""
	local i = string.len(input)
	while (string.sub(input,i,i) == " " or string.sub(input,i,i) == "	") do
		input = string.sub(input,1,(i-1))
		i = i - 1
	end

	while (string.sub(input,1,1) == " " or string.sub(input,1,1) == "	") do
		input = string.sub(input,2)
	end

	i = 1
	while string.sub(input,i,i) ~= "" do
		if string.sub(input,i,i) ~= "\"" then
			output = output .. string.sub(input,i,i)
		end
		i = i + 1
	end

	return output
end

-- this was added to display semi-proper mapnames in case "scripts/<mapname>.arena" cant be found
-- for example, "__random-mapname_release---candidate1_" is now turned into "Random Mapname Release Candidate1"
function elegantMapname(input)
	local i = 1
	local output = ""
	while string.sub(input,i,i) ~= "" do
		-- if first char or char before current one is (underline||dash), we need to make current char upper case
		if (i == 1 or (string.sub(input,(i-1),(i-1)) == "_" or string.sub(input,(i-1),(i-1)) == "-")) then
			-- but only if current char is not (underline||dash) in which case we skip it
			if string.sub(input,i,i) ~= "_" and string.sub(input,i,i) ~= "-" then
				output = output .. string.upper(string.sub(input,i,i))
			end
		-- if current char is (underline||dash), we need to make it whitespace
		elseif string.sub(input,i,i) == "_" or string.sub(input,i,i) == "-" then
				output = output .. " "
		-- normal char, just append it
		else
			output = output .. string.sub(input,i,i)
		end
		i = i + 1
	end
	-- before we release the transformed string, we remove all whitespaces at the end of the string
	-- we do this to make sure "__bridges__" is transformed into "Bridges" and not into "Bridges  "
	i = string.len(output)
	while string.sub(output,i,i) == " " do
		output = string.sub(output,1,(i-1))
		i = i - 1
	end
	return output
end

function getAlienz(input)
	local i = 1
	local x = ""
	local output = ""
	local len = string.len(input)

	while i <= len do

		x = string.sub(input,i,i)

		if x == "ä" then
			output = output .. "ae"
		elseif x == "ö" then
			output = output .. "oe"
		elseif x == "ü" then
			output = output .. "ue"
		elseif x == "Ä" then
			output = output .. "Ae"
		elseif x == "Ö" then
			output = output .. "Oe"
		elseif x == "Ü" then
			output = output .. "Ue"
		elseif x == "ß" then
			output = output .. "ss"
		elseif x == "§" then
			output = output .. "$"
		else
			output = output .. x
		end

		i = i + 1
	end

	return output
end