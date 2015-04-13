(require 'smartchr)

(defun my-smartchr-cperl-setting ()
  (local-set-key (kbd "D") (smartchr '("D" "use Data::Dumper;sub d{ warn Dumper @_ };\n" "DD")))
  )

(add-hook 'cperl-mode-hook
          (function (lambda ()
                      (my-smartchr-cperl-setting)
                      )))
