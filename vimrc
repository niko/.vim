set nocompatible

call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

let mapleader=","

" dont write backup and swapfiles to current directory
set bdir-=.
set bdir+=/tmp
set dir-=.
set dir+=/tmp

set t_Co=256
" colorscheme lucius
" LuciusBlack
colorscheme solarized
let &background=abs(strftime("%H")-12) < 6 ? 'light' : 'dark'
" from 6 - 18 o'clock light color scheme, dark otherwise
function! F()
  let &background=abs(strftime("%H")-12) < 6 ? 'light' : 'dark'
endfunction

autocmd InsertEnter * call F()

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" better linewise movement
nmap j gj
nmap k gk

set hidden
set showcmd
set undofile
syntax on

" searching:
set incsearch
set ignorecase
set smartcase
set hlsearch
set gdefault
map \ :nohlsearch<CR>

" switch to last buffer with just :b
nmap :b<CR> :b#<CR>
" similar:
nmap <C-e> :e#<CR>

" list open buffers via CtrlP plugin:
nmap ; :CtrlPBuffer<CR>
let g:ctrlp_map = '<Leader>t'
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0

let &showbreak=repeat(' ', 14)
set number
set list
set listchars=tab:▸\ ,eol:¬

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set showmatch     " set show matching parenthesis
set scrolloff=8

autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
highlight EOLWS ctermbg=red guibg=red

function! <SID>StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nmap <silent> <Leader><space> :call <SID>StripTrailingWhitespace()<CR>

"make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv


"autocmd Filetype ruby setlocal expandtab shiftwidth=2 softtabstop=2
filetype plugin on

let      NERDShutUp=1
let      NERDSpaceDelims=1

map <Leader>7 <Leader>c<space>
vmap <Leader>7 <Leader>c<space>gv


" For regular expressions turn magic on
set magic

" Automatically cd into the directory that the file is in
set autochdir

let g:netrw_listhide='\^\..*'
map <leader>d :Ex<cr>

set cursorline                  " Highlight current line
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
                                " Selected characters/lines in visual mode
endif


autocmd InsertEnter * hi statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
autocmd InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

" default the statusline to green when entering Vim
hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15


if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%{getcwd()}/%f\           " Path and filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set title titlestring=%{getcwd()}/%f

set mouse=a

fun! s:ToggleCopyPaste()
    if &mouse == ""
        let &mouse = "a"
        set nopaste
        set number
        set list
    else
        let &mouse=""
        set paste
        set nonumber
        set nolist
    endif
endfunction

noremap <Leader>p :call <SID>ToggleCopyPaste()<CR>
inoremap <Leader>p :call <SID>ToggleCopyPaste()<CR>a

function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr()) "we havent moved
    if (match(a:key,'[jk]')) "were we going up/down
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

map <leader>h :call WinMove('h')<cr>
map <leader>k :call WinMove('k')<cr>
map <leader>l :call WinMove('l')<cr>
map <leader>j :call WinMove('j')<cr>

map <leader>f :Ag 
map <leader>F :Ag <C-r><C-w><cr>

" search for last search, put cursor where to enter replace string:
map <leader>s :%s/<C-r><C-w>//gc<Left><Left><Left>
vmap <leader>s :s/<C-r><C-w>//gc<Left><Left><Left>

map <shift><up> <C-U>
map <shift><down> <C-D>
map <shift><left> b
map <shift><right> w

" center screen
nmap <space> zz

" center searches:
nmap n nzz
nmap N Nzz

" use tab instead of %
nnoremap <tab> %
vnoremap <tab> %

" restore cursor position in irb-vi
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

