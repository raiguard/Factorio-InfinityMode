-- ------------------------------------------------------------------------------------------
-- ITEMS

data:extend{
    {
        type = 'item',
        name = 'infinity-accumulator',
        stack_size = 50,
        icons = { apply_infinity_tint{icon=data.raw['accumulator']['accumulator'].icon, icon_size=data.raw['accumulator']['accumulator'].icon_size} },
        place_result = 'infinity-accumulator-primary-output',
        subgroup = 'im-electricity',
        order = 'a'
    }
}

-- ------------------------------------------------------------------------------------------
-- ENTITIES

local ia_types = {'primary-input', 'primary-output', 'secondary-input', 'secondary-output', 'tertiary'}
local ia_entity = table.deepcopy(data.raw['electric-energy-interface']['electric-energy-interface'])
ia_entity.minable.result = 'infinity-accumulator'
ia_entity.picture.layers[1] = apply_infinity_tint(ia_entity.picture.layers[1])
ia_entity.picture.layers[1].hr_version = apply_infinity_tint(ia_entity.picture.layers[1].hr_version)

for _,t in pairs(ia_types) do
    local ia = table.deepcopy(ia_entity)
    ia.name = 'infinity-accumulator-' .. t
    ia.energy_source = {type='electric', usage_priority=t, buffer_capacity='500GJ'}
    ia.subgroup = 'im-electricity'
    ia.order = 'a'
    ia.minable.result = 'infinity-accumulator'
    data:extend{ia}
end

-- ------------------------------------------------------------------------------------------
-- RECIPES

register_recipes{'infinity-accumulator'}