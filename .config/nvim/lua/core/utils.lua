-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local M = {}

M.pt = function(t) print(vim.inspect(t)) end

M.tbl_merge = function (t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                M.tbl_merge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

M.echo = function(m)
    vim.api.nvim_echo({m}, false, {})
end

M.setoptions = function(options)
    for opt, val in pairs(options) do
	vim.opt[opt] = val
    end
end

function M.registerkbdmap(keymap)
    local wk = require("which-key")

    if type(keymap) ~= "table" then
        error("[Error] expected table got: " .. type(keymap))
        return
    end

    for mode, mappings in pairs(keymap) do
        if mode == "n" or mode == "i" or mode == "v" or mode == "x" then
            if mappings[1] and (mappings[2] or {}) then
                local map = mappings[1]
                local opts = mappings[2]
                opts.mode = mode
                wk.register(map, opts)
            end
        else
            error("[Error] Unknown mode. expected i, v, x, c got: " .. mode)
        end
    end
end

return M
