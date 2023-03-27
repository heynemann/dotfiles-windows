" FZF (replaces Ctrl-P, FuzzyFinder and Command-T)
set runtimepath+=/usr/local/opt/fzf
set runtimepath+=~/.fzf
set runtimepath+=/home/linuxbrew/.linuxbrew/opt/fzf
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

let g:fzf_buffers_jump = 1

"nmap ; :Buffers<CR>
nmap <Leader>r :Tags<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>a :Ag<CR>
