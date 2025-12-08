## Advent of Code 2025 – Lua Solutions

This repository contains my personal solutions for **Advent of Code 2025**, implemented in **Lua**.

You can run the solutions easily using the interactive **Solution Wizard**, or run individual day scripts manually.

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

  - `main.lua` – The interactive Solution Wizard (recommended entry point)
  - `Day1.lua`, `Day2.lua`, ... – Standalone solutions for each Advent of Code day
  - `Input.lua` – Shared input helper used by the day scripts
  - `input.txt` – The puzzle input file (managed automatically by the Wizard)

---

## Usage (Recommended)

The easiest way to run the solutions is via the **Solution Wizard**:

1.  **Clone or download** this repository.
2.  Open your terminal in the project folder.
3.  Start the wizard:
    ```bash
    lua main.lua
    ```
4.  **Follow the prompts**:
      - Enter the **Day number** you want to run (e.g., `1`).
      - **Paste your puzzle input** directly into the terminal.
      - Type `END` on a new line to finish pasting.

The wizard will automatically save your input to `input.txt`, run the specific day's solution, and then loop back so you can run another day without restarting.

---

## Manual Usage

If you prefer to run specific scripts directly or want to manage the input file yourself:

1.  **Paste your Advent of Code input** for the specific day into `input.txt` (replacing any existing content).
2.  Run the Lua script for that day. For example:
    ```bash
    lua Day1.lua
    ```
    Or for Day 2:
    ```bash
    lua Day2.lua
    ```
**Note:** If you switch days manually, you must overwrite `input.txt` with the new day's input before running the script.

---

## Notes

  - The wizard (`main.lua`) handles `input.txt` automatically, so you don't need to manually edit files when using it.
  - These solutions are written for clarity and learning; performance is generally more than sufficient for Advent of Code input sizes.

---

## License

This is a personal Advent of Code solutions repository. Feel free to read and learn from the code; if you reuse any parts, please respect Advent of Code's rules and avoid posting full solutions publicly during the active event.
