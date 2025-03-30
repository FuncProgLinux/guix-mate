(define-module (guix-mate packages mintmenu)
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

(define-public mintmenu
  (package
    (name "mintmenu")
    (version "6.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/linuxmint/mintmenu")
             (recursive? #t)
             (commit "master")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0ndaijsx5qi2qxisxxlhw02a9yyzp6j7ib9gzw1fgalsi79273ch"))
       (patches (parameterize ((%patch-path (map (lambda (directory)
                                                   (string-append directory
                                                    "/guix-mate/packages/patches"))
                                                 %load-path)))
                  (search-patches "0001-Fake-apt-library-output-for-now.patch")))))
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
                             mate-menus
                             mate-panel
                             xdg-utils
                             python-pycairo))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan
      #~'(("usr/bin/mintmenu" "bin/mintmenu")
          ("usr/lib/linuxmint/mintMenu/plugins/"
           "lib/linuxmint/mintMenu/plugins/")
          ("usr/lib/linuxmint/mintMenu/" "lib/linuxmint/mintMenu/")
          ("usr/share/mate-panel/applets/org.mate.panel.MintMenuApplet.mate-panel-applet"
           "share/mate-panel/applets/org.mate.applets.MintMenuApplet.mate-panel-applet")
          ("usr/share/" "share/"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'fixup-paths
            (lambda _
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

              (define* (patch-mintMenu-shebangs)
                ;; Patch MintMenu.py python shebangs
                (patch-python3-shebangs #:file "usr/bin/mintmenu")
                (patch-python3-shebangs #:file
                 "usr/lib/linuxmint/mintMenu/plugins/__init__.py"))

              (define* (patch-mintMenu-py)
                ;; Patch MintMenu.py (main application)
                (substitute* "usr/lib/linuxmint/mintMenu/mintMenu.py"
                  (("__DEB_VERSION__")
                   (string-append "" "6.2.0-guix")))

                (patch-usr-to-guix #:file
                                   "usr/lib/linuxmint/mintMenu/mintMenu.py"))

              (define* (patch-mintMenu-applet-files)
                ;; Patch The dbus service, mate-panel-applet file and the
                ;; applications.list on /usr/
                (patch-usrlib-to-lib #:file
                 "usr/share/mate-panel/applets/org.mate.panel.MintMenuApplet.mate-panel-applet")
                (patch-usrlib-to-lib #:file
                 "usr/share/dbus-1/services/org.mate.panel.applet.MintMenuAppletFactory.service")
                (patch-usrshare-to-share #:file
                 "usr/lib/linuxmint/mintMenu/applications.list"))

              ;; Patch /usr/lib/mintmenu to use GUIX's /lib directory
              (patch-usrlib-to-lib #:file "usr/bin/mintmenu")

              ;; Begin patching
              (patch-mintMenu-shebangs)
              (patch-mintMenu-py)
              (patch-mintMenu-applet-files)
              (patch-usr-to-guix #:file
               "usr/lib/linuxmint/mintMenu/plugins/easybuttons.py")
              (patch-usr-to-guix #:file
               "usr/lib/linuxmint/mintMenu/plugins/applications.py")
              (patch-usr-to-guix #:file
                                 "usr/lib/linuxmint/mintMenu/preferences.py")
              (patch-usr-to-guix #:file
               "usr/lib/linuxmint/mintMenu/plugins/execute.py")
              (patch-usr-to-guix #:file
               "usr/lib/linuxmint/mintMenu/plugins/filemonitor.py")
              (patch-usr-to-guix #:file
               "usr/lib/linuxmint/mintMenu/plugins/get_apt_cache.py")
              (patch-usr-to-guix #:file
               "usr/lib/linuxmint/mintMenu/plugins/places.py")
              (patch-usr-to-guix #:file
               "usr/lib/linuxmint/mintMenu/plugins/recent.py")
              (patch-usr-to-guix #:file
               "usr/lib/linuxmint/mintMenu/plugins/recentHelper.py")
              (patch-usr-to-guix #:file
               "usr/lib/linuxmint/mintMenu/plugins/system_management.py"))))
      #:tests? #t))
    (home-page "https://github.com/linuxmint/mintmenu")
    (synopsis "Advanced Mint menu for MATE")
    (description
     "One of the most advanced menus under Linux. MintMenu supports filtering, favorites, easy-uninstallation, autosession, and many other features.")
    (license license:gpl2+)))
