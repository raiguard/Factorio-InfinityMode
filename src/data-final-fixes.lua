-- add crafting recipes for vanilla ores
register_recipes{'wood', 'iron-ore', 'copper-ore', 'coal', 'stone', 'uranium-ore'}
-- -- add crafting recipes for all ores
-- for n,t in pairs(data.raw['resource']) do
--     local result = data.raw['item'][t.minable.result]
--     local recipe = data.raw['recipe'][t.minable.result]
--     if result and result.type == 'item' and not recipe then
--         register_recipes{n}
--     end
-- end