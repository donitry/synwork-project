;;;;pg-datastore.lisp
;;;
;;;pgsql
;;;
(in-package #:synwork-project.pg-datastore)

(defvar *page-max-per*)

(defclass pg-datastore ()
  ((conection-spec :initarg :connection-spec
				   :accessor connection-spec)))

(defparameter *db*
  (make-instance 'pg-datastore
				 :connection-spec '("synwork" "sexdon" "zxc123.com" "localhost")))

(defclass db-project ()
  ((id :col-type serial :reader project-id)
   (name :col-type string :reader project-name :initarg :name)
   (descript :col-type string :col-default "No Descript" :reader project-des :initarg :descript)
   (submitter-id :col-type integer :col-default 0 :reader project-spon-id :initarg :submitter-id)
   (count-cost :col-type integer :col-default 0 :reader project-count-cost :initarg :count-cost :accessor count-cost)
   (manager-id :col-type integer :col-default 0 :reader project-manager-id :initarg :manager-id)
   (submit-date :col-type date :col-default (now) :reader project-submit-date :initarg :submit-date)
   (checked :col-type integer :col-default 0 :reader project-checked :initarg :checked))
  (:metaclass dao-class)
  (:keys id))

(defclass db-sponsor ()
  ((id :col-type serial :reader spon-id)
   (pro-id :col-type integer :reader project-id :initarg :pro-id)
   (user-id :col-type integer :reader user-info-id :initarg :user-id)
   (spon-cost :col-type integer :col-default 0 :reader sponsor-cost :initarg :spon-cost))
  (:metaclass dao-class)
  (:keys id))

(defclass db-manager ()
  ((id :col-type serial :reader manager-id)
   (user-id :col-type integer :reader user-info-id :initarg :user-id)
   (user-name :col-type string :reader apply-user-name :initarg :user-name :accessor user-name)
   (user-private-id :col-type string :reader apply-user-private-id :initarg :user-private-id :accessor user-private-id))
  (:metaclass dao-class)
  (:keys id))

(defclass db-contract ()
  ((id :col-type serial :reader contract-id)
   (user-id :col-type integer :reader user-info-id :initarg :user-id)
   (user-name :col-type string :reader apply-user-name :initarg :user-name :accessor user-name))
  (:metaclass dao-class)
  (:keys id))

(defclass db-apply-manager ()
  ((id :col-type serial :reader apply-manager-id)
   (pro-id :col-type integer :reader apply-project-id :initarg :pro-id :accessor pro-id)
   (manager-id :col-type integer :reader apply-manager-id :initarg :manager-id :accessor manager-id)
   (vote-count :col-type integer :reader apply-vote-count :initarg :vote-count :accessor vote-count))
  (:metaclass dao-class)
  (:keys id))

(defclass db-apply-contract ()
  ((id :col-type serial :reader apply-contract-id)
   (pro-id :col-type integer :reader project-id :initarg :pro-id :accessor pro-id)
   (orgize-name :col-type string :reader apply-orgize-name :initarg :orgize-name :accessor orgize-name)
   (orgize-descript :col-type string :reader apply-orgize-descript :initarg :orgize-descript :accessor orgize-descript)
   (quoted-price :col-type integer :reader apply-quoted-price :initarg :quoted-price :accessor quoted-price))
  (:metaclass dao-class)
  (:keys id))

(defmethod datastore-init ((datastore pg-datastore))
  (with-connection (connection-spec datastore)
	(unless (table-exists-p 'db-project)
	  (execute (dao-table-definition 'db-project)))
	(unless (table-exists-p 'db-sponsor)
	  (execute (dao-table-definition 'db-sponsor)))
	(unless (table-exists-p 'db-apply-manager)
	  (execute (dao-table-definition 'db-apply-manager)))
	(unless (table-exists-p 'db-apply-contract)
	  (execute (dao-table-definition 'db-apply-contract)))
	))

(defmethod datastore-count-project ((datastore pg-datastore) page-max-per)
  (with-connection (connection-spec datastore)
	(setf *page-max-per* page-max-per)
	(let* ((records (query (:select (:count '*) :from 'db-project) :single))
		   (page-count (abs (floor (/ records page-max-per)))))
	  page-count)))

(defmethod datastore-find-project-by-name ((datastore pg-datastore) project-name)
  (with-connection (connection-spec datastore)
	(query (:select :* :from 'db-project
					:where (:= 'name project-name))
		   :plist)))

(defmethod datastore-find-project-by-id ((datastore pg-datastore) project-id)
  (with-connection (connection-spec datastore)
    (query (:select :* :from 'db-project
                    :where (:= 'id project-id))
            :plist)))

(defmethod datastore-create-project ((datastore pg-datastore) project-info)
  (with-connection (connection-spec datastore)
	(unless (datastore-find-project-by-name datastore (getf project-info :project-name))
	  (when
	  	(save-dao
	  	  (make-instance 'db-project
	  	  				 :name (getf project-info :project-name)
	  	  				 :descript (getf project-info :project-des)
	  	  				 :submitter-id (getf project-info :submitter-id)
	  	  				 ))
		;(query (:select (:currval 'db_project_id_seq))
		;	   :single)
		;(query (:insert-into 'db-project :set 'name "tedtt" 'descript "descriptll"))
		;(sequence-next 'DB-PROJECT-ID-SEQ)
		(query (:select (:currval "db_project_id_seq"))
			   :single)
		;(list-sequences t)
		))))

(defun show-project-list (datastore projects project-name)
  (loop
	for project in projects
	for id = (getf project :id)
	collect (list* :project-name (getf project :name)
				   :project-desc (getf project :descript)
				   project)))


(defun get-all-projects/internal (page-id &optional project-name)
  (query (:limit (:select :* :from 'db-project) *page-max-per* (* *page-max-per* page-id))
  		 :plists))
  

(defmethod datastore-get-all-projects ((datastore pg-datastore) page-id &optional project-name)
  (with-connection (connection-spec datastore)
	(show-project-list datastore
					   (get-all-projects/internal page-id)
					   (or project-name ""))))

(defmethod datastore-project-sponsor ((datastore pg-datastore) project-id user-id spon-cost)
  (with-connection (connection-spec datastore)
    (when (datastore-find-project-by-id datastore project-id)
      (when
        (save-dao
          (make-instance 'db-sponsor
                         :pro-id project-id
                         :user-id user-id
                         :spon-cost spon-cost
                         ))
		(datastore-project-update-spon-cost datastore project-id)
        (query (:select (:currval "db_sponsor_id_seq"))
               :single)
      ))))

(defmethod datastore-project-update-spon-cost ((datastore pg-datastore) project-id)
  (with-connection (connection-spec datastore)
	(when (datastore-find-project-by-id datastore project-id)
	  (let* ((spon-cost (query (:select (:sum 'spon-cost) :from 'db-sponsor
										                  :where (:= 'pro-id project-id))
								:single))
			 (cost-project (get-dao 'db-project project-id)))
		;(is (not (null cost-project)))
		(setf (count-cost cost-project) spon-cost)
		(update-dao cost-project))
	  )))

(defmethod datastore-project-apply-manager ((datastore pg-datastore) project-id user-info)
  (with-connection (connection-spec datastore)
	(when (datastore-find-project-by-id datastore project-id)
      (when
	    (save-dao
          (make-instance 'db-apply-manager
                         :pro-id project-id
                         :user-name (getf user-info :user-name)
                         :user-real-name (getf user-info :real-name)
						 :user-private-id (getf user-info :private-id)
                         ))
         (query (:select (:currval "db_apply_manager_id_seq"))
               :single)
      ))))

(defmethod datastore-project-apply-contract ((datastore pg-datastore) project-id contract-info)
  (with-connection (connection-spec datastore)
	(when (datastore-find-project-by-id datastore project-id)
	  (when
		(save-dao
		  (make-instance 'db-apply-contract
						 :pro-id project-id
						 :orgize-name (getf contract-info :orgize-name)
						 :orgize-descript (getf contract-info :orgize-des)
						 :quoted-price (getf contract-info :quoted-price)
						 ))
		(query (:select (:currval "db_apply_contract_id_seq"))
			   :single)
		))))

