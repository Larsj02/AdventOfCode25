---@class Dial
local Dial = {
    _position = 0,
    _high = 99,
    _low = 0,
    _zeroCount = 0,
    _countAnyClick = false,
}

---@param num number
---@param addition number
---@param compareFunc fun(pos:number):boolean
---@param rotationEnd number
function Dial:Move(num, addition, compareFunc, rotationEnd)
    for _ = 1, num do
        self._position = self._position + addition
        if compareFunc(self._position) then
            self._position = rotationEnd
        end
        if self._countAnyClick then
            self:CheckZero()
        end
    end
    if not self._countAnyClick then
        self:CheckZero()
    end
end

---@param num number
function Dial:L(num)
    self:Move(num, -1, function(pos) return pos < self._low end, self._high)
end

---@param num number
function Dial:R(num)
    self:Move(num, 1, function(pos) return pos > self._high end, self._low)
end

---@param instructions string
function Dial:Input(instructions)
    for dir, num in instructions:gmatch("([LR])(%d+)") do
        self[dir](self, num)
    end
end

function Dial:CheckZero()
    if self._position == 0 then
        self._zeroCount = self._zeroCount + 1
    end
end

---@return number password
function Dial:GetPassword()
    return self._zeroCount
end

---@param position number|nil
---@param countAnyClick boolean|nil
---@param high number|nil
---@param low number|nil
function Dial:Reset(position, countAnyClick, high, low)
    self._position = tonumber(position) or 0
    self._countAnyClick = countAnyClick or false
    self._high = tonumber(high) or 99
    self._low = tonumber(low) or 0
    self._zeroCount = 0
end

---@param position number|nil
---@param countAnyClick boolean|nil
---@param high number|nil
---@param low number|nil
---@return Dial dial
function Dial:New(position, countAnyClick, high, low)
    local dial = setmetatable({}, { __index = Dial })
    dial:Reset(position, countAnyClick, high, low)
    return dial
end

local input = require("Input")

local p1 = Dial:New(50)
p1:Input(input)
print(("Solution 1: %d"):format(p1:GetPassword()))
local p2 = Dial:New(50, true)
p2:Input(input)
print(("Solution 2: %d"):format(p2:GetPassword()))
