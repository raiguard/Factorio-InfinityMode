-- ----------------------------------------------------------------------------------------------------
-- INFINITY CHEATS DEFINITIONS
-- Definitions for infinity cheats. Basically just a bunch of enormous tables!

local abs = math.abs
local conditional_event = require('scripts/util/conditional-event')
local event = require('__stdlib__/stdlib/event/event')
local util = require('scripts/util/util')

local defs = {}

-- cheat data and functions
defs.cheats = {
    player = {
        god_mode = {type='toggle', default=false, in_god_mode=true, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                local player_table = util.player_table(player)
                local character = player.character
                if new_value == true then
                    -- make sure the player is not in god mode
                    if player.controller_type == defines.controllers.character then
                        -- store character in global
                        player_table.character = character
                        -- 'deactivate' (freeze) character
                        player_table.character.active = false
                        -- switch controller and transfer inventory
                        player.set_controller{type=defines.controllers.god}
                        util.transfer_inventory_contents(character.get_inventory(defines.inventory.character_main), player.get_inventory(defines.inventory.god_main))
                    end
                else
                    -- make sure the player is in god mode
                    if player.controller_type == defines.controllers.god then
                        -- save inventory
                        local god_inventory = player.get_inventory(defines.inventory.god_main)
                        -- if the player does not own a character, create one
                        if not player_table.character then
                            player_table.character = player.surface.create_entity{name='character', position=player.position, force=player.force}
                        end
                        -- teleport character to current position and reenable movement
                        player_table.character.teleport(player.position)
                        player_table.character.active = true
                        -- transfer inventory and switch controller
                        util.transfer_inventory_contents(god_inventory, player_table.character.get_inventory(defines.inventory.character_main))
                        player.set_controller{type=defines.controllers.character, character=player_table.character}
                    end
                end
            end,
            get_value = function(player, cheat_table)
                return player.controller_type == defines.controllers.god
            end
        }},
        invincible_character = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then
                    player.character.destructible = not new_value
                end
            end,
            get_value = function(player, cheat_table)
                return player.character and not player.character.destructible
            end
        }},
        instant_blueprint = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            setup_global = function(player, default_value)
                return { cur_value = default_value }
            end,
            value_changed = function(player, cheat, cheat_table, new_value)
                cheat_table.cur_value = new_value
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_blueprint.on_built_entity')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_blueprint.on_built_entity')
                end
            end,
            get_value = function(player, cheat_table)
                return cheat_table.cur_value
            end
        }},
        instant_upgrade = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            setup_global = function(player, default_value)
                return { cur_value = default_value }
            end,
            value_changed = function(player, cheat, cheat_table, new_value)
                cheat_table.cur_value = new_value
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_upgrade.on_marked_for_upgrade')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_upgrade.on_marked_for_upgrade')
                end
            end,
            get_value = function(player, cheat_table)
                return cheat_table.cur_value
            end
        }},
        instant_deconstruction = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            setup_global = function(player, default_value)
                return { cur_value = default_value }
            end,
            value_changed = function(player, cheat, cheat_table, new_value)
                cheat_table.cur_value = new_value
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_deconstruction.on_deconstruction')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_deconstruction.on_deconstruction')
                end
            end,
            get_value = function(player, cheat_table)
                return cheat_table.cur_value
            end
        }},
        cheat_mode = {type='toggle', default=true, in_god_mode=true, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                player.cheat_mode = new_value
            end,
            get_value = function(player, cheat_table)
                return player.cheat_mode
            end
        }},
        keep_last_item = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            setup_global = function(player, default_value)
                return { cur_value = default_value }
            end,
            value_changed = function(player, cheat, cheat_table, new_value)
                cheat_table.cur_value = new_value
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.keep_last_item.on_put_item')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.keep_last_item.on_put_item')
                end
            end,
            get_value = function(player, cheat_table)
                return cheat_table.cur_value
            end
        }},
        repair_damaged_item = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            setup_global = function(player, default_value)
                return { cur_value = default_value }
            end,
            value_changed = function(player, cheat, cheat_table, new_value)
                cheat_table.cur_value = new_value
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.repair_damaged_item.on_main_inv_changed')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.repair_damaged_item.on_main_inv_changed')
                end
            end,
            get_value = function(player, cheat_table)
                return cheat_table.cur_value
            end
        }},
        instant_request = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            setup_global = function(player, default_value)
                return { cur_value = default_value }
            end,
            value_changed = function(player, cheat, cheat_table, new_value)
                cheat_table.cur_value = new_value
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_request.on_main_inventory_changed')
                    event.dispatch{name=defines.events.on_player_main_inventory_changed, player_index=player.index}
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_request.on_main_inventory_changed')
                end
            end,
            get_value = function(player, cheat_table)
                return cheat_table.cur_value
            end
        }},
        instant_trash = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            setup_global = function(player, default_value)
                return { cur_value = default_value }
            end,
            value_changed = function(player, cheat, cheat_table, new_value)
                cheat_table.cur_value = new_value
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_trash.on_trash_inventory_changed')
                    event.dispatch{name=defines.events.on_player_trash_inventory_changed, player_index=player.index}
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_trash.on_trash_inventory_changed')
                end
            end,
            get_value = function(player, cheat_table)
                return cheat_table.cur_value
            end
        }},
        character_reach_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_reach_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_reach_distance_bonus
            end
        }},
        character_build_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_build_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_build_distance_bonus
            end
        }},
        character_resource_reach_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_resource_reach_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_resource_reach_distance_bonus
            end
        }},
        character_item_drop_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_item_drop_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_item_drop_distance_bonus
            end
        }},
        character_item_pickup_distance_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_item_pickup_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_item_pickup_distance_bonus
            end
        }},
        character_loot_pickup_distance_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_loot_pickup_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_loot_pickup_distance_bonus
            end
        }},
        character_mining_speed_modifier = {type='number', default=1000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_mining_speed_modifier = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_mining_speed_modifier
            end
        }},
        character_running_speed_modifier = {type='number', default=2, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_running_speed_modifier = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_running_speed_modifier
            end
        }},
        character_crafting_speed_modifier = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_crafting_speed_modifier = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_crafting_speed_modifier
            end
        }},
        character_inventory_slots_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_inventory_slots_bonus = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_inventory_slots_bonus
            end
        }},
        character_health_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_table, new_value)
                if player.character then player.character_health_bonus = new_value end
            end,
            get_value = function(player, cheat_table)
                return player.character and player.character_health_bonus
            end
        }}
    },
    force = {
        instant_research = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            setup_global = function(player, default_value)
                return { cur_value = default_value }
            end,
            value_changed = function(player, cheat, cheat_table, new_value)
                cheat_table.cur_value = new_value
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.force.instant_research.on_research_started')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.force.instant_research.on_research_started')
                end
            end,
            get_value = function(player, cheat_table)
                return cheat_table.cur_value
            end
        }}
    },
    surface = {

    },
    game = {

    }
}

