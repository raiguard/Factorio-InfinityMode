-- INFINITY CHEATS GUI MANAGEMENT
-- Manages all of the GUI elements for the cheats interface

local table = require('__stdlib__/stdlib/utils/table')

-- GUI ELEMENTS
-- local tabbed_pane = require('scripts/util/gui-elems/tabbed-pane')
local titlebar = require('scripts/util/gui-elems/titlebar')

local defs = require('scripts/util/definitions')
local util = require('scripts/util/util')

local cheats_gui = {}

local function create_cheat_ui(parent, obj, cheat, elem_table, player_is_god, player_is_editor)
    local cheat_def = defs.cheats[cheat[1]][cheat[2]]
    local cheat_table = util.cheat_table(cheat[1], cheat[2], obj)
    local cheat_name = cheat[1]..'-'..cheat[2]
    local locale_name = cheat[1]..'.setting-'..cheat[2]
    local element
    if cheat_def.type == 'toggle' then
        element = parent.add{type='checkbox', name='im_cheats-'..cheat_name..'-checkbox', state=cheat_def.functions.get_value(obj, cheat_def, cheat_table),
            caption={'', {'gui-cheats-'..locale_name..'-caption'}, elem_table.tooltip and ' [img=info]' or nil},
            tooltip=elem_table.tooltip and {'gui-cheats-'..locale_name..'-tooltip'} or nil}
    elseif cheat_def.type == 'number' then
        local setting_flow = parent.add{type='flow', name='im_cheats-'..cheat_name..'-flow', direction='horizontal'}
        setting_flow.style.vertical_align = 'center'
        setting_flow.add{type='label', name='im_cheats-'..cheat_name..'-label',
            caption={'', {'gui-cheats-'..locale_name..'-caption'}, elem_table.tooltip and ' [img=info]' or nil},
            tooltip=elem_table.tooltip and {'gui-cheats-'..locale_name..'-tooltip'} or nil}
        setting_flow.add{type='empty-widget', name='im_cheats-'..cheat_name..'-filler', style='invisible_horizontal_filler'}
        if elem_table.slider then
            local slider = setting_flow.add{type='slider', name='im_cheats-'..cheat_name..'-slider', style=elem_table.slider.value_step and 'notched_slider' or nil,
                minimum_value=elem_table.slider.min_value or cheat_def.min_value or 1,
                maximum_value=elem_table.slider.max_value or cheat_def.max_value or 10,
                value_step=elem_table.slider.value_step or nil, discrete_slider=elem_table.slider.value_step and true or nil,
                discrete_values=elem_table.slider.value_step and true or nil}
            slider.slider_value = cheat_def.functions.get_value(obj, cheat_def, cheat_table)
            slider.style.right_margin = 5
        end
        element = setting_flow.add{type='textfield', name='im_cheats-'..cheat_name..'-textfield', style='short_number_textfield',
            text=cheat_def.functions.get_value(obj, cheat_def, cheat_table), numeric=true, lose_focus_on_confirm=true,
            allow_decimal=elem_table.textfield and elem_table.textfield.allow_decimal or false}
        if elem_table.textfield and elem_table.textfield.width then
            element.style.width = elem_table.textfield.width
        end
        if elem_table.slider then
            element.style.horizontal_align = 'center'
        end
    elseif cheat_def.type == 'action' then
        element = parent.add{type='button', name='im_cheats-'..cheat_name..'-button', style='stretchable_button',
            caption={'', {'gui-cheats-'..locale_name..'-caption'}, elem_table.tooltip and ' [img=im-info-black-inline]' or nil},
            tooltip=elem_table.tooltip and {'gui-cheats-'..locale_name..'-tooltip'} or nil}
    elseif cheat_def.type == 'list' then
        local setting_flow = parent.add{type='flow', name='im_cheats-'..cheat_name..'-flow', direction='horizontal'}
        setting_flow.style.vertical_align = 'center'
        setting_flow.add{type='label', name='im_cheats-'..cheat_name..'-label',
            caption={'', {'gui-cheats-'..locale_name..'-caption'}, elem_table.tooltip and ' [img=info]' or nil},
            tooltip=elem_table.tooltip and {'gui-cheats-'..locale_name..'-tooltip'} or nil}
        setting_flow.add{type='empty-widget', name='im_cheats-'..cheat_name..'-filler', style='invisible_horizontal_filler'}
        element = setting_flow.add{type='drop-down', name='im_cheats-'..cheat_name..'-dropdown'}
        for i,n in pairs(cheat_def.items) do
            element.add_item({'gui-cheats-'..locale_name..'-item-'..i..'-caption'})
        end
        element.selected_index = cheat_def.functions.get_value(obj, cheat_def, cheat_table)
    end
    if player_is_god and cheat_def.in_god_mode == false then
        element.enabled = false
        element.tooltip = {'gui-cheats.disabled-in-god-mode-tooltip'}
    elseif player_is_editor and cheat_def.in_editor == false then
        element.enabled = false
        element.tooltip = {'gui-cheats.disabled-in-editor-tooltip'}
    end
