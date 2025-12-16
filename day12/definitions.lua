require "helpers.Map"

---@class Day12
Day12 = {
    Part1 = {}
}

---@alias Day12.Problem {["width"]: integer, ["height"]: integer, ["shape_amount"]: {[number]: integer}}
---@alias Day12.Shapes {[number]: {[number]: Map}}
---@alias Day12.Input {["shapes"]: Day12.Shapes, ["problems"]: {[number]: Day12.Problem}}