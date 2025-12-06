require "helpers.InheritanceObject"
require "day6.ProblemSolver.definitions"

---@class Day6.MultSolver: Day6.MathSolver
MultSolver = MathSolver:new()

---@return integer
function MultSolver:Solve()
    local result = 1
    for i = 1, #self.values do
        result = result * self.values[i]
    end
    return result
end