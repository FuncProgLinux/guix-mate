(define-module (guix-mate packages ubuntu)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages attr)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages code)
  #:use-module (gnu packages dotnet)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg))

;; Lomiri Packages
(define-public cmake-extras
  (package
    (name "cmake-extras")
    (version "1.9")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://gitlab.com/ubports/development/core/cmake-extras")
             (commit "1.9")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0mnxs1j992c3hck5imra3cbb0h2x65m4xnf3vnyr3dlxci1jxlpd"))))
    (build-system cmake-build-system)
    (arguments
     (list
      ;; no test suite is present
      #:tests? #f))
    (native-inputs (list cmake))
    (inputs (list qtbase))
    (home-page "https://gitlab.com/ubports/development/core/cmake-extras")
    (synopsis "Collection of add-ons for the CMake build tool")
    (description
     "Lomiri addons for CMake. Needed to build ayatana indicators.")
    (license license:gpl3)))

;; Ayatana Packages
(define-public ayatana-ido
  (package
    (name "ayatana-ido")
    (version "0.10.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/AyatanaIndicators/ayatana-ido")
             (commit "0.10.4")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1li6pzh9xvl66nlixzpwqsn8aaa0kj0azhzjan4cd65f7nnjpq99"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:out-of-source? #t
      #:imported-modules `(,@%cmake-build-system-modules (guix build
                                                          glib-or-gtk-build-system))
      #:modules '((guix build cmake-build-system)
                  ((guix build glib-or-gtk-build-system)
                   #:prefix glib-or-gtk:)
                  (guix build utils))))
    (native-inputs (list cmake gobject-introspection vala lcov pkg-config))
    (inputs (list gtk+
                  `(,glib "bin") gtk-doc))
    (home-page "https://github.com/AyatanaIndicators")
    (synopsis "Ayatana Display Indicator Objects")
    (description
     "Ayatana IDO provides custom GTK menu widgets for
Ayatana System Indicators. This is a base dependency for all indicators.")
    (license (list license:lgpl2.0+ license:lgpl3+))))

(define-public libayatana-indicator
  (package
    (name "libayatana-indicator")
    (version "0.9.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/AyatanaIndicators/libayatana-indicator")
             (commit "0.9.4")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1c0pymlpxabh7iackv6i47gh81b7pxx194r07lpbxnz5x1kjxj1s"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:validate-runpath? #f
      #:imported-modules `(,@%cmake-build-system-modules (guix build
                                                          glib-or-gtk-build-system))
      #:configure-flags
      #~(list (string-append "-DCMAKE_INSTALL_PREFIX="
                             #$output "/"))
      #:modules '((guix build cmake-build-system)
                  ((guix build glib-or-gtk-build-system)
                   #:prefix glib-or-gtk:)
                  (guix build utils))))
    (native-inputs (list cmake gobject-introspection pkg-config))
    (inputs (list gtk+
                  `(,glib "bin") gtk-doc))
    (propagated-inputs (list ayatana-ido))
    (home-page "https://github.com/AyatanaIndicators")
    (synopsis "Ayatana Indicators Shared Library")
    (description "Ayatana Indicators shared library built with ayatana-ido")
    (license license:gpl3+)))

(define-public libayatana-appindicator
  (package
    (name "libayatana-appindicator")
    (version "0.5.94")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url
              "https://github.com/AyatanaIndicators/libayatana-appindicator")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1di9blgqv5iaq0yjam0j1mnzhjqg23gdbmgmrak8hv0j5xwnnbxj"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:validate-runpath? #f
      #:imported-modules `(,@%cmake-build-system-modules (guix build
                                                          glib-or-gtk-build-system))
      #:configure-flags
      #~(list "-DENABLE_BINDINGS_MONO=False")
      #:modules '((guix build cmake-build-system)
                  ((guix build glib-or-gtk-build-system)
                   #:prefix glib-or-gtk:)
                  (guix build utils))))
    (native-inputs (list cmake gobject-introspection pkg-config gtk-doc/stable
                         vala))
    (inputs (list gtk+
                  (list glib "bin")))
    (propagated-inputs (list libayatana-indicator libdbusmenu))
    (home-page "https://github.com/AyatanaIndicators/libayatana-appindicator")
    (synopsis "Ayatana AppIndicators shared library")
    (description
     "Ayatana indicators shared library built with libayatana-indicator and libdbusmenu")
    (license license:gpl3+)))

(define-public libayatana-common
  (package
    (name "libayatana-common")
    (version "0.9.11")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/AyatanaIndicators/libayatana-common")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0hlpm1xrjbkkyzj1wx29467fz06pv3rqdz7w6vpnjs263js5m5x3"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "-DGSETTINGS_LOCALINSTALL=True" "-DGSETTINGS_COMPILE=True")
      #:imported-modules `(,@%cmake-build-system-modules (guix build
                                                          glib-or-gtk-build-system))
      #:modules '((guix build cmake-build-system)
                  ((guix build glib-or-gtk-build-system)
                   #:prefix glib-or-gtk:)
                  (guix build utils))
      #:tests? #f))
    (native-inputs (list cmake gobject-introspection intltool pkg-config vala))
    (inputs (list cmake-extras gsettings-desktop-schemas
                  (list glib "bin")))
    (home-page "https://github.com/AyatanaIndicators/libayatana-common")
    (synopsis "Common functions for Ayatana System Indicators")
    (description
     "Shared Library for common functions required by the Ayatana System Indicators")
    (license license:gpl3)))

(define-public bamf
  (package
    (name "bamf")
    (version "0.5.6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.launchpad.net/~unity-team/bamf")
             (commit version)
             (recursive? #t)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0x014c4m29ld9aq5xdmydyacc01c3ggr2qz6m8ygb343rccvckzd"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "--enable-headless-tests" "--enable-gtk-doc")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-makefiles
            (lambda _
              ;; Guix doesn't use soystemd. Patch out the ayatana service.
              ;; TODO: Provide a Shepherd service instead!
              (substitute* "data/Makefile.am"
                (("/usr/lib/")
                 (string-append #$output "/lib/"))))))))
    (native-inputs (list autoconf
                         autoconf-archive
                         automake
                         gnome-common
                         gobject-introspection
                         gtk-doc/stable
                         libtool
                         python-lxml
                         pkg-config
                         vala
                         which
                         python-wrapper
                         xorg-server-for-tests))
    (inputs (list glib libgtop libwnck))
    (home-page "https://launchpad.net/bamf")
    (synopsis "Application matching framework from Ubuntu")
    (description "Removes the headache of applications matching into a simple
DBus daemon and a C wrapper library")
    (license license:lgpl3)))
