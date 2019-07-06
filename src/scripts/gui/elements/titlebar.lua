function create_titlebar(parent, name, data)
    local prefix = 'cps_' .. name .. '_'

    local titlebar_flow = parent.add {
        type = 'flow',
        name = prefix .. 'flow',
        style = 'titlebar_flow'
    }

    if data.label then
        titlebar_flow.add {
            type = 'label',
            name = prefix .. 'label',
            style = 'frame_title',
            caption = data.label
        }
    end

    titlebar_flow.add {
        type = 'frame',
        name = prefix .. 'filler',
        style = 'titlebar_filler'
    }

    if data.buttons then
        local buttons = data.buttons
        for i=1, #buttons do
            titlebar_flow.add {
                type = 'sprite-button',
                name = prefix .. 'button_' .. buttons[i].name,
                style = 'close_button',
                sprite = buttons[i].sprite
            }
        end
    end
end