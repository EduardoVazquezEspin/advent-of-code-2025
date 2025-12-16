require "day11.definitions"
require "helpers.InheritanceObject"
require "helpers.Reader"
require "day11.Graph"
require "day11.Node"
require "helpers.helpers"

---@class Day11.InputReader : InheritanceObject
---@field private reader Reader
Day11.InputReader = InheritanceObject:new({ 
    reader = Reader:new()
})

---@param path string
---@return Day11.Graph
function Day11.InputReader:read(path)
    local text = self.reader:read_file(path)
    local graph = Day11.Graph:new()
    ---@type {[number]: {[number]: string}}
    local splits = {}
    for i = 1,#text do
        local split = stringsplit(text[i], ":")
        splits[#splits + 1] = split
        local id = split[1]
        local node = Day11.Node:new({id = id})
        graph:add_node(node)
    end
    graph:add_node(Day11.Node:new(  {id = "out"}))
    for i = 1, #text do
        local node_id_1 = splits[i][1]
        local split = stringsplit(splits[i][2], " ")
        for j = 1, #split do
            local node_id_2 = split[j]
            if string.len(node_id_2) == 3 then
                graph:add_edge(node_id_1, node_id_2)
            end
        end
    end
    return graph
end