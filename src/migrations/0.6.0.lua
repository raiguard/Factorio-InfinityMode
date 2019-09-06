-- ----------------------------------------------------------------------------------------------------
-- INFINITY MODE 0.6.0 MIGRATIONS

if global.mod_enabled then
    -- make sure each player has a cheats window in global, because it was forgotten in the v0.5.0 migrations
    for i,p in pairs(game.players) do
        global.players[i].cheats_gui.window = p.gui.screen.im_cheats_window
    end
    -- make all tesseract chests operable again!
    for _,surface in pairs(game.surfaces) do
        for _,entity in pairs(surface.find_entities_filtered{name={'tesseract-chest', 'tesseract-chest-passive-provider', 'tesseract-chest-storage'}}) do
            if entity.operable == false then entity.operable = true end
        end
    end
end