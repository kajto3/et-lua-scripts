--[[

	Revive Ammo Addon
	===================
	by Micha!

	Further information:
	--------------------
	http://forums.warchest.com/showthread.php/38943-shrubbot-command-to-team-chat
	
	
	Contact:
	--------------------
	http://www.teammuppet.eu
	
	
	Info:
	--------------------
	Commands usage: 	/rpos		/ammo		!rpos		!ammo

--]]---------------------------------------------------------------------------------
---------------------------------CONFIG START----------------------------------------
--[[---------------------------------------------------------------------------------

true means on
false means off

--]]

commandprefix =			"!"							--command prefix

admin_min_level = 		0							--minimum admin level needed to use the shrubbot commands

rpos_cmd =				"rpos"						--revive position command
ammo_cmd =				"ammo"						--ammo command

ammosound = 			"sound/chat/axis/22a.wav"	--ammo sound file

countammoclip = 		true						--true: count ammo and ammoclip
													--false: only count ammo
													
antispam = 				true						--just show "I Need Ammo" message and play sound to fieldops (less spam)
antispammax = 			2							--anti spam maximum -> x time allowed to use the command, counter will start after this value
blocktime = 			20							--wait time after anti spam maximum is hit (in seconds)

-------------------------------------------------------------------------------------
-------------------------------CONFIG END--------------------------------------------
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
----------DO NOT CHANGE THE FOLLOWING IF YOU DO NOT KNOW WHAT YOU ARE DOING----------
-------------------------------------------------------------------------------------

Version = "0.2"
Modname = "revive_ammo_addon"

-------------global vars----------------
samplerate = 1000
et.CS_PLAYERS = 689
woundedplayers = {}
local spaces = 2
local string_out = "" -- will hold up to 5 players
antispamcounter = {}
waittimer = {}
----------------------------------------

weapontable = {
[0]=	"SMG", --can be used from allies and axis
[3]=	"MP40",
[5]=	"Panzerfaust",
[6]=	"Flamethrower",
[8]=	"Thompson",
[10]=	"Sten", 
[23]=	"K43 Rifle",
[24]=	"M1 Rifle",
[25]=	"M1 Garand", 
[31]=	"MG42", 
[32]=	"K43",
[33]=	"FG42", 
[35]=	"Mortar", 
}

-------//---------------------Start of functions----------------------------

function et_InitGame(levelTime,randomSeed,restart)
	mclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
	
    et.G_Print("["..Modname.."] Version: "..Version.." Loaded\n")
    et.RegisterModname(Modname.." "..Version.." "..et.FindSelf())

	rpos = {}
	fops = {}
	
	for clientNum=0, mclients-1, 1 do
		antispamcounter[clientNum] = 0
		waittimer[clientNum] = 0
	end
	
end

