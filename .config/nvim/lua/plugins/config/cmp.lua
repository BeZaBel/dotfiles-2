-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local cmp = require("cmp")
local snippy = require("snippy")

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_next = function()
    return cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
        elseif has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end, { "i", "s" })
end

local cmp_perv = function()
    return cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif snippy.can_jump(-1) then
            snippy.previous()
        else
            fallback()
        end
    end, { "i", "s" })
end

-- Neovim Snippy
snippy.setup({})

-- nvim-cmp setup
cmp.setup({
    snippet = {
        expand = function(args)
            snippy.expand_snippet(args.body)
        end,
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = {
        ["<C-n>"] = cmp_next(),
        ["<C-p>"] = cmp_perv(),
        ["<TAB>"] = cmp_next(),
        ["<S-TAB>"] = cmp_perv(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-3),
        ['<C-f>'] = cmp.mapping.scroll_docs(3),
        ["<C-Space>"] = cmp.mapping(function(_)
            if cmp.visible() then
                cmp.close()
            elseif has_words_before() then
                cmp.complete()
            end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "snippy" },
        { name = "path" },
    },

    completion = { -- Disable autocompletion cmp only works with C-Space
        autocomplete = false,
    }
})
