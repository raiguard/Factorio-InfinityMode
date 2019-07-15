-- ----------------------------------------------------------------------------------------------------
-- INFINITY ACCUMULATOR CONTROL SCRIPTING

local on_event = require('__stdlib__/stdlib/event/event').register
local gui = require('__stdlib__/stdlib/event/gui')
local util = require('scripts/util/util')

-- GUI ELEMENTS
local ia_page = require('scripts/util/gui-elems/ia-page')
local entity_camera = require('scripts/util/gui-elems/entity-camera')
local titlebar = require('scripts/util/gui-elems//titlebar')

local entity_list = {
    ['infinity-accumulator-primary-input'] = true,
    ['infinity-accumulator-primary-output'] = true,
    ['infinity-accumulator-secondary-input'] = true,
    ['infinity-accumulator-secondary-output'] = true,
    ['infinity-accumulator-tertiary'] = true
}

local function check_is_accumulator(e)
    if not e then return false end
    for n,t in pairs(entity_list) do
        if e.name == n then return true end
    end
    return false
end

-- on_event(defines.events.on_entity_settings_pasted, function(e)
--     if check_is_accumulator(e.source) and check_is_accumulator(e.destination) and e.source.name ~= e.destination.name then
--         local name = entity.name:gsub('(%a+)-(%a+)-', '')
--     end
-- end)

-- ----------------------------------------------------------------------------------------------------
-- GUI

-- gui management
on_event(defines.events.on_gui_opened, function(e)
    if check_is_accumulator(e.entity) then
        create_entity_dialog(util.get_player(e), e.entity, ia_page)
    end
end)

-- element handlers
local ia_states = {
    priority = {'primary', 'secondary', 'tertiary'},
    mode = {'input', 'output', 'buffer'}
}

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

local function change_ia_mode_or_priority(e)
    local data = util.get_center_gui(util.get_player(e))
    local entity = data.entity
    local elems = data.page_elems

    local priority = ia_states.priority[elems.priority_dropdown.selected_index]
    local mode = ia_states.mode[elems.mode_dropdown.selected_index]

    if priority == 'tertiary' and mode ~= 'buffer' then priority = 'primary' end
    if mode == 'buffer' then priority = 'tertiary' end

    local new_entity = entity.surface.create_entity{
        name = 'infinity-accumulator-' .. (mode == 'buffer' and 'tertiary' or priority) .. (mode ~= 'buffer' and ('-' .. mode) or ''),
        position = entity.position,
        force = entity.force
    }
    entity.destroy()
    set_ia_params(new_entity, mode, elems.slider.slider_value, elems.slider_dropdown.selected_index * 3)

    refresh_entity_dialog(util.get_player(e), new_entity, ia_page)
end

gui.on_click('im_entity_dialog_titlebar_button_close', function(e) util.close_center_gui(util.get_player(e)) end)

gui.on_selection_state_changed('im_entity_dialog_ia_mode_dropdown', function(e)
    change_ia_mode_or_priority(e)
end)

gui.on_selection_state_changed('im_entity_dialog_ia_priority_dropdown', function(e)
    change_ia_mode_or_priority(e)
end)

gui.on_value_changed('im_entity_dialog_ia_slider', function(e)
    local data = util.get_center_gui(util.get_player(e))
    local entity = data.entity
    local elems = data.page_elems
    local mode = ia_states.mode[elems.mode_dropdown.selected_index]

    local exponent = elems.slider_dropdown.selected_index * 3
    
    elems.slider_textfield.text = tostring(math.floor(e.element.slider_value))
    
    set_ia_params(entity, mode, e.element.slider_value, exponent)
end)

gui.on_text_changed('im_entity_dialog_ia_slider_textfield', function(e)
    local data = util.get_center_gui(util.get_player(e))
    local entity = data.entity
    local elems = data.page_elems
    local mode = ia_states.mode[elems.mode_dropdown.selected_index]

    local exponent = elems.slider_dropdown.selected_index * 3

    -- sanitize text
    local text = e.element.text:gsub('%D','')
    e.element.text = text

    if text == '' or tonumber(text) < 0 or tonumber(text) > 999 then
        e.element.tooltip = 'Must be an integer from 0-999'
        return nil
    else
        e.element.tooltip = ''
    end

    elems.prev_textfield_value = text
    elems.slider.slider_value = tonumber(text)
    set_ia_params(entity, mode, tonumber(text), exponent)
    LOG(data)

end)

on_event(defines.events.on_gui_confirmed, function(e)
    local center_gui = util.get_center_gui(util.get_player(e))
    local elems = center_gui.page_elems
    local entity = center_gui.entity
    local mode = ia_states.mode[elems.mode_dropdown.selected_index]
    local exponent = elems.slider_dropdown.selected_index * 3
    if elems.prev_textfield_value ~= elems.slider_textfield.text then
        elems.slider_textfield.text = elems.prev_textfield_value
        elems.slider_textfield.tooltip = ''
        elems.slider.slider_value = tonumber(elems.prev_textfield_value)
        set_ia_params(entity, mode, tonumber(elems.prev_textfield_value), exponent)
    end
end)

gui.on_selection_state_changed('im_entity_dialog_ia_slider_dropdown', function(e)
    local data = util.get_center_gui(util.get_player(e))
    local entity = data.entity
    local elems = data.page_elems
    local mode = ia_states.mode[elems.mode_dropdown.selected_index]

    local exponent = e.element.selected_index * 3

    set_ia_params(entity, mode, elems.slider.slider_value, exponent)
end)

-- Destroy and recreate the dialog with the new parameters
function refresh_entity_dialog(player, entity, page)
    local entity_frame = player.gui.center.im_entity_dialog_frame

    if entity_frame then
        entity_frame.destroy()
        create_entity_dialog(player, entity, page)
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

    local gui_data = {}
    gui_data.element = main_frame
    gui_data.entity = entity
    gui_data.page_elems = page.create(content_flow, {entity=entity})
    util.set_center_gui(player, gui_data)
end

-- ----------------------------------------------------------------------------------------------------