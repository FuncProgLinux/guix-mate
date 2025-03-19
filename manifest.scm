(concatenate-manifests (list (specifications->manifest (list "git"
                                                        "emacs"
                                                        "emacs-geiser"
                                                        "emacs-geiser-guile"
                                                        "emacs-arei"
                                                        "emacs-paredit"
                                                        "make"
                                                        "emacs-evil"))
                             (package->development-manifest (specification->package
                                                             "git"
                                                             "guile"
                                                             "guile-colorized"))))
