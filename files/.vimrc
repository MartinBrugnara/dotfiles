" Reload .vimrc = "so %"
set nocompatible

set shell=bash
let mapleader=","


filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'

    " UI info - utils
    Plugin 'tpope/vim-fugitive'                 " git integration
    Plugin 'scrooloose/syntastic'
    Plugin 'majutsushi/tagbar'
    Plugin 'jmcantrell/vim-virtualenv'
    Plugin 'scrooloose/nerdtree'

    " Languages support
    Plugin 'fatih/vim-go'                       " NOTE: <C-x><C-o> autocomplete
    Plugin 'rhysd/vim-clang-format'
    Plugin 'leafgarland/typescript-vim'
    Plugin 'othree/html5.vim'
    Plugin 'ekalinin/Dockerfile.vim'
    Plugin 'fisadev/vim-isort'                  " Python sort import
                                                " Requires: pip install isort

    " Themes
    Plugin 'scwood/vim-hybrid'      " hybrid
    Plugin 'fatih/molokai'          " molokai
    Plugin 'juanedi/predawn.vim'    " predawn
    Plugin 'nanotech/jellybeans.vim', { 'tag': 'v1.6' }
call vundle#end()


" ------------------------------------------------------------------------------
" Global

set encoding=utf-8
set fileencoding=utf-8

filetype on
filetype plugin on
filetype plugin indent on


" ------------------------------------------------------------------------------
" Interface

set title               " set window title = filename

set background=dark
" set termguicolors     " enable VIM truecolor (a bit buggy), default ON on Neo
"colorscheme hybrid
colorscheme jellybeans
let g:jellybeans_use_term_italics = 1
" set guifont=Monaco:h10

syntax on
set number
" set ruler
let &colorcolumn="80,120"   " Show coding limits
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

set statusline=%{fugitive#statusline()}%{virtualenv#statusline()}%y\ %f\ %m%=wc:%{WordCount()}\ %c:%l/%L
set nocursorline

if has('mouse')
    set mouse= "(|a|extend)
endif

set laststatus=2        " always show the status line
set ttimeoutlen=50      " fix status bar lag when leaving insert mode

set nowrap              " (only visual) (do not) wrap lines when out of screen
set textwidth=0         " return when column > textwidth. (really format text)
set scrolloff=3         " min # of lines to keep above and below the cursor
set sidescroll=1        " uncover # columns a time when h scrolling
set linebreak           " (only visual) \n @ [^a-z0-9]
set showbreak=↪>


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
" Auto commands
augroup configgroup
    autocmd!
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
augroup END

function! StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

let ts_blacklist = ['md', 'markdown', 'make']
autocmd BufWritePre * if index(ts_blacklist, &ft) < 0 | :call StripTrailingWhitespaces()


" ------------------------------------------------------------------------------
" Configuration

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

let g:syntastic_c_compiler="clang"          " Use clang as default
let g:syntastic_c_compiler_options="-std=c99 -pedantic"
let g:syntastic_cpp_compiler="clang++"      " Use clang as default
let g:syntastic_cpp_compiler_options="-std=c++11 -stdlib=libc++ -pedantic"

" let g:syntastic_tex_checkers=['chktex']
let g:syntastic_tex_checkers = ['lacheck']
let g:syntastic_html_tidy_exec = 'tidy5'
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:syntastic_javascript_checkers = ['jshint']

"let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'gometalinter']
"let g:syntastic_go_checkers = ['govet', 'golint', 'gometalinter']
let g:syntastic_go_checkers = ['govet', 'golint']
let g:syntastic_go_gometalinter_args = ['--disable-all', '--enable=errcheck']
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports" " use goimports for auto manage imports
let g:go_fmt_fail_silently = 0
let g:go_term_enabled = 0
let g:go_list_type = "quickfix"

let g:syntastic_cpp_config_file = '.syntastic_cpp_config'

let g:syntastic_python_checkers = ['python3']
let python_highlight_all=1

" ------------------------------------------------------------------------------
" Bindings & Formatting
autocmd FileType c ClangFormatAutoEnable
" autocmd BufWritePost *.py call Flake8()

" Python

" Open go doc in vertical window, horizontal, or tab
au Filetype go nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>
au Filetype go nnoremap <leader>s :sp <CR>:exe "GoDef"<CR>
au Filetype go nnoremap <leader>t :tab split <CR>:exe "GoDef"<CR>

autocmd BufWritePre * :retab        " Convert tab to spaces

autocmd BufNewFile,BufRead *.tex set makeprg=latexmk\ -pdf\ %

autocmd BufNewFile,BufWritePost *.go SyntasticCheck

" ------------------------------------------------------------------------------
" Shortcut
nmap <F8> :TagbarToggle<CR>
map <F7> :NERDTreeToggle<CR>
let g:vim_isort_map = '<C-i>'       " Sort import
