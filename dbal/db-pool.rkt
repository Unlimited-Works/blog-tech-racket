#lang racket

(require db)

(require "../config.rkt")

(define (connect)
  (keyword-apply mysql-connect
                 '(#:database #:password #:server #:user)
                 mysql-server
                 '()))

(define db-pool
  (connection-pool connect))

(provide db-pool)

   