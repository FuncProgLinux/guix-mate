(define-module (guix-mate services guix-mate-desktop)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (guix-mate packages brisk-menu)
  #:use-module (guix-mate packages mate-menu)
  #:use-module (guix-mate packages mate-tweak)
  #:use-module (guix-mate packages mate-dock-applet)
  #:use-module (guix-mate packages mate-window-applets)
  #:use-module (guix-mate packages python-caja)
  #:export (guix-mate-desktop-service guix-mate-desktop-service-type))

(define (guix-mate-desktop-service config)
  (list brisk-menu
        mate-menu
        mate-tweak
        mate-dock-applet
        python-caja
        mate-window-applets))

(define guix-mate-desktop-service-type
  (service-type (name 'guix-mate-desktop)
                (description
                 "A service to install extra MATE Desktop applets & libraries.")
                (extensions (list (service-extension profile-service-type
                                   guix-mate-desktop-service)))
                (default-value #f)))
