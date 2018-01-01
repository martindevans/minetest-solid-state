local network = require("scripts/network/init.lua");
local names = require("scripts/names.lua");
local storage = require("scripts/storage/init.lua");

local function register_drive_bay()
    network.register_node(names.drive_bay(), {
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
        allow_metadata_inventory_put = storage.allow_metadata_inventory_put_cell_only,
    });
end

return {
    register = function()
        register_drive_bay();
    end
}