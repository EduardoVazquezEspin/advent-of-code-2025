require "day10.definitions"
require "day10.parser.SubParser"

---@class SubParseButton : SubParser
---@field private _button {[number]: integer}
---@field private _num_builder string
Day10.SubParseButton = Day10.SubParser:new()

---@return SubParseButton
function Day10.SubParseButton:new()
    local instance = Day10.SubParser.new(self, {})
    return instance
end

---@param char string
---@return boolean
function Day10.SubParseButton:StartMatches(char)
    if char ~= "(" then
        return false
    end
    self._button = {}
    self._num_builder = ""
    return true
end

---@param char string
function Day10.SubParseButton:Parse(char)
    if char ~= "," then
        self._num_builder = self._num_builder .. char
        return
    end 
    local value = tonumber(self._num_builder)
    self._button[#self._button + 1] = value
    self._num_builder = ""
end

---@param char string
---@return boolean
function Day10.SubParseButton:EndMatches(char)
    return char == ")"
end

---@param result Day10.Input.Machine
function Day10.SubParseButton:EndParse(result)
    local value = tonumber(self._num_builder)
    self._button[#self._button + 1] = value
    result.buttons[#result.buttons + 1] = self._button
end