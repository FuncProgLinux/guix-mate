(define-module (guix-mate packages mate-menu)
  #:use-module (gnu packages)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages mate)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix build utils)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define-public mate-menu
  (package
    (name "mate-menu")
    (version "22.04.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ubuntu-mate/mate-menu")
             (recursive? #f)
             (commit "master")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0zd1gxsrgdhjxc56hiv63hpmrgbhijlc8yhq35sqgm0rar67sm9g"))))
    (build-system python-build-system)
    (arguments
     (list
      #:imported-modules `((guix build glib-or-gtk-build-system)
                           ,@%python-build-system-modules)
      #:modules '((guix build python-build-system)
                  ((guix build glib-or-gtk-build-system)
                   #:prefix glib-or-gtk:
                   #:select (glib-or-gtk-build))
                  (guix build utils))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'check)
          (add-after 'unpack 'substitute-hardcoded-paths
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((output (assoc-ref outputs "out")))
                ;; Substitute /usr paths in all .py
                ;; files.
                (substitute* (find-files "." "\\.py$")
                  (("/usr/share/")
                   (string-append output "/share/")))

                (substitute* (find-files "." "\\.py$")
                  (("/usr/lib/")
                   (string-append output "/lib/")))

                (substitute* "mate-menu"
                  (("'/','usr','lib','mate-menu','mate-menu.py'")
                   (string-append "'" output
                                  "','lib','mate-menu','mate-menu.py'"))))))
          (add-after 'wrap 'gi-wrap
            (lambda _
              (let ((prog (string-append #$output "/bin/mate-menu")))
                (wrap-program prog
                  `("GI_TYPELIB_PATH" =
                    (,(getenv "GI_TYPELIB_PATH"))))))))))
    (native-inputs `(("python-wrapper" ,python-wrapper)
                     ("intltool" ,intltool)
                     ("python-distutils-extra" ,python-distutils-extra)
                     ("gobject-introspection" ,gobject-introspection)))
    (inputs (list gtk+
                  mate-menus
                  mate-panel
                  python-configobj
                  python-pygobject
                  python-pyinotify
                  python-pyxdg
                  python-xdg
                  python-xlib
                  python-pycairo
                  python-setproctitle))
    (home-page "https://github.com/ubuntu-mate/mate-menu")
    (synopsis "An Advanced Menu for the MATE Desktop.")
    (description "An advanced menu for MATE. Ported from Linux Mint by the
Ubuntu MATE project.")
    (license license:gpl2+)))
