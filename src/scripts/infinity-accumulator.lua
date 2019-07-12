-- ----------------------------------------------------------------------------------------------------
-- INFINITY ACCUMULATOR CONTROL SCRIPTING

local on_event = require('__stdlib__/stdlib/event/event').register
local gui = require('__stdlib__/stdlib/event/gui')

-- GUI ELEMENTS
local ia_page = require('scripts/util/gui-elems/ia-page')
local entity_camera = require('scripts/util/gui-elems/entity-camera')
local titlebar = require('scripts/util/gui-elems//titlebar')

local entity_list = {
    'infinity-accumulator-primary-input',
    'infinity-accumulator-primary-output',
    'infinity-accumulator-secondary-input',
    'infinity-accumulator-secondary-output',
    'infinity-accumulator-tertiary'
}

local function check_is_accumulator(e)
    if not e then return false end
    for _,n in pairs(entity_list) do
        if e.name == n then return true end
    end
    return false
end

-- ----------------------------------------------------------------------------------------------------
-- GUI

local gui_element_list = {}

on_event(defines.events.on_gui_opened, function(e)
    if check_is_accumulator(e.entity) then
        toggle_entity_dialog(get_player(e), e.entity, ia_page)
    end
end)

on_event(defines.events.on_gui_closed, function(e)
    local player = get_player(e)
    if e.gui_type == defines.gui_type.custom and e.element.name == 'im_entity_dialog_frame' then
        toggle_entity_dialog(player)
    end
end)

-- element handlers
local ia_states = {
    priority = {'primary', 'secondary', 'tertiary'},
    mode = {'input', 'output', 'buffer'}
}

local function change_ia_mode_or_priority(e)
    local player_data = player_table(get_player(e))
    local entity = player_data.opened_entity
    local elems = player_data.gui_elems

    local priority = ia_states.priority[elems.priority_dropdown.selected_index]
    local mode = ia_states.mode[elems.mode_dropdown.selected_index]

    if priority == 'tertiary' and mode ~= 'buffer' then priority = 'primary' end
    if mode == 'buffer' then priority = 'tertiary' end

    local new_entity = entity.surface.create_entity{
        name = 'infinity-accumulator-' .. (mode == 'buffer' and 'tertiary' or priority) .. (mode ~= 'buffer' and ('-' .. mode) or ''),
        position = entity.position,
        power_production = entity.power_production,
        power_usage = entity.power_usage,
        electric_buffer_size = entity.electric_buffer_size,
        force = entity.force
    }
    entity.destroy()

    refresh_entity_dialog(get_player(e), new_entity, ia_page)
end

local function set_ia_params(entity, mode, value, exponent)
    entity.power_usage = 0
    entity.power_production = 0
    entity.electric_buffer_size = 0

    if mode == 'input' then
        entity.power_usage = (value * 10^exponent) / 60
        entity.electric_buffer_size = (value * 10^exponent)
    elseif mode == 'output' then
        entity.power_production = (value * 10^exponent) / 60
        entity.electric_buffer_size = (value * 10^exponent)
    elseif mode == 'buffer' then
        entity.electric_buffer_size = (value * 10^exponent)
    end
end

gui.on_click('im_entity_dialog_titlebar_button_close', function(e) toggle_entity_dialog(get_player(e)) end)

gui.on_selection_state_changed('im_entity_dialog_ia_mode_dropdown', function(e)
    change_ia_mode_or_priority(e)
end)

gui.on_selection_state_changed('im_entity_dialog_ia_priority_dropdown', function(e)
    change_ia_mode_or_priority(e)
end)

gui.on_value_changed('im_entity_dialog_ia_slider', function(e)
    local player_data = player_table(get_player(e))
    local entity = player_data.opened_entity
    local elems = player_data.gui_elems
    local mode = ia_states.mode[elems.mode_dropdown.selected_index]

    local exponent = elems.slider_dropdown.selected_index * 3
    
    elems.slider_textfield.text = tostring(math.floor(e.element.slider_value))
    
    set_ia_params(entity, mode, e.element.slider_value, exponent)
end)

gui.on_text_changed('im_entity_dialog_ia_slider_textfield', function(e)
    local player_data = player_table(get_player(e))
    local entity = player_data.opened_entity
    local elems = player_data.gui_elems
    local mode = ia_states.mode[elems.mode_dropdown.selected_index]

    local exponent = elems.slider_dropdown.selected_index * 3

    -- sanitize text
    local text = e.element.text:gsub('%D','')
    e.element.text = text

    if text == '' or tonumber(text) < 1 or tonumber(text) > 1000 then
        e.element.tooltip = 'Must be an integer between 1-1000'
        return nil
    else
        e.element.tooltip = ''
    end

    set_ia_params(entity, mode, tonumber(text), exponent)

end)

gui.on_selection_state_changed('im_entity_dialog_ia_slider_dropdown', function(e)
    local player_data = player_table(get_player(e))
    local entity = player_data.opened_entity
    local elems = player_data.gui_elems
    local mode = ia_states.mode[player_data.gui_elems.mode_dropdown.selected_index]

    local exponent = e.element.selected_index * 3

    set_ia_params(entity, mode, elems.slider.slider_value, exponent)
end)

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

    titlebar.create(main_frame, 'im_entity_dialog_titlebar', {
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

    content_flow.style.horizontal_spacing = 10

    local camera = entity_camera.create(content_flow, 'im_entity_dialog_camera', 110, {player=player, entity=entity, camera_zoom=1, camera_offset={0,-0.5}})

    player_table(player).gui_elems = page.create(content_flow, {entity=entity})

    return main_frame
end

-- ----------------------------------------------------------------------------------------------------