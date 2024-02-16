                                   rspree_mod

                  [About][Servers][Config][Download][Contact]

   This etpro server side mod adds "reviving sprees" in the style of
   etadmin_mod's killing sprees.
   See http://wolfwiki.anime.net/index.php/Lua_Mod_API#cvars on how to load
   this mod.

Download

     * latest stable:
       rspree v1.2.3
     * old stable:
       rspree v1.1.12
     * testing:
     * svn:
       warning: this may be not working at all ;)
       http://svn.ankh-morp.org:8080/etpro_mods/rspree/

About

     * A player needs at least 5 revives in a row for a new map record
       printed. Everything below is not worth it ;-> ... it's just recorded
       to the all time stats file.
     * If you want to see if a server is running this mod, check the server
       vars for "RSpree_mod_version" (same place where e.g. "sv_hostname",
       "mod_version" and "mod_url" are announced).
     * If enabled, players can see the map record and overall records with
       the public message (AKA "say") "!spree_record" (default, if you don't
       change it .)). See "rspree_cmd" and "rspree_cmd_enabled" below.
     * new in 1.2.0: Players may now choose to disable the messages. This can
       be done in two ways:
          * on the fly by using \rsprees 0 in the console, and of course
            \rsprees 1 to enable again. This setting will stay until they
            disconnect.
          * by setting the user info variable v_rsprees before connecting.
            This can be done in the console with \setu v_rsprees 0 or as
            command line argument to ET: +setu v_rsprees 0.
       The rsprees command can be used to override the clients default
       settings for the current connection.
     * Admins have two console commands: rsprees and rspreesall (also
       available via rcon, of course). "rsprees" prints all current sprees of
       the running map, "rspreesall" is a reformatted dump of the all time
       stats file (this is from my test server, current records on hirntot
       are 8-15, depending on map):

 ]\rcon rspreesall
 ^7Alltime reviving sprees:
 rspreesall: goldrush: Vetinari^7 with 12 revives @2006-05-27, 12:53:57
 rspreesall: oasis: ^7[^1!!!^7]^1H^7arlekin^7 with 37 revives @2006-06-11, 13:09:12
 rspreesall: battery: Vetinari^7 with 5 revives @2006-05-27, 12:57:58
 rspreesall: radar: ^0M^5y^0x^5o^4m^0a^.t^5o^0s^5i^0s^7 with 15 revives @2006-06-05, 19:07:32
 ^7Alltime reviving sprees END

       new in v1.1.0: rspreerecords, see "!rsprees" for output
     * Don't worry if noone gets a monster revive on your server, it is
       working :-)
       Yes, it's hard, but possible on a 20+ player server. We had that at
       least two times now in the last 2-3 weeks (congratulations to DerGraf
       who did the first one ingame on fueldump as Axis :-)). Take a look in
       the server log file, multi and monster revives are now logged as:
       Multirevive: <slotno> (<playername>)
       and
       Monsterrevive: <slotno> (<playername>)
       Since v1.1.0: use the !rsprees command to see who did the most multi /
       monster revives
       Since v1.1.2: use the !stats command to see your own number of multi /
       monster revives
       Maybe in a later version of this mod I'll add a config setting to
       adjust the time between revives (currently 3000ms == 3 seconds), if
       someone requests it.
   Thanks to the Hirntot.org admin [!!!]Harlekin and the [!!!] community for
   testing on their servers :)

