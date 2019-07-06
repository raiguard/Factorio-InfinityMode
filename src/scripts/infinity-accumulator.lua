-- INFINITY ACCUMULATOR CONTROL SCRIPTING

local on_event = require('__stdlib__/stdlib/event/event').register
local gui = require('__stdlib__/stdlib/event/gui')
local entity_dialog = require('scripts/gui/dialogs/entity-dialog')

local entity_list = {
    'infinity-accumulator-primary-input',
    'infinity-accumulator-primary-output',
    'infinity-accumulator-secondary-input',
    'infinity-accumulator-secondary-output',
    'infinity-accumulator-tertiary'
}

local function check_is_accumulator(e)
    if not e then return false end
    for _,n in pairs(entity_list) do
        if e.name == n then return true end
    end
    return false
end

-- ----------------------------------------------------------------------------------------------------
-- GUI PROTOTYPING

on_event(defines.events.on_gui_opened, function(e)
    if check_is_accumulator(e.entity) then
        toggle_entity_dialog(game.players[e.player_index], e.entity)
    end
end)

on_event(defines.events.on_gui_closed, function(e)
    local player = game.players[e.player_index]
    if e.gui_type == defines.gui_type.custom and e.element.name == 'im_entity_dialog_frame' then
        toggle_entity_dialog(player)
    end
end)

on_event(defines.events.on_gui_click, function(e)
    local player = game.players[e.player_index]
    local name = e.element.name

    if name == 'cps_entity_dialog_titlebar_button_close' then
        toggle_entity_dialog(player)
    end
end)

-- ----------------------------------------------------------------------------------------------------