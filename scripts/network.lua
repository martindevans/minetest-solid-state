local names = require("scripts/names.lua");

local function after_dig_node(pos, oldnode, oldmetadata)
    minetest.chat_send_all("Dug");
end

local function after_place_node(pos, placer, itemstack, pointed_thing)
    minetest.chat_send_all("Placed");
end

return {
    after_dig_node = after_dig_node,
    after_place_node = after_place_node
}