((nil
  .
  ((flycheck-disabled-checkers . (python-mypy))
   (flycheck-flake8rc . ".flake8")
   (lsp-file-watch-threshold . 500)
   (projectile-indexing-method . hybrid)
   (eval . (setq-local cape-file-directory (projectile-project-root)))
   (eval .
         (setq-local lsp-file-watch-ignored-directories
                     (append
                      '("[/\\\\]\\data\\'")
                      lsp-file-watch-ignored-directories)))))
 (org-mode
  .
  ((eval .
         (progn
           (direnv-mode 't)
           (my/load-org-jupyter))))))
