-- INFINITY CHEATS GUI MANAGEMENT
-- Manages all of the GUI elements for the cheats interface

local string = require('__stdlib__/stdlib/utils/string')
local table = require('__stdlib__/stdlib/utils/table')

-- GUI ELEMENTS
-- local tabbed_pane = require('scripts/util/gui-elems/tabbed-pane')
local titlebar = require('scripts/util/gui-elems/titlebar')

local defs = require('cheats-definitions')
local util = require('scripts/util/util')

local cheats_gui = {}

-- only create elements here, do not set their proper values yet
local function create_cheat_ui(parent, obj, cheat, elem_table, add_to_table)
    local function create_elems(parent, obj, cheat, elem_table)
        local cheat_def = defs.cheats[cheat[1]][cheat[2]]
        local cheat_table = util.cheat_table(cheat[1], cheat[2], obj)
        local cheat_name = cheat[1]..'-'..cheat[2]
        local locale_name = cheat[1]..'.setting-'..cheat[2]
        if cheat_def.type == 'toggle' then
            local setting_flow = parent.add{type='flow', name='im_cheats-'..cheat_name..'-flow', direction='horizontal'}
            local checkbox = setting_flow.add{type='checkbox', name='im_cheats-'..cheat_name..'-checkbox', state=false,
                caption={'', {'gui-cheats-'..locale_name..'-caption'}, elem_table.tooltip and ' [img=info]' or nil},
                tooltip=elem_table.tooltip and {'gui-cheats-'..locale_name..'-tooltip'} or nil}
                if defs.cheats_gui_elems[cheat[1]].has_defaults and cheat_def.defaults == nil then
                    setting_flow.add{type='label', name='im_cheats-'..cheat_name..'-no_defaults_icon', caption='[img=restart_required]', tooltip={'gui-cheats.no-defaults-tooltip'}}
                end
            return {checkbox}
        elseif cheat_def.type == 'number' then
            local setting_flow = parent.add{type='flow', name='im_cheats-'..cheat_name..'-flow', direction='horizontal'}
            setting_flow.style.vertical_align = 'center'
            setting_flow.add{type='label', name='im_cheats-'..cheat_name..'-label',
                caption={'', {'gui-cheats-'..locale_name..'-caption'}, elem_table.tooltip and ' [img=info]' or nil},
                tooltip=elem_table.tooltip and {'gui-cheats-'..locale_name..'-tooltip'} or nil}
            if defs.cheats_gui_elems[cheat[1]].has_defaults and cheat_def.defaults == nil then
                setting_flow.add{type='label', name='im_cheats-'..cheat_name..'-no_defaults_icon', caption='[img=restart_required]', tooltip={'gui-cheats.no-defaults-tooltip'}}
            end
            setting_flow.add{type='empty-widget', name='im_cheats-'..cheat_name..'-filler', style='invisible_horizontal_filler'}
            local slider
            if elem_table.slider then
                slider = setting_flow.add{type='slider', name='im_cheats-'..cheat_name..'-slider', style=elem_table.slider.value_step and 'notched_slider' or nil,
                    minimum_value=elem_table.slider.min_value or cheat_def.min_value or 1,
                    maximum_value=elem_table.slider.max_value or cheat_def.max_value or 10,
                    value_step=elem_table.slider.value_step or nil, discrete_slider=elem_table.slider.value_step and true or nil,
                    discrete_values=elem_table.slider.value_step and true or nil}
                slider.style.right_margin = 5
            end
            local textfield = setting_flow.add{type='textfield', name='im_cheats-'..cheat_name..'-textfield', style='short_number_textfield',
                text='---', numeric=true, lose_focus_on_confirm=true,
                allow_decimal=elem_table.textfield and elem_table.textfield.allow_decimal or false}
            if elem_table.textfield and elem_table.textfield.width then
                textfield.style.width = elem_table.textfield.width
            end
            if elem_table.slider then
                textfield.style.horizontal_align = 'center'
            end
            return {slider, textfield}
        elseif cheat_def.type == 'action' then
            local button = parent.add{type='button', name='im_cheats-'..cheat_name..'-button', style='stretchable_button',
                caption={'', {'gui-cheats-'..locale_name..'-caption'}, elem_table.tooltip and ' [img=im-info-black-inline]' or nil},
                tooltip=elem_table.tooltip and {'gui-cheats-'..locale_name..'-tooltip'} or nil}
            return {button}
        elseif cheat_def.type == 'list' then
            local setting_flow = parent.add{type='flow', name='im_cheats-'..cheat_name..'-flow', direction='horizontal'}
            setting_flow.style.vertical_align = 'center'
            setting_flow.add{type='label', name='im_cheats-'..cheat_name..'-label',
                caption={'', {'gui-cheats-'..locale_name..'-caption'}, elem_table.tooltip and ' [img=info]' or nil},
                tooltip=elem_table.tooltip and {'gui-cheats-'..locale_name..'-tooltip'} or nil}
            if defs.cheats_gui_elems[cheat[1]].has_defaults and cheat_def.defaults == nil then
                setting_flow.add{type='label', name='im_cheats-'..cheat_name..'-no_defaults_icon', caption='[img=restart_required]', tooltip={'gui-cheats.no-defaults-tooltip'}}
            end
            setting_flow.add{type='empty-widget', name='im_cheats-'..cheat_name..'-filler', style='invisible_horizontal_filler'}
            local dropdown = setting_flow.add{type='drop-down', name='im_cheats-'..cheat_name..'-dropdown'}
            for i,n in pairs(cheat_def.items) do
                dropdown.add_item({'gui-cheats-'..locale_name..'-item-'..i..'-caption'})
            end
            return {dropdown}
        end
    end
    for _,elem in pairs(create_elems(parent, obj, cheat, elem_table)) do
        table.insert(add_to_table, elem)
    end
