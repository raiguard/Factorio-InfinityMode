-- INFINITY CHEATS GUI MANAGEMENT
-- Manages all of the GUI elements for the cheats interface

-- GUI ELEMENTS
local tabbed_pane = require('scripts/util/gui-elems/tabbed-pane')
local titlebar = require('scripts/util/gui-elems/titlebar')

local defs = require('cheats-definitions')

local cheats_gui = {}

function cheats_gui.create(player, parent)
    local window_frame = parent.add{type='frame', name='im_cheats_window', style='dialog_frame', direction='vertical'}
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
        local pane = tabbed_pane.create(content_frame, 'im_cheats', {
            items = {'Player', 'Team', 'Surface', 'Game'},
            width = 350
        })

        -- local checkboxes_table = pane.add{type='table', name='im_cheats_personal_toggles_table', column_count=2, vertical_centering=false}
        -- checkboxes_table.style.horizontally_stretchable = true
        -- checkboxes_table.style.bottom_margin = 5
        -- local checkboxes_flow_left = checkboxes_table.add{type='flow', name='im_cheats_personal_toggles_left_flow', direction='vertical'}
        -- checkboxes_flow_left.style.horizontally_stretchable = true
        -- checkboxes_flow_left.add{type='label', name='im_cheats_personal_toggles_left_label', style='caption_label', caption='Interaction'}
        -- local checkboxes_left = {'God Mode', 'Invincible player', 'Instant blueprint', 'Instant upgrade', 'Instant deconstruction'}
        -- for i,n in pairs(checkboxes_left) do
        --     checkboxes_flow_left.add{type='checkbox', name='checkbox_left_'..i, caption=n, state = true}
        -- end
        -- local checkboxes_flow_right = checkboxes_table.add{type='flow', name='im_cheats_personal_toggles_right_flow', direction='vertical'}
        -- checkboxes_flow_right.style.horizontally_stretchable = true
        -- checkboxes_flow_right.add{type='label', name='im_cheats_personal_toggles_right_label', style='caption_label', caption='Inventory'}
        -- local checkboxes_right = {'Cheat Mode', 'Keep last item', 'Repair mined item', 'Instant request', 'Instant trash'}
        -- for i,n in pairs(checkboxes_right) do
        --     checkboxes_flow_right.add{type='checkbox', name='checkbox_right_'..i, caption=n, state = true}
        -- end

        pane.add{type='checkbox', name='im_cheats-personal-cheat_mode-checkbox', caption='Cheat Mode', state=true}

        local line = pane.add{type='line', name='im_cheats_personal_divider_line', direction='horizontal'}
        line.style.horizontally_stretchable = true
        line.style.left_margin = -4
        line.style.right_margin = -4

        -- TEXTFIELDS

        local labels_flow = pane.add{type='flow', name='im_cheats_personal_textfields_label_flow', direction='horizontal'}
        labels_flow.style.vertical_align = 'center'
        labels_flow.add{type='label', name='im_cheats_personal_textfields_label', style='caption_label', caption='Bonuses'}
        labels_flow.add{type='flow', name='im_cheats_personal_textfields_label_filler', style='invisible_horizontal_filler', direciton='horizontal'}
        labels_flow.add{type='label', name='im_cheats_personal_textfields_help', style='info_label', caption='Press enter to confirm'}
        local textfields_table = pane.add{type='table', name='im_cheats_personal_textfields_table', column_count=2, vertical_centering=true}
        local reach_label = textfields_table.add{type='label', name='im_cheats_personal_reach_distance_label', caption='Reach distance'}
        reach_label.style.horizontally_stretchable = true
        textfields_table.add{type='textfield', name='im_cheats-personal-character_reach_distance_bonus-textfield', style='short_number_textfield', text='0', numeric=true, lose_focus_on_confirm=true}

        return {element=window_frame, close_button=titlebar.children[4]}
end

return cheats_gui