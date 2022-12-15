-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.markdown_fenced_languages = {
    "bash", "sh=bash", "javascript", "js=javascript", "typescript", "python",
    "py=python", "c", "cpp", "lua", "html",
}

require("core.options")
require("core.autocmd")
require("core.kbdmap")
