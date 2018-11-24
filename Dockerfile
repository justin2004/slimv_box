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

#ADD entry.lisp      /root

# TODO pgp verification
#RUN wget 'https://beta.quicklisp.org/quicklisp.lisp'
#RUN touch .sbclrc
#RUN sbcl --load quicklisp.lisp --load install_it.lisp --eval '(quit)'



#STOPSIGNAL SIGTERM

CMD ["./entry.lisp", "--help"]
