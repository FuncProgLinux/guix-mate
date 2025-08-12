;; NOTE: This package already exists in GNU Guix. And will be
;; dropped when the original package gets updated either by
;; a PR from us or if time allows it.
(define-module (guix-mate packages yaru-theme)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (gnu packages gnome-xyz))

(define-public yaru-theme-guix-mate
  (package
   (inherit yaru-theme)
   (name "yaru-guix-mate")
   (version "25.04.2")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/ubuntu/yaru")
           (commit version)))
     (sha256
      (base32 "1zz5x8cry6zrnmia2sfcgl2s3fgljsrc0zn0wpd45whgk7vk7kb8"))))))

yaru-theme-guix-mate
