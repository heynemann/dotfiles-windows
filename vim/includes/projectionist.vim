" go test
let s:alternates = {}

let g:AlternateFileSmartSink = funcref('NewTabFzfSink')

function! AddAlt(source, alt) abort
    if !has_key(s:alternates, a:source)
        let s:alternates[a:source] = []
    endif

    if !has_key(s:alternates, a:alt)
        let s:alternates[a:alt] = []
    endif

    call add(s:alternates[a:source], a:alt)
    call add(s:alternates[a:alt], a:source)
endfunction

function! s:findAlternateFile() abort
    let l:currentPath = expand('%:p')
    let l:filename = expand('%:t')
    let l:basename = expand('%:p:h')

    for key in keys(s:alternates)
        let l:regex = glob2regpat(key)
        let l:replaced = substitute(key, '*', '', 'g')
        let l:replacedFileName = substitute(l:filename, l:replaced, '', 'g')
        if l:currentPath =~# l:regex
            let l:alternates = s:alternates[key]
            let l:altReplaced = substitute(l:alternates[0], '*', l:replacedFileName, 'g')
            let l:altFile = l:basename . '/' . l:altReplaced

            call g:AlternateFileSmartSink(l:altFile)

            return
        endif
    endfor
endfunction

nnoremap gt :call <sid>findAlternateFile()<CR>
