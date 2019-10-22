(define-module (meiyu packages gcc)
  #:use-module (guix packages))

(define-public gcc
  (package
    (inherit (@@ (gnu packages gcc) gcc))
    (properties `((hidden? . #f)
                  ,@(package-properties (@@ (gnu packages gcc) gcc))))))
