require "helpers.InheritanceObject"
require "helpers.Reader"
require "helpers.helpers"

---@class Day3.InputReader : InheritanceObject
---@field reader Reader
InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@param path string
---@return {[number]: {[number]: number}}
function InputReader:read(path)
    local text = self.reader:read_file(path)
    local result = {}
    for i=1,#text do
        local line = {}
        for j=1,#text[i] do
            line[#line + 1] = tonumber(string.sub(text[i], j, j))
        end
        result[#result + 1] = line
    end
    return result
end