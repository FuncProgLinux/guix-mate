((nil
  . ((fill-column . 80)
     (tab-width   .  8)

     ;; For use with 'bug-reference-prog-mode', taken from GNU GUIX
     ;; Licensed GPL-3.0+
     (bug-reference-url-format . "https://codeberg.org/guix-mate/guix-mate/issues/%s")
     (bug-reference-bug-regexp
      . "\\(#\\([0-9]+\\)\\)")

     (geiser-insert-actual-lambda  .nil)
     (eval . (add-to-list 'completion-ignored-extensions ".go"))))
 (scheme-mode
  .
  ((indent-tabs-mode . nil)
   (geiser-guile-binary . ("guile"))
   (geiser-active-implementations . ("guile"))))
 (makefile-gmake-mode
  .
  ((indent-tabs-mode . t)
   (tab-width        . 4)))
 (cperl-mode
  .
  ((indent-tabs-mode . nil)
   (tab-width . 4)
   (fill-column . 80)
   (cperl-electric-parens . nil))))
