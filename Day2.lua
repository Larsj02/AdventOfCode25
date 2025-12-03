---@class Validator
local Validator = {
    _anyRepeats = false,
}

---@param numberStr string|number
---@return boolean isValid
function Validator:Validate(numberStr)
    numberStr = tostring(numberStr)
    if numberStr[1] == "0" then
        return false
    end

    if self._anyRepeats then
        local nLen = #numberStr
        for i = nLen - 1, 1, -1 do
            if nLen % i == 0 then
                local lastSegment
                local fullMatch = true
                for s = 1, nLen, i do
                    local segment = numberStr:sub(s, s + i - 1)
                    if not lastSegment then lastSegment = segment end
                    if segment ~= lastSegment then
                        fullMatch = false
                        break
                    end
                end
                if fullMatch then return false end
            end
        end
        return true
    else
        local nLen = #numberStr
        if nLen % 2 ~= 0 then
            return true
        end
        local first = numberStr:sub(1, nLen / 2)
        local last = numberStr:sub(nLen / 2 + 1, nLen)
        return first ~= last
    end
end

---@param firstNum string|number|nil
---@param lastNum string|number|nil
---@return number sum
function Validator:ValidateRange(firstNum, lastNum)
    local sum = 0
    firstNum, lastNum = tonumber(firstNum), tonumber(lastNum)
    if not (firstNum and lastNum) then
        return 0
    end
    for checkNum = firstNum, tonumber(lastNum) do
        if not self:Validate(checkNum) then
            sum = sum + checkNum
        end
    end
    return sum
end

---@param sequence string
---@return number sum
function Validator:ValidateSequence(sequence)
    local sum = 0
    for firstNum, lastNum in sequence:gmatch("(%d+)-(%d+)") do
        sum = sum + self:ValidateRange(firstNum, lastNum)
    end
    return sum
end

---@param anyRepeats boolean|nil
---@return Validator
function Validator:New(anyRepeats)
    local val = setmetatable({}, {
        __index = Validator
    })

    if anyRepeats then
        val._anyRepeats = true
    end

    return val
end

local input = require("Input")
local p1 = Validator:New()
print(("Solution 1: %d"):format(p1:ValidateSequence(input)))
local p2 = Validator:New(true)
print(("Solution 2: %d"):format(p2:ValidateSequence(input)))