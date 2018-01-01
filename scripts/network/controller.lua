local network = require("scripts/network/init.lua");
local names = require("scripts/names.lua");

local function register_controller()
    network.register_node(names.controller(), {
        tiles = { "solid_state_controller.png" }
    });
end

return {
    register = function()
        register_controller();
    end
}