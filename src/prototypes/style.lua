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

styles['stretchable_button'] = {
    type = 'button_style',
    parent = 'button',
    horizontally_stretchable = 'on'
}

styles['dropdown_button'].disabled_font_color = styles['button'].disabled_font_color
styles['dropdown_button'].disabled_graphical_set = styles['button'].disabled_graphical_set

-- ----------------------------------------------------------------------------------------------------
-- TABBED PANE

local tab_button_data = {
    type = 'button_style',
    parent = nil,
    default_font_color = true,
    selected_font_color = true,
    disabled_font_color = true,
    minimal_width = true,
    horizontal_align = true,
    vertical_align = true,
    top_padding = true,
    right_padding = true,
    bottom_padding = true,
    left_padding = true,
    default_graphical_set = true,
    selected_graphical_set = true,
    hovered_graphical_set = 'hover_graphical_set',
    clicked_graphical_set = 'press_graphical_set',
    disabled_graphical_set = true
}
local tab_frame_data = {
    type = 'frame_style',
    top_padding = true,
    right_padding = true,
    bottom_padding = true,
    left_padding = true,
    graphical_set = true
}
local function build_style(source, data)
    local obj = {}
    obj.type = data.type
    obj.parent = data.parent
    data.type = nil
    data.parent = nil
    for k,v in pairs(data) do
        if source[k] then
            obj[k] = type(v) == 'boolean' and source[k] or source[v]
        end
    end
    return obj
end

styles['tab_button'] = build_style(styles.tab, tab_button_data)
styles['tab_button'].top_padding = 4
styles['tab_button'].bottom_padding = 4
-- styles['tab_button'].disabled_graphical_set = {
--     base = {
--         left_top = {position={136,0}, size={8,8}},
--         top = {position={144,0}, size={1,8}},
--         right_top = {position={145,0}, size={8,8}},
--         right = {position={145,8}, size={8,1}},
--         bottom = {position={144,9}, size={1,8}},
--         left = {position={136,8}, size={8,1}},
--         center = {position={144,8}, size={1,1}}
--     },
--     -- shadow = tab_glow(default_shadow_color, 0.5),
--     glow = {
--         left_bottom = {position={136,9}, size={8,8}},
--         bottom = {position={144,9}, size={1,8}},
--         right_bottom = {position={145,9}, size={8,8}},
--         scale = 0.5,
--         draw_type = 'outer'
--     }
-- }

styles['tab_content_frame'] = build_style(styles.tabbed_pane.tab_content_frame, tab_frame_data)

styles['tab_listbox'] = {
    type = 'list_box_style',
    -- scroll_pane_style = {
    --     type = 'scroll_pane_style',
    --     vertical_scrollbar_style = {
    --         type = 'vertical_scrollbar_style',
    --         vertical_scroll_policy = 'never'
    --     }
    -- },
    item_style = {
        type = 'button_style',
        parent = 'tab_button'
    }
}

-- ----------------------------------------------------------------------------------------------------
-- SPRITES

data:extend{
    {
        type = 'sprite',
        name = 'im-logo',
        filename = '__InfinityMode__/graphics/gui/crafting-group.png',
        size = 128,
        flags = {'icon'}
    },
    {
        type = 'sprite',
        name = 'im-to-top-black',
        filename = '__InfinityMode__/graphics/gui/to-top-black.png',
        size = 32,
        flags = {'icon'}
    },
    {
        type = 'sprite',
        name = 'im-to-top-white',
        filename = '__InfinityMode__/graphics/gui/to-top-white.png',
        size = 32,
        flags = {'icon'}
    },
    {
        type = 'sprite',
        name = 'im-from-top-black',
        filename = '__InfinityMode__/graphics/gui/from-top-black.png',
        size = 32,
        flags = {'icon'}
    },
    {
        type = 'sprite',
        name = 'im-from-top-white',
        filename = '__InfinityMode__/graphics/gui/from-top-white.png',
        size = 32,
        flags = {'icon'}
    }
}