end

local function add_defaults_gui(pane, category)
    pane.add{type='line', name='im_cheats_'..category..'_defaults_line', direction=horizontal}.style.top_margin = 2
    local buttons_flow = pane.add{type='flow', name='im_cheats_'..category..'_defaults_flow', direction='horizontal'}
    buttons_flow.add{type='button', name='im_cheats-'..category..'-defaults_button-on', caption='Enable all'}.style.horizontally_stretchable = true
    buttons_flow.add{type='button', name='im_cheats-'..category..'-defaults_button-off', caption='Disable all'}.style.horizontally_stretchable = true
end

local function create_tabbed_pane(player, player_table, window_frame)
    local elems_def = defs.cheats_gui_elems
    player_table.cheats_gui.cheat_elems = {}
    local elems_list = player_table.cheats_gui.cheat_elems
    local content_frame = window_frame.add{type='frame', name='im_cheats_content_frame', style='inside_deep_frame_for_tabs', direction='vertical'}
    local tabbed_pane = content_frame.add{type='tabbed-pane', name='im_cheats_tabbed_pane'}
    for category,cheats in pairs(elems_def) do
        local tab = tabbed_pane.add{type='tab', name='im_cheats_'..category..'_tab', caption={'gui-cheats.tab-'..category..'-caption'}}
        local pane = tabbed_pane.add{type='scroll-pane', name='im_cheats_'..category..'_pane', style='tab_scroll_pane', direction='vertical', horizontal_scroll_policy='never', vertical_scroll_policy='always'}
        pane.style.height = 500
        pane.style.padding = 5
        tabbed_pane.add_tab(tab,pane)
    end
    tabbed_pane.selected_tab_index = player_table.cheats_gui.cur_tab
    local tabs = tabbed_pane.tabs
    local pane
    
    -- PLAYER
    elems_list.player = {}
    pane = tabs[1].content
    local cur_player = player_table.cheats_gui.cur_player
    local player_is_god = cur_player.controller_type == defines.controllers.god
    local player_is_editor = cur_player.controller_type == defines.controllers.editor
    -- player switcher
    if game.is_multiplayer() and player.admin then
        local switcher_flow = pane.add{type='flow', name='im_cheats_player_switcher_flow', style='vertically_centered_flow', direction='horizontal'}
        switcher_flow.style.horizontally_stretchable = true
        switcher_flow.add{type='label', name='im_cheats_player_switcher_label', style='caption_label', caption={'gui-cheats-player.switcher-label-caption'}}
        switcher_flow.add{type='empty-widget', name='im_cheats_player_switcher_filler', style='invisible_horizontal_filler'}
        local players = {}
        for i,player in pairs(game.players) do
            players[i] = player.name
        end
        switcher_flow.add{type='drop-down', name='im_cheats-player-switcher_dropdown', items=players, selected_index=player_table.cheats_gui.cur_player.index}
        switcher_flow.style.bottom_margin = 4
        pane.add{type='line', name='im_cheats_player_switcher_line', direction='horizontal'}.style.horizontally_stretchable = true
    end
    -- toggles
    local toggles_flow_table = pane.add{type='table', name='im_cheats_player_toggles_table', column_count=2, vertical_centering=false}
    toggles_flow_table.style.horizontally_stretchable = true
    for group,cheats in pairs(elems_def.player.toggles) do
        local flow = toggles_flow_table.add{type='flow', name='im_cheats_player_toggles_'..group..'_flow', direction='vertical'}
        flow.style.horizontally_stretchable = true
        flow.add{type='label', name='im_cheats_player_toggles_'..group..'_label', style='caption_label', caption={'gui-cheats-player.group-'..group..'-caption'}}
        for n,t in pairs(cheats) do
            create_cheat_ui(flow, cur_player, {'player',n}, t, elems_list.player)
        end
    end
    -- bonuses
    pane.add{type='label', name='im_cheats_player_bonuses_label', style='caption_label', caption={'gui-cheats-player.group-bonuses-caption'}}.style.top_margin = 2
    for n,t in pairs(elems_def.player.bonuses) do
        create_cheat_ui(pane, cur_player, {'player',n}, t, elems_list.player)
    end
    -- actions
    local player_actions_label = pane.add{type='label', name='im_cheats_player_actions_label', style='caption_label', caption={'gui-cheats-player.group-actions-caption'}}
    player_actions_label.style.top_margin = 3
    player_actions_label.style.bottom_margin = 6
    local action_flow = pane.add{type='flow', name='im_cheats_player_actions_flow', direction='horizontal'}
    for n,t in pairs(elems_def.player.actions) do
        create_cheat_ui(pane, cur_player, {'player',n}, t, elems_list.player)
    end
    add_defaults_gui(pane, 'player')
    
    -- FORCE
    elems_list.force = {}
    pane = tabs[2].content    
    local cur_force = player_table.cheats_gui.cur_force
    -- force switcher
    local switcher_flow = pane.add{type='flow', name='im_cheats_force_switcher_flow', style='vertically_centered_flow', direction='horizontal'}
    switcher_flow.style.horizontally_stretchable = true
    switcher_flow.add{type='label', name='im_cheats_force_switcher_label', style='caption_label', caption={'gui-cheats-force.switcher-label-caption'}}
    switcher_flow.add{type='empty-widget', name='im_cheats_force_switcher_filler', style='invisible_horizontal_filler'}
    local forces = {}
    for i,force in pairs(game.forces) do
        forces[i] = force.name
    end
    switcher_flow.add{type='drop-down', name='im_cheats-force-switcher_dropdown', items=forces, selected_index=player_table.cheats_gui.cur_force.index}
    switcher_flow.style.bottom_margin = 4
    pane.add{type='line', name='im_cheats_force_switcher_line', direction='horizontal'}.style.horizontally_stretchable = true
    -- toggles
    for n,t in pairs(elems_def.force.toggles) do
        create_cheat_ui(pane, cur_force, {'force',n}, t, elems_list.force)
    end
    -- bonuses
    pane.add{type='label', name='im_cheats_force_bonuses_label', style='caption_label', caption={'gui-cheats-force.group-bonuses-caption'}}.style.top_margin = 2
    for n,t in pairs(elems_def.force.bonuses) do
        create_cheat_ui(pane, cur_force, {'force',n}, t, elems_list.force)
    end
    -- actions
    local force_actions_label = pane.add{type='label', name='im_cheats_force_actions_label', style='caption_label', caption={'gui-cheats-force.group-actions-caption'}}
    force_actions_label.style.top_margin = 3
    force_actions_label.style.bottom_margin = 6
    local action_flow = pane.add{type='flow', name='im_cheats_force_actions_flow', direction='horizontal'}
    for n,t in pairs(elems_def.force.actions) do
        create_cheat_ui(action_flow, cur_force, {'force',n}, t, elems_list.force)
    end
    -- current research
    local research_action_flow = pane.add{type='flow', name='im_cheats_force_research_actions_flow', direction='horizontal'}
    for n,t in pairs(elems_def.force.research_actions) do
        create_cheat_ui(research_action_flow, cur_force, {'force',n}, t, elems_list.force)
    end
    -- technologies
    local technology_flow = pane.add{type='flow', name='im_cheats_force_technology_flow', direction='horizontal'}
    technology_flow.add{type='button', name='im_cheats-force-research_all_technologies-button', caption={'gui-cheats-force.setting-research_all_technologies-caption'}}.style.horizontally_stretchable = true
    local reset_button = technology_flow.add{type='sprite-button', name='im_cheats-force-reset_technologies-button', style='red_button', sprite='utility/reset'}
    reset_button.style.width = 28
    reset_button.style.left_padding = 2
    reset_button.style.right_padding = 2
    add_defaults_gui(pane, 'force')

    -- SURFACE
    elems_list.surface = {}
    pane = tabs[3].content
    local cur_surface = player_table.cheats_gui.cur_surface
    -- surface selector
    local switcher_flow = pane.add{type='flow', name='im_cheats_surface_switcher_flow', style='vertically_centered_flow', direction='horizontal'}
    switcher_flow.style.horizontally_stretchable = true
    switcher_flow.add{type='label', name='im_cheats_surface_switcher_label', style='caption_label', caption={'gui-cheats-surface.switcher-label-caption'}}
    switcher_flow.add{type='empty-widget', name='im_cheats_surface_switcher_filler', style='invisible_horizontal_filler'}
    local surfaces = {}
    for i,surface in pairs(game.surfaces) do
        surfaces[i] = surface.name
    end
    switcher_flow.add{type='drop-down', name='im_cheats-surface-switcher_dropdown', items=surfaces, selected_index=player_table.cheats_gui.cur_surface.index}
    switcher_flow.style.bottom_margin = 4
    pane.add{type='line', name='im_cheats_surface_switcher_line', direction='horizontal'}.style.horizontally_stretchable = true
    -- toggles
    local toggles_flow = pane.add{type='flow', name='im_cheats_surface_toggles_flow', direction='vertical'}
    toggles_flow.style.horizontally_stretchable = true
    for n,t in pairs(elems_def.surface.toggles) do
        create_cheat_ui(toggles_flow, cur_surface, {'surface',n}, t, elems_list.surface)
    end
    pane.add{type='line', name='im_cheats_surface_toggles_line', direction='horizontal'}.style.top_margin = 4
    -- time
    local time_flow = pane.add{type='flow', name='im_cheats_surface_time_flow', direction='vertical'}
    for n,t in pairs(elems_def.surface.time) do
        create_cheat_ui(time_flow, cur_surface, {'surface',n}, t, elems_list.surface)
    end
    pane.add{type='line', name='im_cheats_surface_time_line', direction='horizontal'}.style.top_margin = 4
    -- clear
    local clear_flow = pane.add{type='flow', name='im_cheats_surface_clear_flow', direction='vertical'}
    for n,t in pairs(elems_def.surface.clear_entities) do
        create_cheat_ui(clear_flow, cur_surface, {'surface',n}, t, elems_list.surface)
    end
    pane.add{type='line', name='im_cheats_surface_clear_line', direction='horizontal'}.style.top_margin = 4
    -- fill
    local fill_flow = pane.add{type='flow', name='im_cheats_surface_fill_flow', direction='vertical'}
    for n,t in pairs(elems_def.surface.fill) do
        create_cheat_ui(fill_flow, cur_surface, {'surface',n}, t, elems_list.surface)
    end

    -- GAME
    elems_list.game = {}
    pane = tabs[4].content
    local toggles_flow = pane.add{type='flow', name='im_cheats_game_toggle_flow', direction='vertical'}
    for n,t in pairs(elems_def.game.toggles) do
        create_cheat_ui(toggles_flow, game, {'game',n}, t, elems_list.game)
    end
