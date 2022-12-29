-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local autocmd = vim.api.nvim_create_autocmd
local bind = vim.keymap.set
local ccmd = vim.api.nvim_create_user_command
local g = vim.g
local o = vim.opt
local ol = vim.opt_local

-- Options and Global settings =================================================
g.mapleader = " "
g.maplocalleader = ","
g.markdown_fenced_languages = {
	"bash", "sh=bash", "javascript", "js=javascript", "typescript", "python",
	"py=python", "c", "cpp", "lua", "html",
}

o.clipboard = "unnamedplus"
o.colorcolumn = "80"
o.completeopt = {'menu', 'menuone', 'noselect'} -- required by cmp
o.encoding = "UTF-8"
o.grepformat = "%f:%l:%c:%m"
o.grepprg    = "rg --no-ignore --vimgrep --color=never --trim"
o.hidden = true
o.hlsearch = true
o.laststatus = 2
o.mouse = "a"
o.number = true
o.numberwidth = 3
o.pumheight = 15
o.relativenumber = true
o.scrolloff = 8
o.shiftwidth = 4
o.showmode = false
o.signcolumn = "yes:1"
o.smartcase = true
o.smartindent = true
o.splitbelow = true
o.splitright = true
o.tabstop = 4
o.termguicolors = false
o.updatetime = 250
o.wildmenu = true
o.wrap = true

-- Key bindings ================================================================
bind("n", "J", "mzJ`z", { noremap = true})
bind("n", "<c-h>", "<c-w>h", { noremap = true })
bind("n", "<c-j>", "<c-w>j", { noremap = true })
bind("n", "<c-k>", "<c-w>k", { noremap = true })
bind("n", "<c-l>", "<c-w>l", { noremap = true })
bind("n", "<C-M-j>", ":resize -2<CR>", { noremap = true })
bind("n", "<C-M-k>", ":resize +2<CR>", { noremap = true })
bind("n", "<C-S-j>", ":vertical resize -2<CR>", { noremap = true })
bind("n", "<C-S-k>", ":vertical resize +2<CR>", { noremap = true })
bind("v", "<S-j>", ":m '>+1<CR>gv=gv", { noremap = true })
bind("v", "<S-k>", ":m '<-2<CR>gv=gv", { noremap = true })
bind("n", "<leader>fe", "<CMD>e ~/.config/nvim/init.lua<CR>", { noremap = true})
bind("n", "<leader>bn", "bnext", { noremap = true})
bind("n", "<leader>bp", "bprev", { noremap = true})
bind("n", "<leader>bp", "bd", { noremap = true})

-- Auto commands ===============================================================
autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(opts)
		bind("n", "gd", vim.lsp.buf.definition,         { buffer = opts.buffer })
		bind("n", "gD", vim.lsp.buf.declaration,        { buffer = opts.buffer })
		bind("n", "gr", vim.lsp.buf.rename,             { buffer = opts.buffer })
		bind("n", "gf", vim.lsp.buf.references,         { buffer = opts.buffer })
		bind("n", "g<leader>", vim.lsp.buf.code_action, { buffer = opts.buffer })
		bind("n", "gk", vim.lsp.buf.hover,              { buffer = opts.buffer })
		bind("n", "go", vim.lsp.buf.type_definition,    { buffer = opts.buffer })
		bind("n", "gi", vim.lsp.buf.implementation,     { buffer = opts.buffer })
		bind("n", "]d", vim.diagnostic.goto_next,      { buffer = opts.buffer })
		bind("n", "[d", vim.diagnostic.goto_prev,      { buffer = opts.buffer })
	end
})

autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
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
})

autocmd("FileType", {
	pattern = { "html", "css", "scss" },
	callback = function()
		ol.shiftwidth = 2
	end
})

autocmd("FileType", {
	pattern = { "make"},
	callback = function()
		ol.tabstop = 8
		ol.shiftwidth = 8
	end,
})

-- Lsp Settings ================================================================
vim.diagnostic.config({
	underline = true,
	signs = true,
	update_in_insert = true,
	virtual_text = false
})

local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Plugin configuration ========================================================
local theme_init = function()
	require("gruvbox").setup({
		undercurl = false,
		contrast = "dark",
		overrides = {
			SignColumn = { bg = "#3c3836" }
		},
		transparent_mode = true,
	})

	vim.cmd.colorscheme("gruvbox")
end

local mkdnflow_init = function()
	local mkdnflow_ok, mkdnflow = pcall(require, "mkdnflow")
	if not mkdnflow_ok then return end

	mkdnflow.setup({
		links = {
			conceal = true,
			transform_explicit = function(inp)
				return inp:gsub(" ", "-"):lower()
			end
		}
	})
end