function et_ClientCommand(clientNum, command)
	local argv1 = string.lower(et.trap_Argv(1))

	-------//--------------------revive----------------------------
	if string.lower(command) == rpos_cmd or ( string.find(argv1, "^"..commandprefix.."" .. rpos_cmd .. "") and getlevel(clientNum) ) then
		if et.gentity_get(clientNum, "sess.sessionTeam") == 3 then
			et.trap_SendServerCommand(clientNum, "chat \"^3REVIVEME: ^7Can't execute this command while beeing in spectator mode\"")
			return 1
		end
		for i=0, mclients-1, 1 do
			RevivePos(clientNum,i)
		end
		table.sort(rpos)
		if rpos[1] == nil then
			et.trap_SendServerCommand(clientNum, "chat \"^3REVIVEME: ^7No person to revive near you!\"" )
		else
			et.trap_SendServerCommand(clientNum, "chat \"^3REVIVEME: ^7Next person to revive in ^1"..rpos[1].."m ^7near you!\"" )
	 
			local v
			local player_count = 0	
			for i=1, table.getn(woundedplayers), 1 do
				v = woundedplayers[i]
				player_count = player_count + 1
				string_out = string_out .. "^7" .. playerName(v)
				if ( player_count < 5) then				    
					string_out = string_out .. string.rep(" ", spaces - string.len(v))
				end
				if ( player_count >= 5 ) then
					player_count = 0
					v = string.format(string_out)
					et.trap_SendServerCommand(clientNum,"chat \"^3REVIVEME^7: ^7"..v.."\"")
					string_out = ""
					woundedplayers = {}
				end
			end
			if (string.len(string_out) > 0) then
				v = string.format(string_out)
				et.trap_SendServerCommand(clientNum,"chat \"^3REVIVEME^7: ^7"..v.."\"")
				string_out = ""
				woundedplayers = {}
			end
		end
		rpos = {}
	
		-------//--------------------return----------------------------
		if string.lower(command) == "rpos" then return 1 end
		if string.find(argv1, "^"..commandprefix.."" .. rpos_cmd .. "") then return end
	end
  
	-------//--------------------ammo----------------------------
	if string.lower(command) == ammo_cmd or ( string.find(argv1, "^"..commandprefix.."" .. ammo_cmd .. "") and getlevel(clientNum) ) then
		if et.gentity_get(clientNum, "sess.sessionTeam") == 3 then
			et.trap_SendServerCommand(clientNum, "chat \"^3AMMO: ^7Can't execute this command while beeing in spectator mode\"")
			if string.lower(command) == "ammo" then return 1 end
			if string.find(argv1, "^"..commandprefix.."" .. ammo_cmd .. "") then return end
		end
		
		-------//--------------------anti spam----------------------------
		antispamcounter[clientNum] = antispamcounter[clientNum] + 1
		if antispamcounter[clientNum] > antispammax then
			local seconds = (blocktime - waittimer[clientNum])
			et.trap_SendServerCommand(clientNum, "chat \"^3AMMO: ^7You need to wait ^1"..seconds.." sec ^7till you can do the cmd again\"")
			if string.lower(command) == "ammo" then return 1 end
			if string.find(argv1, "^"..commandprefix.."" .. ammo_cmd .. "") then return end
		end
		
		for i=0, mclients-1, 1 do
			if et.gentity_get(i, "sess.sessionTeam") == et.gentity_get(clientNum, "sess.sessionTeam") then
				
				AmmoCheck(clientNum)
				
				for cno=0, mclients-1, 1 do --only use the clients on same team
					if antispam then --hm maybe just play the ammo sound/message to just fieldops for less annoying spam
						if checkclass(cno) == 3 then
							if weaponname then --weapon is known ? (out of weapontable)
								et.trap_SendServerCommand(cno, "chat \"^7"..playerName(clientNum).."^7: ^3I Need Ammo! ^7Only ^1"..ammo.." ^7ammo left for my ^1"..weaponname.."^7!\"")
							else
								et.trap_SendServerCommand(cno, "chat \"^7"..playerName(clientNum).."^7: ^3I Need Ammo! ^7Only ^1"..ammo.." ^7ammo left^7!\"")
							end

							et.G_ClientSound( cno, et.G_SoundIndex(ammosound) )
						end
						
					elseif antispam == false then
						if weaponname then --weapon is known ? (out of weapontable)
							et.trap_SendServerCommand(cno, "chat \"^7"..playerName(clientNum).."^7: ^3I Need Ammo! ^7Only ^1"..ammo.." ^7ammo left for my ^1"..weaponname.."^7!\"")
						else
							et.trap_SendServerCommand(cno, "chat \"^7"..playerName(clientNum).."^7: ^3I Need Ammo! ^7Only ^1"..ammo.." ^7ammo left^7!\"")
						end

						et.G_ClientSound( cno, et.G_SoundIndex(ammosound) )
					end
					-------//--------------------find fieldops----------------------------
					FindFops(clientNum,cno)
				end
				
				table.sort(fops)
				if fops[1] == nil then
					et.trap_SendServerCommand(clientNum, "chat \"^3AMMO: ^7No fieldops to supply you near you!\"" )
				else
					et.trap_SendServerCommand(clientNum, "chat \"^3AMMO: ^7Next fieldops to supply you in ^1"..fops[1].."m ^7near you!\"" )
				end
				fops = {}
				
				-------//--------------------return----------------------------
				if string.lower(command) == "ammo" then return 1 end
				if string.find(argv1, "^"..commandprefix.."" .. ammo_cmd .. "") then return end
			end
		end
	end
    -------//--------------------end----------------------------
    return 0   -- allows the cmd
 end
 
 -------//--------------------anti spam ticker----------------------------
 function et_RunFrame( levelTime )
	if math.mod(levelTime, samplerate) ~= 0 then return end
	for cno=0, mclients-1, 1 do
		if antispamcounter[cno] >= 3 then
			waittimer[cno] = waittimer[cno] + 1
		end
		if waittimer[cno] == blocktime then
			antispamcounter[cno] = 0
			waittimer[cno] = 0
		end
	end
 end

