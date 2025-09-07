(define-module (guix-mate packages mint-themes)
  #:use-module (guix)
  #:use-module (guix gexp)
  #:use-module (guix build utils)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system copy)
  #:use-module (guix git-download)
  #:use-module (gnu packages image)
  #:use-module (gnu packages inkscape)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz))

(define-public mint-themes
  (package
    (name "mint-themes")
    (version "2.3.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/linuxmint/mint-themes")
             (commit "2.3.2")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "01py088r52qksz78va2ih7ik8ysckmx9a232dg27qy718pdw9mpp"))))
    (build-system copy-build-system)
    (inputs (list inkscape optipng))
    (native-inputs (list python python-wrapper python-libsass))
    (arguments
     (list
      #:install-plan
      #~'(("usr/share/themes" "share/themes"))
      #:modules '((guix build copy-build-system)
                  (guix build utils))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'generate-themes
            (lambda _
              (substitute* "generate-themes.py"
                (("./build-themes.py")
                 "python3 build-themes.py"))
              (substitute* "update-variations.py"
                (("./render-assets.sh")
                 "bash render-assets.sh"))
              (substitute* "src/Mint-Y/build-themes.py"
                (("./render-assets.sh")
                 "bash render-assets.sh"))
              (substitute* "src/Mint-Y/build-themes.py"
                (("./render-dark-assets.sh")
                 "bash render-dark-assets.sh"))
              ;; Invoking "make" would be the same as this
              (invoke "python3" "generate-themes.py"))))))
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
