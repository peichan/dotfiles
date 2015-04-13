;; 文字コード
;; use utf8
(set-default-coding-systems 'utf-8)
(set-language-environment  'utf-8)
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8-unix)

;; 起動時のメッセージを表示しない
(setq inhibit-startup-message t)

;; タイトルバーの表示名
(setq frame-title-format (format "%%f - @%s" (system-name)))

;; メニューバーを非表示
(menu-bar-mode -1)

;; 対応する括弧表示
(show-paren-mode t)

;; ベルを鳴らさない
(setq ring-bell-function 'ignore)

;; C-kで行末改行まで消す
(setq kill-whole-line t)

;; 画面右端まで行った行を切り詰めない
(setq truncate-partial-width-windows nil)

;; 時間表示
;; (defvar display-time-format "%H:%M")
;; (setq display-time-day-and-date t)
;; (defvar display-time-interval 30)
;; (display-time)

;; シンボリックリンクの読み込みを許可
(setq vc-follow-symlinks t)

;; シンボリックリンク先のVCS内で更新が入った場合にバッファを自動更新
(setq auto-revert-check-vc-info t)

;; エスケープを綺麗に表示する
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Emacsが保持するterminfoを利用する(4mといった文字が表示されるのを防ぐ)
(setq system-uses-terminfo nil)

;; GCを減らして軽くする
(setq gc-cons-threshold (* 10 gc-cons-threshold))

;; 大きいファイルを開くときの警告を和らげる
(setq large-file-warning-threshold (* 25 1024 1024))

;; yesとかの入力を簡単に
(defalias 'yes-or-no-p 'y-or-n-p)

;; auto-save
(setq delete-auto-save-files t) ;; delete auto-save-files
(require 'auto-save-buffers-enhanced)
(setq auto-save-buffers-enhanced-interval 3)
(auto-save-buffers-enhanced t)

;; 同名ファイルにディレクトリ名をつけて表示
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

;; バッファ自動再読み込み
(global-auto-revert-mode 1)

;; wgrep grepバッファ内での置換 -> r
(require 'wgrep)
(setq wgrep-enable-key "r")

;; recentf の拡張
(require 'recentf-ext)

;; 大文字小文字を無視
(setq completion-ignore-case t)

;; for mac
(if (eq system-type 'darwin)
  (require 'pbcopy)
  (turn-on-pbcopy))

;; #!~で始まるものにchmod +xする
(setq my-shebang-patterns
      (list "^#!/usr/.*/perl\\(\\( \\)\\|\\( .+ \\)\\)-w *.*"
        "^#!/usr/.*/sh"
        "^#!/usr/.*/bash"
        "^#!/bin/sh"
        "^#!/bin/bash"))
(add-hook
 'after-save-hook
 (lambda ()
   (if (not (= (shell-command (concat "test -x " (buffer-file-name))) 0))
       (progn
     ;; This puts message in *Message* twice, but minibuffer
     ;; output looks better.
     (message (concat "Wrote " (buffer-file-name)))
     (save-excursion
       (goto-char (point-min))
       ;; Always checks every pattern even after
       ;; match.  Inefficient but easy.
       (dolist (my-shebang-pat my-shebang-patterns)
         (if (looking-at my-shebang-pat)
         (if (= (shell-command
             (concat "chmod u+x " (buffer-file-name)))
            0)
             (message (concat
                   "Wrote and made executable "
                   (buffer-file-name))))))))
     ;; This puts message in *Message* twice, but minibuffer output
     ;; looks better.
     (message (concat "Wrote " (buffer-file-name))))))

;; 保存前に行末の空白を削除する
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)

;; 最終行に改行を必ず入れる
;; (setq require-final-newline t)

