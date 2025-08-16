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
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)

  ;; Include this repository files
  #:use-module (guix-mate packages brisk-menu)
  #:use-module (guix-mate packages mate-menu)
  #:use-module (guix-mate packages mate-tweak)
  #:use-module (guix-mate packages mate-window-applets))

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

(define-public mate-panel-1.28.4
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

(define-public engrampa-1.28.2
  (package
    (name "engrampa")
    (version "1.28.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://mate/"
                           (version-major+minor version)
                           "/"
                           "engrampa-"
                           version
                           ".tar.xz"))
       (sha256
        (base32 "1vq9mi87c0agfwysrbki155835xgv5qm2cbzld1qigs56z17g68y"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags (list "--disable-schemas-compile"
                               "--disable-run-in-place" "--enable-magic"
                               "--enable-packagekit"
                               (string-append "--with-cajadir="
                                              (assoc-ref %outputs "out")
                                              "/lib/caja/extensions-2.0/"))
       #:phases (modify-phases %standard-phases
                  (add-before 'install 'skip-gtk-update-icon-cache
                    ;; Don't create 'icon-theme.cache'.
                    (lambda _
                      (substitute* "data/Makefile"
                        (("gtk-update-icon-cache")
                         "true")) #t)))))
    (native-inputs `(("gettext" ,gettext-minimal)
                     ("gtk-doc" ,gtk-doc/stable)
                     ("intltool" ,intltool)
                     ("pkg-config" ,pkg-config)
                     ("yelp-tools" ,yelp-tools)))
    (inputs (list caja
                  file
                  glib
                  gtk+
                  (librsvg-for-system)
                  json-glib
                  libcanberra
                  libx11
                  libsm
                  packagekit
                  pango))
    (home-page "https://mate-desktop.org/")
    (synopsis "Archive Manager for MATE")
    (description "Engrampa is the archive manager for the MATE Desktop.")
    (license license:gpl2)))

(define-public atril-1.28.1
  (package
    (name "atril")
    (version "1.28.1")
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
        (base32 "0ghrx1nhjjs016swj0qy88azgmvas1478xi3xwnxbspkg4lz9i3l"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags (list (string-append "--with-openjpeg="
                                              (assoc-ref %build-inputs
                                                         "openjpeg"))
                               "--enable-introspection"
                               "--disable-schemas-compile"
                               ;; FIXME: Enable build of Caja extensions.
                               "--disable-caja")
       #:tests? #f
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'fix-mathjax-path
                    (lambda _
                      (let* ((mathjax (assoc-ref %build-inputs "js-mathjax"))
                             (mathjax-path (string-append mathjax
                                            "/share/javascript/mathjax")))
                        (substitute* "backend/epub/epub-document.c"
                          (("/usr/share/javascript/mathjax")
                           mathjax-path))) #t))
                  (add-after 'unpack 'fix-introspection-install-dir
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((out (assoc-ref outputs "out")))
                        (substitute* '("configure")
                          (("\\$\\(\\$PKG_CONFIG --variable=girdir gobject-introspection-1.0\\)")
                           (string-append "\"" out "/share/gir-1.0/\""))
                          (("\\$\\(\\$PKG_CONFIG --variable=typelibdir gobject-introspection-1.0\\)")
                           (string-append out "/lib/girepository-1.0/"))) #t)))
                  (add-before 'install 'skip-gtk-update-icon-cache
                    ;; Don't create 'icon-theme.cache'.
                    (lambda _
                      (substitute* "data/Makefile"
                        (("gtk-update-icon-cache")
                         "true")) #t)))))
    (native-inputs (list pkg-config
                         intltool
                         itstool
                         yelp-tools
                         (list glib "bin")
                         gobject-introspection
                         gtk-doc/stable
                         texlive-bin ;synctex
                         libxml2
                         zlib))
    (inputs (list at-spi2-core
                  cairo
                  caja
                  dconf
                  dbus
                  dbus-glib
                  djvulibre
                  fontconfig
                  freetype
                  ghostscript
                  glib
                  gtk+
                  js-mathjax
                  libcanberra
                  libsecret
                  libspectre
                  libtiff
                  libx11
                  libice
                  libsm
                  libgxps
                  libjpeg-turbo
                  libxml2
                  mate-desktop
                  python-dogtail
                  shared-mime-info
                  gdk-pixbuf
                  gsettings-desktop-schemas
                  libgnome-keyring
                  libarchive
                  marco
                  openjpeg
                  pango
                  ;; texlive
                  ;; TODO:
                  ;; Build libkpathsea as a shared library for DVI support.
                  ;; ("libkpathsea" ,texlive-bin)
                  poppler
                  startup-notification
                  webkitgtk-for-gtk3))
    (home-page "https://mate-desktop.org")
    (synopsis "Document viewer for Mate")
    (description
     "Atril is a simple multi-page document viewer.  It can display and print
@acronym{PostScript, PS}, @acronym{Encapsulated PostScript EPS}, DJVU, DVI, XPS
and @acronym{Portable Document Format PDF} files.  When supported by the
document, it also allows searching for text, copying text to the clipboard,
hypertext navigation, and table-of-contents bookmarks.")
    (license license:gpl2)))

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
      #~(list "--enable-suid=no"
              "--enable-in-process"
              "--enable-polkit"
              (string-append "--libexecdir="
                             #$output "/libexec")
              (string-append "--with-dbus-sys="
                             #$output "/share/dbus-1/system.d")
              "--enable-ipv6")
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'glib-or-gtk-wrap 'create-missing-dir
            (lambda* (#:key outputs #:allow-other-keys)
              (mkdir (string-append (assoc-ref outputs "out") "/libexec")))))))
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
    (license (list license:gpl2+ license:lgpl2.0+ license:gpl3+))))

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
    (build-system gnu-build-system)
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

(define-public mate-extra
  (package
    (inherit mate)
    (version (package-version mate-desktop))
    (inputs (modify-inputs (package-inputs mate)
              (replace "atril" atril-1.28.1)
              (replace "engrampa" engrampa-1.28.2)
              (replace "mate-themes" mate-themes-3.22.26)
              (replace "mate-applets" mate-applets-1.28.1)
              (replace "mate-panel" mate-panel-1.28.4)
              (append brisk-menu)
              (append mate-menu)
              (append mate-tweak)
              (append mate-sensors-applet)
              (append mate-window-applets)))))
