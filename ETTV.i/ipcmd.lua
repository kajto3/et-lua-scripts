-- ipcmd.lua
local admin_vm    = -1
local CommandQueue = {}
 
function et_InitGame(levelTime, randomSeed, restart)
    local mod = ""
    local sig = ""
    local i = 1
    while mod ~= nil do
        mod, sig = et.FindMod(i)
        if string.find(mod, "ipcadmin.lua") == 1 then
            admin_vm = i
            mod      = nil
        end
        i = i + 1
    end
    if admin_vm == -1 then
        et.G_Print("ipcmd.lua: Could not find vm number for ipcadmin.lua")
    end
    et.RegisterModname("ipcmd.lua")
end
 
function et_IPCReceive(vm, msg)
    if vm == admin_vm then
        local junk1,junk2,level,id = string.find(msg, "IsAdmin:%s+(%d+)%s+(%d)")
        if level ~= nil and id ~= nil then
            runAction(tonumber(id), tonumber(level))
        end
    end
end
 
function runAction(id, level)
    local done = table.foreach(CommandQueue,
        function(i, queue)
            if id == queue[1] then
                if queue[2] <= level then
                    if queue[4] == nil then
                        et.trap_SendConsoleCommand(et.EXEC_INSERT, queue[3])
                    else
                        et.trap_SendConsoleCommand(et.EXEC_INSERT,
                                string.format("%s %s", queue[3], queue[4]))
                    end
                end
                return(i)
            end
        end
    )
    if done ~= nil then
        table.remove(CommandQueue, done)
    end
end
 
function et_ClientCommand(id, command)
    local arg0 = et.trap_Argv(0)
    local arg1 = et.trap_Argv(1)
    if arg0 == "say" then
        if arg1 == "!axis" then
            --          id, lvl, cmd,         argument
            queueCommand(id, 4, "forceteam r", id)
        elseif arg1 == "!allies" then
            queueCommand(id, 4, "forceteam b", id)
        elseif arg1 == "!shuffle" then
            queueCommand(id, 3, "shuffleteamsxp_norestart", nil)
        end
    end
    return(0)
end
 
function queueCommand(id, level, cmd, argument)
    if admin_vm ~= -1 then
        local ok = et.IPCSend(admin_vm, string.format("IsAdmin: %d", id))
        if ok ~= 1 then
            et.G_Print("ipcmd: IPCSend to ipcadmin failed")
        else
            table.insert(CommandQueue, { id, level, cmd, argument })
        end
    end
end