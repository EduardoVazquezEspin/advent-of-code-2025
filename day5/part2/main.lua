require "day5.InputReader"
require "day5.Range"
require "helpers.helpers"

---@type Day5.InputReader
local reader = InputReader:new()

local input = reader:read("./day5/part1/input.txt")

local simplified_ranges = simplify_range_set(input.ranges)

print(stringifytable(simplified_ranges))

local total = 0
for i = 1,#simplified_ranges do
    total = total + simplified_ranges[i].max - simplified_ranges[i].min + 1
end

print(total) --14