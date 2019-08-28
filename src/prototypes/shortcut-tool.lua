local function shortcut_sprite(suffix, size)
    return {
        filename = '__InfinityMode__/graphics/shortcut-bar/'..suffix,
        priority = 'extra-high-no-scale',
        size = size,
        scale = 1,
        flags = {'icon'}
    }
end
-- INFINITY SELECTOR
data:extend{
    -- selection tool
    {
        type = 'selection-tool',
        name = 'infinity-selector',
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
        icon = shortcut_sprite('infinity-selector-x32.png', 32),
        disabled_icon = shortcut_sprite('infinity-selector-x32-white.png', 32),
        small_icon = shortcut_sprite('infinity-selector-x24.png', 24),
        disabled_small_icon = shortcut_sprite('infinity-selector-x24-white.png', 24),
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
-- TELEPORTER
data:extend{
    -- shortcut
    {
        type = 'shortcut',
        name = 'im-teleport',
        icon = shortcut_sprite('teleport-x32.png', 32),
        disabled_icon = shortcut_sprite('teleport-x32-white.png', 32),
        small_icon = shortcut_sprite('teleport-x24.png', 24),
        disabled_small_icon = shortcut_sprite('teleport-x24-white.png', 24),
        action = 'lua',
        associated_control_input = 'im-toggle-teleport-interface',
        toggleable = true
    },
    -- custom input
    {
        type = 'custom-input',
        name = 'im-toggle-teleport-interface',
        key_sequence = 'CONTROL + SHIFT + T',
        action = 'lua'
    }
}