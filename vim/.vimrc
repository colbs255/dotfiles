" Colors
syntax enable
set t_Co=256
colorscheme molokai
autocmd Colorscheme * highlight Normal ctermbg=NONE guibg=NONE

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spaces and Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4
set softtabstop=4       " number spaces in tab when editing
set shiftwidth=4
set expandtab           " tabs are spaces
set autoindent          " indent according to current line when new line
set backspace=indent,eol,start
set scrolloff=7         " start scrolling when x lines away
set encoding=utf8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI Stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number              " show line numbers
set hidden              " dont require save on buffer change
set relativenumber
set showcmd
set cursorline          " line below cursor
set wrap                " line wrapping
filetype indent on      " load config files for languages
filetype plugin on
set wildmenu            " visual autocomlete for cmd menu
set lazyredraw          " will not redraw stuff during macros
set showmatch
set title               " show file name in title
set laststatus=2
filetype plugin on
filetype indent on
set guicursor=
set cmdheight=1
set ruler

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch
set hlsearch
set ignorecase
set smartcase           " ignore case unless capital is used
set gdefault            " make replacements global by default
set wildignore+=tags

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Panes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow
set splitright
let g:termdebug_wide = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader Mappings
let mapleader = " "
" Window Commands
nnoremap <silent> <leader>wh :wincmd h<cr>
nnoremap <silent> <leader>wl :wincmd l<cr>
nnoremap <silent> <leader>wj :wincmd j<cr>
nnoremap <silent> <leader>wk :wincmd k<cr>
nnoremap <silent> <leader>wc :close<cr>
nnoremap <silent> <leader>wo :only<cr>
nnoremap <silent> <leader>wv :vs<cr>
nnoremap <silent> <leader>ws :sp<cr>

nnoremap <leader>bs :update<cr>
nnoremap <leader>bS :wa<cr>

nnoremap <silent> <leader>ev :Vexplore!<CR>
nnoremap <silent> <leader>es :Hexplore!<CR>
nnoremap <silent> <leader>tv :vertical terminal<CR>
nnoremap <silent> <leader>ts :terminal<CR>

" Copy and paste
nnoremap <silent> <leader>ys "ayy
vnoremap <silent> <leader>ys "ay
nnoremap <silent> <leader>yy "ayy
vnoremap <silent> <leader>yy "ay
nnoremap <silent> <leader>yp "ayy
vnoremap <silent> <leader>yp "ay
nnoremap <leader>ran :.,.+

" Quick Open
nnoremap <leader>oq :e ~/quick.md

" Git
nnoremap <leader>gg :Gstatus<CR>
" Buffers
nnoremap <leader>bcd :cd %:h<CR>

nnoremap <leader>gm :g//normal @q<left><left><left><left><left><left><left><left><left><left>
nnoremap <leader>/ :lvim  % <left><left><left>

" Overwrites
nnoremap x "_x
vnoremap p "_dP

" Brackets
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" abbreviations
cnoreabbrev vrc ~/.vimrc
cnoreabbrev brc ~/.bashrc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'
Plug 'vimwiki/vimwiki'
" Installed with homebrew
Plug '/usr/local/opt/fzf'
" Note you should install rg for rg search
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mattn/emmet-vim'
Plug 'mhinz/vim-startify'
call plug#end()

" Debugger
packadd termdebug
" Lightline
set noshowmode
" Quicksope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" FZF
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>fl :BLines<cr>
nnoremap <leader>fs :Rg<cr>
" Emmet
let g:user_emmet_leader_key=','
" Vim Sneak
let g:sneak#label = 1
" CoC
inoremap <silent><expr> <C-@> coc#refresh()
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
