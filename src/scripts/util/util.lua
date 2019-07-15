local on_event = require('__stdlib__/stdlib/event/event').register

local util = {}

-- ----------------------------------------------------------------------------------------------------
-- GENERAL

function util.get_player(obj)
    if obj.player_index then return game.players[obj.player_index] end
end

-- ----------------------------------------------------------------------------------------------------
-- GUI

-- close center GUI on escape
on_event(defines.events.on_gui_closed, function(e)
    local player = util.get_player(e)
    local center_gui = util.get_center_gui(player)
    if center_gui and center_gui.element == e.element then
        util.close_center_gui(player)
    end
end)

-- handle window close buttons
on_event(defines.events.on_gui_click, function(e)
    local player = util.get_player(e)
    local element = e.element
    local center_gui = util.get_center_gui(player)
    if center_gui and center_gui.close_button == element then
        util.close_center_gui(player)
    end
end)

function util.set_center_gui(player, data, keep_previous)
    -- data table must contain ELEMENT, which is the root element of the open GUI (the frame, most of the time)
    -- other data is specific to each gui
    local global_data = util.get_center_gui(player)
    -- if another gui is currently open, destroy it
    if global_data and not keep_previous then
        global_data.element.destroy()
    end
    util.player_table(player).center_gui = data
    player.opened = data.element
end

function util.get_center_gui(player)
    return util.player_table(player).center_gui
end

function util.close_center_gui(player)
    local center_gui = util.get_center_gui(player)
    center_gui.element.destroy()
    center_gui = nil
    player.opened = nil
end

-- ----------------------------------------------------------------------------------------------------
-- GLOBAL

on_event('on_init', function(e)
    global.players = {}
end)

on_event(defines.events.on_player_joined_game, function(e)
    local data = {}
    global.players[e.player_index] = data
end)

function util.player_table(player) return global.players[player.index] end

-- ----------------------------------------------------------------------------------------------------

return util