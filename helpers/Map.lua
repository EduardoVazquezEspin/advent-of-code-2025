require "helpers.InheritanceObject"

---@generic T
---@class Map<T> : InheritanceObject
---@field width integer
---@field height integer
---@field default T
---@field private _map {[number]: {[number]: T} } 
Map = InheritanceObject:new()

---@generic T
---@param params {["width"]: integer, ["height"]: integer, ["default"]: T}
function Map:new(params)
    local this = InheritanceObject.new(self, params)
    this._map = {}
    return this
end

---@generic T
---@param i integer
---@param j integer
---@return T | nil
function Map:get(i, j)
    if i < 1 or i > self.width then
        return nil
    end
    if j < 1 or j > self.height then
        return nil
    end
    local value = self._map[i][j]
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
    if i < 1 or i > self.width then
        return nil
    end
    if j < 1 or j > self.height then
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
function Map:adjacents(i, j)
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
