-- ipcadmin.lua
local IPCQueue = {}
local AdminGUIDs = {
        -- name,       guid,                              level
        { "rEhearsal", "94D9FF5579C29E198E081223544CACD8B533A1C4", 5 },
    }
 
function et_InitGame(levelTime, randomSeed, restart)
     et.RegisterModname("ipcadmin.lua")
end
 
function et_IPCReceive(vm, msg)
    local level
    local junk1, junk2, id = string.find(msg, "IsAdmin:%s+(%d+)")
    if id ~= nil then
        id    = tonumber(id)
        guid  = et.Info_ValueForKey(et.trap_GetUserinfo(id), "cl_guid")
        level = table.foreach(AdminGUIDs,
            function(i, admin)
                if admin[2] == guid then
                    return(admin[3])
                end
            end
        )
        if level == nil then
            level = 0
        end
        table.insert(IPCQueue, { vm, level, id })
    end
end
 
function et_RunFrame(lvltime)
    table.foreach(IPCQueue,
        function(i, queue)
            local ok = et.IPCSend(queue[1],
                            string.format("IsAdmin: %d %d", queue[2], queue[3]))
            if ok ~= 1 then
                local mod, cksum = et.FindMod(queue[1])
                et.G_Print(string.format("ipcadmin: IPCSend to %s (vm: %d) failed", mod, queue[1]))
            end
        end
    )
    IPCQueue = {}
end