;;;;;;;;;; util.lisp
;;;
(in-package #:synwork-project)

(defvar *redirect-route-project*)

(defun u-project-create (project-info)
  (create-project project-info))
 
(defun get-all-project (&optional project-name)
  (get-all-projects 0 (or project-name "")))

(defun validate-page-id (id)
  (let ((id (parse-integer id :junk-allowed t)))
	;(if (< id (parse-integer *page-all-count*)) ;i think because *page-all-count* initial been integer 
	(if (and
		  (not (> id *page-all-count*))
		  (not (< id 0))) 
		id
	  	nil)))

(defun slug (string)
  (substitute #\- #\Space
	(string-downcase
	  (string-trim '(#\Space #\Tab #\Newline)
				   string))))

(defun init-datastore-project (&key
								(datastore 'synwork-project.redis-datastore:redis-datastore)
								(datastore-init nil))
  (setf *datastore* (apply #'make-instance datastore datastore-init))
  (init)
  (setf *page-all-count* (count-project *page-max-per*))
  )


