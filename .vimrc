"""""""""""""""""""""""""""
" for vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
"Plugin 'tpope/vim-dadbod'
"Plugin 'moll/vim-node'
"Plugin 'leafgarland/typescript-vim'
"Plugin 'jpalardy/vim-slime'
"Plugin 'https://gitlab.com/n9n/vim-apl'
"Plugin 'https://github.com/skywind3000/asyncrun.vim'
Plugin 'junegunn/fzf'
"Plugin 'sotte/presenting.vim'
"Plugin 'junegunn/goyo.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
call vundle#end()
filetype plugin indent on
"""""""""""""""""""""""""""


syntax enable
set background=dark
set ai
" TODO tabstop, etc.
set hlsearch
set ignorecase
set wildmenu
set history=10000

let CL = $CL_IMPLEMENTATION

" default to sbcl
if CL == ''
    let CL = 'sbcl'
endif

if CL == 'abcl'
    " abcl takes some time to start
    let g:slimv_timeout=40
    let g:slimv_swank_cmd = '! if [ -z "$TMUX" ] ; then echo you need to start tmux first then open vim within tmux ; exit 1 ; else tmux new-window -d -n REPL-ABCL "java -jar $HOME/abcl-bin-1.6.0/abcl.jar --load $HOME/.vim/slime/start-swank.lisp" ; fi'
elseif CL == 'sbcl'
    "let g:slimv_swank_cmd = '! if [ -z "$TMUX" ] ; then echo you need to start tmux first then open vim within tmux ; exit 1 ; else tmux new-window -d -n REPL-SBCL "sbcl --load /root/.vim/slime/start-swank.lisp" ; fi'
    let g:slimv_swank_cmd = '! if [ -z "$TMUX" ] ; then echo you need to start tmux first then open vim within tmux ; exit 1 ; else tmux new-window -d -n REPL-SBCL "sbcl --load $HOME/.vim/slime/start-swank.lisp" ; fi'
endif

" offline hyperspec
"let g:slimv_clhs_root="file:///root/HyperSpec/Body/"
let g:slimv_clhs_root="file://$HOME/HyperSpec/Body/"


" allow tags to be generated for quicklisp libraries
"    TODO should i let that tmp path get autogenerated then append the
"    quicklisp path later?
"set tags=/tmp/v7bAQym/2,./tags,./TAGS,tags,TAGS,/root/quicklisp/dists/quicklisp/software/tags
"let g:slimv_ctags="cd /root/quicklisp/dists/quicklisp/software ; ctags -R ."
set tags=/tmp/v7bAQym/2,./tags,./TAGS,tags,TAGS,$HOME/quicklisp/dists/quicklisp/software/tags
let g:slimv_ctags="cd $HOME/quicklisp/dists/quicklisp/software ; ctags -R ."


" put the REPL on bottom
"let g:slimv_repl_split=2

" put the REPL on right
let g:slimv_repl_split=4


set laststatus=2
set statusline=%f\ %y\ %m\ %p%%\ %l\ %c
hi StatusLine ctermbg=White ctermfg=DarkBlue

" TODO set g:slimv_impl='clisp' or do a PR against slimv and add 'abcl'
"      to allow looking at locals on the stack in the debugger
