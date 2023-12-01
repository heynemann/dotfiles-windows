function! Paste(mode)
    let @" = system('win32yank.exe -o --lf')
    return a:mode
endfunction

map <expr> p Paste('p')
map <expr> P Paste('P')

autocmd TextYankPost * call YankDebounced()

function! Yank(timer)
    call system('win32yank.exe -i --crlf', @")
    redraw!
endfunction

let g:yank_debounce_time_ms = 100
let g:yank_debounce_timer_id = -1

function! YankDebounced()
    let l:now = localtime()
    call timer_stop(g:yank_debounce_timer_id)
    let g:yank_debounce_timer_id = timer_start(g:yank_debounce_time_ms, 'Yank')
endfunction
