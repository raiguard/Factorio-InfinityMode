-- ----------------------------------------------------------------------------------------------------
-- INFINITY CHEATS DEFINITIONS
-- Definitions for infinity cheats. Basically just a bunch of enormous tables!

local defs = {}

-- cheat data and functions
defs.cheats = {
    personal = {
        god_mode = {type='toggle', default=false, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)

            end,
            get_value = function(player)
                
            end
        }},
        invincible_player = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)

            end,
            get_value = function(player)

            end
        }},
        instant_blueprint = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)

            end,
            get_value = function(player)

            end
        }},
        instant_upgrade = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)

            end,
            get_value = function(player)

            end
        }},
        instant_deconstruction = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)

            end,
            get_value = function(player)

            end
        }},
        cheat_mode = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                player.cheat_mode = new_value
            end,
            get_value = function(player)
                return player.cheat_mode
            end
        }},
        keep_last_item = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)

            end,
            get_value = function(player)

            end
        }},
        repair_mined_item = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)

            end,
            get_value = function(player)

            end
        }},
        instant_request = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)

            end,
            get_value = function(player)

            end
        }},
        instant_trash = {type='toggle', default=true, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)

            end,
            get_value = function(player)

            end
        }},
        character_reach_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_reach_distance_bonus = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_reach_distance_bonus or 0
            end
        }},
        character_build_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_build_distance_bonus = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_build_distance_bonus or 0
            end
        }},
        character_resource_reach_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_resource_reach_distance_bonus = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_resource_reach_distance_bonus or 0
            end
        }},
        character_item_drop_distance_bonus = {type='number', default=1000000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_item_drop_distance_bonus = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_item_drop_distance_bonus or 0
            end
        }},
        character_item_pickup_distance_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_item_pickup_distance_bonus = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_item_pickup_distance_bonus or 0
            end
        }},
        character_loot_pickup_distance_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_loot_pickup_distance_bonus = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_loot_pickup_distance_bonus or 0
            end
        }},
        character_mining_speed_modifier = {type='number', default=1000, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_mining_speed_modifier = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_mining_speed_modifier or 0
            end
        }},
        character_running_speed_modifier = {type='number', default=2, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_running_speed_modifier = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_running_speed_modifier or 0
            end
        }},
        character_crafting_speed_modifier = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_crafting_speed_modifier = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_crafting_speed_modifier or 0
            end
        }},
        character_inventory_slots_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_inventory_slots_bonus = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_inventory_slots_bonus or 0
            end
        }},
        character_health_bonus = {type='number', default=0, in_god_mode=false, in_editor=false, functions={
            value_changed = function(player, cheat, new_value)
                if player.character then player.character_health_bonus = new_value end
            end,
            get_value = function(player)
                return player.character and player.character_health_bonus or 0
            end
        }}
    }
}

-- cheats GUI parameters
defs.gui_elems = {
    personal = {
        {category='toggles', table_columns=2, groups={
            {group='interaction', caption={'personal-cheats-gui.group-interaction-caption'}, tooltip={'personal-cheats-gui.group-interaction-tooltip'}, settings={
                {name='god_mode', type='toggle', caption={'personal-cheats-gui.setting-god-mode-caption'}, tooltip={'personal-cheats-gui.setting-god-mode-tooltip'}}
            }}
        }}
    }
}

return defs