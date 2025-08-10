(define-module (guix-mate packages python-caja)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build utils)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (gnu packages mate)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages))

(define-public python-caja
  (package
    (name "python-caja")
    (version "1.28.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://mate/"
                           (version-major+minor version)
                           "/"
                           "python-caja-"
                           version
                           ".tar.xz"))
       (sha256
        (base32 "1ml0yrkbly1mz5gmz1wynn3zff5900szncc4rk83xqyzvcww4mmh"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags (list (string-append "--with-cajadir="
                                              (assoc-ref %outputs "out")
                                              "/lib/caja/extensions-2.0/"))))
    (native-inputs `(("pkg-config" ,pkg-config)
                     ("gettext" ,gettext-minimal)
                     ("python-wrapper" ,python-wrapper)))
    (inputs (list caja gtk+ python-pygobject))
    (home-page "https://mate-desktop.org/")
    (synopsis "Python bindings for Caja components")
    (description "These are unstable bindings for the caja extension library.")
    (license license:gpl2+)))
