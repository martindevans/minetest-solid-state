local names = require("scripts/names.lua");

local function get_cell_inventory_extra(stack_meta)
    local serialized_cell_inv = stack_meta:get_string("solid_state.storage_cell.serialized_inventory");
    if serialized_cell_inv ~= "" then
        local d = minetest.deserialize(serialized_cell_inv);
        local stack_count = 0;
        local full = true;
        for k, v in pairs(d) do
            local stack = ItemStack(v);
            d[k] = stack;
            stack_count = stack_count + 1;
            if stack:get_free_space() ~= 0 then full = false; end
        end
        return d, stack_count, full;
    end
    return {}, 0, true;
end

local function get_cell_inventory(stack_meta)
    local ex = get_cell_inventory_extra(stack_meta);
    return ex;
end

local function set_cell_inventory(stack_meta, inv_list)
    local wip = {};
    for k, v in pairs(inv_list) do
        wip[k] = v:to_table();
    end
    local serialized = minetest.serialize(wip);

    stack_meta:set_string("solid_state.storage_cell.serialized_inventory", serialized);
end

local function register_cell(kb)
    minetest.register_craftitem(names.cell(kb), {
        description = kb .. "K Storage Cell",
        inventory_image = "solid_state_cell_" .. kb .. "k.png",
        stack_max = 1,
        solid_state = {
            storage_cell = {
                capacity = kb,
                get_cell_inventory = get_cell_inventory,
                get_cell_inventory_extra = get_cell_inventory_extra,
                set_cell_inventory = set_cell_inventory,
            }
        }
    });
end

return {
    register_cell = register_cell,
    
    register = function()
        register_cell(1);
        register_cell(4);
        register_cell(16);
        register_cell(64);
        register_cell(256);
    end
}