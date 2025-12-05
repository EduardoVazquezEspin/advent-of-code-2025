require "helpers.InheritanceObject"
require "helpers.Reader"
require "helpers.helpers"

InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

function InputReader:read(path)
    local text = self.reader:read_file(path)
    local line = text[1]
    local pairs = stringsplit(line, ",")
    local result = {}
    for i=1,#pairs do
        local pair = stringsplit(pairs[i], "-")
        result[#result + 1] = pair
    end
    return result
end