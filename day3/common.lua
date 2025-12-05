---@param bank {[number]: number}
---@return integer
function find_largest_joltage_2(bank)
    local max = 0
    for i=1,#bank-1 do
        for j=i+1,#bank do
            local num = tonumber(bank[i] .. bank[j]) 
            if num > max then
                max = num 
            end
        end
    end
    return max
end

---@param bank {[number]: number}
---@param joltage_len integer
---@param index integer
---@return integer
function find_largest_joltage(bank, joltage_len, index)
    ---@type integer
    local max_lead_digit = 0
    ---@type integer
    local max_index = 0
    for i = index,#bank-joltage_len+1 do
        if bank[i] > max_lead_digit then
            max_lead_digit = bank[i]
            max_index = i
        end
    end
    if joltage_len == 1 then
        return max_lead_digit
    end
    local rec = find_largest_joltage(bank, joltage_len - 1, max_index +1)
    return math.floor(10^(joltage_len - 1)) * max_lead_digit + rec
end