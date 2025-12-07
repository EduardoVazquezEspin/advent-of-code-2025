require "day7.definitions"
require "helpers.InheritanceObject"
require "helpers.Reader"

---@class Day7.InputReader : InheritanceObject
---@field private reader Reader
Day7.InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@alias Day7.Input Map

---@param path string
---@return Day7.Input
function Day7.InputReader:read(path)
    local text = self.reader:read_file(path)
    ---@type Day7.Input
    local result = Map:new({
        width = string.len(text[1]),
        height = #text,
        default = "."
    })
    for i = 1,#text do
        for j = 1,string.len(text[i]) do
            result:set(i, j, string.sub(text[i], j, j))
        end
    end
    return result
end