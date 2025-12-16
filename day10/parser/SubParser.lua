require "day10.definitions"
require "helpers.InheritanceObject"

---@class SubParser : InheritanceObject
Day10.SubParser = InheritanceObject:new()

---@param char string
---@return boolean
function Day10.SubParser:StartMatches(char)
    error("Not implemented")
end

---@param char string
---@return boolean
function Day10.SubParser:EndMatches(char)
    error("Not implemented")
end

---@param char string
---@return nil
function Day10.SubParser:Parse(char)
    error("Not implemented")
end

---@param result Day10.Input.Machine
---@return nil
function Day10.SubParser:EndParse(result)
    error("Not implemented")
end