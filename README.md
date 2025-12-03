## Advent of Code 2025 – Lua Solutions

This repository contains my personal solutions for **Advent of Code 2025**, implemented in **Lua**.

Each puzzle day is a standalone Lua script (for example `Day1.lua`, `Day2.lua`, …) that reads its input from `input.txt` and prints the answers for **Part 1** and **Part 2** to the terminal.

---

## Prerequisites

- **Lua interpreter** installed (Lua 5.3+ recommended)
- A terminal or command prompt

You can check if Lua is installed with:

```bash
lua -v
```

If you do not have Lua installed, follow the instructions on the official site:
https://www.lua.org/download.html

---

## Project Structure

- `Day1.lua`, `Day2.lua`, `Day3.lua`, ... – solutions for each Advent of Code day
- `Input.lua` – shared input helper used by the day scripts
- `input.txt` – the puzzle input for the day you want to run

Each `DayX.lua` script assumes that `input.txt` in the project root contains the appropriate Advent of Code input for that specific day.

---

## Usage

1. **Clone or download** this repository.
2. Make sure Lua is installed and available on your `PATH`.
3. **Paste your Advent of Code input** for the day you want to run into `input.txt` (replacing any existing content).
4. Run the Lua script for that day. For example, for **Day 1**:

```bash
lua ./Day1.lua
```

Or for **Day 2**:

```bash
lua ./Day2.lua
```

The script will read from `input.txt` and print the solutions for **Part 1** and **Part 2** directly to the terminal.

---

## Notes

- Each day expects `input.txt` to match that day's Advent of Code puzzle input.
- If you switch to a different day, overwrite `input.txt` with the new day's input before running the corresponding `DayX.lua` file.
- These solutions are written for clarity and learning; performance is generally more than sufficient for Advent of Code input sizes.

---

## License

This is a personal Advent of Code solutions repository. Feel free to read and learn from the code; if you reuse any parts, please respect Advent of Code's rules and avoid posting full solutions publicly during the active event.
