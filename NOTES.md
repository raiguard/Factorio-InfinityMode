# Infinity Mode Notes

## Cheats table structure
Each cheat in the cheat table has the following parameters:
- `name` (_string_) - The internal cheat name.
- `type` (_string_) - One of _toggle_, _number_, or _action_.
- `default` (_boolean_, _number_, _string_) - The default value of the . <!-- - `default_lite` - The default value when initialized in **lite mode** -->
- `in_god_mode` (_boolean_) - If the cheat is applicable / editable in **God Mode**.
- `in_editor` (_boolean_) - If the cheat is applicable / editable while in the **Map Editor**.
- `caption` (_LocalisedString_) - The name of the cheat in the GUI.
- `tooltip` (_LocalisedString_) - The tooltip of the cheat in the GUI.
- `functions` (_table_) - A table of functions for the cheat (see below).

### Cheat functions table
Each cheat has a `functions` parameter that contains a table of functions. The following are expected and mandatory functions for each cheat:
- `get_value(player)` - Must return the current value of the cheat.
- `value_changed(new_value)` - When the player changes the cheat setting through the GUI. The cheat's `value` parameter is set to the return value of this function.
<!-- - `god_mode_entered` - When the player enters **God Mode**. Only necessary if this cheat has `in_god_mode` enabled.
- `god_mode_left` - When the player leaves **God Mode**. Only necessary if this cheat has `in_god_mode` enabled. -->

Beyond these, any functions defined will be event names from the `defines.events` table. To use these event functions, each function must be registered with its event during one of the above mentioned required events, using the `util.conditional_event` module. The `cheats.register_all(functions)` function will register all extra functions for that cheat, and `cheats.unregister_all(functions)` will do the opposite.