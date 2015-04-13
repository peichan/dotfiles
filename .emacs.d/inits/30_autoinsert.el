;; *autoinsert*************************************************************
(require 'autoinsert)
;; テンプレートのディレクトリ
(setq auto-insert-directory "~/.emacs.d/template/")
(setq auto-insert-alist
      (nconc '(
               ("\\.cpp$" . ["template.cpp" my-template])
               ("\\.pl$"   . ["template.pl" my-template])
               ("\\.pm$"   . ["template.pm" my-template])
               ("\\.t$"   . ["template.t" my-template])
               ) auto-insert-alist))

(require 'cl)
(defvar template-replacements-alists
  '(
    ("%file%"             . (lambda () (file-name-nondirectory (buffer-file-name))))
    ("%file-without-ext%" . (lambda () (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    ("%include-guard%"    . (lambda () (format "__SCHEME_%s__" (upcase (file-name-sans-extension (file-name-nondirectory buffer-file-name))))))
    ("%author%" . (lambda()(identity user-full-name)))
    ("%email%"  . (lambda()(identity user-mail-address)))))

(defun my-template ()
  (time-stamp)
  (mapc #'(lambda(c)
            (progn
              (goto-char (point-min))
              (replace-string (car c) (funcall (cdr c)) nil)))
        template-replacements-alists)
  (goto-char (point-max))
  (message "done."))
(add-hook 'find-file-not-found-hooks 'auto-insert)
