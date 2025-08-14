(define-module (guix-mate packages mate-notification-daemon)
  )

(define-public mate-notification-daemon
  (package
    (name "mate-notification-daemon")
    (version "1.28.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://mate/"
                           (version-major+minor version)
                           "/"
                           "mate-notification-daemon-"
                           version
                           ".tar.xz"))
       (sha256
        (base32 "1ml0yrkbly1mz5gmz1wynn3zff5900szncc4rk83xqyzvcww4mmh"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list (string-append "cosas"))))
    (native-inputs (list something))
    (inputs (list something))
    (home-page "https://mate-desktop.org/")
    (synopsis "Daemon to display passive pop-up notifications.")
    (description "")
    (license license:gpl2+)))

mate-notification-daemon
