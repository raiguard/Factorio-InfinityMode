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
        create_entity_dialog(util.get_player(e), e.entity, ia_page).force_auto_center()
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
    local data = util.player_table(e.player_index).ia_gui
    local entity = data.entity

    local priority = ia_states.priority[data.priority_dropdown.selected_index]
    local mode = ia_states.mode[data.mode_dropdown.selected_index]

    if priority == 'tertiary' and mode ~= 'buffer' then priority = 'primary' end
    if mode == 'buffer' then priority = 'tertiary' end

    local new_entity = entity.surface.create_entity{
        name = 'infinity-accumulator-' .. (mode == 'buffer' and 'tertiary' or priority) .. (mode ~= 'buffer' and ('-' .. mode) or ''),
        position = entity.position,
        force = entity.force
    }
    entity.destroy()
    set_ia_params(new_entity, mode, data.slider.slider_value, data.slider_dropdown.selected_index * 3)
    refresh_entity_dialog(util.get_player(e), new_entity)
end

gui.on_selection_state_changed('im_ia_mode_dropdown', function(e)
    change_ia_mode_or_priority(e)
end)

gui.on_selection_state_changed('im_ia_priority_dropdown', function(e)
    change_ia_mode_or_priority(e)
end)

gui.on_value_changed('im_ia_slider', function(e)
    local data = util.player_table(e.player_index).ia_gui
    local entity = data.entity
    local mode = ia_states.mode[data.mode_dropdown.selected_index]

    local exponent = data.slider_dropdown.selected_index * 3
    
    data.slider_textfield.text = tostring(math.floor(e.element.slider_value))
    
    set_ia_params(entity, mode, e.element.slider_value, exponent)
end)

gui.on_text_changed('im_ia_slider_textfield', function(e)
    local data = util.player_table(e.player_index).ia_gui
    local entity = data.entity
    local mode = ia_states.mode[data.mode_dropdown.selected_index]

    local exponent = data.slider_dropdown.selected_index * 3
    local text = data.slider_textfield.text

    if text == '' or tonumber(text) < 0 or tonumber(text) > 999 then
        e.element.tooltip = 'Must be an integer from 0-999'
        return nil
    else
        e.element.tooltip = ''
    end

    data.prev_textfield_value = text
    data.slider.slider_value = tonumber(text)
    set_ia_params(entity, mode, tonumber(text), exponent)
end)

on_event(defines.events.on_gui_confirmed, function(e)
    local player_table = util.player_table(e.player_index)
    local open_gui = player_table.open_gui
    if open_gui and open_gui.element.name == 'im_ia_window' then
        local data = player_table.ia_gui
        local entity = data.entity
        local mode = ia_states.mode[data.mode_dropdown.selected_index]
        local exponent = data.slider_dropdown.selected_index * 3
        if data.prev_textfield_value ~= data.slider_textfield.text then
            data.slider_textfield.text = data.prev_textfield_value
            data.slider_textfield.tooltip = ''
            data.slider.slider_value = tonumber(data.prev_textfield_value)
            set_ia_params(entity, mode, tonumber(data.prev_textfield_value), exponent)
        end
    end
end)

gui.on_selection_state_changed('im_ia_slider_dropdown', function(e)
    local data = util.player_table(e.player_index).ia_gui
    local entity = data.entity
    local mode = ia_states.mode[data.mode_dropdown.selected_index]

    local exponent = e.element.selected_index * 3

    set_ia_params(entity, mode, data.slider.slider_value, exponent)
end)

-- Destroy and recreate the dialog with the new parameters
function refresh_entity_dialog(player, entity)
    local entity_frame = player.gui.screen.im_ia_window
    if entity_frame then
        entity_frame.im_ia_content_flow.im_ia_page_frame.destroy()
        util.player_table(player).ia_gui = ia_page.create(entity_frame.im_ia_content_flow, {entity=entity})
    end
end

-- Creates the main dialog frame
function create_entity_dialog(player, entity)
    local main_frame = player.gui.screen.add {
        type = 'frame',
        name = 'im_ia_window',
        style = 'dialog_frame',
        direction = 'vertical'
    }

    local titlebar = titlebar.create(main_frame, 'im_ia_titlebar', {
        label = {'gui-entity-dialog.titlebar-label-' .. entity.name},
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

    local content_flow = main_frame.add {
        type = 'flow',
        name = 'im_ia_content_flow',
        direction = 'horizontal'
    }

    content_flow.style.horizontal_spacing = 10

    local camera = entity_camera.create(content_flow, 'im_camera', 110, {player=player, entity=entity, camera_zoom=1, camera_offset={0,-0.5}})
    util.set_open_gui(player, main_frame, titlebar.children[3], 'ia_gui')
    util.player_table(player).ia_gui = ia_page.create(content_flow, {entity=entity})
    return main_frame
end

-- ----------------------------------------------------------------------------------------------------