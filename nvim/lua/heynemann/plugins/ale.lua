return {
   'JuanDAC/betty-ale-vim',
   dependencies = {
     'dense-analysis/ale'
   },
   config = function()
      vim.api.nvim_set_keymap('n', 'Q', '<Plug>(ale_previous_wrap)', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'q', '<Plug>(ale_next_wrap)', { noremap = true, silent = true })

      vim.g.ale_linters = {
        c = {'betty-style', 'betty-doc', 'gcc'},
        csh = {'shell'},
        cs = {'OmniSharp'},
        cpp = {'gcc', 'cpplint', 'cppcheck', 'flawfinder'},
        go = {'golangci-lint', 'gopls'},
        html = {'tidy', 'eslint'},
        htmldjango = {'tidy'},
        hack = {'hack', 'hhast'},
        python = {'flake8', 'mypy', 'pylsp', 'pylint'},
        help = {},
        perl = {'perlcritic'},
        json = {'jq'},
        make = {'checkmake'},
        javascript = {'eslint'},
        typescript = {'eslint', 'typecheck', 'tsserver'},
        ['typescript.tsx'] = {'eslint', 'typecheck', 'tsserver'},
        ['javascript.jsx'] = {'eslint'},
        typescriptreact = {'eslint', 'typecheck', 'tsserver'},
        rust = {'analyzer', 'cargo', 'cspell', 'rls', 'rustc'},
        spec = {},
        proto = {'buf-lint'},
        text = {},
        vim = {'vint', 'vimls'},
        yaml = {'yamllint'},
        zsh = {'bashate', 'language_server'},
        bash = {'bashate', 'language_server'},
        sh = {'bashate', 'language_server'}
      }

    vim.g.ale_fix_on_save = 1
    vim.g.ale_fixers = {
        python = {
            'black',
            'remove_trailing_lines',
            'trim_whitespace',
            'isort'
        },
        hack = {
            'hackfmt'
        },
        html = {
            'prettier',
            'remove_trailing_lines',
            'trim_whitespace'
        },
        json = {
            'prettier',
            'remove_trailing_lines',
            'trim_whitespace'
        },
        javascript = {
            'prettier',
            'remove_trailing_lines',
            'trim_whitespace'
        },
        ["javascript.jsx"] = {
            'prettier',
            'remove_trailing_lines',
            'trim_whitespace'
        },
        typescript = {
            'prettier',
            'remove_trailing_lines',
            'trim_whitespace'
        },
        ["typescript.tsx"] = {
            'prettier',
            'remove_trailing_lines',
            'trim_whitespace'
        },
        typescriptreact = {
            'prettier',
            'remove_trailing_lines',
            'trim_whitespace'
        },
        cpp = {
            'clang-format',
            'remove_trailing_lines',
            'trim_whitespace'
        },
        yaml = {
            'yamlfmt',
            'remove_trailing_lines',
            'trim_whitespace'
        },
        sh = {
            'trim_whitespace',
            'remove_trailing_lines',
            'shfmt'
        },
        bash = {
            'trim_whitespace',
            'remove_trailing_lines',
            'shfmt'
        },
        zsh = {
            'trim_whitespace',
            'remove_trailing_lines',
            'shfmt'
        },
        go = {
            'golines',
            'gofumpt',
            'goimports',
            'gopls'
        },
        rust = {
            'trim_whitespace',
            'remove_trailing_lines',
            'rustfmt'
        },
        cs = {
            'dotnet-format',
            'remove_trailing_lines',
            'trim_whitespace'
        },
        proto = {
            'buf-format'
        },
        make = {
            'trim_whitespace',
            'remove_trailing_lines'
        }
    }
    end
}
