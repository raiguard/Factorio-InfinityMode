local ip_item = data.raw['item']['infinity-pipe']
ip_item.subgroup = 'im-fluids'
ip_item.order = 'aa'
ip_item.stack_size = 50

local hi_item = data.raw['item']['heat-interface']
hi_item.subgroup = 'im-fluids'
hi_item.order = 'ab'
hi_item.stack_size = 50

register_recipes{'infinity-pipe', 'heat-interface'}