set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set relativenumber          " relative line numbers
set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on          " clear background
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
highlight Normal ctermbg=NONE guibg=NONE " Disable Nvim background colors
set complete+=kspell
" set spell                 " enable spell check (may need to download language package)
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.

call plug#begin()

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" LSP
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Git Fugitive
Plug 'tpope/vim-fugitive'

" Vim Airline bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Nerd font icons
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Set Airline Color Theme
let g:airline_theme='behelit'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

let mapleader = " "

" General and FZF keybinds
nnoremap <leader>ft :Ex<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fw :Rg<CR>
nnoremap <leader>w :Windows<CR>
nnoremap <leader>h :History/<CR>
nnoremap <leader>g :GFiles?<CR>
nnoremap <leader>c :Commands<CR>
nnoremap <leader>th :Colors<CR>
nnoremap <leader>? :Maps<CR>

" Fast movement
nnoremap <c-d> <c-d>zz
nnoremap <c-e> <c-u>zz
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>n :enew<CR>:Files<CR>
nnoremap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" LSP buffer keybinds
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> ld <plug>(lsp-definition)
    nmap <buffer> ls <plug>(lsp-document-symbol-search)
    nmap <buffer> lS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> lr <plug>(lsp-references)
    nmap <buffer> li <plug>(lsp-implementation)
    nmap <buffer> lt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [l <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]l <plug>(lsp-next-diagnostic)
    nmap <buffer> lh <plug>(lsp-hover)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
        autocmd FileType objc setlocal omnifunc=lsp#complete
        autocmd FileType objcpp setlocal omnifunc=lsp#complete
    augroup end
endif

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