end

local function create_tabbed_pane(player, player_table, window_frame)
    local elems_def = defs.cheats_gui_elems
    local content_frame = window_frame.add{type='frame', name='im_cheats_content_frame', style='inside_deep_frame_for_tabs', direction='vertical'}
    -- local toolbar = content_frame.add{type='frame', name='im_cheats_toolbar_frame', style='subheader_frame'}
    -- toolbar.style.horizontally_stretchable = true
    -- toolbar.add{type='empty-widget', name='im_cheats_toolbar_spacer', style='invisible_horizontal_filler'}
    -- toolbar.add{type='switch', name='im_cheats_toolbar_defaults_switch', allow_none_state=true, switch_state='left', left_label_caption='On', right_label_caption='Off'}
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
        switcher_flow.add{type='drop-down', name='im_cheats_player_switcher_dropdown', items=players, selected_index=player_table.cheats_gui.cur_player.index}
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
            create_cheat_ui(flow, cur_player, {'player',n}, t, player_is_god, player_is_editor)
        end
    end
    -- bonuses
    pane.add{type='label', name='im_cheats_player_bonuses_label', style='caption_label', caption={'gui-cheats-player.group-bonuses-caption'}}.style.top_margin = 2
    for n,t in pairs(elems_def.player.bonuses) do
        create_cheat_ui(pane, cur_player, {'player',n}, t, player_is_god, player_is_editor)
    end
    -- actions
    local player_actions_label = pane.add{type='label', name='im_cheats_player_actions_label', style='caption_label', caption={'gui-cheats-player.group-actions-caption'}}
    player_actions_label.style.top_margin = 3
    player_actions_label.style.bottom_margin = 6
    local action_flow = pane.add{type='flow', name='im_cheats_player_actions_flow', direction='horizontal'}
    for n,t in pairs(elems_def.player.actions) do
        create_cheat_ui(pane, cur_player, {'player',n}, t, player_is_god, player_is_editor)
    end

    -- FORCE
    pane = tabs[2].content
    local cur_force = player_table.cheats_gui.cur_force
    local upper_flow = pane.add{type='flow', name='im_cheats_force_upper_flow', direction='horizontal'}
    upper_flow.style.horizontal_spacing = 10
    upper_flow.style.horizontally_stretchable = true
    -- force selector
    local forces = {}
    for i,force in pairs(game.forces) do
        forces[i] = force.name
    end
    local forces_list = upper_flow.add{type='list-box', name='im_cheats_force_listbox', style='list_box_in_tabbed_pane', items=forces, selected_index=cur_force.index}
    forces_list.style.minimal_width = 140
    forces_list.style.height = 140
    local toggles_flow = upper_flow.add{type='flow', name='im_cheats_force_toggles_flow', direction='vertical'}
    toggles_flow.style.horizontally_stretchable = true
    -- toggles
    for n,t in pairs(elems_def.force.toggles) do
        create_cheat_ui(toggles_flow, cur_force, {'force',n}, t)
    end
    -- bonuses
    pane.add{type='label', name='im_cheats_force_bonuses_label', style='caption_label', caption={'gui-cheats-force.group-bonuses-caption'}}.style.top_margin = 2
    for n,t in pairs(elems_def.force.bonuses) do
        create_cheat_ui(pane, cur_force, {'force',n}, t, player_is_god, player_is_editor)
    end
    -- actions
    local force_actions_label = pane.add{type='label', name='im_cheats_force_actions_label', style='caption_label', caption={'gui-cheats-force.group-actions-caption'}}
    force_actions_label.style.top_margin = 3
    force_actions_label.style.bottom_margin = 6
    local action_flow = pane.add{type='flow', name='im_cheats_force_actions_flow', direction='horizontal'}
    for n,t in pairs(elems_def.force.actions) do
        create_cheat_ui(action_flow, cur_force, {'force',n}, t)
    end
    local technology_flow = pane.add{type='flow', name='im_cheats_force_technology_flow', direction='horizontal'}
    technology_flow.add{type='button', name='im_cheats-force-research_all_technologies-button', caption={'gui-cheats-force.setting-research_all_technologies-caption'}}.style.horizontally_stretchable = true
    local reset_button = technology_flow.add{type='sprite-button', name='im_cheats-force-reset_technologies-button', style='red_button', sprite='utility/reset'}
    reset_button.style.width = 28
    reset_button.style.left_padding = 2
    reset_button.style.right_padding = 2

    -- SURFACE
    pane = tabs[3].content
    local cur_surface = player_table.cheats_gui.cur_surface
    local upper_flow = pane.add{type='flow', name='im_cheats_surface_upper_flow', direction='horizontal'}
    upper_flow.style.horizontal_spacing = 10
    upper_flow.style.horizontally_stretchable = true
    -- surface selector
    local surfaces = {}
    for i,surface in pairs(game.surfaces) do
        surfaces[i] = surface.name
    end
    local surfaces_list = upper_flow.add{type='list-box', name='im_cheats_surface_listbox', style='list_box_in_tabbed_pane', items=surfaces, selected_index=cur_surface.index}
    surfaces_list.style.minimal_width = 140
    surfaces_list.style.height = 140
    -- toggles
    local toggles_flow = upper_flow.add{type='flow', name='im_cheats_surface_toggles_flow', direction='vertical'}
    toggles_flow.style.horizontally_stretchable = true
    for n,t in pairs(elems_def.surface.toggles) do
        create_cheat_ui(toggles_flow, cur_surface, {'surface',n}, t)
    end
    -- table
    local surface_table = pane.add{type='table', name='im_cheats_surface_table', style='bordered_table', column_count=1}
    surface_table.style.top_margin = 5
    local time_flow = surface_table.add{type='flow', name='im_cheats_surface_time_flow', direction='vertical'}
    for n,t in pairs(elems_def.surface.time) do
        create_cheat_ui(time_flow, cur_surface, {'surface',n}, t)
    end
    local clear_flow = surface_table.add{type='flow', name='im_cheats_surface_clear_flow', direction='vertical'}
    for n,t in pairs(elems_def.surface.clear_entities) do
        create_cheat_ui(clear_flow, cur_surface, {'surface',n}, t)
    end
    local fill_flow = surface_table.add{type='flow', name='im_cheats_surface_fill_flow', direction='vertical'}
    for n,t in pairs(elems_def.surface.fill) do
        create_cheat_ui(fill_flow, cur_surface, {'surface',n}, t)
    end

    -- GAME
    pane = tabs[4].content
    local toggles_flow = pane.add{type='flow', name='im_cheats_game_toggle_flow', direction='vertical'}
    for n,t in pairs(elems_def.game.toggles) do
        create_cheat_ui(toggles_flow, game, {'game',n}, t)
    end
