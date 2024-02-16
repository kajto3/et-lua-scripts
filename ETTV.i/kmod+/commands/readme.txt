
IMPORTANT NOTE: 
dont run abusive commands, like !revive, !heal, !ammo etc...
on your server, or no one will want to play there!

i suggest for all command-makers to go by the ETpub line that says: no abusive commands.



to write your own commands:
1) name your file with the name of your command, and the suffix .lua
example: for the command !burn
file name: burn.lua

2) write your command/script in lua.
you got 2 options here:
write a "normal" lua script, that can use any defind globals and the params table (more of this later)
or, 

write your code inside a

function dolua(params)
	your_code_here
	return 1
end

your command/function should *always* return 1.
use return 0 only when your command does not output anything.


when a !command is called, it executes the dolua(params) function inside the command.lua file
if you wrote your code "normally" (without the function dolua(params) declaration) then this call is more "expansive" for the computer
as now your code is loaded as string, the function declaration is added to it, and only then it compiles and runs.

the call to this command will be less expansive if you * DO * wrap your code with this simple function declartion

anyway, you can look at the commands in this folder, you will find that most of them
has the fucntion declartion, but i added some without, just for your conviniance.

to test it, just delete the function declaration from one of the commands (and its corrisponding "end" at the bottom of the file)
and run it, you will see it works this way too.


params is a table, containing:
1) pramars[index] = argument
prarams[index] is the the argument provided by the player, for example !kick necro go away
params[1] = "necro"
params[2] = "go"
params[3] = "away"

params["slot"] = the calling player slot number. 

##### isnt used anymore ################
params["broadcast"] = who to send it to. if the command was silent, it holds the calling player's slot
if the command was public, then the return is also public, in this case params["broadcast"] = -1 (everyone)
########################################


note: if command is rcon'ed (rcon <pass> !command) then params["slot"] == CONSOLE
*CONSOLE is a constant.

params["say"] = were the command return will be printed.
i used the "b 8" (it is set at the UserClientCommand function).


printing:
to send something, use the following syntax:
normal !command return printing
et.trap_SendServerCommand(params["broadcast"], string.format('%s \"%s"',params["say"]," type your message here "))

you can substitute params["say"] with any other printing-string from the etpro-lua-API


to send the message to all connected clients (even if was called silently, good for !ban, !kick commands, where all clients need to be notifed)
et.trap_SendServerCommand( -1 , string.format('%s \"%s"',params["say"]," type your message here "))


print to console:
et.G_Print(" your message here ")


Useable Globals:
global_admin_table[GUID] = level


global_level_table
	global_level_table[i]["greeting"] = message
	global_level_table[i]["sound"] = path
	global_level_table[i]["name"] = name
	global_level_table[i]["commands"][command_index] = command
	global_level_table[i]["flags"] = flags string (use level_flag(level, flag) to check if this level has a certain flag)
						      ( to check slot against a flag use level_flag(AdminUserLevel(slot), "flag") )
						      ( note: you may define any new flags you want in levels.dat, and check for them in your commands )
						      ( note2: if you have a problem with the level_flag function, make sure the level you pass to it is a number, and not a string! )
	

global_players_table[slot]["whatever"] = value
	global_players_table[slot]["guid"] = guid
	global_players_table[slot]["name"] = name
	global_players_table[slot]["team"] = team
	global_players_table[slot]["guid_age"] = guid_age (only if retrived seccessfuly)
	global_players_table[slot]["inactive"] = timestamp when the client *was* active ( measered in MS, devide by 1000 to have seconds )






functions:

ParseString(string)
getPlayernameToId(name)
part2id(client) 
nameforID(name) 
randomClientFinder()
name2IDPM(name) 
crop_text(text,len)
DeleteFileLine(filename, del)
LoadFileToTable(filename)
chop(text)
level_flag(level, flag)
levelcommand(level,command)
AdminUserLevel(PlayerID)
disablewars() -- see panzerwar

loadMutes()
loadspreerecord() -- loads the spree record
loadmapspreerecord() -- loads the map spree records
loadlevels() -- loads the levels from the levels.dat file
loadbanners() -- loads the banners from the banners.cfg file
loadAdmins() -- loads the admins from the shrubbot.dat file

setMute(PlayerID, muteTime)
MuteCheck(PlayerID)
killingspreereset()
dspreereset()
flakreset()
spreerecord_reset()
setAdmin(PlayerID, level)



release notes:
this release still contains alot of the global veriables used in kmod 1.3
so be carefull with the veriable names you choose (if they are global)


remember to share custom commands with us (or if you need any help):
http://www.usef-et.org

