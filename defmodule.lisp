;;;; defmodule.lisp

(restas:define-policy datastore
  (:interface-package #:synwork-project.policy.datastore)
  (:interface-method-template "DATASTORE-~A")
  (:internal-package #:synwork-project.datastore)

  (define-method init ()
	"initiate the datastore")

  (define-method find-project-by-name (project-name)
	"Find the project by project-name")

  (define-method find-project-by-id (project-id)
    "Find the project by project-id")

  (define-method create-project (project-info)
	"Create project by user")

  (define-method get-all-projects (page-id &optional project-name)
	"Show projects list")

  (define-method count-project (page-max-per)
	"Count projects for page")

  (define-method project-sponsor (project-id user-id spon-cost)
	"Sponsor cost")

  (define-method project-update-spon-cost (project-id)
	"Update cost count by id")

  (define-method project-apply-manager (project-id user-info)
    "Save user apply manager by project-id")

  (define-method project-apply-contract (project-id contract-info)
	"Save user apply contract by project-id")

  (define-method t-list-project (beg counts)
	"List projects start beg , show them by counts"))


(restas:define-module #:synwork-project
  (:use #:cl #:restas #:synwork-project.datastore #:synwork-auth)
  (:export #:*redirect-route-project*
		   #:init-datastore-project))

(defpackage #:synwork-project.redis-datastore
  (:use #:cl #:redis #:synwork-project.policy.datastore)
  (:export #:redis-datastore))

(defpackage #:synwork-project.pg-datastore
  (:use #:cl #:postmodern #:synwork-project.policy.datastore)
  (:export #:pg-datastore))

(in-package #:synwork-project)

(defvar *page-all-count*)
(defparameter *page-max-per* 20)

(defparameter *template-directory*
  (merge-pathnames #P"templates/" synwork-project-config:*base-directory*))

(defparameter *static-directory*
  (merge-pathnames #P"static/" synwork-project-config:*base-directory*))

(sexml:with-compiletime-active-layers
  (sexml:standard-sexml sexml:xml-doctype)
  (sexml:support-dtd
	(merge-pathnames "html5.dtd" (asdf:system-source-directory "sexml"))
	:<))

(mount-module -static- (#:restas.directory-publisher)
  (:url "static")
  (restas.directory-publisher:*directory* *static-directory*))


