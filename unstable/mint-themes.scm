(define-module (guix-mate packages mint-themes)
  #:use-module (guix)
  #:use-module (guix gexp)
  #:use-module (guix build utils)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system copy)
  #:use-module (guix git-download))

(define-public mint-themes
  (package
    (name "mint-themes")
    (version "2.3.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/linuxmint/mint-themes")
             (commit "2.3.1")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "04ray600vgrr9b6kk4yw6l90zjmv4rx2vrm0a914qaasx5rrs5x0"))))
    (build-system copy-build-system)
    (native-inputs (list python sassc))
    (arguments
     `(#:install-plan `(("files/usr/share/themes" "share/themes"))))
    (home-page "https://github.com/linuxmint/mint-themes")
    (synopsis "Linux Mint themes for GTK Desktops")
    (description
     "This package contains the collection of GTK desktop themes made
by the Linux Mint distribution. It provides the following themes:

@enumerate
@item Mint-X
@item Mint-X-Colours (Yellow, Purple, Aqua, Etc)
@item Mint-Y
@item Mint-Y-Colours (Orange, Pink,  Purple, Etc)
@end enumerate

The themes also come with Mint-X-compact for the XFCE Desktop xfwm4.")
    (license license:gpl3+)))

mint-themes
