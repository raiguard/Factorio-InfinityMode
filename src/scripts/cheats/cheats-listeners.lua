-- ----------------------------------------------------------------------------------------------------
-- CHEATS LISTENERS
-- Entry point for the cheat scripting, where all listeners are created and managed

local event = require('__stdlib__/stdlib/event/event')
local on_event = event.register
local gui = require('__stdlib__/stdlib/event/gui')
local string = require('__stdlib__/stdlib/utils/string')
local mod_gui = require('mod-gui')

local cheats = require('cheats')
local cheats_gui = require('cheats-gui')
local defs = require('scripts/util/definitions')
local util = require('scripts/util/util')

-- ----------------------------------------------------------------------------------------------------
-- MOD GUI

event.on_init(function()
    cheats.create()
    for i,p in pairs(game.players) do
        cheats.apply_defaults('player', p)
    end
    for i,f in pairs(game.forces) do
        cheats.apply_defaults('force', f)
    end
    for i,s in pairs(game.surfaces) do
        cheats.apply_defaults('surface', s)
    end
    cheats.apply_defaults('game', game)
end)

on_event(defines.events.on_player_created, function(e)
    local player = util.get_player(e)
    local flow = mod_gui.get_button_flow(player)
    if not flow.im_button then
        flow.add{type='sprite-button', name='im_button', style=mod_gui.button_style, sprite='im-logo'}
        -- flow.add{type='button', name='im_DEBUG', style=mod_gui.button_style, caption='DEBUG'}
    end
    cheats.apply_defaults('player', player)
    util.player_table(player).cheats_gui = {
        cur_player = player,
        cur_force = player.force,
        cur_surface = player.surface,
        cur_tab = 1
    }
end)

gui.on_click('im_button', function(e)
    local player = util.get_player(e)
    local frame_flow = player.gui.screen
    if not frame_flow.im_cheats_window then
        cheats_gui.create(player, frame_flow)
    else
        frame_flow.im_cheats_window.destroy()
    end
end)

-- ----------------------------------------------------------------------------------------------------
-- CHEATS WINDOW

on_event(defines.events.on_gui_selected_tab_changed, function(e)
    if e.element.name == 'im_cheats_tabbed_pane' then
        util.player_table(e.player_index).cheats_gui.cur_tab = e.element.selected_tab_index
    end
end)

on_event(defines.events.on_gui_checked_state_changed, function(e)
    local params = string.split(e.element.name, '-')
    local player = util.get_player(e)
    if params[1] == 'im_cheats' and params[4] == 'checkbox' and cheats.is_valid(params[2], params[3]) then
        local obj = util.player_table(player).cheats_gui['cur_'..params[2]] or game
        cheats.update(obj, {params[2], params[3]}, e.element.state)
        cheats_gui.refresh(player, player.gui.screen)
    end
end)

on_event(defines.events.on_gui_confirmed, function(e)
    local params = string.split(e.element.name, '-')
    local player = util.get_player(e)
    if params[1] == 'im_cheats' and params[4] == 'textfield' and cheats.is_valid(params[2], params[3]) then
        local text = e.element.text
        local prev_text = util.player_table(player).cheats_gui.prev_value
        if text ~= prev_text then
            e.element.text = prev_text
            e.element.style = 'short_number_textfield'
        end
        util.player_table(player).cheats_gui.prev_value = nil
        local obj = util.player_table(player).cheats_gui['cur_'..params[2]] or game
        cheats.update(obj, {params[2], params[3]}, e.element.text)
        cheats_gui.refresh(player, player.gui.screen)
    end
end)

