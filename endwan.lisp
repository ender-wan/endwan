(in-package :com.endwan.www)

(defvar *web-server* (start (make-instance 'easy-acceptor :port 8080)))

(defvar static-files (list (create-static-file-dispatcher-and-handler "/logo.jpg" "imgs/logo.jpg")
                           (create-static-file-dispatcher-and-handler "/site.css" "css/site.css")))

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
                   (:span :class "strapline"
                          "This is Ender's new home")
                   (:a :href "/index" "home")
                   (:a :href "/articles" "articles")
                   (:a :href "/about" "about me"))
             ,@body)
            (:div :id "footer"
                  (:img :src "/logo.jpg"
                        :alt "Commodore 64"
                        :width "90"
                        :height "30"
                        :class "logo")))))

(defun index-page ()
  (standard-page (:title "home")
    (:h1 "Home")
    (:div :id "content"
          (:p "My first website!"))))

(defun articles ()
  (standard-page (:title "articles")
    (:h1 "All Articles")
    (:div :id "content"
          (:p "Coming soon..."))))

(defun about-me ()
  (standard-page (:title "About Me")
    (:h1 "About Me")
    (:div :id "content"
          (:p "I'm a C++ and Lisp programmer!"))))

(setf *dispatch-table*
      (append
             static-files
             (list
              (create-prefix-dispatcher "/index" 'index-page)
              (create-prefix-dispatcher "/articles" 'articles)
              (create-prefix-dispatcher "/about" 'about-me))))