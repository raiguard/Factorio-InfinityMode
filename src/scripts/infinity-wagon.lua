local abs = math.abs

-- on game init
script.on_init(function(e)
    game.create_surface('soh', {width = 1, height = 1})
end)

-- on every tick
script.on_event(defines.events.on_tick, function(e)
    for _,t in pairs(global) do
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
end)

-- when an entity is built
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, function(e)
    local entity = e.created_entity
    if entity.name == 'infinity-cargo-wagon' or entity.name == 'infinity-fluid-wagon' then
        local ref = game.surfaces.soh.create_entity{name = 'infinity-' .. (entity.name == 'infinity-cargo-wagon' and 'chest' or 'pipe'), position = {0,0}, force = entity.force}
        -- create all api lookups here to save time in on_tick()
        global[entity.unit_number] = {
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
script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_marked_for_deconstruction}, function(e)
    local entity = e.entity
    if entity.name == 'infinity-cargo-wagon' then
        -- clear the wagon's inventory and set FLIP to 3 to prevent it from being refilled
        global[entity.unit_number].flip = 3
        entity.get_inventory(defines.inventory.cargo_wagon).clear()
    end
end)

-- when a deconstruction order is canceled
script.on_event(defines.events.on_cancelled_deconstruction, function(e)
    local entity = e.entity
    if entity.name == 'infinity-cargo-wagon' then
        global[entity.unit_number].flip = 0
    end
end)

-- when an entity is destroyed
script.on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, function(e)
    local entity = e.entity
    if entity.name == 'infinity-cargo-wagon' or entity.name == 'infinity-fluid-wagon' then
        global[entity.unit_number].ref.destroy()
        global[entity.unit_number] = nil
    end
end)

-- when a gui is opened
script.on_event('iw-open-gui', function(e)
    local player = game.players[e.player_index]
    local selected = player.selected
    if selected and (selected.name == 'infinity-cargo-wagon' or selected.name == 'infinity-fluid-wagon') then
        player.opened = global[selected.unit_number].ref
    end
end)

-- override cargo wagon's default GUI opening
script.on_event(defines.events.on_gui_opened, function(e)
    if e.entity and e.entity.name == 'infinity-cargo-wagon' then
        game.players[e.player_index].opened = global[e.entity.unit_number].ref
    end
end)

-- when an entity copy/paste happens
script.on_event(defines.events.on_entity_settings_pasted, function(e)
    if e.source.name == 'infinity-cargo-wagon' and e.destination.name == 'infinity-cargo-wagon' then
        global[e.destination.unit_number].ref.copy_settings(global[e.source.unit_number].ref)
    elseif e.source.name == 'infinity-fluid-wagon' and e.destination.name == 'infinity-fluid-wagon' then
        global[e.destination.unit_number].ref.copy_settings(global[e.source.unit_number].ref)
    end
end)