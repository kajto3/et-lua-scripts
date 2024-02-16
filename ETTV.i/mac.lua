

Modname = "maclist"
Version = "0.1"

-------------------------------------------------------------------------------------
---------------------------------CONFIG START----------------------------------------
-------------------------------------------------------------------------------------

Homepage = "^://dataa.url.ph"

blocknomac = true		--prevent players connecting to server with an invalid mac 

						--block the mac addresses written in this table
blockmac = {
    "00:00:00:00:00:00",
	"00:00:00:00:00:01",
}

-------------------------------------------------------------------------------------
---------------------------------CONFIG END----------------------------------------
-------------------------------------------------------------------------------------

-------//---------------------Start of functions----------------------------
function et_InitGame(levelTime,randomSeed,restart)
	et.G_Print("^z["..Modname.."^z] Version: "..Version.." Loaded\n")
    et.RegisterModname(et.Q_CleanStr(Modname).."   "..Version.."   "..et.FindSelf())
end


function et_ClientConnect( client, firstTime, isBot )
	local userinfo = et.trap_GetUserinfo(client)    
	if (userinfo ~= "") and isBot == 0 then
		for k,v in pairs(blockmac) do
			local mac = tostring(et.Info_ValueForKey(userinfo,"mac"))
			if tostring(v) and blocknomac then
				et.G_Print(""..Modname..".lua: User "..playerName(client).." tried to connect with a blocked mac: "..mac.."\n")
				return "\n^f'^/"..et.trap_Cvar_Get("sv_hostname").."^f'\n\n^7Connecting with the mac \n^f'^7"..mac.."^f'\n^7is not allowed. \n\n^7Visit "..Homepage.." to report your problem.\n^7"
			elseif (mac == "" or mac == nil) and blocknomac then
				et.G_Print(""..Modname..".lua: User "..playerName(client).." tried to connect with an invalid mac\n")
				return "\n^f'^/"..et.trap_Cvar_Get("sv_hostname").."^f'\n\n^7Connecting with an invalid mac is not allowed. \n\n^7Visit "..Homepage.." to report your problem.\n^7"
			end
		end
	end
end


--[[ --Debug
function et_ClientCommand( client, command )
	if string.lower(command) == "macc" then 
	local userinfo = et.trap_GetUserinfo(client)    
	if (userinfo ~= "") then
		for k,v in pairs(blockmac) do
			local mac = tostring(et.Info_ValueForKey(userinfo,"mac"))
			et.G_Print(""..k..": "..tostring(v).."\n")
			if tostring(v) and blocknomac then
				et.G_Print(""..Modname..": User "..playerName(client).." tried to connect with a blocked mac: "..mac.."\n")
				return 1
			elseif (mac == "" or mac == nil) and blocknomac then
				et.G_Print(""..Modname..": User "..playerName(client).." tried to connect with a invalid mac\n")
				return 1
			end
		end
	end
	end
	return 0
end
--]]

function playerName(client) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(client), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end