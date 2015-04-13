(require 'helm)
(require 'helm-config)
(require 'helm-ag)
(require 'helm-open-github)
(require 'helm-descbinds)
(require 'helm-files)

(helm-descbinds-mode)
(helm-mode 1)

;; List files in git repos
(defvar helm-git-project-dir nil)

(defun git-project:root-dir ()
  (file-name-directory (file-truename
                        (shell-command-to-string "git rev-parse --git-dir"))))

(defun helm-git-project:create-source (name options)
  `((name . ,(concat "Git Project " name))
    (init . (lambda ()
              (setq helm-git-project-dir (git-project:root-dir))
              (let ((buffer (helm-candidate-buffer 'global))
                    (args (format "ls-files --full-name %s %s"
                                  ,options helm-git-project-dir)))
                (call-process-shell-command "git" nil buffer nil args))
              ))
    (display-to-real . (lambda (c) (concat helm-git-project-dir c)))
    (candidates-in-buffer)
    (action ("Find  File" . find-file))))

(defvar helm-c-source-git-project-for-modified
  (helm-git-project:create-source "Modified files" "--modified"))
(defvar helm-c-source-git-project-for-untracked
  (helm-git-project:create-source "Untracked files" "--others --exclude-standard"))
(defvar helm-c-source-git-project-for-all
  (helm-git-project:create-source "All files" ""))

(defun helm-git-project ()
  (interactive)
  (let ((sources '(helm-c-source-git-project-for-modified
                   helm-c-source-git-project-for-untracked
                   helm-c-source-git-project-for-all)))
    (helm-other-buffer sources
                       (format "*Helm git project in %s*" default-directory))))

(defun my/helm-etags-select (arg)
  (interactive "P")
  (let ((tag  (helm-etags-get-tag-file))
        (helm-execute-action-at-once-if-one t))
    (when (or (equal arg '(4))
              (and helm-etags-mtime-alist
                   (helm-etags-file-modified-p tag)))
      (remhash tag helm-etags-cache))
    (if (and tag (file-exists-p tag))
        (helm :sources 'helm-source-etags-select :keymap helm-etags-map
              :input (concat (thing-at-point 'symbol) " ")
              :buffer "*helm etags*"
              :default (concat "\\_<" (thing-at-point 'symbol) "\\_>"))
      (message "Error: No tag file found, please create one with etags shell command."))))

(defun build-ctags ()
  (interactive)
  (message "building project tags")
  (let
      (
       (lang (read-string "language? "))
       (root (vc-git-root default-directory))
       )
    (shell-command (concat "ctags --languages=" lang " -e --verbose -R --fields=\"+afikKlmnsSzt\" --exclude=bin --exclude=log --exclude=static --exclude=db --exclude=public --exclude=.git --exclude=modules --exclude=vendor -f " root "TAGS " root)))
  (visit-project-tags)
  (message "tags built successfully"))

(defun visit-project-tags ()
  (interactive)
  (let ((tags-file (concat (vc-git-root default-directory) "TAGS")))
    (visit-tags-table tags-file)
    (message (concat "Loaded " tags-file))))

;; customize colors
(custom-set-faces
 '(helm-grep-cmd-line ((t (:foreground "color-31"))))
 '(helm-grep-match ((t (:foreground "brightblue"))))
 '(helm-match ((t (:foreground "color-33"))))
 '(helm-selection ((t (:background "color-17" :underline t))))
 '(helm-source-header ((t (:background "color-22" :foreground "brightwhite" :weight bold :height 1.3 :family "Sans Serif"))))
 '(helm-visible-mark ((t (:background "color-17")))))

(define-key global-map "\C-x@" 'my/helm-etags-select)
(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)
(define-key global-map (kbd "\C-xg") 'helm-git-project)
(global-set-key "\C-xf" 'helm-mini)
