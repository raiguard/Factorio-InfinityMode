-- set tesseract chest inventory size based on the number of item prototypes
local slot_count = table_size(data.raw['item'])
for _,p in pairs(data.raw['infinity-container']) do
    if p.name:find('tesseract') then
        p.inventory_size = slot_count
    end
end