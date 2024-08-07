return {
    "ray-x/navigator.lua",
    dependencies = {
        {"neovim/nvim-lspconfig"},
        {"hrsh7th/nvim-cmp"}, 
        {
            "nvim-treesitter/nvim-treesitter",
            config = function()
                require'nvim-treesitter.configs'.setup {
                    refactor = {
                        highlight_definitions = {
                          enable = false,
                          -- Set to false if you have an `updatetime` of ~100.
                          clear_on_cursor_move = true,
                        },
                    },
                }
            end,
        },
        {"nvim-treesitter/nvim-treesitter-textobjects"}, -- Syntax aware text-objects
        {'nvim-treesitter/nvim-treesitter-refactor'},
        {
            "nvim-treesitter/nvim-treesitter-context", -- Show code context
            opts = {enable = true, mode = "topline", line_numbers = true}
        },
        {"ray-x/guihua.lua", run = "cd lua/fzy && make"}, 
        {
            "ray-x/go.nvim",
            event = {"CmdlineEnter"},
            ft = {"go", "gomod"},
            build = ':lua require("go.install").update_all_sync()',
        },
        {
            "ray-x/lsp_signature.nvim", -- Show function signature when you type
            event = "VeryLazy",
            config = function() require("lsp_signature").setup() end
        },
    },
    config = function()
        require("go").setup()
        require("navigator").setup({
            lsp_signature_help = false, -- enable ray-x/lsp_signature
            -- lsp = {format_on_save = true},
            default_mapping = true,
        })

        vim.keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.hover()<cr>", { noremap = true, silent = true })
        vim.keymap.set("v", "<C-a>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { noremap = true, silent = false })
        vim.keymap.set("n", "<C-a>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { noremap = true, silent = false })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = {"go"},
            callback = function(ev)
                -- CTRL/control keymaps
                vim.api
                    .nvim_buf_set_keymap(0, "n", "<C-i>", ":GoImport<CR>", {})
                vim.api.nvim_buf_set_keymap(0, "n", "<C-b>", ":GoBuild %:h<CR>",
                                            {})
                vim.api.nvim_buf_set_keymap(0, "n", "<C-t>", ":GoTestPkg<CR>",
                                            {})
                vim.api.nvim_buf_set_keymap(0, "n", "<C-c>",
                                            ":GoCoverage -p<CR>", {})

                -- Opens test files
                vim.api.nvim_buf_set_keymap(0, "n", "ga",
                                            ":lua require('go.alternate').switch(true, '')<CR>",
                                            {}) -- Test
                vim.api.nvim_buf_set_keymap(0, "n", "V",
                                            ":lua require('go.alternate').switch(true, 'vsplit')<CR>",
                                            {}) -- Test Vertical
                vim.api.nvim_buf_set_keymap(0, "n", "S",
                                            ":lua require('go.alternate').switch(true, 'split')<CR>",
                                            {}) -- Test Split
            end,
            group = vim.api.nvim_create_augroup("go_autocommands",
                                                {clear = true})
        })
    end
}
