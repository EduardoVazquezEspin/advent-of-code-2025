require "day5.Range"
require "helpers.InheritanceObject"
require "helpers.Reader"
require "helpers.helpers"

---@class Day5.InputReader : InheritanceObject
---@field reader Reader
InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@alias Day5.Input {["ranges"]: Array<Range>, ["ingredients"]: Array<integer>}

---@param path string
---@return Day5.Input
function InputReader:read(path)
    local text = self.reader:read_file(path)
    ---@type Day5.Input
    local result = {
        ranges = {},
        ingredients = {}
    }
    local index = 1
    while text[index] ~= "" do
        local split = stringsplit(text[index], "-")
        result.ranges[#result.ranges + 1] = {
            min = tonumber(split[1]),
            max = tonumber(split[2])
        }
        index = index + 1
    end
    index = index + 1
    while text[index] do
        result.ingredients[#result.ingredients + 1] = tonumber(text[index])
        index = index + 1
    end
    return result
end