end

function cheats_gui.create(player, parent)
    local player_table = util.player_table(player)
    local window_frame = parent.add{type='frame', name='im_cheats_window', style='dialog_frame', direction='vertical'}
    -- if parent.name == 'mod_gui_frame_flow' then window_frame.style = mod_gui.frame_style end
    -- window_frame.style.height=530
    window_frame.location = player_table.cheats_gui.location
    -- window_frame.location = {1998,363}
    local titlebar = titlebar.create(window_frame, 'im_cheats_titlebar', {
        label = {'gui-cheats.window-caption'},
        draggable = parent.name == 'screen' and true or false,
        buttons = {
            {
                name = 'pin',
                tooltip = {'gui-cheats.pin-button-tooltip'},
                sprite = 'im_pin',
                hovered_sprite = 'im_pin_black',
                clicked_sprite = 'im_pin_black'
            },
            {
                name = 'close',
                sprite = 'utility/close_white',
                hovered_sprite = 'utility/close_black',
                clicked_sprite = 'utility/close_black'
            }
        }
    })
    if parent.name == 'mod_gui_frame_flow' then titlebar.children[3].style = 'close_button_active' end
    create_tabbed_pane(player, player_table, window_frame)
    cheats_gui.update(player)
    player_table.cheats_gui.window = window_frame
