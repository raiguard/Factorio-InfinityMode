local function shortcut_sprite(suffix, size)
    return {
        filename = '__InfinityMode__/graphics/shortcut-bar/infinity-selector-'..suffix,
        priority = 'extra-high-no-scale',
        size = size,
        scale = 1,
        flags = {'icon'}
    }
end
data:extend{
    -- selection tool
    {
        type = 'selection-tool',
        name = 'infinity-selector',
        -- icons = {
        --     {icon='__InfinityMode__/graphics/item/black.png', icon_size=64, icon_mipmaps=0},
        --     {icon='__InfinityMode__/graphics/shortcut-bar/infinity-selector-x32-white.png', icon_size=32, scale=0.5, icon_mipmaps=0}
        -- },
        icons = {{icon='__InfinityMode__/graphics/item/infinity-selector.png', icon_size=64, icon_mipmaps=0}},
        stack_size = 1,
        stackable = false,
        selection_color = infinity_tint,
        alt_selection_color = infinity_tint,
        selection_mode = {'any-entity', 'same-force'},
        alt_selection_mode = {'any-entity'},
        selection_cursor_box_type = 'entity',
        alt_selection_cursor_box_type = 'entity'
    },
    -- shortcut
    {
        type = 'shortcut',
        name = 'infinity-selector',
        icon = shortcut_sprite('x32.png', 32),
        disabled_icon = shortcut_sprite('x32-white.png', 32),
        small_icon = shortcut_sprite('x24.png', 24),
        small_disabled_icon = shortcut_sprite('x24-white.png', 24),
        action = 'create-blueprint-item',
        item_to_create = 'infinity-selector',
        associated_control_input = 'im-give-infinity-selector',
        toggleable = true
    },
    -- custom input
    {
        type = 'custom-input',
        name = 'im-give-infinity-selector',
        key_sequence = 'CONTROL + SHIFT + S',
        action = 'create-blueprint-item',
        item_to_create = 'infinity-selector'
    }
}