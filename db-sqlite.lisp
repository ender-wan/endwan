(in-package :com.endwan.www)

(defvar *db-name* "db/website.db")

(defvar table-posts-name "posts")

(defun connect-db ()
  (clsql:connect (list *db-name*) :if-exists :old :database-type :sqlite3))

(defun disconnect-db ()
  (clsql:disconnect :database (clsql:find-database *db-name*)))

(defclass post ()
  ((user
    :accessor user
    :initarg :user)
   (subject
    :accessor subject
    :initarg :subject)
   (body
    :accessor body
    :initarg :body)
   (timestamp
    :accessor timestamp
    :initarg :timestamp)))

(defmethod create-post-table ()
  (if (clsql:table-exists-p table-posts-name)
      (format t "table ~a exists" table-posts-name)
      (clsql:create-table 'posts
                         '((user (char 16))
                           (subject (char 128))
                           (body (varchar 1024*1024))
                           (timestamp datatime)))))

(defmethod write-to-db ((a-post post))
  (with-slots (user subject body timestamp) a-post
    (clsql:insert-records :into table-posts-name :attributes '(user subject body timestamp)
                          :values (list user subject body timestamp))))

(defmethod make-post-list ()
  (let* ((instance-list ()))
    (multiple-value-bind (records key-list) (clsql:select '* :from table-posts-name)
      (if (> (list-length records) 0)
          (loop for r in records
             do
               (push (make-post-instance key-list r) instance-list))
          nil)
      instance-list)))

(defun make-post-instance (key-list value-list)
  (let ((key-value-list ()))
    (loop
       for k in key-list
       for v in value-list
       do
         (if (string= k "timestamp")
             (setf v (parse-integer v))
             nil)
         (push v key-value-list)
         (push (intern k :keyword) key-value-list))
    (apply #'make-instance 'post key-value-list)))