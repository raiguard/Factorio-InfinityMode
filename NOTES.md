# Infinity Mode Notes

## Cheats table structure
Each cheat in the cheat table has the following parameters:
- `name` (_string_) - The internal cheat name.
- `type` (_string_) - One of _toggle_, _number_, or _action_.
- `default` (_boolean_, _number_, _string_) - The default value of the . <!-- - `default_lite` - The default value when initialized in **lite mode** -->
- `in_god_mode` (_boolean_) - If the cheat is applicable / editable in **God Mode**.
- `caption` (_LocalisedString_) - The name of the cheat in the GUI.
- `tooltip` (_LocalisedString_) - The tooltip of the cheat in the GUI.
- `functions` (_table_) - A table of functions for the cheat (see below).

When a player's cheats are initialized using the `cheats.create()` function, the following parameters are added to each cheat table:
- `cur_value` (_boolean_, _number_, _string_) - The current value of the cheat as set in the GUI

### Cheat functions table
Each cheat has a `functions` parameter that contains a table of functions. The following are expected and mandatory functions for each cheat:
- `toggled_on` - When this toggle cheat is enabled.
- `toggled_off` - When this toggle cheat is disabled.
- `value_changed(new_value)` - When this number or string cheat's value changes. The cheat's `value` parameter is set to the return value of this function.
- `god_mode_entered` - When the player enters **God Mode**. Only necessary if this cheat has `in_god_mode` enabled.
- `god_mode_left` - When the player leaves **God Mode**. Only necessary if this cheat has `in_god_mode` enabled.

Beyond these, any functions defined will be event names from the `defines.events` table. To use these event functions, each function must be registered with its event during one of the above mentioned required events, using the `util.conditional_event` module. The `cheats` module contains a function to register / unregister all non-required functions of a specific cheat. However, for the sake of optimization and reducing performance impact, it is recommended that a cheat's event handlers only be registered when they are individually needed.