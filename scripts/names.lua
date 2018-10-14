local function n(name)
    name = "solid_state:" .. name;
    return function()
        return name;
    end
end

return {
    --nodes
    controller = n("controller"),
    radio = n("radio"),
    drive_bay = n("drive_bay"),
    cell_chest = n("cell_chest"),

    crafting_cpu = n("crafting_cpu"),
    crafting_coprocessor = n("crafting_coprocessor"),
    crafting_memory = function(kb) return "solid_state:crafting_memory_" .. kb .. "k"; end,
    terminal = n("terminal"),

    --items
    cell = function(kb) return "solid_state:cell_" .. kb .. "k"; end
};