-- ----------------------------------------------------------------------------------------------------
-- INFINITY MODE 0.5.0 MIGRATIONS

if global.mod_enabled then
    -- add cheats GUI position to all player tables
    for i,p in pairs(game.players) do
        global.players[i].cheats_gui.location = p.gui.screen.im_cheats_window and p.gui.screen.im_cheats_window.location or {x=0,y=(44*p.display_scale)}
    end
end