require "day12.definitions"
require "day12.parser.SubParser"

---@class Day12.SubParseShape : SubParser
---@field private _map Map
---@field private _row integer
Day12.SubParseShape = Day12.SubParser:new()

---@return Day12.SubParseShape
function Day12.SubParseShape:new()
    return Day12.SubParser.new(self)
end

---@param line string
---@return boolean
function Day12.SubParseShape:StartMatches(line)
    local match = string.match(line,"^%d+:$")
    if match == nil then
        return false
    end
    self._map = Map:new({width = 3, height = 3, default = false})
    self._row = 0
    return true
end

---@param line string
function Day12.SubParseShape:Parse(line)
    if self._row >= 1 and self._row <= 3 then
        for i = 1,3 do
            local value = string.sub(line, i, i) == "#"
            self._map:set(self._row, i, value)
        end
    end
    self._row = self._row + 1
end

---@param line string
---@return boolean
function Day12.SubParseShape:EndMatches(line)
    return line == ""
end

---@param map Map
---@return Map
local function rotate(map)
    local result = Map:new({width =  3, height =  3, default = false})
    for i = 1,3 do
        for j = 1,3 do
            result:set(j,4-i, map:get(i, j))
        end
    end
    return result
end

---@param map Map
---@return Map
local function reflect(map)
    local result = Map:new({width =  3, height =  3, default = false})
    for i = 1,3 do
        for j = 1,3 do
            result:set(4-i,j, map:get(i, j))
        end
    end
    return result
end

---@param map Map
---@return {[number]: Map}
local function get_all_symmetries(map)
    local symmetries = {map}
    symmetries[2] = rotate(map)
    symmetries[3] = rotate(symmetries[2])
    symmetries[4] = rotate(symmetries[3])
    symmetries[5] = reflect(map)
    symmetries[6] = rotate(symmetries[5])
    symmetries[7] = rotate(symmetries[6])
    symmetries[8] = rotate(symmetries[7])

    local result = {}
    for i = 1, #symmetries do
        local is_already_included = false
        local index = 1
        while not is_already_included and index <= #result do
            is_already_included = symmetries[i]:equals(result[index])
            index = index + 1
        end
        if not is_already_included then
            result[#result + 1] = symmetries[i]
        end
    end
    return result
end

---@param result Day12.Input
function Day12.SubParseShape:EndParse(result)
    result.shapes[#result.shapes + 1] = get_all_symmetries(self._map)
end