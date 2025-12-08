require "day8.InputReader"
require "helpers.sort"
require "helpers.Quotient"

---@type Day8.InputReader
local reader = Day8.InputReader:new()

local input = reader:read("./day8/part1/input.txt")

local quotient = Quotient:new(input)

local PAIRS_TO_CONNECT = 1000

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

for i = 1,PAIRS_TO_CONNECT do
    quotient:set_equal(pairs[i][1], pairs[i][2])
end

local classes = quotient:get_all_classes()

quicksort(classes, function(class1, class2) return #class1 - #class2 >= 0 end)

result = #(classes[1]) * #(classes[2]) * #(classes[3])

print(result) --40