modname="BDMG"
version="1.0"

local maxClients = tonumber(et.trap_Cvar_Get("sv_maxclients"))
local gameState = tonumber(et.trap_Cvar_Get("gamestate"))
local paused = false
local initLevelTime = 0
local gameTime = 0
local gameRunningTime = 0
local minutesPassed = 0
local playerList = {}
local botList = {}

local MAX_HEALTH = 300
local TIMELIMIT = tonumber(et.trap_Cvar_Get("timelimit"))

function et_InitGame(levelTime, randomSeed, restart)
    et.RegisterModname(modname.." "..version)
	math.randomseed( randomSeed )
	initLevelTime = levelTime
end

function et_ClientConnect(clientNum, firstTime, isBot)
	if isBot == 0 then
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "cbp "..clientNum.." \"^1Life here is a constant pain...\\nYour brain will heal with each headshot.\";")
		playerList[clientNum] = {}
		playerList[clientNum].lastSpawn = nil
		playerList[clientNum].hsCount = 0
		playerList[clientNum].hitCount = 0
		playerList[clientNum].killCount = 0
		playerList[clientNum].lastVictim = "^8YOURSELF"
		playerList[clientNum].lastPunished = 0
		playerList[clientNum].hsRequired = 35
		playerList[clientNum].hsBonus = 0
		playerList[clientNum].team = 3
	else
		botList[clientNum] = {}
		botList[clientNum].team = 3
	end
end

function et_ClientDisconnect(clientNum)
	if playerList[clientNum] then playerList[clientNum] = nil end
	if botList[clientNum] then botList[clientNum] = nil end
end

function et_RunFrame(levelTime)
	gameTime = levelTime
	gameState = tonumber(et.trap_Cvar_Get("gamestate"))
	if gameState == 0 and paused == false then
		gameRunningTime = levelTime - initLevelTime
		minutesPassed = math.floor(gameRunningTime / 60000)
		-- restart game if no humans on server
		if next(playerList) == nil then
		   et.trap_SendConsoleCommand( et.EXEC_APPEND, "reset_match" )
		end
	end
	
    for i=0, maxClients-1 do
		-- all
		et.gentity_set(i, "ps.ammoclip", 20, 0)
		et.gentity_set(i, "ps.ammo", 20, 0)
		et.gentity_set(i, "ps.powerups", 4, levelTime)
		for j=1, 55 do
			if j == 8 then
				et.AddWeaponToPlayer( i, j, 666, 33, 0 )
			elseif j == 3 then
				et.AddWeaponToPlayer( i, j, 666, 33, 0 )
			else
				et.gentity_set(i, "ps.ammoclip", j, 0)
				et.gentity_set(i, "ps.ammo", j, 0)
			end
		end
		
		-- bots
		if botList[i] then
			botList[i].team = tonumber(et.gentity_get(i, "sess.sessionTeam"))
			et.gentity_set(i, "ps.powerups", 1, 0)
		end
		
		-- players
		if playerList[i] then
			playerTeam = tonumber(et.gentity_get(i, "sess.sessionTeam"))
			playerList[i].team = playerTeam
			if playerList[i].lastSpawn then
				if levelTime - playerList[i].lastSpawn == 1000 then
					et.gentity_set(i, "ps.powerups", 1, 0)
				end
			end
			et.gentity_set(i, "ps.stats", 3, MAX_HEALTH)

			if gameState == 0 and playerTeam ~= 3 then
				local hsAdditional = 0
				if minutesPassed > 5 then
					hsAdditional = minutesPassed * 10 - 50
				end
				local hsNeeded = minutesPassed * 30 - playerList[i].hsBonus + hsAdditional
				local hsNeededNext = (minutesPassed + 1) * 35 - playerList[i].hsBonus + hsAdditional
				playerList[i].hsRequired = hsNeededNext
				-- seizure every minute if not enough hs
				if minutesPassed > playerList[i].lastPunished then
					local hsRemainingNext = 0
					local function needPunish()
						local hs = playerList[i].hsCount
						hsRemainingNext = hsNeededNext - hs
						return hs < hsNeeded
					end
					
					if needPunish() then
						local playerHealth = et.gentity_get(i, "health")
						local damageMinute = 10 - minutesPassed
						-- if damageMinute == 0 then
							-- deadlySlap(i, playerHealth, "^1CHALLENGE FAILED! ^7"..hsRemainingNext.." ^1HS ^8not hit in time.")

						local seizureDmg = math.floor(playerHealth / damageMinute)
						deadlySlap(i, seizureDmg, "^1SEIZURE! ^8Hit ^7"..hsRemainingNext.." ^1more HS ^8in the next minute.", "uugh")
						playerList[i].lastPunished = minutesPassed
					end
				end
				if playerList[i].hsCount >= playerList[i].hsRequired then
					colorCode = "2"
				else
					colorCode = "8"
				end
				et.trap_SendConsoleCommand(et.EXEC_APPEND, "cbp "..i.." \"^1FRAGS: ^3"..playerList[i].killCount.." ^7| ^1HS: ^"..colorCode..""..playerList[i].hsCount.."^7/^3"..playerList[i].hsRequired.."\";")
				--  ^1LAST BRAIN DAMAGE: ^7"..playerList[i].lastVictim.."
			end
		end
    end
