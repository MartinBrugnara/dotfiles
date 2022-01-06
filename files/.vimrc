" Reload .vimrc = "so %"
set nocompatible

set shell=bash
let mapleader=","

" ------------------------------------------------------------------------------
" Global

set encoding=utf-8
set fileencoding=utf-8

filetype on
filetype plugin on
filetype plugin indent on

set spell
set spelllang=en


" ------------------------------------------------------------------------------
" Interface

set title               " set window title = filename

set background=dark
" set termguicolors     " enable VIM truecolor (a bit buggy), default ON on Neods
colorscheme desert

syntax on
set number
" set ruler
let &colorcolumn="80,120"   " Show coding limits
hi ColorColumn ctermbg=0
hi LineNr term=bold cterm=NONE ctermfg=White ctermbg=NONE gui=NONE guifg=White guibg=NONE

" == Support function
function! WordCount()
   let s:old_status = v:statusmsg
   let position = getpos(".")
   exe ":silent normal g\<c-g>"
   let stat = v:statusmsg
   let s:word_count = 0
   if stat != '--No lines in buffer--'
     let s:word_count = str2nr(split(v:statusmsg)[11])
     let v:statusmsg = s:old_status
   end
   call setpos('.', position)
   return s:word_count
endfunction

set statusline=%y\ %f\ %m%=wc:%{WordCount()}\ %c:%l/%L
set nocursorline
set mouse= "

set laststatus=2        " always show the status line
set ttimeoutlen=50      " fix status bar lag when leaving insert mode

set nowrap              " (only visual) (do not) wrap lines when out of screen
set textwidth=0         " return when column > textwidth. (really format text)
set scrolloff=3         " min # of lines to keep above and below the cursor
set sidescroll=1        " uncover # columns a time when h scrolling
set linebreak           " (only visual) \n @ [^a-z0-9]
set showbreak=↪>
set listchars=eol:¶


" set spell               " spell checking (mv ']s' '[s', add 'zg', fix 'z=')
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif


" ------------------------------------------------------------------------------
" Editing
set backspace=indent,eol,start  " Let backspace work over lines.

set tabstop=4           " <tab> width in 'spaces'
set shiftwidth=4        " indentation per level (in 'spaces')
set softtabstop=4       " use tabs + spaces to 'align' (for us all is spaces)
set expandtab           " use space instead of tab
set shiftround          " Round indent to multiple of 'shiftwidth'

set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set smartindent
set autoindent          " on paste.
" inoremap # #          " do not (out)indent lines starting by #

set incsearch           " While typing, the matched string is highlighted.
set hlsearch            " highlight searched items.

" let loaded_matchparen = 1 " Disable feature
set showmatch           " highlight corresponding bracket.
set matchtime=2         " how log show match in x/10 seconds.
set matchpairs+=<:>     " The |%| command jumps from one to the other

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" space open/closes folds
nnoremap <space> za
set foldmethod=indent   " fold based on indent level (marker, manual, expr, syntax, diff)

" Support files
set writebackup         " While editing keep an old copy
set swapfile            " Use swap (useful for big files).

set modeline            " Enable modeline.
set nostartofline       " Do not jump to first character with page commands.


" ------------------------------------------------------------------------------
" Tabs & buffers

" Enable Elite mode, No ARRRROWWS!!!!
let g:elite_mode=1
" Disable arrow movement, resize splits instead.
if get(g:, 'elite_mode')
    nnoremap <Up>    :resize +2<CR>
    nnoremap <Down>  :resize -2<CR>
    nnoremap <Left>  :vertical resize -2<CR>
    nnoremap <Right> :vertical resize +2<CR>
endif


" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

noremap <leader>h :tabprevious<CR>
noremap <leader>l :tabnext<CR>
noremap <leader>n :tabnew<CR>

" Exit from the editor with only one command
noremap Q :qa<CR>

" ------------------------------------------------------------------------------
" Auto commands
"augroup configgroup
"    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd FileType php setlocal listchars=tab:+\ ,eol:- formatprg=par\ -w80\ -T4
    autocmd FileType python setlocal commentstring=#\ %s

    autocmd Filetype css setlocal ts=2 sts=2 sw=2
    autocmd Filetype scss setlocal ts=2 sts=2 sw=2
    autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
"    autocmd BufEnter *.rb colorscheme desert      " Projector friendly colorscheme

    autocmd BufNewFile,BufRead *.txt setlocal ft=text
    autocmd FileType text setlocal wrap breakindent breakindentopt=sbr nolist textwidth=0 wrapmargin=0 formatoptions+=1 spell
    autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
    autocmd FileType asm set noexpandtab shiftwidth=8 softtabstop=0 syntax=nasm

    autocmd BufEnter *.sh setlocal ts=2 sts=2 sw=2
    autocmd BufNewFile,BufRead *.tex setlocal spell wrap nolist textwidth=0 wrapmargin=0 formatoptions+=1

    autocmd BufRead /tmp/mutt-* set tw=72 spell
    autocmd BufRead */neomutt-* set tw=72 spell

    autocmd BufRead *.wiki set spell wrap list textwidth=0 wrapmargin=0
    autocmd BufRead *.md set spell wrap list textwidth=0 wrapmargin=0
    autocmd BufRead *.yml set nospell
"augroup END

function! StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

let ts_blacklist = ['md', 'markdown', 'vimwiki', 'make']
autocmd BufWritePre * if index(ts_blacklist, &ft) < 0 | :call StripTrailingWhitespaces()

" ------------------------------------------------------------------------------
" Bindings & Formatting
autocmd FileType c ClangFormatAutoEnable  " Requires clang
autocmd BufWritePost *.py call Flake8()   " Requires flake8

" Open go doc in vertical window, horizontal, or tab
au Filetype go nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>
au Filetype go nnoremap <leader>s :sp <CR>:exe "GoDef"<CR>
au Filetype go nnoremap <leader>t :tab split <CR>:exe "GoDef"<CR>

autocmd BufWritePre * :retab              " Convert tab to spaces

autocmd BufNewFile,BufRead *.tex set makeprg=latexmk\ -pdf\ %

autocmd BufNewFile,BufWritePost *.go SyntasticCheck
