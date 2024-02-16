to set levels open the levels.dat file in a text editor (notepad)

level = <level number>
name = <level's name>
command = <a string of commands this level can use>
flags = <flags defining permissions of this level>
greeting = <greeting that gets displayed when a user this level joins the server, [player] is substitutes with the player's name, and [level] substitutes with the level> 
sound = <path to a soundfile that will be played when user at this level joins the server>


greeting - [player] sabstatitues with the player's name, and [level] with his level name
flags - uses the same flags as etpup (the not-commands flags)

the following flags are supported:
1 - cannot be vote kicked or vote muted
2 - cannot be censored
3 - Can run commands silently with /!COMMAND in the console 
6 - does not need to specify a reason for !kick or !ban 
8 - does not need to specify a duration for a ban (defaults to PERMANENT) 
0 - is immune to k_spectatorInactivity (will not be kicked off the server) 
~ - Can read and write the adminchat with the /ma command. All referees and all other players with the ~ flag will be able to read this chat 


etup flags : 
1 - cannot be vote kicked, vote muted, or complained against. 
2 - cannot be censored 
3 - Can run commands silently with /!COMMAND in the console 
4 - Can see Axis/Allies team chats as a spectator 
5 - can switch teams any time, regardless of balance 
6 - does not need to specify a reason for !kick or !ban 
7 - Can call a vote at any time (regardless of disabled voting or voting limitations) 
8 - does not need to specify a duration for a ban (defaults to PERMANENT) 
9 - Can do shrubbot commands via team and fireteam chats 
0 - is immune to g_inactivity and g_spectatorInactivity settings 
! - is immune to all shrubbot commands (useful for server admins). NOTE: this flag must be specified explicitly the * flag does not grant it. 
@ - "incognito" flag shows the admin as level 0 with no a.k.a info in the output of !listplayers. NOTE: this flag must be specified explicitly the * flag does not grant it. 
$ - Can do !admintest on other players 
~ - Can read and write the adminchat with the /ma command. All referees and all other players with the ~ flag will be able to read this chat 
















banner locations

8 - player chat area

16 - left popup area (not recommended)

32 - centered above the chat area

64 - console only

128 - banner area (recommended)(top of screen) 

in order to support etpub's banners, following strings are supported and euqals to:
chat = 8
cpm = 16
cp = 32
bp = 128

