(define-module (guix-mate packages mint-icons)
  #:use-module (guix)
  #:use-module (guix gexp)
  #:use-module (guix build utils)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system copy)
  #:use-module (guix git-download))

;; Mint-X is the base for both Mint-Y and Mint-L themes.
(define-public mint-x-icon-theme
  (package
    (name "mint-x-icon-theme")
    (version "1.7.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/linuxmint/mint-x-icons")
             (commit "1.7.3")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1blm42j1z8fizc95kbw50la66gpwzsyivinxl6i0x1bkz3ql1cxi"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan `(("usr/share/icons" "share/icons"))))
    (home-page "https://github.com/linuxmint/mint-x-icons")
    (synopsis "Icon theme for Linux Mint")
    (description
     "A mint/metal theme based on mintified versions of Clearlooks Revamp, Elementary and Faenza.")
    (license license:gpl3+)))
