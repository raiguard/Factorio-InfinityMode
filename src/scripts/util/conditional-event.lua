-- ----------------------------------------------------------------------------------------------------
-- CONDITIONAL EVENT HANDLER
-- This script creates and handles conditional events.

local abs = math.abs
local event = require('__stdlib__/stdlib/event/event')
local string = require('__stdlib__/stdlib/utils/string')
local table = require('__stdlib__/stdlib/utils/table')

local util = require('scripts/util/util')

-- all conditional events are contained here to enable lookup
local events_def = {
    cheats = {
        player = {
            instant_blueprint = {
                on_built_entity = {{defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built}, function(e)
                    if not e.player_index then return end
                    if not util.cheat_enabled('player', 'instant_blueprint', e.player_index) then return end
                    local entity = e.created_entity or e.entity
                    if util.is_ghost(entity) then entity.revive{raise_revive=true} end
                end}
            },
            instant_upgrade = {
                on_marked_for_upgrade = {{defines.events.on_marked_for_upgrade}, function(e)
                    if not e.player_index then return end
                    if not util.cheat_enabled('player', 'instant_upgrade', e.player_index) then return end
                    local entity = e.entity
                    -- game.print('upgrading entity ' .. entity.name .. ' at position ' .. entity.position.x .. ',' .. entity.position.y .. ' to: ' .. e.target.name)
                    entity.surface.create_entity{
                        name = e.target.name,
                        position = entity.position,
                        direction = entity.direction or nil,
                        force = entity.force,
                        fast_replace = true,
                        spill = false,
                        raise_built = true
                    }
                end}
            },
            instant_deconstruction = {
                on_deconstruction = {{defines.events.on_marked_for_deconstruction}, function(e)
                    if not e.player_index then return end
                    if not util.cheat_enabled('player', 'instant_deconstruction', e.player_index) then return end
                    e.entity.destroy{do_cliff_correction=true, raise_destroy=true}
                end}
            },
            keep_last_item = {
                on_put_item = {{defines.events.on_put_item}, function(e)
                    local player = util.get_player(e)
                    if not util.cheat_enabled('player', 'keep_last_item', player.index) then return end
                    local cursor_stack = player.cursor_stack
                    if cursor_stack.valid_for_read and cursor_stack.count == 1 then
                        player.get_main_inventory().insert{name=cursor_stack.name, count=cursor_stack.count}
                    end
                end}
            },
            repair_damaged_item = {
                on_main_inv_changed = {{defines.events.on_player_main_inventory_changed}, function(e)
                    local player = util.get_player(e)
                    if not util.cheat_enabled('player', 'repair_damaged_item', player.index) then return end
                    local inventory = player.get_main_inventory()
                    -- iterate over every slot in the inventory, repairing any damaged items
                    for i=1,#inventory do
                        if inventory[i].valid_for_read and inventory[i].durability then inventory[i].add_durability(1000000) end
                        -- there is currently no way to get the max ammo for an ammoitem, and simply setting it to 1000000 will cause additional items to be created
                        -- if inventory[i].valid_for_read and inventory[i].type == 'ammo' then inventory[i].add_ammo(1000000) end
                    end
                end},
                on_cursor_stack_changed = {{defines.events.on_player_cursor_stack_changed}, function(e)
                    
                end},
                on_tick = {{defines.events.on_tick}, function(e)
                    
                end}
            },
            instant_request = {
                on_main_inventory_changed = {{defines.events.on_player_main_inventory_changed}, function(e)
                    local player = util.get_player(e)
                    if not util.cheat_enabled('player', 'instant_request', player.index) then return end
                    -- check if the player has a character
                    if not player.character then return end
                    local character = player.character
                    local inventory = player.get_main_inventory()
                    local contents = inventory.get_contents()
                    -- combine the cursor stack with the main inventory contents
                    if player.cursor_stack.valid_for_read then
                        local stack = player.cursor_stack
                        contents[stack.name] = stack.count + (contents[stack.name] or 0)
                    end
                    -- iterate over all request slots
                    for i=1,character.request_slot_count do
                        local request = character.get_request_slot(i)
                        if request then
                            -- subtract request from the actual count
                            local diff = request.count - (contents[request.name] or 0)
                            if diff > 0 then
                                inventory.insert{name=request.name, count=diff}
                            end
                        end
                    end
                end}
            },
            instant_trash = {
                on_trash_inventory_changed = {{defines.events.on_player_trash_inventory_changed}, function(e)
                    local player = util.get_player(e)
                    if not util.cheat_enabled('player', 'instant_trash', player.index) then return end
                    -- check if the player has a character
                    if not player.character then return end
                    player.character.get_inventory(defines.inventory.character_trash).clear()
                end}
            }
        },
        force = {
            instant_research = {
                on_research_started = {{defines.events.on_research_started}, function(e)
                    local research = e.research
                    local force = research.force
                    if not util.cheat_enabled('force', 'instant_research', force.index) then return end
                    force.research_progress = 1
                end}
            }
        },
        surface = {
            
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
        if events[e] == nil then return end
        events[e][def] = nil
        if table_size(events[e]) == 0 then events[e] = nil end
        event.remove(e, object[2])
    end
end

-- only register if nobody else has the cheat active
function conditional_event.cheat_register(obj, cheat_def, event_def)
    local string_table = string.split(event_def)
    if not util.cheat_enabled(string_table[2], string_table[3], nil, obj.index) then
        conditional_event.register(event_def)
    end
end

function conditional_event.cheat_deregister(obj, cheat_def, event_def)
    local string_table = string.split(event_def)
    if not util.cheat_enabled(string_table[2], string_table[3], nil, obj.index) then
        conditional_event.deregister(event_def)
    end
end

return conditional_event