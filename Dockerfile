#FROM debian:experimental
# i originally used ^ because i need a newer version of sbcl
FROM debian:10

LABEL maintainer="Justin <justin2004@hotmail.com>"

USER root
WORKDIR /root

RUN apt-get update \
        && apt-get install -y \
        git \
        curl \
        openjdk-11-jre \
        w3m \
        fzf \
        make \
        build-essential \
        libpython-all-dev \
        python-dev \
        python-all \
        libncurses5-dev \
        exuberant-ctags \
        tmux \
        sbcl \
        sbcl-source \
        procps \
        netcat


# so we can run tmux in the container
RUN apt-get update && apt-get install -y locales
RUN sed --in-place -e '/en_US.UTF-8 UTF-8/ s/^#//' /etc/locale.gen
RUN locale-gen


#################################

# TODO note the image on dockerhub will only be agreeable if your uid and gid are:
ARG uid=1000
ARG gid=1000
ARG user=containeruser

# abcl needs its user to have a homedir
RUN groupadd -g $gid $user || true
RUN useradd $user --uid $uid --gid $gid --home-dir /home/$user && \
    mkdir /home/$user && \
    chown $uid:$gid /home/$user

USER $user
WORKDIR /home/$user

RUN git clone --depth 1 'https://github.com/vim/vim.git'

# enable python for vim
RUN sed --in-place -e 's/#CONF_OPT_PYTHON\>/CONF_OPT_PYTHON/' vim/src/Makefile
RUN cd vim/src && make

# now get slimv
RUN git clone --depth 1 'https://github.com/kovisoft/slimv.git'
RUN mkdir .vim && cp -r slimv/* .vim/

# TODO maybe figure out where the /usr/local/share/ prefix is defined in the
# vim build scripts
#RUN ln -s /root/vim/runtime /usr/local/share/vim
USER root
RUN ln -s /home/$user/vim/runtime /usr/local/share/vim
USER $user


####################
# add abcl   --  TODO build from source so we can ,j to definitions
#  sometimes the download fails so i just manually add abcl to this working copy
#COPY abcl-bin-1.6.0.tar.gz /home/$user/
#RUN tar -xaf abcl-bin-1.6.0.tar.gz
RUN curl -O 'https://common-lisp.net/project/armedbear/releases/1.6.0/abcl-bin-1.6.0.tar.gz' && \
    tar -xaf abcl-bin-1.6.0.tar.gz



####################
# hyperspec
# for better readability with a black terminal background
RUN mkdir /home/$user/.w3m && echo 'anchor_color magenta' > /home/$user/.w3m/config
# for offline hyperspec
RUN curl -O http://ftp.lispworks.com/pub/software_tools/reference/HyperSpec-7-0.tar.gz
RUN tar -xaf HyperSpec-7-0.tar.gz


ADD .vimrc /home/$user/



# get quicklisp
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp

ADD install_ql.lisp      /home/$user
ADD install_ql_abcl.lisp /home/$user

# add quicklisp to sbclrc
# TODO gpg verification?
RUN touch .sbclrc
RUN sbcl --load quicklisp.lisp --load install_ql.lisp --eval '(quit)'

# add quicklisp to abclrc
RUN java -jar abcl-bin-1.6.0/abcl.jar --load install_ql_abcl.lisp --eval '(quit)'




# so tmux will have mode-keys vi set
RUN echo 'set -o vi'            >> /home/$user/.bashrc
RUN echo 'declare -x EDITOR=vi' >> /home/$user/.bashrc
RUN echo 'declare -x VISUAL=vi' >> /home/$user/.bashrc


# vundle and some vim plugins
RUN git clone --depth 1 https://github.com/VundleVim/Vundle.vim.git /home/$user/.vim/bundle/Vundle.vim
RUN /home/$user/vim/src/vim +PluginInstall +qall


# TODO should abcl and sbcl share caches?
#   quicklisp will write to (/root/quicklisp /root/.cache)


# optional packages
#USER root
#COPY extras.sh /home/$user 
#RUN /home/$user/extras.sh
#USER $user

WORKDIR /mnt

# this allows one to use <M-x> key combinations in vim
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# set EDITOR so we have vi tmux mode-keys
#CMD ["bash", "-c", "declare -x HOME=/root ; declare -x EDITOR=vi ;  tmux new-session '/root/vim/src/vim'"]
CMD ["bash", "-c", "declare -x EDITOR=vi ;  tmux new-session '$HOME/vim/src/vim'"]
