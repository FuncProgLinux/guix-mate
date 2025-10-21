(define-module (guix-mate packages mate)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages attr)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages backup)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages djvu)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages enchant)
  #:use-module (gnu packages file)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages iso-codes)
  #:use-module (gnu packages javascript)
  #:use-module (gnu packages libcanberra)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mate)
  #:use-module (gnu packages messaging)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages photo)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages webkit)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)

  ;; Include this repository files
  #:use-module (guix-mate packages brisk-menu)
  #:use-module (guix-mate packages mate-tweak)
  #:use-module (guix-mate packages mate-window-applets))

;; TODO: Remove this after the package gets updated at upstream
;; Guix on: gnu/packages/gnome.scm
(define-public libwnck-next
  (package
    (inherit libwnck)
    (name "libwnck")
    (version "43.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://gnome/sources/"
                           "libwnck"
                           "/"
                           (version-major version)
                           "/"
                           "libwnck"
                           "-"
                           (version-major+minor version)
                           ".tar.xz"))
       (sha256
        (base32 "1zn1l8k5m4lz9acwvx6fgvkflqfwsq6b6mhyhvwbimj7b2wcsnwh"))))))

(define-public mate-panel-1.28.7
  (package
    (name "mate-panel")
    (version "1.28.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mate-desktop/mate-panel")
             (commit (string-append "v" version))
             (recursive? #t)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1549rd3x08qm91n55rw6jy8n1ryf3n7h4bf2n456cjv4iqjvlr7h"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags (list (string-append "--with-zoneinfo-dir="
                                              (assoc-ref %build-inputs
                                                         "tzdata")
                                              "/share/zoneinfo")
                               "--with-in-process-applets=all")
       #:phases (modify-phases %standard-phases
                  (add-before 'configure 'fix-timezone-path
                    (lambda* (#:key inputs #:allow-other-keys)
                      (let* ((tzdata (assoc-ref inputs "tzdata")))
                        (substitute* "applets/clock/system-timezone.h"
                          (("/usr/share/lib/zoneinfo/tab")
                           (string-append tzdata "/share/zoneinfo/zone.tab"))
                          (("/usr/share/zoneinfo")
                           (string-append tzdata "/share/zoneinfo")))) #t))
                  (add-after 'unpack 'fix-introspection-install-dir
                    (lambda* (#:key outputs #:allow-other-keys)
                      ;; NOTE: v1.28.5 and later require autogen.sh
                      (setenv "ACLOCAL_FLAGS"
                              (string-join (map (lambda (s)
                                                  (string-append "-I " s))
                                                (string-split (getenv
                                                               "ACLOCAL_PATH")
                                                              #\:)) " "))
                      (setenv "NOCONFIGURE" "yes")
                      (invoke "bash" "autogen.sh")
                      (let ((out (assoc-ref outputs "out")))
                        (substitute* '("configure")
                          (("`\\$PKG_CONFIG --variable=girdir gobject-introspection-1.0`")
                           (string-append "\"" out "/share/gir-1.0/\""))
                          (("\\$\\(\\$PKG_CONFIG --variable=typelibdir gobject-introspection-1.0\\)")
                           (string-append out "/lib/girepository-1.0/"))) #t))))))
    (native-inputs (list autoconf
                         autoconf-archive
                         automake
                         pkg-config
                         intltool
                         itstool
                         gtk-doc/stable
                         libtool
                         mate-common
                         xtrans
                         gobject-introspection
                         which ;Wanted by autogen.sh
                         yelp-tools))
    (inputs (list dconf
                  dconf-editor
                  cairo
                  dbus-glib
                  gtk-layer-shell
                  gtk+
                  libcanberra
                  libice
                  libmateweather
                  (librsvg-for-system)
                  libsm
                  libx11
                  libxau
                  libxml2
                  libxrandr
                  libwnck-next
                  mate-desktop
                  mate-menus
                  pango
                  tzdata
                  wayland))
    (native-search-paths
     (list (search-path-specification
            (variable "MATE_PANEL_APPLETS_DIR")
            (files '("share/mate-panel/applets")))
           (search-path-specification
            (variable "MATE_PANEL_EXTRA_MODULES")
            (files '("lib/mate-panel/modules")))))
    (home-page "https://mate-desktop.org/")
    (synopsis "Panel for MATE")
    (description
     "Mate-panel contains the MATE panel, the libmate-panel-applet library and
several applets.  The applets supplied here include the Workspace Switcher,
the Window List, the Window Selector, the Notification Area, the Clock and the
infamous 'Wanda the Fish'.")
    (license (list license:gpl2+ license:lgpl2.0+))))

(define-public mate-applets-1.28.1
  (package
    (name "mate-applets")
    (version "1.28.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://mate/"
                           (version-major+minor version)
                           "/"
                           "mate-applets-"
                           version
                           ".tar.xz"))
       (sha256
        (base32 "0bkyzapds1ha8cvbnl7nc0qjbv5f4cy019i2sdrb3ibxa90p35m5"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "--enable-suid=no" "--enable-polkit" "--enable-in-process"
              (string-append "--with-dbus-sys="
                             #$output "/share/dbus-1/system.d")
              "--enable-ipv6")))
    (native-inputs (list pkg-config
                         intltool ;Listed in Debian package (but not in upstream build.yml)
                         itstool ;Listed in upstream build.yml
                         libxslt
                         yelp-tools
                         gettext-minimal
                         docbook-xml
                         gobject-introspection))
    (inputs (list at-spi2-core
                  cpupower
                  dbus
                  dbus-glib
                  glib
                  gucharmap
                  gtk+
                  gtksourceview-4
                  libgtop
                  libmateweather
                  libnl
                  libnotify
                  libsoup-minimal-2 ;Listed in upstream configure.ac
                  libx11
                  libxml2
                  libwnck
                  mate-desktop
                  mate-menus
                  mate-panel
                  pango
                  polkit ;either polkit or setuid
                  upower
                  wireless-tools))
    (propagated-inputs (list python-pygobject))
    (home-page "https://mate-desktop.org/")
    (synopsis "Various applets for the MATE Panel")
    (description
     "Mate-applets includes various small applications for Mate-panel:

@enumerate
@item accessx-status: indicates keyboard accessibility settings,
including the current state of the keyboard, if those features are in use.
@item Battstat: monitors the power subsystem on a laptop.
@item Character palette: provides a convenient way to access
non-standard characters, such as accented characters,
mathematical symbols, special symbols, and punctuation marks.
@item MATE CPUFreq Applet: CPU frequency scaling monitor
@item Drivemount: lets you mount and unmount drives and file systems.
@item Geyes: pair of eyes which follow the mouse pointer around the screen.
@item Keyboard layout switcher: lets you assign different keyboard
layouts for different locales.
@item Modem Monitor: monitors the modem.
@item Invest: downloads current stock quotes from the Internet and
displays the quotes in a scrolling display in the applet. The
applet downloads the stock information from Yahoo! Finance.
@item System monitor: CPU, memory, network, swap file and resource.
@item Trash: lets you drag items to the trash folder.
@item Weather report: downloads weather information from the
U.S National Weather Service (NWS) servers, including the
Interactive Weather Information Network (IWIN).
@end enumerate
")
    (license (list license:gpl2+ license:lgpl2.0+ license:gpl3+))
    (native-search-paths
     (list (search-path-specification
            (variable "XDG_DATA_DIRS")
            (files '("share")))))))

(define-public caja-actions
  (package
    (name "caja-actions")
    (version "1.28.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://mate/"
                           (version-major+minor version)
                           "/"
                           "caja-actions-"
                           version
                           ".tar.xz"))
       (sha256
        (base32 "0kga1dfv6kcyyidgzbnxvyc48kqmnq0ai82ri62aszvhir43j39i"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list (string-append "--with-caja-extdir="
                             #$output "/lib/caja/extensions-2.0/"
                             "--disable-static"))))
    (native-inputs (list gettext-minimal
                         intltool
                         libice
                         libxml2
                         libtool
                         gobject-introspection
                         gtk-doc/stable
                         pkg-config
                         yelp-tools))
    (inputs (list caja
                  dbus
                  dbus-glib
                  gtk+
                  (list glib "bin")
                  libgtop
                  libsm
                  mate-desktop))
    (home-page "https://mate-desktop.org/")
    (synopsis "Execute commands from the caja popup menu.")
    (description
     "This package is an extension for the MATE caja file manager
it allows users to add arbitrary programs and launch them through the popup
menu of selected files.")
    (license license:gpl2)))

(define-public mate-user-share
  (package
    (name "mate-user-share")
    (version "1.28.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://mate/"
                           (version-major+minor version)
                           "/"
                           "mate-user-share-"
                           version
                           ".tar.xz"))
       (sha256
        (base32 "0f5f75bsxvkp80qag95ijwdhi1hb6n7z0zj9iqs535hpk6cn11c9"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list (string-append "--with-cajadir="
                             #$output "/lib/caja/extensions-2.0/"))))
    (native-inputs (list pkg-config gettext-minimal itstool libxml2))
    (inputs (list gtk+
                  caja
                  dbus
                  dbus-glib
                  libnotify
                  libcanberra
                  hicolor-icon-theme))
    (home-page "https://mate-desktop.org/")
    (synopsis "Public files sharing tools for the MATE Desktop")
    (description
     "This package binds programs together to ease file-sharing
across networks on the MATE Desktop. If the file-sharing option is enabled
it will expose the user's $HOME/Public directory on a webdav server.")
    (license license:gpl2+)))

(define-public mate-menus-1.28.0-1
  (package
    (inherit mate-menus)
    (inputs (modify-inputs (package-inputs mate)
              (replace "python" python)))))

(define-public mate-polkit-1.28.1-1
  (package
    (inherit mate-polkit)
    (arguments
     (substitute-keyword-arguments (package-arguments mate-polkit)
       ((#:configure-flags flags
         #~(list))
        #~(list (string-append "--libexecdir="
                               #$output "/libexec")))))))

(define-public mate-power-manager-1.28.1-1
  (package
    (inherit mate-power-manager)
    (arguments
     (substitute-keyword-arguments (package-arguments mate-power-manager)
       ((#:configure-flags flags
         #~(list))
        #~(list (string-append "--libexecdir="
                               #$output "/libexec")))))))

(define-public mate-settings-daemon-1.28.0-1
  (package
    (inherit mate-settings-daemon)
    (arguments
     (substitute-keyword-arguments (package-arguments mate-settings-daemon)
       ((#:configure-flags flags
         #~(list))
        #~(list (string-append "--libexecdir="
                               #$output "/libexec") "--enable-polkit"
                "--enable-pulse"))))))

(define-public mate-media-1.28.1-1
  (package
    (inherit mate-media)
    (arguments
     (substitute-keyword-arguments (package-arguments mate-media)
       ((#:configure-flags flags
         #~(list))
        #~(list (string-append "--libexecdir="
                               #$output "/libexec")))))))

(define-public mate-control-center-1.28.0-1
  (package
    (inherit mate-control-center)
    (arguments
     (substitute-keyword-arguments (package-arguments mate-control-center)
       ((#:configure-flags flags
         #~(list))
        #~(list (string-append "--sbindir="
                               #$output "/sbin")))))))

(define-public pluma-1.28.0-1
  (package
    (name "pluma")
    (version "1.28.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://mate/"
                           (version-major+minor version)
                           "/"
                           name
                           "-"
                           version
                           ".tar.xz"))
       (sha256
        (base32 "1m51cmcl6z68bx37zhi72wfl58kq9bg7xcih1sjr6l1li6axz2ma"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "--enable-python")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'wrap-pluma
            (lambda* (#:key outputs #:allow-other-keys)
              (wrap-program (search-input-file outputs "bin/pluma")
                ;; For plugins (same as gedit).
                `("GI_TYPELIB_PATH" ":" prefix
                  (,(getenv "GI_TYPELIB_PATH")))
                `("GUIX_PYTHONPATH" ":" prefix
                  (,(getenv "GUIX_PYTHONPATH")))
                ;; For language-specs.
                `("XDG_DATA_DIRS" ":" prefix
                  (,(string-append #$(this-package-input "gtksourceview")
                                   "/share")))))))
      ;; Tests can not succeed.
      ;; https://github.com/mate-desktop/mate-text-editor/issues/33
      #:tests? #f))
    (native-inputs (list gettext-minimal
                         gtk-doc/stable
                         gobject-introspection
                         intltool
                         libtool
                         perl
                         pkg-config
                         yelp-tools))
    (inputs (list at-spi2-core
                  cairo
                  enchant
                  glib
                  gtk+
                  gtksourceview-4
                  gdk-pixbuf
                  iso-codes/pinned
                  libcanberra
                  libx11
                  libsm
                  libpeas
                  libxml2
                  libice
                  mate-desktop
                  packagekit
                  pango
                  python
                  python-pygobject
                  python-wrapper
                  python-pycairo
                  python-six
                  startup-notification))
    (home-page "https://mate-desktop.org/")
    (synopsis "Text Editor for MATE")
    (description "Pluma is the text editor for the MATE Desktop.")
    (license license:gpl2)))

(define-public mate-extra
  (package
    (inherit mate)
    (version (string-append (package-version mate-desktop) "-3"))
    (propagated-inputs (modify-inputs (package-propagated-inputs mate)
                         (replace "mate-applets" mate-applets-1.28.1)
                         (replace "mate-panel" mate-panel-1.28.7)
                         (replace "mate-polkit" mate-polkit-1.28.1-1)
                         (replace "mate-menus" mate-menus-1.28.0-1)
                         (replace "mate-power-manager"
                                  mate-power-manager-1.28.1-1)
                         (replace "pluma" pluma-1.28.0-1)
                         (replace "mate-settings-daemon"
                                  mate-settings-daemon-1.28.0-1)
                         (replace "mate-media" mate-media-1.28.1-1)
                         (replace "mate-control-center"
                                  mate-control-center-1.28.0-1)
                         ;; Ubuntu MATE Packages
                         (append brisk-menu)
                         (append mate-tweak)
                         (append mate-window-applets)

                         ;; Upstream MATE packages
                         (append mate-user-share)))))
