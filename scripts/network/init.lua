local names = require("scripts/names.lua");

local function on_destruct(pos)
    minetest.chat_send_all("Dug");
end

local function on_construct(pos)
    local node_meta = minetest.get_meta(pos);

    node_meta:set_string("solid_state_network_controller_pos", minetest.serialize({ x = 20000, y = 20000, z = 20000 }));
end

local function register_network_node(name, def)

    if not def.groups then
        def.groups = { snappy = 1 };
    end
    def.groups.solid_state_network_node = 1;

    if not def.on_destruct then
        def.on_destruct = on_destruct;
    else
        local des = def.on_destruct;
        def.on_destruct = function(pos)
            on_destruct(pos);
            des(pos);
        end
    end

    if not def.on_construct then
        def.on_construct = on_construct;
    else
        local cons = def.on_construct;
        def.on_construct = function(pos)
            on_construct(pos);
            cons(pos);
        end
    end

    minetest.register_node(name, def);
end

--Find the network connected to given position
local function find_network_controller(pos)
    --todo: find controller on adjacent network
end

local function get_network(pos)

    --todo: this gets the position of the controller for this node. However controllers aren't implemented yet!
    --local pos = minetest.deserialize(minetest.get_meta(pos):get_string("solid_state_network_controller_pos"));

    return minetest.get_mod_storage();
end

return {
    register_node = register_network_node,
    on_destruct = on_destruct,
    on_construct = on_construct,

    get = get_network,
    
    register = function()
        require("scripts/network/radio.lua").register();
        require("scripts/network/controller.lua").register();
    end
};