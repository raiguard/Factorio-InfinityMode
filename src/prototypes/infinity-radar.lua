local r_item = table.deepcopy(data.raw['item']['radar'])
r_item.name = 'infinity-radar'
r_item.icons = { apply_infinity_tint{icon=r_item.icon} }
r_item.place_result = 'infinity-radar'
r_item.subgroup = 'im-misc'
r_item.order = 'ba'

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

data:extend{r_item, r_entity}

register_recipes{'infinity-radar'}