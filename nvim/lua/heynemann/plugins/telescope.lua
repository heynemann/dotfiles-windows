function vim.custom_find_files()
  local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end
  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end
  local opts = {}
  if is_git_repo() then
    require("telescope.builtin").git_files({ show_untracked = true })
  else
    require("telescope.builtin").find_files()
  end
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
            enabled = true,
            config = function()
              require("telescope").load_extension("fzf")
            end,
        }, {"nvim-telescope/telescope-file-browser.nvim", enabled = true},
		{ 
			"nvim-telescope/telescope-live-grep-args.nvim" ,
			-- This will not install any breaking changes.
			-- For major updates, this must be adjusted manually.
			version = "^1.0.0",
		},
    },
    branch = "0.1.x",
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {prompt_position = "top"},
                git_files_arguments = {
                    show_untracked = true
                },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist +
                            actions.open_qflist -- send selected to quickfixlist
                    }
                }
            },
            extensions = {
                file_browser = {
                    path = "%:p:h", -- open from within the folder of your current buffer
                    display_stat = false, -- don't show file stat
                    grouped = true, -- group initial sorting by directories and then files
                    hidden = true, -- show hidden files
                    hide_parent_dir = true, -- hide `../` in the file browser
                    hijack_netrw = true, -- use telescope file browser when opening directory paths
                    prompt_path = true, -- show the current relative path from cwd as the prompt prefix
                    use_fd = true -- use `fd` instead of plenary, make sure to install `fd`
                }
            }
        })

        telescope.load_extension("fzf")
        telescope.load_extension("file_browser")
		telescope.load_extension("live_grep_args")

        local builtin = require("telescope.builtin")
		local livegrep = require('telescope').extensions.live_grep_args

        -- key maps

        local map = vim.keymap.set
        local opts = {noremap = true, silent = true}

        map("n", "-", ":Telescope file_browser<CR>")

        map("n", "<leader>t", vim.custom_find_files, opts)
        map("n", "<leader>ss", builtin.treesitter, opts) -- Lists tree-sitter symbols
        map("n", "<leader>sc", builtin.spell_suggest, opts) -- Lists spell options
        map("n", "<leader>a", livegrep.live_grep_args, opts) -- Live Grep
    end
}
