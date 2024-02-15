-- Original Author: Major Zeman's Rules printer
-- version 0.1 (20.7.2007)

-- changelog
--
-- v0.1
-- initial
-- v0.2 --unofficial work
-- modname
-- server message
-- v0.3 --unofficial work
-- removed server message
-- command reworked to shrub like

--
-- The printer can handle both unix and windows line endings (and mac, too)
-- in the input file, however as a price for this, it ignores any empty lines
-- in the input file. Therefore if you desire to print an empty line inside the
-- rules text, use a line with one space (or more of course) instead.
--

------------------------------------------ name ----------------------------------------------

Modname = "Rules"
Version = "0.3"

------------------------------------------ settings ----------------------------------------------

commandprefix 			 = "!"				--command prefix (! shrubbot like)
rules_cmd                = "rules"			--Rules shrubbot command
RULES_FILENAME           = "rules.txt"		--Rules filename

----------------------------------------- functions ---------------------------------------------

function et_InitGame(levelTime,randomSeed,restart)
   et.G_Print("[Rules] Version: "..Version.." Loaded\n")
   et.RegisterModname(Modname.." "..Version.. " "..et.FindSelf())
end


-- print message to either client's console or (if clientID == nil) to server console
function printmsg(message, clientID)
    if not message then
        return
    end

    -- replace "s in message with 's
    local dummy
    message, dummy = string.gsub(message, "\"", "'")

    if clientID then
        et.trap_SendServerCommand(clientID, "print \"".. message .."^7\n\"")
    else
        if lastcallerID then
            et.trap_SendServerCommand(lastcallerID, "print \"".. message .."^7\n\"")
        else
            et.G_Print(message .."^7\n")
        end
    end
end


-- reads file and returns string array of rows (indexed from 1) and number of rows
function readFile(filename)
    local fd, len
    local rows = {}

    fd, len = et.trap_FS_FOpenFile(filename, et.FS_READ)

    if len == -1 then
        return rows, 0
    else
        --read it all
        local filestr = et.trap_FS_Read(fd, len)

        local rowcount = 0
        for line in string.gfind(filestr, "[^\r\n]+") do
            rowcount = rowcount + 1
            rows[rowcount] = line
        end

            et.trap_FS_FCloseFile(fd)
            return rows, rowcount
      end
end

function playerName(id) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(id), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end


---------------------------------- client command functions ------------------------------

function et_ClientCommand(client, command)
    local arg0 = string.lower(et.trap_Argv(0))
    local argv1 = string.lower(et.trap_Argv(1))
	-------//--------------------Command----------------------------
	if string.find(arg0, "^"..commandprefix.."" .. rules_cmd .. "") or string.find(argv1, "^"..commandprefix..""" .. rules_cmd .. "") then
		printrules(client)
		return 1
	end
end

-- print rules to client
function printrules(clientID)
	et.trap_SendServerCommand( clientID, "chat \"^1"..Modname.."^7: ^2Open the console, ^7"..playerName(clientID).." \"" )
    rows, numrows = readFile(RULES_FILENAME)

    printmsg("", clientID)

    for i = 1, numrows do
            printmsg(rows[i], clientID)
    end

    printmsg("", clientID)
end