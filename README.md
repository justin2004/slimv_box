### what

- slimv (Superior Lisp Interaction Mode for Vim) with sbcl (common lisp interpreter) and tmux (terminal multiplexer) in a Docker container


### why

- setting up slimv the first time took me a few hours and that could be an impediment to someone attempting to use slimv so i wanted to remove the impediment for first time slimv users



### how 

##### setup
- i would create an alias in your .bashrc like this:

    - if you want to use the image straight from the docker hub registry:

>        - alias vv='docker run --rm -it -v `pwd`:/mnt justin2004/slimv_box'

- or if you build the container yourself

>        - alias vv='docker run --rm -it -v `pwd`:/mnt slimv_box'

- replacing "slimv_box" with the tag name you used

##### use

- cd to the directory where you have some common lisp source files you want to edit

- run "vv"

- now you should be in the container and vim should be running inside tmux

- either create a new file ":e newfile.lisp" or open an existing one ":e oldfile.lisp"

- press ,c to start swank

- TODO reference slimv tutorial


### NOTES

- only files in the /mnt directory are saved when you leave vim!

- you'll need to know how to use:

    - vim
    - tmux
    - common lisp
    - docker


