(define-module (guix-mate packages mintdesktop)
  #:use-module (guix)
  #:use-module (guix gexp)
  #:use-module (guix build utils)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix build-system copy)
  #:use-module (guix git-download)
  #:use-module (gnu packages mate)
  #:use-module (gnu packages cinnamon)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build))

(define-public mintdesktop
  (package
    (name "mintdesktop")
    (version "3.7.9")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/linuxmint/mintdesktop")
             (recursive? #t)
             (commit "master")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "13dsiqjsc1573s11r02cp6wlnb9cqlmqaz3nm6hvimbplk7sl2kr"))))
    (native-inputs (list python-3 intltool libxapp glib gobject-introspection))
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
                             mate-menus
                             mate-panel
                             xdg-utils
                             python-pycairo))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan
      #~'(("etc/X11/Xsession.d/" "/etc/X11/Xsession.d/")
          ("etc/compizconfig/" "/etc/compizconfig/")

          ("usr/bin/mintdesktop" "bin/mintdesktop")
          ("usr/bin/compiz-reset-profile" "bin/compiz-reset-profile")
          ("usr/bin/window-manager-launcher" "bin/window-manager-launcher")
          ("usr/bin/wm-detect" "/bin/wm-detect")
          ("usr/bin/wm-recovery" "/bin/wm-recovery")
          ("usr/bin/xfce-autostart-wm" "/bin/xfce-autostart-wm")

          ("usr/lib/linuxmint/mintdesktop/mintdesktop.py"
           "/lib/linuxmint/mintdesktop/mintdesktop.py")

          ("usr/share/applications/mint-window-manager.desktop"
           "/share/applications/mint-window-manager.desktop")
          ("usr/share/applications/mintdesktop.desktop"
           "/share/applications/mintdesktop.desktop")

          ("usr/share/help" "share/help")

          ("usr/share/linuxmint/mintdesktop/main.ui"
           "/share/linuxmint/mintdesktop/main.ui")
          ("usr/share/linuxmint/mintdesktop/mint.dconf"
           "/share/linuxmint/mintdesktop/mint.dconf")
          ("usr/share/linuxmint/mintdesktop/xfce-autostart-wm.desktop"
           "/share/linuxmint/mintdesktop/xfce-autostart-wm.desktop"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'fixup-paths
            (lambda _
              
              (define* (patch-bash-shebangs #:key (file ""))
                (substitute* file
                  (("#!/bin/bash")
                   (string-append "#!"
                                  (which "bash")))))

              (define* (patch-python3-shebangs #:key (file ""))
                (substitute* file
                  (("#!/usr/bin/python3")
                   (string-append "#!"
                                  (which "python3")))))

              (define* (patch-usrlib-to-lib #:key (file ""))
                (substitute* file
                  (("/usr/lib/")
                   (string-append #$output "/lib/"))))

              (define* (patch-usrbin-to-bin #:key (file ""))
                (substitute* file
                  (("/usr/bin/")
                   (string-append #$output "/bin/"))))

              (define* (patch-usrshare-to-share #:key (file ""))
                (substitute* file
                  (("/usr/share/")
                   (string-append #$output "/share/"))))

              (define* (patch-usr-to-guix #:key (file ""))
                (patch-usrlib-to-lib #:file file)
                (patch-usrbin-to-bin #:file file)
                (patch-usrshare-to-share #:file file))

              (patch-bash-shebangs #:file "usr/bin/compiz-reset-profile")
              (patch-usr-to-guix #:file "usr/bin/compiz-reset-profile")

              (patch-python3-shebangs #:file "usr/bin/mintdesktop")
              (patch-usr-to-guix #:file "usr/bin/mintdesktop")

              (patch-python3-shebangs #:file "usr/bin/window-manager-launcher")
              (patch-usr-to-guix #:file "usr/bin/window-manager-launcher")

              (patch-python3-shebangs #:file "usr/bin/wm-detect")

              (patch-python3-shebangs #:file "usr/bin/wm-recovery")

              (patch-python3-shebangs #:file "usr/bin/xfce-autostart-wm")

              (patch-python3-shebangs #:file
               "usr/lib/linuxmint/mintdesktop/mintdesktop.py")
              (patch-usr-to-guix #:file
               "usr/lib/linuxmint/mintdesktop/mintdesktop.py"))))
      #:tests? #t))
    (home-page "https://github.com/linuxmint/mintdesktop")
    (synopsis "Desktop configuration tool for MATE and Xfce")
    (description
     "Mintdesktop provides some additional settings for the MATE desktop environment and the ability to switch window managers.")
    (license license:gpl2+)))
