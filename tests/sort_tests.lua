-- lua tests/Quotient_tests.lua
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

Test.run(silent)