on_event(defines.events.on_gui_text_changed, function(e)
    local params = string.split(e.element.name, '-')
    local player = util.get_player(e)
    local player_table = util.player_table(player)
    if params[1] == 'im_cheats' and params[4] == 'textfield' and cheats.is_valid(params[2], params[3]) then
        local cheat_def = defs.cheats[params[2]][params[3]]
        local text = e.element.text
        if text == '' or (cheat_def.min_value and tonumber(text) < cheat_def.min_value) or (cheat_def.max_value and tonumber(text) > cheat_def.max_value) then
            e.element.style = 'invalid_short_number_textfield'
            if player_table.cheats_gui.prev_value == nil then player_table.cheats_gui.prev_value = 0 end
            return nil
        else
            e.element.style = 'short_number_textfield'
        end
        player_table.cheats_gui.prev_value = text
        local slider = e.element.parent[string.gsub(e.element.name, 'textfield', 'slider')]
        if slider then slider.slider_value = text end
    end
end)

on_event(defines.events.on_gui_value_changed, function(e)
    local params = string.split(e.element.name, '-')
    local player = util.get_player(e)
    local player_table = util.player_table(player)
    if params[1] == 'im_cheats' and params[4] == 'slider' and cheats.is_valid(params[2], params[3]) then
        local textfield = e.element.parent[string.gsub(e.element.name, 'slider', 'textfield')]
        if textfield then
            textfield.text = tostring(e.element.slider_value)
        end
        if player_table.cheats_gui.prev_value ~= e.element.slider_value then
            local obj = player_table.cheats_gui['cur_'..params[2]] or game
            cheats.update(obj, {params[2], params[3]}, e.element.slider_value)
        end
        player_table.cheats_gui.prev_value = e.element.slider_value
    end
end)

on_event(defines.events.on_gui_click, function(e)
    local params = string.split(e.element.name, '-')
    local player = util.get_player(e)
    if params[1] == 'im_cheats' and params[4] == 'button' and cheats.is_valid(params[2], params[3]) then
        local obj = util.player_table(player).cheats_gui['cur_'..params[2]] or game
        cheats.trigger_action(obj, {params[2], params[3]})
    end
end)

on_event(defines.events.on_gui_selection_state_changed, function(e)
    local params = string.split(e.element.name, '-')
    local player = util.get_player(e)
    if params[1] == 'im_cheats' and params[4] == 'dropdown' and cheats.is_valid(params[2], params[3]) then
        local obj = util.player_table(player).cheats_gui['cur_'..params[2]] or game
        cheats.update(obj, {params[2], params[3]}, e.element.selected_index)
        cheats_gui.refresh(player, player.gui.screen)
    end
end)

on_event(defines.events.on_player_toggled_map_editor, function(e)
    local player = util.get_player(e)
    cheats_gui.refresh(player, player.gui.screen)
end)

gui.on_selection_state_changed('im_cheats_player_switcher_dropdown', function(e)
    local player = util.get_player(e)
    util.player_table(player).cheats_gui.cur_player = game.players[e.element.selected_index]
    cheats_gui.refresh(player, player.gui.screen)
end)

gui.on_selection_state_changed('im_cheats_force_listbox', function(e)
    local player = util.get_player(e)
    util.player_table(player).cheats_gui.cur_force = game.forces[e.element.selected_index]
    cheats_gui.refresh(player, player.gui.screen)
end)

gui.on_selection_state_changed('im_cheats_surface_listbox', function(e)
    local player = util.get_player(e)
    util.player_table(player).cheats_gui.cur_surface = game.surfaces[e.element.selected_index]
    cheats_gui.refresh(player, player.gui.screen)
end)

gui.on_click('im_cheats_titlebar_button_close', function(e)
    e.element.parent.parent.destroy()
end)

-- ----------------------------------------------------------------------------------------------------
-- CHEATS

on_event({defines.events.on_player_created, defines.events.on_force_created, defines.events.on_surface_created}, function(e)
    if e.player_index then
        cheats.apply_defaults('player', util.get_player(e))
    elseif e.surface_index then
        cheats.apply_defaults('surface', game.surfaces[e.surface_index])
    elseif e.force then
        cheats.apply_defaults('force', e.force)
    end
end)