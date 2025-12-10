require "day9.InputReader"
require "helpers.helpers"

---@type Day9.InputReader
local reader = Day9.InputReader:new()

local input = reader:read("./day9/part2/input.txt")

---@param interval1 {[1|2]: integer}
---@param interval2 {[1|2]: integer}
---@param limit1 {[1|2]: integer}
---@param limit2 {[1|2]: integer}
---@return boolean
function is_interval_exterior(interval1, interval2, limit1, limit2)
    local is_horizontal = interval1[1] == interval2[1]
    if is_horizontal then
        local min_x = math.min(limit1[1], limit2[1])
        local max_x = math.max(limit1[1], limit2[1])
        local is_internal = interval1[1] > min_x and interval1[1] < max_x
        if not is_internal then
            return true
        end
        local min_y = math.min(limit1[2], limit2[2])
        local max_y = math.max(limit1[2], limit2[2])
        return (interval1[2] >= max_y and interval2[2] >= max_y) or (interval1[2] <= min_y and interval2[2] <= min_y)
    else
        local min_y = math.min(limit1[2], limit2[2])
        local max_y = math.max(limit1[2], limit2[2])
        local is_internal = interval1[2] > min_y and interval1[2] < max_y
        if not is_internal then
            return true
        end
        local min_x = math.min(limit1[1], limit2[1])
        local max_x = math.max(limit1[1], limit2[1])
        return (interval1[1] >= max_x and interval2[1] >= max_x) or (interval1[1] <= min_x and interval2[1] <= min_x)
    end
end

---@param vector1 {[1|2]: number}
---@param vector2 {[1|2]: number}
---@return number
function exterior_product(vector1, vector2)
    return vector1[1] * vector2[2] - vector1[2] * vector2[1]
end

---Will assume no weird things happen
---@param point {[1|2]: number}
---@param segments {[number]: {[1|2]: number}}
---@return boolean
function is_point_interior(point, segments)
    local vector = {2 * math.random() - 1, 2 * math.random() - 1}
    ---@type integer
    local wn = 0
    for i = 1,#segments do
        local limit1 = segments[i]
        local limit2 = segments[i % #segments + 1]
        local limit_diff = {limit2[1] - limit1[1], limit2[2] - limit1[2]}
        local point_diff = {point[1] - limit1[1], point[2] - limit1[2]}
        local denominator = exterior_product(limit_diff, vector)
        local t = exterior_product(point_diff, limit_diff) / denominator
        local r = exterior_product(point_diff, vector) / denominator
        if t > 0 and r > 0 and r < 1 then
            wn = wn + 1
        end
    end

    return wn % 2 == 1
end

local max = 0
for i = 1,#input-1 do
    for j=i+1,#input do
        local is_valid_rectangle = true
        local index = 1
        while is_valid_rectangle and index <= #input do
            local interval1 = input[index]
            local interval2 = input[index % #input + 1]
            is_valid_rectangle = is_interval_exterior(interval1, interval2, input[i], input[j])
            index = index + 1
        end
        if is_valid_rectangle and input[i][1] ~= input[j][1] and input[i][2] ~= input[j][2] then
            local mid_point = {
                0.5 * (input[i][1] +input[j][1]) + 0.1 *(2*math.random() -1),
                0.5 * (input[i][2] +input[j][2]) + 0.1 *(2*math.random() -1)
            }
            is_valid_rectangle = is_point_interior(mid_point, input)
        end
        if is_valid_rectangle then
            local area = (math.abs(input[i][1] - input[j][1]) + 1) * (math.abs(input[i][2] - input[j][2]) + 1)
            if area > max then
                max = area
            end
        end
    end
end

print(max) --24, 12, 16