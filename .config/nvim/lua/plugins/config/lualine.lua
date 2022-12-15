-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local M = {}
function M.init()
    local lualine_ok, lualine = pcall(require, "lualine")

    if not lualine_ok then
        return
    end

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { "NvimTree" },
            always_divide_middle = true,
        },

        sections = {
            lualine_a = { "mode" },
            lualine_b = { "filename", "filetype"},
            lualine_c = { "branch", "diff", { "diagnostics", sources = { "nvim_lsp" }}},
            lualine_x = {
                "encoding",
                {
                    "fileformat",
                    color = { gui = "bold" },
                },
            },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },

        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
    })
end

return M
