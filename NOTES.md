# Infinity Mode Notes

## Cheats table structure
Each cheat in the cheat table has the following parameters:
- `type` (_string_) - One of _toggle_, _number_, or _action_.
- `defaults` (_dictionary string_ -> (_number_ or _boolean_)) - Default values (see below).
- `in_god_mode` (_boolean_) - If the cheat is applicable / editable in **God Mode**.
- `in_editor` (_boolean_) - If the cheat is applicable / editable while in the **Map Editor**.
- `functions` (_table_) - A table of functions for the cheat (see below).

### Defaults
Each cheat has several defaults:
- `on` - The cheat's value when set to _default on_.
- `off` - The cheat's value when set to _default off_.
- `lite` (optional) - The cheat's initial value when _Lite Mode_ is enabled. If left out, the cheat's **get_value()** function will be used to set the initial value.
- `full` (optional) - The cheat's initial value when _Full Mode_ is enabled. If left out, the cheat's **get_value()** function will be used to set the initial value.

### Cheat functions table
Each cheat has a `functions` parameter that contains a table of functions:
- `get_value(obj, cheat, cheat_global)` - Must return the current value of the cheat.
- `value_changed(obj, cheat, cheat_global, new_value)` - When the player changes the cheat setting through the GUI.
- `setup_global(obj, default_value)` (optional) - Returns the initial value of the cheat's global table for the object.
- `setup_global_global(default_value)` (optional) - Returns the initial value of the cheat's global table.

## Player table structure
- player_index
    - open_gui
        - element (LuaGuiElement)
        - location (concepts.position)
        - close_button (LuaGuiElement or nil)
        - data_to_destroy (string or nil)
    - cheats_gui
        - cur_player (LuaPlayer)
        - cur_force (LuaForce)
        - cur_surface (LuaSurface)
        - cur_tab (int)
    - ia_gui
        - entity (LuaEntity)
        - mode_dropdown (LuaGuiElement)
        - priority_dropdown (LuaGuiElement)
        - slider (LuaGuiElement)
        - slider_textfield (LuaGuiElement)
        - slider_dropdown (LuaGuiElement)
        - prev_textfield_value (int)