local g, o = vim.g, vim.opt

o.splitbelow = true -- Default split below
o.splitright = true -- Default split right
o.splitkeep = "screen" -- Keep the text on the same screen line

-- No show modes twice with status bar
o.showmode = false
o.showcmd = false

o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"

o.virtualedit = "block"

-- Files
o.hidden = true
o.swapfile = false
o.backup = false
o.writebackup = false

-- Undo
o.undofile = true
o.undolevels = 10000

-- Indent
vim.opt.expandtab = true -- expand tabs into spaces
vim.opt.shiftwidth = 2 -- number of spaces to use for each step of indent.
vim.opt.tabstop = 2 -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
o.smartindent = true
o.smoothscroll = true

-- Required for `opts.events.reload`.
o.autoread = true

o.shortmess:append { W = true, I = true, c = true, C = true }

o.scrolloff = 8
o.sidescrolloff = 8
-- o.clipboard = { "unnamedplus" }
o.autowrite = true -- enable auto write
o.laststatus = 3

-- Compositor transparency on pum menus
o.pumblend = 5

o.formatoptions = "jcroqlnt" -- tcqj

-- Wrap
o.wrap = false

o.winminwidth = 5 -- Minimum window width

-- Tmux support
-- g["&t_8f"] = "<Esc>[38;2;%lu;%lu;%lum]"
-- g["&t_8b"] = "<Esc>[48;2;%lu;%lu;%lum]"

--Incremental live completion
o.inccommand = "nosplit"
if vim.fn.has "nvim-0.11" > 0 then
  vim.opt.completeopt:append { "fuzzy" }
end

--Set highlight on search
o.hlsearch = true
o.incsearch = true

--Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

--Make line numbers default
o.relativenumber = true
o.number = true

--Enable mouse mode
o.mouse = "a"

-- Disable mouse scrolling
vim.o.mousescroll = "ver:3,hor:0"

-- Hide * markup for bold and italic
o.conceallevel = 2
o.showmatch = true

-- List
o.list = true
o.listchars = {
  eol = "¬",
  tab = "▸ ",
  extends = "»",
  precedes = "«",
  trail = "·",
  nbsp = "␣",
}

o.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

--Decrease update time
o.timeout = true
o.updatetime = 150
o.ttimeoutlen = 200

o.signcolumn = "yes:1"
o.joinspaces = false
o.showbreak = "↳ "

-- Wildmode
o.wildmode = "longest:full,full"
o.wildignore = {
  "*.o",
  "*.obj,*~",
  "*.git*",
  "*.meteor*",
  "*vim/backups*",
  "*sass-cache*",
  "*mypy_cache*",
  "*__pycache__*",
  "*cache*",
  "*logs*",
  "*node_modules*",
  "**/node_modules/**",
  "*DS_Store*",
  "*.gem",
  "log/**",
  "tmp/**",
  "*package-lock.json*",
  "**/dist/**",
  "**/.next/**",
  "**/.nx/**",
}

o.belloff = "all" -- Just turn the dang bell off
o.pumheight = 15
if vim.fn.has "nvim-0.12" > 0 then
  vim.opt.pummaxwidth = 60
end

-- o.lazyredraw = false
-- o.maxmempattern = 20000

-- Don't add newline if missing on write
o.fixendofline = false

-- o.switchbuf = "useopen"

-- Explicitly auto select regex engine
-- o.regexpengine = 0

-- diff
o.diffopt:append {
  "linematch:50",
  "vertical,context:99",
  "foldcolumn:0",
  "indent-heuristic",
}

-- g.editorconfig = false
-- g.markdown_folding = true
-- g.markdown_fenced_languages = {
--   "ts=typescript",
--   "bash=sh",
--   "javascript",
--   "js=javascript",
--   "json=javascript",
--   "typescript",
--   "php",
--   "html",
--   "css",
--   "rust",
--   "sql",
-- }

o.termguicolors = true -- Support 24bit colors
o.cursorline = false
o.cursorlineopt = "both"

-- -- fold
vim.opt.foldcolumn = "0"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 5
vim.opt.foldtext = ""

o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-- TODO: remove once flickering issue is resolved
-- https://github.com/neovim/neovim/issues/32660
vim.g._ts_force_sync_parsing = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- os information
vim.g.mac = vim.fn.has "mac" == 1
vim.g.linux = vim.fn.has "linux" == 1 or vim.fn.has "wsl" == 1
vim.g.windows = vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1

if vim.fn.getenv "TERM_PROGRAM" == "ghostty" then
  vim.opt.title = true
  vim.opt.titlestring = "%{getcwd()}/%{bufname()}"
end

if vim.fn.has "win32" == 1 then
  local powershell_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
end