end

function cheats_gui.create(player, parent)
    local player_table = util.player_table(player)
    local window_frame = parent.add{type='frame', name='im_cheats_window', style='dialog_frame', direction='vertical'}
    -- if parent.name == 'mod_gui_frame_flow' then window_frame.style = mod_gui.frame_style end
    -- window_frame.style.height=530
    window_frame.location = player_table.cheats_gui.location and player_table.cheats_gui.location or {0,(44*player.display_scale)}
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
    player_table.cheats_gui.window = window_frame
end

function cheats_gui.refresh(player, parent)
    if parent.im_cheats_window then
        parent.im_cheats_window.im_cheats_content_frame.destroy()
        create_tabbed_pane(player, util.player_table(player), parent.im_cheats_window)
    end
end

-- create the 'do you want to enable infinity mode?' prompt
function cheats_gui.create_initial_dialog(player)
    local window = player.gui.screen.add{type='frame', name='im_enable_window', direction='vertical'}
    window.style.bottom_padding = 4
    local titlebar = titlebar.create(window, 'im_enable_titlebar', {label={'gui-initial-dialog.titlebar-label-caption'}, draggable=true})
    local buttons_flow = window.add{type='flow', name='im_enable_buttons_flow', direction='horizontal'}
    buttons_flow.add{type='button', name='im_enable_button_yes_off', style='stretchable_button', caption={'', {'gui-initial-dialog.yes-off-button-caption'}, ' [img=im-info-black-inline]'}, tooltip={'gui-initial-dialog.yes-off-button-tooltip'}}
    buttons_flow.add{type='button', name='im_enable_button_yes_on', style='stretchable_button', caption={'', {'gui-initial-dialog.yes-on-button-caption'}, ' [img=im-info-black-inline]'}, tooltip={'gui-initial-dialog.yes-on-button-tooltip'}}
    buttons_flow.add{type='button', name='im_enable_button_no', style='stretchable_button', caption={'', {'gui-initial-dialog.no-button-caption'}, ' [img=im-info-black-inline]'}, tooltip={'gui-initial-dialog.no-button-tooltip'}}
    window.force_auto_center()
end

return cheats_gui