;; *scala******************************************************************
;; scala-mode
(autoload 'scala-mode-auto "scala-mode-auto" nil t)
(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))

;; ensime
;; Load the ensime lisp code...
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; C-c,C-qでエラー表示
(defun my-ensime-show-tooltips-nox ()
  (interactive)
  (ensime-tooltip-handler (point)))
(add-hook 'scala-mode-hook
          (function (lambda ()
                      (local-set-key (kbd "\C-c\C-n") 'my-ensime-show-tooltips-nox)
                      )))
