require "day12.definitions"
require "helpers.InheritanceObject"
require "helpers.Reader"
require "day12.parser.Parser"

---@class Day12.InputReader : InheritanceObject
---@field private reader Reader
Day12.InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@param path string
---@return Day12.Input
function Day12.InputReader:read(path)
    local text = self.reader:read_file(path)
    local parser = Day12.Parser:new()
    ---@type Day12.Input
    local result = parser:Parse(text)
    return result
end