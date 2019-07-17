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
            label = 'Cheats'
            -- buttons = {
            --     {
            --         name = 'to_top',
            --         sprite = 'im-to-top-white',
            --         hovered_sprite = 'im-to-top-black',
            --         clicked_sprite = 'im-to-top-black'
            --     },
            --     {
            --         name = 'close',
            --         sprite = 'utility/close_white',
            --         hovered_sprite = 'utility/close_black',
            --         clicked_sprite = 'utility/close_black'
            --     }
            -- }
        })
        local content_frame = window_frame.add{type='frame', name='im_cheats_content_frame', style='inside_deep_frame', direction='vertical'}
        local pane = tabbed_pane.create(content_frame, 'im_cheats', {
            items = {
                {'gui-cheats.tab-player-caption'},
                {'gui-cheats.tab-force-caption'},
                {'gui-cheats.tab-surface-caption'},
                {'gui-cheats.tab-game-caption'}
            },
            width = 365
        })

        local category_num = 0
        for _,category in pairs(defs.cheats_gui_elems.player) do
            category_num = category_num + 1
            local table = pane.add{type='table', name='im_cheats-player-'..category.category..'-table', column_count=category.table_columns, vertical_centering=category.vertical_centering}
            table.style.horizontally_stretchable = true
            table.style.bottom_margin = 5
            for i,group in pairs(category.groups) do
                local flow = table.add{type='flow', name='im_cheats-player-'..category.category..'-flow-'..i, direction='vertical'}
                flow.add{type='label', name='im_cheats-player-'..group.group..'-flow-'..i..'-label', style='caption_label', caption={'gui-cheats-player.group-'..group.group..'-caption'}}.style.horizontally_stretchable = true
                for _,setting in pairs(group.settings) do
                    if setting.type == 'toggle' then
                        flow.add{type='checkbox', name='im_cheats-player-'..setting.name..'-checkbox', state=defs.cheats.player[setting.name].functions.get_value(player) or false, caption={'gui-cheats-player.setting-'..setting.name..'-caption'}}.style.horizontally_stretchable = true
                    elseif setting.type == 'number' then
                        local setting_flow = flow.add{type='flow', name='im_cheats-player-'..setting.name..'-flow', direction='horizontal'}
                        setting_flow.style.vertical_align = 'center'
                        setting_flow.add{type='label', name='im_cheats-player-'..setting.name..'-label', caption={'gui-cheats-player.setting-'..setting.name..'-caption'}}
                        setting_flow.add{type='flow', name='im_cheats-player-'..setting.name..'-filler', style='invisible_horizontal_filler'}
                        setting_flow.add{type='textfield', name='im_cheats-player-'..setting.name..'-textfield', style='short_number_textfield', text=tostring(defs.cheats.player[setting.name].functions.get_value(player) or '---'), numeric=true, lose_focus_on_confirm=true}
                    end
                end
            end
        end

        return {element=window_frame, close_button=titlebar.children[4]}
end

return cheats_gui