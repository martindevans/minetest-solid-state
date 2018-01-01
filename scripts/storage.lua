local connectivity = require("scripts/connectivity.lua");
local names = require("scripts/names.lua");
local utilities = require("scripts/utilities.lua");
local uuid = require("scripts/uuid.lua");

function register_cell(kb)
    minetest.register_craftitem(names.cell(kb), {
        description = kb .. "K Storage Cell",
        inventory_image = "solid_state_cell_" .. kb .. "k.png",
        stack_max = 1,
        solid_state = {
            storage_cell = {
                capacity = kb,
            }
        }
    });
end

function serialize_inventory(invref_list)
    local wip = {};
    for k, v in pairs(invref_list) do
        wip[k] = v:to_table();
    end
    local s = minetest.serialize(wip);
    return s;
end

function deserialize_inventory(str)
    local d = minetest.deserialize(str);
    for k, v in pairs(d) do
        d[k] = ItemStack(v);
    end
    return d;
end

function allow_metadata_inventory_put_cell_only(pos, listname, index, stack, player)

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
        allow_metadata_inventory_put = allow_metadata_inventory_put_cell_only,

        --A cell has been inserted into the chest, update the formspec to show a child inventory
        on_metadata_inventory_put = function(pos, listname, index, stack, player)

            --We don't need to do anything special to insert into the non-main inventory, early exit
            if listname ~= "main" then return; end

            --Get node info
            local node_meta = minetest.get_meta(pos);
            local node_inv = node_meta:get_inventory();

            --Get item info
            local stack_meta = stack:get_meta();

            --Materialize cell inventory into inventory of this node
            local serialized_cell_inv = stack_meta:get_string("solid_state.storage_cell.serialized_inventory");
            if serialized_cell_inv ~= "" then
                local des = deserialize_inventory(serialized_cell_inv);
                node_inv:set_list("cell", des);
            else
                node_inv:set_list("cell", {});
            end

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

            --Serialize inventory back into cell metadata
            local stack_meta = stack:get_meta();
            local serialized = serialize_inventory(node_inv:get_list("cell"));
            stack_meta:set_string("solid_state.storage_cell.serialized_inventory", serialized);

            --Put the stack back into the main inventory with the changed metadata
            node_inv:set_stack("main", 1, stack);

            --Clear the inventory on this node
            node_inv:set_list("cell", {});

            return 1;
        end
    });
end

function register_drive_bay()
    connectivity.register_node(names.drive_bay(), {
        tiles = {
            "solid_state_drive_bay_side.png",
            "solid_state_drive_bay_side.png",
            "solid_state_drive_bay_side.png",
            "solid_state_drive_bay_side.png",
            "solid_state_drive_bay_side.png",
            "solid_state_drive_bay_front.png"
        },

        on_construct = function(pos)
            local meta = minetest.get_meta(pos);

            local spec = "invsize[11,5;]" .. "list[context;main;0,0;2,5;]" .. "list[current_player;main;3,0;8,4;]";
            meta:set_string("formspec", spec);

            local inv = meta:get_inventory();
            inv:set_size("main", 10);
        end,

        --Only allow items with `solid_state.storage_cell` in their item definition
        allow_metadata_inventory_put = allow_metadata_inventory_put_cell_only,
    });
end


return {
    register = function()

        --todo: recipes

        --register cell (items) of varying sizes
        register_cell(1);
        register_cell(4);
        register_cell(16);
        register_cell(64);
        register_cell(256);

        --Register nodes
        register_drive_bay();
        register_cell_chest();
    end
};