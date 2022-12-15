-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local utils = require("core.utils")
local ol = vim.opt_local
local autocmd = vim.api.nvim_create_autocmd

autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(opts)
        utils.registerkbdmap({
            n = {{
                g = { -- LSP Actions
                    d = { vim.lsp.buf.definition, "Goto Defenition" },
                    D = { vim.lsp.buf.declaration, "Goto Declaration" },
                    r = { vim.lsp.buf.rename, "Rename" },
                    f = { vim.lsp.buf.references, "List References" },
                    ["<leader>"] = { vim.lsp.buf.code_action, "Code Action" },
                    k = { vim.lsp.buf.hover, "Hower Doc" },
                    o = { vim.lsp.buf.type_definition, "Goto Type Definition" },
                    i = { vim.lsp.buf.implementation, "Implementation" },
                },
            }, { buffer = opts.buf } }
        })
    end
})

autocmd("FileType", {
    pattern = { "html", "css", "scss" },
    callback = function()
        vim.schedule(function()
            ol.shiftwidth = 2
        end)
    end
})

autocmd("FileType", {
    pattern = { "html", "css", "scss" },
    callback = function()
        vim.schedule(function()
            ol.shiftwidth = 2
        end)
    end
})

autocmd("FileType", {
    pattern = { "make"},
    callback = function()
        vim.schedule(function()
            ol.tabstop = 8
            ol.shiftwidth = 0
        end)
    end,
})

autocmd("FileType", {
    pattern = {"go"},
    callback = function()
        vim.schedule(function()
            ol.tabstop = 4
            ol.shiftwidth = 4
            ol.expandtab = false
        end)
    end,
})
