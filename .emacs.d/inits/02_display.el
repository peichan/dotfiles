;; font
(add-to-list 'default-frame-alist
             '(font . "-apple-Ricty_Discord-medium-normal-normal-*-14-*-*-*-m-0-iso10646-1"))

;; 行数とカラム数をスクリーン下部に表示
(column-number-mode t)

;; * linum 画面横の行数表示
;; (global-linum-mode t)
;; (setq linum-format "%03d ")
;; (global-set-key "\C-xl" 'linum-mode)
;; (custom-set-faces
;;  '(linum ((t (:inherit default)))))

;; 色付け ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; color
(require 'color-theme)
(eval-after-load "color-theme"
    '(progn
       (color-theme-initialize)
       (color-theme-dark-laptop)))
(set-background-color "#FFFFFF")
(set-foreground-color "White")
(set-cursor-color "snow")
(set-frame-parameter nil 'alpha 95)

;; カーソル行のハイライト
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "#222222"
                  :underline nil))
    (((class color)
      (background light))
     (:background "#111111"
                  :underline nil))
    (t ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode t)

;; 行末の空白を強調表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")

;; タブを色付け
(defface my-face-b-2 '((t (:background "#181820"))) nil)
(defvar my-face-b-2 'my-face-b-2)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("\t" 0 my-face-b-2 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
                              (if font-lock-mode
                                  nil
                                (font-lock-mode t))))


;; programming misc
;; カーソル位置のシンボルハイライト
(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)
(ahs-set-idle-interval 2)

;; タブを空白4つとして扱う
(setq-default tab-width 4 indent-tabs-mode nil)

