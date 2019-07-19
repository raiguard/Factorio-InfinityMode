-- ----------------------------------------------------------------------------------------------------
-- CONDITIONAL EVENT HANDLER
-- This script creates and handles conditional events.

local event = require('__stdlib__/stdlib/event/event')
local string = require('__stdlib__/stdlib/utils/string')

local defs = require('scripts/util/definitions')
local util = require('scripts/util/util')

local conditional_event = {}

local function get_object(string)
    local def = defs
    for _,key in pairs(string.split(string)) do
        def = def[key]
    end
    return def
end

event.on_init(function()
    global.events = {}
end)

event.on_load(function()
    for e,t in pairs(global.events) do
        for def,_ in pairs(t) do
            event.register(e, get_object(def))
        end
    end
end)

-- handler must be a function reference from the definitions file
function conditional_event.register(e, def)
    local events = global.events
    if not events[e] then events[e] = {} end
    if not events[e][def] then
        events[e][def] = true
    end
    event.register(e, get_object(def))
    LOG(global.events)
end

function conditional_event.deregister(e, def)
    local events = global.events
    events[e][def] = nil
    if table_size(events[e]) == 0 then events[e] = nil end
    event.remove(e, get_object(def))
    LOG(global.events)
end

function conditional_event.cheat_event(e)
    if not e.player_index then
        game.print('cannot follow cheat event without a player index!')
        return
    end
    local player = util.get_player(e)
    local events = global.events
end

return conditional_event