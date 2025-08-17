(define-module (guix-mate packages ayatana)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages attr)
  #:use-module (gnu packages code)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages pkg-config))

(define-public ayatana-ido
  (package
    (name "ayatana-ido")
    (version "0.10.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/AyatanaIndicators/ayatana-ido")
             (commit "0.10.4")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1li6pzh9xvl66nlixzpwqsn8aaa0kj0azhzjan4cd65f7nnjpq99"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:out-of-source? #t
      #:imported-modules `(,@%cmake-build-system-modules (guix build
                                                          glib-or-gtk-build-system))
      #:modules '((guix build cmake-build-system)
                  ((guix build glib-or-gtk-build-system)
                   #:prefix glib-or-gtk:)
                  (guix build utils))))
    (native-inputs (list cmake gobject-introspection vala lcov pkg-config))
    (inputs (list gtk+
                  `(,glib "bin") gtk-doc))
    (home-page "https://github.com/AyatanaIndicators")
    (synopsis "Ayatana Display Indicator Objects")
    (description
     "Ayatana IDO provides custom GTK menu widgets for
Ayatana System Indicators. This is a base dependency for all indicators.")
    (license (list license:lgpl2.0+ license:lgpl3+))))
