local network = require("scripts/network/init.lua");
local names = require("scripts/names.lua");

local function register_radio()
    network.register_node(names.radio(), {
        tiles = { "solid_state_radio.png" }
    });
end

return {
    register = function()
        register_radio();
    end
}