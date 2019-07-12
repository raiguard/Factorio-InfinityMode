local toolbar = {}

function toolbar.create(parent, name, data)
    local frame = parent.add {type='frame', name=name..'_frame', style='subheader_frame'}
    if data.label then frame.add{type='label', name=name..'_label', style='subheader_caption_label', caption=data.label} end
    frame.add{type='flow', name=name..'_filler', style='invisible_horizontal_filler'}
    
    if data.buttons then
        local buttons = data.buttons
        for i=1, #buttons do
            frame.add {
                type = 'sprite-button',
                name = name .. '_button_' .. buttons[i].name,
                style = buttons[i].style or 'tool_button',
                sprite = buttons[i].sprite,
                tooltip = buttons[i].tooltip
            }
        end
    end

    return frame
end

return toolbar