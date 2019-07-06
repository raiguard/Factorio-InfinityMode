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

styles['dialog_content_deep_frame'] = {
    type = 'frame_style',
    parent = 'inside_deep_frame',
    direction = 'vertical',
    horizontally_stretchable = 'on',
    vertically_stretchable = 'on',
    horizontal_flow_style = {
        type = 'horizontal_flow_style',
        horizontal_spacing = 0
    }
}

styles['invisible_horizontal_filler'] = {
    type = 'horizontal_flow_style',
    horizontally_stretchable = 'on'
}

styles['nav_frame'] = {
    type = 'frame_style',
    parent = 'frame_with_even_paddings',
    top_padding = 4,
    right_padding = 4,
    bottom_padding = 4,
    left_padding = 4
}

styles['nav_pane_item'] = {
    type = 'button_style',
    parent = 'list_box_item',
    horizontally_stretchable = 'on',
    disabled_font_color = button_hovered_font_color,
    disabled_vertical_offset = 1, -- text/icon goes down on click
    disabled_graphical_set = {position = {51, 17}, corner_size = 8}
}

styles['nav_pane_item_pane'] = {
    type = 'scroll_pane_style',
    parent = 'list_box_scroll_pane',
    horizontally_stretchable = 'on',
    vertically_stretchable = 'on',
    vertical_flow_style = {
        type = 'vertical_flow_style',
        vertical_spacing = 0
    }
}

styles['subheader_frame_with_left_border'] = {
    type = 'frame_style',
    parent = 'subheader_frame',
    graphical_set = {
        base = {
            center = {position = {256, 25}, size = {1, 1}},
            bottom = {position = {256, 26}, size = {1, 8}},
            left_bottom = {position = {248,26}, size = {8,8}},
            left = {position = {248,25}, size = {8,1}}
        }
    }
}

styles['nav_page_button'] = {
    type = 'button_style',
    parent = 'button',
    width = 24,
    padding = 0,
    vertically_stretchable = 'on',
    hovered_graphical_set = {
        base = {position = {34, 17}, corner_size = 8},
        shadow = default_dirt
        -- glow = default_glow(default_glow_color, 0.5) -- glow is disabled because this button is inset
    }
}

styles['nav_page_button_dark'] = {
    type = 'button_style',
    parent = 'list_box_item',
    width = 24,
    padding = 0,
    vertically_stretchable = 'on',
    disabled_font_color = {179, 179, 179},
    disabled_graphical_set = {
        base = {position = {17, 17}, corner_size = 8},
        shadow = default_dirt
    }
}

styles['dark_inset_frame'] = {
    type = 'frame_style',
    parent = 'dark_frame',
    graphical_set = {
        base = {
            center = {position = {76,8}, size = {1,1}},
            draw_type = 'outer'
        },
        shadow = default_inner_shadow
    }
}

styles['dialog_page_frame'] = {
    type = 'frame_style',
    parent = 'dark_frame',
    graphical_set = {
        
    }
}