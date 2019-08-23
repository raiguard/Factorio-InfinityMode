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
function cheats.create(default_ref)
    local cheats = global.cheats
    for category,list in pairs(defs.cheats) do
        cheats[category] = {}
        cheats[category].default_ref = default_ref
        for name,table in pairs(list) do
            cheats[category][name] = {}
        end
    end
end

local function apply_default(category, name, data, obj, default_ref)
    local def = defs.cheats[category][name]
    if def.type == 'action' then
        data[obj.index], data.global = def.functions.setup_global and def.functions.setup_global(obj) or nil
        if def.defaults and def.defaults[default_ref] then cheats.trigger_action(obj, {category,name}) end
    else
        if def.defaults and def.defaults[default_ref] ~= nil then
            data[obj.index] = def.functions.setup_global and def.functions.setup_global(obj, def.defaults[default_ref]) or {cur_value=def.defaults[default_ref]}
            if data.global == nil then
                data.global = def.functions.setup_global_global and def.functions.setup_global_global(obj, def.defaults[default_ref]) or {}
            end
            cheats.update(obj, {category,name}, def.defaults[default_ref])
        else
            data[category == 'game' and 1 or obj.index] = {cur_value=def.functions.get_value(obj, def, data)}
        end
    end
end

function cheats.apply_defaults(category, obj)
    local default_ref = global.cheats[category].default_ref
    for name,data in pairs(global.cheats[category]) do
        if name ~= 'default_ref' then
            apply_default(category, name, data, obj, default_ref)
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

-- reiterate over all cheats for all objects and set up any new ones that have been added
function cheats.migrate()
    for _,category in pairs{'player','force','surface','game'} do
        local objects = category == 'game' and {game} or game[category..'s']
        local global_cheats = util.cheat_table(category)
        for name,def in pairs(defs.cheats[category]) do
            if not global_cheats[name] then
                global_cheats[name] = {}
                for _,obj in pairs(objects) do
                    apply_default(category, name, global_cheats[name], category == 'game' and game or obj, global_cheats.default_ref)
                end
            end
        end
    end
end

return cheats