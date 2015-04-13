;; *scss*****************************************************************
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.\\(scss\\|css\\|sass\\)\\'" . scss-mode))
(setq scss-compile-at-save nil)
