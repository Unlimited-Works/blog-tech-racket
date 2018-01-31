#lang racket

(require (planet dmac/spin)
         web-server/servlet
         json)

(require "dbal/access-dbal.rkt")

(provide (all-defined-out))

(define (json-post path handler)
  (post path
        (lambda (req)
          (log-info "POST ~a" path)
          (insert-access-record req)
          `(200 ()
                ,(jsexpr->string
                  (handler (request-headers req)
                           (request-bindings req)
                           (bytes->jsexpr (request-post-data/raw req))))))))

(define (json-get path handler)
  (get path
       (lambda (req)
          (log-info "GET ~a" path)
          (insert-access-record req)
          `(200 ()
                ,(jsexpr->string
                  (handler (request-headers req)
                           (request-bindings req)))))))
