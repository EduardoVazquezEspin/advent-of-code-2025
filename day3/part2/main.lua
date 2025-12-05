require "day3.InputReader"
require "day3.common"

---@type Day3.InputReader
local reader = InputReader:new()

local input = reader:read("./day3/part1/input.txt")

---@type integer
local total = 0
for i=1,#input do
    total = total + find_largest_joltage(input[i], 12, 1)
end

print(total) --3121910778619