---@class Validator
local Validator = {}

---@param numberStr string|number
---@return boolean isValid
function Validator:Validate(numberStr)
    numberStr = tostring(numberStr)
    if numberStr[1] == "0" then
        return false
    end
    local nLen = #numberStr
    if nLen % 2 ~= 0 then
        return true
    end
    local first = numberStr:sub(1, nLen / 2)
    local last = numberStr:sub(nLen / 2 + 1, nLen)
    return first ~= last
end

---@param firstNum string|number
---@param lastNum string|number
---@return number sum
function Validator:ValidateRange(firstNum, lastNum)
    local sum = 0
    local firstNum, lastNum = tonumber(firstNum), tonumber(lastNum)
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

---@return Validator
function Validator:New()
    local val = setmetatable({}, {
        __index = Validator
    })

    return val
end

local val = Validator:New()
print(val:ValidateSequence([[
  9595822750-9596086139,1957-2424,88663-137581,48152-65638,12354817-12385558,435647-489419,518494-609540,2459-3699,646671-688518,195-245,295420-352048,346-514,8686839668-8686892985,51798991-51835611,8766267-8977105,2-17,967351-995831,6184891-6331321,6161577722-6161678622,912862710-913019953,6550936-6625232,4767634976-4767662856,2122995-2257010,1194-1754,779-1160,22-38,4961-6948,39-53,102-120,169741-245433,92902394-92956787,531-721,64-101,15596-20965,774184-943987,8395-11781,30178-47948,94338815-94398813
]]))
