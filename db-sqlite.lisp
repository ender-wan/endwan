(in-package :com.endwan.www)

(defvar *db-name* "db/website.db")

(clsql:connect (list *db-name*) :database-type :sqlite3)
