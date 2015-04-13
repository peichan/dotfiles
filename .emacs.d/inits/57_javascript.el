;; *javascript*****************************************************************
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-hook
 'js2-mode-hook
 '(lambda ()
    (local-set-key (kbd "C-c C-n") 'js2-next-error)
    (local-set-key (kbd "C-c C-p") 'js2-prev-error)))
;; インデントの関数の再設定
(add-hook 'js2-mode-hook
          (require 'js)
          (setq js-indent-level 4
                js-expr-indent-offset 4
                indent-tabs-mode nil)
          (set (make-local-variable 'indent-line-function) 'js-indent-line))
(defun js2-prev-error (&optional arg reset)
  (interactive "p")
  (js2-next-error (- arg) reset))
