local network = require("scripts/network/init.lua");
local names = require("scripts/names.lua");

local function construct_cpu(pos)
    --Setup an initial job in the CPU task list to initialize the assembly
    minetest.get_meta(pos):set_string("solid_state_crafting_cpu_task_list", minetest.serialize({{ name = "setup_assembly" }}));
end

local function destruct_cpu(pos)

end

local task_functions = {
    setup_assembly = function(task, tasks, assembly)
        minetest.chat_send_all("setup_assembly");
    end,
};

local function tick_cpu(pos)

    --Get the metadata for this node
    local node_meta = minetest.get_meta(pos);

    --Get the list of tasks this CPU has to execute, early exit if none
    local task_list = minetest.deserialize(node_meta:get_string("solid_state_crafting_cpu_task_list")) or {};
    if #task_list == 0 then return end;

    --Get the state of the whole crafting assembly
    local assembly = minetest.deserialize(node_meta:get_string("solid_state_crafting_assembly_state")) or {};
    local network = network.get(pos);

    --Calculate how many tasks we can execute (one per coprocessor) and run them now (the loop runs one extra task, representing the CPU itself)
    local cpu_count = assembly.coprocessor_count or 0;
    for i=0,cpu_count,1 do
        if #task_list == 0 then break; end
        local task = table.remove(task_list, 1);
        local func = task_functions[task.name];
        if func then func(task, task_list, assembly, network); end;
    end

    --Save the changed state back into the node metadata
    node_meta:set_string("solid_state_crafting_cpu_task_list", minetest.serialize(task_list));
    node_meta:set_string("solid_state_crafting_assembly_state", minetest.serialize(assembly));
end

local function register_cpu()
    network.register_node(names.crafting_cpu(), {
        tiles = { "solid_state_crafting_cpu.png" },
        on_construct = construct_cpu,
        on_destruct = destruct_cpu,
        solid_state = {
            crafting_cpu = {
            }
        }
    });
end

return {
    register = function()
        register_cpu();

        minetest.register_abm({
            label = "solid_state crafting",
            nodenames = { names.crafting_cpu() },
            interval = 1,
            chance = 1,
            action = tick_cpu,
        });
    end
};