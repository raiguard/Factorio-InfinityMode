-- STYLES
local styles = data.raw['gui-style'].default

styles['green_button'] = {
    type = 'button_style',
    parent = 'button',
    default_graphical_set = {
        base = {position = {68, 17}, corner_size = 8},
        shadow = default_dirt
    },
    hovered_graphical_set = {
        base = {position = {102, 17}, corner_size = 8},
        shadow = default_dirt,
        glow = default_glow(green_arrow_button_glow_color, 0.5)
    },
    clicked_graphical_set = {
        base = {position = {119, 17}, corner_size = 8},
        shadow = default_dirt
    },
    disabled_graphical_set = {
        base = {position = {85, 17}, corner_size = 8},
        shadow = default_dirt
    }
}

styles['green_icon_button'] = {
    type = 'button_style',
    parent = 'green_button',
    padding = 3,
    size = 28
}

styles['footer_filler'] = {
    type = 'frame_style',
    height = 32,
    graphical_set = styles['draggable_space'].graphical_set,
    use_header_filler = false,
    horizontally_stretchable = 'on',
    left_margin = styles['draggable_space'].left_margin,
    right_margin = styles['draggable_space'].right_margin,
}

styles['titlebar_filler'] = {
    type = 'frame_style',
    parent = 'footer_filler',
    height = 24
}

styles['titlebar_flow'] = {
    type = 'horizontal_flow_style',
    direction = 'horizontal',
    horizontally_stretchable = 'on',
    vertical_align = 'center'
}

styles['invisible_horizontal_filler'] = {
    type = 'horizontal_flow_style',
    horizontally_stretchable = 'on'
}

styles['invisible_vertical_filler'] = {
    type = 'vertical_flow_style',
    vertically_stretchable = 'on'
}

styles['entity_dialog_page_frame'] = {
    type = 'frame_style',
    parent = 'window_content_frame',
    minimal_width = 250,
    vertically_stretchable = 'on',
    horizontally_stretchable = 'on',
    left_padding = 8,
    top_padding = 6,
    right_padding = 6,
    bottom_padding = 6
}

styles['camera_frame'] = {
    type = 'frame_style',
    parent = 'window_content_frame',
    padding = 0
}

styles['inventory_slot_button'] = {
    type = "button_style",
    parent = "button",
    draw_shadow_under_picture = true,
    size = 40,
    padding = 0,
    default_graphical_set =
    {
        base = {border = 4, position = {0, 424}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color)
    },
    hovered_graphical_set =
    {
        base = {border = 4, position = {0, 500}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color),
        glow = offset_by_2_default_glow(default_glow_color)
    },
    clicked_graphical_set =
    {
        base = {border = 4, position = {0, 576}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color)
    },
    pie_progress_color = {0.98, 0.66, 0.22, 0.5},
    left_click_sound = {}
}

styles['inventory_slot_button_red'] = {
    type = 'button_style',
    parent = 'inventory_slot_button',
    default_graphical_set =
    {
        base = {border = 4, position = {76, 424}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color)
    },
    hovered_graphical_set =
    {
        base = {border = 4, position = {76, 500}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color),
        glow = offset_by_2_default_glow({236, 130, 130, 127}, 0.5)
    },
    clicked_graphical_set =
    {
        base = {border = 4, position = {76, 576}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color)
    }
}

styles['inventory_slot_button_green'] = {
    type = 'button_style',
    parent = 'inventory_slot_button',
    default_graphical_set =
    {
        base = {border = 4, position = {152, 424}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color)
    },
    hovered_graphical_set =
    {
        base = {border = 4, position = {152, 500}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color),
        glow = offset_by_2_default_glow({110, 164, 104, 127}, 0.5)
    },
    clicked_graphical_set =
    {
        base = {border = 4, position = {152, 576}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color)
    }
}

styles['inventory_slot_button_blue'] = {
    type = 'button_style',
    parent = 'inventory_slot_button',
    default_graphical_set =
    {
        base = {border = 4, position = {228, 424}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color)
    },
    hovered_graphical_set =
    {
        base = {border = 4, position = {228, 500}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color),
        glow = offset_by_2_default_glow({132, 177, 198, 127}, 0.5)
    },
    clicked_graphical_set =
    {
        base = {border = 4, position = {228, 576}, size = 76},
        shadow = offset_by_2_default_glow(default_dirt_color)
    }
}


data:extend{
    {
        type = 'sprite',
        name = 'im_sprite_info',
        filename = '__InfinityMode__/graphics/gui/info-blue.png',
        priority = 'extra-high',
        size = 32,
        flags = {'icon'}
    },
    {
        type = 'sprite',
        name = 'im_sprite_info_black',
        filename = '__InfinityMode__/graphics/gui/info-black.png',
        priority = 'extra-high',
        size = 32,
        flags = {'icon'}
    }
}