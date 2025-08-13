;; Lo que sigue es un "manifest" equivalente a la línea de comando que
;; introdujo. Puede almacenarlo dentro de un archivo que pudiese pasar a
;; cualquier comando 'guix' que acepte una opción '--manifest' (o -m).

(concatenate-manifests (list (specifications->manifest (list "emacs"
                                                        "emacs-geiser"
                                                        "emacs-geiser-guile"
                                                        "emacs-paredit"
                                                        "guile-lsp-server"
                                                        "make"
                                                        "perl"))
                             (package->development-manifest (specification->package
                                                             "git"))))
