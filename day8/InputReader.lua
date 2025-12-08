require "day8.definitions"
require "helpers.InheritanceObject"
require "helpers.Reader"
require "helpers.helpers"

---@class Day8.InputReader : InheritanceObject
---@field private reader Reader
Day8.InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@alias Day8.Input {[number]: {[1|2|3]: integer}}

---@param path string
---@return Day8.Input
function Day8.InputReader:read(path)
    local text = self.reader:read_file(path)
    ---@type Day8.Input
    local result = {}
    for i = 1, #text do
        local split = stringsplit(text[i], ",")
        result[#result + 1] = {tonumber(split[1]), tonumber(split[2]), tonumber(split[3]), name=i}
    end
    return result
end