-- ----------------------------------------------------------------------------------------------------
-- INFINITY LOADER CONTROL SCRIPTING

local event = require('__stdlib__/stdlib/event/event')
local position = require('__stdlib__/stdlib/area/position')
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
    if string.find(entity.name, 'infinity%-loader%-underneathy') then
        local chest = entity.surface.create_entity{
            name = 'infinity-loader-chest',
            position = position.add(entity.position, {0.45,0}),
            force = entity.force
        }
        local inserter = entity.surface.create_entity{
            name='infinity-loader-inserter',
            position = entity.position,
            force = entity.force,
            direction = entity.direction
        }
        inserter.inserter_stack_size_override = 1
        inserter.pickup_target = entity
        inserter.drop_target = chest
        inserter.drop_position = chest.position
        inserter.pickup_position = position.add(entity.position, {-0.15,0.25})
        -- rendering.draw_circle{target=inserter.pickup_position, color={r=0,g=1,b=0}, radius=0.035, filled=true, surface=inserter.surface}
        -- rendering.draw_circle{target=inserter.drop_position, color={r=0,g=1,b=1}, radius=0.035, filled=true, surface=inserter.surface}
        -- inserter.pickup_position = 
        chest.set_infinity_container_filter(1, {name='iron-ore', count=50, mode='exactly'})
        chest.set_infinity_container_filter(2, {name='copper-ore', count=50, mode='exactly'})
        chest.remove_unfiltered_items = true
    end
end)

-- when an entity is rotated
on_event(defines.events.on_player_rotated_entity, function(e)
    local entity = e.entity
    local surface = entity.surface
    if string.find(entity.name, 'infinity%-loader%-underneathy') then
        local inserter = surface.find_entities_filtered{type='inserter', position=entity.position}[1]
        local chest = surface.find_entities_filtered{type='infinity-container', area=position.to_tile_area(entity.position)}[1]
        if entity.belt_to_ground_type == 'output' then
            inserter.drop_target = entity
            inserter.pickup_target = chest
            inserter.pickup_position = chest.position
            inserter.drop_position = position.add(entity.position, {-0.15,0.25})
        else
            inserter.drop_target = chest
            inserter.pickup_target = entity
            inserter.pickup_position = position.add(entity.position, {-0.15,0.25})
            inserter.drop_position = chest.position
        end
    end
end)

-- when an entity is destroyed
on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, function(e)
    local entity = e.entity
    if string.find(entity.name, 'infinity%-loader') then
        global.loaders[entity.unit_number] = nil
    end
end)