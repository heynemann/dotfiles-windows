" FZF (replaces Ctrl-P, FuzzyFinder and Command-T)
set runtimepath+=/usr/local/opt/fzf
set runtimepath+=~/.fzf
set runtimepath+=/home/linuxbrew/.linuxbrew/opt/fzf
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

let g:fzf_buffers_jump = 1

"nmap ; :Buffers<CR>
nmap <Leader>r :Tags<CR>
nmap <Leader>t :call g:FzfFilePreview()<CR>
nmap <Leader>a :Ag<CR>

function! WithPreview(window, options)
  let l:spec = fzf#vim#with_preview(a:options)
  let l:preview = index(l:spec['options'], '--preview-window')
  if l:preview >= 0
    let l:spec['options'][l:preview + 1] = a:window
  endif
  return l:spec
endfunction

function! NewTabFzfSink(item)
    let l:file = a:item
    let l:line = 0
    let l:column = 0
    if l:file =~ "[:]"
        let l:data = split(a:item, ":")

        if len(l:data) == 2
          let l:file = l:data[0]
          let l:line = l:data[1]
        else
          let l:file = l:data[0]
          let l:line = l:data[1]
          let l:column = l:data[2]
        endif
    endif
    
    let l:tabnr = WhichTab(l:file)

    if l:tabnr == 0
      if IsTabEmpty() == 1
        execute(":e " . l:file)
      else
        execute(":tabnew " . l:file)
      endif
    else
      if IsTabEmpty() == 1
        execute(":bd")
      endif
      execute(":tabn " . l:tabnr)
    endif

    call cursor(l:line, l:column)
    normal! zz
endfunction

let $FZF_DEFAULT_COMMAND = 'fd --type f --color=never'

"command! -bang -nargs=? -complete=dir Files call fzf#run(fzf#vim#with_preview({
    "\ 'source': "cd " . expand('%:p:h') . " && cd $(git rev-parse --show-toplevel) && fd --type f",
    "\ 'sink': function("NewTabFzfSink"),
    "\ 'down': '30%'
    "\ }))

function! g:FzfFilePreview()
  let s:files_status = {}
  let s:rootDir = split(system('cd ' . expand('%:p:h') . ' && git rev-parse --show-toplevel'), '\n')[0]

  let l:fzf_files_options = '--preview "bat --style=numbers,changes --color always ' . s:rootDir . '/{3..-1} | head -200" --expect=ctrl-v,ctrl-x'

  function! s:cacheGitStatus()
    let l:gitcmd = 'git -c color.status=false -C ' . $PWD . ' status -s'
    let l:statusesStr = system(l:gitcmd)
    let l:statusesSplit = split(l:statusesStr, '\n')
    for l:statusLine in l:statusesSplit
      let l:fileStatus = split(l:statusLine, ' ')[0]
      let l:fileName = split(l:statusLine, ' ')[1]
      let s:files_status[l:fileName] = l:fileStatus
    endfor
  endfunction

  function! s:files()
    call s:cacheGitStatus()
    let l:cmd = 'cd ' . s:rootDir . ' && fd --type f'
    let l:files = split(system(l:cmd, '\n'))
    return s:prepend_indicators(l:files)
  endfunction

  function! s:prepend_indicators(candidates)
    return s:prepend_git_status(s:prepend_icon(a:candidates))
  endfunction

  function! s:prepend_git_status(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:status = ''
      let l:icon = split(l:candidate, ' ')[0]
      let l:filePathWithIcon = split(l:candidate, ' ')[1]

      let l:pos = strridx(l:filePathWithIcon, ' ')
      let l:file_path = l:filePathWithIcon[pos+1:-1]
      if has_key(s:files_status, l:file_path)
        let l:status = s:files_status[l:file_path]
        call add(l:result, printf('%s %s %s', l:status, l:icon, l:file_path))
      else
        " printf statement contains a load-bearing unicode space
        " the file path is extracted from the list item using {3..-1},
        " this breaks if there is a different number of spaces, which
        " means if we add a space in the following printf it breaks.
        " using a unicode space preserves the spacing in the fzf list
        " without breaking the {3..-1} index
        call add(l:result, printf('%s %s %s', ' ', l:icon, l:file_path))
      endif
    endfor

    return l:result
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(lines)
    if len(a:lines) < 2 | return | endif

    let l:cmd = get({'ctrl-x': 'split',
                 \ 'ctrl-v': 'vertical split',
                 \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')

    for l:item in a:lines[1:]
      let l:pos = strridx(l:item, ' ')
      let l:file_path = l:item[pos+1:-1]
      call NewTabFzfSink(l:file_path)
    endfor
  endfunction

  let l:options = substitute(l:fzf_files_options, '@@ROOTDIR', s:rootDir, 'g')
  call fzf#run({
        \ 'source': <sid>files(),
        \ 'sink*':   function('s:edit_file'),
        \ 'options': '-m --preview-window=right:70%:noborder --prompt Files\> ' . l:options,
        \ 'down':    '40%'
        \ })
endfunction

" Try to determine whether file is open in any tab.
" Return number of tab it's open in
function! WhichTab(filename)
  let l:buffer = FindBuffer(a:filename)
  if l:buffer[0] is v:null
    return 0
  endif

  let buffernumber = l:buffer[0]
  let buffername = l:buffer[1]

  " tabdo will loop through pages and leave you on the last one;
  " this is to make sure we don't leave the current page
  let currenttab = tabpagenr()
  let tab_arr = []
  tabdo let tab_arr += tabpagebuflist()

  " return to current page
  exec 'tabnext ' . currenttab

  " Start checking tab numbers for matches
  let i = 0
  for tnum in tab_arr
    let i += 1
    if tnum == buffernumber
      return i
    endif
  endfor
endfunction

function! FindBuffer(filename) abort
  for l:buffer in getbufinfo()
    if fnamemodify(l:buffer.name, ':p') == fnamemodify(a:filename, ':p')
      return [l:buffer.bufnr, l:buffer.name]
    endif
  endfor

  return [v:null, v:null]
endfunction

" Determine if current tab is empty or has anything in it
function! IsTabEmpty()
  return bufname('%') ==# ''
endfunction

" Function to create or move to an open tab
function! FindOrCreateTab(item)
  let l:file = a:item
  let l:line = 0
  let l:column = 0

  if l:file =~# '[:]'
    let l:data = split(a:item, ':')

    let l:file = l:data[0]
    let l:line = l:data[1]

    if len(l:data) > 2
      let l:column= l:data[2]
    endif
  endif

  let l:tabnr = WhichTab(l:file)
  let l:emptytab = IsTabEmpty()

  if l:tabnr == 0
    if l:emptytab == 1
      execute(':e ' . l:file)
    else
      execute(':tabnew ' . l:file)
    endif
  else
    if l:emptytab == 1
      let l:currenttabnr = tabpagenr()
      if l:tabnr > l:currenttabnr
        let l:tabnr -= 1
      endif
      execute(':bd')
    endif
    execute(':tabn ' . l:tabnr)
  endif

  call cursor(l:line, l:column)
  normal! zz
endfunction
