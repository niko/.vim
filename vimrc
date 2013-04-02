set nocompatible

call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

let mapleader=","

set t_Co=256
colorscheme solarized
" from 6 - 18 o'clock light color scheme, dark otherwise
function! AdjustColorScheme()
  let &background=abs(strftime("%H")-12) < 6 ? 'light' : 'dark'
endfunction
call AdjustColorScheme()
autocmd CursorHold * call AdjustColorScheme()

let g:indent_guides_enable_on_vim_startup=1

" Quickly edit/reload the vimrc file
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

" better linewise movement
nnoremap j gj
nnoremap k gk

set hidden
set showcmd

" searching:
set ignorecase
set smartcase
set hlsearch
set gdefault


nnoremap :b<CR> :b#<CR>                         " switch to last buffer
" similar:
nnoremap <C-e> :e#<CR>

" list open buffers via CtrlP plugin:
nnoremap ; :CtrlPBuffer<CR>
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

set history=10000         " remember more commands and search history
set undolevels=10000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set copyindent    " copy the previous indentation on autoindenting
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
nnoremap <silent> <Leader><space> :call <SID>StripTrailingWhitespace()<CR>

"make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv


let      NERDShutUp=1
let      NERDSpaceDelims=1

map <Leader>7 <Leader>c<space>
vmap <Leader>7 <Leader>c<space>gv


" For regular expressions turn magic on
set magic

" Automatically cd into the directory that the file is in
set autochdir

let g:netrw_listhide='\^\..*'
noremap <leader>d :Ex<cr>                       " browse directory

set cursorline                  " Highlight current line
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids

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

nnoremap <leader>c :w !pbcopy ; pbpaste<cr><cr>   " copy buffer to system clipboard
vnoremap <leader>c : !pbcopy ; pbpaste<cr>        " copy selection to system clipboard
nnoremap <leader>v :r !pbpaste<cr>                " paste system clipboard after current line

nnoremap <leader>p diw"0P     " paste over word
vnoremap <leader>p "_d"0P     " paste over selection

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

noremap <leader>h :call WinMove('h')<cr>        " move to left window or create one
noremap <leader>j :call WinMove('j')<cr>        " move to bottom window or create one
noremap <leader>k :call WinMove('k')<cr>        " move to top window or create one
noremap <leader>l :call WinMove('l')<cr>        " move to right window or create one

noremap <leader>f :Ag                           " search project
noremap <leader>F :Ag <C-r><C-w><cr>            " search project for yanked word

" search for last search, put cursor where to enter replace string:
noremap <leader>s :%s/<C-r><C-w>//gc<Left><Left><Left>
vnoremap <leader>s :s/<C-r><C-w>//gc<Left><Left><Left>

noremap <shift><up> <C-U>
noremap <shift><down> <C-D>
noremap <shift><left> b
noremap <shift><right> w

" select word
noremap <space> viw

" center searches:
nnoremap n nzz
nnoremap N Nzz

" use tab instead of %
nnoremap <tab> %
vnoremap <tab> %

" restore cursor position in irb-vi
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

hi NonText cterm=NONE ctermfg=NONE
set lazyredraw

let g:agprg="ag --nocolor --nogroup --column"

