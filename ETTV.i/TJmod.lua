HSP_TJmod_Verison=0.4
pos={}
pos1={}
pos2={}

function gotohell()
   et.gentity_set(et.trap_Argv(1), "health", -200)
end 
function goto()
   		pos[30]=et.gentity_get(et.trap_Argv(2),"origin")
   		et.gentity_set(et.trap_Argv(1), "origin", pos[30])
end 
function iwant(selfID,targetID)
			pos[targetID]=et.gentity_get(targetID,"origin")
   		pos[30]=et.gentity_get(selfID,"origin")
    	et.trap_SendServerCommand(targetID, "cp \"^:Your position before moved has been saved, use ^1!goback ^:to restore\"" )
   		et.gentity_set(targetID, "origin", pos[30])
  end		
  function save(targetID)
    	if et.gentity_get(targetID,"sess.sessionTeam")==1 then
    	pos1[targetID]=et.gentity_get(targetID,"origin")
    	et.trap_SendServerCommand(targetID, "cp \"^1S^:aved\"" )
    end
  	if et.gentity_get(targetID,"sess.sessionTeam")==2 then
    	pos2[targetID]=et.gentity_get(targetID,"origin")
    	et.trap_SendServerCommand(targetID, "cp \"^1S^:aved\"" )
    end
    if et.gentity_get(targetID,"sess.sessionTeam")==3 then
    	et.trap_SendServerCommand(targetID,"cp \"^:You can not ^1/save^: as spectator.\"")
    end
  end
  function load(targetID)
  if et.gentity_get(targetID,"sess.sessionTeam")==1 then
    et.gentity_set(targetID,"origin",pos1[targetID])
    et.trap_SendServerCommand( targetID, "cp \"\"" )
  end
  if et.gentity_get(targetID,"sess.sessionTeam")==2 then
    et.gentity_set(targetID,"origin",pos2[targetID])
    et.trap_SendServerCommand( targetID, "cp \"\"" )
  end
  if et.gentity_get(targetID,"sess.sessionTeam")==3 then
    	et.trap_SendServerCommand(targetID,"cp \"^:You can not ^1/load^: as spectator.\"")
  end
  end
  function block(clientNum)
    et.trap_SendServerCommand( clientNum, "cp \"^:(^3#//Data.hourb.com^:)\n\"" )
    return 1
  end
function et_ConsoleCommand()
		if et.trap_Argv(0)=="gotohell" then
		 gotohell(et.trap_Argv(1))
		 return 1
		end
		if et.trap_Argv(0)=="goto" then
		 goto(et.trap_Argv(1),et.trap_Argv(2))
		 return 1
		end
		if et.trap_Argv(0)=="goback" then
		 et.gentity_set(et.trap_Argv(1), "origin", pos[et.trap_Argv(1)])
		 return 1
		end
		if et.trap_Argv(0)=="iwant" then
		 iwant(et.trap_Argv(1),et.trap_Argv(2))
		 return 1
		end
return 0
end

godmode = {}

function et_InitGame(levelTime,randomSeed,restart)
maxclients = tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )   --gets the maxclients
for i = 0, maxclients - 1 do
	godmode[i] = 0
end
end

function et_ClientCommand( clientNum, command )
	local cmd = string.lower(command)
		if cmd == "save" then
			 save(clientNum)
		 	 return 1
		end
		if cmd == "load" then
			 load(clientNum)
		 	 return 1
		end
		if cmd == "god" then
			if godmode[clientNum] == 0 then
				godmode[clientNum] = 1
				et.trap_SendServerCommand( clientNum, "chat \"^:Godmode enabled \"" )
				return 1
			elseif godmode[clientNum] == 1 then
				local class = et.gentity_get(clientNum,"sess.playertype")
				godmode[clientNum] = 0
				et.trap_SendServerCommand( clientNum, "chat \"^:Godmode disabled \"" )
				if class ~= 1 then
					et.gentity_set(clientNum, "ps.stats", 4,100)
					et.gentity_set(clientNum, "health", 100)
				end
				if class == 1 then
					et.gentity_set(clientNum, "ps.stats", 4,109)
					et.gentity_set(clientNum, "health", 123)
				end
				return 1
			end
		end
		return 0
end

samplerate = 200

function et_RunFrame( levelTime )
if math.mod(levelTime, samplerate) ~= 0 then return end
	for clientNum = 0, maxclients - 1 do
		class = et.gentity_get(clientNum,"sess.playertype")
		if godmode[clientNum] == 1 then
			if class ~= 1 then
				et.gentity_set(clientNum, "ps.stats", 4,999)
				et.gentity_set(clientNum, "health", 999)
			elseif class == 1 then
				et.gentity_set(clientNum, "ps.stats", 4,876)
				et.gentity_set(clientNum, "health", 999)
			end
		end
	end
end
