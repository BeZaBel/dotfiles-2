-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local mason           = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup({
    ui = {
        border = "rounded",
    }
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, { border = "single" }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, { border = "single" }
)

-- Set diagnostic signs
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Diagnostic Handler
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        underline = true,
        virtual_text = {
            prefix = "▎",
            spacing = 2,
        },
        signs = false,
        update_in_insert = true
    }
)

mason_lspconfig.setup({})
mason_lspconfig.setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup {}
    end,
    ["sumneko_lua"] = function ()
        require("lspconfig").sumneko_lua.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            }
        }
    end,
})

