((nil
  .
  ((lsp-file-watch-threshold . 500)
   (eval .
         (setq-local cape-file-directory
                     (when-let ((project (project-current)))
                       (project-root project))))))
 (org-mode
  .
  ((eval .
         (progn
           (direnv-mode 't)
           (my/load-org-jupyter))))))
