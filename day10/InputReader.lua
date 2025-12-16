require "day10.definitions"
require "day10.parser.Parser"
require "helpers.InheritanceObject"
require "helpers.Reader"

---@class Day10.InputReader : InheritanceObject
---@field private reader Reader
Day10.InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@param path string
---@return Day10.Input
function Day10.InputReader:read(path)
    local text = self.reader:read_file(path)
    ---@type Day10.Input
    local result = {}
    local parser = Day10.Parser:new()
    for i = 1,#text do
        result[#result + 1] = parser:Parse(text[i])
    end
    return result
end