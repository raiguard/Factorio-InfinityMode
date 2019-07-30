register_recipes({'wood'}, true)
-- add free crafting recipes for all ores
for n,t in pairs(data.raw['resource']) do
    if t.minable then
        local results = {}
        if t.minable.result then
            results[1] = data.raw['item'][t.minable.result]
        elseif t.minable.results then
            for i,r in pairs(t.minable.results) do
                results[i] = data.raw['item'][r.name]
            end
        end
        for _,result in pairs(results) do
            local recipe = data.raw['recipe'][result.name]
            if result.type == 'item' and not recipe then
                result.subgroup = 'raw-resource'
                register_recipes({result.name}, true)
            end
        end
    end
end