Config

   Below is a list of config vars and their explanation. You'll have to edit
   the rspree.lua and change these values to fit your needs.

   For the config vars ending in "_pos", see
   http://wolfwiki.anime.net/index.php/SendServerCommand#Printing for valid
   locations, most people should be fine with the defaults.

     * announce_revives default: false
       this disables (or in case of 'true' enables ;-)) the announcing of
       revives. It is usually set to false because it influences game play
       too much... ...and spams the screen ;-P (info: this was mainly added
       for debugging)
     * revive_color default: "7" (white)
       color of announced revives (see above)
     * revive_pos default: "cpm"
       where to put the announced revive messages (see here)
     * spree_cfg default: "revivingspree.txt"
       all time stats are saved here..
     * date_fmt default: "%Y-%m-%d, %H:%M:%S"
       for map record dates, see man strftime(3) ;->
     * spree_pos default: "b 8"
       where to put the spree messages (see here)
     * spree_color default: "8" (orange)
       color of spree messages
     * multi_revive default: true
       false disables multi/monster revives
     * multi_announce default: true
       false disables the messages below
     * multi_msg default: "^7!!!! ^1Multirevive ^7> ^7%s ^7< ^1Multirevive^7
       !!!!"
       what to print in case of multi revive, the '%s' will be replaced by
       the player name ... you MUST HAVE exactly one %s in this string!
     * monster_msg default: "^7OMG,^1 MONSTER REVIVE ^7>>> ^7%s ^7<<<
       ^1MONSTER REVIVE^7 !!!!"
       what to print in case of monster revive, the '%s' will be replaced by
       the player name ... you MUST HAVE exactly one %s in this string!
     * multi_sound default: false
       DON'T set to true to enable, no sounds yet...
       SET TO false IF YOU DON'T HAVE SOUNDS FOR THIS...
       if set to true will play "sound/misc/multirevive.wav" /
       "sound/misc/monsterrevive.wav" as global sound (like etadmin_mod's
       "multikill"/"monsterkill" sounds).
       Put the sounds you want in a .pk3 and make it available for your
       clients
     * multi_pos default: "b 8"
       where to put the multi revive messages (see here)
     * monster_pos default: "b 32"
       where to put the monster revive messages (see here)
     * multi_without_death default: false
       set to true to stop multi revives if medic dies...
       yes, it's very unlikely, but you can revive, die, get revived and make
       another revive within 3 seconds....
       ... probably it's worth a possible multi/monster revive if a player
       manages to do that (hence the default of: false)
     * allow_tk_revive default: true
       new in 1.1.9: If set to true, a revive of a team killed team mate does
       not add a revive, but just sets the time of the last revive. With this
       you can tk one, revive someone else, then the tk'd player and another
       one with max 3 secs between each revive instead of max 3 seconds
       between two not tk'd players.
       If set to false, the time between reviving two not tk'd players is
       used
     * rspree_cmd default: "!spree_record"
       same as etadmin_mod's killing spree record printing, output is same
       (just for reviving sprees instead of killing sprees ;-)) ... if you
       use the default, this rspree mod and the etadmin_mod will both print
       their stats
     * rspree_cmd_enabled default: true
       set to false to ignore the "rspree_cmd"
     * record_cfg default: "rspree-records.txt"
       new in 1.1.0: all time records file
     * record_cmd default: "!rsprees"
       new in 1.1.0: command for players to print players with most monster,
       multi and normal revives
     * record_last_nick default: false
       new in 1.1.0: set to true to keep the last known nick a guid has,
       instead of the one seen the first time
     * srv_record default: true
       new in 1.1.0: enable the recording and printing of players with most
       monster, multi and normal revives
     * stats_cmd default: "!stats"
       new in 1.1.2: same as etadmin_mod's "!stats", prints personal reviving
       records (i.e. monster, multi, and normal)
     * record_expire default: 60*60*24*90
       new in 1.1.2: expire settings after a player has not made any revives
       since this many seconds... set to 0 to disable.
       NOTE: don't set this too high, else it will cause a delay on map
       start. Watch the log file for messages like

 rspree.lua: startup: 20 ms

       and lower the expire time if it's too long ...
     * save_awards default: true
       new in 1.1.8: save monsterrevives to the awards_file... include this
       in your homepage or ... ;->
     * awards_file default: "awards.txt"
       new in 1.1.8: save monsterrevives to this file if save_awards is true.
     * msg_default default: true
       new in 1.2.0: default for all clients, send messages if true.
     * msg_command default: "rsprees"
       new in 1.2.0: clients use this command to switch on / off the
       messages. This will last until they disconnect. Clients may set a
       default with +setu v_rsprees 1 (or 0 to disable).
   Customization of reviving spree messages... WARNING: don't try to add
   something higher than 35, it will be ignored ;-)

 R_Sprees = { -- these numbers MUST be multiple of 5...!
      [5] = "is on a reviving spree",
     [10] = "really needs new syringes soon",
     [15] = "earned the bronze syringe",
     [20] = "earned the silver syringe",
     [25] = "earned the golden syringe",
     [30] = "is a god dressed in white",
     [35] = "just arrived from the 4077th M*A*S*H",
 }

Servers

Contact

   Vetinari @ QuakeNet (#hirntot.org)
   or mail

     ----------------------------------------------------------------------

   $Revision: 180 $ $Date: 2007-03-02 13:05:27 +0100 (Fri, 02 Mar 2007) $
