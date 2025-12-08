local input = require("Input")

local grid = {}

local row = 1
for rowStr in input:gmatch("[^\n]+") do
    grid[row] = {}
    local col = 1
    for char in rowStr:gmatch(".") do
        grid[row][col] = char
        col = col + 1
    end
    row = row + 1
end

local splitCount = 0
for y, xTbl in ipairs(grid) do
    for x, char in pairs(xTbl) do
      if char == "S" then
        grid[y+1][x] = "|"
      elseif char == "^" and grid[y-1][x] == "|" then
        splitCount = splitCount + 1
        grid[y][x-1] = "|"
        grid[y][x+1] = "|"
      elseif grid[y-1] and grid[y-1][x] == "|" then
        grid[y][x] = "|"
      end
    end
end

for x, xTbl in ipairs(grid) do
    local line = ""
    for y, char in pairs(xTbl) do
        line = line .. char
    end
    print(line)
end
print(("Solution 1: %d"):format(splitCount))