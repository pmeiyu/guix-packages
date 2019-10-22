(define-module (meiyu services dns)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guix packages)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:use-module (ice-9 match)
  #:use-module (meiyu packages dns)
  #:export (dnscrypt-proxy-configuration
            dnscrypt-proxy-configuration?
            dnscrypt-proxy-configuration-package
            dnscrypt-proxy-configuration-config-file
            dnscrypt-proxy-configuration-use-syslog?
            dnscrypt-proxy-service-type))

;;;
;;; dnscrypt-proxy
;;;

(define-record-type* <dnscrypt-proxy-configuration>
  dnscrypt-proxy-configuration make-dnscrypt-proxy-configuration
  dnscrypt-proxy-configuration?
  (package     dnscrypt-proxy-configuration-package
               (default dnscrypt-proxy))
  (config-file dnscrypt-proxy-configuration-config-file
               (default "/etc/dnscrypt-proxy/dnscrypt-proxy.toml"))
  (use-syslog? dnscrypt-proxy-configuration-use-syslog?
               (default #t)))

(define dnscrypt-proxy-shepherd-service
  (match-lambda
    (($ <dnscrypt-proxy-configuration> package
                                       config-file
                                       use-syslog?)
     (shepherd-service
      (documentation "Dnscrypt-proxy server.")
      (provision '(dnscrypt-proxy dns))
      (requirement (if use-syslog?
                       '(networking syslogd)
                       '(networking)))
      (start #~(make-forkexec-constructor
                '(#$(file-append package "/bin/dnscrypt-proxy")
                  "-config" #$config-file)))
      (stop #~(make-kill-destructor))))))

(define dnscrypt-proxy-service-type
  (service-type
   (name 'dnscrypt-proxy)
   (description "Run the dnscrypt-proxy server.")
   (extensions
    (list (service-extension shepherd-root-service-type
                             (compose list dnscrypt-proxy-shepherd-service))))
   (default-value (dnscrypt-proxy-configuration))))
