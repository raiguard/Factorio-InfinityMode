local function shortcut_sprite(suffix, size)
    return {
        filename = '__InfinityMode__/graphics/shortcut-bar/'..suffix,
        priority = 'extra-high-no-scale',
        size = size,
        scale = 1,
        flags = {'icon'}
    }
end
-- Generates data for the smoke of magic wands.
local function magic_wand_smoke(entity_name, color)
	return {
		affected_by_wind = false,
		animation = {
			animation_speed = 60 / 40,
			axially_symmetrical = false,
			direction_count = 1,
			filename = "__base__/graphics/entity/smoke/smoke.png",
			flags = {
				"smoke"
			},
			frame_count = 60,
			height = 120,
			line_length = 5,
			priority = "high",
			shift = {
				-0.53125,
				-0.4375
			},
			width = 152
		},
		color = color,
		cyclic = true,
		duration = 40,
		end_scale = 3.0,
		fade_away_duration = 40,
		fade_in_duration = 0,
		flags = {
			"not-on-map"
		},
		name = entity_name,
		spread_duration = 40,
		start_scale = 0.5,
		type = "trivial-smoke"
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
        selection_mode = {'any-tile', 'same-force'},
        alt_selection_mode = {'any-entity', 'same-force'},
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
    -- smoke
    magic_wand_smoke('infinity-selector-smoke', infinity_tint),
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