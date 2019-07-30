-- ----------------------------------------------------------------------------------------------------
-- INFINITY CHEATS DEFINITIONS
-- Definitions for infinity cheats. Basically just a bunch of enormous tables!

local abs = math.abs
local conditional_event = require('scripts/util/conditional-event')
local event = require('__stdlib__/stdlib/event/event')
local util = require('scripts/util/util')

local defs = {}

local infinity_tools_recipes = {
    'infinity-chest',
    'infinity-chest-active-provider',
    'infinity-chest-passive-provider',
    'infinity-chest-storage',
    'infinity-chest-buffer',
    'infinity-chest-requester',
    'infinity-pipe',
    'heat-interface',
    'infinity-radar',
    'infinity-lab',
    'infinity-accumulator',
    'infinity-electric-pole',
    'infinity-substation',
    'infinity-locomotive',
    'infinity-cargo-wagon',
    'infinity-fluid-wagon',
    'infinity-roboport',
    'infinity-construction-robot',
    'infinity-logistic-robot',
    'infinity-beacon',
    'super-speed-module',
    'super-effectivity-module',
    'super-productivity-module',
    'super-slow-module',
    'super-ineffectivity-module',
    'infinity-fusion-reactor-equipment',
    'infinity-personal-roboport-equipment'
}

local ores_recipes = {
    'wood',
    'coal',
    'stone',
    'iron-ore',
    'copper-ore',
    'uranium-ore'
}

local vanilla_loaders_recipes = {
    'loader',
    'fast-loader',
    'express-loader'
}

