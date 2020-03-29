;; install quicklisp in a slient fashion
(load "~/quicklisp.lisp")
;(quicklisp-quickstart:install)
(load "~/quicklisp/setup.lisp")
(in-package #:ql-util)
(setf *do-not-prompt* t)
(ql:add-to-init-file)
