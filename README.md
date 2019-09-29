### what

- an IDE for Common Lisp
- slimv (Superior Lisp Interaction Mode for Vim) with sbcl (common lisp interpreter) and tmux (terminal multiplexer) in a Docker container
    - now with:
        - quicklisp (https://www.quicklisp.org/beta/) 
        - a copy of the common lisp hyperspec (for offline use)
        - support for CEPL (https://github.com/cbaggers/cepl) on a system without hardware acceleration


### why

- setting up slimv the first time took me a few hours and that could be an impediment to someone attempting to use slimv so i wanted to remove the impediment for first time slimv users



### how 

##### setup

- use a GNU/Linux distro
    - i use Debian but i bet the Debian derivatives will work too
        - create an issue if that is not the case for you

- you need to have docker installed

    - it is a pretty easy installation
    - instructions for ubuntu:
        - https://docs.docker.com/v17.12/install/linux/docker-ce/ubuntu/
    - there are also instructions for fedora, debian, centos, etc.

    - you'll probably want to follow the instructions referenced by "Continue to Linux postinstall to allow non-privileged users to run Docker commands and for other optional configuration steps."


- then i would create an alias in your .bashrc like this 

    - mostly

>        alias vv='docker run --user=`id -u`:`id -u` --net=host --rm -it -v `pwd`:/mnt justin2004/slimv_box'

    - but if you want to output to X11 (for CEPL)

>        alias vvc='docker run -e DISPLAY=$DISPLAY -v ~/.Xauthority:/root/.Xauthority -v /tmp/.X11-unix:/tmp/.X11-unix --user=`id -u`:`id -u` --rm -it --net=host -v `pwd`:/mnt justin2004/slimv_box'



##### use

- cd to the directory where you have some common lisp source files you want to edit

- run "vv" or "vvc"

    - the first time you do this it will need to download the image from docker hub

- now you should be in the container and vim should be running inside tmux

- either create a new file ":e newfile.lisp" or open an existing one ":e oldfile.lisp"

- press ,c to start swank

- you can now follow the tutorial:

    - https://kovisoft.bitbucket.io/tutorial.html

- when you are done editing your .lisp files be sure to :w them, press ,Q to quit the sbcl REPL, then :q



### NOTES

- if you don't want to wait for the quicklisp downloads each time you start slimv_box then use a docker volume
    - e.g.
        - alias vv='docker run --user=`id -u`:`id -u` --rm -it --net=host -v slimv_box_root:/root -v `pwd`:/mnt justin2004/slimv_box'

- only files in the /mnt directory (in the container) are saved when you leave vim!

- don't run vv from within an existing tmux session or else you'll end up with an embedded tmux session


- you'll need to know how to use:

    - vim
    - tmux
    - common lisp
    - docker (well you just need docker ce installed and your user account needs to be in the docker group)


- TODO maybe i should add gvim and/or xterm support so that the slimv menu is visible and clickable because i bet some users would prefer the GUI-ish approach to slimv



