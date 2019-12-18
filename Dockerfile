FROM debian:experimental
# TODO maybe slim or even alpine would work fine?

LABEL maintainer="Justin <justin2004@hotmail.com>"

# TODO could reorder these stanzas in a logical fashion
#   i left them in the order i developed them in

# TODO use a multistage build to remove the vim src, etc. 

WORKDIR /root

# for CEPL without hardware acceleration
RUN apt-get update && apt-get install -y libglapi-mesa libgl1-mesa-dev libsdl2-dev libsdl2-2.0-0 xorg-dev x11-apps

RUN set -x \
    && apt-get update \
    && apt-get install -y git make build-essential libpython-all-dev python-dev python-all libncurses5-dev exuberant-ctags tmux sbcl sbcl-source
RUN git clone 'https://github.com/vim/vim.git'

# enable python for vim
RUN sed --in-place -e 's/#CONF_OPT_PYTHON\>/CONF_OPT_PYTHON/' vim/src/Makefile
RUN cd vim/src && make

# now get slimv
RUN git clone 'https://github.com/kovisoft/slimv.git'
RUN mkdir .vim && cp -r slimv/* .vim/

# TODO maybe figure out where the /usr/local/share/ prefix is defined in the
# vim build scripts
RUN ln -s /root/vim/runtime /usr/local/share/vim


# just used for troubleshooting
RUN apt-get update && apt-get install -y procps netcat

# so we can run tmux in the container
RUN apt-get update && apt-get install -y locales
RUN sed --in-place -e '/en_US.UTF-8 UTF-8/ s/^#//' /etc/locale.gen
RUN locale-gen

ADD .vimrc /root

# your pwd in the host should be mounted here
WORKDIR /mnt


# since in the container we are running as root
# but if you create a new file while in the container you probably want
# to be able to read/write it once you are outside of the container
RUN echo 'umask 0000' >> /root/.bashrc
# TODO this isn't ideal.
# is there a better way to do this?
# maybe we can get the uid of the user that runs the container and then inside the
# continer we can create a user with that uid?
# https://denibertovic.com/posts/handling-permissions-with-docker-volumes/

# ^ done!




# get quicklisp
WORKDIR /root
RUN apt-get update && apt-get install -y curl
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp

ADD install_ql.lisp /root

# TODO gpg verification?
RUN touch .sbclrc
RUN sbcl --load quicklisp.lisp --load install_ql.lisp --eval '(quit)'




# so tmux will have mode-keys vi set
RUN echo 'set -o vi'            >> /root/.bashrc
RUN echo 'declare -x EDITOR=vi' >> /root/.bashrc
RUN echo 'declare -x VISUAL=vi' >> /root/.bashrc


# for hyperspec
RUN apt-get update && apt-get install -y w3m
# for better readability with a black terminal background
RUN mkdir /root/.w3m && echo 'anchor_color magenta' > /root/.w3m/config
# for offline hyperspec
RUN curl -O http://ftp.lispworks.com/pub/software_tools/reference/HyperSpec-7-0.tar.gz
RUN tar -xaf HyperSpec-7-0.tar.gz

# so non-root users can run vim (which lives in /root)
# and
# quicklisp will write to (/root/quicklisp /root/.cache)
# we don't want to chown -R at container runtime (when we know the uid of the user) though...
RUN chmod -R 777 /root


# GNU scientific library
RUN apt-get update && apt-get install -y gsl-bin libgsl-dev

# vundle and some vim plugins
RUN git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim
RUN /root/vim/src/vim +PluginInstall +qall
RUN apt-get update && apt-get install -y fzf

RUN apt-get update && apt-get install -y jq gnuplot

RUN apt-get update && apt-get install -y libv4l-dev libv4l-0

WORKDIR /mnt

# set the HOME variable so vim can set its rtp (runtimepath)
# as the root user.  we are just using the root user's home
# because we don't know what user will run the container at
# image build time
#
# set EDITOR so we have vi tmux mode-keys 
#
CMD ["bash", "-c", "declare -x HOME=/root ; declare -x EDITOR=vi ;  tmux new-session '/root/vim/src/vim'"]
