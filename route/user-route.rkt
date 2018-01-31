#lang racket

(require net/jwt)

(require "../service/user-service.rkt"
         "../my-spin.rkt")

(provide (all-defined-out))

(define (user-route)
  (json-post "/user"
             (lambda (header _ req)
               (define user (get-user-from-header header))
               (define current-password (hash-ref req 'current-password))
               (define new-password (hash-ref req 'new-password))
               (change-password user current-password new-password))))



               
