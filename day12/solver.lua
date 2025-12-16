require "day12.definitions"
require "helpers.Map"

---@class Day12.Part1.Solver : InheritanceObject
---@field shapes Day12.Shapes
---@field problem Day12.Problem
---@field _memo {[string]: boolean}
---@field _pending_shapes {[number]: integer}
---@field _map Map
Day12.Part1.Solver = InheritanceObject:new()

---@param params {["shapes"]: Day12.Shapes, ["problem"]: Day12.Problem}
---@return Day12.Part1.Solver
function Day12.Part1.Solver:new(params)
    local instance = InheritanceObject.new(self, params)
    instance._memo = {}
    instance._pending_shapes = params.problem.shape_amount
    instance._map = Map:new({
        width = params.problem.width, 
        height = params.problem.height,
        default = false
    })
    return instance
end

---@private
---@param self Day12.Part1.Solver
---@param pos_x integer
---@param pos_y integer
---@return string
function Day12.Part1.Solver:get_hash(pos_x, pos_y)
    local result = pos_x .. "," .. pos_y .. ":"
    for i = 1,#self._pending_shapes do
        if i ~=1 then
            result = result .. ","
        end
        result = result .. self._pending_shapes[i]
    end
    result = result .. ":"
    for j = 1,self._map.width do
        for i= 1, self._map.height do
            if self._map:get(i, j) then
                result = result .. "#"
            else
                result = result .. "."
            end
        end
    end
    return result
end

---@private
---@param shape Map
---@param pos_x integer
---@param pos_y integer
---@return boolean
function Day12.Part1.Solver:fits(shape, pos_x, pos_y)
    for i = 1,shape.height do
        for j = 1,shape.width do
            if shape:get(i, j) then
                if pos_y + i - 1 > self._map.height then
                    return false
                end
                if pos_x + j - 1 > self._map.width then
                    return false
                end
                if self._map:get(pos_y + i - 1, pos_x + j - 1) then
                    return false
                end
            end
        end
    end
    return true
end

---@private
---@param shape Map
---@param pos_x integer
---@param pos_y integer
---@return nil
function Day12.Part1.Solver:write(shape, pos_x, pos_y)
    for i = 1,shape.height do
        for j = 1,shape.width do
            if shape:get(i, j) then
                self._map:set(pos_y + i - 1, pos_x + j - 1, true)
            end
        end
    end
end

---@private
---@param shape Map
---@param pos_x integer
---@param pos_y integer
---@return nil
function Day12.Part1.Solver:remove(shape, pos_x, pos_y)
    for i = 1,shape.height do
        for j = 1,shape.width do
            if shape:get(i, j) then
                self._map:set(pos_y + i - 1, pos_x + j - 1, false)
            end
        end
    end
end

---@private
---@param self Day12.Part1.Solver
---@param pos_x integer
---@param pos_y integer
---@return boolean
function Day12.Part1.Solver:solve_rec(pos_x, pos_y)
    local hash = self:get_hash(pos_x, pos_y)
    local memoized = self._memo[hash]
    if memoized ~= nil then
        return memoized
    end

    if pos_x > self._map.width then
        return self:solve_rec(1, pos_y + 1)
    end
    if pos_y > self._map.height then
        local total = 0
        for i = 1, #self._pending_shapes do
            total = total + self._pending_shapes[i]
        end
        if total == 0 then
            self._memo[hash] = true
            print(self._map:to_string(function(it) 
                if it then
                    return "#"
                else
                    return "."
                end
            end))
            return true
        end
        self._memo[hash] = false
        return false
    end

    for shape_index=1, #self.shapes do
        if self._pending_shapes[shape_index] > 0 then
            local symmetry_array = self.shapes[shape_index]
            for symmetry_index = 1, #symmetry_array do
                local shape = symmetry_array[symmetry_index]
                --- Write rec logic
                if self:fits(shape, pos_x, pos_y) then
                    self:write(shape, pos_x, pos_y)
                    self._pending_shapes[shape_index] = self._pending_shapes[shape_index] - 1
                    local result = self:solve_rec(pos_x + 1, pos_y)
                    if result then
                        self._memo[hash] = true
                        return self._memo[hash]
                    end
                    self:remove(shape, pos_x, pos_y)
                    self._pending_shapes[shape_index] = self._pending_shapes[shape_index] + 1
                end
            end
        end
    end

    local result = self:solve_rec(pos_x + 1, pos_y)
    self._memo[hash] = result
    return result
end

function Day12.Part1.Solver:solve()
    local total_shapes = 0
    for i = 1, #self._pending_shapes do
        total_shapes = total_shapes + self._pending_shapes[i]
    end

    local total_shape_area = 0
    for i = 1, #self._pending_shapes do
        local area = 0
        for x=1,3 do
            for y = 1,3 do
                if self.shapes[i][1]:get(x, y) then
                    area = area + 1
                end
            end
        end

        total_shape_area = total_shape_area + self._pending_shapes[i] * area
    end

    if 9 * total_shapes <= self._map.width * self._map.height then
        print("trivially solved")
        return true
    end

    if total_shape_area > self._map.width * self._map.height then
        print("trivially impossible")
        return false
    end

    return self:solve_rec(1, 1)
end