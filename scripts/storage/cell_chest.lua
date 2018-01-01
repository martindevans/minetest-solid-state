local storage = require("scripts/storage/init.lua");
local connectivity = require("scripts/network/connectivity.lua");
local names = require("scripts/names.lua");

local function cell_chest_formspec_no_cell() return "invsize[8,8;]list[context;main;1,0;1,1;]list[current_player;main;0,4;8,4;]"; end;
local function cell_chest_formspec_cell() return cell_chest_formspec_no_cell() .. "list[context;cell;2,0;3,3;]"; end;

function register_cell_chest()
    connectivity.register_node(names.cell_chest(), {
        tiles = {
            "solid_state_cell_chest_top.png",
            "solid_state_cell_chest_bot.png",
            "solid_state_cell_chest_side.png",
            "solid_state_cell_chest_side.png",
            "solid_state_cell_chest_side.png",
            "solid_state_cell_chest_front.png"
        },

        on_construct = function(pos)
            local meta = minetest.get_meta(pos);

            --Show a form with no child inventory (for cell contents)
            meta:set_string("formspec", cell_chest_formspec_no_cell());

            --Configure the "main" inventory (holder for cells) to hold one item
            local inv = meta:get_inventory();
            inv:set_size("main", 1);
            inv:set_size("cell", 0);
        end,


        --Only allow items with `solid_state.storage_cell` in their item definition
        allow_metadata_inventory_put = storage.allow_metadata_inventory_put_cell_only,

        --A cell has been inserted into the chest, update the formspec to show a child inventory
        on_metadata_inventory_put = function(pos, listname, index, stack, player)

            --We don't need to do anything special to insert into the non-main inventory, early exit
            if listname ~= "main" then return; end

            --Get node info
            local node_meta = minetest.get_meta(pos);
            local node_inv = node_meta:get_inventory();

            --Materialize cell inventory into inventory of this node
            node_inv:set_list("cell", stack:get_definition().solid_state.storage_cell.get_cell_inventory(stack:get_meta()));

            --Change the form to display the inventory for the given cell
            node_meta:set_string("formspec", cell_chest_formspec_cell());
        end,

        allow_metadata_inventory_take = function(pos, listname, index, stack, player)

            --Allow all removals from non-main inventory
            if listname ~= "main" then return stack:get_count(); end

            --Get node info
            local node_meta = minetest.get_meta(pos);
            local node_inv = node_meta:get_inventory();

            --Change the form back to displaying no cell inventory
            node_meta:set_string("formspec", cell_chest_formspec_no_cell());

            --Save inventory into metadata of cell
            stack:get_definition().solid_state.storage_cell.set_cell_inventory(stack:get_meta(), node_inv:get_list("cell"));
            node_inv:set_stack("main", 1, stack);

            --Clear the inventory on this node
            node_inv:set_list("cell", {});

            return 1;
        end
    });
end

return {
    register = function()
        register_cell_chest();
    end
}