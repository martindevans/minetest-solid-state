local network = require("scripts/network/init.lua");
local names = require("scripts/names.lua");
local storage = require("scripts/storage/init.lua");

local drive_bay_okay = { name = names.drive_bay() .. "_ok" };
local drive_bay_warn = { name = names.drive_bay() .. "_warn" };
local drive_bay_crit = { name = names.drive_bay() .. "_critical" };

local def = {
    on_construct = function(pos)
        local meta = minetest.get_meta(pos);

        local spec = "invsize[11,5;]" .. "list[context;main;0,0;1,1;]" .. "list[current_player;main;3,0;8,4;]";
        meta:set_string("formspec", spec);

        --Initialize inventory sizes. Main contains the cell, cell contains the items in the cell
        local inv = meta:get_inventory();
        inv:set_size("main", 1);
        inv:set_size("cell", 0);
    end,

    --Only allow items with `solid_state.storage_cell` in their item definition
    allow_metadata_inventory_put = storage.allow_metadata_inventory_put_cell_only,

    --A cell has been inserted into the chest, create a child inventory and unpack the cell into it
    on_metadata_inventory_put = function(pos, listname, index, stack, player)

        --We don't need to do anything special to insert into the non-main inventory, early exit
        if listname ~= "main" then return; end

        --Get node info
        local node_meta = minetest.get_meta(pos);
        local node_inv = node_meta:get_inventory();

        local cell_def = stack:get_definition();

        --Materialize cell inventory into inventory of this node
        local list, stacks_count, stacks_full = cell_def.solid_state.storage_cell.get_cell_inventory_extra(stack:get_meta());
        node_inv:set_list("cell", list);

        --Check if there is space to insert a new item into the inventory. Update drive indicator light depending on if all stacks are used
        if stacks_count == cell_def.solid_state.storage_cell.capacity then
            if stacks_full then
                minetest.swap_node(pos, drive_bay_crit);
            else
                minetest.swap_node(pos, drive_bay_warn);
            end
        else
            minetest.swap_node(pos, drive_bay_okay);
        end

        minetest.chat_send_all("Inserted cell into slot " .. index);

        --[[ --Get node info
        local node_meta = minetest.get_meta(pos);
        local node_inv = node_meta:get_inventory();

        --Materialize cell inventory into inventory of this node
        node_inv:set_list("cell", stack:get_definition().solid_state.storage_cell.get_cell_inventory(stack:get_meta()));

        --Change the form to display the inventory for the given cell
        node_meta:set_string("formspec", cell_chest_formspec_cell()); ]]
    end,

    allow_metadata_inventory_take = function(pos, listname, index, stack, player)

        --Allow all removals from non-main inventory
        if listname ~= "main" then return stack:get_count(); end

        minetest.swap_node(pos, { name = names.drive_bay() });

        minetest.chat_send_all("Taken cell from slot " .. index);

        return 1;

    end
}

local function register_drive_bay(name, front)
    minetest.register_node(name, {
        tiles = {
            "solid_state_drive_bay_side.png",
            "solid_state_drive_bay_side.png",
            "solid_state_drive_bay_side.png",
            "solid_state_drive_bay_side.png",
            "solid_state_drive_bay_side.png",
            front
        },
        on_construct = def.on_construct,

        allow_metadata_inventory_put = def.allow_metadata_inventory_put,
        on_metadata_inventory_put = def.on_metadata_inventory_put,

        allow_metadata_inventory_take = def.allow_metadata_inventory_take,
    });
end

return {
    register = function()
        register_drive_bay(names.drive_bay(),   "solid_state_drive_bay_front_nodrive.png");
        register_drive_bay(drive_bay_okay.name, "solid_state_drive_bay_front_ok.png");
        register_drive_bay(drive_bay_warn.name, "solid_state_drive_bay_front_warn.png");
        register_drive_bay(drive_bay_crit.name, "solid_state_drive_bay_front_critical.png");
    end
}