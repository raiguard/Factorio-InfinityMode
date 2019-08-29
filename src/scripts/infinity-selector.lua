-- ----------------------------------------------------------------------------------------------------
-- INFINITY SELECTOR CONTROL SCRIPTING

local area = require('__stdlib__/stdlib/area/area')
local conditional_event = require('scripts/util/conditional-event')
local event = require('__stdlib__/stdlib/event/event')
local direction = require('__stdlib__/stdlib/area/direction')
local gui = require('__stdlib__/stdlib/event/gui')
local position = require('__stdlib__/stdlib/area/position')
local table = require('__stdlib__/stdlib/utils/table')
local tile = require('__stdlib__/stdlib/area/tile')
local on_event = event.register
local util = require('scripts/util/util')
local version = require('__stdlib__/stdlib/vendor/version')

-- GUI ELEMENTS
local titlebar = require('scripts/util/gui-elems/titlebar')

-- local selector_gui = require('scripts/selector-gui')

-- ----------------------------------------------------------------------------------------------------
-- UTILITIES



-- ----------------------------------------------------------------------------------------------------
-- GUI

local selector_gui = {}

function selector_gui.create(player, data)
    -- basic structure
    local window = player.gui.screen.add{type='frame', name='im_selector_window', style='dialog_frame', direction='vertical'}
    local titlebar = titlebar.create(window, 'im_selector_titlebar', {
        label={'gui-selector.window-title'},
        draggable = true,
        buttons={
            {
                name = 'close',
                sprite = 'utility/close_white',
                hovered_sprite = 'utility/close_black',
                clicked_sprite = 'utility/close_black'
            }
    }})
    local main_flow = window.add{type='flow', name='im_selector_main_flow', direction='horizontal'}
    main_flow.style.horizontal_spacing = 12
    local groups_frame = main_flow.add{type='frame', name='im_selector_groups_frame', style='inside_deep_frame', direction='vertical'}
    groups_frame.style.width = 400
    groups_frame.style.height = 500
    local settings_frame = main_flow.add{type='frame', name='im_selector_settings_frame', style='window_content_frame', direction='vertical'}
    settings_frame.style.width = 400
    settings_frame.style.height = 500
    -- center and set as open GUI
    window.force_auto_center()
    util.set_open_gui(player, window, titlebar.children[3])
end

-- ----------------------------------------------------------------------------------------------------
-- LISTENERS

-- when a player selects an area
on_event({defines.events.on_player_selected_area, defines.events.on_player_alt_selected_area}, function(e)
    if not global.mod_enabled then return end
    if e.item ~= 'infinity-selector' then return end
    if #e.entities == 0 then return end
    local player = util.get_player(e)
    -- if the player is already editing
    if player.gui.screen.im_selector_window then
        -- create warning message
        player.surface.create_entity{
            name = 'flying-text',
            position = area.center(e.area),
            text = {'flying-text.selector-already-editing'},
            render_player_index = e.player_index
        }
    else
        -- create data
        local entities = e.entities
        local data = {}
        -- create GUI
        selector_gui.create(player)
    end
end)