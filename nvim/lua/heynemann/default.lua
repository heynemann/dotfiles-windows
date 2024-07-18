vim.g.mapleader = ","

vim.opt.encoding = "utf-8"

vim.opt.visualbell = false
vim.opt.errorbells = false
vim.opt.expandtab = true
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
vim.opt.clipboard = "unnamedplus"
vim.opt.scrollbind = false
vim.opt.wildmenu = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- When on, the ":substitute" flag 'g' is default on.  This means that
-- all matches in a line are substituted instead of one.  When a 'g' flag
-- is given to a ":substitute" command, this will toggle the substitution
-- of all or one match.
vim.opt.gdefault = true

-- By default, searching starts after you enter the string. With the option: :set incsearch set, incremental searches
-- will be done. The Vim editor will start searching when you type the first character of the search string.
-- As you type in more characters, the search is refined.
vim.opt.incsearch = true

-- The "highlight search option" ('hlsearch') turns on search highlighting. This option is enabled by the command:
-- vim.opt.hlsearch = true

-- The showmatch option is also useful: it can reduce the need for %, the cursor will briefly
-- jump to the matching brace when you insert one.
-- To speed things up, you can set the 'matchtime' option.
vim.opt.showmatch = true
vim.opt.matchtime = 3

vim.opt.history = 1000         -- remember more commands and search history
vim.opt.undolevels = 1000      -- use many muchos levels of undo

-- Remap ; to : in normal mode
vim.keymap.set("n", ";", ":", { noremap = true })

-- Tabnew with tt
vim.keymap.set("n", "tt", ":tabnew<CR>", { noremap = true })

-- Better search
vim.keymap.set("n", "/", "/\\v", { noremap = true })
vim.keymap.set("x", "/", "/\\v", { noremap = true })

-- filetype related 
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"gitcommit"},
    callback = function(ev)
        vim.api.nvim_set_option_value("textwidth", 72, {scope = "local"})
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"markdown"},
    callback = function(ev)
        vim.keymap.set("n", "<F1>", ":MarkdownPreview<CR>", { noremap = true, silent = true })
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"plantuml"},
    callback = function(ev)
        vim.keymap.set("n", "<F1>", ":PlantumlToggle<CR>", { noremap = true, silent = true })
    end
})

vim.keymap.set("n", "<C-q>", ":cclose<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>m", function()
    vim.cmd(":%s/\r//ge")
end, { noremap = true, silent = true })

vim.cmd([[
  set t_BE=
]])
