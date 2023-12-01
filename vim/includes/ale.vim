" ALE

let g:ale_linters_explicit = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
let g:ale_fix_on_save = 1
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

nmap <silent> Q <Plug>(ale_previous_wrap)
nmap <silent> q <Plug>(ale_next_wrap)

let g:ale_cpp_clang_executable = 'clang++-6.0'
let g:ale_c_clangformat_executable = 'clang-format-6.0'
let g:ale_cpp_gcc_options = "-std=c++14 -I./node_modules/node-addon-api/ -I$HOME/.node-gyp/11.8.0/include/node/"
let g:ale_cpp_clang_options = "-std=c++14 -I./node_modules/node-addon-api/ -I~/$HOME/node-gyp/11.8.0/include/node/"

let g:ale_linters = {
  \   'csh': ['shell'],
  \   'cs': ['OmniSharp'],
  \   'cpp': ['gcc', 'cpplint', 'cppcheck', 'flawfinder'],
  \   'go': ['golangci-lint', 'gopls'],
  \   'html': ['tidy', 'eslint'],
  \   'htmldjango': ['tidy'],
  \   'hack': ['hack', 'hhast'],
  \   'python': ['flake8', 'mypy', 'pylsp', 'pylint'],
  \   'help': [],
  \   'perl': ['perlcritic'],
  \   'json': ['jq'],
	\   'make': ['checkmake'],
  \   'javascript': ['eslint'],
  \   'typescript': ['tslint', 'typecheck', 'tsserver'],
  \   'typescript.tsx': ['tslint', 'typecheck', 'tsserver'],
  \   'javascript.jsx': ['eslint'],
  \   'rust': ['analyzer', 'cargo', 'cspell', 'rls', 'rustc'],
  \   'spec': [],
  \   'proto': ['buf-lint'],
  \   'text': [],
  \   'vim': ['vint', 'vimls'],
  \   'zsh': ['bashate', 'language_server'],
  \   'bash': ['bashate', 'language_server'],
  \   'sh': ['bashate', 'language_server']
\}

let g:ale_fixers = {
\   'python': [
\       'black',
\       'remove_trailing_lines',
\       'trim_whitespace',
\       'isort'
\   ],
\   'hack': [
\       'hackfmt',
\   ],
\   'html': [
\       'prettier',
\       'remove_trailing_lines',
\       'trim_whitespace'
\   ],
\   'json': [
\       'jq',
\       'remove_trailing_lines',
\       'trim_whitespace'
\   ],
\   'javascript': [
\       'prettier',
\       'remove_trailing_lines',
\       'trim_whitespace'
\   ],
\   'javascript.jsx': [
\       'prettier',
\       'remove_trailing_lines',
\       'trim_whitespace'
\   ],
\   'typescript': [
\	'prettier',
\       'remove_trailing_lines',
\       'trim_whitespace'
\   ],
\   'typescript.tsx': [
\	'prettier',
\       'remove_trailing_lines',
\       'trim_whitespace'
\   ],
\   'cpp': [
\       'clang-format',
\       'remove_trailing_lines',
\       'trim_whitespace'
\   ],
\   'yaml': [
\       'yamlfix',
\       'remove_trailing_lines',
\       'trim_whitespace'
\   ],
\   'sh': ['trim_whitespace', 'remove_trailing_lines','shfmt'],
\   'bash': ['trim_whitespace', 'remove_trailing_lines','shfmt'],
\   'zsh': ['trim_whitespace', 'remove_trailing_lines','shfmt'],
\   'go': ['golines', 'gofumpt', 'goimports', 'gopls'],
\   'rust': ['trim_whitespace', 'remove_trailing_lines', 'rustfmt'],
\   'cs': [
\       'remove_trailing_lines',
\       'trim_whitespace'
\   ],
\   'proto': ['buf-format'],
\   'make': ['trim_whitespace', 'remove_trailing_lines']
\}

let g:ale_typescript_tslint_use_global = 0
" let g:ale_c_uncrustify_options = '-c ~/.uncrustify.cfg'
let g:ale_c_uncrustify_options = ''
let g:ale_history_log_output=1
set omnifunc=ale#completion#OmniFunc
set completeopt=menu,menuone,preview,noselect,noinsert
" let g:SuperTabDefaultCompletionType = "context"
" let g:SuperTabContextDiscoverDiscovery = ["&omnifunc:<c-x><c-o>"]
let g:ale_python_black_options=""
let g:ale_completion_autoimport = 1

nnoremap <silent> gr :ALEFindReferences<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>
" nnoremap <silent> gt :ALEGoToTypeDefinition<CR>
nnoremap <silent> gf :ALEGoToDefinition -tab<CR>
nnoremap <silent> <F2> :ALERename<CR>

let g:ale_python_pylsp_config={
\   'pylsp': {
\     'plugins': {
\       'pycodestyle': {
\         'enabled': v:false
\       },
\       'pyflakes': {
\         'enabled': v:false,
\       },
\       'pydocstyle': {
\         'enabled': v:false,
\       },
\     }
\   },
\ }

" let g:ale_python_pyls_executable = "pylsp"

" let g:ale_python_pyls_config = {
" \   'pylsp': {
" \     'plugins': {
" \       'pycodestyle': {
" \         'enabled': v:false,
" \       },
" \       'pyflakes': {
" \         'enabled': v:false,
" \       },
" \       'pydocstyle': {
" \         'enabled': v:false,
" \       },
" \     },
" \   },
" \}
let g:ale_go_goimports_executable = 'gosimports'
let g:ale_go_goimports_options = '-local github.com/NSXBet'

let g:ale_go_golangci_lint_package = 1
let g:go_fmt_command = 'gosimports'

imap <silent> <C-a> <Plug>(copilot-next)
imap <silent> <C-s> <Plug>(copilot-previous)
imap <silent> <C-\> <Plug>(copilot-dismiss)
let NERDSpaceDelims=1
