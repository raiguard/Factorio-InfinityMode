-- INFINITY CHEATS GUI MANAGEMENT
-- Manages all of the GUI elements for the cheats interface

local table = require('__stdlib__/stdlib/utils/table')

-- GUI ELEMENTS
-- local tabbed_pane = require('scripts/util/gui-elems/tabbed-pane')
local titlebar = require('scripts/util/gui-elems/titlebar')

local defs = require('scripts/util/definitions')
local util = require('scripts/util/util')

local cheats_gui = {}

local function create_cheat_ui(parent, obj, cheat, player_is_god, player_is_editor)
    local cheat_def = defs.cheats[cheat[1]][cheat[2]]
    local cheat_table = util.cheat_table(cheat[1], cheat[2], obj.index)
    local cheat_name = cheat[1]..'-'..cheat[2]
    local element
    if cheat_def.type == 'toggle' then
        element = parent.add{type='checkbox', name='im_cheats-'..cheat_name..'-checkbox', state=util.cheat_table(cheat[1], cheat[2], obj.index).cur_value, caption={'gui-cheats-'..cheat[1]..'.setting-'..cheat[2]..'-caption'}}
        element.style.horizontally_stretchable = true
    elseif cheat_def.type == 'number' then
        local setting_flow = parent.add{type='flow', name='im_cheats-'..cheat_name..'-flow', direction='horizontal'}
        setting_flow.style.vertical_align = 'center'
        setting_flow.add{type='label', name='im_cheats-'..cheat_name..'-label', caption={'gui-cheats-player.setting-'..cheat[2]..'-caption'}}
        setting_flow.add{type='flow', name='im_cheats-'..cheat_name..'-filler', style='invisible_horizontal_filler'}
        element = setting_flow.add{type='textfield', name='im_cheats-'..cheat_name..'-textfield', style='short_number_textfield', text=util.cheat_table(cheat[1], cheat[2], obj.index).cur_value, numeric=true, lose_focus_on_confirm=true}
    end
    if player_is_god and cheat_def.in_god_mode == false then
        element.enabled = false
        element.tooltip = {'gui-cheats.disabled-in-god-mode-tooltip'}
    elseif player_is_editor and cheat_def.in_editor == false then
        element.enabled = false
        element.tooltip = {'gui-cheats.disabled-in-editor-tooltip'}
    end
    return element
end

local function create_tabbed_pane(player, window_frame)
    local player_table = util.player_table(player)
    local elems_def = defs.cheats_gui_elems
    local content_frame = window_frame.add{type='frame', name='im_cheats_content_frame', style='inside_deep_frame_for_tabs', direction='vertical'}
    local tabbed_pane = content_frame.add{type='tabbed-pane', name='im_cheats_tabbed_pane'}
    for category,cheats in pairs(elems_def) do
        local tab = tabbed_pane.add{type='tab', name='im_cheats_'..category..'_tab', caption={'gui-cheats.tab-'..category..'-caption'}}
        local pane = tabbed_pane.add{type='flow', name='im_cheats_'..category..'_pane', direction='vertical'}
        if category == 'game' then tab.enabled = false end
        pane.style.left_padding = 5
        pane.style.right_padding = 5
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
    local switcher_flow = pane.add{type='flow', name='im_cheats_player_switcher_flow', style='vertically_centered_flow', direction='horizontal'}
    switcher_flow.add{type='label', name='im_cheats_player_switcher_label', style='caption_label', caption={'gui-cheats-player.switcher-label-caption'}}
    switcher_flow.add{type='flow', name='im_cheats_player_switcher_filler', style='invisible_horizontal_filler'}
    local players = {}
    for i,player in pairs(game.players) do
        players[i] = player.name
    end
    switcher_flow.add{type='drop-down', name='im_cheats_player_switcher_dropdown', items=players, selected_index=player_table.cheats_gui.cur_player.index}
    switcher_flow.style.bottom_margin = 4
    pane.add{type='line', name='im_cheats_player_switcher_line', direction='horizontal'}.style.horizontally_stretchable = true
    -- toggles
    local toggles_flow_table = pane.add{type='table', name='im_cheats_player_toggles_table', column_count=2}
    toggles_flow_table.style.horizontally_stretchable = true
    for group,cheats in pairs(elems_def.player.toggles) do
        local flow = toggles_flow_table.add{type='flow', name='im_cheats_player_toggles_'..group..'_flow', direction='vertical'}
        flow.style.horizontally_stretchable = true
        flow.add{type='label', name='im_cheats_player_toggles_'..group..'_label', style='caption_label', caption={'gui-cheats-player.group-'..group..'-caption'}}
        for i,n in pairs(cheats) do
            create_cheat_ui(flow, cur_player, {'player',n}, player_is_god, player_is_editor)
        end
    end
    -- pane.add{type='line', name='im_cheats_player_toggles_line', direction='horizontal'}.style.horizontally_stretchable = true
    -- bonuses
    pane.add{type='label', name='im_cheats_player_bonuses_label', style='caption_label', caption={'gui-cheats-player.group-bonuses-caption'}}.style.top_margin = 2
    for i,n in pairs(elems_def.player.bonuses) do
        create_cheat_ui(pane, player, {'player',n}, player_is_god, player_is_editor)
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
    forces_list.style.width = 140
    forces_list.style.height = 140
    local toggles_flow = upper_flow.add{type='flow', name='im_cheats_force_toggles_flow', direction='vertical'}
    toggles_flow.style.horizontally_stretchable = true
    -- toggles
    for i,n in pairs(elems_def.force.toggles) do
        create_cheat_ui(toggles_flow, cur_force, {'force',n})
    end

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
    surfaces_list.style.width = 140
    surfaces_list.style.height = 140
    local toggles_flow = upper_flow.add{type='flow', name='im_cheats_surface_toggles_flow', direction='vertical'}
    toggles_flow.style.horizontally_stretchable = true
    -- toggles
    for i,n in pairs(elems_def.surface.toggles) do
        create_cheat_ui(toggles_flow, cur_surface, {'surface',n})
    end

end

function cheats_gui.create(player, parent)
    local window_frame = parent.add{type='frame', name='im_cheats_window', style='dialog_frame', direction='vertical'}
    window_frame.location = {0,(44*player.display_scale)}
    local titlebar = titlebar.create(window_frame, 'im_cheats_titlebar', {
        label = {'gui-cheats.window-caption'},
        draggable = true,
        buttons = {
            {
                name = 'close',
                sprite = 'utility/close_white',
                hovered_sprite = 'utility/close_black',
                clicked_sprite = 'utility/close_black'
            }
        }
    })
    create_tabbed_pane(player, window_frame)
end

function cheats_gui.refresh(player, parent)
    if parent.im_cheats_window then
        parent.im_cheats_window.im_cheats_content_frame.destroy()
        create_tabbed_pane(player, parent.im_cheats_window)
    end
end

return cheats_gui