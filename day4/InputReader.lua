require "helpers.InheritanceObject"
require "helpers.Reader"
require "helpers.Map"
require "helpers.helpers"

---@class Day4.InputReader : InheritanceObject
---@field reader Reader
InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@param path string
---@return Map<boolean>
function InputReader:read(path)
    local text = self.reader:read_file(path)
    ---@type Map<boolean>
    local result = Map:new({
        width = string.len(text[1]), 
        height = #text,
        default = false
    })
    for j=1,#text do
        local len = string.len(text[j])
        for i=1,len do
            local char = string.sub(text[j], i, i)
            if char == "@" then
                result:set(i, j, true)
            end
        end
    end
    return result
end