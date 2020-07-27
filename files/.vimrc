" Reload .vimrc = "so %"
set nocompatible

set shell=bash
let mapleader=","

" GUI only
" set guifont=Monaco:h15
set guifont=Fira\ Code:h15
"if has("gui")
"    set lines=40
"    set columns=130
"endif


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
    Plugin 'Shougo/neocomplete.vim'

    " Themes
    Plugin 'scwood/vim-hybrid'      " hybrid
    Plugin 'fatih/molokai'          " molokai
    Plugin 'juanedi/predawn.vim'    " predawn
    Plugin 'nanotech/jellybeans.vim', { 'tag': 'v1.6' }
    Plugin 'mitsuhiko/fruity-vim-colorscheme' " fruity
    Plugin 'lifepillar/vim-solarized8'

    Plugin 'vimwiki/vimwiki'          " http://vimwiki.github.io/
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
" set termguicolors     " enable VIM truecolor (a bit buggy), default ON on Neods
" colorscheme hybrid
colorscheme solarized8
"colorscheme jellybeans
" colorscheme myterm
let g:jellybeans_use_term_italics = 1
"set guifont=Monaco:h10

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
" Neocomplete
" https://github.com/Shougo/neocomplete.vim

"Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'


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

" let g:syntastic_python_python_exec = 'python3'
" let g:syntastic_python_checkers = ['python']
let python_highlight_all=1

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

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

" ------------------------------------------------------------------------------
" Startup
au VimEnter *  NERDTree | wincmd w
