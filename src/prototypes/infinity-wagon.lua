-- ------------------------------------------------------------------------------------------
-- ITEMS

local cw_item = table.deepcopy(data.raw['item-with-entity-data']['cargo-wagon'])

cw_item.name = 'infinity-cargo-wagon'
cw_item.icons = {apply_infinity_tint{icon = cw_item.icon}}
cw_item.place_result = 'infinity-cargo-wagon'
cw_item.subgroup = 'im-trains'
cw_item.order = 'ba'
cw_item.stack_size = 50

local fw_item = table.deepcopy(data.raw['item-with-entity-data']['fluid-wagon'])

fw_item.name = 'infinity-fluid-wagon'
fw_item.icons = {apply_infinity_tint{icon = fw_item.icon}}
fw_item.place_result = 'infinity-fluid-wagon'
fw_item.subgroup = 'im-trains'
fw_item.order = 'bb'
fw_item.stack_size = 50

local l_item = table.deepcopy(data.raw['item-with-entity-data']['locomotive'])

l_item.name = 'infinity-locomotive'
l_item.icons = {apply_infinity_tint{icon = l_item.icon}}
l_item.place_result = 'infinity-locomotive'
l_item.subgroup = 'im-trains'
l_item.order = 'aa'
l_item.stack_size = 50

data:extend{cw_item, fw_item, l_item}
register_recipes{'infinity-cargo-wagon', 'infinity-fluid-wagon', 'infinity-locomotive'}

-- ------------------------------------------------------------------------------------------
-- ENTITIES

local cw_entity = table.deepcopy(data.raw['cargo-wagon']['cargo-wagon'])
cw_entity.name = 'infinity-cargo-wagon'
cw_entity.inventory_size = 100
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

local l_entity = table.deepcopy(data.raw['locomotive']['locomotive'])
l_entity.name = 'infinity-locomotive'
l_entity.max_power = '10MW'
l_entity.energy_source = {type='void'}
l_entity.max_speed = 10
l_entity.reversing_power_modifier = 1
l_entity.braking_force = 100
l_entity.allow_manual_color = false
l_entity.color = {r=0, g=0, b=0, a=0.5}
for i=1,2 do
    apply_infinity_tint(l_entity.pictures.layers[i])
    apply_infinity_tint(l_entity.pictures.layers[i].hr_version)
end

data:extend{cw_entity, fw_entity, l_entity}

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