require "day10.InputReader"
require "day10.common"

---@type Day10.InputReader
local reader = Day10.InputReader:new()

local input = reader:read("./day10/part1/input.txt")

local total = 0
for i=1,#input do
    local machine = input[i]
    local solution = Day10.find_min_z2_solution(machine.buttons, machine.lights)
    if solution == nil then
        error("Something went wrong with machine " .. i)
    end
    total = total + solution.evaluation
end

print(total) --7