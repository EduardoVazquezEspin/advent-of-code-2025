require "day10.definitions"
require "day10.parser.SubParser"
require "day10.parser.SubParseLights"
require "day10.parser.SubParseButton"
require "day10.parser.SubParseJoltage"
require "helpers.InheritanceObject"

---@class Parser : InheritanceObject
---@field _subparsers {[number]: SubParser}
---@field _current_subparser SubParser | nil
Day10.Parser = InheritanceObject:new()

---@return Parser
function Day10.Parser:new()
    local instance = InheritanceObject.new(self, {
        _subparsers = {
            Day10.SubParseLights:new(),
            Day10.SubParseButton:new(),
            Day10.SubParseJoltage:new()
        }})
    return instance
end

---@param self Parser
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

---@param input string
---@return Day10.Input.Machine
function Day10.Parser:Parse(input)
    ---@type Day10.Input.Machine
    local result = {
        lights = {},
        buttons = {},
        joltage = {}
    }
    ---@type SubParser | nil
    self._current_subparser = nil
    local index = 1
    local len = string.len(input)
    while index <= len do
        local char = string.sub(input, index, index)
        if char == " " then
            --- ignore empty space
        elseif self._current_subparser == nil then
            find_matching_subparser(self, char)
        elseif self._current_subparser:EndMatches(char) then
            self._current_subparser:EndParse(result)
            self._current_subparser = nil
        else
            self._current_subparser:Parse(char)
        end
        index = index + 1
    end
    return result
end