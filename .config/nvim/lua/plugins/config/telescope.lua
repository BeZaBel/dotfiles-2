-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local M = {}

M.init = function()
    local telescope_ok, telescope = pcall(require, "telescope")

    if not telescope_ok then
        return nil
    end

    local actions = require("telescope.actions")

    telescope.setup({
        defaults = {
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,

            prompt_prefix = " ",
            selection_caret = " ",
            entry_prefix = " ",

            results_title = false,
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            use_less = true,

            file_ignore_patterns = { "node_modules", "__pycache__/", "*.py[cod]" },

            path_display = { "smart" },
            initial_mode = "insert",
            layout_strategy = "center",
            border = true,
            layout_config = {
                center = {
                    height = 0.4,
                    width = 0.5,
                    mirror = true
                },
            },

            borderchars = {
                { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
                prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
                results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
            },
            mappings = {
                i = {
                    ["<esc>"] = actions.close
                },
            }
        },
    })

    require("core.utils").registerkbdmap({
        n = {{
            ["<leader>"] = {
                f = {
                    f = {
                        function()
                            require('telescope.builtin').find_files({
                                find_command = { "rg", "--files", "--no-ignore" },
                                vimgrep_arguments = {
                                    "rg",
                                    "--color=never",
                                    "--vimgrep",
                                    "--smart-case",
                                    "--trim",
                                },
                                previewer = false
                            })
                        end, "Find files"
                    },
                    r = { require('telescope.builtin').oldfiles, "Find recent files" },
                    g = { require('telescope.builtin').live_grep, "Grep string"},
                },
                p = {
                    name = "Pick!",
                    m = {require('telescope.builtin').man_pages, "Pick Manual"},
                    h = {require('telescope.builtin').help_tags, "Pick Help tag's"},
                }
            }
        }, {silent = true}}
    })
end

return M
