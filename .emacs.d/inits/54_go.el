(require 'go-mode-load)

(add-hook 'go-mode-hook
          '(lambda()
             (flycheck-mode)
             (setq c-basic-offset 4)
             (setq indent-tabs-mode t)
             (local-set-key (kbd "C-c @" 'godef-jump))
             (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
             (local-set-key (kbd "C-c i") 'go-goto-imports)
             (local-set-key (kbd "C-c d") 'godoc)))
(add-hook 'before-save-hook 'gofmt-before-save)

(eval-after-load "go-mode"
  '(progn
     (require 'go-autocomplete)))

(require 'go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)
(set-face-attribute 'eldoc-highlight-function-argument nil
                    :underline t :foreground "green"
                    :weight 'bold)
