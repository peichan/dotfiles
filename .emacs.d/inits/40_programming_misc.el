(require 'autopair)
(autopair-global-mode)

(require 'rainbow-mode)
(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'scss-mode-hook 'rainbow-mode)
(add-hook 'php-mode-hook 'rainbow-mode)
(add-hook 'html-mode-hook 'rainbow-mode)

;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook
 'flycheck-mode-hook
 '(lambda ()
    (local-set-key (kbd "C-c C-n") 'flycheck-next-error)
    (local-set-key (kbd "C-c C-p") 'flycheck-previous-error)))

(require 'quickrun)
