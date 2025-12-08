-- # color the terminal

local color = { _NAME = "color" }
local _M = color

local esc = string.char(27, 91)

local names = {'black', 'red', 'green', 'yellow', 'blue', 'pink', 'cyan', 'white'}
local hi_names = {'BLACK', 'RED', 'GREEN', 'YELLOW', 'BLUE', 'PINK', 'CYAN', 'WHITE'}

color.fg, color.bg = {}, {}

for i, name in ipairs(names) do
   color.fg[name] = esc .. tostring(30+i-1) .. 'm'
   _M[name] = color.fg[name]
   color.bg[name] = esc .. tostring(40+i-1) .. 'm'
end

for i, name in ipairs(hi_names) do
   color.fg[name] = esc .. tostring(90+i-1) .. 'm'
   _M[name] = color.fg[name]
   color.bg[name] = esc .. tostring(100+i-1) .. 'm'   
end

local function fg256(_,n)
   return esc .. "38;5;" .. n .. 'm'   
end

local function bg256(_,n)
   return esc .. "48;5;" .. n .. 'm'   
end

setmetatable(color.fg, {__call = fg256})
setmetatable(color.bg, {__call = bg256})

color.reset = esc .. '0m'
color.clear = esc .. '2J'

color.bold = esc .. '1m'
color.faint = esc .. '2m'
color.normal = esc .. '22m'
color.invert = esc .. '7m'
color.underline = esc .. '4m'

color.hide = esc .. '?25l'
color.show = esc .. '?25h'

function color.move(x, y)
   return esc .. y .. ';' .. x .. 'H'
end

color.home = color.move(1, 1)

--------------------------------------------------

function color.chart(ch,col)
   local cols = '0123456789abcdef'

   ch = ch or ' '
   col = col or color.fg.black
   local str = color.reset .. color.bg.WHITE .. col

   for y = 0, 15 do
      for x = 0, 15 do
         local lbl = cols:sub(x+1, x+1)
         if x == 0 then lbl = cols:sub(y+1, y+1) end

         str = str .. color.bg.black .. color.fg.WHITE .. lbl
         str = str .. color.bg(x+y*16) .. col .. ch
      end
      str = str .. color.reset .. "\n"
   end
   return str .. color.reset
end

function color.test()
   print(color.reset .. color.bg.green .. color.fg.RED .. "This is bright red on green" .. color.reset)
   print(color.invert .. "This is inverted..." .. color.reset .. " And this isn't.")
   print(color.fg(0xDE) .. color.bg(0xEE) .. "You can use xterm-256 colors too!" .. color.reset)
   print("And also " .. color.bold .. "BOLD" .. color.normal .. " if you want.")
   print(color.bold .. color.fg.BLUE .. color.bg.blue .. "Miss your " .. color.fg.RED .. "C-64" .. color.fg.BLUE .. "?" .. color.reset)
   print("Try printing " .. color.underline .. _M._NAME .. ".chart()" .. color.reset)
end

-- # Helpers

function tableequals(table1, table2)
    if type(table1) ~= type(table2) then
        return false
    end
    
    if type(table1) == 'table' then
        for table_key, table_value in next, table1, nil do
            if not tableequals(table_value, table2[table_key]) then
                return false
            end
        end        
        for table_key, table_value in next, table2, nil do
            if not tableequals(table_value, table1[table_key]) then
                return false
            end
        end
        return getmetatable(table1) == getmetatable(table2)
    else -- number, string, boolean, etc
        return table1 == table2
    end
end

function tablecontains(table1, table2) --table 1 contains table 2
    if type(table1) ~= type(table2) then
        return false
    end
    
    if type(table2) == 'table' then
        for table_key, table_value in next, table2, nil do
            if not tablecontains(table_value, table1[table_key]) then
                return false
            end
        end
        return true
    else -- number, string, boolean, etc
        return table1 == table2
    end
end

