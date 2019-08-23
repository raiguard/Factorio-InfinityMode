-- ----------------------------------------------------------------------------------------------------
-- INFINITY MODE 0.4.0 MIGRATIONS

-- add default_ref to all cheat categories. should have been done in v0.3.0, but was forgotten :(
if global.cheats then
    for _,category in pairs(global.cheats) do
        category.default_ref = category.default_ref or 'on'
    end
end