require "day5.InputReader"
require "helpers.helpers"

---@type Day5.InputReader
local reader = InputReader:new()

local input = reader:read("./day5/part1/input.txt")

---@param ingredient integer
---@param ranges Array<Range>
local function is_ingredient_fresh(ingredient, ranges)
    for i=1,#ranges do
        if ingredient >= ranges[i].min and ingredient <= ranges[i].max then
            return true
        end
    end
    return false
end

local total_fresh_ingredients = 0
for i=1,#input.ingredients do
    if is_ingredient_fresh(input.ingredients[i], input.ranges) then
        total_fresh_ingredients = total_fresh_ingredients + 1
    end
end

print(total_fresh_ingredients) --3