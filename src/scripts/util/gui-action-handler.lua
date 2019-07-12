local script_data =
{
  gui_actions = {}
}

--Global scope, so all scripts can access it.
Gui_action = {}

Gui_action.add = function(gui, action)
  script_data.gui_actions[gui.player_index] = script_data.gui_actions[gui.player_index] or {}
  script_data.gui_actions[gui.player_index][gui.index] = action
end

Gui_action.destroy = function(gui)
  script_data.gui_actions[gui.player_index] = script_data.gui_actions[gui.player_index] or {}
  script_data.gui_actions[gui.player_index][gui.index] = nil
  for k, child in pairs (gui.children) do
    Gui_action.destroy(child)
  end
  gui.destroy()
end

local on_gui_event = function(event)
  local gui = event.element
  if not (gui and gui.valid) then return end

  local player_index = gui.player_index
  local events = script_data.gui_actions[player_index]
  if not events then return end

  local action = events[gui.index]

  if action then
    action.func(event, action)
  end

end

local events =
{
  [defines.events.on_gui_click] = on_gui_event,
  [defines.events.on_gui_value_changed] = on_gui_event,
  [defines.events.on_gui_selection_state_changed] = on_gui_event,
  [defines.events.on_gui_elem_changed] = on_gui_event,
  [defines.events.on_gui_text_changed] = on_gui_event
}

local lib = {}

lib.on_load = function()
  script_data = global.gui_action_handler or script_data
end

lib.on_init = function()
  global.gui_action_handler = global.gui_action_handler or script_data
end

lib.get_events = function()
  return events
end

return lib
