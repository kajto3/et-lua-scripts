The QMM bugfixes (for Enemy Territory) provides some additional bugfixes which may already be supported by the mod you run. Please note that QMM itself also contains an infostring bugfix which is always enabled and is not covered in this README.

The following bugfixes have been implemented

1) /ws Crash Protection
  This bugfix is enabled when the cvar bf_ws is set to 1 (default). To disable this fix simply set bf_ws to 0. 

2) GUID Faking (userinfo)
  This bugfix prevents users from changing their GUID after they have joined the server. This is required for console mods such as etadmin_mod and etphp. This bugfix is enabled when bf_userinfo is set to 1 (default). To disable this bugfix set bf_userinfo to 0. 

2b) The userinfo bugfix above prevents the user from exploiting the bug on 2.55 clients which allows them to gain referee access, (ref access can then be exploited the same way as callvote to gain rcon, will possibly be fixed in future update).

3) Team Changes Spam Protection
  This bugfix allows the server to restrict how many team changes a player can make within 10 seconds. By default bf_teamchanges is set to 3 (3 team changes per 10 seconds). You can change this value to any integer to allow more/less team changes per 10 seconds. To disable this feature set bf_teamchanges to 0.

4) Name Changes Spam Protection
  This bugfix works the same way as the team changes protection but for name changes. This feature is disabled by default (bf_namechanges is set to 0) as some mods and PB have this feature integrated. To enable this feature set bf_namechanges to the limit of name changes per any 10 second period.

5) Callvote Exploit
  This bugfix prevents clients from injecting additional rcon commands through the callvote command. This bugfix is enabled when bf_callvote is set to 1 (default). To disable this feature set bf_callvote 0.

6) Max Connections per IP
  When bf_maxcon cvar is set to any value above 0 then when more connections are made from the same IP address then the value, they will be rejected and the connection will be closed. By default the connection limit is set to 3. To disable this feature set bf_maxcon 0. This feature allows protection against an exploit which floods your server with fake players.

Documentation for version 1.0.7b released on 20/11/2009
Plugin By Evgeny Yakimov (eyjohn) 
www.ycn-hosting.com

Change Log

1.0.8
- Added bf_namechanges (Name Change Spam Protection

1.0.7b
- Max Connections now protects against the "undetected" -u argument of the q3fill application

1.0.7
- Userinfo has been fixed and should no longer kick players, it is now enabled (bf_userinfo 1) by default
- Max Connections now works by rejecting a connection, causes no player connected/disconnected spam.
