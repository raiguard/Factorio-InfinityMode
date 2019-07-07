-- ELEMENTS
local entity_camera = require('scripts/gui/elements/entity-camera')
local titlebar = require('scripts/gui/elements/titlebar')

local ia_page = require('entity-pages/infinity-accumulator')

-- Toggles the visibility of the interface
function toggle_entity_dialog(player, entity, page)
    local entity_frame = player.gui.center.im_entity_dialog_frame

    if entity_frame then
        entity_frame.destroy()
        player.opened = nil
    else
        player.opened = create_entity_dialog(player, entity, page)
        global.players[player.index].opened_entity = entity
    end
end

-- Destroy and recreate the dialog with the new parameters
function refresh_entity_dialog(player, entity, page)
    local entity_frame = player.gui.center.im_entity_dialog_frame

    if entity_frame then
        entity_frame.destroy()
        player.opened = create_entity_dialog(player, entity, page)
        global.players[player.index].opened_entity = entity
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

    titlebar.create(main_frame, 'entity_dialog_titlebar', {
        label = {'gui-entity-dialog.titlebar-label-' .. entity.name},
        buttons = {
            {
                name = 'close',
                sprite = 'utility/close_white',
                hovered_sprite = 'utility/close_black',
                clicked_sprite = 'utility/close_black'
            }
        }
    })

    local content_flow = main_frame.add {
        type = 'flow',
        name = 'im_entity_dialog_content_flow',
        direction = 'horizontal'
    }

    content_flow.style.horizontal_spacing = 8

    local camera = entity_camera.create(content_flow, 'im_entity_dialog_camera', 110, {player=player, entity=entity, camera_zoom=1, camera_offset={0,-0.5}})

    player_table(player).gui_elems = ia_page.create(content_flow, entity)

    return main_frame
end