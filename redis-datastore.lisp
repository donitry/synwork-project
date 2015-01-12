;;;;;;;;;;;;;;;;;; redis-datastore.lisp
;;;
(in-package #:synwork-project.redis-datastore)

(defclass redis-datastore ()
  ((host :initarg :host :initform #(127 0 0 1) :accessor host)
   (port :initarg :port :initform 6379 :accessor port)))

(defmethod datastore-init ((datastore redis-datastore)))

(defun serialize-list (list)
  (with-output-to-string (out)
	(print list out)))

(defun deserialize-list (string)
  (let ((read-eval nil))
	(read-from-string string)))

(defun make-key (prefix suffix)
  (format nil "~a:~a" (symbol-name prefix) suffix))

(defmethod datastore-find-project ((datastore redis-datastore) project-name)
  (with-connection (:host (host datastore)
					:port (port datastore))
	nil))

(defmethod datastore-create-project ((datastore redis-datastore) project-info)
  (with-connection (:host (host datastore)
					:port (port datastore))
	(unless (datastore-find-project datastore (getf project-info :project-name))
	  (let ((id (red-incr :pro-ids)))
		(red-hset (make-key :spon (getf project-info :user-name)) (make-key :pro id) (getf project-info :project-name))))))

