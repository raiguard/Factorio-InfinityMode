function create_page(content_frame, entity)
    local elems = {}
    local page_frame = content_frame.add {
        type = 'frame',
        name = 'im_entity_dialog_ia_page_frame',
        style = 'dark_inset_frame',
        direction = 'vertical'
    }

    page_frame.style.minimal_width = 250
    page_frame.style.vertically_stretchable = true
    page_frame.style.horizontally_stretchable = true
    page_frame.style.padding = 8

    -- SETTINGS
    local mode_flow = page_frame.add {
        type = 'flow',
        name = 'im_entity_dialog_ia_mode_flow',
        direction = 'horizontal'
    }

    mode_flow.style.vertical_align = 'center'

    mode_flow.add {
        type = 'label',
        name = 'im_entity_dialog_ia_mode_label',
        caption = 'Mode',
        style = 'bold_label'
    }

    mode_flow.add {
        type = 'flow',
        name = 'im_entity_dialog_ia_mode_filler',
        style = 'invisible_horizontal_filler'
    }

    elems.mode_dropdown = mode_flow.add {
        type = 'drop-down',
        name = 'im_entity_dialog_ia_mode_dropdown',
        items = {'input', 'output', 'buffer'},
        selected_index = ia_priority_to_index(entity).mode
    }

    local priority_flow = page_frame.add {
        type = 'flow',
        name = 'im_entity_dialog_ia_priority_flow',
        direction = 'horizontal'
    }

    priority_flow.style.vertical_align = 'center'

    priority_flow.add {
        type = 'label',
        name = 'im_entity_dialog_ia_priority_label',
        caption = 'Priority',
        style = 'bold_label'
    }

    priority_flow.add {
        type = 'flow',
        name = 'im_entity_dialog_ia_priority_filler',
        style = 'invisible_horizontal_filler'
    }

    elems.priority_dropdown = priority_flow.add {
        type = 'drop-down',
        name = 'im_entity_dialog_ia_priority_dropdown',
        items = {'primary', 'secondary', 'tertiary'},
        selected_index = ia_priority_to_index(entity).priority
    }

    if ia_priority_to_index(entity).priority == 3 then
        elems.priority_dropdown.enabled = false
    end

    local slider_flow = page_frame.add {
        type = 'flow',
        name = 'im_entity_dialog_ia_slider_flow',
        direction = 'horizontal'
    }

    slider_flow.style.vertical_align = 'center'

    elems.slider = slider_flow.add {
        type = 'slider',
        name = 'im_entity_dialog_ia_slider',
        minimum_value = 0,
        maximum_value = 1000,
        value = 100
    }

    elems.slider_textfield = slider_flow.add {
        type = 'textfield',
        name = 'im_entity_dialog_ia_slider_textfield',
        text = '100'
    }

    elems.slider_textfield.style.width = 48

    elems.slider_dropdown = slider_flow.add {
        type = 'drop-down',
        name = 'im_entity_dialog_ia_slider_dropdown',
        items = {'kW', 'MW', 'GW', 'TW', 'PW', 'EW', 'ZW', 'YW'},
        selected_index = 3
    }

    elems.slider_dropdown.style.width = 65

    return elems
end

local pti_ref = {
    input = 1,
    output = 2,
    buffer = 3,
    primary = 1,
    secondary = 2,
    tertiary = 3
}

function ia_priority_to_index(entity)
    local name = entity.name:gsub('(%a+)-(%a+)-', '')
    if name == 'tertiary' then return {mode=3, priority=3} end
    local _,_,priority,mode = string.find(name, '(%a+)-(%a+)')
    return {mode=pti_ref[mode], priority=pti_ref[priority]}
end