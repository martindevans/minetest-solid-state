local function after_dig_node(pos, oldnode, oldmetadata)
    minetest.chat_send_all("Dug");
end

local function after_place_node(pos, placer, itemstack, pointed_thing)
    minetest.chat_send_all("Placed");
end

local function register_network_node(name, def)

    if not def.groups then
        def.groups = { snappy = 1 };
    end
    def.groups.solid_state_network_node = 1;

    if not def.after_dig_node then
        def.after_dig_node = after_dig_node;
    end

    if not def.after_place_node then
        def.after_place_node = after_place_node;
    end

    minetest.register_node(name, def);
end

return {
    register_node = register_network_node,
    after_dig_node = after_dig_node,
    after_place_node = after_place_node,
    
    register = function()
        require("scripts/network/radio.lua").register();
        require("scripts/network/controller.lua").register();
    end
};