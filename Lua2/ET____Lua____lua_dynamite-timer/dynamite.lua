----------------
-- dynamite.lua 
-- $Date: 2007-02-10 21:35:12 +0100 (Sat, 10 Feb 2007) $
-- $Id: dynamite.lua 66 2007-02-10 20:35:12Z etpro $
-- $Revision: 66 $
--
-- Config:
-- where to place the timer message, see
--   http://wolfwiki.anime.net/index.php/SendServerCommand#Printing 
-- for valid locations
local announce_pos   = "b 8"

-- print "Dynamite planted at LOCATION"?
local announce_plant = false

-- for 20, 10, 5, 3, 2, 1, BOOM use:
local first_step = 20
local steps = { -- [step] = { next step, diff to next step }
                   [20]   =  { 10,        10 }, 
                   [10]   =  {  5,         5 }, 
                    [5]   =  {  3,         2 }, 
                    [3]   =  {  2,         1 }, 
                    [2]   =  {  1,         1 }, 
                    [1]   =  {  0,         1 },
                    [0]   =  {  0,         0 } -- delete if diff to next == 0
              }
-- -- for 25, 15, 5, 3, 2, 1 use:
-- local first_step = 25
-- local steps = {
--                 [25]={15,10},
--                 [15]={5,10},
--                  [5]={3,2},
--                  [3]={2,1}, 
--                  [2]={1,1}, 
--                  [1]={0,0} -- no "Dynamite at %s exploding now" message
--               }
-- -- I think you got the idea now ...oh setting first_step = 30 will print
-- -- everything one (server) frame too late ;-)
-- end Config

local version = "1.0"

local timers  = {}
local levelTime

local ST_NEXT = 1
local ST_DIFF = 2

local T_TIME     = 1
local T_STEP     = 2
local T_LOCATION = 3


-- called when game inits
function et_InitGame(levelTime, randomSeed, restart)
    et.RegisterModname( "dynamite.lua" .. version .. " " .. et.FindSelf() )
    et.G_Print("Vetinari's dynamite.lua version " ..  version .. " activated...\n")
end

function sayClients(pos, msg) 
    et.trap_SendServerCommand(-1, string.format("%s \"%s^7\"", pos, msg))
end

function et_Print(text)
    -- etpro popup: allies planted "the Old City Wall"
    -- etpro popup: axis defused "the Old City Wall"
    local pattern = "^etpro%s+popup:%s+(%w+)%s+(%w+)%s+\"(.+)\""
    local junk1,junk2,team,action,location = string.find(text, pattern)
    if team ~= nil and action ~= nil and location ~= nil then
        if action == "planted" then
            if announce_plant then
                sayClients(announce_pos, 
                    string.format("Dynamite planted at ^8%s^7", location))
            end
            addTimer(location)
        end
        if action == "defused" then
            sayClients(announce_pos, 
                        string.format("Dynamite defused at ^8%s^7", location))
            removeTimer(location)
        end
    end
    if text == "Exit: Timelimit hit.\n" or text == "Exit: Wolf EndRound.\n" then
        -- stop countdowns on intermission
        timers = {}
    end
end

function printTimer(seconds, loc) 
    local when = string.format("in ^8%d^7 seconds", seconds)
    if seconds == 0 then
        when = "^8now^7"
    elseif seconds == 1 then
        when = "in ^81^7 second"
    end
    sayClients(announce_pos, 
            string.format("Dynamite at ^8%s^7 exploding %s", loc, when))
end

function addTimer(location) 
    -- local diff = ((30 - first_step) * 1000) - 25 -- move one frame earlier 
    local diff = (30 - first_step) * 1000
    table.insert(timers, { levelTime + diff, first_step, location })
end

function removeTimer(location) 
    local delete = table.foreach(timers,
        function(i, timer) 
            -- problem with 2 or more planted dynas at one location
            -- ... remove the one which was planted first
            if timer[T_LOCATION] == location then
                return(i)
            end
        end
    )
    if delete ~= nil then
        table.remove(timers, delete)
    end
end

function et_RunFrame(lvltime)
    levelTime = lvltime
    table.foreach(timers,
        function(i, timer)
            if timer[T_TIME] <= levelTime then
                printTimer(timer[T_STEP], timer[T_LOCATION])
                local step = steps[timer[T_STEP]]
                if step[ST_DIFF] == 0 then
                    removeTimer(timer[T_LOCATION])
                else
                    timer[T_STEP] = step[ST_NEXT]
                    timer[T_TIME] = levelTime + (step[ST_DIFF] * 1000)
                end
            end
        end
    )
end

-- vim: ts=4 sw=4 expandtab syn=lua
