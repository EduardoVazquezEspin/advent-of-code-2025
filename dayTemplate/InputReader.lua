require "day##DAY##.definitions"
require "helpers.InheritanceObject"
require "helpers.Reader"

---@class Day##DAY##.InputReader : InheritanceObject
---@field private reader Reader
Day##DAY##.InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@alias Day##DAY##.Input {[number]: integer}

---@param path string
---@return Day##DAY##.Input
function Day##DAY##.InputReader:read(path)
    local text = self.reader:read_file(path)
    ---@type Day##DAY##.Input
    local result = {}
    return result
end