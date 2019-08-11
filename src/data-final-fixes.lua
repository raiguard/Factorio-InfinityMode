local to_check = {
    'ammo',
    'armor',
    'blueprint',
    'blueprint-book',
    'capsule',
    'copy-paste-tool',
    'deconstruction-item',
    'gun',
    'item',
    'item-with-entity-data',
    'item-with-inventory',
    'item-with-label',
    'item-with-tags',
    'mining-tool',
    'module',
    'rail-planner',
    'repair-tool',
    'selection-tool',
    'tool',
    'upgrade-item'
}
-- start with four extra slots to account for inserter interactions
local slot_count = 4
for _,n in pairs(to_check) do
    slot_count = slot_count + table_size(data.raw[n])
end
-- apply to tesseract chests
for _,p in pairs(data.raw['infinity-container']) do
    if p.name:find('tesseract') then
        -- set tesseract chest inventory size to the number of item prototypes
        p.inventory_size = slot_count
    end
end