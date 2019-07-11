local ip_item = data.raw['item']['infinity-pipe']
ip_item.icons = { apply_infinity_tint(ip_item.icons[1]) }
ip_item.subgroup = 'im-fluids'
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
hi_item.subgroup = 'im-fluids'
hi_item.order = 'ab'
hi_item.stack_size = 50

register_recipes{'infinity-pipe', 'heat-interface'}