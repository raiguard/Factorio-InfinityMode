-- ----------------------------------------------------------------------------------------------------
-- INFINITY LOADER CONTROL SCRIPTING

local event = require('__stdlib__/stdlib/event/event')
local on_event = event.register
local util = require('scripts/util/util')

local function check_is_loader(e)
    if string.find(e, 'infinity-loader') then return true end
    return false
end

event.on_init(function()
    global.loaders = {}
end)

-- when an entity is built
on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive}, function(e)
    local entity = e.created_entity or e.entity
    if string.find(entity.name, 'infinity%-loader') then
        local max_index = entity.get_max_transport_line_index()
        local data = {
            entity = entity,
            num_lines = max_index
        }
        for i=1,max_index do
            data['transport_line_'..i] = entity.get_transport_line(i)
            data['filter_'..i] = 'iron-ore'
        end
        global.loaders[entity.unit_number] = data
    end
end)

-- when an entity is destroyed
on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, function(e)
    local entity = e.entity
    if string.find(entity.name, 'infinity%-loader') then
        global.loaders[entity.unit_number] = nil
    end
end)

-- on_event(defines.events.on_tick, function(e)
--     for _,t in pairs(global.loaders) do
--         for i=1,t.num_lines do
--             local line = t['transport_line_'..i]
--             if line.can_insert_at_back() and t['filter_'..i] then
--                 line.insert_at_back{name=t['filter_'..i], count=1}
--             end
--         end
--     end
-- end)