-- cheat data and functions
defs.cheats = {
    player = {
        god_mode = {type='toggle', default=false, in_god_mode=true, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
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
            get_value = function(player, cheat_global)
                return player.controller_type == defines.controllers.god
            end
        }},
        invincible_character = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then
                    player.character.destructible = not new_value
                end
            end,
            get_value = function(player, cheat_global)
                return player.character and not player.character.destructible
            end
        }},
        instant_blueprint = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_blueprint.on_built_entity')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_blueprint.on_built_entity')
                end
            end,
            get_value = function(player, cheat_global)
                return cheat_global.cur_value
            end
        }},
        instant_upgrade = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_upgrade.on_marked_for_upgrade')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_upgrade.on_marked_for_upgrade')
                end
            end,
            get_value = function(player, cheat_global)
                return cheat_global.cur_value
            end
        }},
        instant_deconstruction = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_deconstruction.on_deconstruction')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_deconstruction.on_deconstruction')
                end
            end,
            get_value = function(player, cheat_global)
                return cheat_global.cur_value
            end
        }},
        cheat_mode = {type='toggle', default=true, in_god_mode=true, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                player.cheat_mode = new_value
            end,
            get_value = function(player, cheat_global)
                return player.cheat_mode
            end
        }},
        keep_last_item = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.keep_last_item.on_put_item')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.keep_last_item.on_put_item')
                end
            end,
            get_value = function(player, cheat_global)
                return cheat_global.cur_value
            end
        }},
        repair_damaged_item = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.repair_damaged_item.on_main_inv_changed')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.repair_damaged_item.on_main_inv_changed')
                end
            end,
            get_value = function(player, cheat_global)
                return cheat_global.cur_value
            end
        }},
        instant_request = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_request.on_main_inventory_changed')
                    event.dispatch{name=defines.events.on_player_main_inventory_changed, player_index=player.index}
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_request.on_main_inventory_changed')
                end
            end,
            get_value = function(player, cheat_global)
                return cheat_global.cur_value
            end
        }},
        instant_trash = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_trash.on_trash_inventory_changed')
                    event.dispatch{name=defines.events.on_player_trash_inventory_changed, player_index=player.index}
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_trash.on_trash_inventory_changed')
                end
            end,
            get_value = function(player, cheat_global)
                return cheat_global.cur_value
            end
        }},
        character_reach_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_reach_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_reach_distance_bonus
            end
        }},
        character_build_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_build_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_build_distance_bonus
            end
        }},
        character_resource_reach_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_resource_reach_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_resource_reach_distance_bonus
            end
        }},
        character_item_drop_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_item_drop_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_item_drop_distance_bonus
            end
        }},
        character_item_pickup_distance_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_item_pickup_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_item_pickup_distance_bonus
            end
        }},
        character_loot_pickup_distance_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_loot_pickup_distance_bonus = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_loot_pickup_distance_bonus
            end
        }},
        character_mining_speed_modifier = {type='number', default=1000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_mining_speed_modifier = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_mining_speed_modifier
            end
        }},
        character_running_speed_modifier = {type='number', default=2, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_running_speed_modifier = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_running_speed_modifier
            end
        }},
        character_crafting_speed_modifier = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_crafting_speed_modifier = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_crafting_speed_modifier
            end
        }},
        character_inventory_slots_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_inventory_slots_bonus = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_inventory_slots_bonus
            end
        }},
        character_health_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_health_bonus = new_value end
            end,
            get_value = function(player, cheat_global)
                return player.character and player.character_health_bonus
            end
        }}
    },
    force = {
        instant_research = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(force, cheat, 'cheats.force.instant_research.on_research_started')
                else
                    conditional_event.cheat_deregister(force, cheat, 'cheats.force.instant_research.on_research_started')
                end
            end,
            get_value = function(force, cheat_global)
                return cheat_global.cur_value
            end
        }},
        research_all_technologies = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                if new_value then
                    force.research_all_technologies()
                else
                    force.reset()
                end
            end,
            get_value = function(force, cheat_global)
                return cheat_global.cur_value
            end
        }},
        infinity_tools_recipes = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                for n,r in pairs(game.recipe_prototypes) do
                    if string.find(n, 'im_tool_') and force.recipes[n] then force.recipes[n].enabled = new_value end
                end
            end,
            get_value = function(force, cheat_global)
                return cheat_global.cur_value
            end
        }},
        free_resource_recipes = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                for n,r in pairs(game.recipe_prototypes) do
                    if string.find(n, 'im_free_resource_') and force.recipes[n] then force.recipes[n].enabled = new_value end
                end
            end,
            get_value = function(force, cheat_global)
                return cheat_global.cur_value
            end
        }},
        vanilla_loaders_recipes = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                for _,n in pairs(vanilla_loaders_recipes) do
                    if force.recipes[n] then force.recipes[n].enabled = new_value end
                end
            end,
            get_value = function(force, cheat_global)
                return cheat_global.cur_value
            end
        }},
        misc_vanilla_recipes = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.recipes['player-port'].enabled = new_value
                force.recipes['railgun'].enabled = new_value
                force.recipes['railgun-dart'].enabled = new_value
            end,
            get_value = function(force, cheat_global)
                return cheat_global.cur_value
            end
        }}
    },
    surface = {
        freeze_time = {type='toggle', default=true, in_god_mode=true, in_editor=true, functions={
            value_changed = function(surface, cheat, cheat_global, new_value)
                surface.freeze_daytime = new_value
            end,
            get_value = function(surface, cheat_global)
                return surface.freeze_daytime
            end 
        }}
    },
    game = {

    }
}

-- cheats GUI parameters
defs.cheats_gui_elems = {
    player = {
        toggles = {
            interaction = {
                god_mode = {},
                invincible_character = {},
                instant_blueprint = {},
                instant_upgrade = {},
                instant_deconstruction = {}
            },
            inventory = {
                cheat_mode = {},
                keep_last_item = {},
                repair_damaged_item = {},
                instant_request = {},
                instant_trash = {}
            }
        },
        bonuses = {
            character_reach_distance_bonus = {},
            character_build_distance_bonus = {},
            character_resource_reach_distance_bonus = {},
            character_item_drop_distance_bonus = {},
            character_item_pickup_distance_bonus = {},
            character_loot_pickup_distance_bonus = {},
            character_mining_speed_modifier = {},
            character_running_speed_modifier = {},
            character_crafting_speed_modifier = {},
            character_inventory_slots_bonus = {},
            character_health_bonus = {}
        }
    },
    force = {
        toggles = {
            instant_research = {},
            research_all_technologies = {tooltip=true},
            infinity_tools_recipes = {},
            free_resource_recipes = {tooltip=true},
            vanilla_loaders_recipes = {},
            misc_vanilla_recipes = {tooltip=true}
        }
    },
    surface = {
        toggles = {
            freeze_time = {}
        }
    },
    game = {

    }
}

return defs