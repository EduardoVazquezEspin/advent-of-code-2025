require "day6.Part1_InputReader"
require "day6.ProblemSolver.ProblemSolver"

---@typeDay6_Part1_InputReader
local reader = Day6_Part1_InputReader:new({lines_to_read = 5})

local input = reader:read("./day6/part1/input.txt")

local solver = ProblemSolver:new(input)

print(solver:Solve()) --4277556