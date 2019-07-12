local pti_ref = {
    input = 1,
    output = 2,
    buffer = 3,
    primary = 1,
    secondary = 2,
    tertiary = 3
}

local function ia_priority_to_index(entity)
    local name = entity.name:gsub('(%a+)-(%a+)-', '')
    if name == 'tertiary' then return {mode=3, priority=3} end
    local _,_,priority,mode = string.find(name, '(%a+)-(%a+)')
    return {mode=pti_ref[mode], priority=pti_ref[priority]}
end

local function create_dropdown(parent, name, caption, items, selected_index)
    local flow = parent.add{type='flow', name=name..'_flow', direction='horizontal'}
    flow.style.vertical_align = 'center'

    flow.add{type='label', name=name..'_label', caption=caption, style='bold_label'
    }

    flow.add {type='flow', name=name..'_filler', style='invisible_horizontal_filler'}

    return flow.add{type='drop-down', name=name..'_dropdown', items=items, selected_index=selected_index}
end

local page = {}

function page.create(content_frame, data)
    local entity = data.entity
    local elems = {}
    local mode = ia_priority_to_index(entity).mode
    local priority = ia_priority_to_index(entity).priority

    local page_frame = content_frame.add{type='frame', name='im_entity_dialog_ia_page_frame', style='entity_dialog_page_frame', direction='vertical'}

    -- SETTINGS
    
    elems.mode_dropdown = create_dropdown(page_frame, 'im_entity_dialog_ia_mode',
        {'gui-entity-dialog.infinity-accumulator-mode-caption'}, {'input', 'output', 'buffer'}, mode)

    elems.priority_dropdown = create_dropdown(page_frame, 'im_entity_dialog_ia_priority',
        {'gui-entity-dialog.infinity-accumulator-priority-caption'}, {'primary', 'secondary', 'tertiary'}, priority)

    page_frame.im_entity_dialog_ia_priority_flow.style.vertically_stretchable = true

    if priority == 3 then
        elems.priority_dropdown.enabled = false
    end

    local slider_flow = page_frame.add{type='flow', name='im_entity_dialog_ia_slider_flow', direction='horizontal'}

    slider_flow.style.vertical_align = 'center'

    local value = entity.electric_buffer_size

    local exponent = (string.len(string.format("%.0f", math.floor(value))) - 3)
    value = math.floor(value / 10^exponent)

    elems.slider = slider_flow.add{type='slider', name='im_entity_dialog_ia_slider', minimum_value=0, maximum_value=1000, value=value}

    elems.slider.style.horizontally_stretchable = true

    elems.slider_textfield = slider_flow.add{type='textfield', name='im_entity_dialog_ia_slider_textfield', text=value}
    elems.slider_textfield.style.width = 48

    elems.slider_dropdown = slider_flow.add{type='drop-down', name='im_entity_dialog_ia_slider_dropdown', items={'kW','MW','GW','TW','PW','EW','ZW','YW'}, selected_index=(exponent/3)}

    elems.slider_dropdown.style.width = 65

    return elems
end

return page