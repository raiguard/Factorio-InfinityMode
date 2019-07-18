-- ----------------------------------------------------------------------------------------------------
-- CONDITIONAL EVENT HANDLER
-- This script creates and handles conditional events.

local event = require('__stdlib__/stdlib/event/event')
local conditional_event = {}

event.on_init(function()
    global.events = {}
end)

function conditional_event.register(e, handler)
    local events = global.events
    if not events[e] and events[e][handler] then
        if not events[e] then events[e] = {} end
        table.insert(events[e], handler)
    end
    event.register(e, handler)
end

function conditional_event.deregister(e, handler)
    local events = global.events
    events[e][handler] = nil
    event.remove(e, handler)
end

function conditional_event.is_registered(event, handler)
    local events = global.events
    if handler then return events[event] and events[event][handler] and true or false
    else return events[event] and true or false
    end
end

-- function conditional_event.cheat_event(cheat_def, e)

-- end

return conditional_event