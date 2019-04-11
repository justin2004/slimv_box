syntax enable
set background=dark
set ai
" TODO tabstop, etc.
set hlsearch
set ignorecase

"let g:slimv_swank_cmd = '! tmux new-window -d -n REPL-SBCL "sbcl --load ~/.vim/slime/start-swank.lisp"' 
let g:slimv_swank_cmd = '! if [ -z "$TMUX" ] ; then echo you need to start tmux first then open vim within tmux ; exit 1 ; else tmux new-window -d -n REPL-SBCL "sbcl --load /root/.vim/slime/start-swank.lisp" ; fi' 
"let g:slimv_swank_cmd = '!sbcl --load ~/.vim/slime/start-swank.lisp &' 
"let g:slimv_swank_cmd = '! xterm -e sbcl --load ~/.vim/slime/start-swank.lisp &'

" offline hyperspec
let g:slimv_clhs_root="file:///root/HyperSpec/Body/"
