local network = require("scripts/network/init.lua");
local names = require("scripts/names.lua");

local function register_cpu()
    network.register_node(names.crafting_cpu(), {
        tiles = { "solid_state_crafting_cpu.png" }
    });
end

return {
    register = function()
        register_cpu();
    end
}