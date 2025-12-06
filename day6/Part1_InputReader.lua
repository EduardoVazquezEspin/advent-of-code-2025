require "helpers.InheritanceObject"
require "helpers.Reader"
require "helpers.helpers"

---@class Day6_Part1_InputReader : InheritanceObject
---@field lines_to_read integer
---@field private reader Reader
Day6_Part1_InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@param params {["lines_to_read"]: integer}
---@return Day6_Part1_InputReader
function Day6_Part1_InputReader:new(params)
    return InheritanceObject.new(self, params)
end

---@alias Day6.Part1.Input {[number]: Day6.Problem}

---@param path string
---@return Day6.Part1.Input
function Day6_Part1_InputReader:read(path)
    local text = self.reader:read_file(path)
    local split_lines = {}
    for i = 1,self.lines_to_read do
        split_lines[i] = stringsplit(text[i], " ")
    end

    ---@type Day6.Part1.Input
    local result = {}
    for j=1,#split_lines[1] do
        ---@type Day6.Problem
        local res = {}
        for i = 1,self.lines_to_read-1 do
            res[#res + 1] = tonumber(split_lines[i][j])
        end
        res.operation = split_lines[self.lines_to_read][j]
        result[#result + 1] = res
    end
    return result
end