require "helpers.InheritanceObject"

---@enum Day6.Operation
Day6_Operation = {
    Mult = "*", 
    Sum = "+"
}

---@alias Day6.Problem {[1|2|3]: integer, ["operation"]: Day6.Operation}

---@class Day6.MathSolver : InheritanceObject
---@field values {[1|2|3]: integer}
MathSolver = InheritanceObject:new()

---@return Day6.MathSolver
function MathSolver:new()
    return InheritanceObject.new(self)
end

---@param values {[1|2|3]: integer}
function MathSolver:AddValues(values)
    self.values = values
end

---@return integer
function MathSolver:Solve()
    error("Function not implemented")
end