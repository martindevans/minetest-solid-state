return {
    register = function()
        require("scripts/network/radio.lua").register();
        require("scripts/network/controller.lua").register();
    end
};