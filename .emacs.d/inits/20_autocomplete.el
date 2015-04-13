;; auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)
(setq ac-use-fuzzy t)  ;; 曖昧マッチ有効
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

;; au-etags
;; usage 1. generate tags -> 2 M-x visit-tags-table
;; (custom-set-variables
;;  '(ac-etags-requires 1))
;; (eval-after-load "etags"
;;   '(progn
;;      (ac-etags-setup)))
;; (add-hook 'c-mode-common-hook 'ac-etags-ac-setup)
;; (add-hook 'ruby-mode-common-hook 'ac-etags-ac-setup)
;; (add-hook 'cperl-mode-common-hook 'ac-etags-ac-setup)

;; Enable auto-complete mode other than default enable modes
(dolist (mode '(
                coffee-mode
                cperl-mode
                fundamental-mode
                git-commit-mode
                go-mode
                js2-mode
                json-mode
                markdown-mode
                org-mode
                python-mode
                ruby-mode
                scala-mode
                scss-mode
                css-mode
                text-mode
                ))
  (add-to-list 'ac-modes mode))

;; ac-ispell
(ac-ispell-setup)
(dolist (hook '(text-mode-hook markdown-mode-hook))
  (add-hook hook 'ac-ispell-ac-setup))
