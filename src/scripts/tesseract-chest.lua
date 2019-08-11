-- ----------------------------------------------------------------------------------------------------
-- TESSERACT CHEST CONTROL SCRIPTING

local event = require('__stdlib__/stdlib/event/event')
local on_event = event.register
local table = require('__stdlib__/stdlib/utils/table')
local util = require('scripts/util/util')

-- ----------------------------------------------------------------------------------------------------
-- UTILITIES

-- check if the given entity is a tesseract chest
local function check_is_chest(entity)
    return entity.name:find('tesseract') and true or false
end

-- set the filters for the given tesseract chest
local function update_chest_filters(entity)
    local i = 0
    local include_hidden = settings.global['im-tesseract-include-hidden'].value
    entity.remove_unfiltered_items = true
    -- set infinity filters
    for n,p in pairs(game.item_prototypes) do
        if p.type ~= 'mining-tool' then
            if include_hidden or not p.has_flag('hidden') then
                i = i + 1
                entity.set_infinity_container_filter(i, {name=n, count=p.stack_size, mode='exactly', index=i})
            end
        end
    end
end

-- set the filters of all existing tesseract chests
local function update_all_chest_filters()
    for i,s in pairs(game.surfaces) do
        for _,e in pairs(s.find_entities_filtered{name={'tesseract-chest','tesseract-chest-passive-provider','tesseract-chest-storage'}}) do
            update_chest_filters(e)
        end
    end
end

-- ----------------------------------------------------------------------------------------------------
-- LISTENERS

event.on_configuration_changed(function(e)
    -- update filters of all tesseract chests
    update_all_chest_filters()    
end)

-- when a mod setting changes
on_event(defines.events.on_runtime_mod_setting_changed, function(e)
    if e.setting == 'im-tesseract-include-hidden' then
        -- update filters of all tesseract chests
        update_all_chest_filters()
    end
end)

-- when an entity is built
on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built}, function(e)
    local entity = e.created_entity or e.entity
    if check_is_chest(entity) then
        entity.operable = false
        update_chest_filters(entity)
    end
end)