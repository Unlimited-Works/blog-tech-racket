#lang racket

(require net/jwt
         racket/date)

(require "../dbal/user-dbal.rkt"
         "../config.rkt")

(provide (all-defined-out))

(define (user-login name password)
  (define pass (get-last-reviewed-password-from-phone name))
  (cond ((not pass)
         (hasheq 'success #f
                 'reason "用户不存在"))
        ((string=? pass password)
         (hasheq 'success #t
                 'data (hasheq 'loginName name
                               'jwt (encode/sign "HS256"
                                                 jwt-secret
                                                 #:iss "http://www.heqiying.com/"
                                                 #:sub name
                                                 #:exp (+ (current-seconds) 86400)
                                                 #:iat (current-seconds)))))
        (else
         (hasheq 'success #f
                 'reason "密码不正确"))))

;if headers doesn't contain jwt, return ""
;if jwt expires or is not valid, return #f
(define (get-user-from-header headers)
  (let/ec k
    (define jwt-header (assq 'jwt headers))
    (unless jwt-header
      (k ""))
    (define jwt
      (decode/verify (cdr jwt-header)
                     "HS256"
                     jwt-secret))
    (and jwt
         (> (date->seconds (expiration-date jwt))
            (current-seconds))
         (subject jwt))))

(define (change-password user current-password new-password)
  (cond ((not user)
         (hasheq 'success #f
                 'reason "用户不存在"))
        ;as the user has already logged in, assue his password exists
        ((string=? (get-last-reviewed-password-from-phone user)
                   current-password)
         (update-password user new-password)
         (hasheq 'success #t))
        (else
         (hasheq 'success #f
                 'reason "当前密码错误"))))

        
