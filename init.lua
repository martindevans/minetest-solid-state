local root = minetest.get_modpath("solid_state");
dofile(root .. "/scripts/require.lua")(root);

require("scripts/network/init.lua").register();
require("scripts/storage/init.lua").register();
require("scripts/crafting/init.lua").register();