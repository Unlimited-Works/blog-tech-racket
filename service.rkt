#lang racket

(require (planet dmac/spin))

(require "route/login-route.rkt"
         "route/user-route.rkt")

(login-route)
(user-route)

(run #:listen-ip "0.0.0.0"
     #:port 7100)
