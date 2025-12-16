---@param array {[number]: any}
---@param index1 integer
---@param index2 integer
local function swap(array, index1, index2)
    local x = array[index1]
    array[index1] = array[index2]
    array[index2] = x
end

---@param a boolean
---@param b boolean
---@return boolean
local function xor(a,b)
    return (a or b) and not (a and b)
end


---@generic T
---@param array {[number]: T}
---@param comparer function(value1: T, value2: T): boolean
---@param start integer?
---@param stop integer?
function quicksort(array, comparer, start, stop)
    if start == nil then
        start = 1
    end
    if stop == nil then
        stop = #array + 1
    end
    local diff = stop - start
    if diff <= 1 then
        return
    end
    local index = start + math.random(stop - start) - 1
    swap(array, index, stop - 1)
    local pivot_index = stop - 1
    local pivot_value = array[pivot_index]
    local comparer_index = start
    local is_inverted = false
    while comparer_index ~= pivot_index do
        local have_to_swap = xor(is_inverted, comparer(pivot_value, array[comparer_index]))
        if have_to_swap then
            swap(array, pivot_index, comparer_index)
            local x = pivot_index
            pivot_index = comparer_index
            comparer_index = x
            is_inverted = not is_inverted
        end
        if is_inverted then
            comparer_index = comparer_index - 1
        else
            comparer_index = comparer_index + 1
        end
    end

    quicksort(array, comparer, start, pivot_index)
    quicksort(array, comparer, pivot_index + 1, stop)
end

---@generic T
---@param nodes {[number]: T}
---@param get_children function(node: T): {[number]: T}
---@return {[number]: T}
function topological_sort(nodes, get_children)
  local result = {}
  ---@type {[number]: {["type"]: "eval"|"add", ["node"]: T}}
  local stack = {}
  for i=1,#nodes do
    stack[#stack + 1] = {type = "eval", node = nodes[i]}
  end
  ---@type {[T]: boolean}
  local visited = {}
  ---@type {["type"]: "eval"|"add", ["node"]: T} | nil
  local top = stack[#stack] 
  stack[#stack] = nil
  while top ~= nil do
    if top.type == "add" then
        result[#result + 1] = top.node
    elseif visited[top.node] == nil then
        visited[top.node] = true
        stack[#stack + 1]= {type = "add", node = top.node}
        local children = get_children(top.node)
        for i = 1, #children do
            stack[#stack + 1] = {type = "eval", node = children[i]}
        end
    end
    top = stack[#stack]
    stack[#stack] = nil
  end
  return result
end