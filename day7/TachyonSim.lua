require "helpers.InheritanceObject"
require "helpers.Map"
require "helpers.helpers"
require "day7.definitions"

---@class Day7.TachyonSim : InheritanceObject
---@field Map Map
---@field private _start integer
Day7.TachyonSim = InheritanceObject:new()

---@param params {["map"]: Map}
function Day7.TachyonSim:new(params)
    ---@type Day7.TachyonSim
    local instance = InheritanceObject.new(self, params)
    instance.Map = params.map
    for j = 1, params.map.width do
        if params.map:get(1, j) == "S" then
            instance._start = j
        end
    end
    return instance
end

---@return integer
function Day7.TachyonSim:Simulate()
    local split_count = 0
    ---@type {[number]: integer}
    local beans = {self._start}
    for i=2, self.Map.height do
        ---@type {[number]: integer}
        local new_beans = {}
        for t=1,#beans do
            -- Bean is not split
            if self.Map:get(i, beans[t]) ~= "^" then
                if new_beans[#new_beans] ~= beans[t] then
                    new_beans[#new_beans + 1] = beans[t]
                end
            else -- Bean is split
                split_count = split_count + 1
                if new_beans[#new_beans] ~= beans[t] - 1 then
                    new_beans[#new_beans + 1] = beans[t] - 1
                end 
                new_beans[#new_beans + 1] = beans[t] + 1
            end
        end
        beans = new_beans
    end
    return split_count
end

---@param dict {[number]: integer}
---@param index integer
---@param value integer | nil
local function safely_add(dict, index, value)
    if value == nil then
        return
    end
    if dict[index] == nil then
        dict[index] = 0
    end
    dict[index] = dict[index] + value
end

---@return integer
function Day7.TachyonSim:SimulateQuantum()
    ---@type {[number]: integer}
    local beans = {[self._start] = 1}
    for i=2, self.Map.height do
        ---@type {[number]: integer}
        local new_beans = {}
        for j=1,self.Map.width do
            -- Bean is not split
            if self.Map:get(i, j) ~= "^" then
                safely_add(new_beans, j, beans[j])
            else -- Bean is split
                safely_add(new_beans, j-1, beans[j])
                safely_add(new_beans, j+1, beans[j])
            end
        end
        beans = new_beans
    end
    local total = 0
    for j=1,self.Map.width do
        if beans[j] ~= nil then
            total = total + beans[j]
        end
    end
    return total
end

