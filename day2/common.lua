
local function isTInvalid(t, str)
    local len = string.len(str)
    for i = 1,len-t do
        if string.sub(str, i, i) ~= string.sub(str, i + t, i +t) then
            return false
        end
    end
    return true
end

function isInvalidId(str)
    local len = string.len(str)
    for t = 1,(len-1) do 
        if len / t == math.floor(len / t) then
            if isTInvalid(t, str) then
                return true
            end
        end
    end
    return false
end

function isLen2InvalidId(str)
    local len = string.len(str)
    if len % 2 == 1 then
        return false
    end
    return isTInvalid(math.floor(len /2), str)
end