---@class Day11.Node : InheritanceObject
---@field id string
---@field goes_to {[number]: Day11.Node}
---@field comes_from {[number]: Day11.Node}
Day11.Node = InheritanceObject:new()

---@param params {["id"]: string}
---@return Day11.Node
function Day11.Node:new(params)
    ---@type Day11.Node
    local instance = InheritanceObject.new(self,params)
    instance.goes_to = {}
    instance.comes_from = {}
    return instance
end

---@param node Day11.Node
---@return nil
function Day11.Node:add_edge(node)
    self.goes_to[#self.goes_to + 1] = node
    node.comes_from[#node.comes_from + 1] = self
end