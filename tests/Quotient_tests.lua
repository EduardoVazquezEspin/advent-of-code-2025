-- lua tests/Quotient_tests.lua
Pathname = debug.getinfo(1).source
require "tests.Test"
require "helpers.Quotient"

local Suite = Describe('Quotient helper class')
local Test = Suite.Test
local Assert = Suite.Assert

Test.new("Initializing a Quotient with an array will return the number of elements", function()
    local quotient = Quotient:new({"a", "b", "c", "d"})
    Assert(quotient.class_count).toBe(4)
end)

Test.new("set_equal will reduce the number of classes", function()
    local quotient = Quotient:new({"a", "b", "c", "d"})
    quotient:set_equal("a", "b")
    Assert(quotient.class_count).toBe(3)
    quotient:set_equal("a", "c")
    Assert(quotient.class_count).toBe(2)
    quotient:set_equal("b", "c")
    Assert(quotient.class_count).toBe(2)
    quotient:set_equal("a", "d")
    Assert(quotient.class_count).toBe(1)
end)

Test.new("get_all_classes will return a list of lists", function()
    local quotient = Quotient:new({"a", "b", "c", "d"})
    quotient:set_equal("a", "b")
    quotient:set_equal("a", "c")
    local classes = quotient:get_all_classes()
    Assert(quotient.class_count).toBe(2)
    Assert(#classes).toBe(2)
    Assert(#(classes[1]) * #(classes[2])).toBe(3)
end)

Test.new("get_all_classes will return the correct classes", function()
    local quotient = Quotient:new({"a", "b", "c", "d", "e"})
    quotient:set_equal("a", "b")
    quotient:set_equal("c", "d")
    quotient:set_equal("a", "e")
    quotient:set_equal("a", "c")
    local classes = quotient:get_all_classes()
    Assert(quotient.class_count).toBe(1)
    Assert(#classes).toBe(1)
    Assert(#(classes[1])).toBe(5)
end)

Test.run(silent)