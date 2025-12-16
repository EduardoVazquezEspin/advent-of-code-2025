---@generic T : table
---@param orig T
---@return T
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
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

---@param table table
---@return string
function stringifytable(table)
    return stringifytable_withdepth(table, 0, 0, {})
end

---@param table1 table
---@param table2 table
---@return boolean
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

---@param inputstr string
---@param sep string
---@return {[number]: string}
function stringsplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[#t + 1] = str
    end
    return t
end
