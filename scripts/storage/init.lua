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

    register = function()
        require("scripts/storage/cell.lua").register();
        require("scripts/storage/cell_chest.lua").register();
        require("scripts/storage/drive_bay.lua").register();
    end
}