end 

function et_WeaponFire(clientNum, weapNum)
	local aWeaponStats = {}
	for j = 0, 28 - 1 do
		aWeaponStats[j] = et.gentity_get(clientNum, "sess.aWeaponStats", j)
		local atts      = aWeaponStats[j][1]
		if atts then
			-- et.trap_SendServerCommand(-1, string.format("chat \"^5weapNum: ^7%s ^3| ^7%s", j, atts))
		end
	end
	
	if playerList[clientNum] and gameState == 0 then
		-- et.trap_SendServerCommand(-1, string.format("chat \"^5gameRunningTime: ^7%s  ^5minutesPassed: ^7%s ^5lastPunished: ^7%s ^5team: ^7%s ^5gs: ^7%s", gameRunningTime, minutesPassed, playerList[clientNum].lastPunished, playerList[clientNum].team, gameState))
		-- Disable shields
		et.gentity_set(clientNum, "ps.powerups", 1, 0)
		local shots = 0
		local hits = 0
		local headshots = 0
		local aWeaponStats = {}
		for j = 0, 10 do
			aWeaponStats[j] = et.gentity_get(clientNum, "sess.aWeaponStats", j)
			shots = shots + aWeaponStats[j][1]
			hits = hits + aWeaponStats[j][4]
			headshots = headshots + aWeaponStats[j][3]
		end
		oldHSCount = playerList[clientNum].hsCount
		playerList[clientNum].hsCount = headshots
		oldHitCount = playerList[clientNum].hitCount
		playerList[clientNum].hitCount = hits
		
		local playerHealth = et.gentity_get(clientNum, "health")
		if headshots > oldHSCount then
			-- health boost for hs
			local newHealth = playerHealth + 5
			if playerHealth < 110 then
				newHealth = playerHealth + 15
			end

			et.gentity_set(clientNum, "health", newHealth)

			--too much hp punish
			local randomHealthNum = math.random(50)
			local brainCanExplode = (playerHealth - randomHealthNum) > 210
			-- brain explosion
			if brainCanExplode then
				explodeBrain(clientNum, randomHealthNum)
			else
				local strokeHealth = 180 + math.random(100)
				local strokeDmg = 25 + math.random(15)
				-- random stroke
				if playerHealth > strokeHealth and math.random(5) == 1 then
					deadlySlap(clientNum, strokeDmg, "^1STROKE! ^8Too much HP, camper!", "ygh")
				end
			end
		end
	end
end

function et_ClientSpawn( clientNum, revived, teamChange, restoreHealth )
	et.RemoveWeaponFromPlayer( clientNum, 1 )
	et.RemoveWeaponFromPlayer( clientNum, 48 )
	et.RemoveWeaponFromPlayer( clientNum, 20 )

	
	if playerList[clientNum] then
		playerList[clientNum].lastSpawn = gameTime
		-- auto ready and start when a first human joins
		-- if gameState == 2 then
			-- et.gentity_set(clientNum, "pers.ready", 1)
		-- end
		-- et.trap_SendServerCommand(-1, string.format("chat \"^5revived: ^7%s  ^5teamChange: ^7%s  ^5restoreHealth: ^7%s", revived, teamChange, restoreHealth))
	end

	if teamChange == 0 and gameState == 0 then
		slap(clientNum, 80, "^1CANCER! ^8Your brain is damaged.", "hls")
	end
end


