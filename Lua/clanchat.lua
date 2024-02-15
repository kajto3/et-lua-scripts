--[[

	clanchat.lua
	===================
	by Micha!

	
	Contact:
	--------------------
	http://www.teammuppet.eu
	
	
	Info:
	--------------------
	This lua adds the /mc command to users with level 'member_level' and above. 
	Usage: /mc text
	
--]]

Modname = "Clan-chat"
Version = "0.2"

-------------------------------------------------------------------------------------
---------------------------------CONFIG START----------------------------------------
-------------------------------------------------------------------------------------

chatcommand 	 = "mc"		--clan-chat command

member_level     = 7		--level needed to use chatcommand (/mc)
colour 			 = "N"		--message colour

-------------------------------------------------------------------------------------
-------------------------------CONFIG END--------------------------------------------
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
----------DO NOT CHANGE THE FOLLOWING IF YOU DO NOT KNOW WHAT YOU ARE DOING----------
-------------------------------------------------------------------------------------

function et_InitGame(levelTime, randomSeed, restart)
  et.RegisterModname(et.Q_CleanStr(Modname).."   "..Version.."   "..et.FindSelf())
  
  maxclients = tonumber(et.trap_Cvar_Get("sv_maxclients"))-1
end

function et_ClientCommand(clientNum, command) -- get client commands
local cmd = string.lower(command)
local arg1 = et.trap_Argv(1)
local conarg = et.ConcatArgs(2)
  -- check if client is in list of allowed members
	if et.G_shrubbot_level(clientNum) >= member_level then
		if cmd == chatcommand or arg1 == "/"..chatcommand.."" or string.find(arg1, "^/"..chatcommand.."") then
			if et.trap_Argc() > 1 then
				-- build message
				local message = ""
				if cmd == chatcommand then
					for i = 1, et.trap_Argc() - 1, 1 do
						message = message .. et.trap_Argv(i) .. " "
					end
				elseif arg1 == "/"..chatcommand.."" then
						message = conarg
				elseif string.find(arg1, "^/"..chatcommand.."") then
					for i = 1, et.trap_Argc() - 1 , 1 do
						message = message .. et.trap_Argv(i) .. " "
						message = string.sub(message, 5)
					end
				end
				-- send message to all other members
				for i = 0, maxclients, 1 do
					if et.G_shrubbot_level(i) >= member_level then
						sendstring = playerName(clientNum) .. " ^7(^8Clan-chat^7)^N: ^"..colour.."" .. message
						et.trap_SendServerCommand(i, "chat \"" .. sendstring .. "\"")
						if i == clientNum then
							et.trap_SendServerCommand(clientNum, "print \"^fYour clan-chat has been sent to all online clan-members\n\"")
						elseif i ~= clientNum then
							et.trap_SendServerCommand(i, "cp \"^8You received a clan-chat message from ^7"..playerName(clientNum).."\n\"")
						end
					end
				end
			else
				et.trap_SendServerCommand(clientNum, "print \"^"..colour.."usage: /"..chatcommand.." [message]\n\"")
			end
			return 1
		end
	end
	return 0
end

function playerName(client) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(client), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end