-------//--------------------player name----------------------------
function playerName(id) -- return a player's name
  local name = et.Info_ValueForKey(et.trap_GetUserinfo(id), "name")
  if name == "" then
    return "*unknown*"
  end
  return name
end

-------//--------------------revive position----------------------------
function RevivePos(caller,id)
	if caller == id then return 1 end
	if et.gentity_get(id, "sess.sessionTeam") == 3 or et.gentity_get(caller, "sess.sessionTeam") == 3 then return 1 end
	if et.gentity_get(caller, "sess.sessionTeam") == et.gentity_get(id, "sess.sessionTeam") then
		if et.gentity_get(id, "health") <= 0 and et.gentity_get(id, "r.contents") ~= 0 then
			local callerpos = et.gentity_get(caller,"r.currentOrigin")
			local idpos = et.gentity_get(id,"r.currentOrigin")
			distance = dist(callerpos,idpos)
			table.insert(rpos,distance)
			table.insert(woundedplayers,id)
		end
	end
end

-------//--------------------fieldops position----------------------------
function FindFops(caller,id)
	if caller == id then return 1 end
	if et.gentity_get(id, "sess.sessionTeam") == 3 or et.gentity_get(caller, "sess.sessionTeam") == 3 then return 1 end
	if et.gentity_get(caller, "sess.sessionTeam") == et.gentity_get(id, "sess.sessionTeam") then
		if checkclass(id) == 3 then
			local callerpos = et.gentity_get(caller,"r.currentOrigin")
			local idpos = et.gentity_get(id,"r.currentOrigin")
			distance = dist(callerpos,idpos)
			table.insert(fops,distance)
		end
	end
end
	
-------//--------------------distance----------------------------
function dist(a ,b)
   local dx = math.abs(b[1] - a[1])
   local dy = math.abs(b[2] - a[2])
   local dz = math.abs(b[3] - a[3])
   local d = math.sqrt((dx ^ 2) + (dy ^ 2) + (dz ^ 2))
   return math.floor(d / 52.4934)
end

-------//--------------------Ammo check----------------------------
function AmmoCheck(clientNum)
	weaponcode = et.gentity_get(clientNum, "sess.PlayerWeapon")
	weaponname = weapontable[weaponcode]
	-------//--------------------check ammo----------------------------
	if weaponcode == 5 or weaponcode == 6 or weaponcode == 35 then --in case it's: Panzerfaust, Flamethrower or Mortar
		ammo = et.gentity_get(clientNum, "ps.ammoclip", weaponcode)
	else
		-------//--------------------check ammo----------------------------
		if countammoclip then
			ammo = et.gentity_get(clientNum, "ps.ammo", weaponcode) + et.gentity_get(clientNum, "ps.ammoclip", weaponcode)
		elseif countammoclip == false then
			ammo = et.gentity_get(clientNum, "ps.ammo", weaponcode)
		end
	end
end

-------//--------------------player class----------------------------
--0=Soldier, 1=Medic, 2=Engineer, 3=FieldOps, 4=CovertOps
function checkclass(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client)
    return tonumber(et.Info_ValueForKey(cs, "c"))
end

-------//--------------------get player shrubbot level----------------------------
function getlevel(client)
    local lvl = et.G_shrubbot_level(client)
    if lvl >= admin_min_level then
        return true
    end
        return nil
end