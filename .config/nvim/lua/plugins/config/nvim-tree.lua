-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local M = {}

M.init = function()
    local nvimtree_ok, nvimtree = pcall(require, "nvim-tree")

    if not nvimtree_ok then
        return
    end

    -- Mapping
    local kbdmap = {
        { key = { "l", "<CR>", "<2-LeftMouse>" }, action = "edit" },
        { key = { "<C-e>", "<S-CR>" },            action = "edit_in_place" },
        { key = "h",                              action = "close_node" },
        { key = { "<2-RightMouse>", "L" },        action = "cd" },
        { key = "H",                              action = "dir_up" },
        { key = "v",                              action = "vsplit" },
        { key = "s",                              action = "split" },
        { key = "t",                              action = "tabnew" },
        { key = "<",                              action = "prev_sibling" },
        { key = ">",                              action = "next_sibling" },
        { key = "<Tab>",                          action = "preview" },
        { key = "I",                              action = "toggle_ignored" },
        { key = "H",                              action = "toggle_dotfiles" },
        { key = "n",                              action = "create" },
        { key = "d",                              action = "trash" },
        { key = "D",                              action = "remove" },
        { key = "r",                              action = "rename" },
        { key = "<C-r>",                          action = "full_rename" },
        { key = "R",                              action = "refresh" },
        { key = "x",                              action = "cut" },
        { key = "c",                              action = "copy" },
        { key = "p",                              action = "paste" },
        { key = "y",                              action = "copy_name" },
        { key = "Y",                              action = "copy_path" },
        { key = "gy",                             action = "copy_absolute_path" },
        { key = "o",                              action = "system_open" },
        { key = "q",                              action = "close" },
        { key = "?",                              action = "toggle_help" },
        { key = ".",                              action = "run_file_command" },
    }

    -- Setup
    nvimtree.setup({
        disable_netrw = true,
        open_on_setup = false,
        open_on_tab = false,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        ignore_ft_on_setup = { "dashboard" },

        git = {
            enable = true,
            ignore = false,
        },

        update_focused_file = {
            enable = true,
        },

        renderer = {
            -- highlight_git = false,
            group_empty = true,
            indent_markers = { enable = true },
            icons = {
                symlink_arrow = " >> ",
                glyphs = {
                    default = "",
                    symlink = "",
                    git = {
                        unstaged = "•",
                        unmerged = "",
                        untracked = "U",
                        staged = "S",
                        renamed = "",
                        deleted = "",
                        ignored = "◦",
                    },
                },
            },
        },

        view = {
            width = 35,
            side = "left",
            mappings = {
                custom_only = true,
                list = kbdmap,
            },
        },
    })

    require("core.utils").registerkbdmap({
        n = {{
            ["<leader>"] = {
                e = { "<CMD>NvimTreeFocus<CR>",  "FileTree Focus"  },
                E = { "<CMD>NvimTreeToggle<CR>", "FileTree Toggle" },
            }
        }, {silent = true}}
    })
end

return M
