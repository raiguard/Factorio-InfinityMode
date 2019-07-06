infinity_tint = {r=1, g=0.8, b=1, a=1}

function register_recipes(t)
    for _,k in pairs(t) do
        data:extend{
            {
                type = 'recipe',
                name = k,
                ingredients = {},
                enabled = true,
                result = k
            }
        }
    end
end

require('prototypes.infinity-accumulator')
require('prototypes.infinity-chest')
require('prototypes.infinity-robot')
require('prototypes.infinity-vanilla')
require('prototypes.infinity-wagon')
require('prototypes.item-group')
require('prototypes.style')