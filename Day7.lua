local input = require("Input")

---@enum CellType
local CellType = {Start = "S", Splitter = "^", Path = "|", Empty = "."}

---@class Cell
local Cell = {
    ---@type number
    _x = 0,
    ---@type number
    _y = 0,
    ---@type CellType
    _type = ""
}

---@param x number
---@param y number
---@param cellType CellType
---@return Cell cell
function Cell:New(x, y, cellType)
    local cell = setmetatable({}, {__index = Cell})
    cell._x = x
    cell._y = y
    cell._type = cellType
    return cell
end

---@class Grid
local Grid = {
    ---@type Cell[][]
    _cells = {}
}

function Grid:New()
    local grid = setmetatable({}, {__index = Grid})
    return grid
end

---@param input string
function Grid:ParseInput(input)
    self._cells = {}
    local row = 1
    for rowStr in input:gmatch("[^\n]+") do
        self._cells[row] = {}
        local col = 1
        for char in rowStr:gmatch(".") do
            self._cells[row][col] = Cell:New(col, row, char)
            col = col + 1
        end
        row = row + 1
    end
end

function Grid:PrintGrid(grid)
    for y, xTbl in ipairs(grid or self._cells) do
        local line = ""
        for x, cell in pairs(xTbl) do line = line .. cell._type end
        print(line)
    end
end

function Grid:GetCopy(tbl)
    local newTbl = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            newTbl[k] = self:GetCopy(v)
        else
            newTbl[k] = v
        end
    end
    return newTbl
end

---@return number splitCount
---@return Cell[][] solutionGrid
function Grid:GetSolution1()
    local grid = self:GetCopy(self._cells)
    local splitCount = 0
    for y, xTbl in ipairs(grid) do
        for x, cell in pairs(xTbl) do
            if cell._type == "S" then
                grid[y + 1][x] = Cell:New(x, y + 1, "|")
            elseif cell._type == "^" and grid[y - 1] and grid[y - 1][x]._type == "|" then
                splitCount = splitCount + 1
                grid[y][x - 1] = Cell:New(x - 1, y, "|")
                grid[y][x + 1] = Cell:New(x + 1, y, "|")
            elseif grid[y - 1] and grid[y - 1][x]._type == "|" then
                grid[y][x] = Cell:New(x, y, "|")
            end
        end
    end
    return splitCount, grid
end

local grid = Grid:New()
grid:ParseInput(input)
local splitCount, solutionGrid = grid:GetSolution1()
print(("Solution 1: %d"):format(splitCount))