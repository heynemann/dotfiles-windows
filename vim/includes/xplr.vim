func! OpenInSmartTab(lines)
    let dir = a:lines[-1]
    if filereadable(dir)
        call NewTabFzfSink(dir)
    endif
endfunc

let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.9, 'highlight': 'Debug' } }
let g:nnn#action = {
      \ '<CR>': function('OpenInSmartTab')
      \ }
let g:nnn#replace_netrw = 1

nnoremap - :XplrPicker %:p<CR>

command XplrProjectRoot :XplrPicker `git rev-parse --show-toplevel`
