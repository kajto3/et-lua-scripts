
local map
local sound 
userPrint(params.slot,params.chat,et.ConcatArgs(1),-1)
if params[1] ~= nil then
	map = params[1]
else
	map = tostring(et.trap_Cvar_Get("mapname"))
end
sound = "sound\\vo\\" .. map .. "\\" .. 'news_' .. map .. '.wav'
et.G_globalSound(sound)
return 1
