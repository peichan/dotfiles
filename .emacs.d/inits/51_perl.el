;; *perl******************************************************************
;; Perl用設定
(defalias 'perl-mode 'cperl-mode)
(add-to-list 'auto-mode-alist '("\\.t$" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.psgi$" . cperl-mode))

(eval-after-load "cperl-mode"
  '(progn
     (helm-perldoc:setup)))
;; auto carton setup
(add-hook 'cperl-mode-hook 'helm-perldoc:carton-setup)

(add-hook 'cperl-mode-hook
          (function (lambda ()
                      (require 'perlbrew)
                      (perlbrew-switch "perl-5.14.2")
                      (require 'set-perl5lib)
                      (set-perl5lib)
                      (set-face-background 'cperl-hash-face "black")
                      (set-face-foreground 'cperl-hash-face "#66cdaa")
                      (set-face-background 'cperl-array-face "black")
                      (set-face-foreground 'cperl-array-face "#66aacd")
                      (setq cperl-continued-statement-offset 4
                            cperl-indent-level 4
                            cperl-tab-always-indent t
                            cperl-close-paren-offset -4
                            cperl-indent-parens-as-block t)
                      )))

;;perlのsyntaxチェック
(defun perl-syntax-check()
  (interactive)
  (shell-command
   (concat "perl -wc " (file-name-nondirectory (buffer-file-name)))))

;; テスト実行
(defun run-perl-test ()
  "test実行します"
  (interactive)
  (compile (format "cd %s; carton exec -- perl %s" (vc-git-root default-directory) (buffer-file-name (current-buffer)))))

;; テスト実行
(defun run-perl-method-test ()
  (interactive)
  (let (
        (command compile-command)
        (test-method nil))
    (save-excursion
      (when (or
             (re-search-backward "\\bsub\s+\\([_[:alpha:]]+\\)\s*:\s*Test" nil t)
             (re-search-forward "\\bsub\s+\\([_[:alpha:]]+\\)\s*:\s*Test" nil t))
        (setq test-method (match-string 1))))
    (if test-method
        (compile
         (format
          "cd %s; TEST_METHOD=%s perl -M'Project::Libs lib_dirs => [qw(modules/*/lib local/lib/perl5)]' %s"
          (replace-regexp-in-string
           "\n+$" ""
           (shell-command-to-string "git rev-parse --show-cdup"))
          test-method
          (buffer-file-name (current-buffer))))

      (compile
       (format
        "cd %s; perl -M'Project::Libs lib_dirs => [qw(modules/*/lib local/lib/perl5)]' %s"
        (replace-regexp-in-string
         "\n+$" "" (shell-command-to-string "git rev-parse --show-cdup"))
        (buffer-file-name (current-buffer)))))))

(defun run-perl-region ()
  "指定範囲内のコードをスクリプトとして実行します"
  (interactive)
  (if (>= (region-beginning) (region-end))
      (message "no selected region")
    (let ((run-perl-region-buffer-file-path "/tmp/run-perl-region"))
      (write-region (region-beginning) (region-end) run-perl-region-buffer-file-path nil)
      (compile
       (format
        "cd %s; perl -M'Project::Libs lib_dirs => [qw(modules/*/lib local/lib/perl5)]' %s"
        (vc-git-root default-directory)
        run-perl-region-buffer-file-path)))))

(defun cpanfile--check ()
  (let ((file (buffer-file-name)))
    (unless (executable-find "scan-prereqs-cpanfile")
      (error "Please 'cpanm App::scan_prereqs_cpanfile' !!"))
    (unless (and file (string= (file-name-nondirectory file) "cpanfile"))
      (error "This is not 'cpanfile'"))))

(defun cpanfile-insert ()
  (interactive)
  (cpanfile--check)
  (save-buffer)
  (let ((cmd "scan-prereqs-cpanfile"))
    (insert (with-temp-buffer
              (unless (zerop (call-process-shell-command cmd nil t))
                (error "Failed %s" cmd))
              (buffer-string)))))

(defun cpanfile-diff ()
  (interactive)
  (cpanfile--check)
  (let ((cmd (format "scan-prereqs-cpanfile --diff=cpanfile"))
        (curdir default-directory))
    (with-current-buffer (get-buffer-create "*perl-cpanfile*")
      (erase-buffer)
      (let ((default-directory curdir))
        (unless (zerop (call-process-shell-command cmd nil t))
          (error "Failed %s" cmd)))
      (pop-to-buffer (current-buffer))
      (goto-char (point-min)))))
