### what

- slimv (Superior Lisp Interaction Mode for Vim) with sbcl (common lisp interpreter) and tmux (terminal multiplexer) in a Docker container


### why

- setting up slimv the first time took me a few hours and that could be an impediment to someone attempting to use slimv so i wanted to remove the impediment for first time slimv users



### how 

##### setup

- you need to have docker installed

    - it is a pretty easy installation
    - instructions for ubuntu:
        - https://docs.docker.com/v17.12/install/linux/docker-ce/ubuntu/
    - there are also instructions for fedora, debian, centos, etc.

    - you'll probably want to follow the instructions referenced by "Continue to Linux postinstall to allow non-privileged users to run Docker commands and for other optional configuration steps."


- then i would create an alias in your .bashrc like this:

    - if you want to use the image straight from the docker hub registry:

>        - alias vv='docker run --rm -it -v `pwd`:/mnt justin2004/slimv_box'

- or if you build the image yourself

>        - alias vv='docker run --rm -it -v `pwd`:/mnt slimv_box'

- replacing "slimv_box" with the tag name you used

##### use

- cd to the directory where you have some common lisp source files you want to edit

- run "vv"

    - the first time you do this it will need to download the image from docker hub

- now you should be in the container and vim should be running inside tmux

- either create a new file ":e newfile.lisp" or open an existing one ":e oldfile.lisp"

- press ,c to start swank

- TODO reference slimv tutorial


### NOTES

- only files in the /mnt directory (in the container) are saved when you leave vim!

- don't run vv from within an existing tmux session or else you'll end up with an embedded tmux session


- you'll need to know how to use:

    - vim
    - tmux
    - common lisp
    - docker (well you just need docker ce installed and your user account needs to be in the docker group)


- TODO maybe i should add gvim and/or xterm support so that the slimv menu is visible and clickable and i bet some users would prefer the GUI-ish approach to slimv



