function create_page(content_frame, entity)
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

    mode_flow.add {
        type = 'drop-down',
        name = 'im_entity_dialog_ia_mode_dropdown',
        items = {'input', 'output', 'buffer'},
        selected_index = 2
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

    priority_flow.add {
        type = 'drop-down',
        name = 'im_entity_dialog_ia_priority_dropdown',
        items = {'primary', 'secondary'},
        selected_index = 1
    }

    local slider_flow = page_frame.add {
        type = 'flow',
        name = 'im_entity_dialog_ia_slider_flow',
        direction = 'horizontal'
    }

    slider_flow.style.vertical_align = 'center'

    local slider = slider_flow.add {
        type = 'slider',
        name = 'im_entity_dialog_ia_slider',
        minimum_value = 0,
        maximum_value = 1000,
        value = 100
    }

    local slider_textfield = slider_flow.add {
        type = 'textfield',
        name = 'im_entity_dialog_ia_slider_textfield',
        text = '100'
    }

    slider_textfield.style.width = 48

    local slider_dropdown = slider_flow.add {
        type = 'drop-down',
        name = 'im_entity_dialog_ia_slider_dropdown',
        items = {'kW', 'MW', 'GW', 'TW', 'PW', 'EW', 'ZW', 'YW'},
        selected_index = 3
    }

    slider_dropdown.style.width = 65

    return page_frame
end