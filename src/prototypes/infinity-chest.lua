local table = require('__stdlib__/stdlib/utils/table')
local chest_data = {
    ['active-provider'] = {s=0, t={218,115,255}, o='ab'},
    ['passive-provider'] = {s=0, t={255,141,114}, o='ac'},
    ['storage'] = {s=1, t={255,220,113}, o='ad'},
    ['buffer'] = {s=30, t={114,255,135}, o='ae'},
    ['requester'] = {s=30, t={114,236,255}, o='af'}
}

-- ------------------------------------------------------------------------------------------
-- ITEMS

-- modify existing infinity-chest item
local ic_item = data.raw['item']['infinity-chest']
ic_item.subgroup = 'im-inventories'
ic_item.order = 'aa'
ic_item.stack_size = 50
ic_item.flags = {}

-- create logistic chest items
ic_item = table.deepcopy(data.raw['item']['infinity-chest'])
for lm,d in pairs(chest_data) do
    local chest = table.deepcopy(ic_item)
    chest.name = 'infinity-chest-' .. lm
    chest.icons = { {icon=chest.icon, tint = d.t} }
    chest.place_result = 'infinity-chest-' .. lm
    chest.order = d.o
    chest.flags = {}
    data:extend{chest}
end

-- ------------------------------------------------------------------------------------------
-- ENTITIES

data.raw['infinity-container']['infinity-chest'].inventory_size = 100
data.raw['infinity-container']['infinity-chest'].gui_mode = 'all'

local ic_entity = table.deepcopy(data.raw['infinity-container']['infinity-chest'])
local inf_chest_picture = table.deepcopy(ic_entity.picture)
local inf_chest_icon = table.deepcopy(ic_entity.icon)

for lm,d in pairs(chest_data) do
    local chest = table.deepcopy(data.raw['logistic-container']['logistic-chest-' .. lm])
    chest.type = 'infinity-container'
    chest.name = 'infinity-chest-' .. lm
    chest.order = d.o
    chest.subgroup = 'im-inventories'
    chest.icons = { {icon=inf_chest_icon, tint = d.t} }
    chest.erase_contents_when_mined = true
    chest.picture = table.deepcopy(inf_chest_picture)
    chest.picture.layers[1].tint = d.t
    chest.picture.layers[1].hr_version.tint = d.t
    chest.animation = nil
    chest.logistic_slots_count = d.s
    chest.minable.result = 'infinity-chest-' .. lm
    chest.render_not_in_network_icon = true
    chest.inventory_size = 100
    chest.next_upgrade = nil
    data:extend{chest}
end

-- ------------------------------------------------------------------------------------------
-- RECIPES

register_recipes{'infinity-chest'}
register_recipes(table.map(table.keys(chest_data), function(v) return 'infinity-chest-' .. v end))