local gitsigns_init = function()
	local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
	if not gitsigns_ok then return end

	gitsigns.setup({
		signs = {
			add =          { hl = 'GitSignsAdd',    text = '|', numhl = 'GitSignsAddNr',    linehl = 'GitSignsAddLn' },
			change =       { hl = 'GitSignsChange', text = '|', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
			delete =       { hl = 'GitSignsDelete', text = '-', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
			topdelete =    { hl = 'GitSignsDelete', text = '-', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
			changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
			untracked =    { hl = 'GitSignsAdd',    text = '|', numhl = 'GitSignsAddNr',    linehl = 'GitSignsAddLn' },
		},
		attach_to_untracked = false,
	})
end

local autopairs_init = function()
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

local mason_init = function()
	local mason           = require("mason")
	local mason_lspconfig = require("mason-lspconfig")

	mason.setup({})

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
end

local mason_null_ls = function()
	require("mason-null-ls").setup({ automatic_setup = true })
end

local treesitter_init = function()
	local tsc_ok, tsc = pcall(require, "nvim-treesitter.configs")
	if not tsc_ok then return end

	tsc.setup({
		use_languagetree = true,
		autopairs  = { enable = true },
		playground = { enable = true },
		matchup    = { enable = true },
		highlight  = { enable = true },
		context_commentstring = {
			enable = true,
			enable_autocmd = true,
		},
	})

	require('vim.treesitter.query').set_query("markdown", "highlights", [[
	(atx_heading (inline) @text.title)
	(setext_heading (paragraph) @text.title)
	(code_fence_content) @none
	(link_destination) @text.uri
	(link_label) @text.reference
	(backslash_escape) @string.escape
	[
		(atx_h1_marker)
		(atx_h2_marker)
		(atx_h3_marker)
		(atx_h4_marker)
		(atx_h5_marker)
		(atx_h6_marker)
		(setext_h1_underline)
		(setext_h2_underline)
	] @punctuation.special
	[
		(link_title)
		(indented_code_block)
		(fenced_code_block)
	] @text.literal
	[
		(fenced_code_block_delimiter)
	] @punctuation.delimiter
	[
		(list_marker_plus)
		(list_marker_minus)
		(list_marker_star)
		(list_marker_dot)
		(list_marker_parenthesis)
		(thematic_break)
	] @punctuation.special
	[
		(block_continuation)
		(block_quote_marker)
	] @punctuation.special
	]])
end

local cmp_init = function()
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

	snippy.setup({})
	cmp.setup({
		snippet = {
			expand = function(args)
				snippy.expand_snippet(args.body)
			end,
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
		completion = {
			-- Disable autocompletion cmp only works with C-Space
			autocomplete = false,
		}
	})
end

local telescope_init = function()
	local telescope_ok, telescope = pcall(require, "telescope")
	if not telescope_ok then return end

	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
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
			layout_config = {
				center = {
					height = 0.4,
					width = 0.5,
					mirror = true
				},
			},
			mappings = {
				i = {
					["<esc>"] = actions.close
				},
			}
		},
	})

	vim.keymap.set("n", "<leader>ff", function()
		require('telescope.builtin').find_files({
			previewer = false,
			find_command = { "rg", "--files", "--no-ignore" },
			vimgrep_arguments = { "rg", "--vimgrep", "--smart-case", "--trim" }
		})
	end, { noremap = true})
	vim.keymap.set( "n", "<leader>fr", require('telescope.builtin').oldfiles, { noremap = true})
end

local cmplsp_init = function()
	local lspconfig = require("lspconfig")
	local lsp_defaults = lspconfig.util.default_config

	lsp_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lsp_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities())
end

-- Plugins / Packer ============================================================
local packer_ok, packer = pcall(require, "packer")

if packer_ok then
    local fopenev = { "BufRead", "BufWinEnter", "BufNewFile" }

    packer.init({
        auto_clean = true,
        compile_on_sync = true,
        display = { open_fn = require('packer.util').float }
    })

	packer.startup(function(use)
		use({ "wbthomason/packer.nvim" })
		use({ "nvim-lua/plenary.nvim" })

		-- UI
		use({
			"itchyny/lightline.vim",
			config = function() g.lightline = { colorscheme = 'gruvbox' } end
		})
		use({ "ellisonleao/gruvbox.nvim", config = theme_init })
		use({
			"nvim-treesitter/nvim-treesitter",
			event = fopenev,
			module = "nvim-treesitter",
			run = ":TSUpdate",
			config = treesitter_init
		})

		-- LSP
		use({ "neovim/nvim-lspconfig" })
		use({ "williamboman/mason-lspconfig.nvim", after = "nvim-lspconfig" })
		use({
			"williamboman/mason.nvim",
			after = "mason-lspconfig.nvim",
			config = mason_init
		})
		use({ "jose-elias-alvarez/null-ls.nvim", event = fopenev })
		use({
			"jayp0521/mason-null-ls.nvim",
			after = "null-ls.nvim",
			config = mason_null_ls
		})

		-- Code Completion / Snippets
		use({ "dcampos/nvim-snippy", })
		use({ "hrsh7th/nvim-cmp", config = cmp_init })
		use({ "dcampos/cmp-snippy", after = "nvim-cmp" })
		use({ "hrsh7th/cmp-nvim-lsp", after = "cmp-snippy", config = cmplsp_init })
		use({ "hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp" })
		use({ "hrsh7th/cmp-buffer", after = "cmp-nvim-lua" })
		use({ "hrsh7th/cmp-path", after = "cmp-buffer" })

		-- Language support
		use({ "ron-rs/ron.vim", ft = "ron" })
		use({
			"jakewvincent/mkdnflow.nvim",
			branch = "dev",
			config = mkdnflow_init
		})

		-- Utilities
		use({ "ap/vim-css-color" })
		use({ "Asheq/close-buffers.vim" })
		use({ "andymass/vim-matchup" })
		use({ "tpope/vim-repeat", event = fopenev })
		use({ "tpope/vim-surround", event = fopenev })
		use({ "tpope/vim-vinegar" })
		use({ "tpope/vim-commentary" })
		use({ "godlygeek/tabular", event = fopenev })
		use({
			"windwp/nvim-autopairs",
			config = autopairs_init,
			event = fopenev
		})
		use({
			"lewis6991/gitsigns.nvim",
			requires = "nvim-lua/plenary.nvim",
			event = fopenev,
			config = gitsigns_init
		})
		use({
			"nvim-telescope/telescope.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = telescope_init,
		})
	end)
else
    error("Packer Is not installed!\nhttps://github.com/wbthomason/packer.nvim")
end
