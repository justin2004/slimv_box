; install quicklisp in a slient fashion

(quicklisp-quickstart:install)

(in-package #:ql-util)
(setf *do-not-prompt* t)

(ql:add-to-init-file)