end

-- destroys the cheat GUI
function cheats_gui.destroy(player)
    local player_table = util.player_table(player)
    player_table.cheats_gui.window.destroy()
    player_table.cheats_gui.window = nil
end

-- update the values/states of cheat GUIs
function cheats_gui.update(player, category)
    local player_table = util.player_table(player)
    local function iterate_category(category, elems)
        local obj = category == 'game' and game or player_table.cheats_gui['cur_'..category]
        for _,elem in pairs(elems or player_table.cheats_gui.cheat_elems[category]) do
            local name = string.split(elem.name, '-')[3]
            local cheat_def = defs.cheats[category][name]
            if cheat_def.type ~= 'action' then
                local cheat_table = util.cheat_table(category, name, obj)
                local cur_value = cheat_def.functions.get_value(obj, cheat_def, cheat_table)
                -- disable if needed
                if cheat_def.functions.get_enabled then
                    elem.enabled = cheat_def.functions.get_enabled(obj, cheat_def, cheat_table)
                end
                -- set value
                if elem.type == 'checkbox' then
                    elem.state = elem.enabled and cur_value or false
                elseif elem.type == 'slider' then
                    elem.slider_value = cur_value
                elseif elem.type == 'textfield' then
                    elem.text = elem.enabled and cur_value or '---'
                elseif elem.type == 'drop-down' then
                    elem.selected_index = cur_value
                end
            end
        end
    end
    if category then
        iterate_category(category)
    else
        for category,elems in pairs(player_table.cheats_gui.cheat_elems) do
            iterate_category(category, elems)
        end
    end 
