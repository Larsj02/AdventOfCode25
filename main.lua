local function clearScreen()
    if package.config:sub(1,1) == "\\" then
        os.execute("cls")
    else
        os.execute("clear")
    end
end

local function safeRead()
    return io.stdin:read("*l")
end

local function printSeparator()
    print("----------------------------------------")
end

local function printHeader(heading)
    print(("=== %s ==="):format(heading))
end

while true do
    clearScreen()
    printHeader("ADVENT OF CODE - SOLUTION WIZARD")

    io.input(io.stdin)

    print("Which day would you like to run? (e.g. 1, 12)")
    print("(Type 'q' or 'exit' to quit)")
    io.write("> ")

    local day = safeRead()

    if not day or day:lower() == "q" or day:lower() == "exit" then
        print("Goodbye!")
        break
    end

    printHeader("INPUT ENTRY")
    print("Paste your input below. Type 'END' on a new line to finish:")
    printSeparator()

    local input_lines = {}
    while true do
        local line = safeRead()
        if not line or line == "END" then break end
        table.insert(input_lines, line)
    end

    local f = io.open("input.txt", "w")
    if f then
        f:write(table.concat(input_lines, "\n"))
        f:close()
    else
        print("Error: Could not write to input.txt")
    end

    package.loaded["Input"] = nil

    printHeader(("RUNNING DAY %s"):format(day))
    printSeparator()

    local filename = ("Day%s.lua"):format(day)
    local status, err = pcall(dofile, filename)

    printSeparator()
    if status then
        print("Finished.")
    else
        print(("Error running Day %s: %s"):format(day, err))
    end

    print("\nPress [Enter] to run another day...")
    safeRead()
end