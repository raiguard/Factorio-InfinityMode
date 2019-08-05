-- ----------------------------------------------------------------------------------------------------
-- INFINITY LOADER CONTROL SCRIPTING

local event = require('__stdlib__/stdlib/event/event')
local position = require('__stdlib__/stdlib/area/position')
local table = require('__stdlib__/stdlib/utils/table')
local on_event = event.register
local util = require('scripts/util/util')

-- ----------------------------------------------------------------------------------------------------
-- UTILITIES

local function check_is_loader(e)
    if string.find(e, 'infinity-loader') then return true end
    return false
end

local function opposite_direction(direction)
    if direction >= 4 then
        return direction - 4
    end
    return direction + 4
end

local function offset(direction, longitudinal, orthogonal)
    if direction == defines.direction.north then
        return {x=orthogonal, y=-longitudinal}
    elseif direction == defines.direction.south then
        return {x=-orthogonal, y=longitudinal}
    elseif direction == defines.direction.east then
        return {x=longitudinal, y=orthogonal}
    elseif direction == defines.direction.west then
        return {x=-longitudinal, y=-orthogonal}
    end
end

-- returns two arrays of inserter pickup / dropoff positions
local function get_belt_positions(direction, origin)
    -- returns left_array, right_array
    return {
        position.add(origin, offset(direction,0,0.25))
    },{
        position.add(origin, offset(direction,0,-0.25))
    }
end

-- 60 items/second / 60 ticks/second / 8 items/tile = X tiles/tick
local BELT_SPEED_FOR_60_PER_SECOND = 60/60/8
local function num_inserters(entity)
  return math.ceil(entity.prototype.belt_speed / BELT_SPEED_FOR_60_PER_SECOND) * 2
end

local function update_inserters(entity)
    local inserters = entity.surface.find_entities_filtered{name='infinity-loader-inserter', position=entity.position}
    local chest = entity.surface.find_entities_filtered{name='infinity-loader-chest', position=entity.position}
    local e_type = entity.belt_to_ground_type
    local e_position = entity.position
    local e_direction = entity.direction
    for i=1,#inserters do
        local side = i > (#inserters/2) and 0.25 or -0.25
        local inserter = inserters[i]
        local mod = (i % (#inserters/2) + 1) * -1 
        if e_type == 'input' then
            -- pickup on belt, drop in chest
            inserter.pickup_target = entity
            inserter.pickup_position = position.add(e_position, offset(e_direction,mod*0.2,side))
            inserter.drop_target = chest
            inserter.drop_position = e_position
        elseif e_type == 'output' then
            -- pickup from chest, drop on belt
            inserter.pickup_target = chest
            inserter.pickup_position = e_position
            inserter.drop_target = entity
            inserter.drop_position = position.add(e_position, offset(e_direction,-mod*0.2,side))
        end
        -- TEMPORARY rendering
        rendering.draw_circle{target=inserter.pickup_position, color={r=0,g=1,b=0}, surface=entity.surface, radius=0.03, filled=true}
        rendering.draw_circle{target=inserter.drop_position, color={r=0,g=1,b=1}, surface=entity.surface, radius=0.03, filled=true}
    end
end

-- ----------------------------------------------------------------------------------------------------
-- LISTENERS

event.on_init(function()
    global.loaders = {}
end)

-- when an entity is built
on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive}, function(e)
    local entity = e.created_entity or e.entity
    if string.find(entity.name, 'infinity%-loader%-underneathy') then
        local chest = entity.surface.create_entity{
            name = 'infinity-loader-chest',
            position = entity.position,
            force = entity.force
        }
        for i=1,num_inserters(entity) do        
            local inserter = entity.surface.create_entity{
                name='infinity-loader-inserter',
                position = entity.position,
                force = entity.force,
                direction = entity.direction
            }
        end
        update_inserters(entity)
        chest.set_infinity_container_filter(1, {name='iron-ore', count=50, mode='exactly'})
    end
end)

-- when an entity is rotated
on_event(defines.events.on_player_rotated_entity, function(e)
    local entity = e.entity
    local surface = entity.surface
    if string.find(entity.name, 'infinity%-loader%-underneathy') then
        update_inserters(entity)
    end
end)

-- when an entity is destroyed
on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, function(e)
    local entity = e.entity
    if string.find(entity.name, 'infinity%-loader') then
        global.loaders[entity.unit_number] = nil
    end
end)