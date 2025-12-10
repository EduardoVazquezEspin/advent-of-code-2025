require "day9.InputReader"

---@type Day9.InputReader
local reader = Day9.InputReader:new()

local input = reader:read("./day9/part1/input.txt")

local max = 0
for i = 1,#input-1 do
    for j=i+1,#input do
        local area = (math.abs(input[i][1] - input[j][1]) + 1) * (math.abs(input[i][2] - input[j][2]) + 1)
        if area > max then
            max = area
        end
    end
end

print(max) --50