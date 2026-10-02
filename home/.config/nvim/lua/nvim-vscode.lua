---@diagnostic disable: undefined-global
-- -- Run only inside VS Code (vscode-neovim)
-- disable netrw at the very start of our init.lua, because we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable Neovim built-in syntax highlighting and use VS Code's instead.
vim.opt.swapfile = false -- Don't use swapfile
vim.opt.ignorecase = true -- Search case insensitive...
vim.opt.smartcase = true -- ... but not it begins with upper case

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath "data" .. "undo"

vim.opt.shadafile = "NONE"

vim.opt.expandtab = true -- expand tabs into spaces
vim.opt.shiftwidth = 2 -- number of spaces to use for each step of indent.
vim.opt.tabstop = 2 -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = true

vim.opt.shortmess = "oOtTWIcCFS"
vim.opt.timeoutlen = 500
vim.opt.virtualedit = "block"
vim.opt.jumpoptions = "stack"
vim.opt.formatoptions = "tcrqjnl"

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.cmd.syntax "off"

if vim.g.vscode then
  vim.opt.cmdheight = 100
  local vscode = require "vscode-neovim"

  -- Helpers
  local function vsc(id)
    vim.fn.VSCodeNotify(id)
  end
  local function vsc_many(ids)
    for _, id in ipairs(ids) do
      vsc(id)
    end
  end
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
  end

  -- ========== COMMAND GROUPS ==========
  -- Refactored to inline functions directly in the keymaps below (no local tables)

  -- ========== BASE MOTION / CLIPBOARD ==========
  -- Wrap-aware j/k
  vim.keymap.set("n", "j", "gj", { remap = true, silent = true })
  vim.keymap.set("n", "k", "gk", { remap = true, silent = true })

  -- Visual move/indent helpers
  map("v", "<Up>", ":m .-2<CR>==", "Move selection up")
  map("v", "<Down>", ":m .+1<CR>==", "Move selection down")
  map("x", "<Up>", ":move '<-2<CR>gv-gv", "Move block up")
  map("x", "<Down>", ":move '>+1<CR>gv-gv", "Move block down")

  -- Operation: better indenting
  vim.keymap.set("n", "<", "<<", { desc = "Deindent" })
  vim.keymap.set("n", ">", ">>", { desc = "Indent" })
  vim.keymap.set("x", "<", "<gv", { desc = "Deindent" })
  vim.keymap.set("x", ">", ">gv", { desc = "Indent" })

  -- Clipboard / paste quality-of-life
  map({ "n", "v" }, "<leader>y", [["+y]], "Yank → system clipboard")
  map("n", "<leader>Y", [["+Y]], "Yank line → clipboard")
  map("n", "<leader>p", [["+p]], "Paste after (clipboard)")
  map("n", "<leader>P", [["+P]], "Paste before (clipboard)")
  map("x", "<leader>p", [["_dP]], "Paste (keep clipboard)")
  map("x", "p", [["_dP]], "Visual paste (keep clipboard)")

  -- Clear highlight
  map("n", "\\\\", "<Cmd>nohlsearch<CR>", "Clear search highlight")

  vim.keymap.set("c", "<C-A>", "<C-B>", { desc = "Start Of Line" })
  vim.keymap.set("i", "<C-A>", "<Home>", { desc = "Start Of Line" })
  vim.keymap.set("i", "<C-E>", "<End>", { desc = "End Of Line" })

  -- Search: fix direction of n/N
  vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
  vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
  vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
  vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

  -- ========== GROUPED BY PREFIX ==========

  -- [W] File / Editor (writes & window-close)
  map({ "n", "v" }, "<leader>w", function()
    vim.fn.VSCodeNotify "workbench.action.files.save"
  end, "File: Save")
  map({ "n", "v" }, "<leader>wa", function()
    vim.fn.VSCodeNotify "workbench.action.files.saveAll"
  end, "File: Save all")
  map("n", "<leader>q", function()
    vim.fn.VSCodeNotify "workbench.action.closeActiveEditor"
  end, "Editor: Close active")

  -- [F] Find / Search
  map("n", "<leader>ff", function()
    vim.fn.VSCodeNotify "workbench.action.quickOpen"
  end, "Find: Quick Open")
  map("n", "<leader>fs", function()
    vim.fn.VSCodeNotify "workbench.action.findInFiles"
  end, "Find: In Files")
  map("n", "<leader>fb", function()
    vim.fn.VSCodeNotify "workbench.action.showAllEditors"
  end, "Find: Show All Editors")
  map("n", "<leader>fw", function()
    vim.fn.VSCodeNotify "workbench.action.quickTextSearch"
  end, "Find: Open New Search Editor")
  map("n", "<leader>fn", function()
    vim.fn.VSCodeNotify "search.action.openNewEditor"
  end, "Find: In Files (alias)")
  map("n", "<leader>fc", function()
    vim.fn.VSCodeNotify "workbench.action.showCommands"
  end, "Find: Commands")
  map({ "n", "v" }, "<leader>fp", function()
    vim.fn.VSCodeNotify "editor.action.addSelectionToNextFindMatch"
    vim.fn.VSCodeNotify "workbench.action.findInFiles"
  end, "Find: Project (add selection + open in files)")
  map("n", "<leader>fo", function()
    vim.fn.VSCodeNotify "workbench.files.action.focusOpenEditorsView"
  end, "Project: Focus Open Editors")

  -- [G] Git
  map("n", "<leader>gi", function()
    vim.fn.VSCodeNotify "git.init"
  end, "Git: Init")
  map("n", "<leader>gs", function()
    vim.fn.VSCodeNotify "workbench.view.scm"
  end, "Git: Status")
  map("n", "<leader>gb", function()
    vim.fn.VSCodeNotify "git.checkout"
  end, "Git: Checkout")
  map("n", "<leader>gd", function()
    vim.fn.VSCodeNotify "git.deleteBranch"
  end, "Git: Delete branch")
  map("n", "<leader>gf", function()
    vim.fn.VSCodeNotify "git.fetch"
  end, "Git: Fetch")
  map("n", "<leader>gp", function()
    vim.fn.VSCodeNotify "git.pull"
  end, "Git: Pull")
  map("n", "[c", function()
    vim.fn.VSCodeNotify "workbench.action.editor.previousChange"
  end, "Git: Previous changes")
  map("n", "]c", function()
    vim.fn.VSCodeNotify "workbench.action.editor.nextChange"
  end, "Git: Next changes")
  -- Stage all + Copilot commit message (from VSCodeVim carry-over)
  map("n", "<leader>ag", function()
    vsc_many { "workbench.view.scm", "git.stageAll", "github.copilot.git.generateCommitMessage" }
  end, "Git: Stage all + Copilot commit msg")

  -- [P] Project
  map("n", "<leader>pp", function()
    vim.fn.VSCodeNotify "workbench.action.openRecent"
  end, "Project: Open recent")
  map("n", "<leader>-", function()
    vim.fn.VSCodeNotify "workbench.view.explorer"
  end, "Project: Explorer")
  map("n", "<leader>-", function()
    vim.fn.VSCodeNotify "workbench.view.explorer"
  end, "Project: Explorer")

  -- [U] UI Toggles (moved here to free <leader>t* for tests)
  map({ "n", "v" }, "<leader>ua", function()
    vim.fn.VSCodeNotify "workbench.action.toggleActivityBarVisibility"
  end, "UI: Toggle Activity Bar")
  map({ "n", "v" }, "<leader>us", function()
    vim.fn.VSCodeNotify "workbench.action.toggleSidebarVisibility"
  end, "UI: Toggle Sidebar")
  map({ "n", "v" }, "<leader>uz", function()
    vim.fn.VSCodeNotify "workbench.action.toggleZenMode"
  end, "UI: Toggle Zen Mode")
  map({ "n", "v" }, "<leader>ut", function()
    vim.fn.VSCodeNotify "workbench.action.selectTheme"
  end, "UI: Select Theme")
  map("n", "-", function()
    vim.fn.VSCodeNotify "workbench.files.action.showActiveFileInExplorer"
  end, "File: Show file in explorer")

  -- Vim-style z-motions (kept)
  map("n", "zr", function()
    vim.fn.VSCodeNotify "editor.unfoldAll"
  end)
  map("n", "zO", function()
    vim.fn.VSCodeNotify "editor.unfoldRecursively"
  end)
  map("n", "zo", function()
    vim.fn.VSCodeNotify "editor.unfold"
  end)
  map("n", "zm", function()
    vim.fn.VSCodeNotify "editor.foldAll"
  end)
  map("n", "zb", function()
    vim.fn.VSCodeNotify "editor.foldAllBlockComments"
  end)
  map("n", "zc", function()
    vim.fn.VSCodeNotify "editor.fold"
  end)
  map("n", "zg", function()
    vim.fn.VSCodeNotify "editor.foldAllMarkerRegions"
  end)
  map("n", "zG", function()
    vim.fn.VSCodeNotify "editor.unfoldAllMarkerRegions"
  end)
  map("n", "za", function()
    vim.fn.VSCodeNotify "editor.toggleFold"
  end)

  -- [T] Test / Debug (from VSCodeVim)
  map("n", "<leader>db", function()
    vsc "editor.debug.action.toggleBreakpoint"
  end, "Debug: toggle breakpoint")
  map("n", "<leader>dr", function()
    vsc "workbench.action.debug.restart"
  end, "Debug: restart")
  map("n", "<leader>tt", function()
    vsc "testing.runAtCursor"
  end, "Test: run at cursor")
  map("n", "<leader>td", function()
    vsc "testing.debugAtCursor"
  end, "Test: debug at cursor")
  map("n", "<leader>tr", function()
    vsc "testing.runAll"
  end, "Test: run all")
  map("n", "<leader>tc", function()
    vsc "testing.runCurrentFile"
  end, "Test: run current file")
  map("n", "<leader>to", function()
    vsc "workbench.view.testing.toggleVisibility"
  end, "Test: show most recent output")

  -- [A] AI / Chat
  -- AI / Chat: Copilot shortcuts
  -- Focus the Copilot Chat panel in VS Code
  map("n", "<leader>ai", function()
    vim.fn.VSCodeNotify "workbench.panel.chat.view.copilot.focus"
  end, "AI: Focus Copilot Chat Panel")
  -- Attach the current file to the active chat session
  map("n", "<leader>ab", function()
    vim.fn.VSCodeNotify "workbench.action.chat.attachFile"
  end, "AI: Attach File to Chat")

  -- [R] Refactor & Run Recent
  map("n", "<leader>ra", function()
    vim.fn.VSCodeNotify "editor.action.refactor"
  end, "Refactor: menu")
  map("n", "<leader>rr", function()
    vsc "workbench.action.terminal.runRecentCommand"
  end, "Terminal: run recent command")

  -- [E] Errors / Diagnostics
  map("n", "<leader>el", function()
    vim.fn.VSCodeNotify "workbench.actions.view.problems"
  end, "Problems: list")
  map("n", "]e", function()
    vim.fn.VSCodeNotify "editor.action.marker.next"
  end, "Problems: next")
  map("n", "[e", function()
    vim.fn.VSCodeNotify "editor.action.marker.prev"
  end, "Problems: prev")

  -- [V] Window / Workbench / Misc
  map("n", "<leader>ve", function()
    vim.fn.VSCodeNotify "workbench.action.focusActiveEditorGroup"
  end, "Window: focus active editor")
  map("n", "<leader>vl", function()
    vim.fn.VSCodeNotify "workbench.action.moveSideBarLeft"
  end, "Window: move sidebar left")
  map("n", "<leader>vr", function()
    vim.fn.VSCodeNotify "workbench.action.moveSideBarRight"
  end, "Window: move sidebar right")
  map({ "n", "v" }, "<leader>fc", function()
    vim.fn.VSCodeNotify "workbench.action.showCommands"
  end, "Command Palette")
  map("n", "<leader>un", function()
    vim.fn.VSCodeNotify "notifications.clearAll"
  end, "Clear all notifications")

  vim.keymap.set({ "n", "x" }, "<C-w>o", function()
    vscode.action "workbench.action.joinAllGroups"
    vscode.action "workbench.action.closeAuxiliaryBar"
    vscode.action "workbench.action.closeSidebar"
    vscode.action "workbench.action.closePanel"
  end, { silent = true })

  vim.keymap.set({ "n", "x" }, "<C-w>c", function()
    vscode.action "workbench.action.closeEditorsInGroup"
  end, { silent = true })

  vim.keymap.set("n", "<leader>ya", function()
    vscode.call "multiCommand.openFileManager"
    vscode.call "workbench.action.terminal.moveToEditor"
    vim.defer_fn(function()
      vscode.call "workbench.action.moveEditorToNewWindow"
    end, 200)
  end, { silent = true })

  -- Tabs (Neovim tabs to mirror your old mapping)
  map("n", "<leader>to", "<Cmd>tabnew<CR>", "Tab: new")
  map("n", "<leader>tx", "<Cmd>tabclose<CR>", "Tab: close")

  map("n", "<leader>tv", function()
    vim.fn.VSCodeNotify "workbench.action.createTerminalEditorSide"
  end, "Terminal: create new terminal editor side")
  map("n", "<leader>tn", function()
    vim.fn.VSCodeNotify "workbench.action.createTerminalEditor"
  end, "Terminal: create new terminal")

  -- Task
  map("n", "<leader>rr", function()
    vim.fn.VSCodeNotify "workbench.action.tasks.runTask"
  end, "Task: run task")

  -- LSP NAV / HOVER (g-r family)
  map("n", "grr", function()
    vsc "editor.action.goToReferences"
  end, "LSP: references")
  map("n", "gri", function()
    vsc "editor.action.goToImplementation"
  end, "LSP: implementation")
  map("n", "gry", function()
    vsc "editor.action.goToTypeDefinition"
  end, "LSP: type def")
  map("n", "grn", function()
    vsc "editor.action.rename"
  end, "LSP: rename")
  map("n", "gD", function()
    vim.fn.VSCodeNotify "editor.action.revealDefinition"
  end, "LSP: declaration")
  map("n", "grf", function()
    vim.fn.VSCodeNotify "editor.action.goToReferences"
  end, "LSP: references (alt)")
  map("n", "K", function()
    vsc "editor.action.showHover"
  end, "Hover")
  map("n", "<S-k>", function()
    vsc "editor.action.showHover"
  end, "Hover (S-k)")
  map({ "n", "v" }, "gra", function()
    vsc "editor.action.quickFix"
  end, "Code Action: Quick Fix")
  map({ "n", "v" }, "grc", function()
    vsc "editor.action.refactor"
  end, "Code Action: Refactor")

  map("n", "<leader>wb", function()
    vim.fn.VSCodeNotify "workbench.action.gotoSymbol"
  end, "Go to Symbol")
  map("n", "<leader>wa", function()
    vim.fn.VSCodeNotify "workbench.action.showAllSymbols"
  end, "Show All Symbols")
  map("n", "<leader>wr", function()
    vim.fn.VSCodeNotify "references-view.findReferences"
  end, "Find: In Files (alias)")
  map("n", "<leader>wr", function()
    vim.fn.VSCodeNotify "references-view.findReferences"
  end, "Find: In Files (alias)")
  -- Code actions / Format
  map("n", "<leader>cc", function()
    vsc "editor.action.autoFix"
  end, "Code: auto fix")
  map("n", "<leader>ca", function()
    vsc "editor.action.autoFix"
  end, "Code: auto fix")
  map("n", "<leader>;", function()
    vsc "editor.action.formatDocument"
  end, "Code: format document")
  map({ "n", "v" }, "<leader>=", function()
    vim.fn.VSCodeNotify "editor.action.formatDocument"
  end, "Code: format (alt)")

  -- Bookmarks
  map("n", "<leader>mm", function()
    vim.fn.VSCodeNotify "bookmarks.toggle"
  end, "Bookmark: toggle")
  map("n", "<leader>mt", function()
    vim.fn.VSCodeNotify "bookmarks.toggleLabeled"
  end, "Bookmark: toggle (alias)")
  map("n", "<leader>ml", function()
    vim.fn.VSCodeNotify "bookmarks.list"
  end, "Bookmark: list")
  map("n", "<leader>mn", function()
    vim.fn.VSCodeNotify "bookmarks.jumpToNext"
  end, "Bookmark: next")
  map("n", "<leader>mp", function()
    vim.fn.VSCodeNotify "bookmarks.jumpToPrevious"
  end, "Bookmark: prev")
  map("n", "<leader>m/", function()
    vim.fn.VSCodeNotify "bookmarks.listFromAllFiles"
  end, "Bookmark: prev")
end
