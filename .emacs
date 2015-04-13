;; setup with cask
;; $ curl -fsSkL https://raw.github.com/cask/cask/master/go | python
;; cd .emacs.d
;; cask install

;; cask
(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'cl)

;; emacs daemon
(require 'server)
(or (server-running-p)
    (server-start))

;;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)
;;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)

;; shell path の引き継ぎ
(exec-path-from-shell-initialize)
(let ((envs '("PATH" "GOROOT" "GOPATH")))
  (exec-path-from-shell-copy-envs envs))

;; additional load-path
(setq load-path (append '(
                          "~/.emacs.d/elisp/"
                          )
                        load-path))

(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")

(xterm-mouse-mode t)

;; マウスホイールでスクロール
(defun scroll-down-with-lines ()
    "" (interactive) (scroll-down 1))
(defun scroll-up-with-lines ()
     "" (interactive) (scroll-up 1))
(global-set-key [mouse-4] 'scroll-down-with-lines)
(global-set-key [mouse-5] 'scroll-up-with-lines)

;; magitのcommit用
(set-variable 'magit-emacsclient-executable "/usr/local/Cellar/emacs/24.3/bin/emacsclient")

;; (load "~/.emacs.local")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-diff-options nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-grep-cmd-line ((t (:foreground "color-31"))))
 '(helm-grep-match ((t (:foreground "brightblue"))))
 '(helm-match ((t (:foreground "color-33"))))
 '(helm-selection ((t (:background "color-17" :underline t))))
 '(helm-source-header ((t (:background "color-22" :foreground "brightwhite" :weight bold :height 1.3 :family "Sans Serif"))))
 '(helm-visible-mark ((t (:background "color-17"))))
 '(web-mode-comment-face ((t (:foreground "#E8733F"))))
 '(web-mode-css-at-rule-face ((t (:foreground "#FF7F00"))))
 '(web-mode-css-pseudo-class-face ((t (:foreground "#FF7F00"))))
 '(web-mode-css-rule-face ((t (:foreground "#A0D8EF"))))
 '(web-mode-doctype-face ((t (:foreground "#82AE46"))))
 '(web-mode-html-attr-name-face ((t (:foreground "#B8B453"))))
 '(web-mode-html-attr-value-face ((t (:foreground "#C97586"))))
 '(web-mode-html-tag-face ((t (:foreground "#4C8799" :weight bold))))
 '(web-mode-server-comment-face ((t (:foreground "#D9333F")))))
(put 'erase-buffer 'disabled nil)
