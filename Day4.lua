---@enum FieldType
local TYPES = {
    EMPTY = ".",
    PAPER = "@",
}

local directions = {}
for y = -1, 1 do
    for x = -1, 1 do
        if not (x == 0 and y == 0) then
            table.insert(directions, { x = x, y = y })
        end
    end
end

---@class Field
local Field = {
    ---@type FieldType
    _type = "."
}

---@param fieldType FieldType
---@return Field field
function Field:New(fieldType)
    local field = setmetatable({}, { __index = Field })
    field._type = fieldType
    return field
end

---@class Diagram
local Diagram = {
    ---@type Field[][]
    _grid = {},
}

---@param input string
function Diagram:ParseInput(input)
    local y = 1
    for line in input:gmatch("[^\n]+") do
        self._grid[y] = {}
        local x = 1
        for char in line:gmatch(".") do
            self._grid[y][x] = Field:New(char)
            x = x + 1
        end
        y = y + 1
    end
end

---@return number accessable
---@return {x:number, y:number} removable
function Diagram:GetNumAccessable()
    local count, removable = 0, {}
    for y, field in ipairs(self._grid) do
        for x, f in ipairs(field) do
            if f._type == TYPES.PAPER then
                local adjacentRolls = 0
                for _, dir in ipairs(directions) do
                    local checkX = x + dir.x
                    local checkY = y + dir.y
                    if self._grid[checkY] and self._grid[checkY][checkX] then
                        local checkField = self._grid[checkY][checkX]
                        if checkField._type == TYPES.PAPER then
                            adjacentRolls = adjacentRolls + 1
                        end
                    end
                end
                if adjacentRolls < 4 then
                    count = count + 1
                    table.insert(removable, { x = x, y = y })
                end
            end
        end
    end
    return count, removable
end

---@return number totalAccessable
function Diagram:CountAndRemoveAccessable()
    local count = 0
    repeat
        local accessable, removable = self:GetNumAccessable()
        if accessable == 0 then
            break
        end
        count = count + accessable
        for _, pos in ipairs(removable) do
            self._grid[pos.y][pos.x]._type = TYPES.EMPTY
        end
    until false
    return count
end

---@return Diagram diagram
function Diagram:New()
    local diagram = setmetatable({}, { __index = Diagram })
    return diagram
end

local input = require("Input")
local diagram = Diagram:New()
diagram:ParseInput(input)
local accessable = diagram:GetNumAccessable()
print("Solution 1: " .. accessable)
local totalAccessable = diagram:CountAndRemoveAccessable()
print("Solution 2: " .. totalAccessable)