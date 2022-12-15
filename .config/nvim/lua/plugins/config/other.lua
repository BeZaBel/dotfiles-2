-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

M = {}

--  Vim Colorizer ==============================================================
M.colorizer = function()
    local colorizer_ok, colorizer = pcall(require, "colorizer")
    if not colorizer_ok then return end

    colorizer.setup({
        filetypes = { "*" },
        user_default_options = { RRGGBBAA = true, names = false }
    })
end

--  Comment.nvim ===============================================================
M.comment = function()
    local comment_ok, comment = pcall(require, "Comment")
    if not comment_ok then return end

    comment.setup({
        toggler = { block = 'gCC' },
        opleader = { block = 'gC' },
        mappings = { extra = false },
    })
end

-- Autopairs ===================================================================
M.autopairs = function()
    local pairs_ok, pairs = pcall(require, "nvim-autopairs")
    if not pairs_ok then return end

    pairs.setup({
        check_ts = true,
        ts_config = {
            lua = { "string" },
            javascript = { "template_string" },
        },
        map_cr = true,
        map_bs = true
    })
end

-- GitSigns ====================================================================
M.gitsigns = function()
    local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
    if not gitsigns_ok then return end

    gitsigns.setup({
        signs = {
            add          = { hl = 'GitSignsAdd', text = '▎', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
            change       = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
            delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
            topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
            changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
            untracked    = { hl = 'GitSignsAdd', text = '▎', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        },
        attach_to_untracked = false,
        preview_config = {
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
    })

    -- TODO: GIT SIGNS KBDMAP
end

-- Trouble =====================================================================
M.trouble = function()
    local trouble_ok, trouble = pcall(require, "trouble")
    if not trouble_ok then return end

    trouble.setup({
        position = "bottom",
        height = 15,
        mode = "quickfix",
        padding = false,
        icons = false,
    })

    require("core.utils").registerkbdmap({
        n = {{
            ["<leader>"] = {
                l = {
                    d = { "<CMD>Trouble lsp_document_diagnostics<CR>", "Diagnostics List" },
                    q = { "<CMD>Trouble quickfix<CR>", "Quick Fix List" },
                },
            }
        }, {silent = true}}
    })
end

-- Indent Blankline ============================================================
M.indent_blankline = function()
    local indent_blankline_ok, indent_blankline = pcall(require, "indent_blankline")

    if not indent_blankline_ok then return end

    indent_blankline.setup({
        indentLine_enabled = true,
        show_first_indent_level = true,
        show_current_context = true,
        show_current_context_start = false,
        filetype_exclude = {
            "NvimTree",
            "help",
            "dashboard",
            "mason",
            "Trouble",
            "lspinfo",
            "Trouble",
            "Telescope",
            "TelescopePrompt",
            "TelescopeResults",
            "checkhealth",
            "packer",
            ""
        },

        buftype_exclude = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt",
            "help"
        },
    })
end

-- TreeSitter ==================================================================
M.treesitter = function()
    local tsc_ok, tsc = pcall(require, "nvim-treesitter.configs")

    if not tsc_ok then return end

    tsc.setup({
        use_languagetree = true,
        autopairs = { enable = true },
        matchup = { enable = true },
        highlight = {
            enable = true,
        },
        context_commentstring = {
            enable = true,
            enable_autocmd = true,
        },
    })
end

-- Which Key ===================================================================
M.whichkey = function()
    local wk_ok, wk = pcall(require, "which-key")

    if not wk_ok then return end

    wk.setup({
        key_labels = {
            ["<space>"] = "SPC",
            ["<cr>"] = "RET",
            ["<tab>"] = "TAB",
        },
        window = {
            border = "single",
        },
        layout = {
            align = "center",
        },
        ignore_missing = false,
        triggers_blacklist = {
            i = { "j", "k" },
            v = { "j", "k" },
        },
    })
end

-- MkdnFlow ====================================================================
M.mkdnflow = function()
    local mkdnflow_ok, mkdnflow = pcall(require, "mkdnflow")
    if not mkdnflow_ok then return end

    mkdnflow.setup({
        links = {
            conceal = true
        }
    })

    local ccmd = vim.api.nvim_create_user_command
    local bind = vim.api.nvim_set_keymap

    ccmd("MdFindBacklinks", function()
        vim.cmd("setlocal grepprg=mdfindbacklinks | silent! grep! '" ..
        vim.fn.expand("%:t").."'")
    end, { bang = true })
    bind("n", "<leader>wb", "<CMD>:MdFindBacklinks<CR>", { silent = true })

    ccmd("MdConvertLinks", function()
        vim.cmd([[silent! %s/\[\[\([A-z0-9-_\?\!@$:. ]\+\)\]\]/[\1](\1)/]])
        vim.cmd([[silent! %s/\[\[\([A-z0-9-_\?\!@$:. ]\+\)|\([A-z0-9\-_. ]\+\)\]\]/[\2](\1)/]])
        vim.cmd("noh")
    end, { bang = true })
    bind("n", "<leader>wc", "<CMD>:MdConvertLinks<CR>", { silent = true })
end

-- Markdown Preview ============================================================
M.markdown_preview = function()
    vim.cmd([[
    function! OpenMarkdownPreview (url)
        execute "silent !$BROWSER --new-window " . a:url
    endfunction]])
    vim.g.mkdp_browserfunc = 'OpenMarkdownPreview'
end

return M
