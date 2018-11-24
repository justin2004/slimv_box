# notes:
#       i would create an alias in your .bashrc like this:
#       alias vv='docker run --rm -it -v `pwd`:/mnt slimv'

FROM debian:stretch
# maybe slim would work fine?

LABEL maintainer="Justin <justin2004@hotmail.com>"

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

# enable python
RUN sed --in-place -e 's/#CONF_OPT_PYTHON\>/CONF_OPT_PYTHON/' vim/src/Makefile
RUN cd vim/src && make

RUN git clone 'https://github.com/kovisoft/slimv.git'
RUN mkdir .vim && cp -r slimv/* .vim/
RUN ln -s /root/vim/runtime /usr/local/share/vim
RUN apt-get install -y tmux
RUN apt-get install -y procps
RUN apt-get install -y sbcl

# so we can run tmux
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


#STOPSIGNAL SIGTERM

CMD ["bash", "-c", "tmux new-session /root/vim/src/vim"]
