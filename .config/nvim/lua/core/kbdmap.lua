-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local bind = vim.api.nvim_set_keymap

bind("n", "J", "mzJ`z", { noremap = true})

-- Move between windows
bind("n", "<c-h>", "<c-w>h", { noremap = true })
bind("n", "<c-j>", "<c-w>j", { noremap = true })
bind("n", "<c-k>", "<c-w>k", { noremap = true })
bind("n", "<c-l>", "<c-w>l", { noremap = true })

-- Window Resize
bind("n", "<C-M-j>", ":resize -2<CR>", { noremap = true })
bind("n", "<C-M-k>", ":resize +2<CR>", { noremap = true })
bind("n", "<C-S-j>", ":vertical resize -2<CR>", { noremap = true })
bind("n", "<C-S-k>", ":vertical resize +2<CR>", { noremap = true })

-- Move Lines
bind("v", "<S-j>", ":m '>+1<CR>gv=gv", { noremap = true })
bind("v", "<S-k>", ":m '<-2<CR>gv=gv", { noremap = true })

require("core.utils").registerkbdmap({
    n = {{
            ["<leader>"] = {
                f = {
                    name = "Find Actions",
                    e = { "<CMD>e ~/.config/nvim/init.lua<CR>", "Edit Config File" },
                    n = { "<CMD>ene!<CR>", "New File" },
                },

                o = {
                    name = "Toggle Options",
                    s = { function()
                        vim.opt.spell = not(vim.opt.spell:get())
                    end, "Toggle Spell" },
                    l = { function()
                        vim.opt.list = not(vim.opt.list:get())
                    end, "Toggle List" },
                    n = { function()
                        vim.opt.number = not(vim.opt.number:get())
                        vim.opt.relativenumber = not(vim.opt.relativenumber:get())
                    end, "Toggle Number" },
                    c = { function()
                        vim.opt.cursorcolumn = not(vim.opt.cursorcolumn:get())
                    end, "Toggle CursorCol" },
                    L = { function()
                        vim.opt.cursorline = not(vim.opt.cursorline:get())
                    end, "Toggle CursorLine" },
                    p = { function()
                        vim.opt.paste = not(vim.opt.paste:get())
                    end, "Toggle Paste" },
                    w = { function()
                        vim.opt.wrap = not(vim.opt.wrap:get())
                    end, "Toggle Wrap" },
                },

                b = {
                    name = "Buffers",
                    n = {"bnext", "Goto next buffer"},
                    p = {"bprev", "Goto next previous"},
                    c = {"bdelete", "Close current buffer"}
                }
            },
        },
        { silent = false, noremap = false, nowait = false }
    }
})
