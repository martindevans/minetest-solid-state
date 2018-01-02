local network = require("scripts/network/init.lua");
local names = require("scripts/names.lua");

local function register_memory(kb)
    network.register_node(names.crafting_memory(kb), {
        tiles = { "solid_state_crafting_memory_" .. kb .. "k.png" },
        solid_state = {
            crafting_memory = {
                capacity = kb
            }
        }
    });
end

return {
    register = function()
        register_memory(1);
        register_memory(4);
        register_memory(16);
        register_memory(64);
        register_memory(256);
    end
}