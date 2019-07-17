local table = require('__stdlib__/stdlib/utils/table')

-- ------------------------------------------------------------------------------------------
-- ITEMS

-- add crafting recipes for vanilla ores
register_recipes{'wood', 'iron-ore', 'copper-ore', 'coal', 'stone', 'uranium-ore'}

-- infinity pipe
local ip_item = data.raw['item']['infinity-pipe']
ip_item.icons = { apply_infinity_tint(ip_item.icons[1]) }
ip_item.subgroup = 'im-misc'
ip_item.order = 'aa'
ip_item.stack_size = 50

for name, picture in pairs(data.raw['infinity-pipe']['infinity-pipe'].pictures) do
    if name ~= 'high_temperature_flow' and name ~= 'middle_temperature_flow' and name ~= 'low_temperature_flow' and name ~= 'gas_flow' then
        apply_infinity_tint(picture)
        if picture.hr_version then
            apply_infinity_tint(picture.hr_version)
        end
    end
end

-- heat interface
local hi_item = data.raw['item']['heat-interface']
hi_item.subgroup = 'im-misc'
hi_item.order = 'ab'
hi_item.stack_size = 50

-- infinity radar
local ir_item = table.deepcopy(data.raw['item']['radar'])
ir_item.name = 'infinity-radar'
ir_item.icons = { apply_infinity_tint{icon=ir_item.icon} }
ir_item.place_result = 'infinity-radar'
ir_item.subgroup = 'im-misc'
ir_item.order = 'ba'

-- infinity beacon
local ib_item = table.deepcopy(data.raw['item']['beacon'])
ib_item.name = 'infinity-beacon'
ib_item.icons = { apply_infinity_tint{icon=ib_item.icon} }
ib_item.place_result = 'infinity-beacon'
ib_item.subgroup='im-modules'
ib_item.order = 'aa'

-- infinity lab
local lab_item = table.deepcopy(data.raw['item']['lab'])
lab_item.name = 'infinity-lab'
lab_item.icons = {apply_infinity_tint{icon=lab_item.icon}}
lab_item.place_result = 'infinity-lab'
lab_item.subgroup = 'im-misc'
lab_item.order = 'ca'

data:extend{ip_item, hi_item, ir_item, ib_item, lab_item}

data:extend{
    {
        -- Infinity fusion reactor
        type = 'item',
        name = 'infinity-fusion-reactor-equipment',
        icon_size = 32,
        icons = { apply_infinity_tint{icon=data.raw['item']['fusion-reactor-equipment'].icon} },
        subgroup = 'im-equipment',
        order = 'aa',
        placed_as_equipment_result = 'infinity-fusion-reactor-equipment',
        stack_size = 50
    },
    {
        -- Infinity personal roboport
        type = 'item',
        name = 'infinity-personal-roboport-equipment',
        icon_size = 32,
        icons = { apply_infinity_tint{icon=data.raw['item']['personal-roboport-equipment'].icon} },
        subgroup = 'im-equipment',
        order = 'ab',
        placed_as_equipment_result = 'infinity-personal-roboport-equipment',
        stack_size = 50
    }
}

register_recipes{'infinity-pipe', 'heat-interface', 'infinity-radar', 'infinity-beacon', 'infinity-lab', 'infinity-fusion-reactor-equipment', 'infinity-personal-roboport-equipment'}


-- ------------------------------------------------------------------------------------------
-- ENTITIES

-- infinity radar
local ir_entity = table.deepcopy(data.raw['radar']['radar'])
ir_entity.name = 'infinity-radar'
ir_entity.icons = ir_item.icons
ir_entity.minable.result = 'infinity-radar'
ir_entity.energy_source = {type='void'}
ir_entity.max_distance_of_sector_revealed = 20
ir_entity.max_distance_of_nearby_sector_revealed = 20
for _,t in pairs(ir_entity.pictures.layers) do
    apply_infinity_tint(t)
    apply_infinity_tint(t.hr_version)
end

-- infinity beacon
local ib_entity = table.deepcopy(data.raw['beacon']['beacon'])
ib_entity.name = 'infinity-beacon'
ib_entity.icons = ib_item.icons
ib_entity.minable.result = 'infinity-beacon'
ib_entity.energy_source = {type='void'}
ib_entity.allowed_effects = {'consumption', 'speed', 'productivity'}
ib_entity.supply_area_distance = 64
ib_entity.module_specification = {module_slots=12}
apply_infinity_tint(ib_entity.base_picture)
apply_infinity_tint(ib_entity.animation)

-- infinity lab
local lab_entity = table.deepcopy(data.raw['lab']['lab'])
lab_entity.name = 'infinity-lab'
lab_entity.icons = lab_item.icons
lab_entity.minable.result = 'infinity-lab'
lab_entity.energy_source = {type='void'}
lab_entity.energy_usage = '1W'
lab_entity.researching_speed = 100
lab_entity.module_specification = {module_slots=12}
for _,k in pairs{'on_animation', 'off_animation'} do
    for i=1,2 do
        apply_infinity_tint(lab_entity[k].layers[i])
        apply_infinity_tint(lab_entity[k].layers[i].hr_version)
    end
end

data:extend{ir_entity, ib_entity, lab_entity}


-- ------------------------------------------------------------------------------------------
-- EQUIPMENT

local pfr_equipment = table.deepcopy(data.raw['generator-equipment']['fusion-reactor-equipment'])
pfr_equipment.name = 'infinity-fusion-reactor-equipment'
pfr_equipment.sprite = apply_infinity_tint(pfr_equipment.sprite)
pfr_equipment.shape = {width=1, height=1, type='full'}
pfr_equipment.power = '1000YW'

local pr_equipment = table.deepcopy(data.raw['roboport-equipment']['personal-roboport-mk2-equipment'])
pr_equipment.name = 'infinity-personal-roboport-equipment'
pr_equipment.shape = {width=1, height=1, type='full'}
pr_equipment.sprite = apply_infinity_tint(pr_equipment.sprite)
pr_equipment.charging_energy = '1000GJ'
pr_equipment.charging_station_count = 1000
pr_equipment.robot_limit = 1000
pr_equipment.construction_radius = 100

data:extend{pfr_equipment, pr_equipment}


-- ------------------------------------------------------------------------------------------
-- MODULES

local function get_module_icon(name)
    local obj = data.raw['module'][name]
    return {apply_infinity_tint{icon=obj.icon, icon_size=obj.icon_size}}
end

local module_template = {
    type = 'module',
    subgroup = 'im-modules',
    stack_size = 50
}

local modules = {
    {name='super-speed-module', icon_ref='speed-module-3', order='ba', category = 'speed', tier=50, effect={speed={bonus=2.5}}},
    {name='super-effectivity-module', icon_ref='effectivity-module-3', order='bb', category = 'effectivity', tier=50, effect={consumption={bonus=-2.5}}},
    {name='super-productivity-module', icon_ref='productivity-module-3', order='bc', category = 'productivity', tier=50, effect={productivity={bonus=2.5}}},
    {name='super-slow-module', icon_ref='speed-module', order='ca', category = 'speed', tier=50, effect={speed={bonus=-2.5}}},
    {name='super-ineffectivity-module', icon_ref='effectivity-module', order='cb', category = 'effectivity', tier=50, effect={consumption={bonus=2.5}}}
}

for _,v in pairs(modules) do
    v = table.merge(v, module_template)
    v.icons = get_module_icon(v.icon_ref)
    v.icon_ref = nil
    data:extend{v}
    register_recipes{v.name}
end