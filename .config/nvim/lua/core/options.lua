-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.encoding = "UTF-8"
vim.opt.mouse = "a" -- Enable mouse in all modes.
vim.opt.completeopt = {'menu', 'menuone', 'noselect'} -- required by cmp
vim.opt.updatetime = 250
vim.opt.termguicolors = true

-- clean-up
vim.opt.swapfile = false

-- Status bar
vim.opt.showmode = false
vim.opt.laststatus = 2
vim.opt.cmdheight = 1
vim.opt.showcmd = true

-- Numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = "yes:1"

-- Text
vim.opt.wrap = true
vim.opt.colorcolumn = "80"
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 2
vim.opt.scrolloff = 8
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.smartcase = true -- Smart case search
vim.opt.hidden = true
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.wildmenu = true
vim.opt.pumheight = 15

-- Vim Grep
vim.opt.grepprg    = "rg --no-ignore --vimgrep --color=never --trim"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
