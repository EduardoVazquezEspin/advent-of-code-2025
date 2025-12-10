require "day9.definitions"
require "helpers.InheritanceObject"
require "helpers.Reader"
require "helpers.helpers"

---@class Day9.InputReader : InheritanceObject
---@field private reader Reader
Day9.InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@alias Day9.Input {[number]: {[1|2]: integer}}

---@param path string
---@return Day9.Input
function Day9.InputReader:read(path)
    local text = self.reader:read_file(path)
    ---@type Day9.Input
    local result = {}
    for i = 1,#text do
        local split = stringsplit(text[i], ",")
        result[#result + 1] = {
            tonumber(split[1]),
            tonumber(split[2])
        }
    end
    return result
end