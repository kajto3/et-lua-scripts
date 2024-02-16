--	load settings from the server-cvars
	




--[[	
	global_soundpath_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree1_amount"))] = tostring(et.trap_Cvar_Get("killingspreesound"))
	global_soundpath_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree2_amount"))] = tostring(et.trap_Cvar_Get("rampagesound"))
	global_soundpath_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree3_amount"))] = tostring(et.trap_Cvar_Get("dominatingsound"))
	global_soundpath_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree4_amount"))] = tostring(et.trap_Cvar_Get("unstopablesound"))
	global_soundpath_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree5_amount"))] = tostring(et.trap_Cvar_Get("godlikesound"))
	global_soundpath_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree6_amount"))] = tostring(et.trap_Cvar_Get("wickedsicksound"))

	global_soundpath_table[flakmonkey] = tostring(et.trap_Cvar_Get("flakmonkeysound"))
	global_soundpath_table[firstblood] = tostring(et.trap_Cvar_Get("firstbloodsound"))

	global_soundpath_table[deathspree][tonumber(et.trap_Cvar_Get("k_deathspree1_amount"))] = tostring(et.trap_Cvar_Get("deathspreesound1"))
	global_soundpath_table[deathspree][tonumber(et.trap_Cvar_Get("k_deathspree2_amount"))] = tostring(et.trap_Cvar_Get("deathspreesound2"))
	global_soundpath_table[deathspree][tonumber(et.trap_Cvar_Get("k_deathspree3_amount"))] = tostring(et.trap_Cvar_Get("deathspreesound3"))

	global_soundpath_table[multikill][2] = tostring(et.trap_Cvar_Get("doublekillsound"))
	global_soundpath_table[multikill][3] = tostring(et.trap_Cvar_Get("multikillsound"))
	global_soundpath_table[multikill][4] = tostring(et.trap_Cvar_Get("megakillsound"))
	global_soundpath_table[multikill][5] = tostring(et.trap_Cvar_Get("ultrakillsound"))
	global_soundpath_table[multikill][6] = tostring(et.trap_Cvar_Get("monsterkillsound"))
	global_soundpath_table[multikill][7] = tostring(et.trap_Cvar_Get("ludicrouskillsound"))
	global_soundpath_table[multikill][8] = tostring(et.trap_Cvar_Get("holyshitsound"))




	global_message_table[deathspree][tonumber(et.trap_Cvar_Get("k_deathspree1_amount"))] = tostring(et.trap_Cvar_Get("k_ds_message1"))
	global_message_table[deathspree][tonumber(et.trap_Cvar_Get("k_deathspree2_amount"))] = tostring(et.trap_Cvar_Get("k_ds_message2"))
	global_message_table[deathspree][tonumber(et.trap_Cvar_Get("k_deathspree3_amount"))] = tostring(et.trap_Cvar_Get("k_ds_message3"))

	global_message_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree1_amount"))] = tostring(et.trap_Cvar_Get("k_ks_message1"))
	global_message_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree2_amount"))] = tostring(et.trap_Cvar_Get("k_ks_message2"))
	global_message_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree3_amount"))] = tostring(et.trap_Cvar_Get("k_ks_message3"))
	global_message_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree4_amount"))] = tostring(et.trap_Cvar_Get("k_ks_message4"))
	global_message_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree5_amount"))] = tostring(et.trap_Cvar_Get("k_ks_message5"))
	global_message_table[killingspree][tonumber(et.trap_Cvar_Get("k_spree6_amount"))] = tostring(et.trap_Cvar_Get("k_ks_message6"))

	global_message_table[multikill][2] = tostring(et.trap_Cvar_Get("k_mk_message1"))
	global_message_table[multikill][3] = tostring(et.trap_Cvar_Get("k_mk_message2"))
	global_message_table[multikill][4] = tostring(et.trap_Cvar_Get("k_mk_message3"))
	global_message_table[multikill][5] = tostring(et.trap_Cvar_Get("k_mk_message4"))
	global_message_table[multikill][6] = tostring(et.trap_Cvar_Get("k_mk_message5"))
	global_message_table[multikill][7] = tostring(et.trap_Cvar_Get("k_mk_message6"))
	global_message_table[multikill][8] = tostring(et.trap_Cvar_Get("k_mk_message7"))
--]]



	killingspreesound = tostring(et.trap_Cvar_Get("killingspreesound"))
	k_color = tostring(et.trap_Cvar_Get("k_color"))
	rampagesound = tostring(et.trap_Cvar_Get("rampagesound"))
	dominatingsound = tostring(et.trap_Cvar_Get("dominatingsound"))
	unstopablesound = tostring(et.trap_Cvar_Get("unstopablesound"))
	godlikesound = tostring(et.trap_Cvar_Get("godlikesound"))
	wickedsicksound = tostring(et.trap_Cvar_Get("wickedsicksound"))
	flakmonkeysound = tostring(et.trap_Cvar_Get("flakmonkeysound"))
	firstbloodsound = tostring(et.trap_Cvar_Get("firstbloodsound"))
	deathspreesound1 = tostring(et.trap_Cvar_Get("deathspreesound1"))
	deathspreesound2 = tostring(et.trap_Cvar_Get("deathspreesound2"))
	deathspreesound3 = tostring(et.trap_Cvar_Get("deathspreesound3"))
	doublekillsound = tostring(et.trap_Cvar_Get("doublekillsound"))
	multikillsound = tostring(et.trap_Cvar_Get("multikillsound"))
	megakillsound = tostring(et.trap_Cvar_Get("megakillsound"))
	ultrakillsound = tostring(et.trap_Cvar_Get("ultrakillsound"))
	monsterkillsound = tostring(et.trap_Cvar_Get("monsterkillsound"))
	ludicrouskillsound = tostring(et.trap_Cvar_Get("ludicrouskillsound"))
	holyshitsound = tostring(et.trap_Cvar_Get("holyshitsound"))
	k_ds_message1 = tostring(et.trap_Cvar_Get("k_ds_message1"))
	k_ds_message2 = tostring(et.trap_Cvar_Get("k_ds_message2"))
	k_ds_message3 = tostring(et.trap_Cvar_Get("k_ds_message3"))
	k_ks_message1 = tostring(et.trap_Cvar_Get("k_ks_message1"))
	k_ks_message2 = tostring(et.trap_Cvar_Get("k_ks_message2"))
	k_ks_message3 = tostring(et.trap_Cvar_Get("k_ks_message3"))
	k_ks_message4 = tostring(et.trap_Cvar_Get("k_ks_message4"))
	k_ks_message5 = tostring(et.trap_Cvar_Get("k_ks_message5"))
	k_ks_message6 = tostring(et.trap_Cvar_Get("k_ks_message6"))
	k_mk_message1 = tostring(et.trap_Cvar_Get("k_mk_message1"))
	k_mk_message2 = tostring(et.trap_Cvar_Get("k_mk_message2"))
	k_mk_message3 = tostring(et.trap_Cvar_Get("k_mk_message3"))
	k_mk_message4 = tostring(et.trap_Cvar_Get("k_mk_message4"))
	k_mk_message5 = tostring(et.trap_Cvar_Get("k_mk_message5"))
	k_mk_message6 = tostring(et.trap_Cvar_Get("k_mk_message6"))
	k_mk_message7 = tostring(et.trap_Cvar_Get("k_mk_message7"))


	k_fm_message = tostring(et.trap_Cvar_Get("k_fm_message"))
	k_end_message1 = tostring(et.trap_Cvar_Get("k_end_message1"))
	k_end_message2 = tostring(et.trap_Cvar_Get("k_end_message2"))
	k_end_message3 = tostring(et.trap_Cvar_Get("k_end_message3"))
	k_end_message4 = tostring(et.trap_Cvar_Get("k_end_message4"))
	k_fb_message = tostring(et.trap_Cvar_Get("k_fb_message"))
	k_lb_message = tostring(et.trap_Cvar_Get("k_lb_message"))

	k_spreesounds = tonumber(et.trap_Cvar_Get("k_spreesounds"))
	k_sprees = tonumber(et.trap_Cvar_Get("k_sprees"))
	k_multikillsounds = tonumber(et.trap_Cvar_Get("k_multikillsounds"))
	k_multikills = tonumber(et.trap_Cvar_Get("k_multikills"))
	k_flakmonkeysound = tonumber(et.trap_Cvar_Get("k_flakmonkeysound"))
	k_flakmonkey = tonumber(et.trap_Cvar_Get("k_flakmonkey"))
	k_firstbloodsound = tonumber(et.trap_Cvar_Get("k_firstbloodsound"))
	k_firstblood = tonumber(et.trap_Cvar_Get("k_firstblood"))
	k_lastblood = tonumber(et.trap_Cvar_Get("k_lastblood"))
	k_killerhpdisplay = tonumber(et.trap_Cvar_Get("k_killerhpdisplay"))
	k_deathsprees = tonumber(et.trap_Cvar_Get("k_deathsprees"))
	k_deathspreesounds = tonumber(et.trap_Cvar_Get("k_deathspreesounds"))
	k_spreerecord = tonumber(et.trap_Cvar_Get("k_spreerecord"))
	k_advplayers = tonumber(et.trap_Cvar_Get("k_advplayers"))
	k_crazygravityinterval = tonumber(et.trap_Cvar_Get("k_crazygravityinterval"))
	k_teamkillrestriction = tonumber(et.trap_Cvar_Get("k_teamkillrestriction"))
	k_tklimit_high = tonumber(et.trap_Cvar_Get("k_tklimit_high"))
	k_tklimit_low = tonumber(et.trap_Cvar_Get("k_tklimit_low"))
	k_tk_protect = tonumber(et.trap_Cvar_Get("k_tk_protect"))
	k_slashkills = tonumber(et.trap_Cvar_Get("k_slashkills"))
	k_endroundshuffle = tonumber(et.trap_Cvar_Get("k_endroundshuffle"))
	k_noisereduction = tonumber(et.trap_Cvar_Get("k_noisereduction"))
	k_advancedpms = tonumber(et.trap_Cvar_Get("k_advancedpms"))
	k_logchat = tonumber(et.trap_Cvar_Get("k_logchat"))
	k_disablevotes = tonumber(et.trap_Cvar_Get("k_disablevotes"))
	k_dvmode = tonumber(et.trap_Cvar_Get("k_dvmode"))
	k_dvtime = tonumber(et.trap_Cvar_Get("k_dvtime"))
	k_adrensound = tonumber(et.trap_Cvar_Get("k_adrensound"))
	k_advancedadrenaline = tonumber(et.trap_Cvar_Get("k_advancedadrenaline"))
	k_antiunmute = tonumber(et.trap_Cvar_Get("k_antiunmute"))
	k_advancedspawn = tonumber(et.trap_Cvar_Get("k_advancedspawn"))
	k_deathspree1_amount = tonumber(et.trap_Cvar_Get("k_deathspree1_amount"))
	k_deathspree2_amount = tonumber(et.trap_Cvar_Get("k_deathspree2_amount"))
	k_deathspree3_amount = tonumber(et.trap_Cvar_Get("k_deathspree3_amount"))
	k_spree1_amount = tonumber(et.trap_Cvar_Get("k_spree1_amount"))
	k_spree2_amount = tonumber(et.trap_Cvar_Get("k_spree2_amount"))
	k_spree3_amount = tonumber(et.trap_Cvar_Get("k_spree3_amount"))
	k_spree4_amount = tonumber(et.trap_Cvar_Get("k_spree4_amount"))
	k_spree5_amount = tonumber(et.trap_Cvar_Get("k_spree5_amount"))
	k_spree6_amount = tonumber(et.trap_Cvar_Get("k_spree6_amount"))
	k_multikill_time = tonumber(et.trap_Cvar_Get("k_multikill_time"))
	k_ds_location = tonumber(et.trap_Cvar_Get("k_ds_location"))
	k_ks_location = tonumber(et.trap_Cvar_Get("k_ks_location"))
	k_mk_location = tonumber(et.trap_Cvar_Get("k_mk_location"))
	k_fm_location = tonumber(et.trap_Cvar_Get("k_fm_location"))
	k_fb_location = tonumber(et.trap_Cvar_Get("k_fb_location"))
	k_lb_location = tonumber(et.trap_Cvar_Get("k_lb_location"))




-- avoid errors by unconfigured, or ill configured server.cfg
local private = tonumber(et.trap_Cvar_Get("sv_privateclients"))
if not private then
	et.G_Print("KMOD+ Configuration Error: sv_privateclients is not a number, reseting it to 0")
	et.trap_Cvar_Set("sv_privateclients","0")
end
	