;;;;; template.lisp
;;;
(in-package #:synwork-project)

(defun create-project-form ()
  (<:form :action (genurl 'project/create/post) :method "post"
		  "Project Name:" (<:br)
		  (<:input :type "text" :name "pro_name")(<:br)
		  "Description" (<:br)
		  (<:textarea :name "pro_des" :rows 15 :cols 80) (<:br)
		  (<:input :type "submit" :value "Submit")))

(defun show-projects (projects)
  (<:div
    (<:ul
  	  (loop
	    for project in projects
	    collect
	     (<:li "Name is:"
		   (<:a :href (genurl 'project-detail :pro-id (getf project :id)) (getf project :project-name)) 
			   "By"
			   (getf project :id))))
	(<:ul
	  (loop 
		for num from 0 to *page-all-count*
		collect
	  	 (<:li "page:" 
		  (<:a :href (genurl 'project-list :page-id num) (+ 1 num)))))
	(<:ul
	  (<:li "page" *page-all-count*))
	))
  	
(defun show-project-detail (project)
  (<:div
	(<:ul
	  (<:li "Project's Name:" (getf project :name))
	  (<:li "Project's Id:" (getf project :id))
	  "Cost Count  :" (getf project :count-cost)(<:br)
	  (<:li (<:a :href (genurl 'sponsor :pro-id (getf project :id)) "spon") "   "
			(<:a :href (genurl 'apply-manager :pro-id (getf project :id)) "Apply Manager") "   "
			(<:a :href (genurl 'apply-contract :pro-id (getf project :id)) "Apply Contract")))
	))

(defun show-apply-manager-list (managers)
  (<:span
	(loop
	  for manager in managers
	  collect
	   (<:a :href (genurl 'project-apply-manager-detail :manager-id (getf manager :id)) (getf manager :user-name))
	   " "(getf manager :vote-count)(<:br))
	))

(defun show-manager-detail (manager)
  (<:span
	(<:ul
	  (<:li "Real_Name:" (getf manager :real-name)(<:br)
			"Private_Id:" (getf manager :private-id)))))

(defun project-manager-vote-form (vote-info)
  (<:form :action (genurl 'manager-vote/post) :method "post"
          "Vote-Count:" (getf vote-info :vote-count)(<:br)
		  (<:input :type "hidden" :name "user_id" :value (getf vote-info :user-id))
		  (<:input :type "hidden" :name "project_id" :value (getf vote-info :project-id))
		  (<:input :type "hidden" :name "manager_id" :value (getf vote-info :manager-id))
		  (<:input :type "submit" :value "Submit")))


(defun project-spon-form (project)
  (<:form :action (genurl 'sponsor/post) :method "post"
          "Project Name:" (getf project :name) (<:br)
		  "Description :" (getf project :descript)(<:br)
          "Sponsor Cost:" (<:input :type "text" :name "spon_cost")(<:br)
          (<:input :type "hidden" :name "project_id" :value (getf project :id))
		  (<:input :type "submit" :value "Submit")))

(defun project-apply-manager-form (project)
  (<:form :action (genurl 'apply-manager/post) :method "post"
		  "Project Name:" (getf project :name) (<:br)
		  "Description :" (getf project :descript)(<:br)
		  "Sponsor Cost:" (getf project :count-cost)(<:br)
		  (<:input :type "hidden" :name "project_id" :value (getf project :id))
		  (<:ul
			(<:li "RealName:" (<:input :type "text" :name "real_name"))(<:br)
			(<:li "PrivateID:" (<:input :type "text" :name "private_id")))
		  (<:input :type "submit" :value "Submit")))

(defun project-apply-contract-form (project)
  (<:form :action (genurl 'apply-contract/post) :method "post"
          "Project Name:" (getf project :name) (<:br)
          "Description :" (getf project :descript)(<:br)
          "Sponsor Cost:" (getf project :count-cost)(<:br)
          (<:input :type "hidden" :name "project_id" :value (getf project :id))
          (<:ul
            (<:li "OrgizeName:" (<:input :type "text" :name "orgize_name"))(<:br)
            (<:li "OrgizeDescript:" (<:input :type "text" :name "orgize_des"))
			(<:li "QuotedPrice:" (<:input :type "text" :name "quoted_price")))
          (<:input :type "submit" :value "Submit")))

(defun test-frame ()
  "Test some var"
  (<:div (logged-info "xdebug")))

(defun test-link-frame ()
  "Test Link"
  (<:div
	(list (<:a :href (genurl 'test-link :page-id 1) "Test link -page-id:1")
		  " "
		  (<:a :href (genurl 'test-link :page-id 0) "Test link -page-id:0")
		  )))

