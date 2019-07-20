local abs = math.abs
local event = require('__stdlib__/stdlib/event/event')
local on_event = event.register
local util = require('scripts/util/util')

local conditional_event = require('scripts/util/conditional-event')

-- on game init
event.on_init(function()
    game.create_surface('soh', {width = 1, height = 1})
    global.wagons = {}
end)

-- when an entity is built
on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built}, function(e)
    local entity = e.created_entity or e.entity
    if entity.name == 'infinity-cargo-wagon' or entity.name == 'infinity-fluid-wagon' then
        local ref = game.surfaces.soh.create_entity{name = 'infinity-' .. (entity.name == 'infinity-cargo-wagon' and 'chest' or 'pipe'), position = {0,0}, force = entity.force}
        if table_size(global.wagons) == 0 then
            conditional_event.register(defines.events.on_tick, 'infinity_wagon.on_tick')
        end
        -- create all api lookups here to save time in on_tick()
        global.wagons[entity.unit_number] = {
            wagon = entity,
            wagon_name = entity.name,
            wagon_inv = entity.get_inventory(defines.inventory.cargo_wagon),
            wagon_fluidbox = entity.fluidbox,
            ref = ref,
            ref_inv = ref.get_inventory(defines.inventory.chest),
            ref_fluidbox = ref.fluidbox,
            flip = 0
        }
    end
end)

-- before an entity is mined by a player or marked for deconstructione
on_event({defines.events.on_pre_player_mined_item, defines.events.on_marked_for_deconstruction}, function(e)
    local entity = e.entity
    if entity.name == 'infinity-cargo-wagon' then
        -- clear the wagon's inventory and set FLIP to 3 to prevent it from being refilled
        global.wagons[entity.unit_number].flip = 3
        entity.get_inventory(defines.inventory.cargo_wagon).clear()
    end
end)

-- when a deconstruction order is canceled
on_event(defines.events.on_cancelled_deconstruction, function(e)
    local entity = e.entity
    if entity.name == 'infinity-cargo-wagon' then
        global.wagons[entity.unit_number].flip = 0
    end
end)

-- when an entity is destroyed
on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, function(e)
    local entity = e.entity
    if entity.name == 'infinity-cargo-wagon' or entity.name == 'infinity-fluid-wagon' then
        global.wagons[entity.unit_number].ref.destroy()
        global.wagons[entity.unit_number] = nil
        if table_size(global.wagons) == 0 then
            conditional_event.deregister(defines.events.on_tick, 'infinity_wagon.on_tick')
        end
    end
end)

-- when a gui is opened
on_event('iw-open-gui', function(e)
    local player = util.get_player(e)
    local selected = player.selected
    if selected and (selected.name == 'infinity-cargo-wagon' or selected.name == 'infinity-fluid-wagon') then
        player.opened = global.wagons[selected.unit_number].ref
    end
end)

-- override cargo wagon's default GUI opening
on_event(defines.events.on_gui_opened, function(e)
    if e.entity and e.entity.name == 'infinity-cargo-wagon' then
        game.players[e.player_index].opened = global.wagons[e.entity.unit_number].ref
    end
end)

-- when an entity copy/paste happens
on_event(defines.events.on_entity_settings_pasted, function(e)
    if e.source.name == 'infinity-cargo-wagon' and e.destination.name == 'infinity-cargo-wagon' then
        global.wagons[e.destination.unit_number].ref.copy_settings(global.wagons[e.source.unit_number].ref)
    elseif e.source.name == 'infinity-fluid-wagon' and e.destination.name == 'infinity-fluid-wagon' then
        global.wagons[e.destination.unit_number].ref.copy_settings(global.wagons[e.source.unit_number].ref)
    end
end)