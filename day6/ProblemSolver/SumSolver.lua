require "helpers.InheritanceObject"
require "day6.ProblemSolver.definitions"

---@class Day6.SumSolver: Day6.MathSolver
SumSolver = MathSolver:new()

---@return integer
function SumSolver:Solve()
    local result = 0
    for i = 1, #self.values do
        result = result + self.values[i]
    end
    return result
end