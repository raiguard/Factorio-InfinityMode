-- ----------------------------------------------------------------------------------------------------
-- INFINITY MODE 0.2.0 MIGRATIONS

for _,t in pairs(global.wagons) do
    -- change global naming scheme from 'ref' to 'proxy'
    t.proxy = t.ref
    t.proxy_inv = t.ref_inv
    t.proxy_fluidbox = t.ref_fluidbox
    t.ref = nil
    t.ref_inv = nil
    t.ref_fluidbox = nil
    -- convert wagon proxies to non-interactable versions and move them to their wagons
    local new_proxy = t.wagon.surface.create_entity{
        name = 'infinity-wagon-'..(t.wagon.name == 'infinity-cargo-wagon' and 'chest' or 'pipe'),
        position = t.wagon.position,
        force = t.wagon.force
    }
    if new_proxy.type == 'infinity-container' then
        new_proxy.infinity_container_filters = t.proxy.infinity_container_filters
    else
        new_proxy.fluidbox = t.proxy.fluidbox
    end
    t.proxy_inv = new_proxy.get_inventory(defines.inventory.cargo_wagon)
    t.proxy_fluidbox = new_proxy.fluidbox
    t.proxy.destroy()
    t.proxy = new_proxy
end

-- delete surface of holding
if game.surfaces['soh'] then game.delete_surface('soh') end

-- mod enabled metadata
if global.mod_enabled == nil then
    global.mod_enabled = true
    global.dialog_shown = true
end