mapvote_table = {
  { map="adlernest",      votes=0, },      -- 1
  { map="frostbite",      votes=0, },      -- 2
  { map="tc_base",         votes=0, },      -- ...
  { map="sp_delivery_te", votes=0, },
  { map="sw_goldrush_te", votes=0, },
  { map="braundorf_b4",   votes=0, },
  { map="supply",         votes=0, },
  { map="bremen_b3",      votes=0, },
  { map="radar",      votes=0, },
}


samplerate = 200
mapvotecmd =  "!mapvote"


function et_InitGame(levelTime,randomSeed,restart)
  mclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
  endmaptimer = 0
  endmaptimer2 = 0
  announced = 0
  can_vote = {}
  for cno = 0, mclients - 1 do
    can_vote[cno] = 1
  end
end

function et_RunFrame( levelTime )
  if math.mod(levelTime, samplerate) ~= 0 then return end

  if endofmap then
    endmaptimer = endmaptimer + 1
    endmaptimer2 = endmaptimer2 +1

    if endmaptimer == 36 then
      -- sort descending
      table.sort(mapvote_table, function(a,b) return tonumber(a.votes) > tonumber(b.votes) end)
      et.trap_SendServerCommand( -1, "chat \"^3MapsVoted:" .. create_vote_string() .. "\n\"")
      endmaptimer = 0
    end

    if endmaptimer2 == 145 then
      -- check if there has been votes
      table.sort(mapvote_table, function(a,b) return tonumber(a.votes) > tonumber(b.votes) end)
      if mapvote_table[1] and mapvote_table[1].votes > 0 then
        if mapvote_table[2] and mapvote_table[2].votes < mapvote_table[1].votes then
          -- first is the winner
          et.trap_SendConsoleCommand(et.EXEC_APPEND, "ref map ".. mapvote_table[1].map .."\n")
          return 1
        end

        -- at least two maps with same vote count (get random map)
        local i = 2
        while mapvote_table[i] do
          if mapvote_table[i].votes < mapvote_table[i-1].votes then break end
          i = i + 1
        end

        et.trap_SendConsoleCommand(et.EXEC_APPEND, "ref map ".. mapvote_table[math.random(1,i-1)].map .."\n")
      else
        -- no votes... do nothing and wait untill intermission is finished
      end
    end
  end
end


function et_ClientCommand(id, command)
  if string.lower(et.trap_Argv(0)) == "imready" then return 1 end

  if endofmap and string.lower(et.trap_Argv(0)) == "say" then
    local s, e, mapname = string.find(et.trap_Argv(1), "^" .. mapvotecmd .. " ([%w%_]+)$")
    if mapname then
      is_valid_map(id, string.lower(mapname)) --void...
      return 1
    elseif string.lower(et.trap_Argv(1)) == mapvotecmd and et.trap_Argv(2) then
      is_valid_map(id, string.lower(et.trap_Argv(2)))
      return 1
    end
  end
  return 0
end


function is_valid_map(id, mapname)
  if can_vote[id] == 0 then
    et.trap_SendServerCommand(id,"chat \"^3MapVoted: ^7You have already voted!\n")
    return 1
  end

  for _, line in ipairs(mapvote_table) do
    if mapname == line.map then
      line.votes = line.votes + 1   -- increment map vote counter
      can_vote[id] = 0              -- player can't vote anymore
      et.trap_SendServerCommand(id,"chat \"^3MapVoted: ^7You voted for ^2" .. mapname .. "\n")
      return
    end
  end

  et.trap_SendServerCommand( id,"chat \"^3Mapvote: ^2"..mapname.." ^7is not a valid map!\n\"")
end


function et_Print(text) 
   if text == "Exit: Timelimit hit.\n" or text == "Exit: Wolf EndRound.\n" or text == "Exit: Axis team has the most survivors.\n" 
   or text == "Exit: Axis team eliminated.\n" or text == "Exit: Allied team eliminated.\n" or text == "Exit: Allied team has the most survivors.\n" then
        endofmap = true
   end
   if endofmap and string.find(text, "^WeaponStats: ") == 1 then
    if announced == 0 then
      et.trap_SendServerCommand( -1,"chat \"^3Mapvote: ^2!mapvote ^3mapname ^7to vote for a map\n\"")

      local map_msg = ""
      for _, mtable in pairs(mapvote_table) do
        map_msg = map_msg .. string.format(" ^7%s", mtable.map)
      end
      et.trap_SendServerCommand( -1,"chat \"^3Valid maps:" .. map_msg .. "\n\"")
      announced = 1
    end 
  end
end

function create_vote_string()
  local vote_msg = ""

  for _, mtable in pairs(mapvote_table) do
    if mtable.votes > 0 then
      vote_msg = vote_msg .. string.format(" ^7%s(^3%d^7)", mtable.map, tonumber(mtable.votes))
    end
  end

  if vote_msg == "" then
    vote_msg = " ^7No votes ^3:("
  end

  return vote_msg
end