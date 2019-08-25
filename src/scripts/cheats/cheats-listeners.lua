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
-- SETUP

local function player_setup(e)
    local player = util.get_player(e)
    local flow = mod_gui.get_button_flow(player)
    if not flow.im_button then
        flow.add{type='sprite-button', name='im_button', style=mod_gui.button_style, sprite='im-logo'}
    end
    cheats.apply_defaults('player', player)
    util.player_table(player).cheats_gui = {
        cur_player = player,
        cur_force = player.force,
        cur_surface = player.surface,
        cur_tab = 1,
        docked = true
    }
end

local function enable_infinity_mode(default_ref)
    cheats.create(default_ref)
    for i,p in pairs(game.players) do
        player_setup{player_index=i}
    end
    for i,f in pairs(game.forces) do
        cheats.apply_defaults('force', f)
    end
    for i,s in pairs(game.surfaces) do
        cheats.apply_defaults('surface', s)
    end
    cheats.apply_defaults('game', game)
    global.mod_enabled = true
    game.print{'chat-message.mod-enabled-message'}
end

local function process_enable_command(e)
    if util.get_player(e).admin then
        enable_infinity_mode(e.parameter or 'on')
    end
end

local function show_dialog()
    -- check if the prompt was already shown
    if game.ticks_played > 0 and #game.connected_players > 0 and global.prompt_shown == false then
        global.prompt_shown = true
        event.remove(defines.events.on_tick, show_dialog)
        -- skip prompt if set to do so
        local dialog_behavior = settings.global['im-new-map-behavior'].value
        if dialog_behavior == 'Ask' then
            cheats_gui.create_initial_dialog(game.connected_players[1])
        else
            if dialog_behavior ~= 'No' then
                global.mod_enabled = true
                enable_infinity_mode(dialog_behavior:gsub('Yes, cheats ', ''))
            end
        end
    elseif game.ticks_played > 0 and #game.connected_players > 0 then
        event.remove(defines.events.on_tick, show_dialog)
    end
end

event.on_init(function()
    global.mod_enabled = false
    global.prompt_shown = false
    event.register(defines.events.on_tick, show_dialog)
end)

event.on_load(function()
    event.register(defines.events.on_tick, show_dialog)
end)

gui.on_click('im_enable_button_yes_', function(e)
    enable_infinity_mode(e.element.name:gsub(e.match, ''))
    e.element.parent.parent.destroy()
end)

gui.on_click('im_enable_button_no', function(e)
    e.element.parent.parent.destroy()
end)

commands.add_command('enable-infinity-mode', {'chat-message.enable-command-help'}, process_enable_command)

-- ----------------------------------------------------------------------------------------------------
-- MOD GUI

local function toggle_cheats_gui(e)
    local player = util.get_player(e)
    local parent = util.player_table(player).cheats_gui.docked and mod_gui.get_frame_flow(player) or player.gui.screen
    log(parent.name)
    if not parent.im_cheats_window then
        cheats_gui.create(player, parent)
    else
        parent.im_cheats_window.destroy()
    end
end

gui.on_click('im_button', function(e)
    toggle_cheats_gui(e)
end)

on_event('im-toggle-cheats-gui', function(e)
    toggle_cheats_gui(e)
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
        if params[3] == 'god_mode' then
            cheats_gui.refresh(player, player.gui.screen)
        end
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
        -- cheats_gui.refresh(player, player.gui.screen)
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
            if player_table.cheats_gui.prev_value == nil then
                local index = params[2] == 'game' and 1 or player_table.cheats_gui['cur_'..params[2]].index
                player_table.cheats_gui.prev_value = util.cheat_table(params[2], params[3], index).cur_value
            end
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
        -- cheats_gui.refresh(player, player.gui.screen)
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

gui.on_click('im_cheats_titlebar_button_pin', function(e)
    local player = util.get_player(e)
    local player_table = util.player_table(player)
    if e.element.style.name == 'close_button' then
        e.element.style = 'close_button_active'
        player_table.cheats_gui.docked = true
        player_table.cheats_gui.location = nil
    else
        e.element.style = 'close_button'
        player_table.cheats_gui.docked = false
    end
    e.element.parent.parent.destroy()
    toggle_cheats_gui{player_index=player.index}
end)

on_event(defines.events.on_gui_location_changed, function(e)
    if e.element.name ~= 'im_cheats_window' then return end
    util.player_table(e.player_index).cheats_gui.location = e.element.location
end)

on_event(defines.events.on_player_display_scale_changed, function(e)
    if not global.mod_enabled then return end
    local player = util.get_player(e)
    local player_table = util.player_table(player)
    if not player_table.cheats_gui.location and player_table.cheats_gui.window then
        player_table.cheats_gui.window.location = {0,(44*player.display_scale)}
    end
end)

-- ----------------------------------------------------------------------------------------------------
-- CHEATS

on_event({defines.events.on_player_created, defines.events.on_force_created, defines.events.on_surface_created}, function(e)
    if global.mod_enabled then
        if e.player_index then
            player_setup(e)
        elseif e.surface_index then
            cheats.apply_defaults('surface', game.surfaces[e.surface_index])
        elseif e.force then
            cheats.apply_defaults('force', e.force)
        end
    end
end)

event.on_configuration_changed(function(e)
    if global.mod_enabled then
        for i,f in pairs(game.forces) do
            -- update infinity tool recipes to account for any that might have been added
            if util.cheat_enabled('force', 'infinity_tools_recipes', f.index) then
                cheats.update(f, {'force','infinity_tools_recipes'}, true)
            end
        end
        cheats.migrate()
        -- refresh all open player cheat GUIs
        for _,p in pairs(game.players) do
            cheats_gui.refresh(p, p.gui.screen)
        end
    end
end)