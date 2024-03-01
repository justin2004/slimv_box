"""""""""""""""""""""""""""
" for vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'junegunn/fzf'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'preservim/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'guns/vim-sexp'
Plugin 'jpalardy/vim-slime'
Plugin 'justin2004/vim-apl'  "my fork of 'https://gitlab.com/n9n/vim-apl' because the upstream disappeared
Plugin 'justin2004/w3m.vim'  "my fork of 'yuratomo/w3m.vim' because the upsteam doesn't accept PRs
Plugin 'luochen1990/rainbow'
call vundle#end()
filetype plugin indent on
"""""""""""""""""""""""""""
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle


syntax enable
set background=dark
set ai
set hlsearch
set incsearch
set noignorecase
set wildmenu
set history=10000
set belloff=all
set hidden

let CL = $CL_IMPLEMENTATION

" default to sbcl
if CL == ''
    let CL = 'sbcl'
endif

if CL == 'abcl'

    " abcl takes some time to start
    let g:slimv_timeout=40

    let g:slimv_impl='clisp'
    " ^ allows inspection of variables on the stack in the debugger
    " TODO does it have other, undesireable, effects?

    let g:slimv_swank_cmd = '! if [ -z "$TMUX" ] ; then echo you need to start tmux first then open vim within tmux ; exit 1 ; else tmux new-window -d -n REPL-ABCL "java -jar $HOME/abcl-bin-1.9.2/abcl.jar --load $HOME/.vim/slime/start-swank.lisp" ; fi'

elseif CL == 'sbcl'

    let g:slimv_swank_cmd = '! if [ -z "$TMUX" ] ; then echo you need to start tmux first then open vim within tmux ; exit 1 ; else tmux new-window -d -n REPL-SBCL "sbcl --load $HOME/.vim/slime/start-swank.lisp" ; fi'

endif

" offline hyperspec
let g:slimv_clhs_root="file://$HOME/HyperSpec/Body/"
" let g:slimv_browser_cmd_ex=":W3m local"


" allow tags to be generated for quicklisp libraries
"    TODO should i let that tmp path get autogenerated then append the
"    quicklisp path later?
set tags=/tmp/v7bAQym/2,./tags,./TAGS,tags,TAGS,$HOME/quicklisp/dists/quicklisp/software/tags
let g:slimv_ctags="cd $HOME/quicklisp/dists/quicklisp/software ; ctags -R ."


" put the REPL on bottom
"let g:slimv_repl_split=2

" put the REPL on right
let g:slimv_repl_split=4

" turn off slimv's paredit
let g:paredit_mode = 0


set laststatus=2
set statusline=%f\ %y\ %m\ %p%%\ %l\ %c
hi StatusLine ctermbg=White ctermfg=DarkBlue


" vim-slime
let g:slime_target="tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{down-of}"}
"let g:slime_no_mappings=1
"let g:slime_python_ipython = 1

" slimv does not seem to set this?
au FileType lisp set commentstring=;%s




" only works if you run the vvc alias (for X11)
function! LookAtImage(...)
        let fpath=expand('%')
        execute('!feh --force-aliasing ' . fpath)
endfunction

au BufEnter *.png,*.jpg,*.jpeg,*.gif :call LookAtImage()

