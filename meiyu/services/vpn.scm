(define-module (meiyu services vpn)
  #:use-module (gnu packages vpn)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guix packages)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:use-module (ice-9 match)
  #:export (tinc-configuration
            tinc-configuration?
            tinc-configuration-tinc
            tinc-configuration-net-name
            tinc-service-type))

;;;
;;; tinc
;;;

(define-record-type* <tinc-configuration>
  tinc-configuration make-tinc-configuration
  tinc-configuration?
  (tinc     tinc-configuration-tinc
            (default tinc))
  (net-name tinc-configuration-net-name
            (default ".")))

(define (tinc-activation config)
  "Return the activation gexp for CONFIG."
  (with-imported-modules '((guix build utils))
    #~(begin
        (use-modules (guix build utils))

        (let ((tinc #$(tinc-configuration-tinc config))
              (net-name #$(tinc-configuration-net-name config)))
          (if (string=? net-name ".")
              (unless (directory-exists? "/etc/tinc")
                (mkdir-p "/etc/tinc")
                (invoke (string-append tinc "/sbin/tincd") "-K"))
              (unless (directory-exists? (string-append "/etc/tinc/" net-name))
                (mkdir-p (string-append "/etc/tinc/" net-name))
                (invoke (string-append tinc "/sbin/tincd")
                        "-n" net-name "-K")))))))

(define tinc-shepherd-service
  (match-lambda
    (($ <tinc-configuration> tinc net-name)
     (shepherd-service
      (documentation "Tinc VPN daemon.")
      (provision '(tinc))
      (requirement '(networking))
      (start #~(make-forkexec-constructor
                '(#$(file-append tinc "/sbin/tincd") "-D" "-n" #$net-name)))
      (stop #~(make-kill-destructor))))))

(define tinc-service-type
  (service-type
   (name 'tinc)
   (description "Run the tinc VPN daemon.")
   (extensions
    (list (service-extension activation-service-type
                             tinc-activation)
          (service-extension shepherd-root-service-type
                             (compose list tinc-shepherd-service))))
   (default-value (tinc-configuration))))
