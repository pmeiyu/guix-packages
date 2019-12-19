(define-module (meiyu packages linux-nonfree)
  #:use-module (gnu packages linux)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils))

;;; Linux kernel and firmware

(define-public linux-nonfree
  (package
    (inherit linux-libre)
    (name "linux-nonfree")
    (version "5.4.5")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://kernel.org"
                           "/linux/kernel/v" (version-major version) ".x/"
                           "linux-" version ".tar.xz"))
       (sha256
        (base32 "1h1ynb51gd4kiakqlkcc7vny45j2snbg4j985qf171mszckrz3jn"))))
    (home-page "https://www.kernel.org/")
    (synopsis "Linux kernel")
    (description "The Linux kernel.")))

(define-public linux-firmware-nonfree
  (package
    (name "linux-firmware-nonfree")
    (version "20191215")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url (string-append "https://git.kernel.org/pub/scm/linux/kernel/"
                                 "git/firmware/linux-firmware.git"))
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "01zwmgva2263ksssqhhi46jh5kzb6z1a4xs8agsb2mbwifxf84cl"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let* ((source (assoc-ref %build-inputs "source"))
                          (out (assoc-ref %outputs "out"))
                          (firmware (string-append out "/lib/firmware")))
                     (mkdir-p firmware)
                     (copy-recursively source firmware)))))
    (home-page "https://kernel.org/")
    (synopsis "Non-free Linux firmware")
    (description "Non-free firmware blobs for Linux kernel.")
    (license #f)))