function stringifytable_withdepth(table, depth, firstlinedepth, seen)
    local result = ""
    if table == nil then
        for i=1,firstlinedepth do
            result = " " .. result
        end
        return result .. "nil"
    elseif type(table) == 'table' and not seen[table] then
        seen[table] = true
        for i=1,firstlinedepth do
            result = result .. " "
        end
        result = result .. "{"
        local total = 0
        for table_key, table_value in next, table, nil do
            total = total + 1
            result = result .. "\n" .. stringifytable_withdepth(table_key, depth + 2, depth + 2, seen) .. " = " .. stringifytable_withdepth(table_value, depth + 2, 0, seen)
        end
        if total ~= 0 then
            result = result .. "\n"
            for i=1,depth do
                result = result .. " "
            end
        end
        return result .. "} [" .. tostring(table) .. "]"
    else
        for i=1,firstlinedepth do
            result = " " .. result
        end
        return result .. tostring(table)
    end
end

function stringifytable_flat(table, seen)
    if table == nil then
        return "nil"
    elseif type(table) == 'table' and not seen[table] then
        seen[table] = true
        local result = "[" .. tostring(table) .. "]{"
        for table_key, table_value in next, table, nil do
            result = result .. stringifytable_flat(table_key, seen) .. "=" .. stringifytable_flat(table_value, seen)
        end
        return result .. "}"
    else
        return tostring(table)
    end
end

function stringifytable(table)
    return stringifytable_withdepth(table, 0, 0, {})
end

-- # Printers

local function writeresults(test, data)
    local message = ""
    if data.error then
        message = "· " .. color.bg.yellow .. "WARN"  .. color.reset .. " " .. test.testname .. "\n"
        message = message .. "  " .. data.error
    elseif data.result then
        message = "· " .. color.bg.green .. "PASS"  .. color.reset .. " " .. test.testname
    else
        message = "· " .. color.bg.red .. "FAIL" .. color.reset .. " " .. test.testname .. "\n"
        message = message .. "  Expected: " 
        if string.find(data.expected, "\n") then
            message = message .. "\n"
        end
        message = message .. data.expected
        message = message .. "\n" .. "  Received: "
        if string.find(data.received, "\n") then
            message = message .. "\n"
        end
        message = message .. data.received
        if data.extra then
            message = message .. "\n" .. data.extra 
        end
    end
    return message
end

function writesummary(passed, skipped, total, suitename)
    local summary = ""
    if total == 0 then
        summary = summary .. color.bg.yellow .. "WARN"
    elseif passed == total - skipped then
        summary = summary .. color.bg.green .. "PASS"
    else
        summary = summary .. color.bg.red .. "FAIL"
    end
    summary = summary .. color.reset 
    if total == 0 then
        summary = summary .. " No tests found"
    elseif passed == total - skipped then
        summary = summary .. " " .. passed .. "/" .. total - skipped .. " tests"
    else
        summary = summary .. " " .. passed .. "/" .. total - skipped .. " tests"
    end
    if skipped > 0 then
        summary = summary .. " (" .. skipped .. " skip)"
    end
    while string.len(summary) < 37 do
        summary = summary .. " "
    end
    summary = summary .. " " .. suitename
    if Pathname then
        while string.len(summary) < 77 do
            summary = summary .. " "
        end
        summary = summary .. " " .. Pathname;
    end
    return summary
end

-- # Actual Code

