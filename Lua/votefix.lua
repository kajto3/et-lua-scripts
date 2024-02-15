Modname = "votefix"
Version = "0.1"
Author = "Perlo_0ung?!"

function et_InitGame(levelTime,randomSeed,restart)
	et.G_Print("[votefix] Version:"..Version.." Loaded\n")
	et.RegisterModname(Modname .. " " .. Version)
end

et.CS_VOTE_STRING = 7

function et_Print(text)
	local t = ParseString(text)  --Vote Passed: Change map to suppLY
	if t[2] == "Passed:" and t[4] == "map" then 
		if string.find(t[6],"%u") == nil or t[6] ~= getCS() then return 1 end
			local mapfixed = string.lower(t[6])
			et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref map " .. mapfixed .. "\n" )
			--et.G_Print("votefix: map "..mapfixed.." loaded \n") --Debug line
			--et.G_Print("votefix: map "..t[6].." loaded \n") --Debug line
	end
end    
    
function ParseString(inputString)
	local i = 1
	local t = {}
	for w in string.gfind(inputString, "([^%s]+)%s*") do
		t[i]=w
		i=i+1
	end
	return t
 end

function getCS()
	local cs = et.trap_GetConfigstring(et.CS_VOTE_STRING)
	local t = ParseString(cs)
	return t[4]
end