" search easily
nnoremap / /\v
vnoremap / /\v

" remove search highlight
nnoremap <leader><space> :noh<cr>

" no more arrows for you
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> :tabp<CR>
nnoremap <right> :tabn<CR>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> :tabp<CR>
inoremap <right> :tabn<CR>
nnoremap j gj
nnoremap k gk

" tabs
nnoremap { :tabp<CR>
nnoremap } :tabn<CR>

nnoremap [ :tabp<CR>
nnoremap ] :tabn<CR>

nnoremap <F7> :tabp<CR>
nnoremap <F6> :tabn<CR>
inoremap <F7> :tabp<CR>
inoremap <F6> :tabn<CR>

" please no help ever
inoremap <F1> :set invnumber<CR>
nnoremap <F1> :set invnumber<CR>
vnoremap <F1> :set invnumber<CR>

" use ; as leader as well
nnoremap ; :

" linux CTRL+T
map tt :tabnew<CR>

" Keep search pattern at the center of the screen - http://vimbits.com/bits/92
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

" close quick tips
map <silent><F12> :cclose<cr>

" delete all buffers
map <Leader>b :bufdo bd<CR>

set nofoldenable    " disable folding

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

set clipboard^=unnamed,unnamedplus " Use same clipboard as macOS/Linux
