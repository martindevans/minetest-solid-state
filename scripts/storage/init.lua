local names = require("scripts/names.lua");

local function get_cell_inventory(stack_meta)
    local serialized_cell_inv = stack_meta:get_string("solid_state.storage_cell.serialized_inventory");
    if serialized_cell_inv ~= "" then
        local d = minetest.deserialize(serialized_cell_inv);
        for k, v in pairs(d) do
            d[k] = ItemStack(v);
        end
        return d;
    end
    return {};
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
                set_cell_inventory = set_cell_inventory,
            }
        }
    });
end

local function allow_metadata_inventory_put_cell_only(pos, listname, index, stack, player)
    --If we're inserting into the cell then just allows the insertion (up to max size)
    if listname ~= "main" then
        return math.min(stack:get_stack_max() - stack:get_count(), stack:get_count());
    end

    --Early exit if this is not a solid_state item
    local item_def = stack:get_definition();
    local ss_data = item_def.solid_state;
    if not ss_data then
        return 0;
    end;

    --Early exit if it is not a cell
    local cell_data = ss_data.storage_cell;
    if not cell_data then
        return 0;
    end;

    --Move is allowed
    return 1;
end

return {
    --Expose a helper function that only allows putting cells into the main inventory
    allow_metadata_inventory_put_cell_only = allow_metadata_inventory_put_cell_only,

    --Expose a helper fucntion to register new cells
    register_cell = register_cell,

    register = function()
        require("scripts/storage/cell.lua").register();
        require("scripts/storage/cell_chest.lua").register();
        require("scripts/storage/drive_bay.lua").register();
    end
}