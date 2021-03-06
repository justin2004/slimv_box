### what

- an IDE for Common Lisp
- [slimv](https://github.com/kovisoft/slimv) (Superior Lisp Interaction Mode for Vim) and tmux (terminal multiplexer) in a Docker container
- with [sbcl](http://www.sbcl.org/) and [abcl](https://common-lisp.net/project/armedbear/)
    - you choose one at container run time with an environment variable (see below)
- also including:
    - [quicklisp](https://www.quicklisp.org/beta/) 
    - a copy of the common lisp hyperspec (for offline use)
        - which opens with [w3m.vim](https://github.com/justin2004/w3m.vim) (a vim plugin for w3m)
    - support for [CEPL](https://github.com/cbaggers/cepl) on a system without hardware acceleration
    - [fzf](https://github.com/junegunn/fzf) (fuzzy finder)
        - to find files in your current host directory press `:FZF` 
        - to find files in quicklisp packages press `:FZF ~` 
        - then press ctrl-x to bring that selected file into a horizontal split
    - [vim-sexp](https://github.com/guns/vim-sexp)
        - if you want to disable structural editing you can edit `.vimrc`, comment out `Plugin 'guns/vim-sexp'`, and rebuild the image

[![asciicast](https://asciinema.org/a/314616.svg)](https://asciinema.org/a/314616)


### why

- setting up slimv the first time took me a few hours and that could be an impediment to someone attempting to use slimv so i wanted to remove the impediment for first time slimv users



### how 

##### setup

- you need to have docker installed

    - [install_docker](https://docs.docker.com/install/)

    - you'll probably want to follow the instructions referenced by "Continue to Linux postinstall to allow non-privileged users to run Docker commands and for other optional configuration steps."


- then you have to build this image yourself
    - clone this repo and cd into it
>       docker build --build-arg=uid=`id -u` --build-arg=gid=`id -g` -t justin2004/slimv_box .


- then i would create an alias in your .bashrc like this 
    - for sbcl

>        alias  vv='docker run --user=`id -u`:`id -u` -e CL_IMPLEMENTATION=sbcl --net=host --rm -it -v `pwd`:/mnt justin2004/slimv_box'


- then another
    - for abcl

>        alias vva='docker run --user=`id -u`:`id -u` -e CL_IMPLEMENTATION=abcl --net=host --rm -it -v `pwd`:/mnt justin2004/slimv_box'


- then perhaps another
    - if you want to output to X11 (for CEPL)

>        alias vvc='docker run -e DISPLAY=$DISPLAY -v ~/.Xauthority:/home/containeruser/.Xauthority -v /tmp/.X11-unix:/tmp/.X11-unix --user=`id -u`:`id -u` --rm -it --e CL_IMPLEMENTATION=sbcl --net=host -v `pwd`:/mnt justin2004/slimv_box'




##### use

- assuming you've built the image already 

- cd to the directory where you have some common lisp source files you want to edit

- run "vv"

- now you should be in the container and vim should be running inside tmux

- either create a new file ":e newfile.lisp" or open an existing one ":e oldfile.lisp"

- press ,c to start swank

- you can now follow the [tutorial](https://kovisoft.github.io/slimv-tutorial/tutorial.html):

- when you are done editing your .lisp files be sure to :w them, press ,Q to quit the sbcl REPL, then :q



### NOTES

- if you don't want to wait for the quicklisp downloads each time you start slimv_box then use a docker volume
    - e.g.
>        alias vv='docker run --user=`id -u`:`id -u` --rm -it --net=host -v slimv_box_userhome:/home/containeruser -v `pwd`:/mnt justin2004/slimv_box'

- only files in the /mnt directory (in the container) are saved when you leave vim!

- don't run vv from within an existing tmux session or else you'll end up with an embedded tmux session


- you'll need to know how to use:

    - vim
    - tmux
    - common lisp
    - docker (well you just need docker ce installed and your user account needs to be in the docker group)


- TODO maybe i should add gvim and/or xterm support so that the slimv menu is visible and clickable because i bet some users would prefer the GUI-ish approach to slimv



