(define-module (guix-mate packages mate-sensors-applet)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages mate)
  #:use-module (gnu packages gtk)
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
