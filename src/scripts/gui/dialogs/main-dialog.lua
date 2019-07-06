-- ELEMENTS


-- Create player GUI
function player_gui_init(player)
    local button_flow = mod_gui.get_button_flow(player)
    if not button_flow.cps_button_toggle_main_dialog then
        button_flow.add{
            type = 'button',
            name = 'cps_button_toggle_main_dialog',
            caption = {'mod-gui.cps-button-caption'},
            style = mod_gui.button_style,
            mouse_button_filter = {'left'}
        }
    end

    if not button_flow.cps_DEBUG_GLOBAL_INIT then
        button_flow.add{
            type = 'button',
            name = 'cps_DEBUG_GLOBAL_INIT',
            caption = 'GLOBAL_INIT',
            style = mod_gui.button_style,
            mouse_button_filter = {'left'}
        }
    end

    toggle_mod_gui_button(player)
end

-- Toggles the visibility of the editor interface button in the mod button flow
function toggle_mod_gui_button(player)
    local enable = player.mod_settings['show-mod-gui-button'].value
    mod_gui.get_button_flow(player).cps_button_toggle_main_dialog.visible = enable
end

-- Toggles the visibility of the editor interface
function toggle_main_dialog(player)
    local editor_frame = player.gui.center.cps_main_dialog_frame

    if editor_frame and editor_frame.visible then
        editor_frame.visible = false
    elseif editor_frame and editor_frame.visible == false then
        editor_frame.visible = true
    else
        create_main_dialog(player.gui.center)
    end
end

-- Creates the main dialog frame
function create_main_dialog(center_gui)
    local main_frame = center_gui.add {
        type = 'frame',
        name = 'cps_main_dialog_frame',
        style = 'dialog_frame',
        direction = 'vertical'
    }

    create_titlebar(main_frame, 'main_dialog_titlebar', {
        label = {'gui-main-dialog.titlebar-browser-label'},
        buttons = {
            {
                name = 'info',
                sprite = 'cps_sprite_info'
            },
            {
                name = 'settings',
                sprite = 'cps_sprite_gear'
            },
            {
                name = 'close',
                sprite = 'utility/close_white'
            }
        }
    })

    local content_frame = main_frame.add {
        type = 'frame',
        name = 'cps_main_dialog_content_frame',
        style = 'dialog_content_deep_frame',
        direction = 'vertical'
    }

    local browser_page = create_browser_page(content_frame, 'browser')
    browser_page.visible = true
    local editor_page = create_editor_page(content_frame, 'editor')
    editor_page.visible = false
end