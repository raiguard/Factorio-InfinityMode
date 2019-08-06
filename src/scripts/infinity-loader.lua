-- ----------------------------------------------------------------------------------------------------
-- INFINITY LOADER CONTROL SCRIPTING

local conditional_event = require('scripts/util/conditional-event')
local event = require('__stdlib__/stdlib/event/event')
local direction = require('__stdlib__/stdlib/area/direction')
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
    '%-?splitter',
    'infinity%-loader%-underneathy%-?'
}

local function get_belt_type(entity)
    local type = connected_belt_overrides[entity.name]
    if not type then
        type = entity.name
        for _,pattern in pairs(connected_belt_patterns) do
            type = type:gsub(pattern, '')
        end
        -- check to see if the underneathy exists
        if type ~= '' and not game.entity_prototypes['infinity-loader-underneathy-'..type] then
            -- print warning message
            game.print{'chat-message.unable-to-identify-belt-warning'}
            game.print('belt_name=\''..entity.name..'\', parse_result=\''..type..'\'')
            -- set to default type
            type = 'express'
        end
    end
    return type
end

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

local function to_vector_2d(direction, longitudinal, orthogonal)
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
    local entities = entity.surface.find_entities_filtered{type={'transport-belt','underground-belt','splitter'}, area=position.to_tile_area(position.add(entity.position, to_vector_2d(entity.direction,-1,0)))}
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
    for i=1,#inserters do
        local side = i > (#inserters/2) and -0.25 or 0.25
        local inserter = inserters[i]
        local mod = (i % (#inserters/2))
        if e_type == 'input' then
            -- pickup on belt, drop in chest
            inserter.pickup_target = entity
            inserter.pickup_position = position.add(e_position, to_vector_2d(e_direction,(-mod*0.2 + 0.4),side))
            inserter.drop_target = chest
            inserter.drop_position = e_position
        elseif e_type == 'output' then
            -- pickup from chest, drop on belt
            inserter.pickup_target = chest
            inserter.pickup_position = chest.position
            inserter.drop_target = entity
            inserter.drop_position = position.add(e_position, to_vector_2d(e_direction,(mod*0.2 - 0.4),side))
        end
        -- TEMPORARY rendering
        -- rendering.draw_circle{target=inserter.pickup_position, color={r=0,g=1,b=0,a=0.5}, surface=entity.surface, radius=0.03, filled=true, time_to_live=300}
        -- rendering.draw_circle{target=inserter.drop_position, color={r=0,g=1,b=1,a=0.5}, surface=entity.surface, radius=0.03, filled=true, time_to_live=300}
    end
end

-- offsets based on direction
local facing_lib = {
    [defines.direction.north] = {0,-1},
    [defines.direction.east] = {1,0},
    [defines.direction.south] = {0,1},
    [defines.direction.west] = {-1,0}
}

-- check if the given loader is facing the given belt
local function loader_facing_belt(loader, belt)
    local op = loader.belt_to_ground_type == 'output' and 'add' or 'subtract'
    if position.equals(position[op](loader.position, facing_lib[loader.direction]), belt.position) then
        return true
    end
    return false
end

local function update_filters(entity)
    local inserters = entity.surface.find_entities_filtered{name='infinity-loader-inserter', position=entity.position}
    local chest = entity.surface.find_entities_filtered{name='infinity-loader-chest', position=entity.position}[1]
    local filters = entity.get_control_behavior().parameters.parameters
    -- update inserter filter based on side
    for i=1,#inserters do
        local side = i > (#inserters/2) and 1 or 2
        inserters[i].set_filter(1, filters[side].signal.name or nil)
    end
    for i=1,2 do
        local name = filters[i].signal.name
        chest.set_infinity_container_filter(i, name and {name=name, count=game.item_prototypes[name].stack_size, mode='exactly', index=i} or nil)
    end
    chest.remove_unfiltered_items = true
end

local function create_loader(type, mode, surface, position, direction, force)
    local underneathy = surface.create_entity{
        name = 'infinity-loader-underneathy' .. (type == '' and '' or '-'..type),
        position = position,
        direction = mode == 'input' and opposite_direction(direction) or direction,
        force = force,
        type = mode
    }
    local inserters = {}
    for i=1,num_inserters(underneathy) do
         inserters[i] = surface.create_entity{
            name='infinity-loader-inserter',
            position = position,
            force = force,
            direction = direction
        }
        inserters[i].inserter_stack_size_override = 1
    end
    local chest = surface.create_entity{
        name = 'infinity-loader-chest',
        position = position,
        force = force
    }
    local combinator = surface.create_entity{
        name = 'infinity-loader-logic-combinator',
        position = position,
        force = force,
        direction = direction
    }
    return underneathy, inserters, chest, combinator
end

-- ----------------------------------------------------------------------------------------------------
-- SNAPPING

-- snap adjacent loaders to a belt entity
local function perform_snapping(entity)
    for _,pos in pairs(tile.adjacent(entity.surface, position.floor(entity.position))) do
        local entities = entity.surface.find_entities_filtered{area=position.to_tile_area(pos), type='underground-belt'} or {}
        for _,e in pairs(entities) do
            if e.name:find('infinity%-loader%-underneathy') then
                if loader_facing_belt(e, entity) then
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
end

-- update adjacent loader types, if necessary
local function update_loader_types(entity)
    local belt_type = get_belt_type(entity)
    for _,pos in pairs(tile.adjacent(entity.surface, position.floor(entity.position))) do
        local entities = entity.surface.find_entities_filtered{area=position.to_tile_area(pos), type='underground-belt'} or {}
        for _,e in pairs(entities) do
            if e.name:find('infinity%-loader%-underneathy') and loader_facing_belt(e, entity) then
                local loader_type = get_belt_type(e)
                if belt_type ~= loader_type then
                    -- old loader has to be destroyed first, so save its info here
                    local position = e.position
                    local force = e.force
                    local direction = e.direction
                    local type = e.belt_to_ground_type
                    local surface = e.surface
                    e.destroy()
                    local new_loader = surface.create_entity{
                        name = 'infinity-loader-underneathy' .. (belt_type == '' and '' or '-'..belt_type),
                        position = position,
                        force = force,
                        direction = direction,
                        type = type
                    }
                    update_inserters(new_loader)
                end
            end
        end
    end
end

-- ----------------------------------------------------------------------------------------------------
-- BLUEPRINTING

-- convert loaders in a blueprint to dummy combinators
local function convert_blueprint_loaders(bp)
    local entities = bp.get_blueprint_entities()
    if not entities then return end
    for i=1,#entities do
        if entities[i].name == 'infinity-loader-logic-combinator' then
            entities[i].name = 'infinity-loader-dummy-combinator'
            entities[i].direction = opposite_direction(entities[i].direction or defines.direction.north)
        end
    end
    bp.set_blueprint_entities(entities)
end

-- ----------------------------------------------------------------------------------------------------
-- LISTENERS

event.on_init(function()
    global.loaders = {}
    remote.add_interface('infinity_mode', {update_loader_filters=update_filters})
end)

event.on_load(function()
    remote.add_interface('infinity_mode', {update_loader_filters=update_filters})
end)

-- when an entity is built
on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive}, function(e)
    local entity = e.created_entity or e.entity
    -- if the placed entity is an infinity underneathy
    if entity.name == 'infinity-loader-dummy-combinator' then
        local connected_belt = get_connected_belt(entity)
        local type, mode
        if connected_belt then
            type = get_belt_type(connected_belt)
            mode = connected_belt.direction ~= entity.direction and 'output' or 'input'
        else
            type = 'express'
            mode = 'output'
        end
        local loader,inserters,chest,combinator = create_loader(type, mode, entity.surface, entity.position, opposite_direction(entity.direction), entity.force)
        -- get previous filters, if any
        combinator.get_or_create_control_behavior().parameters = entity.get_or_create_control_behavior().parameters
        entity.destroy()
        -- update entitiy
        update_inserters(loader)
        update_filters(combinator)
    elseif entity.type == 'transport-belt' or entity.type == 'underground-belt' or entity.type == 'splitter' then
        update_loader_types(entity)
        perform_snapping(entity)
    end
end)

-- when an entity is rotated
on_event(defines.events.on_player_rotated_entity, function(e)
    local entity = e.entity
    local surface = entity.surface
    if string.find(entity.name, 'infinity%-loader%-logic%-combinator') then
        entity.direction = e.previous_direction
        local underneathy = entity.surface.find_entities_filtered{type='underground-belt', position=entity.position}[1]
        underneathy.rotate()
        update_inserters(underneathy)
    elseif entity.type == 'transport-belt' or entity.type == 'underground-belt' or entity.type == 'splitter' then
        perform_snapping(entity)
    end
end)

-- when an entity is destroyed
on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, function(e)
    local entity = e.entity
    if string.find(entity.name, 'infinity%-loader%-logic%-combinator') then
        local entities = entity.surface.find_entities_filtered{position=entity.position}
        for _,e in pairs(entities) do e.destroy() end
    end
end)

-- when a player selects an area for blueprinting
on_event(defines.events.on_player_setup_blueprint, function(e)
    local player = util.get_player(e)
    local bp = player.blueprint_to_setup
    if not bp or not bp.valid_for_read then
        bp = player.cursor_stack
    end
    convert_blueprint_loaders(bp)
end)

-- when a player opens a GUI
on_event(defines.events.on_gui_opened, function(e)
    local entity = e.entity
    if entity and entity.name == 'infinity-loader-logic-combinator' then
        if #global.loaders == 0 then
            conditional_event.register('infinity_loader.on_tick')
        end
        global.loaders[entity.unit_number] = entity
    end
end)

-- when a player closes a GUI
on_event(defines.events.on_gui_closed, function(e)
    local entity = e.entity
    if entity and entity.name == 'infinity-loader-logic-combinator' then
        global.loaders[entity.unit_number] = nil
        if #global.loaders == 0 then
            conditional_event.deregister('infinity_loader.on_tick')
        end
    end
end)

-- when an entity settings copy/paste occurs
on_event(defines.events.on_entity_settings_pasted, function(e)
    if e.destination.name == 'infinity-loader-logic-combinator' then
        update_filters(e.destination)
    end
end)