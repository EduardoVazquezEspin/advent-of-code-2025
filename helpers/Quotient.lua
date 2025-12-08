require "helpers.InheritanceObject"

---@class NodeClass : InheritanceObject
---@field parent NodeClass | nil
local NodeClass = InheritanceObject:new()

---@param params? {["parent"]: NodeClass | nil}
function NodeClass:new(params)
    if params == nil then
        params = {}
    end
    return InheritanceObject.new(self, params)
end

---@class Quotient : InheritanceObject
---@field private _node_map {[any]: NodeClass}
---@field class_count integer
Quotient = InheritanceObject:new()

---@param params {[number]: any} | nil
---@return Quotient
function Quotient:new(params)
    local instance = InheritanceObject.new(self, {
        _node_map = {},
        class_count = 0
    })

    if params ~= nil then
        for i = 1, #params do
            if instance:get_class(params[i]) == nil then
                instance:set_class(params[i])
            end
        end
    end

    return instance
end

---@private
---@param node NodeClass
---@param value any|nil
---@return NodeClass
function Quotient:get_node_class(node, value)
    local parent = node.parent
    if parent == nil then
        return node
    end

    ---@type {[number]: NodeClass}
    local node_list = {node, parent}
    ---@type NodeClass
    local current = parent
    ---@type NodeClass | nil
    local next = current.parent
    while(next ~= nil) do
        node_list[#node_list + 1] = next
        current = next
        next = current.parent
    end

    for i = 1,#node_list-1 do
        node_list[i].parent = current
    end

    if value ~= nil then
        self._node_map[value] = current
    end

    return current
end

---@private
---@param value any
---@return NodeClass | nil
function Quotient:get_class(value)
    local node = self._node_map[value]
    if node == nil then
        return nil
    end

    return self:get_node_class(node, value)
end

---@private
---@param value any
---@param node NodeClass
function Quotient:set_node_class(value, node)
    local previous = self:get_class(value)
    if previous == nil or previous == node then
        self._node_map[value] = node
        return
    end

    previous.parent = node
    self.class_count = self.class_count - 1
    self._node_map[value] = node
end

---@private
---@param value any
function Quotient:set_value_class(value)
    ---@type NodeClass | nil
    local node = self:get_class(value)
    if node ~= nil then
        return
    end
    node = NodeClass:new() 
    self.class_count = self.class_count + 1
    self:set_node_class(value, node)
end

---@param ... {[number]: any}
function Quotient:set_class(...)
    local arg= {...}
    if #arg < 1 then
        return
    end
    self:set_value_class(arg[1])
    ---@type NodeClass
    local node = self:get_class(arg[1])
    for i=2,#arg do
        self:set_node_class(arg[i], node)
    end
end

---@param value1 any
---@param value2 any
function Quotient:set_equal(value1, value2)
    ---@type NodeClass | nil
    local node = self:get_class(value1)
    if node ~= nil then
        self:set_node_class(value2, node)
        return
    end
    node = self:get_class(value2)
    if node == nil then
        self:set_class(value2)
        node = self:get_class(value2)
    end
    self:set_node_class(value1, node)
end


---@param value1 any
---@param value2 any
---@return boolean
function Quotient:are_equal(value1, value2)
    local color1 = self:get_class(value1)
    local color2 = self:get_class(value2)
    if color1 == nil and color2 == nil then
        return value1 == value2
    end
    if color1 == nil or color2 == nil then
        return false
    end
    return color1 == color2
end

---@return {[number]: {[number]: any}}
function Quotient:get_all_classes()
    local result = {}
    for key,v in pairs(self._node_map) do
        local matching = {}
        for index=1,#result do
            if self:are_equal(key, result[index][1]) then
                matching[#matching + 1] = result[index]
            end
        end
        if #matching == 0 then
            result[#result + 1] = {key}
        else
            local list = matching[1]
            list[#list + 1] = key
        end
    end
    return result
end