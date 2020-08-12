(define-module (meiyu packages linux-nonfree)
  #:use-module (gnu packages linux)
  #:use-module (guix build-system copy)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils))

;;; Linux kernel and firmware

(define-public linux-nonfree
  (package
    (inherit linux-libre)
    (name "linux-nonfree")
    (version "5.8.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://kernel.org"
                           "/linux/kernel/v" (version-major version) ".x/"
                           "linux-" version ".tar.xz"))
       (sha256
        (base32 "09574qbcrncb34dx9pd65iqs06758zim4nkncnjzmxwgjgza9lpq"))))
    (home-page "https://www.kernel.org/")
    (synopsis "Linux kernel")
    (description "The Linux kernel.")))

(define-public linux-firmware-nonfree
  (package
    (name "linux-firmware-nonfree")
    (version "20200421")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url (string-append "https://git.kernel.org/pub/scm/linux/kernel/"
                                 "git/firmware/linux-firmware.git"))
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "13q3gnh2cmf91qg8qrdhxah6d1j8cc1g587lz712ryxx54w06rk8"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan '(("./" "lib/firmware/"))
       #:phases (modify-phases %standard-phases
                  (delete 'strip)
                  (delete 'validate-runpath))))
    (home-page "https://kernel.org/")
    (synopsis "Non-free Linux firmware")
    (description "Non-free firmware blobs for Linux kernel.")
    (license #f)))
