require "day10.definitions"
require "day10.parser.SubParser"

---@class SubParseJoltage : SubParser
---@field private _joltage {[number]: integer}
---@field private _num_builder string
Day10.SubParseJoltage = Day10.SubParser:new()

---@return SubParseJoltage
function Day10.SubParseJoltage:new()
    local instance = Day10.SubParser.new(self, {})
    return instance
end

---@param char string
---@return boolean
function Day10.SubParseJoltage:StartMatches(char)
    if char ~= "{" then
        return false
    end
    self._joltage = {}
    self._num_builder = ""
    return true
end

---@param char string
function Day10.SubParseJoltage:Parse(char)
    if char ~= "," then
        self._num_builder = self._num_builder .. char
        return
    end 
    local value = tonumber(self._num_builder)
    self._joltage[#self._joltage + 1] = value
    self._num_builder = ""
end

---@param char string
---@return boolean
function Day10.SubParseJoltage:EndMatches(char)
    return char == "}"
end

---@param result Day10.Input.Machine
function Day10.SubParseJoltage:EndParse(result)
    local value = tonumber(self._num_builder)
    self._joltage[#self._joltage + 1] = value
    result.joltage = self._joltage
end