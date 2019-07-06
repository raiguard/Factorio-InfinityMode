-- infinity entities from vanilla
data:extend({
    {
        type = 'recipe',
        name = 'infinity-chest',
        enabled = true,
        ingredients = { },
        result = 'infinity-chest'
    },
    {
        type = 'recipe',
        name = 'infinity-pipe',
        enabled = true,
        ingredients = { },
        result = 'infinity-pipe'
    }
})
  
local inf_chest = data.raw.item['infinity-chest']
inf_chest.subgroup = 'im-inventories'
inf_chest.order = 'aa'
inf_chest.stack_size = 50

local inf_pipe = data.raw.item['infinity-pipe']
inf_pipe.subgroup = 'im-inventories'
inf_pipe.order = 'ab'
inf_pipe.stack_size = 50