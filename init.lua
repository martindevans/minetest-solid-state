local root = minetest.get_modpath("solid_state");
dofile(root .. "/scripts/require.lua")(root);

require("scripts/connectivity.lua").register();
require("scripts/storage.lua").register();