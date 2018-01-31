#lang racket

(require net/jwt)

(require "../service/user-service.rkt"
         "../my-spin.rkt")

(provide (all-defined-out))

(define (login-route)
  (json-post "/login"
             (lambda (header binding req)
               (define name (hash-ref req 'name))
               (define password (hash-ref req 'password))
               (user-login name password))))



               
