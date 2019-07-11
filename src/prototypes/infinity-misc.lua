-- ------------------------------------------------------------------------------------------
-- ITEMS

local ip_item = data.raw['item']['infinity-pipe']
ip_item.icons = { apply_infinity_tint(ip_item.icons[1]) }
ip_item.subgroup = 'im-misc'
ip_item.order = 'aa'
ip_item.stack_size = 50

for name, picture in pairs(data.raw['infinity-pipe']['infinity-pipe'].pictures) do
    if name ~= "high_temperature_flow" and name ~= "middle_temperature_flow" and name ~= "low_temperature_flow" and name ~= "gas_flow" then
        apply_infinity_tint(picture)
        if picture.hr_version then
            apply_infinity_tint(picture.hr_version)
        end
    end
end

local hi_item = data.raw['item']['heat-interface']
hi_item.subgroup = 'im-misc'
hi_item.order = 'ab'
hi_item.stack_size = 50

local r_item = table.deepcopy(data.raw['item']['radar'])
r_item.name = 'infinity-radar'
r_item.icons = { apply_infinity_tint{icon=r_item.icon} }
r_item.place_result = 'infinity-radar'
r_item.subgroup = 'im-misc'
r_item.order = 'ba'

data:extend{ip_item, hi_item, r_item}
register_recipes{'infinity-pipe', 'heat-interface', 'infinity-radar'}


-- ------------------------------------------------------------------------------------------
-- ENTITIES

local r_entity = table.deepcopy(data.raw['radar']['radar'])
r_entity.name = 'infinity-radar'
r_entity.icons = r_item.icons
r_entity.minable.result = 'infinity-radar'
r_entity.energy_source = {type='void'}
r_entity.max_distance_of_sector_revealed = 20
r_entity.max_distance_of_nearby_sector_revealed = 20

for _,t in pairs(r_entity.pictures.layers) do
    apply_infinity_tint(t)
    apply_infinity_tint(t.hr_version)
end

data:extend{r_entity}