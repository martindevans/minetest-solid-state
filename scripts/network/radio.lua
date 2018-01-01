local connectivity = require("scripts/network/connectivity.lua");
local names = require("scripts/names.lua");

local function register_radio()
    connectivity.register_node(names.radio(), {
        tiles = { "solid_state_radio.png" }
    });
end

return {
    register = function()
        register_radio();
    end
}