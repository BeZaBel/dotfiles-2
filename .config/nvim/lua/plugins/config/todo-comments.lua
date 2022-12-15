-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local M = {}

M.init = function()
    local todoc_ok, todoc = pcall(require, "todo-comments")

    if not todoc_ok then
        return
    end

    todoc.setup({
        signs = false,
        sign_priority = 8,

        keywords = {
            FIXME = {
                icon = " ",
                color = "error",
                alt = { "FIX", "BUG", "FIXIT", "ISSUE" },
            },
            TODO = { icon = " ", color = "info" },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
        highlight = {
            multiline = false,
            before = "",
            keyword = "bg",
            after = "fg",
            comments_only = true,
            max_line_len = 400,
            exclude = {}, -- ft to exclude
        },
        colors = {
            error = { "DiagnosticError", "ErrorMsg" },
            info = { "DiagnosticInfo" },
            hint = { "DiagnosticHint" },
        },
        search = {
            command = "rg",
            args = {
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
            },
            pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        },
    })


    local utils = require("core.utils")

    if pcall(require, "trouble") then
        utils.registerkbdmap({
            n = {
                {
                    ["<leader>"] = {
                        t = { "<CMD>TodoTrouble<CR>", "Todo List" }
                    }
                }, {silent = true}
            }
        })
    else
        utils.registerkbdmap({
            n = {
                ["<leader>"] = {
                    t = { "<CMD>TodoQuickFix<CR>", "Todo List" }
                }
            } , {silent = true}
        })
    end
end

return M
