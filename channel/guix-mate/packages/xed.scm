(define-module (guix-mate packages xed)
  #:use-module (guix)
  #:use-module (guix gexp)
  #:use-module (guix build utils)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (guix build-system python)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system copy)
  #:use-module (guix git-download)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages mate)
  #:use-module (gnu packages libcanberra)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages cinnamon)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build))

(define-public xed
  (package
    (name "xed")
    (version "3.8.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/linuxmint/xed")
             (recursive? #t)
             (commit "master")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ma8gfirrkjvlg29cnk7slipvsc65l17qw9kfn8a16sgm6ihw81d"))))
    (native-inputs `(("gettext-minimal" ,gettext-minimal)
                     ("gobject-introspection" ,gobject-introspection)
                     ("itstool" ,itstool)
                     ("desktop-file-utils" ,desktop-file-utils)
                     ("gspell" ,gspell)
                     ("gtk:bin" ,gtk)
                     ("glib:bin" ,glib)
                     ("gtk-doc" ,gtk-doc/stable)
                     ("intltool" ,intltool)
                     ;; xed still uses the 1.x version of libpeas
                     ("libpeas@1" ,libpeas)
                     ;; Same with gtksourceview
                     ("gtksourceview@4" ,gtksourceview)
                     ("libtool" ,libtool)
                     ("libcanberra" ,libcanberra)
                     ("pkg-config" ,pkg-config)
                     ("yelp-tools" ,yelp-tools)
                     ("libxapp" ,libxapp)))
    (inputs (list at-spi2-core
                  cairo
                  glib
                  gtk+
                  gtksourceview-4
                  gspell
                  (list glib "bin")
                  libgnomekbd
                  libxkbfile
                  python-3
                  gdk-pixbuf
                  libx11
                  libpeas
                  libsm
                  libxml2
                  libice
                  packagekit
                  pango
                  scrollkeeper
                  startup-notification))
    (build-system meson-build-system)
    (arguments
     (list
      #:imported-modules `((guix build python-build-system)
                           ,@%meson-build-system-modules)
      #:modules '((guix build utils)
                  (guix build meson-build-system)
                  ((guix build python-build-system)
                   #:prefix python:))
      #:glib-or-gtk? #t

      ;; For some reason tests make the package installation fail.
      ;; these will remain disabled for now.
      #:tests? #f))
    (home-page "https://github.com/linuxmint/xed")
    (synopsis "xed is a small and lightweight text editor.")
    (description
     "xed supports most standard editing features, plus several not found in your average text editor (plugins being the most notable of these).")
    (license license:gpl2+)))
