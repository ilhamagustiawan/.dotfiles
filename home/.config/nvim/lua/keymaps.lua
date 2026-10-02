local yank = require "custom.yank"

-- Leader and LocalLeader
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Navigation: Word Wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Navigation: Window Splits
vim.keymap.set("n", "<C-j>", "<C-W>j")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-h>", "<C-W>h")
vim.keymap.set("n", "<C-l>", "<C-W>l")

-- Navigation: Terminal Mode
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")

-- half screen up and down zz: center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-Down>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-Up>", "<C-u>zz")
vim.keymap.set("v", "<C-d>", "<C-d>zz")
vim.keymap.set("v", "<C-Down>", "<C-d>zz")
vim.keymap.set("v", "<C-u>", "<C-u>zz")
vim.keymap.set("v", "<C-Up>", "<C-u>zz")
-- when searching n: go to next result; zz: to center the result/cursor; zv expand all folds
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Disable mark feature
vim.keymap.set({ "n", "v" }, "m", "<Nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "'", "<Nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "`", "<Nop>", { silent = true })

-- Visual Mode: Move Selection
vim.keymap.set("x", "<S-Up>", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
vim.keymap.set("x", "<S-Down>", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Indent and keep selection
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-- Unindent and keep selection
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })

-- Disable/Remove Unwanted Keymaps
vim.api.nvim_set_keymap("", "<C-a>", "<Nop>", { noremap = false })

-- Clipboard/Yank/Paste

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank entire line to clipboard" })

-- Paste from system clipboard
vim.keymap.set("n", "<leader>p", [["+p]], { desc = "Paste after cursor from clipboard" })
vim.keymap.set("n", "<leader>P", [["+P]], { desc = "Paste before cursor from clipboard" })

-- Replace selected text without overwriting default register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without losing clipboard" })

-- Fix 'p' in visual mode so it doesn't replace register
vim.keymap.set("x", "p", [["_dP]], { desc = "Better paste in visual mode" })

vim.keymap.set("n", "\\\\", function()
  vim.cmd.nohlsearch()
end, { desc = "Clear search highlights" })

-- Toggle between last 2 buffers
vim.keymap.set("n", "<leader><tab>", "<c-^>", { desc = "Toggle between last 2 buffers" })

-- Unimpaired mappings
vim.keymap.set("n", "[q", ":cprevious<CR>", { silent = true })
vim.keymap.set("n", "]q", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "[Q", ":copen<CR>", { silent = true })
vim.keymap.set("n", "]Q", ":cclose<CR>", { silent = true })
vim.keymap.set("n", "[l", ":lprevious<CR>", { silent = true })
vim.keymap.set("n", "]l", ":lnext<CR>", { silent = true })
vim.keymap.set("n", "[L", ":lopen", { silent = true })
vim.keymap.set("n", "]L", ":lclose<CR>", { silent = true })
vim.keymap.set("n", "[t", ":tabprevious<CR>", { silent = true })
vim.keymap.set("n", "]t", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "[T", ":tabfirst<CR>", { silent = true })
vim.keymap.set("n", "]T", ":tablast<CR>", { silent = true })
vim.keymap.set("n", "[b", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "]b", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "[B", ":bfirst<CR>", { silent = true })
vim.keymap.set("n", "]B", ":blast<CR>", { silent = true })

-- Fast Saving/Quitting
vim.keymap.set("n", "<Leader>w", ":write!<CR>")
vim.keymap.set("n", "<Leader>q", ":q!<CR>", { silent = true })

-- Open in VSCode
vim.keymap.set("n", "<leader>ov", function()
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  vim.cmd("!cursor . && cursor -g " .. vim.fn.expand "%" .. ":" .. r .. ":" .. c)
end, { desc = "[O]pen E[x]ternal editor" })

-- Paste Toggle
vim.keymap.set("n", ",p", ":set invpaste<CR>:set paste?<CR>")

-- Search Result Navigation (saner n/N)
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

vim.keymap.set("n", "<leader>ya", function()
  yank.yank_path(yank.get_buffer_absolute(), "absolute")
end, { desc = "[Y]ank [A]bsolute path to clipboard" })

vim.keymap.set("n", "<leader>yr", function()
  yank.yank_path(yank.get_buffer_cwd_relative(), "relative")
end, { desc = "[Y]ank [R]elative path to clipboard" })

vim.keymap.set("v", "<leader>ya", function()
  yank.yank_visual_with_path(yank.get_buffer_absolute(), "absolute")
end, { desc = "[Y]ank selection with [A]bsolute path" })

vim.keymap.set("v", "<leader>yr", function()
  yank.yank_visual_with_path(yank.get_buffer_cwd_relative(), "relative")
end, { desc = "[Y]ank selection with [R]elative path" })
