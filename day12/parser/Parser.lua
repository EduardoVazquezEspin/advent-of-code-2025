require "day12.definitions"
require "day12.parser.SubParser"
require "day12.parser.SubParseShape"
require "day12.parser.SubParseProblem"
require "helpers.InheritanceObject"

---@class Day12.Parser : InheritanceObject
---@field _subparsers {[number]: Day12.SubParser}
---@field _current_subparser Day12.SubParser | nil
Day12.Parser = InheritanceObject:new()

---@return Day12.Parser
function Day12.Parser:new()
    local instance = InheritanceObject.new(self, {
        _subparsers = {
            Day12.SubParseShape:new(),
            Day12.SubParseProblem:new()
        }})
    return instance
end

---@param self Day12.Parser
---@param char string
local find_matching_subparser = function(self, char)
    for i=1,#self._subparsers do
        if self._subparsers[i]:StartMatches(char) then
            self._current_subparser = self._subparsers[i]
            return
        end
    end
    error("No subparser found")
end

---@param input {[number]: string}
---@return Day12.Input
function Day12.Parser:Parse(input)
    ---@type Day12.Input
    local result = {
        shapes = {},
        problems = {}
    }
    ---@type Day12.SubParser | nil
    self._current_subparser = nil
    local index = 1
    while index <= #input do
        local line = input[index]
        if self._current_subparser == nil then
            find_matching_subparser(self, line)
        end
        self._current_subparser:Parse(line)
        if self._current_subparser:EndMatches(line) then
            self._current_subparser:EndParse(result)
            self._current_subparser = nil
        end
        index = index + 1
    end
    return result
end