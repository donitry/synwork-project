;;;; synwork-project.lisp

(in-package #:synwork-project)

;;; "synwork-project" goes here. Hacks and glory await!
;;;
;;;

(define-route project-list-t ("project-list-t")
  ;(print (hunchentoot:get-parameter "page-id"))
  (let* ((page-id (validate-page-id (hunchentoot:get-parameter "page-id"))))
	(if page-id
	  ;(:sift-variables (page-id #'validate-page-id))
	  
	  (list :title (format nil "Project list:~A" page-id)
			:body (show-projects (get-all-projects page-id)))
	  (list :title "Project List"
	  		:body (show-projects (get-all-projects 0))))))

(define-route project-list ("project-list/:page-id")
  (:sift-variables (page-id #'validate-page-id))
  (list :title "Project List"
		:body (show-projects (get-all-projects page-id))))

(define-route project-detail ("project-detail/:pro-id")
  (if (logged-on-p)
    (let* ((project-info (find-project-by-id pro-id))
		   (apply-managers (get-all-apply-managers pro-id))
		   (apply-contracts (get-all-apply-contracts pro-id)))
	  (list :title "Project detail"
			:body (list (show-project-detail (find-project-by-id pro-id))
						(when apply-managers
						  (show-apply-manager-list apply-managers))
						(when apply-contracts
						  (show-apply-contracts-list apply-contracts)))))
	(redirect "/login")))

(define-route project-apply-manager-detail ("manager-detail/apply/:manager-id")
  (if (logged-on-p)
	(let* ((apply-manager (find-manager-by-id manager-id))
		   (confirm-manager (

(define-route sponsor ("sponsor/:pro-id")
  (list :title "Project Sponsor"
		:body (project-spon-form (find-project-by-id pro-id))))

(define-route sponsor/post ("project-sponsor/post" :method :post)
  (if (logged-on-p)
	(let* ((user-info (logged-info (logged-on-p)))
		   (project-id (hunchentoot:post-parameter "project_id"))
		   (sponsor-cost (hunchentoot:post-parameter "spon_cost")))
	  (if (and 
			user-info
			project-id)
		(when (project-sponsor project-id (getf user-info :id) sponsor-cost)
		  (redirect 'project-detail :pro-id project-id))))
	(redirect "/login")))

(define-route apply-manager ("apply-manager/:pro-id")
  (list :title "Project Manager Apply"
		:body (project-apply-manager-form (find-project-by-id pro-id))))

(define-route apply-manager/post ("apply-manager/post" :method :post)
  (if (logged-on-p)
	(let* ((project-id (hunchentoot:post-parameter "project_id"))
		   (user-info (list :user-name (logged-on-p)
							:real-name (hunchentoot:post-parameter "real_name")
							:private-id (hunchentoot:post-parameter "private_id"))))
	  (if (and project-id (getf user-info :real-name) (getf user-info :private-id))
		(when (project-apply-manager project-id user-info)
		  (redirect 'project-detail :pro-id project-id))
		(redirect 'apply-manager :pro-id project-id)))
	(redirect "/login")))

(define-route apply-contract ("apply-contract/:pro-id")
  (list :title "Project Contract Apply"
        :body (project-apply-contract-form (find-project-by-id pro-id))))

(define-route apply-contract/post ("apply-contract/post" :method :post)
  (if (logged-on-p)
    (let* ((project-id (hunchentoot:post-parameter "project_id"))
           (contract-info (list :orgize-name (hunchentoot:post-parameter "orgize_name")
                                :orgize-des (hunchentoot:post-parameter "orgize_des")
	                        	:quoted-price (hunchentoot:post-parameter "quoted_price"))))
	  (if (and project-id contract-info)
	    (when (project-apply-contract project-id contract-info)
	      (redirect 'project-detail :pro-id project-id))
	    (redirect 'apply-contract :pro-id project-id)))
    (redirect "/login")))

(define-route project/create ("project/create")
  (list :title "Create Project"
		:body (create-project-form)))

(define-route project/create/post ("project/create" :method :post)
  (if (logged-on-p)
	(let* ((user-info (logged-info (logged-on-p))))
	  (if user-info
		(let* ((project-info (list :project-name (hunchentoot:post-parameter "pro_name") 
								   :project-des (hunchentoot:post-parameter "pro_des")
								   :submitter-id (getf user-info :id))))
		  (when (u-project-create project-info)
			(redirect 'project-list :page-id 0)))
		(redirect "/register")))
	(redirect "/login")))

(define-route test ("ptest")
  (list :title "test project"
		:body (test-frame)))
