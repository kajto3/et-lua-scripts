-------------------------------------
------- Private message mute --------
-------    By Necromancer    --------
-------      4/18/2009       --------
-------   www.usef-et.org    --------
-------------------------------------


-- with this simple lua module a muted player will not be able to send private messages (using the /m command).


function et_ClientCommand( clientNum, command )
	if command == "m" then -- private message
		if tonumber(et.gentity_get(clientNum, "sess.muted")) ~= 0 then -- client is muted
			return 1 -- abort PM
		end
	end
	return 0
end
