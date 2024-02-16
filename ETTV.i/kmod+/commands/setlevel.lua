function dolua(params)
   local clientnum = tonumber(params[1]) 
   local level = tonumber(params[2])
	

   if ( params["slot"] == "console" ) then
	if clientnum then 
		if (clientnum >= 0) and (clientnum < 64) then 
	         if et.gentity_get(clientnum,"pers.connected") ~= 2 then 
				et.G_Print("^3Setlevel^w: ^fThere is no client associated with this slot number\n" )
				return 
	         end 
	
	      else              
				et.G_Print("^3Setlevel^w: ^fPlease enter a slot number between 0 and 63\n" )
				return 
	      end 
	else 
	if params[1] then 
		s,e=string.find(params[1], params[1])
		if e <= 2 then
				et.G_Print("^3Setlevel^w: ^fPlayer name requires more than 2 characters\n" )
		   return
		   else
	         	clientnum = NameToSlot(params[1])
		   end
		end 
		if clientnum == nil or table.getn(clientnum) ~= 1 then -- maches more then 1 player / maches no1 
			et.G_Print("^3Setlevel^w: ^fTry name again or use slot number\n" )
			return 
	    end 
		clientnum = clientnum[1]
	end 
	if global_level_table[level] == nil then
		et.G_Print("^3Setlevel^w: ^fAdmin level does not exist!\n" )
		return
	end

	  local name = et.Info_ValueForKey( et.trap_GetUserinfo( clientnum ), "name" )
	  loadAdmins()
	  if et.trap_Cvar_Get("k_shrubbot") ~= "" then -- using a shrubbot file, just load to memory, dont physiclly write anything.
		
		local tlevel = tonumber(level)
		local name = et.Q_CleanStr(et.Info_ValueForKey( et.trap_GetUserinfo( clientnum ), "name" ))
		local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( clientnum ), "cl_guid" ))

		
		if ( tlevel == nil or name == nil or guid == nil or guid == "" ) then
			
			return 0
		end
		
		if (global_admin_table[guid] == nil) then -- new admin
			global_admin_table[guid] = {}
			global_admin_table[guid]["name"] = name
			global_admin_table[guid]["level"] = level
			global_admin_table[guid]["flags"] = ""
			global_admin_table[guid]["greeting"] = ""		
			return 0
		else 
			global_admin_table[guid]["level"] = level
		end
	  
	  else	
		  
		  setAdmin(clientnum, level)
		  et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3Setlevel^w: ^1" ..name .. " ^fis now a " .. level .. " user"))
		  return 1

	  end
	  return 1
  end




userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)

if clientnum then 
	if (clientnum >= 0) and (clientnum < 64) then 
		if et.gentity_get(clientnum,"pers.connected") ~= 2 then 
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"]," ^3Setlevel^w: ^fThere is no client associated with this slot number" ))
			return 1
		end 

	else              
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"]," ^3Setlevel^w: ^fPlease enter a slot number between 0 and 63" ))
		return 1
	end 
else 
      if params[1] ~= nil then 
	   s,e=string.find(params[1], params[1])
	   if e <= 2 then
			et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"]," ^3Setlevel^w: ^fPlayer name requires more than 2 characters" ))
			return 1
	   else
		clientnum = NameToSlot(params[1])
	   end
      end 
	 if table.getn(clientnum) ~= 1 then 
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"]," ^3Setlevel^w: ^fTry name again or use slot number" ))
		return 1
	 end 
	 clientnum = clientnum[1]
end 
   if global_level_table[level] == nil then
		et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"',params["say"]," ^3Setlevel^w: ^fAdmin level does not exist!" ))

		return 1
   end
 

  if ( AdminUserLevel(params["slot"]) < AdminUserLevel(clientnum)) then
	et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Setlevel^w: ^fcannot target a higher level"))
	return 1
  end
  if ( AdminUserLevel(params["slot"]) < level ) then
	et.trap_SendServerCommand(params["slot"], string.format('%s \"%s"\n',params["say"],"^3Setlevel^w: ^fcannot setlevel higher then yours"))
	return 1
  end
  local name = et.Info_ValueForKey( et.trap_GetUserinfo( clientnum ), "name" )
  loadAdmins()

  if et.trap_Cvar_Get("k_shrubbot") ~= "" then -- using a shrubbot file, just load to memory, dont physiclly write anything.

	local tlevel = tonumber(level)
	local name = et.Q_CleanStr(et.Info_ValueForKey( et.trap_GetUserinfo( clientnum ), "name" ))
	local guid = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( clientnum ), "cl_guid" ))

	if ( tlevel == nil or name == nil or guid == nil ) then
		return 0
	end

	if (global_admin_table[guid] == nil) then -- new admin
		global_admin_table[guid] = {}
		global_admin_table[guid]["name"] = name
		global_admin_table[guid]["level"] = level
		global_admin_table[guid]["flags"] = ""
		global_admin_table[guid]["greeting"] = ""		
	else
		global_admin_table[guid]["level"] = level

	end
	return 0
  
  else	
	  setAdmin(clientnum, level)
	  et.trap_SendServerCommand( -1 , string.format('%s \"%s"\n',params["say"],"^3Setlevel^w: ^1" ..name .. " ^fis now a " .. level .. " user"))
	  return 1
  end

end 