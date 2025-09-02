(define-public gtk-sharp
  (package
    (name "gtk-sharp")
    (version "2.99.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://gnome/sources/gtk-sharp/"
                           (version-major+minor version)
                           "/"
                           "gtk-sharp-"
                           version
                           ".tar.xz"))
       (sha256
        (base32 "1li6pzh9xvl66nlixzpwqsn8aaa0kj0azhzjan4cd65f7nnjpq99"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:make-flags
      #~(list "-Wno-error=int-conversion"
              "-Wno-error=implicit-function-declaration")))
    (inputs mono glib pango gtk+ libxml2)
    (native-inputs pkg-config autoconf automake libtool which)
    (home-page "https://www.mono-project.com/docs/gui/gtksharp")
    (synopsis "GTK User Interface Toolkit for mono and .NET")
    (description
     "This package provides bindings to the cross-platform Gtk+ User
Interface Toolkit and the foundation of GUI Apps build with Mono.")
    (license license:gpl2+)))
