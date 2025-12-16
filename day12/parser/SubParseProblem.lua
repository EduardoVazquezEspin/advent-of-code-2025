require "day12.definitions"
require "day12.parser.SubParser"
require "helpers.helpers"

---@class Day12.SubParseProblem : SubParser
---@field private _width integer
---@field private _height integer
---@field private _shapes {[number]: integer}
Day12.SubParseProblem = Day12.SubParser:new()

---@return Day12.SubParseProblem
function Day12.SubParseProblem:new()
    return Day12.SubParser.new(self)
end

---@param line string
---@return boolean
function Day12.SubParseProblem:StartMatches(line)
    return string.match(line,"^%d+x%d+:[ %d]+$") ~= nil
end

---@param line string
function Day12.SubParseProblem:Parse(line)
    local first_split = stringsplit(line, ":")
    local second_split = stringsplit(first_split[1], "x")
    self._width = tonumber(second_split[1])
    self._height = tonumber(second_split[2])
    local third_split = stringsplit(first_split[2], " ")
    self._shapes = {}
    for i = 1,#third_split do
        self._shapes[#self._shapes + 1] = tonumber(third_split[i])
    end
end

---@param line string
---@return boolean
function Day12.SubParseProblem:EndMatches(line)
    return true
end

---@param result Day12.Input
function Day12.SubParseProblem:EndParse(result)
    result.problems[#result.problems + 1] = {width = self._width, height = self._height, shape_amount = self._shapes}
end