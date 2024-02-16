HSP_TJmod_Verison=0.4
pos={}
pos1={}
pos2={}

function et_InitGame(levelTime,randomSeed,restart)
et.trap_SendConsoleCommand(et.EXEC_NOW,"sets ^8T^sJmod_verison ^s"..HSP_TJmod_Verison.."")
et.trap_SendConsoleCommand(et.EXEC_NOW,"sets ^8T^sJmod_WebSite ^sliteral-party.com/et/mod")
end

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
    	et.trap_SendServerCommand(targetID, "cp \"^8Y^sour position before moved has been saved, use ^1!goback ^sto restore\"" )
   		et.gentity_set(targetID, "origin", pos[30])
  end		
  function save(targetID)
    	if et.gentity_get(targetID,"sess.sessionTeam")==1 then
    	pos1[targetID]=et.gentity_get(targetID,"origin")
    	et.trap_SendServerCommand(targetID, "cp \"^8S^saved\"" )
    end
  	if et.gentity_get(targetID,"sess.sessionTeam")==2 then
    	pos2[targetID]=et.gentity_get(targetID,"origin")
    	et.trap_SendServerCommand(targetID, "cp \"^8S^saved\"" )
    end
    if et.gentity_get(targetID,"sess.sessionTeam")==3 then
    	et.trap_SendServerCommand(targetID,"cp \"^8Y^sou can not ^1/save^S as a spectator.\"")
    end
  end
  function load(targetID)
  if et.gentity_get(targetID,"sess.sessionTeam")==1 then
    et.gentity_set(targetID,"origin",pos1[targetID])
    et.trap_SendServerCommand( targetID, "cp \"^8L^soaded\"" )
  end
  if et.gentity_get(targetID,"sess.sessionTeam")==2 then
    et.gentity_set(targetID,"origin",pos2[targetID])
    et.trap_SendServerCommand( targetID, "cp \"^8L^soaded\"" )
  end
  if et.gentity_get(targetID,"sess.sessionTeam")==3 then
    	et.trap_SendServerCommand(targetID,"cp \"^8Y^sou can not ^1/load^S as a spectator.\"")
  end
  end
  function block(clientNum)
    et.trap_SendServerCommand( clientNum, "cp \"^8h^sttp://literal-party.com\n\"" )
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
function et_ClientCommand( clientNum, command )
			if command=="save" then
			 save(clientNum)
		 	 return 1
			end
			if command=="load" then
			 load(clientNum)
		 	 return 1
			end
			if command=="noclip" or command=="god" then
			 block(clientNum)
		 	 return 1
			end
			return 0
end
