local network = require("scripts/network.lua");
local names = require("scripts/names.lua");

local function register_network_node(name, def)

    if not def.groups then
        def.groups = { snappy = 1 };
    end
    def.groups.solid_state_network_node = 1;

    if not def.after_dig_node then
        def.after_dig_node = network.after_dig_node;
    end

    if not def.after_place_node then
        def.after_place_node = network.after_place_node;
    end

    minetest.register_node(name, def);
end

return {
    register = function()
        minetest.register_node(names.radio(), { tiles = { "solid_state_radio.png" } });
        minetest.register_node(names.controller(), { tiles = { "solid_state_controller.png" } });
    end,

    register_node = register_network_node,
};