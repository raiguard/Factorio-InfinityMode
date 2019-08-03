-- ----------------------------------------------------------------------------------------------------
-- INFINITY CHEATS CONTROL SCRIPTING
-- Contains the actual logic for all of the cheats in the mod

local table = require('__stdlib__/stdlib/utils/table')

local defs = require('scripts/util/definitions')
local util = require('scripts/util/util')

local cheats = {}

-- ----------------------------------------------------------------------------------------------------
-- CHEATS DATA MANAGEMENT

-- create cheat data structure in global
function cheats.create()
    local cheats = global.cheats
    for category,list in pairs(defs.cheats) do
        cheats[category] = {}
        for name,table in pairs(list) do
            cheats[category][name] = {}
        end
    end
end

function cheats.apply_defaults(category, obj)
    for name,data in pairs(global.cheats[category]) do
        local def = defs.cheats[category][name]
        if def.type == 'action' then
            data[obj.index], data.global = def.functions.setup_global and def.functions.setup_global(obj) or nil
            if def.default then cheats.trigger_action(obj, {category,name}) end
        else
            if def.default ~= nil then
                data[obj.index] = def.functions.setup_global and def.functions.setup_global(obj, def.default) or {cur_value=def.default}
                if data.global == nil then
                    data.global = def.functions.setup_global_global and def.functions.setup_global_global(obj, def.default) or {}
                end
                cheats.update(obj, {category,name}, def.default)
            else
                data[category == 'game' and 1 or obj.index] = {cur_value=def.functions.get_value(obj, def, data)}
            end
        end
    end
end

-- update a cheat to the new value
function cheats.update(obj, cheat, value)
    log((cheat[1] == 'game' and 'game' or obj.name) .. ' :: ' .. cheat[1] .. '.' .. cheat[2] .. ' = ' .. tostring(value))
    local cheat_def = defs.cheats[cheat[1]][cheat[2]]
    local cheat_global = util.cheat_table(cheat[1], cheat[2], obj)
    cheat_global.cur_value = value
    cheat_def.functions.value_changed(obj, cheat_def, cheat_global, value)
end

-- trigger an action cheat
function cheats.trigger_action(obj, cheat)
    log((cheat[1] == 'game' and 'game' or obj.name) .. ' :: ' .. cheat[1] .. '.' .. cheat[2] .. ' TRIGGERED')
    local cheat_def = defs.cheats[cheat[1]][cheat[2]]
    local cheat_global = util.cheat_table(cheat[1], cheat[2], obj)
    cheat_global.cur_value = value
    cheat_def.functions.action(obj, cheat_def, cheat_global)
end

function cheats.is_valid(category, name)
    return type(defs.cheats[category][name]) == 'table'
end

return cheats