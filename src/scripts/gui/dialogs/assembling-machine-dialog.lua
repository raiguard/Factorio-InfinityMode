-- PLAYING WITH THE ASSEMBLING MACHINE DIALOG, MIGHT DELETE LATER

require('scripts/util/util')

local on_event = require('__stdlib__/stdlib/event/event').register
local gui = require('__stdlib__/stdlib/event/gui')

local entity_camera = require('scripts/gui/elements/entity-camera')
local titlebar = require('scripts/gui/elements/titlebar')
local toolbar = require('scripts/gui/elements/toolbar')

local ingredients = {
    {8, 'item/steel-plate', 'inventory_slot_button_red'},
    {21, 'item/iron-gear-wheel', 'inventory_slot_button_green'},
    {12, 'item/electronic-circuit'},
    {1, 'item/pipe', 'inventory_slot_button_red'},
    {10, 'item/stone-brick'}
}

local inventory = {
    {50, 'item/steel-chest'},
    {100, 'item/fast-transport-belt'},
    {100, 'item/fast-transport-belt'},
    {100, 'item/fast-transport-belt'},
    {50, 'item/fast-underground-belt'},
    {50, 'item/fast-splitter'},
    {50, 'item/long-handed-inserter'},
    {50, 'item/fast-inserter'},
    {50, 'item/stack-inserter'},
    {50, 'item/medium-electric-pole'},
    {50, 'item/big-electric-pole'},
    {50, 'item/substation'},
    {100, 'item/pipe'},
    {50, 'item/pipe-to-ground'},
    {10, 'item/pump'},
    {100, 'item/rail'},
    {100, 'item/rail'},
    {100, 'item/rail'},
    {50, 'item/rail-signal'},
    {50, 'item/rail-chain-signal'},
    {49, 'item/logistic-chest-passive-provider'},
    {34, 'item/logistic-chest-storage'},
    {50, 'item/logistic-chest-buffer'},
    {35, 'item/logistic-chest-requester'},
    {10, 'item/roboport'},
    {1, 'item/roboport'},
    {50, 'item/small-lamp'},
    {50, 'item/solar-panel'},
    {50, 'item/electric-mining-drill'},
    {50, 'item/assembling-machine-2'},
    {10, 'item/beacon'},
    {10, 'item/beacon'},
    {100, 'item/iron-plate'},
    {100, 'item/copper-plate'},
    {100, 'item/steel-plate'},
    {10, 'item/battery'},
    {100, 'item/iron-gear-wheel'},
    {200, 'item/electronic-circuit'},
    {132, 'item/advanced-circuit'},
    {58, 'item/processing-unit'},
    {100, 'item/stone-wall'},
    {50, 'item/laser-turret'},
    {50, 'item/iron-ore'}
}

