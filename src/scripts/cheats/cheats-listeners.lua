-- ----------------------------------------------------------------------------------------------------
-- CHEATS LISTENERS
-- Entry point for the cheat scripting, where all listeners are created and managed

local on_event = require('__stdlib__/stdlib/event/event').register
local gui = require('__stdlib__/stdlib/event/gui')
local string = require('__stdlib__/stdlib/utils/string')
local util = require('scripts/util/util')
local mod_gui = require('mod-gui')

local cheats = require('cheats')
local cheats_gui = require('cheats-gui')

-- ----------------------------------------------------------------------------------------------------
-- MOD GUI

on_event(defines.events.on_player_joined_game, function(e)
    local player = util.get_player(e)
    local flow = mod_gui.get_button_flow(player)
    if not flow.im_button then
        flow.add{type='sprite-button', name='im_button', style=mod_gui.button_style, sprite='im-logo'}
    end
    local cheats_table = util.player_table(player).cheats
    if not cheats_table then cheats.create(player) end
end)

gui.on_click('im_button', function(e)
    local player = util.get_player(e)
    -- local frame_flow = mod_gui.get_frame_flow(player)
    -- if not frame_flow.im_cheats_window then
    --     cheats_gui.create(player, frame_flow)
    -- else
    --     frame_flow.im_cheats_window.destroy()
    -- end
    local center_gui = util.get_center_gui(player)
    if center_gui and center_gui.element.name ~= 'im_cheats_window' then
        util.close_center_gui(player)
        util.set_center_gui(player, cheats_gui.create(player, player.gui.center))
    elseif center_gui and center_gui.element.name == 'im_cheats_window' then
        util.close_center_gui(player)
    elseif not center_gui then
        util.set_center_gui(player, cheats_gui.create(player, player.gui.center))
    end
end)

-- ----------------------------------------------------------------------------------------------------
-- CHEATS WINDOW

on_event(defines.events.on_gui_checked_state_changed, function(e)
    local params = string.split(e.element.name, '-')
    if params[1] == 'im_cheats' and params[4] == 'checkbox' and cheats.is_valid(params[2], params[3]) then
        cheats.update(util.get_player(e), {params[2], params[3]}, e.element.state)
    end
end)

on_event(defines.events.on_gui_confirmed, function(e)
    local params = string.split(e.element.name, '-')
    if params[1] == 'im_cheats' and params[4] == 'textfield' and cheats.is_valid(params[2], params[3]) then
        cheats.update(util.get_player(e), {params[2], params[3]}, tonumber(e.element.text))
    end
end)