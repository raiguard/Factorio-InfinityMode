-- ----------------------------------------------------------------------------------------------------
-- INFINITY SELECTOR CONTROL SCRIPTING

local area = require('__stdlib__/stdlib/area/area')
local conditional_event = require('scripts/util/conditional-event')
local event = require('__stdlib__/stdlib/event/event')
local direction = require('__stdlib__/stdlib/area/direction')
local gui = require('__stdlib__/stdlib/event/gui')
local position = require('__stdlib__/stdlib/area/position')
local table = require('__stdlib__/stdlib/utils/table')
local tile = require('__stdlib__/stdlib/area/tile')
local on_event = event.register
local util = require('scripts/util/util')
local version = require('__stdlib__/stdlib/vendor/version')

-- local selector_gui = require('scripts/selector-gui')

-- ----------------------------------------------------------------------------------------------------
-- UTILITIES

local initial_data = {
    mode = 1, -- 1 = creator, 2 = healer, 3 = modifier
    settings = {
        { -- creator
            tile_1 = false, -- set these to false so they can be created later
            tile_2 = false
        },
        {},
        {
            
        }
    }
}

-- ----------------------------------------------------------------------------------------------------
-- GUI

local selector_gui = {}

function selector_gui.create(player)

end

-- ----------------------------------------------------------------------------------------------------
-- LISTENERS

event.on_init(function()
    for _,p in pairs(game.players) do
        util.player_table(p).selector = initial_data
    end
end)

on_event(defines.events.on_player_created, function(e)
    util.player_table(e.player_index).selector = initial_data
end)

event.on_configuration_changed(function(e)
    if e.mod_changes['InfinityMode'] and e.mod_changes['InfinityMode'].old_version then
        local t = e.mod_changes['InfinityMode']
        local v = version('0.6.0')
        if version(t.old_version) < v then
            for _,p in pairs(game.players) do
                util.player_table(p).selector = initial_data
            end
        end
    end
end)

-- when a player's cursor stack changes
on_event(defines.events.on_player_cursor_stack_changed, function(e)
    if not global.mod_enabled then return end
    local player = util.get_player(e)
    local player_table = util.player_table(player)
    local cursor_stack = player.cursor_stack
    if cursor_stack and cursor_stack.valid_for_read and cursor_stack.name == 'infinity-selector' then
        if player_table.selector.window then return end
        selector_gui.create(player)
    elseif player_table.selector.window then
        player_table.selector.window.destroy()
    end
end)

-- when a player selects an area
on_event({defines.events.on_player_selected_area, defines.events.on_player_alt_selected_area}, function(e)
    if not global.mod_enabled then return end
    if e.item ~= 'infinity-selector' then return end
    local surface = util.get_player(e).surface
    for _,tile in pairs(e.tiles) do
        surface.create_trivial_smoke{name='infinity-selector-smoke', position=tile.position}
    end
    for _,entity in pairs(e.entities) do
        surface.create_trivial_smoke{name='infinity-selector-smoke', position=entity.position}
    end
end)