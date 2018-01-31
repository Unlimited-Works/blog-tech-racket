#lang racket

(require db)
(require "db-pool.rkt")

(provide (all-defined-out))

(define (get-last-reviewed-password-from-phone phone)
  (define ep
    (query-rows (connection-pool-lease db-pool)
                "select id, password from investors where cellphone = ? and review_state = 2"
                phone))
  (if (null? ep)
      #f
      (vector-ref (car
                   (sort ep >
                         #:key (lambda (v) (vector-ref v 0))))
                  1)))

(define (update-password phone new)
  (query-exec (connection-pool-lease db-pool)
              "update investors set password = ? where cellphone = ?"
              new phone))
