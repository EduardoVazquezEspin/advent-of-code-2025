require "helpers.InheritanceObject"
require "day11.Node"
require "helpers.sort"
require "helpers.BigUInt"

---@class Day11.Graph : InheritanceObject
---@field private _nodes {[string]:Day11.Node}
Day11.Graph = InheritanceObject:new()

---@return Day11.Graph
function Day11.Graph:new()
    local instance = InheritanceObject.new(self, {
        _nodes = {}
    })
    return instance
end

---@param node Day11.Node
---@return nil
function Day11.Graph:add_node(node)
    self._nodes[node.id] = node
end

---@param node_id string
---@return Day11.Node
function Day11.Graph:get_node(node_id)
    local node1 = self._nodes[node_id]
    if node1 == nil then
        error("Invalid node id " .. node_id)
    end
    return node1
end

---@param node_id_1 string
---@param node_id_2 string
---@return nil
function Day11.Graph:add_edge(node_id_1, node_id_2)
    local node_1 = self:get_node(node_id_1)
    local node_2 = self:get_node(node_id_2)
    node_1:add_edge(node_2)
end

---@return {[number]: Day11.Node} 
function Day11.Graph:get_all_nodes()
    local result = {}
    for k, value in pairs(self._nodes) do
        result[#result + 1] = value
    end
    return result;
end

--- Will assume no cycles exist
---@param origin_id string
---@return {[string]: integer}
function Day11.Graph:count_paths(origin_id)
    local nodes = self:get_all_nodes()
    local sorted_node_list = topological_sort(nodes, 
        ---@param node Day11.Node
        function(node) 
            return node.comes_from  
        end
    )
    ---@type {[string]: integer}  
    local result = {[origin_id] = 1}
    for i = 1, #sorted_node_list do
        local paths = result[sorted_node_list[i].id]
        if paths == nil then
            paths = 0
        end
        local comes_from = sorted_node_list[i].comes_from
        for j = 1, #comes_from do
            local value = result[comes_from[j].id]
            if value ~= nil then
                paths = paths + result[comes_from[j].id]
            end
        end
        result[sorted_node_list[i].id] = paths
    end
  
    return result
end

---@alias Choice {[boolean]: Choice} | BigUInt

---@param size integer
---@param value BigUInt
---@return Choice
local function create_default_choice(size, value)
    if size == 0 then
        return value
    end
    local result = {
        [false] = create_default_choice(size-1, value),
        [true] = create_default_choice(size-1, BigUInt:new(0))
    }
    return result
end

---@param choice_1 Choice
---@param choice_2 Choice
---@param choice_size integer
---@return Choice
local function choice_sum(choice_1, choice_2, choice_size)
    if choice_size == 0 then
        return choice_1:add(choice_2)
    end
    return {
        [false] = choice_sum(choice_1[false], choice_2[false], choice_size - 1),
        [true] = choice_sum(choice_1[true], choice_2[true], choice_size - 1)
    }
end

---@param choice Choice
---@param index integer
---@param choice_size integer
---@return Choice
local function map_choice(choice, index, choice_size)
    if choice_size == 0 then
        return choice
    end
    if index ~= 1 then
        return {
            [false] = map_choice(choice[false], index - 1, choice_size - 1),
            [true] = map_choice(choice[true], index - 1, choice_size - 1)
        }
    end
    local false_value = create_default_choice(choice_size - 1, BigUInt:new(0))
    local true_value = choice_sum(choice[false], choice[true], choice_size - 1)

    return {
        [false] = false_value,
        [true] = true_value
    }
end

--- Will assume no cycles exist
---@param origin_id string
---@param tags {[number]: string}
---@return {[string]: Choice}
function Day11.Graph:count_paths_with_tags(origin_id, tags)
    ---@type {[string]: Choice}
    local result = { [origin_id] = create_default_choice(#tags, BigUInt:new(1)) }
    local nodes = self:get_all_nodes()
    local sorted_node_list = topological_sort(nodes, 
        ---@param node Day11.Node
        function(node) 
            return node.comes_from  
        end
    )
    for i = 1, #sorted_node_list do
        local node = sorted_node_list[i]
        local tag_index = -1
        for j = 1, #tags do
            if tags[j] == node.id then
                tag_index = j
            end
        end
        local paths = result[node.id]
        if paths == nil then
            paths = create_default_choice(#tags, BigUInt:new(0))
        end
        local comes_from = sorted_node_list[i].comes_from
        for j = 1, #comes_from do
            local value = result[comes_from[j].id]
            if value ~= nil then
                value = map_choice(value, tag_index, #tags)
                paths = choice_sum(paths, value, #tags)
            end
        end
        result[sorted_node_list[i].id] = paths
    end
  
    return result
end