function et_Obituary(victimNum, killerNum, meansOfDeath) 
	
	local victimTeam = 0
	local killerTeam = 0
	if playerList[victimNum] then
		victimTeam = playerList[victimNum].team
	elseif botList[victimNum] then
		victimTeam = botList[victimNum].team
	else
		victimTeam = 0
	end
		
	if playerList[killerNum] then
		killerTeam = playerList[killerNum].team
	elseif botList[killerNum] then
		killerTeam = botList[killerNum].team
	else
		killerTeam = 0
	end
	-- et.trap_SendServerCommand(-1, string.format("chat \"^5victimNum: ^7%s (%s)  ^5killerNum: ^7%s (%s)  ^5meansOfDeath: ^7%s", victimNum, victimTeam, killerNum, killerTeam, meansOfDeath))	
	-- value = test ? x : y;
	-- roughly translates to the following Lua:
    -- value = test and x or y

		-- if victimTeam > 0 and killerTeam > 0 then return false else return true end
		-- if victimTeam == killerTeam then return false else return true end
		-- if meansOfDeath ~= 8 or meansOfDeath ~= 9 then return false else return true end

	-- local victimTeam = tonumber(et.gentity_get(victimNum, "sess.sessionTeam")) 
	-- local killerTeam = tonumber(et.gentity_get(killerNum, "sess.sessionTeam")) 
	-- if (victimTeam > 0 and killerTeam > 0) and (victimTeam ~= killerTeam) and (meansOfDeath == 8 or meansOfDeath == 9) then 
    if (victimTeam ~= killerTeam) then 
		local killerName = string.gsub(et.gentity_get(killerNum, "pers.netname"), "%^$", "^^ ")
		local victimName = string.gsub(et.gentity_get(victimNum, "pers.netname"), "%^$", "^^ ")
		local killerHP = et.gentity_get(killerNum, "health")
		local killerweap = et.gentity_get(killerNum, "ps.weapon")
		-- this sends a message to the victim
		msg = string.format("chat  \"" .. killerName ..  "^7 had^o " .. killerHP .. " ^7HP left\n")

		et.trap_SendServerCommand(victimNum, msg)
		
		if playerList[killerNum] then
			playerList[killerNum].killCount = et.gentity_get(killerNum, "sess.kills")
			playerList[killerNum].lastVictim = victimName
		end
	end
	-- punish for tk
	if (victimNum ~= killerNum) and (victimTeam == killerTeam) then
		deadlySlap(killerNum, 25, "^1MIGRAINE! ^8TK hurts!", "ugh")
	end
	
	-- insta gib
	if meansOfDeath == 8 or meansOfDeath == 9 then
		et.G_Damage(victimNum, 0, 1024, 113, 0, 0)
	end
	-- remove dropped weapons
	for i = 64, 1023 do
		local classname = et.gentity_get(i, "classname")
		if classname then
			if (string.sub(classname, 1, 7) == "weapon_") then
				et.trap_UnlinkEntity(i)
				et.G_FreeEntity(i)
			end
		end
	end
end

function et_ClientCommand(clientNum, command)
	local cmd = string.lower(command)
	local arg1 = string.lower(et.trap_Argv(1))
	-- if cmd == "team" then
		-- if playerList[clientNum] and (arg1 == "s" or arg1 == "spectator") then
			-- ref pause/unpause is needed here..
			-- return 1
		-- end
	-- end
	if cmd == "ref" and arg1 == "pause" then
		paused = true
	end
	if cmd == "ref" and arg1 == "unpause" then
		paused = false
	end
end

function slap(client, dmg, msg, snd)
	local newHealth = et.gentity_get(client, "health") - dmg
	if newHealth < 40 then newHealth = 40 end
	et.gentity_set(client, "health", newHealth)
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "cchat "..client.." \""..msg.." ^1-"..dmg.."HP\";")
	plsnd(client, snd)
end

function deadlySlap(client, dmg, msg, snd)
	et.G_Damage(client, 0, 1024, dmg, 8, 36)
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "cchat "..client.." \""..msg.." ^1-"..dmg.."HP\";")
	plsnd(client, snd)
end

function explodeBrain(client, randomHealthNum)
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound_env "..client.." \"sound/brexp.wav\";")
	local health = et.gentity_get(client, "health")
	local newHealth = randomHealthNum + 2
	local dmg = health - newHealth + 1
	local playerName = et.gentity_get(client, "pers.netname")
	et.gentity_set(client, "health", newHealth)
	et.G_Damage(client, 0, 1024, 1, 8, 36)
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "cchat -1 \"^7"..playerName.."^7's ^8brain EXPLODED! ^1-"..dmg.."HP ^7| ^2-5 HS BONUS\";")
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "ccpm -1 \"^7"..playerName.."^7's ^8brain EXPLODED! ^1-"..dmg.."HP ^7| ^2-5 HS BONUS\";")
	playerList[client].hsBonus = playerList[client].hsBonus + 5
end

function plsnd(client, snd)
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "playsound "..client.." \"sound/"..snd..".wav\";")
end



