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
vim.opt.foldmethod = "syntax"          -- defines folds based on lang syntax

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
vim.keymap.set("n", "<leader>p", vim.cmd.Lazy, { desc = "Opens Lazy vim" })
vim.keymap.set("n", "<leader>?", require('fzf-lua').keymaps, { desc = "Show keybindings" })
vim.keymap.set("n", "<leader>ff", require('fzf-lua').files, { desc = "Show Files" })
vim.keymap.set("n", "<leader>fw", require('fzf-lua').grep_project, { desc = "Grep folder" })
vim.keymap.set("n", "<leader>fh", require('fzf-lua').grep, { desc = "Grep File" })
vim.keymap.set("n", "<leader>g", require('fzf-lua').git_status, { desc = "Show Git status" })
vim.keymap.set("n", "<leader>c", require('fzf-lua').changes, { desc = "List File Changes" })
vim.keymap.set("n", "<leader>h", require('fzf-lua').oldfiles, { desc = "Show File History" })
vim.keymap.set("n", "<leader>b", require('fzf-lua').buffers, { desc = "Show Open Vim Buffers" })
vim.keymap.set("n", "<c-d>", "<c-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<c-e>", "<c-d>zz", { desc = "Scroll up and center" })

