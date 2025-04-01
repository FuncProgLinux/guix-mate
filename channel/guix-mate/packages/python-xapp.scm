(define-module (guix-mate packages python-xapp)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix deprecation)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system python)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages cinnamon)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-xyz))

(define-public python-xapp
  (package
    (name "python-xapp")
    (version "2.4.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/linuxmint/python3-xapp")
             (recursive? #f)
             (commit "master")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "06v84bvhhhx7lf7bsl2wdxh7vlkpb2fczjh6717b9jjr7xhvif8r"))))
    (native-inputs (list python-3 intltool glib gobject-introspection))
    (propagated-inputs (list python-configobj
                             python-pygobject
                             python-distutils-extra
                             python-setuptools
                             python-unidecode
                             python-pyinotify
                             python-pyxdg
                             python-xdg
                             python-xlib
                             python-setproctitle
                             libxapp
                             xdg-utils
                             python-pycairo))
    (build-system meson-build-system)
    (arguments
     (list
      #:imported-modules `((guix build python-build-system)
                           ,@%meson-build-system-modules)
      #:modules '((guix build utils)
                  (guix build meson-build-system)
                  ((guix build python-build-system)
                   #:prefix python:))
      #:tests? #t))
    (home-page "https://github.com/linuxmint/python3-xapp")
    (synopsis "Python 3 XApp library")
    (description "This package contains the Python 3 version of the library.")
    (license license:lgpl2.0+)))