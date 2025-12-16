-- lua tests/sort_tests.lua
Pathname = debug.getinfo(1).source
require "tests.Test"
require "helpers.sort"

local Suite = Describe('Sorting algorithms')
local Test = Suite.Test
local Assert = Suite.Assert

Test.new("Quicksort works properly", function()
    local array = {8, 10, 18, 9, 7, 17, 1, 16, 14, 5, 3, 15, 11, 2, 19, 13, 6, 4, 12, 20}
    quicksort(array, function(x, y) return x-y <= 0 end)
    for i = 1, #array-1 do
        Assert(array[i]).toBeLessOrEqualThan(array[i+1])
    end
end)

Test.only("TopologicalSort works properly", function()
    local array = {8, 10, 18, 9, 7, 17, 1, 16, 14, 5, 3, 15, 11, 2, 19, 13, 6, 4, 12, 20}
    function get_proper_divsors(num)
        local result = {}
        for i = 1, num-1 do
            if num % i == 0 then
                result[#result + 1] = i
            end
        end
        return result
    end

    local sort = topological_sort(array, get_proper_divsors)
    for i=1,#sort-1 do
        Assert(sort[i] % sort[i + 1])._not().toBe(0)
    end
end)

Test.run(silent)