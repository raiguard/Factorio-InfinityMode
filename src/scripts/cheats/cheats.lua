-- ----------------------------------------------------------------------------------------------------
-- INFINITY CHEATS CONTROL SCRIPTING
-- Contains the actual logic for all of the cheats in the mod

local table = require('__stdlib__/stdlib/utils/table')

local defs = require('cheats-definitions')
local util = require('scripts/util/util')

local cheats = {}

-- ----------------------------------------------------------------------------------------------------
-- CHEATS DATA MANAGEMENT

function cheats.create(player)
    local player_table = util.player_table(player)
    local player_cheats = {}
    for category,list in pairs(defs.cheats) do
        player_cheats[category] = {}
        for name,table in pairs(list) do
            if table.functions.get_value then
                cheats.update(player, {category, name}, table.default)
            end
        end
    end
    player_table.cheats = player_cheats
end

-- update a cheat to the new value
function cheats.update(player, cheat, value)
    game.print(player.name .. ' :: ' .. cheat[1] .. '.' .. cheat[2] .. ' = ' .. tostring(value))
    cheat = table.deepcopy(defs.cheats[cheat[1]][cheat[2]])
    cheat.functions.value_changed(player, cheat, value)
end

function cheats.is_valid(category, name)
    return type(defs.cheats[category][name]) == 'table'
end

return cheats
