#lang racket

(require db
         racket/date
         web-server/http/request-structs
         web-server/http/bindings
         net/url-string)
(require "db-pool.rkt"
         "../service/user-service.rkt")

(provide insert-access-record)

(date-display-format 'iso-8601)

(define (insert-access-record req)
  (query-exec (connection-pool-lease db-pool)
              "insert into access_records (time, uri, method, who, access_records.from) values (?, ?, ?, ?, ?)"
              (date->string (current-date) #t)
              (url->string (request-uri req))
              (request-method req)
              (or (get-user-from-header (request-headers req)) "")
              (request-host-ip req)))
