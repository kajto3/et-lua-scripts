Modname = "Scoreboard"
Version = "0.6"
Author  = "Micha!" --aka. MNwa!
--Contact:	http://www.teammuppet.eu/home/index.php?/user/1290-micha/
--			http://forums.warchest.com/member.php/52875-Micha

--Baserace Score Announce

--Note: This lua will only work if the mapname includes "baserace"

--Updated to Lua 5.2.1
--string.gfind was renamed to string.gmatch
--math.mod is now math.fmod

-------------------------------------------------------------------------------------
-------------------------------CONFIG START------------------------------------------
-------------------------------------------------------------------------------------

printlocation 	= "cpm"												--Scoreboard print location
																	--[[
																	Notice: 
																	bp = banner print
																	cp = center screen
																	cpm = popup message area
																	chat = chat area
																	--]]
																	
printtime		= 15												--print rhythm in seconds

-------------------------------------------------------------------------------------
-------------------------------CONFIG END--------------------------------------------
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
----------DO NOT CHANGE THE FOLLOWING IF YOU DO NOT KNOW WHAT YOU ARE DOING----------
-------------------------------------------------------------------------------------

-------//-----------------DO NOT CHANGE THESE VARS-----------------------------------
samplerate = (printtime *1000)										--global refresh rate
baserace = "baserace"												--search for mapname which include baserace
--

function et_InitGame( levelTime,randomSeed,restart )
	et.G_Print("[SB] Version:"..Version.." Loaded\n")
	et.RegisterModname(Modname .. " " .. Version)
	maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )	--get the maxclients
	gamestate = tonumber(et.trap_Cvar_Get( "gamestate" ))			--get the gamestate (warmup,etc)
	mapname = string.lower(et.trap_Cvar_Get( "mapname" ))			--get the mapname
	if gamestate == 0 then
		et.trap_Cvar_Set( "b_scoreboard_axis", "0" )
		et.trap_Cvar_Set( "b_scoreboard_allies", "0" )
	end
end

function et_RunFrame( levelTime ) 
  if math.fmod(levelTime, samplerate) ~= 0 then return end
	if string.find(mapname, "^"..baserace.."") then
		if gamestate == 0 then
			
			local sbax = et.trap_Cvar_Get( "b_scoreboard_axis" )	--ScoreBoard Axis
			local sbal = et.trap_Cvar_Get( "b_scoreboard_allies" )	--ScoreBoard Allies
			
			--AXIS SCORE
			if sbax >= "1" and sbax < "5" then
				et.trap_SendServerCommand( -1, ""..printlocation.." \"^NThe ^1Axis ^Nare ahead by ^1"..sbax.."^N!\n\"")
				et.trap_SendServerCommand( -1, "print \"^NThe ^1Axis ^Nare ahead by ^1"..sbax.."^N!\n\"")
			end
			if sbax >= "5" then
				et.trap_SendServerCommand( -1, ""..printlocation.." \"^NThe ^1Axis ^Nhave a commanding ^1lead^N!\n\"")
				et.trap_SendServerCommand( -1, "print \"^NThe ^1Axis ^Nhave a commanding ^1lead^N!\n\"")
			end
			
			--ALLIES SCORE
			if sbal >= "1" and sbal < "5" then
				et.trap_SendServerCommand( -1, ""..printlocation.." \"^NThe ^5Allies ^Nare ahead by ^1"..sbal.."^N!\n\"")
				et.trap_SendServerCommand( -1, "print \"^NThe ^5Allies ^Nare ahead by ^1"..sbal.."^N!\n\"")
			end
			if sbal >= "5" then
				et.trap_SendServerCommand( -1, ""..printlocation.." \"^NThe ^5Allies ^Nhave a commanding ^1lead^N!\n\"")
				et.trap_SendServerCommand( -1, "print \"^NThe ^5Allies ^Nhave a commanding ^1lead^N!\n\"")
			end
			
			--TIED
			if sbax == "0" and sbal == "0" then
				et.trap_SendServerCommand( -1, ""..printlocation.." \"^NThe Score is ^2Tied^N!\n\"")
				et.trap_SendServerCommand( -1, "print \"^NThe Score is ^2Tied^N!\n\"")
			end
		end
	else
		if math.fmod(levelTime, 600000) ~= 0 then return end
		return --do nothing on a non baserace map
	end
end


function et_Print(text)

	--AXIS SCORE
	local sbaxc
	for sbaxc in string.gmatch(text, "The Axis are ahead by (%x)") do
		et.trap_Cvar_Set( "b_scoreboard_axis", sbaxc )
	end
	
	for sbaxc in string.gmatch(text, "The Axis have a commanding lead!") do
		et.trap_Cvar_Set( "b_scoreboard_axis", "5" )
	end
	
	--ALLIES SCORE
	local sbalc
	for sbalc in string.gmatch(text, "The Allies are ahead by (%x)") do
		et.trap_Cvar_Set( "b_scoreboard_allies", sbalc )
	end
	
	for sbalc in string.gmatch(text, "The Allies have a commanding lead!") do
		et.trap_Cvar_Set( "b_scoreboard_allies", "5" )
	end
	
	--TIED
	local tied
	for tied in string.gmatch(text, "The Score is Tied!") do
		et.trap_Cvar_Set( "b_scoreboard_axis", "0" )
		et.trap_Cvar_Set( "b_scoreboard_allies", "0" )
	end
	
end    