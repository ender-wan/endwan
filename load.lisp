(in-package :cl-user)

(ql:quickload '(cl-who hunchentoot parenscript clsql-sqlite3))

(load "packages.lisp")
(load "endwan.lisp")
(load "db-sqlite.lisp")

(in-package :com.endwan.www)