local network = require("scripts/network/init.lua");
local names = require("scripts/names.lua");

local function register_coprocessor()
    network.register_node(names.crafting_coprocessor(), {
        tiles = { "solid_state_crafting_coprocessor.png" }
    });
end

return {
    register = function()
        register_coprocessor();
    end
}