-- cheats GUI parameters
defs.cheats_gui_elems = {
    player = {
        {category='toggles', table_columns=2, vertical_centering=false, groups={
            {group='interaction', settings={
                {name='god_mode', type='toggle'},
                {name='invincible_character', type='toggle'},
                {name='instant_blueprint', type='toggle'},
                {name='instant_upgrade', type='toggle'},
                {name='instant_deconstruction', type='toggle'}
            }},
            {group='inventory', settings={
                {name='cheat_mode', type='toggle'},
                {name='keep_last_item', type='toggle'},
                {name='repair_damaged_item', type='toggle'},
                {name='instant_request', type='toggle'},
                {name='instant_trash', type='toggle'}
            }}
        }},
        {category='bonuses', table_columns=1, groups={
            {group='bonuses', settings={
                {name='character_reach_distance_bonus', type='number'},
                {name='character_build_distance_bonus', type='number'},
                {name='character_resource_reach_distance_bonus', type='number'},
                {name='character_item_drop_distance_bonus', type='number'},
                {name='character_item_pickup_distance_bonus', type='number'},
                {name='character_loot_pickup_distance_bonus', type='number'},
                {name='character_mining_speed_modifier', type='number'},
                {name='character_running_speed_modifier', type='number'},
                {name='character_crafting_speed_modifier', type='number'},
                {name='character_inventory_slots_bonus', type='number'},
                {name='character_health_bonus', type='number'}
            }}
        }}
    }
}

return defs