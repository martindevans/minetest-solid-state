local network = require("scripts/network/init.lua");
local names = require("scripts/names.lua");

local function register_terminal()
    network.register_node(names.terminal(), {
        tiles = {
            "solid_state_cell_chest_top.png",
            "solid_state_cell_chest_bot.png",
            "solid_state_cell_chest_side.png",
            "solid_state_cell_chest_side.png",
            "solid_state_cell_chest_side.png",
            "solid_state_terminal_front.png"
        },

        on_construct = function(pos)
            local meta = minetest.get_meta(pos);
            meta:set_string("formspec", "");
        end,
    });
end

return {
    register = function()
        register_terminal();
    end
}