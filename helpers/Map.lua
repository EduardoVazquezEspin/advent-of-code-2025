require "helpers.InheritanceObject"

---@generic T
---@class Map<T> : InheritanceObject
---@field width integer
---@field height integer
---@field default T
---@field private _map {[integer]: {[integer]: T} } 
Map = InheritanceObject:new()

---@generic T
---@param params {["width"]: integer, ["height"]: integer, ["default"]: T}
---@return Map<T>
function Map:new(params)
    ---@type Map<T>
    local this = InheritanceObject.new(self, params)
    this._map = {}
    return this
end

---@generic T
---@param i integer
---@param j integer
---@return T | nil
function Map:get(i, j)
    if i < 1 or i > self.height then
        return nil
    end
    if j < 1 or j > self.width then
        return nil
    end
    local row_value = self._map[i]
    if row_value == nil then
        return self.default
    end
    local value = row_value[j]
    if value == nil then
        return self.default
    end
    return value
end

---@generic T
---@param i integer
---@param j integer
---@param value T
function Map:set(i, j, value)
    if i < 1 or i > self.height then
        error("WOAH")
        return nil
    end
    if j < 1 or j > self.width then
        error("WOAH")
        return nil
    end
    if self._map[i] == nil then
        self._map[i] = {}
    end
    self._map[i][j] = value
end

---@generic T
---@param i integer
---@param j integer
---@return {[number]: T}
function Map:get_adjacents(i, j)
    local result = {}
    local value = self:get(i-1, j-1)
    if value ~= nil then
        result[#result + 1] = value
    end
    value = self:get(i-1, j)
    if value ~= nil then
        result[#result + 1] = value
    end
    value = self:get(i-1, j+1)
    if value ~= nil then
        result[#result + 1] = value
    end
    value = self:get(i, j-1)
    if value ~= nil then
        result[#result + 1] = value
    end
    value = self:get(i, j+1)
    if value ~= nil then
        result[#result + 1] = value
    end
    value = self:get(i+1, j-1)
    if value ~= nil then
        result[#result + 1] = value
    end
    value = self:get(i+1, j)
    if value ~= nil then
        result[#result + 1] = value
    end
    value = self:get(i+1, j+1)
    if value ~= nil then
        result[#result + 1] = value
    end
    return result
end

---@param map Map
---@return boolean
function Map:equals(map)
    if map.width ~= self.width then
        return false
    end
    if map.height ~= self.height then
        return false
    end
    for i, row in pairs(self._map) do
        for j, value in pairs(row) do
            if map:get(i,j) ~= value then
                return false
            end
        end
    end
    for i, row in pairs(map._map) do
        for j, value in pairs(row) do
            if self:get(i,j) ~= value then
                return false
            end
        end
    end
    return true
end

---@param projector nil | function(char: T): string
---@return string
function Map:to_string(projector)
    if projector == nil then
        projector = function(thing)
            return thing
        end
    end

    local result = ""
    for i = 1, self.height do
        for j = 1, self.width do
            result = result .. projector(self:get(i, j))
        end
        result = result .. "\n"
    end
    return result
end