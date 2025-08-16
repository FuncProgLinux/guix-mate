(define-module (guix-mate packages mate)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages mate)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages libcanberra)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg))

(define-public mate-sensors-applet
  (package
    (name "mate-sensors-applet")
    (version "1.28.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://mate/"
                           (version-major+minor version)
                           "/"
                           "mate-sensors-applet-"
                           version
                           ".tar.xz"))
       (sha256
        (base32 "10as64102wbgmi8ak3ya2zyvc3dpx24rfg18323fp3xgh9k3crfl"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "--enable-in-process")))
    (native-inputs (list pkg-config
                         intltool ;Listed in Debian package (but not in upstream build.yml)
                         itstool ;Listed in upstream build.yml
                         yelp-tools
                         gettext-minimal
                         gobject-introspection))
    (inputs (list at-spi2-core
                  dbus
                  dbus-glib
                  glib
                  gtk+
                  libnotify
                  lm-sensors
                  libx11
                  libxml2
                  libxslt
                  libatasmart
                  libwnck
                  mate-desktop
                  mate-menus
                  mate-panel
                  pango
                  polkit ;either polkit or setuid
                  upower
                  wireless-tools))
    (home-page "https://mate-desktop.org/")
    (synopsis "MATE panel applet for hardware sensors.")
    (description
     "MATE Sensors Applet displays readings from hardware sensors in the MATE
panel, these include CPU temperature, fan speeds and voltage reading under
Gnu/Linux.")
    (license license:gpl2+)))

(define-public mate-panel
  (package
    (name "mate-panel")
    (version "1.28.4")
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
        (base32 "0x48jqm2axzxp2hc7mh3znds7nqwaw59b2ghnsbw2ajc66q9xw02"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list (string-append "--with-zoneinfo-dir="
                             (assoc-ref %build-inputs "tzdata")
                             "/share/zoneinfo")
              "--with-in-process-applets=all")
      #:phases
      #~(modify-phases %standard-phases
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
              (let ((out (assoc-ref outputs "out")))
                (substitute* '("configure")
                  (("`\\$PKG_CONFIG --variable=girdir gobject-introspection-1.0`")
                   (string-append "\"" out "/share/gir-1.0/\""))
                  (("\\$\\(\\$PKG_CONFIG --variable=typelibdir gobject-introspection-1.0\\)")
                   (string-append out "/lib/girepository-1.0/"))) #t)))
          ;; add missing libexec dir
          (add-before 'glib-or-gtk-wrap 'create-missing-dir
                      (lambda* (#:key outputs #:allow-other-keys)
                        (mkdir (string-append (assoc-ref outputs "out") "/libexec"))))
          ;; patch XDG_DATA_DIRS
          (add-after 'glib-or-gtk-wrap 'wrap-typelib
            (lambda* (#:key outputs inputs #:allow-other-keys)
              (wrap-program (search-input-file outputs "/bin/mate-panel")
                ;; For plugins.
                `("GI_TYPELIB_PATH" ":" prefix
                  (,(getenv "GI_TYPELIB_PATH")))
                `("XDG_DATA_DIRS" ":" prefix
                  (,(string-append #$(this-package-input "marco") "/share")))))))))
    (native-inputs (list pkg-config intltool itstool xtrans
                         gobject-introspection))
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
                  libwnck
                  marco
                  mate-desktop
                  mate-menus
                  pango
                  tzdata
                  wayland))
    (home-page "https://mate-desktop.org/")
    (synopsis "Panel for MATE")
    (description
     "Mate-panel contains the MATE panel, the libmate-panel-applet library and
several applets.  The applets supplied here include the Workspace Switcher,
the Window List, the Window Selector, the Notification Area, the Clock and the
infamous 'Wanda the Fish'.")
    (license (list license:gpl2+ license:lgpl2.0+))))
