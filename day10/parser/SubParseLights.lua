require "day10.definitions"
require "day10.parser.SubParser"

---@class SubParseLights : SubParser
---@field private _lights {[number]: boolean}
Day10.SubParseLights = Day10.SubParser:new()

---@return SubParseLights
function Day10.SubParseLights:new()
    local instance = Day10.SubParser.new(self, {})
    return instance
end

---@param char string
---@return boolean
function Day10.SubParseLights:StartMatches(char)
    if char ~= "[" then
        return false
    end
    self._lights = {}
    return true
end

---@param char string
function Day10.SubParseLights:Parse(char)
    local value = true
    if char == "." then
        value = false
    end
    self._lights[#self._lights + 1] = value
end

---@param char string
---@return boolean
function Day10.SubParseLights:EndMatches(char)
    return char == "]"
end

---@param result Day10.Input.Machine
function Day10.SubParseLights:EndParse(result)
    result.lights = self._lights
end