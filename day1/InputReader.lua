require "helpers.InheritanceObject"
require "helpers.Reader"

InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

function InputReader:read(path)
    local text = self.reader:read_file(path)
    local result = {}
    for i = 1,#text do
        local line = text[i]
        local inputLine = { goRight = true }
        if string.sub(line, 1, 1) == "L" then
            inputLine.goRight = false
        end
        inputLine.number = tonumber(string.sub(line, 2))
        result[#result + 1] = inputLine
    end
    return result
end