require "helpers.InheritanceObject"
require "day6.ProblemSolver.definitions"
require "day6.ProblemSolver.MultSolver"
require "day6.ProblemSolver.SumSolver"

---@class Day6.ProblemSolver : InheritanceObject
---@field problems {[number]: Day6.Problem}
---@field private _solvers {[number]: Day6.MathSolver}
ProblemSolver = InheritanceObject:new()

---@type {[Day6.Operation]: Day6.MathSolver}
local SolverFactory = {
    [Day6_Operation.Sum] = SumSolver,
    [Day6_Operation.Mult] = MultSolver
}

---@return Day6.ProblemSolver
---@param params {[number]: Day6.Problem}
function ProblemSolver:new(params)
    local instance = InheritanceObject.new(self, params)
    self._solvers = {}
    for i = 1,#params do
        if params[i].operation ~= Day6_Operation.Sum and params[i].operation ~= Day6_Operation.Mult then
            error("Error with input at value " .. i .. " invalid operation: " .. params[i])
        end
        local solver = SolverFactory[params[i].operation]:new()
        solver:AddValues(params[i])
        self._solvers[i] = solver
    end
    return instance
end

---@return integer
function ProblemSolver:Solve()
    local total = 0
    for i = 1,#self._solvers do
        total = total + self._solvers[i]:Solve()
    end
    return total
end