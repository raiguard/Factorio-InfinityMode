-- ELEMENTS
require('scripts.gui.elements.titlebar')

-- Toggles the visibility of the interface
function toggle_entity_dialog(player, entity)
    local entity_frame = player.gui.center.im_entity_dialog_frame

    if entity_frame then entity_frame.destroy()
    else
        player.opened = create_entity_dialog(player.gui.center, entity)
    end
end

-- Creates the main dialog frame
function create_entity_dialog(center_gui, entity)
    local main_frame = center_gui.add {
        type = 'frame',
        name = 'im_entity_dialog_frame',
        style = 'dialog_frame',
        direction = 'vertical'
    }

    create_titlebar(main_frame, 'entity_dialog_titlebar', {
        label = {'gui-entity-dialog.titlebar-label-' .. entity.name},
        buttons = {
            {
                name = 'close',
                sprite = 'utility/close_white'
            }
        }
    })

    local content_frame = main_frame.add {
        type = 'frame',
        name = 'im_dialog_content_frame',
        style = 'dark_inset_frame',
        direction = 'vertical'
    }

    content_frame.style.height = 250
    content_frame.style.width = 350

    return main_frame
end