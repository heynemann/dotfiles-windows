vim.g.mapleader = ","

vim.opt.encoding = "utf-8"

vim.opt.compatible = false
vim.opt.hlsearch = true
vim.opt.relativenumber = true
vim.opt.laststatus = 2
vim.opt.vb = true
vim.opt.ruler = true
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.autoindent = true
vim.opt.colorcolumn = "120"
vim.opt.textwidth = 120
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamed"
vim.opt.scrollbind = false
vim.opt.wildmenu = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Remap ; to : in normal mode
vim.keymap.set("n", ";", ":", { noremap = true })

-- filetype related 
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"gitcommit"},
    callback = function(ev)
        vim.api.nvim_set_option_value("textwidth", 72, {scope = "local"})
    end
})

-- vim.api.nvim_create_autocmd("FileType", {
    -- pattern = {"markdown"},
    -- callback = function(ev)
        -- vim.api.nvim_set_option_value("textwidth", 0, {scope = "local"})
        -- vim.api.nvim_set_option_value("wrapmargin", 0, {scope = "local"})
        -- vim.api.nvim_set_option_value("linebreak", 0, {scope = "local"})
    -- end
-- })

vim.keymap.set("n", "<C-q>", ":cclose<CR>", { noremap = true, silent = true })
