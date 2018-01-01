local connectivity = require("scripts/network/connectivity.lua");
local names = require("scripts/names.lua");

local function register_controller()
    connectivity.register_node(names.controller(), {
        tiles = { "solid_state_controller.png" }
    });
end

return {
    register = function()
        register_controller();
    end
}