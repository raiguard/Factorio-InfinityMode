-- ----------------------------------------------------------------------------------------------------
-- INFINITY CHEATS DEFINITIONS
-- Definitions for infinity cheats. Basically just a bunch of enormous tables!

local abs = math.abs
local conditional_event = require('scripts/util/conditional-event')
local chunk = require('__stdlib__/stdlib/area/chunk')
local event = require('__stdlib__/stdlib/event/event')
local table = require('__stdlib__/stdlib/utils/table')
local util = require('scripts/util/util')

local defs = {}

local vanilla_loaders_recipes = {
    'loader',
    'fast-loader',
    'express-loader'
}

-- cheat data and functions
defs.cheats = {
    player = {
        god_mode = {type='toggle', defaults={on=false, off=false}, in_god_mode=true, in_editor=false, functions={
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
            get_value = function(player, cheat, cheat_global)
                return player.controller_type == defines.controllers.god
            end
        }},
        invincible_character = {type='toggle', defaults={on=true, off=false}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then
                    player.character.destructible = not new_value
                end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and not player.character.destructible or false
            end
        }},
        instant_blueprint = {type='toggle', defaults={on=true, off=false}, in_god_mode=true, in_editor=false, functions={
            setup_global_global = function(player, default)
                return {next_tick_entities={}}
            end,
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_blueprint.on_built_entity')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_blueprint.on_built_entity')
                end
            end,
            get_value = function(player, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        instant_upgrade = {type='toggle', defaults={on=true, off=false}, in_god_mode=true, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_upgrade.on_marked_for_upgrade')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_upgrade.on_marked_for_upgrade')
                end
            end,
            get_value = function(player, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        instant_deconstruction = {type='toggle', defaults={on=true, off=false}, in_god_mode=true, in_editor=false, functions={
            setup_global_global = function(player, default)
                return {next_tick_entities={}}
            end,
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_deconstruction.on_deconstruction')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_deconstruction.on_deconstruction')
                end
            end,
            get_value = function(player, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        cheat_mode = {type='toggle', defaults={on=true, off=false}, in_god_mode=true, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                player.cheat_mode = new_value
            end,
            get_value = function(player, cheat, cheat_global)
                return player.cheat_mode
            end
        }},
        keep_last_item = {type='toggle', defaults={on=true, off=false}, in_god_mode=true, in_editor=true, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.keep_last_item.on_put_item')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.keep_last_item.on_put_item')
                end
            end,
            get_value = function(player, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        repair_used_item = {type='toggle', defaults={on=true, off=false}, in_god_mode=true, in_editor=true, functions={
            setup_global_global = function(player, default)
                return {cur_players={}}
            end,
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.repair_used_item.on_main_inventory_changed')
                    conditional_event.cheat_register(player, cheat, 'cheats.player.repair_used_item.on_cursor_stack_changed')
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.repair_used_item.on_main_inventory_changed')
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.repair_used_item.on_cursor_stack_changed')
                end
            end,
            get_value = function(player, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        instant_request = {type='toggle', defaults={on=true, off=false}, in_god_mode=false, in_editor=false, functions={
            setup_global = function(player, default)
                return {cur_value=default}
            end,
            setup_global_global = function(player, default)
                return {active_players={}}
            end,
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_request.on_main_inventory_changed')
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_request.on_gui_opened')
                    event.dispatch{name=defines.events.on_player_main_inventory_changed, player_index=player.index}
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_request.on_main_inventory_changed')
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_request.on_gui_opened')
                end
            end,
            get_value = function(player, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        instant_trash = {type='toggle', defaults={on=true, off=false}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(player, cheat, 'cheats.player.instant_trash.on_trash_inventory_changed')
                    event.dispatch{name=defines.events.on_player_trash_inventory_changed, player_index=player.index}
                else
                    conditional_event.cheat_deregister(player, cheat, 'cheats.player.instant_trash.on_trash_inventory_changed')
                end
            end,
            get_value = function(player, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        character_reach_distance_bonus = {type='number', defaults={on=1000000, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_reach_distance_bonus = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_reach_distance_bonus
            end
        }},
        character_build_distance_bonus = {type='number', defaults={on=1000000, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_build_distance_bonus = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_build_distance_bonus
            end
        }},
        character_resource_reach_distance_bonus = {type='number', defaults={on=1000000, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_resource_reach_distance_bonus = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_resource_reach_distance_bonus
            end
        }},
        character_item_drop_distance_bonus = {type='number', defaults={on=1000000, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_item_drop_distance_bonus = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_item_drop_distance_bonus
            end
        }},
        character_item_pickup_distance_bonus = {type='number', defaults={on=0, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_item_pickup_distance_bonus = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_item_pickup_distance_bonus
            end
        }},
        character_loot_pickup_distance_bonus = {type='number', defaults={on=0, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_loot_pickup_distance_bonus = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_loot_pickup_distance_bonus
            end
        }},
        character_mining_speed_modifier = {type='number', defaults={on=0, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_mining_speed_modifier = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_mining_speed_modifier
            end
        }},
        character_running_speed_modifier = {type='number', defaults={on=0, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_running_speed_modifier = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_running_speed_modifier
            end
        }},
        character_crafting_speed_modifier = {type='number', defaults={on=0, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_crafting_speed_modifier = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_crafting_speed_modifier
            end
        }},
        character_inventory_slots_bonus = {type='number', defaults={on=0, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_inventory_slots_bonus = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_inventory_slots_bonus
            end
        }},
        character_health_bonus = {type='number', defaults={on=0, off=0}, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, cheat_global, new_value)
                if player.character then player.character_health_bonus = new_value end
            end,
            get_value = function(player, cheat, cheat_global)
                return player.character and player.character_health_bonus
            end
        }},
        clear_inventory = {type='action', in_god_mode=true, in_editor=true, functions={
            action = function(player, cheat, cheat_table)
                player.get_main_inventory().clear()
            end
        }}
    },
    force = {
        instant_research = {type='toggle', defaults={on=true, off=false}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(force, cheat, 'cheats.force.instant_research.on_research_started')
                else
                    conditional_event.cheat_deregister(force, cheat, 'cheats.force.instant_research.on_research_started')
                end
            end,
            get_value = function(force, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        infinity_tools_recipes = {type='toggle', defaults={on=true, off=true}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                for n,r in pairs(game.recipe_prototypes) do
                    if string.find(n, 'im_tool_') and force.recipes[n] then force.recipes[n].enabled = new_value end
                end
            end,
            get_value = function(force, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        free_resource_recipes = {type='toggle', defaults={on=true, off=false}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                for n,r in pairs(game.recipe_prototypes) do
                    if string.find(n, 'im_free_resource_') and force.recipes[n] then force.recipes[n].enabled = new_value end
                end
            end,
            get_value = function(force, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        vanilla_loaders_recipes = {type='toggle', defaults={on=true, off=false}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                for _,n in pairs(vanilla_loaders_recipes) do
                    if force.recipes[n] then force.recipes[n].enabled = new_value end
                end
            end,
            get_value = function(force, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        misc_vanilla_recipes = {type='toggle', defaults={on=true, off=false}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.recipes['player-port'].enabled = new_value
                force.recipes['railgun'].enabled = new_value
                force.recipes['railgun-dart'].enabled = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return cheat_global.cur_value
            end
        }},
        character_reach_distance_bonus = {type='number', defaults={on=0, off=0}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.character_reach_distance_bonus = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.character_reach_distance_bonus
            end
        }},
        character_build_distance_bonus = {type='number', defaults={on=0, off=0}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.character_build_distance_bonus = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.character_build_distance_bonus
            end
        }},
        character_resource_reach_distance_bonus = {type='number', defaults={on=0, off=0}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.character_resource_reach_distance_bonus = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.character_resource_reach_distance_bonus
            end
        }},
        character_item_drop_distance_bonus = {type='number', defaults={on=0, off=0}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.character_item_drop_distance_bonus = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.character_item_drop_distance_bonus
            end
        }},
        character_item_pickup_distance_bonus = {type='number', defaults={on=0, off=0}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.character_item_pickup_distance_bonus = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.character_item_pickup_distance_bonus
            end
        }},
        character_loot_pickup_distance_bonus = {type='number', defaults={on=0, off=0}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.character_loot_pickup_distance_bonus = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.character_loot_pickup_distance_bonus
            end
        }},
        character_running_speed_modifier = {type='number', defaults={on=2, off=0}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.character_running_speed_modifier = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.character_running_speed_modifier
            end
        }},
        character_inventory_slots_bonus = {type='number', defaults={on=0, off=0}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.character_inventory_slots_bonus = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.character_inventory_slots_bonus
            end
        }},
        character_health_bonus = {type='number', defaults={on=0, off=0}, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.character_health_bonus = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.character_health_bonus
            end
        }},
        inserter_stack_size_bonus = {type='number', functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.inserter_stack_size_bonus = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.inserter_stack_size_bonus
            end
        }},
        stack_inserter_capacity_bonus = {type='number', functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.stack_inserter_capacity_bonus = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.stack_inserter_capacity_bonus
            end
        }},
        evolution_factor = {type='number', max_value=1, functions={
            value_changed = function(force, cheat, cheat_global, new_value)
                force.evolution_factor = new_value
            end,
            get_value = function(force, cheat, cheat_global)
                return force.evolution_factor
            end
        }},
        chart_all = {type='action', defaults={on=true}, functions={
            action = function(force, cheat, cheat_global)
                force.chart_all()
            end
        }},
        kill_all_units = {type='action', functions={
            action = function(force, cheat, cheat_global)
                force.kill_all_units()
            end
        }},
        research_all_technologies = {type='action', defaults={on=true}, functions={
            action = function(force, cheat, cheat_global)
                force.research_all_technologies()
            end,
            get_value = function(force, cheat, cheat_global)
                
            end
        }},
        reset_technologies = {type='action', functions={
            action = function(force, cheat, cheat_global)
                force.reset()
            end,
            get_value = function(force, cheat, cheat_global)

            end
        }}
    },
    surface = {
        peaceful_mode = {type='toggle', functions={
            value_changed = function(surface, cheat, cheat_global, new_value)
                surface.peaceful_mode = new_value
            end,
            get_value = function(surface, cheat, cheat_global)
                return surface.peaceful_mode
            end
        }},
        dont_generate_biters = {type='toggle', functions={
            value_changed = function(surface, cheat, cheat_global, new_value)
                if not surface.map_gen_settings.autoplace_controls then return end
                if new_value then
                    local map_gen_settings = table.deepcopy(surface.map_gen_settings)
                    cheat_global.settings_copy = table.deepcopy(map_gen_settings)
                    map_gen_settings.autoplace_controls['enemy-base'].size = 0
                    surface.map_gen_settings = map_gen_settings
                else
                    if cheat_global.settings_copy == nil then return end
                    surface.map_gen_settings = cheat_global.settings_copy
                    cheat_global.settings_copy = nil
                end
            end,
            get_value = function(surface, cheat, cheat_global)
                return cheat_global.cur_value or false
            end
        }},
        freeze_time = {type='toggle', defaults={on=true, off=false}, functions={
            value_changed = function(surface, cheat, cheat_global, new_value)
                surface.freeze_daytime = new_value
            end,
            get_value = function(surface, cheat, cheat_global)
                return surface.freeze_daytime
            end 
        }},
        time_of_day = {type='number', defaults={on=0}, max_value=1, functions={
            value_changed = function(surface, cheat, cheat_global, new_value)
                surface.daytime = new_value
            end,
            get_value = function(surface, cheat, cheat_global)
                return surface.daytime
            end
        }},
        clear_pollution = {type='action', functions={
            action = function(surface, cheat, cheat_global)
                surface.clear_pollution()
            end
        }},
        clear_all_entities = {type='action', functions={
            action = function(surface, cheat, cheat_global)
                for pos in surface.get_chunks() do
                    for _,entity in pairs(surface.find_entities_filtered{area=chunk.to_area(pos), type='character', invert=true}) do
                        entity.destroy()
                    end
                end
            end
        }},
        auto_clear_all_entities = {type='toggle', functions={
            value_changed = function(surface, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(surface, cheat, 'cheats.surface.auto_clear_all_entities.on_chunk_generated')
                else
                    conditional_event.cheat_deregister(surface, cheat, 'cheats.surface.auto_clear_all_entities.on_chunk_generated')
                end
            end,
            get_value = function(surface, cheat, cheat_global)
                return cheat_global.cur_value or false
            end
        }},
        fill_with_lab_tiles = {type='action', functions={
            action = function(surface, cheat, cheat_global)
                surface.destroy_decoratives{}
                for chunk_pos in surface.get_chunks() do
                    local tiles = {}
                    local chunk_area = chunk.to_area(chunk_pos)
                    for y=chunk_area.left_top.y,chunk_area.right_bottom.y-1 do
                        for x=chunk_area.left_top.x,chunk_area.right_bottom.x-1 do
                            table.insert(tiles, {name=((x+y)%2==0 and 'lab-dark-1' or 'lab-dark-2'), position={x,y}})
                        end
                    end
                    surface.set_tiles(tiles, false)
                end
            end
        }},
        auto_fill_with_lab_tiles = {type='toggle', functions={
            value_changed = function(surface, cheat, cheat_global, new_value)
                if new_value then
                    conditional_event.cheat_register(surface, cheat, 'cheats.surface.auto_fill_with_lab_tiles.on_chunk_generated')
                else
                    conditional_event.cheat_deregister(surface, cheat, 'cheats.surface.auto_fill_with_lab_tiles.on_chunk_generated')
                end
            end,
            get_value = function(surface, cheat, cheat_global)
                return cheat_global.cur_value or false
            end
        }},
    },
    game = {
        pollution = {type='toggle', functions={
            value_changed = function(game, cheat, cheat_global, new_value)
                game.map_settings.pollution.enabled = new_value
            end,
            get_value = function(game, cheat, cheat_global)
                return game.map_settings.pollution.enabled
            end
        }},
        evolution = {type='toggle', functions={
            value_changed = function(game, cheat, cheat_global, new_value)
                game.map_settings.enemy_evolution.enabled = new_value
            end,
            get_value = function(game, cheat, cheat_global)
                return game.map_settings.enemy_evolution.enabled
            end
        }},
        biter_expansion = {type='toggle', functions={
            value_changed = function(game, cheat, cheat_global, new_value)
                game.map_settings.enemy_expansion.enabled = new_value
            end,
            get_value = function(game, cheat, cheat_global)
                return game.map_settings.enemy_expansion.enabled
            end
        }},
        research_queue = {type='list', items={'always','after-victory','never'}, functions={
            value_changed = function(game, cheat, cheat_global, selected_index)
                game.difficulty_settings.research_queue_setting = cheat.items[selected_index]
            end,
            get_value = function(game, cheat, cheat_global)
                return table.invert(cheat.items)[game.difficulty_settings.research_queue_setting]
            end
        }},
        recipe_difficulty = {type='list', items={'normal','expensive'}, functions={
            value_changed = function(game, cheat, cheat_global, selected_index)
                game.difficulty_settings.recipe_difficulty = defines.difficulty_settings.recipe_difficulty[cheat.items[selected_index]]
            end,
            get_value = function(game, cheat, cheat_global)
                return table.invert(cheat.items)[table.invert(defines.difficulty_settings.recipe_difficulty)[game.difficulty_settings.recipe_difficulty]]
            end
        }},
        game_speed = {type='number', min_value=0.01, max_value=1000, functions={
            value_changed = function(game, cheat, cheat_global, new_value)
                game.speed = new_value
            end,
            get_value = function(game, cheat, cheat_global)
                return game.speed
            end
        }}
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
                keep_last_item = {tooltip=true},
                repair_used_item = {tooltip=true},
                instant_request = {tooltip=true},
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
        },
        actions = {
            clear_inventory = {}
        }
    },
    force = {
        toggles = {
            instant_research = {},
            infinity_tools_recipes = {},
            free_resource_recipes = {tooltip=true},
            vanilla_loaders_recipes = {},
            misc_vanilla_recipes = {tooltip=true}
        },
        bonuses = {
            character_reach_distance_bonus = {},
            character_build_distance_bonus = {},
            character_resource_reach_distance_bonus = {},
            character_item_drop_distance_bonus = {},
            character_item_pickup_distance_bonus = {},
            character_loot_pickup_distance_bonus = {},
            character_running_speed_modifier = {},
            character_inventory_slots_bonus = {},
            character_health_bonus = {},
            inserter_stack_size_bonus = {},
            stack_inserter_capacity_bonus = {},
            evolution_factor = {textfield={allow_decimal=true}}
        },
        actions = {
            chart_all = {tooltip=true},
            kill_all_units = {tooltip=true}
        }
    },
    surface = {
        toggles = {
            peaceful_mode = {},
            dont_generate_biters = {tooltip=true},
            clear_pollution = {tooltip=true}
        },
        time = {
            freeze_time = {},
            time_of_day = {
                slider = {min_value=0, max_value=1, value_step=0.1},
                textfield = {allow_decimal=true, width=42}
            }
        },
        clear_entities = {
            auto_clear_all_entities = {tooltip=true},
            clear_all_entities = {tooltip=true}
        },
        fill = {
            auto_fill_with_lab_tiles = {tooltip=true},
            fill_with_lab_tiles = {tooltip=true}
        }
    },
    game = {
        toggles = {
            pollution = {},
            evolution = {},
            biter_expansion = {},
            -- research_queue = {tooltip=true},
            -- recipe_difficulty = {},
            game_speed = {
                slider = {min_value=1, max_value=10, value_step=1},
                textfield = {allow_decimal=true, width=50}
            }
        }
    }
}

return defs