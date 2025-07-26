(define-module (guix-mate packages mint-icons)
  #:use-module (guix)
  #:use-module (guix gexp)
  #:use-module (guix build utils)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system copy)
  #:use-module (guix git-download))

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

(define-public mint-y-icon-theme
  (package
    (name "mint-y-icon-theme")
    (version "1.8.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/linuxmint/mint-y-icons")
             (commit "1.8.4")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1vbm85jyn6w8c0bc9p0h0i3nx5m4i9hngyhdnyfnakp1bvv9bn3y"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan `(("usr/share/icons" "share/icons"))))
    (home-page "https://github.com/linuxmint/mint-y-icons")
    (synopsis "The Mint-Y icon theme")
    (description
     "A flat, colorful, and modern theme based on Paper and Moka.")
    (license (list license:gpl3+
                   license:cc-by-sa4.0))))

(define-public mint-l-icon-theme
  (package
    (name "mint-l-icon-theme")
    (version "1.7.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/linuxmint/mint-l-icons")
             (commit "master")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0bz0iqhrb7cybrfkhk583w2dq4dx3agba280f1c3ansv1m2szmp2"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan `(("usr/share/icons" "share/icons"))))
    (home-page "https://github.com/linuxmint/mint-l-icons")
    (synopsis "Mint-L icon theme")
    (description
     "A flat, colorful, and modern theme based on Paper and Moka.")
    (license (list license:gpl3+
                   license:cc-by-sa4.0))))


