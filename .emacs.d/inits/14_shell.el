;; multi-term
;; (require 'multi-term)
;; (setq multi-term-program "/bin/zsh")
;; (add-to-list 'term-unbind-key-list '"M-x")
;; (add-to-list 'term-unbind-key-list '"TAB")
;; (add-to-list 'term-unbind-key-list '"DEL")
;; (add-hook 'term-mode-hook
;;           '(lambda ()
;;              (define-key term-raw-map (kbd "C-h") 'term-send-backspace)
;;              (define-key term-raw-map (kbd "C-y") 'term-paste)
;;              ))

;; hide input passward in shell-mode
(add-hook 'comint-output-filte-functions
          'comint-watch-for-password-prompt)

(setq system-uses-terminfo nil)
