-- VIM OPTIONS
vim.opt.showmatch = true               -- show matching 
vim.opt.ignorecase = true              -- case insensitive 
vim.opt.mouse = "v"                    -- middle-click paste
vim.opt.hlsearch = true                -- highlight searches
vim.opt.incsearch = true               -- incremental search
vim.opt.tabstop = 4                    -- tab columns
vim.opt.softtabstop = 4                -- multiple spaces as tabstops
vim.opt.expandtab = true               -- tabs to whitespace
vim.opt.shiftwidth = 4                 -- width for autoindent
vim.opt.autoindent = true              -- indent newline same a previous
vim.opt.number = true                  -- add line numbers
vim.opt.relativenumber = true          -- relative line numbers
vim.opt.wildmode = "longest,list"      -- get bash tab-completions 
vim.opt.cursorline = true              -- highlight current cursor line
vim.opt.clipboard = "unnamedplus"      -- use system clipboard
vim.opt.foldmethod = "indent"          -- defines folds based on lang syntax

vim.cmd([[
  set complete+=kspell
  filetype plugin indent on
  highlight Normal ctermbg=NONE guibg=NONE
]])

-- MAP LEADER
--
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- CONFIGS
require("config.init")

-- KEYBINDS
vim.keymap.set("n", "<leader>ft", vim.cmd.Ex, { desc = "Opens file tree" })
vim.keymap.set("n", "<leader>p", vim.cmd.Lazy, { desc = "Opens Lazy.vim package manager" })
vim.keymap.set("n", "<leader>m", vim.cmd.Mason, { desc = "Opens Mason LSP manager" })
vim.keymap.set("n", "<leader>?", require('fzf-lua').keymaps, { desc = "Show keybindings" })
vim.keymap.set("n", "<leader>ff", require('fzf-lua').files, { desc = "Show Files" })
vim.keymap.set("n", "<leader>fw", require('fzf-lua').grep_project, { desc = "Grep folder" })
vim.keymap.set("n", "<leader>fh", require('fzf-lua').grep, { desc = "Grep File" })
vim.keymap.set("n", "<leader>g", require('fzf-lua').git_status, { desc = "Show Git status" })
vim.keymap.set("n", "<leader>c", require('fzf-lua').changes, { desc = "List File Changes" })
vim.keymap.set("n", "<leader>h", require('fzf-lua').oldfiles, { desc = "Show File History" })
vim.keymap.set("n", "<leader>b", require('fzf-lua').buffers, { desc = "Show Open Vim Buffers" })
vim.keymap.set("n", "<c-d>", "<c-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<c-u>", "<c-u>zz", { desc = "Scroll up and center" })


-- LSP Keybinds
vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "LSP declaration" })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "LSP definition" })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "LSP implementation" })
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = "LSP signature" })
vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, { desc = "LSP type definition" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "LSP rename" })
vim.keymap.set('n', 'lr', vim.lsp.buf.references, { desc = "LSP references" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "LSP errors" })
vim.keymap.set('n', '<leader>qa', ':CodeCompanionActions<CR>', { desc = 'Open CodeCompanion Action Palette' })
vim.keymap.set('n', '<leader>qq', ':CodeCompanionChat Toggle<CR>', { desc = 'Toggle CodeCompanion Chat Buffer' })
vim.keymap.set('n', '<leader>qw', ':CodeCompanion<CR>', { desc = 'Open CodeCompanion Inline Chat' })


