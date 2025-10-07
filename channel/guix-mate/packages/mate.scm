(define-module (guix-mate packages mate)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
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
      #~(list "--enable-suid=no" "--enable-polkit"
              (string-append "--libexecdir="
                             #$output "/libexec")
              (string-append "--with-dbus-sys="
                             #$output "/share/dbus-1/system.d")
              "--enable-ipv6")))
    (native-inputs (list pkg-config
                         intltool ;Listed in Debian package (but not in upstream build.yml)
                         itstool ;Listed in upstream build.yml
                         libxslt
                         yelp-tools
                         scrollkeeper
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

(define-public mate-themes-3.22.26
  (package
    (name "mate-themes")
    (version "3.22.26")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://mate/themes/"
                           (version-major+minor version) "/mate-themes-"
                           version ".tar.xz"))
       (sha256
        (base32 "1msyfpmhgijzr2i4jhzmrf9ilhlq994havbmrzqp6fzbck9qjki2"))))
    (build-system gnu-build-system)
    (native-inputs (list pkg-config intltool gdk-pixbuf ;gdk-pixbuf+svg isn't needed
                         gtk+-2))
    (home-page "https://mate-desktop.org/")
    (synopsis "Official themes for the MATE desktop")
    (description
     "This package includes the standard themes for the MATE desktop, for
example Menta, TraditionalOk, GreenLaguna or BlackMate.  This package has
themes for both gtk+-2 and gtk+-3.")
    (license (list license:lgpl2.1+ license:cc-by-sa3.0 license:gpl3+
                   license:gpl2+))))

(define-public mate-indicator-applet
  (package
    (name "mate-indicator-applet")
    (version "1.28.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://mate/"
                           (version-major+minor version)
                           "/"
                           "mate-indicator-applet-"
                           version
                           ".tar.xz"))
       (sha256
        (base32 "1ka9mplw28p2sb75lj9559sszqvi44f0ppypgj6maghajw1xgcyf"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs (list pkg-config gettext-minimal))
    (inputs (list gtk+ libindicator mate-common mate-panel hicolor-icon-theme))
    (home-page "https://mate-desktop.org/")
    (synopsis
     "Applet for displaying application indicators on the MATE panel.")
    (description "This applet displays information from various applications
consistently in the MATE panel.")
    (license (list license:gpl3 license:lgpl2.1))))

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
    (inherit pluma)
    (inputs (modify-inputs (package-inputs mate)
              (replace "python" python)
              (append python-wrapper)
              (append enchant)
              (append iso-codes)
              (append libxml2)
              (append glib)
              (append gtk+)
              (append libsm)
              (append libpeas)
              (append gtksourceview-4)
              (append mate-desktop)
              (append startup-notification)))
    (arguments
     (substitute-keyword-arguments (package-arguments pluma)
       ((#:configure-flags flags
         #~(list))
        #~(list (string-append "--libexecdir="
                               #$output "/libexec") "--enable-python"))))))

(define-public mate-extra
  (package
    (inherit mate)
    (version (string-append (package-version mate-desktop) "-2"))
    (propagated-inputs (modify-inputs (package-propagated-inputs mate)
                         (replace "mate-themes" mate-themes-3.22.26)
                         (replace "mate-applets" mate-applets-1.28.1)
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
