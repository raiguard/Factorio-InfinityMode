-- ----------------------------------------------------------------------------------------------------
-- INFINITY LOADER CONTROL SCRIPTING

local event = require('__stdlib__/stdlib/event/event')
local position = require('__stdlib__/stdlib/area/position')
local table = require('__stdlib__/stdlib/utils/table')
local tile = require('__stdlib__/stdlib/area/tile')
local on_event = event.register
local util = require('scripts/util/util')

-- ----------------------------------------------------------------------------------------------------
-- UTILITIES

-- connected belt name -> underneathy suffix
-- this table is to be used when the auto-detection fails
local connected_belt_overrides = {
    -- ultimate belts - https://mods.factorio.com/mod/UltimateBelts
    ['ultimate-belt'] = 'original-ultimate'
}

-- removing all of these patterns from the connected belt name will result in the suffix 
local connected_belt_patterns = {
    '%-?belt',
    '%-?transport',
    '%-?underground',
    '%-?splitter'
}

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

local function dir_offset(direction, longitudinal, orthogonal)
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

-- gets the transport belt, underneathy, or splitter that the entity is facing
local function get_connected_belt(entity)
    local entities = entity.surface.find_entities_filtered{type={'transport-belt','underground-belt','splitter'}, area=position.to_tile_area(position.add(entity.position, dir_offset(entity.direction,1*(entity.belt_to_ground_type == 'output' and 1 or -1),0)))}
    if entities then return entities[1] end
    return nil
end

-- 60 items/second / 60 ticks/second / 8 items/tile = X tiles/tick
local BELT_SPEED_FOR_60_PER_SECOND = 60/60/8
local function num_inserters(entity)
  return math.ceil(entity.prototype.belt_speed / BELT_SPEED_FOR_60_PER_SECOND) * 2
end

local function update_inserters(entity)
    local inserters = entity.surface.find_entities_filtered{name='infinity-loader-inserter', position=entity.position}
    local chest = entity.surface.find_entities_filtered{name='infinity-loader-chest', position=entity.position}[1]
    local e_type = entity.belt_to_ground_type
    local e_position = entity.position
    local e_direction = entity.direction
    local connected_belt = get_connected_belt(entity)
    -- log(get_connected_belt(entity)[1].name)
    for i=1,#inserters do
        local side = i > (#inserters/2) and 0.25 or -0.25
        local inserter = inserters[i]
        local mod = (i % (#inserters/2))
        if e_type == 'input' then
            -- pickup on belt, drop in chest
            inserter.pickup_target = entity
            inserter.pickup_position = position.add(e_position, dir_offset(e_direction,(-mod*0.2 + 0.4),side))
            inserter.drop_target = chest
            inserter.drop_position = e_position
        elseif e_type == 'output' then
            -- pickup from chest, drop on belt
            inserter.pickup_target = chest
            inserter.pickup_position = chest.position
            inserter.drop_target = entity
            inserter.drop_position = position.add(e_position, dir_offset(e_direction,(mod*0.2 - 0.4),side))
        end
        -- TEMPORARY rendering
        -- rendering.draw_circle{target=inserter.pickup_position, color={r=0,g=1,b=0,a=0.5}, surface=entity.surface, radius=0.03, filled=true, time_to_live=300}
        -- rendering.draw_circle{target=inserter.drop_position, color={r=0,g=1,b=1,a=0.5}, surface=entity.surface, radius=0.03, filled=true, time_to_live=300}
    end
end

-- ----------------------------------------------------------------------------------------------------
-- SNAPPING

-- snap adjacent loaders to a placed belt entity
local function perform_snapping(entity)
    for _,pos in pairs(tile.adjacent(entity.surface, position.floor(entity.position))) do
        local entities = entity.surface.find_entities_filtered{area=position.to_tile_area(pos), type='underground-belt'} or {}
        for _,e in pairs(entities) do
            if e.name:find('infinity%-loader%-underneathy') then
                if e.direction ~= entity.direction and e.belt_to_ground_type == 'input' then
                    e.rotate()
                    update_inserters(e)
                elseif opposite_direction(e.direction) == entity.direction then
                    e.rotate()
                    update_inserters(e)
                end
            end
        end
    end
end

-- ----------------------------------------------------------------------------------------------------
-- LISTENERS

event.on_init(function()
    global.loaders = {}
end)

-- when an entity is built
on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive}, function(e)
    local e_entity = e.created_entity or e.entity
    -- if the placed entity is an infinity underneathy
    if string.find(e_entity.name, 'infinity%-loader%-underneathy') then
        -- attempt to get the connected belt's type
        local connected_belt = get_connected_belt(e_entity)
        -- get type from the manual overrides table, or attempt to auto-detect it
        local suffix = connected_belt and connected_belt_overrides[connected_belt.name]
        if connected_belt and not suffix then
            suffix = connected_belt.name
            for _,pattern in pairs(connected_belt_patterns) do
                suffix = suffix:gsub(pattern, '')
            end
        end
        local entity
        -- if the type exists and is not the same as the underneathy
        if suffix and e_entity.name:gsub('infinity%-loader%-underneathy%-', '') ~= suffix then
            -- if the required underneathy exists, create it
            if suffix and game.entity_prototypes[suffix ~= '' and 'infinity-loader-underneathy-'..suffix or 'infinity-loader-underneathy'] then
                -- we need to destroy the old entity first, so save all of the pertinent data here
                local position = e_entity.position
                local direction = e_entity.direction
                local type = e_entity.belt_to_ground_type
                local force = e_entity.force
                local surface = e_entity.surface
                e_entity.destroy()
                entity = surface.create_entity{
                    name = suffix ~= '' and 'infinity-loader-underneathy-'..suffix or 'infinity-loader-underneathy',
                    position = position,
                    direction = direction,
                    type = type,
                    force = force
                }
            elseif suffix then
                -- use default belt type (express), print error message
                entity = e_entity
                local player = util.get_player(e)
                player.print('ERROR: Could not identify belt type, using express belt')
                player.print('Please give the following information to the mod author via GitHub or the Mod Portal:')
                player.print('connected_belt.name=\''..connected_belt.name..'\', suffix=\''..suffix..'\'')
            else
                entity = e_entity
                entity.rotate()
            end
        else
            entity = e_entity
            entity.rotate()
        end
        -- underneathy snapping
        if connected_belt then
            if connected_belt.direction ~= entity.direction then
                entity.rotate()
            end
        end
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
            inserter.inserter_stack_size_override = 1
        end
        update_inserters(entity)
        chest.set_infinity_container_filter(1, {name='solid-fuel', count=50, mode='exactly'})
        chest.remove_unfiltered_items = true
    elseif e_entity.type == 'transport-belt' or e_entity.type == 'underground-belt' or e_entity.type == 'splitter' then
        perform_snapping(e_entity)
    end
end)

-- when an entity is rotated
on_event(defines.events.on_player_rotated_entity, function(e)
    local entity = e.entity
    local surface = entity.surface
    if string.find(entity.name, 'infinity%-loader%-underneathy') then
        update_inserters(entity)
    elseif entity.type == 'transport-belt' or entity.type == 'underground-belt' or entity.type == 'splitter' then
        perform_snapping(entity)
    end
end)

-- when an entity is destroyed
on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, function(e)
    local entity = e.entity
    if string.find(entity.name, 'infinity%-loader%-underneathy') then
        local entities = entity.surface.find_entities_filtered{position=entity.position}
        for _,e in pairs(entities) do e.destroy() end
    end
end)