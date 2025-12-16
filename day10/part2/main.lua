require "day10.InputReader"
require "day10.common"

---@type Day10.InputReader
local reader = Day10.InputReader:new()

local input = reader:read("./day10/part2/input.txt")

local total = 0
for i=1,#input do
    local machine = input[i]
    ---@type number
    local power = 1
    for i=1,#machine.joltage do
        power = power * machine.joltage[i]
    end
    print("Computing ".. i .. "... (" .. power .. ")")
    local solution = Day10.find_min_zp_solution(machine.buttons, machine.joltage)
    if solution == nil then
        error("Something went wrong with machine " .. i)
    end
    total = total + solution.evaluation
end

print(total) --33