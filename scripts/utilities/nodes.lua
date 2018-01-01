local function get_far_node(pos)
    local node = minetest.get_node(pos)
    if node.name == "ignore" then
        minetest.get_voxel_manip():read_from_map(pos, pos)
        node = minetest.get_node(pos)
    end
    return node
end

local function search_in_direction(pos, dir, steps, pred, found, also_neg)
    for i=1, steps do
        local pp = vector.add(vector.multiply(dir, i), pos);
        local np = get_far_node(pp);

        if pred(np) then
            found(np, pp);
            return np, pp;
        end

        if also_neg then
            local pn = vector.add(vector.multiply(dir, -i), pos);
            local nn = get_far_node(pn);
    
            if pred(nn) then
                found(nn, pn);
                return nn, pn;
            end
        end
    end
end

return {

    -- Get a node even if it is not loaded. Will return "ignore" if the node is not generated
    get_far_node = get_far_node,

    --Starting at a corner, find a bounding box denoted by corners of the same node type
    find_device_bounding_box = function(pos, size)
        
        --Establish bounding box extents
        local min_bounds = pos;
        local max_bounds = pos;
        function update_bounds(pos)
            min_bounds = { x = math.min(min_bounds.x, pos.x), y = math.min(min_bounds.y, pos.y), z = math.min(min_bounds.z, pos.z) };
            max_bounds = { x = math.max(max_bounds.x, pos.x), y = math.max(max_bounds.y, pos.y), z = math.max(max_bounds.z, pos.z) };
        end

        --Get the initial corner node
        local initial_corner_node = get_far_node(pos);

        --Find corners in all 3 directions
        local function search(pos, dir)
            local _,p = search_in_direction(
                pos,
                dir,
                size,
                function(a) return a.name == initial_corner_node.name; end,
                function(n, p) update_bounds(p); end,
                true
            );
            return p;
        end
        if not search(pos, { x = 1, y = 0, z = 0 }) then return; end
        if not search(pos, { x = 0, y = 1, z = 0 }) then return; end
        if not search(pos, { x = 0, y = 0, z = 1 }) then return; end

        --Check that all 8 corners corners are the expected type
        local function check(pos)
            local n = get_far_node(pos);
            return n.name == initial_corner_node.name;
        end
        if not check({ x = min_bounds.x, y = min_bounds.y, z = min_bounds.z }) then return; end
        if not check({ x = min_bounds.x, y = min_bounds.y, z = max_bounds.z }) then return; end
        if not check({ x = min_bounds.x, y = max_bounds.y, z = min_bounds.z }) then return; end
        if not check({ x = min_bounds.x, y = max_bounds.y, z = max_bounds.z }) then return; end
        if not check({ x = max_bounds.x, y = min_bounds.y, z = min_bounds.z }) then return; end
        if not check({ x = max_bounds.x, y = min_bounds.y, z = max_bounds.z }) then return; end
        if not check({ x = max_bounds.x, y = max_bounds.y, z = min_bounds.z }) then return; end
        if not check({ x = max_bounds.x, y = max_bounds.y, z = max_bounds.z }) then return; end

        --Ok! return the extents
        return min_bounds, max_bounds;

    end
}