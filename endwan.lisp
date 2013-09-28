(in-package :cl-user)

(ql:quickload '(cl-who hunchentoot parenscript))

(defpackage :com.endwan.www
  (:use :cl :cl-who :hunchentoot :parenscript))

(in-package :com.endwan.www)

(defvar *web-server* (start (make-instance 'easy-acceptor :port 8080)))

(defmacro standard-page ((&key title) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
     (:html :xmlns "http://www.w3.org/1999/xhtml"
            :xml\:lang "en"
            :lang "en"
            (:head
             (:meta :http-equiv "Content-Type"
                    :content "text/html;charset=utf-8")
             (:title ,title)
             (:link :type "text/css"
                    :rel "stylesheet"
                    :href "site.css"))
            (:body
             (:div :id "header"
                   (:img :src "/logo.jpg"
                         :alt "Commodore 64"
                         :width "100"
                         :height "50"
                         :class "logo")
                   (:span :class "strapline"
                          "This is Ender's new home")
                   (:a :href "/index" "home")
                   (:a :href "/blog" "blog")
                   (:a :href "/about" "about me"))
             ,@body)
            (:div :id "footer"
                  "Created by Common Lisp :)"))))

(defun index-page ()
  (standard-page (:title "home")
    (:h1 "Home")
    (:div :id "content"
          (:p "My first website!"))))

(defun my-blog ()
  (standard-page (:title "Ender's Blog")
    (:h1 "Ender's Blog")
    (:div :id "content"
          (:p "Coming soon..."))))

(defun about-me ()
  (standard-page (:title "About Me")
    (:h1 "About Me")
    (:div :id "content"
          (:p "I'm a C++ and Lisp programmer!"))))

(setf *dispatch-table*
      (list
       (create-prefix-dispatcher "/index" 'index-page)
       (create-prefix-dispatcher "/blog" 'my-blog)
       (create-prefix-dispatcher "/about" 'about-me)
       (create-static-file-dispatcher-and-handler "/logo.jpg" "imgs/logo.jpg")
       (create-static-file-dispatcher-and-handler "/site.css" "css/site.css")))