end

-- destroys and recreates the GUI
function cheats_gui.refresh(player, parent)
    if parent.im_cheats_window then
        cheats_gui.destroy(player)
        cheats_gui.create(player, parent)
        cheats_gui.update(player)
    end
end

-- create the 'do you want to enable infinity mode?' prompt
function cheats_gui.create_initial_dialog(player)
    local window = player.gui.screen.add{type='frame', name='im_enable_window', direction='vertical'}
    window.style.bottom_padding = 4
    local titlebar = titlebar.create(window, 'im_enable_titlebar', {label={'gui-initial-dialog.titlebar-label-caption'}, draggable=true})
    local buttons_table = window.add{type='table', name='im_enable_buttons_table', column_count=2}
    buttons_table.add{type='button', name='im_enable_button_yes_off', style='stretchable_button', caption={'', {'gui-initial-dialog.yes-off-button-caption'}, ' [img=im-info-black-inline]'}, tooltip={'gui-initial-dialog.yes-off-button-tooltip'}}
    buttons_table.add{type='button', name='im_enable_button_yes_on', style='stretchable_button', caption={'', {'gui-initial-dialog.yes-on-button-caption'}, ' [img=im-info-black-inline]'}, tooltip={'gui-initial-dialog.yes-on-button-tooltip'}}
    buttons_table.add{type='button', name='im_enable_button_editor', style='stretchable_button', caption={'', {'gui-initial-dialog.editor-button-caption'}, ' [img=im-info-black-inline]'}, tooltip={'gui-initial-dialog.editor-button-tooltip'}}
    buttons_table.add{type='button', name='im_enable_button_no', style='stretchable_button', caption={'', {'gui-initial-dialog.no-button-caption'}, ' [img=im-info-black-inline]'}, tooltip={'gui-initial-dialog.no-button-tooltip'}}
    window.force_auto_center()
end

return cheats_gui