-- ----------------------------------------------------------------------------------------------------
-- CHEATS LISTENERS
-- Entry point for the cheat scripting, where all listeners are created and managed

local event = require('__stdlib__/stdlib/event/event')
local on_event = event.register
local gui = require('__stdlib__/stdlib/event/gui')
local string = require('__stdlib__/stdlib/utils/string')
local util = require('scripts/util/util')
local mod_gui = require('mod-gui')

local cheats = require('cheats')
local cheats_gui = require('cheats-gui')

-- ----------------------------------------------------------------------------------------------------
-- MOD GUI

event.on_init(function()
    cheats.create()
    cheats.apply_defaults('force', game.forces['player'])
    cheats.apply_defaults('force', game.forces['enemy'])
    cheats.apply_defaults('force', game.forces['neutral'])
    cheats.apply_defaults('surface', game.surfaces['nauvis'])
end)

on_event(defines.events.on_player_created, function(e)
    local player = util.get_player(e)
    local flow = mod_gui.get_button_flow(player)
    if not flow.im_button then
        flow.add{type='sprite-button', name='im_button', style=mod_gui.button_style, sprite='im-logo'}
        flow.add{type='button', name='im_DEBUG', style=mod_gui.button_style, caption='DEBUG'}
    end
    cheats.apply_defaults('player', player)
end)

gui.on_click('im_button', function(e)
    local player = util.get_player(e)
    local frame_flow = mod_gui.get_frame_flow(player)
    if not frame_flow.im_cheats_window then
        cheats_gui.create(player, frame_flow)
    else
        frame_flow.im_cheats_window.destroy()
    end
end)

gui.on_click('im_DEBUG', function(e)
    local cur_value = global.cheats.force.instant_research[1].cur_value
    cheats.update(game.forces['player'], {'force','instant_research'}, not cur_value)
end)

-- ----------------------------------------------------------------------------------------------------
-- CHEATS WINDOW

on_event({defines.events.on_gui_checked_state_changed, defines.events.on_gui_confirmed}, function(e)
    local params = string.split(e.element.name, '-')
    local player = util.get_player(e)
    if params[1] == 'im_cheats' and (params[4] == 'checkbox' or params[4] == 'textfield') and cheats.is_valid(params[2], params[3]) then
        local param = e.element.type == 'checkbox' and 'state' or 'text'
        cheats.update(player, {params[2], params[3]}, e.element[param])
        cheats_gui.refresh(player, mod_gui.get_frame_flow(player))
    end
end)

on_event(defines.events.on_player_toggled_map_editor, function(e)
    local player = util.get_player(e)
    cheats_gui.refresh(player, mod_gui.get_frame_flow(player))
end)

-- ----------------------------------------------------------------------------------------------------
-- CHEATS

on_event({defines.events.on_player_created, defines.events.on_force_created, defines.events.on_surface_created}, function(e)
    if e.player_index then
        cheats.apply_defaults('player', util.get_player(e))
    elseif e.surface_index then
        cheats.apply_defaults('surface', game.surfaces[e.surface_index])
    elseif e.force then
        cheats.apply_defaults('force', e.force)
    end
end)