local function create(player, entity)
    local main_frame = player.gui.center.add{type='frame', name='amd_frame', style='dialog_frame', direction='vertical'}
    titlebar.create(main_frame, 'amd_titlebar', {label='Assembling machine 3',buttons ={
        {name='info', sprite='im_sprite_info', hovered_sprite='im_sprite_info_black', clicked_sprite='im_sprite_info_black'},
        {name='close', sprite='utility/close_white', hovered_sprite='utility/close_black', clicked_sprite='utility/close_black'}
    }})

    local main_flow = main_frame.add{type='flow', name='amd_main_flow', direction='vertical'}
    main_flow.style.vertical_spacing = 12

    local upper_flow = main_flow.add{type='flow', name='amd_upper_flow', direction='horizontal'}
    upper_flow.style.horizontal_spacing = 12

    -- PREVIEW AND MODULES
    local upper_left_flow = upper_flow.add{type='flow', name='amd_upper_left_flow', direction='vertical'}
    upper_left_flow.style.vertical_spacing = 10
    entity_camera.create(upper_left_flow, 'amd_camera', 120, {player=player, entity=entity, camera_offset={0,-0.15}})
    local module_flow = upper_left_flow.add{type='flow', name='amd_module_flow', direction='horizontal'}
    module_flow.style.horizontally_stretchable = true
    module_flow.style.vertically_stretchable = true
    module_flow.style.horizontal_align = 'center'
    module_flow.style.vertical_align = 'center'
    local module_table = module_flow.add{type='table', name='amd_module_table', style='slot_table', column_count=2}
    for i=1,4 do
        module_table.add{
            type = 'sprite-button',
            name = 'amd_module_button_' .. i,
            style = 'inventory_slot_button',
            sprite = 'item/speed-module-2'
        }
    end

    -- RECIPE FRAME
    local recipe_frame = upper_flow.add{type='frame', name='amd_recipe_frame', style='window_content_frame_packed', direction='vertical'}
    recipe_frame.style.vertically_stretchable = true
    recipe_frame.style.minimal_width = 309
    recipe_frame.style.minimal_height = 200
    local toolbar = toolbar.create(recipe_frame, 'amd_recipe_toolbar', {
        label = 'Oil Refinery',
        buttons = {
            {name='change', sprite='utility/reset', tooltip='Change recipe'}
        }
    })

    local recipe_content_flow = recipe_frame.add{type='flow', name='amd_recipe_content_flow', direction='vertical'}
    recipe_content_flow.style.padding = 8
    recipe_content_flow.style.horizontally_stretchable = true
    recipe_content_flow.style.vertically_stretchable = true
    local ingredients_table = recipe_content_flow.add{type='table', name='amd_ingredients_table', style='slot_table', column_count=7}
    for i=1,#ingredients do
        ingredients_table.add{
            type = 'sprite-button',
            name = 'amd_ingredients_button_' .. i,
            style = ingredients[i][3] or 'inventory_slot_button',
            sprite = ingredients[i][2],
            number = ingredients[i][1]
        }
    end

    recipe_content_flow.add{type='flow', name='TEMP_vertflow', style='invisible_vertical_filler', direction='vertical'}

    local products_flow = recipe_content_flow.add{type='flow', name='amd_products_flow', direction='horizontal'}
    products_flow.add{type='flow', name='amd_products_filler', style='invisible_horizontal_filler'}
    local products_table = products_flow.add{type='table', name='amd_products_table', style='slot_table', column_count=7}
    products_table.add{type='sprite-button', name='amd_products_button_1', style='inventory_slot_button_green', sprite='item/oil-refinery', number='5'}

    local progress_bar_flow = recipe_content_flow.add{type='flow', name='amd_progress_flow', directiion='horizontal'}
    progress_bar_flow.style.horizontal_spacing = 8
    progress_bar_flow.style.vertical_align = 'center'
    local progress_bar = progress_bar_flow.add{type='progressbar', name='amd_progress_bar', value=0.43}
    progress_bar.style.horizontally_stretchable = true
    progress_bar_flow.add{type='label', name='amd_progress_label', caption='43%'}

    local bonus_bar_flow = recipe_content_flow.add{type='flow', name='amd_bonus_flow', directiion='horizontal'}
    bonus_bar_flow.style.horizontal_spacing = 8
    bonus_bar_flow.style.vertical_align = 'center'
    local bonus_bar = bonus_bar_flow.add{type='progressbar', name='amd_bonus_bar', style='bonus_progressbar', value=0.81}
    bonus_bar.style.horizontally_stretchable = true
    bonus_bar_flow.add{type='label', name='amd_bonus_label', caption='81%'}

    -- INVENTORY
    local inventory_frame = main_flow.add{type='frame', name='amd_inventory_frame', style='window_content_frame', direction='vertical'}
    inventory_frame.style.padding = 12
    local inventory_label = inventory_frame.add{type='label', name='amd_inventory_label', style='heading_3_label', caption='Inventory'}
    inventory_label.style.bottom_margin = 4
    local inventory_flow = inventory_frame.add{type='flow', name='amd_inventory_flow', direction='horizontal'}
    inventory_flow.style.horizontal_align = 'center'
    inventory_flow.style.horizontally_stretchable = true
    local inventory_table = inventory_flow.add{type='table', name='amd_inventory_table', style='slot_table', column_count=10}
    for i=1,#inventory do
        inventory_table.add{
            type = 'sprite-button',
            name = 'amd_inventory_button_' .. i,
            style = inventory[i][3] or 'inventory_slot_button',
            sprite = inventory[i][2],
            number = inventory[i][1]
        }
    end
    for i=#inventory + 1,84 do
        inventory_table.add{
            type = 'sprite-button',
            name = 'amd_inventory_button_' .. i,
            style = 'inventory_slot_button'
        }
    end
    inventory_table.add{type='sprite-button', name='amd_inventory_button_85', style='inventory_slot_button_blue', sprite = 'item/construction-robot', number=50}
    inventory_table.add{type='sprite-button', name='amd_inventory_button_86', style='inventory_slot_button_blue', sprite = 'item/construction-robot', number=50}
    inventory_table.add{type='sprite-button', name='amd_inventory_button_87', style='inventory_slot_button_blue', sprite = 'item/cliff-explosives', number=20}
    inventory_table.add{type='sprite-button', name='amd_inventory_button_88', style='inventory_slot_button_blue', sprite = 'item/flamethrower-ammo', number=82}
    inventory_table.add{type='sprite-button', name='amd_inventory_button_89', style='inventory_slot_button_blue', sprite = 'item/repair-pack', number=100}
    inventory_table.add{type='sprite-button', name='amd_inventory_button_90', style='inventory_slot_button_blue', sprite = 'item/uranium-rounds-magazine', number=200}

    return main_frame
end

on_event(defines.events.on_gui_opened, function(e)
    if e.entity and e.entity.name == 'assembling-machine-3' then
        local player = get_player(e)
        player.opened = create(player, e.entity)
    end
end)

on_event(defines.events.on_gui_closed, function(e)
    local player = get_player(e)
    if e.gui_type == defines.gui_type.custom and e.element.name == 'amd_frame' then
        player.gui.center.amd_frame.destroy()
        player.opened = nil
    end
end)

gui.on_click('amd_titlebar_button_close', function(e)
    e.element.parent.parent.destroy()
    get_player(e).opened = nil
end)