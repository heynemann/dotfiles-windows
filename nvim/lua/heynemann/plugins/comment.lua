return {
    "numToStr/Comment.nvim",
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    config = function() require("Comment").setup() 
        local map = vim.api.nvim_set_keymap
        local opts = {noremap = true}

        -- Move to previous/next
        map("n", "<leader>c<space>", "<Plug>(comment_toggle_linewise_current)<CR>", opts)
        map(
            'x',
            '<leader>c<space>',
            '<Plug>(comment_toggle_linewise_visual)',
            { desc = 'Comment toggle linewise (visual)' }
        )
end
}