---@param suitename string
function Describe(suitename)
    ---@class Test
    ---@field length number
    ---@field suitename string
    local Test = {length = 0, suitename=suitename}

    local function Assert(received)
        local Received = {negative = false}

        function Received._not()
            Received.negative = not Received.negative
            return Received
        end

        function Received.toFlatBe(expected)
            local result = (type(received) == type(expected) and received == expected)
            local expectedstring = tostring(expected)
            if Received.negative then
                expectedstring = 'not ' .. expectedstring
            end
            Test[Test.current].tests.length = Test[Test.current].tests.length + 1
            Test[Test.current].tests[Test[Test.current].tests.length] = { 
                result = result ~= Received.negative,
                expected = expectedstring,
                received = tostring(received)
           }
        end

        function Received.toBe(expected)
            local result = tableequals(received, expected)
            local expectedstring = stringifytable(expected)
            if Received.negative then
                expectedstring = 'not ' .. expectedstring
            end
            Test[Test.current].tests.length = Test[Test.current].tests.length + 1
            Test[Test.current].tests[Test[Test.current].tests.length] = { 
                result = result ~= Received.negative,
                expected = expectedstring,
                received = stringifytable(received)
            }
        end

        function Received.toBeLessThan(expected)
            local result, expectedstring, receivedstring
            if type(received) ~= 'number' then
                result = false
                expectedstring = 'number'
                receivedstring = stringifytable(received) .. ' is ' .. type(received)
            elseif  type(expected) ~= 'number' then
                result = false
                expectedstring = 'number'
                receivedstring = stringifytable(expected) .. ' is ' .. type(expected)
            else
                result = (received < expected) ~= Received.negative
                receivedstring = tostring(received)
                if Received.negative then
                    expectedstring = '>=' .. tostring(expected)
                else
                    expectedstring = '<' .. tostring(expected)
                end
            end
            Test[Test.current].tests.length = Test[Test.current].tests.length + 1
            Test[Test.current].tests[Test[Test.current].tests.length] = { 
                result = result ,
                expected = expectedstring,
                received = receivedstring
            }
        end

        function Received.toBeLessOrEqualThan(expected)
            local result, expectedstring, receivedstring
            if type(received) ~= 'number' then
                result = false
                expectedstring = 'number'
                receivedstring = stringifytable(received) .. ' is ' .. type(received)
            elseif  type(expected) ~= 'number' then
                result = false
                expectedstring = 'number'
                receivedstring = stringifytable(expected) .. ' is ' .. type(expected)
            else
                result = (received <= expected) ~= Received.negative
                receivedstring = tostring(received)
                if Received.negative then
                    expectedstring = '>' .. tostring(expected)
                else
                    expectedstring = '<=' .. tostring(expected)
                end
            end
            Test[Test.current].tests.length = Test[Test.current].tests.length + 1
            Test[Test.current].tests[Test[Test.current].tests.length] = { 
                result = result ,
                expected = expectedstring,
                received = receivedstring
            }
        end

        function Received.toBeGreaterThan(expected)
            local result, expectedstring, receivedstring
            if type(received) ~= 'number' then
                result = false
                expectedstring = 'number'
                receivedstring = stringifytable(received) .. ' is ' .. type(received)
            elseif  type(expected) ~= 'number' then
                result = false
                expectedstring = 'number'
                receivedstring = stringifytable(expected) .. ' is ' .. type(expected)
            else
                result = (received > expected) ~= Received.negative
                receivedstring = tostring(received)
                if Received.negative then
                    expectedstring = '<=' .. tostring(expected)
                else
                    expectedstring = '>' .. tostring(expected)
                end
            end
            Test[Test.current].tests.length = Test[Test.current].tests.length + 1
            Test[Test.current].tests[Test[Test.current].tests.length] = { 
                result = result ,
                expected = expectedstring,
                received = receivedstring
            }
        end

        function Received.toBeGreaterOrEqualThan(expected)
            local result, expectedstring, receivedstring
            if type(received) ~= 'number' then
                result = false
                expectedstring = 'number'
                receivedstring = stringifytable(received) .. ' is ' .. type(received)
            elseif  type(expected) ~= 'number' then
                result = false
                expectedstring = 'number'
                receivedstring = stringifytable(expected) .. ' is ' .. type(expected)
            else
                result = (received >= expected) ~= Received.negative
                receivedstring = tostring(received)
                if Received.negative then
                    expectedstring = '<' .. tostring(expected)
                else
                    expectedstring = '>=' .. tostring(expected)
                end
            end
            Test[Test.current].tests.length = Test[Test.current].tests.length + 1
            Test[Test.current].tests[Test[Test.current].tests.length] = { 
                result = result ,
                expected = expectedstring,
                received = receivedstring
            }
        end

        function Received.toHaveLength(expected)
            local i = 1
            local actuallength = 0
            local correct = received[expected + 1] == nil
            if not correct then 
                actuallength = ">" .. expected
            end
            while correct and i <= expected do
                correct = correct and not (received[i] == nil)
                if correct then
                    actuallength = actuallength + 1
                end
                i = i + 1
            end
            local expectedstring = expected
            if Received.negative then
                expectedstring = 'not ' .. expectedstring
            end
            Test[Test.current].tests.length = Test[Test.current].tests.length + 1
            Test[Test.current].tests[Test[Test.current].tests.length] = { 
                result = correct ~= Received.negative,
                expected = expectedstring,
                received = actuallength,
                extra = stringifytable(received)
            }
        end

        function Received.toStringContain(expected)
            if type(received) ~= 'string' then
                local expectedstring = 'string'
                if Received.negative then
                    expectedstring = 'not ' .. expectedstring
                end
                Test[Test.current].tests.length = Test[Test.current].tests.length + 1
                Test[Test.current].tests[Test[Test.current].tests.length] = { 
                    result = Received.negative,
                    expected = expectedstring,
                    received = stringifytable(received) .. " is " .. tostring(type(received)),
                }
            else
                local result = string.find(received, expected) ~= nil
                local expectedstring = expected
                if Received.negative then
                    expectedstring = 'not ' .. expectedstring
                end
                Test[Test.current].tests.length = Test[Test.current].tests.length + 1
                Test[Test.current].tests[Test[Test.current].tests.length] = { 
                    result = result ~= Received.negative,
                    expected = expectedstring,
                    received = received,
                }
            end
        end

        function Received.toTableContain(expected)
            local result = tablecontains(received, expected)
            local expectedstring = stringifytable(expected)
            if Received.negative then
                expectedstring = 'not ' .. expectedstring
            end
            Test[Test.current].tests.length = Test[Test.current].tests.length + 1
            Test[Test.current].tests[Test[Test.current].tests.length] = { 
                result = result ~= Received.negative,
                expected = expectedstring,
                received = stringifytable(received),
            }
        end

        function Received.toBeOfType(expected)
            local result = type(received) == expected
            local expectedstring = stringifytable(expected)
            if Received.negative then
                expectedstring = 'not ' .. expectedstring
            end
            Test[Test.current].tests.length = Test[Test.current].tests.length + 1
            Test[Test.current].tests[Test[Test.current].tests.length] = { 
                result = result ~= Received.negative,
                expected = expectedstring,
                received = type(received),
            }
        end

        function Received.toBeNil()
            Received.toBeOfType('nil')
        end

        function Received.toBeBoolean()
            Received.toBeOfType('boolean')
        end

        function Received.toBeNumber()
            Received.toBeOfType('number')
        end

        function Received.toBeString()
            Received.toBeOfType('string')
        end

        function Received.toBeTable()
            Received.toBeOfType('table')
        end

        return Received
    end

    --- @param testname string Name of the test
    --- @param testfunc function Test to run
    function Test.new(testname, testfunc)
        Test.length = Test.length + 1
        Test[Test.length] = {testname = testname, func = testfunc, tests = {length = 0}}
    end

    --- @param testname string Name of the test
    --- @param testfunc function Test to run
    function Test.only(testname, testfunc)
        Test.new(testname, testfunc)
        Test.onlyrun = Test.length
    end

    function Test.run(silentTests, silentSuiteSummary)
        local message = color.bg.pink .. "RUNNING" .. color.reset .. " " .. Test.suitename
        local passed = 0
        local skipped = 0
        for i=1,Test.length do
            if not Test.onlyrun or Test.onlyrun == i then
                Test.current = i
                Test[i].func()

                local result = Test[i].tests.length > 0
                local data = { error = "No assertions implemented" }
                local j=1
                while result and j <= Test[i].tests.length do
                    data = Test[i].tests[j]
                    result = result and data.result
                    j = j + 1
                end

                if data.result then
                    passed = passed + 1
                end

                message = message .. "\n" .. writeresults(Test[i], data)
            else
                skipped = skipped + 1
            end
        end
        if Test.length == 0 then
            message = message .. "\n  " .. color.bg.yellow .. "WARN" .. color.reset .. " No tests found"
        end

        local summary = writesummary(passed, skipped, Test.length, Test.suitename)
        if not silentTests then
            print(message)
        elseif not silentSuiteSummary then
            print(summary)
        end
        return { message = message, summary = summary }
    end

    return { Test = Test, Assert = Assert}
end