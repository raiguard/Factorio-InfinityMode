-- ----------------------------------------------------------------------------------------------------
-- INFINITY CHEATS CONTROL SCRIPTING

local on_event = require('__stdlib__/stdlib/event/event').register
local gui = require('__stdlib__/stdlib/event/gui')
local mod_gui = require('mod-gui')

-- GUI ELEMENTS
local tabbed_pane = require('scripts/util/gui-elems/tabbed-pane')
local titlebar = require('scripts/util/gui-elems/titlebar')
local toolbar = require('scripts/util/gui-elems/toolbar')

on_event(defines.events.on_player_joined_game, function(e)
    local flow = mod_gui.get_button_flow(get_player(e))
    if not flow.im_button then
        flow.add{type='sprite-button', name='im_button', style=mod_gui.button_style, caption='nauvis'}
    end
end)

gui.on_click('im_button', function(e)
    local player = get_player(e)
    local frame_flow = mod_gui.get_frame_flow(player)
    if not frame_flow.im_flow then
        local flow = frame_flow.add{type='flow', name='im_flow', direction='horizontal'}
        local main_menu = flow.add{type='frame', name='im_main_menu', style='dialog_frame', direction='vertical'}
        titlebar.create(main_menu, 'im_main_menu_titlebar', {label='Infinity Mode'})
        local buttons_flow = main_menu.add{type='flow', name='im_main_menu_buttons_flow', direction='vertical'}
        buttons_flow.add{type='button', name='im_main_menu_button_cheats', style='stretchable_button', caption='Cheats'}
        buttons_flow.add{type='button', name='im_main_menu_button_testworlds', style='stretchable_button', caption='Testworlds'}
    else
        frame_flow.im_flow.destroy()
    end
end)

gui.on_click('im_main_menu_button_cheats', function(e)
    local player = get_player(e)
    local center = player.gui.center
    -- local mod_flow = mod_gui.get_frame_flow(player).im_flow
    if not center.im_cheats_window then
        local window_frame = center.add{type='frame', name='im_cheats_window', style='dialog_frame', direction='vertical'}
        titlebar.create(window_frame, 'im_cheats_titlebar', {
            label = 'Cheats',
            buttons = {
                {
                    name = 'close',
                    sprite = 'utility/close_white',
                    hovered_sprite = 'utility/close_black',
                    clicked_sprite = 'utility/close_black'
                }
            }
        })
        local content_frame = window_frame.add{type='frame', name='im_cheats_content_frame', style='inside_deep_frame', direction='vertical'}
        toolbar.create(content_frame, 'im_cheats_toolbar', {
            buttons = {
                {
                    name = 'reset',
                    style = 'red_icon_button',
                    sprite = 'utility/reset',
                    tooltip = 'Reset'
                }
            }
        })
        local pane = tabbed_pane.create(content_frame, 'im_cheats', {
            items = {'Player', 'Team', 'Surface', 'Game'},
            width = 400,
            height = 450,
            use_scroll = true
        })

        local checkboxes_frame = pane.add{type='frame', name='im_cheats_personal_checkboxes_frame', style='bordered_frame', direction='vertical'}
        checkboxes_frame.style.horizontally_stretchable = true
        checkboxes_frame.style.height = 200
        checkboxes_frame.add{type='label', name='im_cheats_personal_checkboxes_label', style='caption_label', caption='Toggles'}
    else
        center.im_cheats_window.destroy()
    end
end)