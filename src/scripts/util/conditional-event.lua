-- ----------------------------------------------------------------------------------------------------
-- CONDITIONAL EVENT HANDLER
-- This script creates and handles conditional events.

local event = require('__stdlib__/stdlib/event/event')
local util = require('scripts/util/util')
local conditional_event = {}

event.on_init(function()
    global.events = {}
end)

event.on_load(function()
    for e,t in pairs(global.events) do
        for _,h in pairs(t) do
            event.register(e,h)
        end
    end
end)

function conditional_event.register(e, handler)
    local events = global.events
    if not events[e] then events[e] = {} end
    if not events[e][handler] then
        table.insert(events[e], handler)
    end
    event.register(e, handler)
    LOG(global.events)
end

function conditional_event.deregister(e, handler)
    local events = global.events
    events[e][handler] = nil
    event.remove(e, handler)
    LOG(global.events)
end

function conditional_event.is_registered(event, handler)
    local events = global.events
    if handler then return events[event] and events[event][handler] and true or false
    else return events[event] and true or false
    end
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