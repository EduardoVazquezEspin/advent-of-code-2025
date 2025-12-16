require "day12.definitions"
require "helpers.InheritanceObject"

---@class Day12.SubParser : InheritanceObject
Day12.SubParser = InheritanceObject:new()

---@param line string
---@return boolean
function Day12.SubParser:StartMatches(line)
    error("Not implemented")
end

---@param line string
---@return boolean
function Day12.SubParser:EndMatches(line)
    error("Not implemented")
end

---@param line string
---@return nil
function Day12.SubParser:Parse(line)
    error("Not implemented")
end

---@param result Day12.Input
---@return nil
function Day12.SubParser:EndParse(result)
    error("Not implemented")
end