(require 'powerline)

(set-face-attribute 'mode-line nil
                    :foreground "#fff"
                    :background "#0C4C3D"
                    :box nil)
(set-face-attribute 'powerline-active1 nil
                    :foreground "#fff"
                    :background "#147A62"
                    :inherit 'mode-line)
(set-face-attribute 'powerline-active2 nil
                    :foreground "#fff"
                    :background "#0E5444"
                    :inherit 'mode-line)

(defun my/powerline-center-theme ()
  "Setup a mode-line with major and minor modes centered."
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (mode-line (if active 'mode-line 'mode-line-inactive))
                          (face1 (if active 'powerline-active1 'powerline-inactive1))
                          (face2 (if active 'powerline-active2 'powerline-inactive2))
                          (separator-left (intern (format "powerline-%s-%s"
                                                          powerline-default-separator
                                                          (car powerline-default-separator-dir))))
                          (separator-right (intern (format "powerline-%s-%s"
                                                           powerline-default-separator
                                                           (cdr powerline-default-separator-dir))))
                          (lhs (list (powerline-raw "%*" nil 'l)
                                     (powerline-buffer-size nil 'l)
                                     (powerline-raw " ")
                                     (powerline-raw mode-line-mule-info nil 'l)
                                     (powerline-buffer-id nil 'l)
                                     (powerline-raw " ")
                                     (funcall separator-left mode-line face1)
                                     (powerline-narrow face1 'l)
                                     (powerline-vc face1)
                                     (powerline-raw "%5l" face1 'r)
                                     (powerline-raw ":" face1)
                                     (powerline-raw "%3c" face1 'r)
                                     ))
                          (rhs (list (powerline-raw global-mode-string face1 'r)
                                     (funcall separator-right face1 mode-line)
                                     (powerline-raw "%6p" nil 'r)
                                     (powerline-hud face2 face1)))
                          (center (list (powerline-raw " " face1)
                                        (funcall separator-left face1 face2)
                                        (when (boundp 'erc-modified-channels-object)
                                          (powerline-raw erc-modified-channels-object face2 'l))
                                        (powerline-major-mode face2 'l)
                                        (powerline-process face2)
                                        (powerline-raw ":" face2)
                                        (powerline-minor-modes face2 'l)
                                        (powerline-raw " " face2)
                                        (funcall separator-right face2 face1)
                                        )))
                     (concat (powerline-render lhs)
                             (powerline-fill-center face1 (/ (powerline-width center) 2.0))
                             (powerline-render center)
                             (powerline-fill face1 (powerline-width rhs))
                             (powerline-render rhs)))))))

;;; modeの名前を自分で再定義
(defvar mode-line-cleaner-alist
  '( ;; For minor-mode
    (abbrev-mode . "")
    (anzu-mode . "")
    (auto-highlight-symbol-mode . "")
    (eldoc-mode . "")
    (flycheck-mode . "Fly")
    (git-gutter+-mode . "")
    (guide-key-mode . "")
    (helm-descbinds-mode . "")
    (helm-gtags-mode . "")
    (helm-mode . "")
    (magit-auto-revert-mode . "")
    (paredit-mode . "")
    (undo-tree-mode . "")
    (yas-minor-mode . "")

    ;; Major modes
    (fundamental-mode . "fund")
    (dired-mode . "dir")
    (lisp-interaction-mode . "li")
    (cperl-mode . "pl")
    (python-mode . "py")
    (ruby-mode   . "rb")
    (emacs-lisp-mode . "el")
    (markdown-mode . "md")))

(defun clean-mode-line ()
  (interactive)
  (loop for (mode . mode-str) in mode-line-cleaner-alist
        do
        (let ((old-mode-str (cdr (assq mode minor-mode-alist))))
          (when old-mode-str
            (setcar old-mode-str mode-str))
          ;; major mode
          (when (eq mode major-mode)
            (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)

(my/powerline-center-theme)
