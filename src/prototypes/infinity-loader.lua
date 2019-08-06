-- ------------------------------------------------------------------------------------------
-- ITEMS

data:extend{
    {
        type = 'item',
        name = 'infinity-loader',
        localised_name = {'entity-name.infinity-loader'},
        icons = {apply_infinity_tint{icon='__InfinityMode__/graphics/item/infinity-loader.png', icon_size=32}},
        stack_size = 50,
        place_result = 'infinity-loader-combinator',
        subgroup = 'im-misc',
        order = 'aa'
    }
}

register_recipes{'infinity-loader'}

-- ------------------------------------------------------------------------------------------
-- ENTITIES

local empty_sheet = {
    filename = "__core__/graphics/empty.png",
    priority = "very-low",
    width = 1,
    height = 1,
    frame_count = 1,
}

local underneathy_base = table.deepcopy(data.raw['underground-belt']['underground-belt'])
for n,t in pairs(underneathy_base.structure) do
    apply_infinity_tint(t.sheet)
    apply_infinity_tint(t.sheet.hr_version)
    if n ~= 'back_patch' and n ~= 'front_patch' then
        t.sheet.filename = '__InfinityMode__/graphics/entity/infinity-loader.png'
        t.sheet.hr_version.filename = '__InfinityMode__/graphics/entity/hr-infinity-loader.png'
    end
end
underneathy_base.icons = {apply_infinity_tint{icon='__InfinityMode__/graphics/item/infinity-loader.png', icon_size=32}}

-- underground belt
local function create_underneathy(base_underground)
    local entity = table.deepcopy(data.raw['underground-belt'][base_underground])
    -- adjust pictures and icon
    entity.structure = underneathy_base.structure
    -- entity.structure = {
    --     direction_in = empty_sheet,
    --     direction_out = empty_sheet
    -- }
    entity.icons = underneathy_base.icons
    -- basic data
    local suffix = entity.name:gsub('%-?underground%-belt', '')
    entity.name = 'infinity-loader-underneathy' .. (suffix ~= '' and '-'..suffix or '')
    entity.next_upgrade = nil
    entity.max_distance = 0
    entity.order = 'a'
    entity.selectable_in_game = false
    data:extend{entity}
end

for n,_ in pairs(table.deepcopy(data.raw['underground-belt'])) do
    create_underneathy(n)
end

local base_underneathy_path = '__base__/graphics/entity/underground-belt/'

data:extend{
    -- infinity chest
    {
        type = 'infinity-container',
        name = 'infinity-loader-chest',
        localised_name = {'entity-name.infinity-loader'},
        erase_contents_when_mined = true,
        inventory_size = 10,
        picture = empty_sheet,
        icons = underneathy_base.icons,
        collision_box = underneathy_base.collision_box,
        selection_box = underneathy_base.selection_box
    },
    -- combinator (for placement and blueprints)
    {
        type = 'constant-combinator',
        name = 'infinity-loader-combinator',
        localised_name = {'entity-name.infinity-loader'},
        icons = underneathy_base.icons,
        order = 'a',
        item_slot_count = 2,
        sprites = {
            sheets = {
                apply_infinity_tint{
                    filename = base_underneathy_path..'underground-belt-structure-back-patch.png',
                    width = 96,
                    height = 96,
                    hr_version = apply_infinity_tint{
                        filename = base_underneathy_path..'hr-underground-belt-structure-back-patch.png',
                        width = 192,
                        height = 192,
                        scale = 0.5
                    }
                },
                apply_infinity_tint{
                    filename = '__InfinityMode__/graphics/entity/infinity-loader.png',
                    width = 96,
                    height = 96,
                    hr_version = apply_infinity_tint{
                        filename = '__InfinityMode__/graphics/entity/hr-infinity-loader.png',
                        width = 192,
                        height = 192,
                        scale = 0.5
                    }
                },
                apply_infinity_tint{
                    filename = base_underneathy_path..'underground-belt-structure-front-patch.png',
                    width = 96,
                    height = 96,
                    hr_version = apply_infinity_tint{
                        filename = base_underneathy_path..'hr-underground-belt-structure-front-patch.png',
                        width = 192,
                        height = 192,
                        scale = 0.5
                    }
                }
            }   
        },
        activity_led_sprites = empty_sheet,
        activity_led_light_offsets = {{0,0}, {0,0}, {0,0}, {0,0}},
        circuit_wire_connection_points = {
            {wire={},shadow={}},
            {wire={},shadow={}},
            {wire={},shadow={}},
            {wire={},shadow={}}
        },
        collision_box = underneathy_base.collision_box
    }
}

local filter_inserter = data.raw['inserter']['stack-filter-inserter']

-- inserter
data:extend{
    {
        type = 'inserter',
        name = 'infinity-loader-inserter',
        icons = {apply_infinity_tint{icon='__InfinityMode__/graphics/item/infinity-loader.png', icon_size=32}},
        stack = true,
        collision_box = {{-0.1,-0.1}, {0.1,0.1}},
        -- selection_box = {{-0.1,-0.1}, {0.1,0.1}},
        -- selection_priority = 99,
        selectable_in_game = false,
        allow_custom_vectors = true,
        energy_source = {type='void'},
        extension_speed = 1,
        rotation_speed = 0.5,
        energy_per_movement = '0.00001J',
        energy_per_extension = '0.00001J',
        pickup_position = {0, -0.2},
        insert_position = {0, 0.2},
        draw_held_item = false,
        platform_picture = empty_sheet,
        hand_base_picture = empty_sheet,
        hand_open_picture = empty_sheet,
        hand_closed_picture = empty_sheet,
        -- hand_base_picture = filter_inserter.hand_base_picture,
        -- hand_open_picture = filter_inserter.hand_open_picture,
        -- hand_closed_picture = filter_inserter.hand_closed_picture,
        draw_inserter_arrow = false,
        flags = {'hide-alt-info'}
    }
}