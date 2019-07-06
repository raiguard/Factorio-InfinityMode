local on_event = require('__stdlib__/stdlib/event/event').register

on_event('on_init', function(e)
    global.players = {}
end)

on_event(defines.events.on_player_joined_game, function(e)
    global.players[e.player_index] = {}
end)

function player_table(player) return global.players[player.index] end