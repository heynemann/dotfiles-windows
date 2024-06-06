return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      -- debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    config = function()
        require("CopilotChat").setup()

        local map = vim.keymap.set
        local opts = {noremap = true, silent = false}

        local function ask(input)
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end

        local function review(input)
            require("CopilotChat").ask('/COPILOT_REVIEW Review the selected code.', { selection = require("CopilotChat.select").buffer })
        end
        map("n", "<F9>", ask, opts)
        map("x", "<F9>", ask, opts)
        map("n", "<F10>", review, opts)
        map("x", "<F10>", review, opts)
        map("n", "<F12>", ":CopilotChatReset<CR>", opts)
        map("x", "<F12>", ":CopilotChatReset<CR>", opts)
    end,
  },
}
