require("copilot").setup({
  suggestion = {
    auto_trigger = true,
    accept = false,
  },
})

-- vim.keymap.set("i", 'C-a', function()
	-- if require("copilot.suggestion").is_visible() then
		-- require("copilot.suggestion").accept()
  -- else
		-- -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
	-- end
-- end, {
  -- noremap = false,
-- })

-- require("copilot").setup({
  -- panel = {
    -- auto_refresh = false,
    -- keymap = {
      -- accept = "<CR>",
      -- jump_prev = "[[",
      -- jump_next = "<Tab>",
      -- refresh = "gr",
      -- open = "<M-CR>",
    -- },
  -- },
  -- suggestion = {
    -- auto_trigger = true,
    -- keymap = {
      -- accept = "<M-l>",
      -- prev = "<M-[>",
      -- next = "<Tab>",
      -- dismiss = "<C-]>",
    -- },
  -- },
-- })
