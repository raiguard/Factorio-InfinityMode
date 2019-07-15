-- ----------------------------------------------------------------------------------------------------
-- INFINITY CHEATS CONTROL SCRIPTING

local on_event = require('__stdlib__/stdlib/event/event').register
local gui = require('__stdlib__/stdlib/event/gui')
local util = require('scripts/util/util')
local mod_gui = require('mod-gui')

-- GUI ELEMENTS
local tabbed_pane = require('scripts/util/gui-elems/tabbed-pane')
local titlebar = require('scripts/util/gui-elems/titlebar')
local toolbar = require('scripts/util/gui-elems/toolbar')

on_event(defines.events.on_player_joined_game, function(e)
    local flow = mod_gui.get_button_flow(util.get_player(e))
    if not flow.im_button then
        flow.add{type='sprite-button', name='im_button', style=mod_gui.button_style, sprite='im-logo'}
    end
end)

gui.on_click('im_button', function(e)
    local player = util.get_player(e)
    local frame_flow = mod_gui.get_frame_flow(player)
    if not frame_flow.im_flow then
        local flow = frame_flow.add{type='flow', name='im_flow', direction='horizontal'}
        local main_menu = flow.add{type='frame', name='im_main_menu', style='frame_with_even_paddings', direction='vertical'}
        main_menu.style.padding = 4
        titlebar.create(main_menu, 'im_main_menu_titlebar', {label='Infinity Mode'})
        local buttons_flow = main_menu.add{type='flow', name='im_main_menu_buttons_flow', direction='vertical'}
        buttons_flow.add{type='button', name='im_main_menu_button_cheats', style='stretchable_button', caption='Cheats'}
        buttons_flow.add{type='button', name='im_main_menu_button_editor', style='stretchable_button', caption='Map Editor'}
        buttons_flow.add{type='button', name='im_main_menu_button_testworlds', style='stretchable_button', caption='Testworlds'}.enabled = false
        
    else
        frame_flow.im_flow.destroy()
    end
end)

gui.on_click('im_main_menu_button_cheats', function(e)
    local player = util.get_player(e)
    local center = player.gui.center
    -- local mod_flow = mod_gui.get_frame_flow(player).im_flow
    if not center.im_cheats_window then
        local window_frame = center.add{type='frame', name='im_cheats_window', style='dialog_frame', direction='vertical'}
        local titlebar = titlebar.create(window_frame, 'im_cheats_titlebar', {
            label = 'Cheats',
            buttons = {
                {
                    name = 'to_top',
                    sprite = 'im-to-top-white',
                    hovered_sprite = 'im-to-top-black',
                    clicked_sprite = 'im-to-top-black'
                },
                {
                    name = 'close',
                    sprite = 'utility/close_white',
                    hovered_sprite = 'utility/close_black',
                    clicked_sprite = 'utility/close_black'
                }
            }
        })
        local content_frame = window_frame.add{type='frame', name='im_cheats_content_frame', style='inside_deep_frame', direction='vertical'}
        -- toolbar.create(content_frame, 'im_cheats_toolbar', {
        --     buttons = {
        --         {
        --             name = 'reset',
        --             style = 'red_icon_button',
        --             sprite = 'utility/reset',
        --             tooltip = 'Reset'
        --         }
        --     }
        -- })
        local pane = tabbed_pane.create(content_frame, 'im_cheats', {
            items = {'Player', 'Team', 'Surface', 'Game'},
            width = 400
        })

        local checkboxes_table = pane.add{type='table', name='im_cheats_personal_toggles_table', column_count=2, vertical_centering=false}
        checkboxes_table.style.horizontally_stretchable = true
        checkboxes_table.style.bottom_margin = 5
        local checkboxes_flow_left = checkboxes_table.add{type='flow', name='im_cheats_personal_toggles_left_flow', direction='vertical'}
        checkboxes_flow_left.style.horizontally_stretchable = true
        checkboxes_flow_left.add{type='label', name='im_cheats_personal_toggles_left_label', style='caption_label', caption='Interaction'}
        local checkboxes_left = {'God Mode', 'Invincible player', 'Instant blueprint', 'Instant upgrade', 'Instant deconstruction'}
        for i,n in pairs(checkboxes_left) do
            checkboxes_flow_left.add{type='checkbox', name='checkbox_left_'..i, caption=n, state = true}
        end
        local checkboxes_flow_right = checkboxes_table.add{type='flow', name='im_cheats_personal_toggles_right_flow', direction='vertical'}
        checkboxes_flow_right.style.horizontally_stretchable = true
        checkboxes_flow_right.add{type='label', name='im_cheats_personal_toggles_right_label', style='caption_label', caption='Inventory'}
        local checkboxes_right = {'Cheat Mode', 'Keep last item', 'Repair mined item', 'Instant request', 'Instant trash'}
        for i,n in pairs(checkboxes_right) do
            checkboxes_flow_right.add{type='checkbox', name='checkbox_right_'..i, caption=n, state = true}
        end

        local line = pane.add{type='line', name='im_cheats_personal_divider_line', direction='horizontal'}
        line.style.horizontally_stretchable = true
        line.style.left_margin = -4
        line.style.right_margin = -4

        -- TEXTFIELDS

        pane.add{type='label', name='im_cheats_personal_textfields_label', style='caption_label', caption='Bonuses'}.style.top_margin = 5
        local textfields_table = pane.add{type='table', name='im_cheats_personal_textfields_table', column_count=2, vertical_centering=true}
        local textfields = {'Reach distance', 'Build distance', 'Resource reach distance', 'Item drop distance', 'Item pickup distance', 'Loot pickup distance', 'Mining speed', 'Running speed', 'Crafting speed', 'Inventory size', 'Health'}
        for i=1,#textfields do
            local label = textfields_table.add{type='label', name='im_cheats_personal_textfield_' .. i .. '_label', caption=textfields[i]}
            label.style.horizontally_stretchable = true
            textfields_table.add{type='textfield', name='im_cheats_personal_textfield_'..i, style='short_number_textfield', text='0'}
        end

        util.set_center_gui(player, {element=window_frame, close_button=titlebar.children[4]})
        
    else
        center.im_cheats_window.destroy()
    end
end)