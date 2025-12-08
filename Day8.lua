local input = require("Input")

---@class JunctionBox
---@field x number
---@field y number
---@field z number

---@class ConnectionCandidate
---@field boxIndexA number
---@field boxIndexB number
---@field distanceSquared number

---@class CircuitSolver
---@field junctionBoxes JunctionBox[]
---@field parentIndices number[]
local CircuitSolver = {}
CircuitSolver.__index = CircuitSolver

---@param inputStr string
---@return CircuitSolver solver
function CircuitSolver:New(inputStr)
    local instance = setmetatable({}, self)
    instance.junctionBoxes = {}

    for xStr, yStr, zStr in inputStr:gmatch("(%d+),(%d+),(%d+)") do
        table.insert(instance.junctionBoxes, {
            x = tonumber(xStr),
            y = tonumber(yStr),
            z = tonumber(zStr)
        })
    end

    instance.parentIndices = {}
    for boxIndex = 1, #instance.junctionBoxes do
        instance.parentIndices[boxIndex] = boxIndex
    end

    return instance
end

---@param boxIndex number
---@return number representativeIndex
function CircuitSolver:FindRepresentative(boxIndex)
    if self.parentIndices[boxIndex] == boxIndex then
        return boxIndex
    end

    local representativeIndex = self:FindRepresentative(self.parentIndices[boxIndex])
    self.parentIndices[boxIndex] = representativeIndex

    return representativeIndex
end

---@param boxIndexA
---@param boxIndexB
---@return boolean
function CircuitSolver:ConnectCircuits(boxIndexA, boxIndexB)
    local representativeA = self:FindRepresentative(boxIndexA)
    local representativeB = self:FindRepresentative(boxIndexB)

    if representativeA ~= representativeB then
        self.parentIndices[representativeA] = representativeB
        return true
    end

    return false
end

---@return number
function CircuitSolver:GetSolution1()
    ---@type ConnectionCandidate[]
    local allPossibleConnections = {}
    local boxCount = #self.junctionBoxes

    for indexA = 1, boxCount do
        for indexB = indexA + 1, boxCount do
            local boxA = self.junctionBoxes[indexA]
            local boxB = self.junctionBoxes[indexB]

            local deltaX = boxA.x - boxB.x
            local deltaY = boxA.y - boxB.y
            local deltaZ = boxA.z - boxB.z

            local distanceSquared = (deltaX * deltaX) + (deltaY * deltaY) + (deltaZ * deltaZ)

            table.insert(allPossibleConnections, {
                boxIndexA = indexA,
                boxIndexB = indexB,
                distanceSquared = distanceSquared
            })
        end
    end

    table.sort(allPossibleConnections, function(connectionA, connectionB)
        return connectionA.distanceSquared < connectionB.distanceSquared
    end)

    local maxConnectionsToProcess = 1000
    local actualLimit = math.min(maxConnectionsToProcess, #allPossibleConnections)

    for i = 1, actualLimit do
        local connection = allPossibleConnections[i]
        self:ConnectCircuits(connection.boxIndexA, connection.boxIndexB)
    end

    ---@type table<number, number>
    local circuitSizeMap = {}

    for boxIndex = 1, boxCount do
        local representativeIndex = self:FindRepresentative(boxIndex)

        local currentCount = circuitSizeMap[representativeIndex] or 0
        circuitSizeMap[representativeIndex] = currentCount + 1
    end

    ---@type number[]
    local sortedSizes = {}
    for _, size in pairs(circuitSizeMap) do
        table.insert(sortedSizes, size)
    end

    table.sort(sortedSizes, function(sizeA, sizeB) return sizeA > sizeB end)

    local largest = sortedSizes[1] or 0
    local secondLargest = sortedSizes[2] or 0
    local thirdLargest = sortedSizes[3] or 0

    return largest * secondLargest * thirdLargest
end

local solver = CircuitSolver:New(input)
local result1 = solver:GetSolution1()
print(("Solution 1: %d"):format(result1))