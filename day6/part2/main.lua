require "day6.Part2_InputReader"
require "day6.ProblemSolver.ProblemSolver"

---@typeDay6_Part2_InputReader
local reader = Day6_Part2_InputReader:new({lines_to_read = 5})

local input = reader:read("./day6/part2/input.txt")

local solver = ProblemSolver:new(input)

print(solver:Solve()) --3263827