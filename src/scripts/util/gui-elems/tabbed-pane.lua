local tabbed_pane = {}

function tabbed_pane.create(parent, name, data)
    local prefix = name .. '_'
    local list_box = parent.add{type='list-box', name=prefix..'tabs_list', style='tab_listbox', items=data.items, selected_index=data.selected_index or 1}
    local tab_frame = parent.add{type='frame', name=prefix..'tab_frame', style='tab_content_frame'}
    tab_frame.style.horizontally_stretchable = true
    tab_frame.style.vertically_stretchable = true
    tab_frame.style.width = data.width or nil
    tab_frame.style.height = data.height or nil

    local pane
    if use_scroll then
        pane = tab_frame.add{type='scroll-pane', name=prefix..'pane'}
        pane.style.horizontal_scroll_policy = 'never'
    else
        pane = tab_frame.add{type='flow', name=prefix..'pane', direction='vertical'}
    end
    pane.style.horizontally_stretchable = true
    pane.style.vertically_stretchable = true

    return pane
end

return tabbed_pane