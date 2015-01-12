(defpackage #:synwork-project-config (:export #:*base-directory*))
(defparameter synwork-project-config:*base-directory* 
  (make-pathname :name nil :type nil :defaults *load-truename*))

(asdf:defsystem #:synwork-project
  :serial t
  :description "Your description here"
  :author "Your name here"
  :license "Your license here"
  :depends-on (:RESTAS :SEXML :IRONCLAD :BABEL
  			   :CL-REDIS :POSTMODERN
  			   :restas-directory-publisher :synwork-auth)
  :components ((:file "defmodule")
  			   (:file "redis-datastore")
			   (:file "pg-datastore")
			   (:file "util")
			   (:file "template")
               (:file "synwork-project")
			   ))
