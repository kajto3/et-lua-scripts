
-- !slap <player> wont kill the player, it'll leave him with 1 hp
COMMAND = "slap"
HEADING = COMMAND_COLOR .. COMMAND .. "^w: " ..COMMAND_COLOR
local define = {}
local victim

define["msg_syntax"] = HEADING .. " !" .. COMMAND .. " [name|slot]"
define["msg_no_target"] =  HEADING .."<PARAM>" .. COMMAND_COLOR.. " is not on the server!"
define["msg_higher_admin"] = HEADING .. "cannot target higher level"
define["reqired_params"] = 1
victim = readyCommand(params,define)

if params.slot ~= CONSOLE then
	-- make it look like the player has used the command in chat
	userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
end


if victim ~= -1 then
	local victim_health = et.gentity_get(victim, "health")
	local name = et.gentity_get(victim,"pers.netname")
	if global_players_table[victim]["team"] == 3 then -- spec
		if params["slot"] == "console" then
			et.G_Print(HEADING..name ..COMMAND_COLOR .." must be on a team\n")
		else
			et.trap_SendServerCommand(params.slot, string.format('%s \"%s\"',params["say"],HEADING..name ..COMMAND_COLOR .." must be on a team" ))
		end
		return
	end
	if victim_health <=0 then 
		if params["slot"] == "console" then
			et.G_Print(HEADING..name ..COMMAND_COLOR .." must be alive\n")
		else
			et.trap_SendServerCommand(params.slot, string.format('%s \"%s\"',params["say"],HEADING..name ..COMMAND_COLOR .." must be alive" ))
		end
		return
	end

	if victim_health <= 6 then -- dont kill the guy
		et.gentity_set(victim, "health", 1)
	else
		et.gentity_set(victim, "health", victim_health -5)
	end
	et.trap_SendServerCommand( -1 , string.format('%s \"%s\"',params["say"],HEADING..name ..COMMAND_COLOR .." was slapped!" ))
	local sound = 'sound/player/hurt_barbwire.wav'
	soundindex = et.G_SoundIndex(sound)
	et.G_Sound( victim,  soundindex)


end

return 1
