-- ELEMENTS
local titlebar = require('scripts.gui.elements.titlebar')
local position = require('__stdlib__.stdlib.area.position')
local page = require('entity-pages.infinity-accumulator')

-- Toggles the visibility of the interface
function toggle_entity_dialog(player, entity)
    local entity_frame = player.gui.center.im_entity_dialog_frame

    if entity_frame then
        entity_frame.destroy()
        player.opened = nil
    else
        player.opened = create_entity_dialog(player, entity, 'infinity-accumulator')
    end
end

-- Creates the main dialog frame
function create_entity_dialog(player, entity, page)
    local main_frame = player.gui.center.add {
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
        style = 'dialog_content_deep_frame',
        direction = 'horizontal'
    }

    local entity_outer_frame = content_frame.add {
        type = 'frame',
        name = 'im_entity_dialog_camera_frame',
        style = 'nav_frame'
    }

    local entity_inner_frame = entity_outer_frame.add {
        type = 'frame',
        name = 'im_entity_dialog_camera_inner_frame',
        style = 'dark_inset_frame'
    }

    entity_inner_frame.style.padding = 0

    local entity_camera = entity_inner_frame.add {
        type = 'camera',
        name = 'im_entity_dialog_camera',
        position = position.subtract(entity.position, {0,0.5}),
        zoom = player.display_scale
    }

    entity_camera.style.width = 110
    entity_camera.style.height = 110

    -- local page = require('entity-pages.' .. page or entity.name)
    create_page(content_frame, entity)

    return main_frame
end