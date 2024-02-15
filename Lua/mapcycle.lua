map_table = {
	{ map = "supply", type=0, },
	{ map = "oasis", type=1, },
	{ map = "odenthal_b2", type=1, },
	{ map = "radar", type=1, },
	{ map = "tc_base", type=0, },
	{ map = "et_beach", type=1, },
	{ map = "frostbite", type=0, },
	{ map = "sp_delivery_te", type=0, },
	{ map = "adlernest", type=0, },
	{ map = "bremen_b2", type=0, },
	{ map = "braundorf_b4", type=0, },
	{ map = "et_ice", type=1, },
	{ map = "goldrush-ga", type=1, },
	{ map = "railgun", type=1, },
	{ map = "dubrovnik_final", type=1, },
	{ map = "sw_battery", type=1, },
	{ map = "1944_beach", type=1, },
	{ map = "caen2", type=1, },
	{ map = "venice", type=1, },
	{ map = "coast_b1", type=1, },
	{ map = "Haemar_a11", type=0, },
	{ map = "et_mor_pro", type=1, },
	{ map = "vio_grail", type=1, },
	{ map = "frost_final", type=0, },
	{ map = "missile_b2", type=1, },
	{ map = "rommel_final", type=1, },
	{ map = "et_village", type=1, },
	{ map = "el_kef_final", type=1, },
	{ map = "axislab_final", type=1, },
	{ map = "reactor_final", type=0, },
	{ map = "sos_secret_weapon", type=0, },
	{ map = "sottevast_b3", type=0, },
	{ map = "townsquare_final", type=1, },
	{ map = "fueldump", type=1, },
	{ map = "pirates_b4", type=1, },
}	



table.foreach(map_table, function(k,v)
		countPlayers()
		if playercountready < 10 then
			if mapname == v.map then
				if map_table[k+1].type == 1 then  
					repeat 
			 			k = k + 1
					until map_table[k].type == 0 
					et.trap_SendConsoleCommand( et.EXEC_APPEND, "nextmap \"map "..map_table[k].map.."\n\"" )
				end
			end
		else
     	if mapname == v.map then
		et.trap_SendConsoleCommand( et.EXEC_APPEND, "nextmap \"map "..map_table[k+1].map.."\n\"" )
          end
   	  end
  	end)