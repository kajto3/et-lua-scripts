
---------------------------------------------------------
http://bani.anime.net/banimod/forums/viewtopic.php?t=6777
---------------------------------------------------------



UPDATE August 1 2008 
etadmin_mod can be tricked into giving people with certain names admin access. See http://www.snl-clan.com/forum/viewtopic.php?f=9&t=9789 for a workaround. 

ty SNL|Lucel|STA 

UPDATE May 16 2008 
Updated hash for combinedfixes. 

UPDATE April 21 2008 
Fixed 
Code: 

etpro: et_RunFrame error running lua script: [string "combinedfixes.lua"]:127: attempt to call field `match' (a nil value) 
 

error. 

combinedfixes.lua now uses string.find instead of string.match. 

UPDATE April 1 2008 
Individual modules retired, combined fixes is the only one being maintained from now on. 

Updated to prevent some more userinfo abuse, which allowed players to bypass the fakeplayer prevention, among other things. Thanks again DoGoD 

UPDATE Mar 23 2008 
userinfocheck.lua combindedfixes.lua updated to prevent an exploit in guidcheck.lua. 

If you want to use the guidcheck fix, you MUST either update your combinedfixes.lua or run both userinfocheck.lua and guidcheck.lua 

Note lua mod authors 
The exploit relies on the fact that chat (or /m) with well chosen player names allows almost arbitrary strings to be sent to the et_Print function. Lua mod authors are urged to treat the text sent to et_Print with extreme caution. 

Note to etadmin_mod users 
Similar exploits likely exist against other log parsers such as etadmin_mod. The updated version of userinfocheck.lua may be used to prevent some abuse of this sort, but you must uncomment some lines in the file yourself. This is untested, and very likely does not eliminate all such exploits against etadmin_mod. 

edit Mar 24 2008: 
The name vulnerability should only apply to log parsers which read the game console or console log, not the game log. 

Thanks to Hadr0 for bringing the guidcheck problem to my attention. 

-- earlier post follows-- 
edit: 
Updated Mar 2 2008 
- fix nil var ref if kicked in RunFrame 
- fix incorrect clientNum in log message for ClientConnect kick 
thanks to DoGoD and benny. 

--original post-- 
Several significant exploits against ET and ETPro have recently been brought to our attention. 



the "ws" clientcommand can be used to crash servers, or with a modified client, obtain arbitrary information such as passwords from server memory. Since tvgame does not support lua, a fixed tvgame is available here: tvgame-update.zip. This should work with beta13. People who already have my ettv test builds don't need this, it's the same tvgame. 

clients can send malformed userinfo which can confuse some game functions about their IP. 

Cheats which spoof etpro guids can crash servers. 

q3fill DOS program to fill up servers with bogus players. 


All of these exploits have been observed in the wild. It is strongly recommended that you run combinedfixes.lua 

The ws and infostring exploits affect all ET versions and mods. The authors of noquarter, jaymod, and etpub have been informed. The guid exploit obviously only affects etpro. 

To install lua modules: 
copy the .lua file to your etpro directory and addCode: 
set lua_modules "somemodule.lua anothermodule.lua" 
 

to your server cfg. lua_modules takes effect after a map change or map_restart. You can check whether your mod was loaded using the lua_status command, on either a client or the server console. 

For leagues that wish to use these modules with their certified configs, you should also setl lua_allowedmodules to the hash of the module you wish to use. You can obtain this hash with lua_status. Because of length limitations, you can only allow one module in a .config, so use of combinedfixes.lua or your own custom module is recommended. The hash of combinedfixes.lua is 
Code: 
1C455F0C2D3497C3D435DFD58352FB6B924CD887  


By default the combinedfixes.lua limits users to 3 connections per IP. You may want to adjust this using the cvar ip_max_clients if you expect a lot of players to connect from the same IP. 

Thanks to McSteve and pants for bringing these to our attention. As always, we appreciate the help of the community in identifying this sort of thing.