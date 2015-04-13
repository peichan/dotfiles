;; Keyjack *****************************************************************
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-c\C-_" 'comment-region)
(global-set-key "\C-c/" 'uncomment-region)
(global-set-key "\C-x\C-b" 'buffer-menu)
(global-set-key "\C-xx" 'compile)
(global-set-key "\C-x\C-x" 'recompile)
(global-set-key "\C-xp" (lambda () (interactive) (other-window -1)))
(global-set-key "\C-x\C-r" 'recentf-open-files)

;;; 検索置換
(global-set-key (kbd "C-x C-g") 'git-grep)
(global-set-key (kbd "C-c r") 'replace-string)
(global-set-key (kbd "C-c R") 'anzu-query-replace)

;; magit
(global-set-key "\C-xm" 'magit-status)

;; sequential-command
(require 'sequential-command-config)
;; C-aに割り当てる設定
(define-sequential-command seq-home
  beginning-of-line beginning-of-buffer seq-return)
(define-sequential-command seq-end
  end-of-line end-of-buffer seq-return)
(global-set-key "\C-a" 'seq-home)
(global-set-key "\C-e" 'seq-end)
(when (require 'org nil t)
  (define-key org-mode-map "\C-a" 'org-seq-home)
  (define-key org-mode-map "\C-e" 'org-seq-end))
