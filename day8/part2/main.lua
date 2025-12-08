require "day8.InputReader"
require "helpers.sort"
require "helpers.Quotient"

---@type Day8.InputReader
local reader = Day8.InputReader:new()

local input = reader:read("./day8/part2/input.txt")

local quotient = Quotient:new(input)

---@type {[number]: {[1|2]: {[1|2|3]: integer}, ["distance"]: integer}} 
local pairs = {}
for i = 1,#input-1 do
    for j= i+1, #input do
        local first = input[i]
        local second = input[j]
        pairs[#pairs + 1] = {
            first, 
            second, 
            distance = (first[1]-second[1])*(first[1]-second[1]) + (first[2]-second[2])*(first[2]-second[2]) + (first[3]-second[3])*(first[3]-second[3])
        }
    end
end

quicksort(pairs, function(pair1, pair2) return pair1.distance - pair2.distance <= 0 end)

local index = 1
while quotient.class_count > 1 do
    quotient:set_equal(pairs[index][1], pairs[index][2])
    index = index + 1
end
index = index - 1

print(pairs[index][1][1] * pairs[index][2][1]) --25272