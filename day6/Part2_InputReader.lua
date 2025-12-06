require "helpers.InheritanceObject"
require "helpers.Reader"
require "helpers.helpers"

---@class Day6_Part2_InputReader : InheritanceObject
---@field lines_to_read integer
---@field private reader Reader
Day6_Part2_InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@param params {["lines_to_read"]: integer}
---@return Day6_Part2_InputReader
function Day6_Part2_InputReader:new(params)
    return InheritanceObject.new(self, params)
end

---@alias Day6.Part2.Input {[number]: Day6.Problem}

---@param path string
---@return Day6.Part2.Input
function Day6_Part2_InputReader:read(path)
    local text = self.reader:read_file(path)
    ---@type Day6.Part2.Input
    local result = {}
    ---@type integer
    local problem_index = 1
    result[problem_index] = {}
    for column_index = 1,string.len(text[1]) do
        ---@type integer
        local num = 0
        local is_empty_column = true
        local is_empty_number = true
        for i=1,self.lines_to_read-1 do
            local char = string.sub(text[i], column_index, column_index)
            if char ~= " " then
                is_empty_number = false
                is_empty_column = false
                num = 10 * num + math.floor(tonumber(char))
            end
        end

        local char = string.sub(text[self.lines_to_read], column_index, column_index)
        if char ~= " " then
            is_empty_column = false
            result[problem_index].operation = char
        end

        if not is_empty_number then
            result[problem_index][#result[problem_index] + 1] = num
        end
        
        if is_empty_column then
            problem_index = problem_index + 1
            result[problem_index] = {}
        end
    end

    return result
end