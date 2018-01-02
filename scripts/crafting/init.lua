local names = require("scripts/names.lua");
local cpu = require("scripts/crafting/cpu.lua");

return {
    register = function()
        cpu.register();
        require("scripts/crafting/coprocessor.lua").register();
        require("scripts/crafting/memory.lua").register();
    end
};