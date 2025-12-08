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

---@return Grid grid
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

---@param grid Cell[][]
function Grid:PrintGrid(grid)
    for y, xTbl in ipairs(grid or self._cells) do
        local line = ""
        for x, cell in pairs(xTbl) do line = line .. cell._type end
        print(line)
    end
end

---@param tbl table
---@return table tblCopy
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

---@return number totalTimelines
function Grid:GetSolution2()
    local counts = {}
    local maxY = #self._cells

    local maxX = 0
    if maxY > 0 then maxX = #self._cells[1] end

    local function addCount(y, x, amount)
        if not counts[y] then counts[y] = {} end
        counts[y][x] = (counts[y][x] or 0) + amount
    end

    for y, row in ipairs(self._cells) do
        for x, cell in pairs(row) do
            if cell._type == "S" then
                addCount(y, x, 1)
            end
        end
    end

    for y = 1, maxY do
        if counts[y] then
            for x, count in pairs(counts[y]) do
                if x >= 1 and x <= maxX then
                    local cellType = self._cells[y][x]._type

                    if cellType == "^" then
                        addCount(y + 1, x - 1, count)
                        addCount(y + 1, x + 1, count)
                    else
                        addCount(y + 1, x, count)
                    end
                else
                    addCount(y + 1, x, count)
                end
            end
        end
    end

    local totalTimelines = 0
    if counts[maxY + 1] then
        for _, count in pairs(counts[maxY + 1]) do
            totalTimelines = totalTimelines + count
        end
    end
    return totalTimelines
end

local grid = Grid:New()
grid:ParseInput(input)
local splitCount = grid:GetSolution1()
print(("Solution 1: %d"):format(splitCount))
local totalTimelines = grid:GetSolution2()
print(("Solution 2: %d"):format(totalTimelines))