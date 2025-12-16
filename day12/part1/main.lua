require "day12.InputReader"
require "day12.solver"

---@type Day12.InputReader
local reader = Day12.InputReader:new()

local input = reader:read("./day12/part1/test.txt")

local total = 0
for i = 1, #input.problems do
    local solver = Day12.Part1.Solver:new({
        problem = input.problems[i],
        shapes = input.shapes
    })

    print("CASE " .. i)

    if solver:solve() then
        total = total + 1
    end
end

print(total) --2