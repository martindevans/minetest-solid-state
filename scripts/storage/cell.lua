local storage = require("scripts/storage/init.lua");

return {
    register = function()
        storage.register_cell(1);
        storage.register_cell(4);
        storage.register_cell(16);
        storage.register_cell(64);
        storage.register_cell(256);
    end
}