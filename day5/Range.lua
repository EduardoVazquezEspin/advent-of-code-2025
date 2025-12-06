---@alias Range {["min"]: integer, ["max"]: integer}

---@param range1 Range
---@param range2 Range
---@return boolean
local function do_they_intersect(range1, range2)
    if range1.min > range2.max then
        return false
    end
    if range1.max < range2.min then
        return false
    end
    return true
end

---@param range1 Range
---@param range2 Range
---@return Range
local function get_intersection(range1, range2)
    return {
        min = math.min(range1.min, range2.min),
        max = math.max(range1.max, range2.max)
    }
end

---@param range_set Array<Range>
---@return Array<Range>
function simplify_range_set(range_set)
    local index_to_simplify = 1
    local result = range_set
    while index_to_simplify <= #result do
        ---@type boolean
        local has_been_modified = false
        local new_ranges = {}
        for i=1,index_to_simplify do
            new_ranges[#new_ranges + 1] = result[i]
        end
        for i=index_to_simplify + 1,#result do
            if do_they_intersect(new_ranges[index_to_simplify], result[i]) then
                has_been_modified = true
                new_ranges[index_to_simplify] = get_intersection(new_ranges[index_to_simplify], result[i])
            else
                new_ranges[#new_ranges + 1] = result[i]
            end
        end
        result = new_ranges
        if not has_been_modified then
            index_to_simplify = index_to_simplify + 1
        end
    end
    return result
end