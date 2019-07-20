-- ----------------------------------------------------------------------------------------------------
-- INFINITY CHEATS CONTROL SCRIPTING
-- Contains the actual logic for all of the cheats in the mod

local table = require('__stdlib__/stdlib/utils/table')

local defs = require('scripts/util/definitions')
local util = require('scripts/util/util')

local cheats = {}

-- ----------------------------------------------------------------------------------------------------
-- CHEATS DATA MANAGEMENT

function cheats.create(player)
    util.player_table(player).cheats = {}
    local player_cheats = util.player_table(player).cheats
    for category,list in pairs(defs.cheats) do
        player_cheats[category] = {}
        for name,table in pairs(list) do
            player_cheats[category][name] = table.functions.setup_global and table.functions.setup_global(table.default)
            if table.functions.get_value then
                cheats.update(player, {category, name}, table.default)
            end
        end
    end
end

-- update a cheat to the new value
function cheats.update(player, cheat, value)
    game.print(player.name .. ' :: ' .. cheat[1] .. '.' .. cheat[2] .. ' = ' .. tostring(value))
    local cheat_def = defs.cheats[cheat[1]][cheat[2]]
    cheat_def.functions.value_changed(player, cheat, util.cheat_table(player, cheat[1], cheat[2]), value)
end

function cheats.is_valid(category, name)
    return type(defs.cheats[category][name]) == 'table'
end

return cheats