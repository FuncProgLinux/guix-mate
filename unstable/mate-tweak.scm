(define-module (guix-mate packages mate-tweak)
  #:use-module (gnu packages)
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

(define-public mate-tweak
  (package
    (name "mate-tweak")
    (version "22.10.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ubuntu-mate/mate-tweak")
             (recursive? #t)
             (commit "22.10.0")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "07kfc20mq1hrwd1xgh5f8lqd1v7hprvr357c5hg7716c5j08srvs"))))
    (build-system python-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          ;; sanity checks fail with a
          ;; FileNotFoundError: [Errno 2] No such file or directory: 'mate-tweak'
          ;; error. More research should be done about this issue
          (delete 'sanity-check)
          ;; Substitute non /usr paths until #95 is merged
          ;; upstream.
          ;; NOTE: Consider forking & merging patch
          ;; for this repository
          (add-after 'unpack 'substitute-hardcoded-paths
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((output (assoc-ref outputs "out")))
                (substitute* (find-files "." "\\.py$")
                  (("/usr/lib/mate-tweak")
                   (string-append output "/lib/mate-tweak")))
                (substitute* "setup.py"
                  (("\\{prefix\\}/")
                   ""))))))))
    (native-inputs `(("python-wrapper" ,python-wrapper)
                     ("intltool" ,intltool)
                     ("python-distutils-extra" ,python-distutils-extra)
                     ("gobject-introspection" ,gobject-introspection)))
    (inputs (list gtk+
                  libnotify
                  glib
                  gdk-pixbuf
                  mate-desktop
                  mate-applets
                  mate-panel
                  marco
                  dconf
                  gsettings-desktop-schemas
                  libmatekbd
                  mate-session-manager
                  python-pygobject
                  python-configobj
                  python-psutil
                  python-distro
                  python-setproctitle))
    (home-page "https://github.com/ubuntu-mate/mate-tweak")
    (synopsis "Tweak tool for the MATE Desktop.")
    (description
     "Configuration tool for MATE Desktop settings not exposed
by the Mate Control Center, such as panel layouts, desktop icons show & hide
options and window manager tuning.")
    (license license:gpl2+)))

mate-tweak
