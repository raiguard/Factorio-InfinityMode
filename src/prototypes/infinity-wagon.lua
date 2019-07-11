-- ------------------------------------------------------------------------------------------
-- ITEMS

local cw_item = table.deepcopy(data.raw['item-with-entity-data']['cargo-wagon'])

cw_item.name = 'infinity-cargo-wagon'
cw_item.icons = { apply_infinity_tint{icon = cw_item.icon}}
cw_item.place_result = 'infinity-cargo-wagon'
cw_item.subgroup = 'im-trains'
cw_item.order = 'ba'
cw_item.stack_size = 50

local fw_item = table.deepcopy(data.raw['item-with-entity-data']['fluid-wagon'])

fw_item.name = 'infinity-fluid-wagon'
fw_item.icons = { apply_infinity_tint{icon = fw_item.icon}}
fw_item.place_result = 'infinity-fluid-wagon'
fw_item.subgroup = 'im-trains'
fw_item.order = 'bb'
fw_item.stack_size = 50

data:extend{cw_item,fw_item}


-- ------------------------------------------------------------------------------------------
-- ENTITIES

local cw_entity = table.deepcopy(data.raw['cargo-wagon']['cargo-wagon'])

cw_entity.name = 'infinity-cargo-wagon'
cw_entity.inventory_size = 48
cw_entity.minable.result = 'infinity-cargo-wagon'

for _,t in pairs(cw_entity.pictures.layers) do
    apply_infinity_tint(t)
    apply_infinity_tint(t.hr_version)
end

for _,t in pairs(cw_entity.horizontal_doors.layers) do
    apply_infinity_tint(t)
    apply_infinity_tint(t.hr_version)
end

for _,t in pairs(cw_entity.vertical_doors.layers) do
    apply_infinity_tint(t)
    apply_infinity_tint(t.hr_version)
end

local fw_entity = table.deepcopy(data.raw['fluid-wagon']['fluid-wagon'])

fw_entity.name = 'infinity-fluid-wagon'
fw_entity.minable.result = 'infinity-fluid-wagon'

for _,t in pairs(fw_entity.pictures.layers) do
    apply_infinity_tint(t)
    apply_infinity_tint(t.hr_version)
end

data:extend{cw_entity,fw_entity}


-- ------------------------------------------------------------------------------------------
-- RECIPES

register_recipes{'infinity-cargo-wagon', 'infinity-fluid-wagon'}


-- ------------------------------------------------------------------------------------------
-- CUSTOM INPUTS

data:extend{
    {
        type = 'custom-input',
        name = 'iw-open-gui',
        key_sequence = '',
        linked_game_control = 'open-gui'
    }
}