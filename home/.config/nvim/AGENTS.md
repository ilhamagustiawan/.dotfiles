# AGENTS.md — Guidelines for agentic contributions

Purpose: Provide clear, actionable rules for automated agents working on this Neovim configuration repository.

NOTE: This repository is a personal Neovim config (lazy.nvim). Don't make changes that assume a specific machine setup beyond what's present in this repo.

1) Build / Lint / Test Commands

- Formatting
  - Lua formatter: stylua
    - Run: stylua .
    - Config: .stylua.toml (2-space indent, prefer double quotes, column width 120)
  - Other formatters: managed at runtime with conform.nvim
    - Run: Use Neovim Conform commands or manually run formatters (prettier, biome, rustfmt, gofmt, shfmt, taplo, sql_formatter, etc.) depending on filetype

- Linting
  - Linting is configured via lua/plugins/linter.lua and uses nvim-lint with external tools (golangci-lint, biomejs, etc.).
  - Run: use the Lint command inside Neovim (:Lint) or trigger autocommands by saving the file.

- Testing
  - There is no repository-level automated test suite for the configuration itself.
  - For code you add that requires tests, use plenary.nvim test harness. Example test command (run inside a Neovim plugin project):
    - nvim --headless -c "luafile tests/init.lua" -c "qa"
  - In-development tests can be run with neotest (see lua/plugins/testing.lua). Single test runs depend on neotest adapters (go, rust, plenary, etc.).

- Verification
  - After changes: open Neovim and run :checkhealth and ensure there are no runtime errors. Also verify plugin pages load where applicable.

2) Code Style

- Formatting / Tooling
  - Run stylua before committing. Conform is used for on-save formatting when enabled (toggle with <leader>uf).

- Lua conventions
  - Indentation: 2 spaces
  - Strings: prefer double quotes by default
  - Modules: return a table `local M = {}` and `return M`
  - Naming:
    - Use snake_case for variables and functions (e.g., my_function)
    - Use PascalCase for module tables or plugin-level types when appropriate
  - Use EmmyLua annotations for non-trivial function signatures (---@param,---@return,---@type)
  - Prefer `local` scope. Avoid polluting global namespace.

- Plugin specs
  - Follow lazy.nvim patterns. Prefer `opts` for simple, declarative plugin configs and `config = function(_, opts)` for more complex setups.
  - List plugin dependencies explicitly using `dependencies = { ... }`.

- Error handling
  - When requiring optional modules, use pcall.
  - Use vim.notify for user messages and vim.log.levels for logging levels.
  - Prefer returning early on errors instead of deep nesting.

- Tests & Neotest
  - If writing tests for functionality, use plenary's test framework or neotest adapters configured in lua/plugins/testing.lua.

3) File Structure / Paths

- Main entry: init.lua
- Plugins: lua/plugins/*.lua
- Utilities: lua/utils.lua
- Customizations: lua/custom/*

4) Cursor and Copilot Rules

- There are no repository-level Cursor rules (.cursor/rules/) present.
- There is no .github/copilot-instructions.md present. If added, include them in this AGENTS.md.

5) Git / Commit Guidelines for Agents

- NEVER force-push or amend commits unless explicitly requested.
- Only create commits when asked by the user.
- Do not commit files containing secrets or machine-specific configs.

6) Environment Notes

- The user runs on macOS (darwin). Be cautious with path separators. Use vim.fs or standard Lua path handling.
- The preferred shell in AGENTS.md instructions should be nushell where applicable.

7) Safety & Other Notes

- Do not make assumptions about installed system-level tools—check for executables using `vim.fn.executable` before suggesting commands.
- Keep changes minimal and focused; prefer incremental improvements.