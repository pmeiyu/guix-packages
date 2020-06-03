(define-module (meiyu packages dns)
  #:use-module (gnu packages)
  #:use-module (gnu packages golang)
  #:use-module (guix build-system go)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils))

;; TODO: Remove bundled vendor dependencies.
(define-public dnscrypt-proxy
  (package
    (name "dnscrypt-proxy")
    (version "2.0.42")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/DNSCrypt/dnscrypt-proxy.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1v4n0pkwcilxm4mnj4fsd4gf8pficjj40jnmfkiwl7ngznjxwkyw"))))
    (build-system go-build-system)
    (arguments
     `(#:import-path "github.com/jedisct1/dnscrypt-proxy/dnscrypt-proxy"
       #:unpack-path "github.com/jedisct1/dnscrypt-proxy"
       #:install-source? #f))
    (inputs
     `(("go-golang-org-x-crypto" ,go-golang-org-x-crypto)
       ("go-golang-org-x-net" ,go-golang-org-x-net)
       ("go-golang-org-x-sys" ,go-golang-org-x-sys)
       ("go-golang-org-x-text" ,go-golang-org-x-text)))
    (home-page "https://dnscrypt.info/")
    (synopsis "Secure and flexible DNS proxy")
    (description "@command{dnscrypt-proxy} is a flexible DNS proxy, with
support for modern encrypted DNS protocols such as DNSCrypt v2 and
DNS-over-HTTPS.")
    (license license:isc)))
