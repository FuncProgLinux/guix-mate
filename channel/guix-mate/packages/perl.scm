(define-module (guix-mate packages perl)
  #:use-module (gnu packages perl)
  #:use-module (guix download)
  #:use-module (guix packages))

(define-public perl-next
  (let ((next-version "5.42.0")
        (hash "1p4n61k2jcym7q62p15qvavas42mynb54ip2jybip6kz9lcfz4z0"))
    (package
      (inherit perl)
      (name "perl-next")
      (version next-version)
      (source
       (origin
         (method url-fetch)
         (uri (string-append "mirror://cpan/src/5.0/perl-" next-version
                             ".tar.gz"))
         (sha256
          (base32 hash))))
      (properties `((release-date . "2025-07-03"))))))
