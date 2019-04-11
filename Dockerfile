FROM debian:stretch
# TODO maybe slim or even alpine would work fine?

LABEL maintainer="Justin <justin2004@hotmail.com>"

# TODO could reorder these stanzas in a logical fashion
#   i left them in the order i developed them in

# TODO use a multistage build to remove the vim src, etc. 

WORKDIR /root

RUN set -x \
    && apt-get update \
    && apt-get install -y git 
RUN git clone 'https://github.com/vim/vim.git'
RUN apt-get install -y make
RUN apt-get install -y build-essential
RUN apt-get install -y libpython-all-dev
RUN apt-get install -y python-dev
RUN apt-get install -y python-all
RUN apt-get install -y libncurses5-dev

# enable python for vim
RUN sed --in-place -e 's/#CONF_OPT_PYTHON\>/CONF_OPT_PYTHON/' vim/src/Makefile
RUN cd vim/src && make

# now get slimv
RUN git clone 'https://github.com/kovisoft/slimv.git'
RUN mkdir .vim && cp -r slimv/* .vim/

# TODO maybe figure out where the /usr/local/share/ prefix is defined in the
# vim build scripts
RUN ln -s /root/vim/runtime /usr/local/share/vim


RUN apt-get install -y tmux
RUN apt-get install -y sbcl

# just used for troubleshooting
RUN apt-get install -y procps

# so we can run tmux in the container
RUN apt-get install -y locales
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
RUN apt-get install -y curl
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp

ADD install_ql.lisp /root

# TODO gpg verification?
RUN touch .sbclrc
RUN sbcl --load quicklisp.lisp --load install_ql.lisp --eval '(quit)'




# so tmux will have mode-keys vi set
RUN echo 'set -o vi'            >> /root/.bashrc
RUN echo 'declare -x EDITOR=vi' >> /root/.bashrc
RUN echo 'declare -x VISUAL=vi' >> /root/.bashrc

# troubleshooting
RUN apt-get install -y netcat

# for hyperspec
RUN apt-get install -y w3m
# for offline hyperspec
RUN curl -O http://ftp.lispworks.com/pub/software_tools/reference/HyperSpec-7-0.tar.gz
RUN tar -xaf HyperSpec-7-0.tar.gz

# so non-root users can run vim (which lives in /root)
# and
# quicklisp will write to (/root/quicklisp /root/.cache)
# we don't want to chown -R at container runtime (when we know the uid of the user) though...
RUN chmod -R 777 /root

WORKDIR /mnt

# set the HOME variable so vim can set its rtp (runtimepath)
# as the root user.  we are just using the root user's home
# because we don't know what user will run the container at
# image build time
CMD ["bash", "-c", "declare -x HOME=/root ;  tmux new-session '/root/vim/src/vim'"]

#CMD ["bash", "-c", "tmux new-session '/root/vim/src/vim -u /root/.vimrc'"]
#CMD ["bash", "-c", "tmux new-session '/root/vim/src/vim'"]
#CMD ["bash", "-c", "tmux new-session /root/vim/src/vim"]
