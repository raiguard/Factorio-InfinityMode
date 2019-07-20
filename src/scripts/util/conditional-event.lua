-- ----------------------------------------------------------------------------------------------------
-- CONDITIONAL EVENT HANDLER
-- This script creates and handles conditional events.

local event = require('__stdlib__/stdlib/event/event')
local string = require('__stdlib__/stdlib/utils/string')

local util = require('scripts/util/util')

-- all conditional events are contained here for easy lookup
local events_def = {
    cheats = {
        player = {
            instant_blueprint = {
                on_built_entity = {{defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built}, function(e)
                    if util.is_ghost(e.created_entity) then e.created_entity.revive{raise_revive=true} end
                end}
            },
            instant_deconstruction = {
                on_deconstruction = {{defines.events.on_marked_for_deconstruction}, function(e)
                    e.entity.destroy{raise_destroy=true}
                end}
            }
        }
    },
    infinity_wagon = {
        on_tick = {{defines.events.on_tick}, function(e)
            for _,t in pairs(global.wagons) do
                if t.wagon.valid and t.ref.valid then
                    if t.wagon_name == 'infinity-cargo-wagon' then
                        if t.flip == 0 then
                            t.wagon_inv.clear()
                            for n,c in pairs(t.ref_inv.get_contents()) do t.wagon_inv.insert{name=n, count=c} end
                            t.flip = 1
                        elseif t.flip == 1 then
                            t.ref_inv.clear()
                            for n,c in pairs(t.wagon_inv.get_contents()) do t.ref_inv.insert{name=n, count=c} end
                            t.flip = 0
                        end
                    elseif t.wagon_name == 'infinity-fluid-wagon' then
                        if t.flip == 0 then
                            local fluid = t.ref_fluidbox[1]
                            t.wagon_fluidbox[1] = fluid and {name=fluid.name, amount=(abs(fluid.amount) * 250), temperature=fluid.temperature} or nil
                            t.flip = 1
                        elseif t.flip == 1 then
                            local fluid = t.wagon_fluidbox[1]
                            t.ref_fluidbox[1] = fluid and {name=fluid.name, amount=(abs(fluid.amount) / 250), temperature=fluid.temperature} or nil
                            t.flip = 0
                        end
                    end
                end
            end
        end}
    }
}

local conditional_event = {}

local function get_object(string)
    local def = events_def
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
            conditional_event.register(def)
        end
    end
end)

-- handler must be a function reference from the definitions file
function conditional_event.register(def)
    local events = global.events
    local object = get_object(def)
    for i,e in pairs(object[1]) do
        if not events[e] then events[e] = {} end
        if not events[e][def] then
            events[e][def] = true
        end
        event.register(e, object[2])
    end
end

function conditional_event.deregister(def)
    local events = global.events
    local object = get_object(def)
    for i,e in pairs(object[1]) do
        events[e][def] = nil
        if table_size(events[e]) == 0 then events[e] = nil end
        event.remove(e, object[2])
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