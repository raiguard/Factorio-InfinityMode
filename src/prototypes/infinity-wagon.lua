-- ------------------------------------------------------------------------------------------
-- ITEMS

local cw_item = table.deepcopy(data.raw['item-with-entity-data']['cargo-wagon'])

cw_item.name = 'infinity-cargo-wagon'
cw_item.icons = { {icon = cw_item.icon, tint = infinity_tint}}
cw_item.place_result = 'infinity-cargo-wagon'
cw_item.subgroup = 'im-inventories'
cw_item.order = 'aba'
cw_item.stack_size = 50

local fw_item = table.deepcopy(data.raw['item-with-entity-data']['fluid-wagon'])

fw_item.name = 'infinity-fluid-wagon'
fw_item.icons = { {icon = fw_item.icon, tint = infinity_tint}}
fw_item.place_result = 'infinity-fluid-wagon'
fw_item.subgroup = 'im-inventories'
fw_item.order = 'abb'
fw_item.stack_size = 50

data:extend{cw_item,fw_item}


-- ------------------------------------------------------------------------------------------
-- ENTITIES

local cw_entity = table.deepcopy(data.raw['cargo-wagon']['cargo-wagon'])

cw_entity.name = 'infinity-cargo-wagon'
cw_entity.inventory_size = 48
cw_entity.minable.result = 'infinity-cargo-wagon'

for _,t in pairs(cw_entity.pictures.layers) do
    t.tint = infinity_tint
    t.hr_version.tint = infinity_tint
end

for _,t in pairs(cw_entity.horizontal_doors.layers) do
    t.tint = infinity_tint
    t.hr_version.tint = infinity_tint
end

for _,t in pairs(cw_entity.vertical_doors.layers) do
    t.tint = infinity_tint
    t.hr_version.tint = infinity_tint
end

local fw_entity = table.deepcopy(data.raw['fluid-wagon']['fluid-wagon'])

fw_entity.name = 'infinity-fluid-wagon'
fw_entity.minable.result = 'infinity-fluid-wagon'

for _,t in pairs(fw_entity.pictures.layers) do
    t.tint = infinity_tint
    t.hr_version.tint = infinity_tint
end

data:extend{cw_entity,fw_entity}


-- ------------------------------------------------------------------------------------------
-- RECIPES

data:extend{
    {
        type = 'recipe',
        name = 'infinity-cargo-wagon',
        enabled = true,
        ingredients = { },
        result = 'infinity-cargo-wagon'
    },
    {
        type = 'recipe',
        name = 'infinity-fluid-wagon',
        enabled = true,
        ingredients = { },
        result = 'infinity-fluid-wagon'
    }
}


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