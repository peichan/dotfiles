(require 'git-gutter+)
(global-git-gutter+-mode)

(require 'magit)
(eval-after-load 'magit
  '(progn
     (set-face-background 'magit-item-highlight "#000000")
     (set-face-background 'magit-diff-add "#000000")
     (set-face-background 'magit-diff-del "#000000")
     (set-face-background 'magit-diff-none "#000000")
     (set-face-background 'magit-diff-hunk-header "#000000")
     (set-face-background 'magit-diff-file-header "#000000")
     (set-face-foreground 'magit-diff-add "#40ff40")
     (set-face-foreground 'magit-diff-del "#ff4040")
     (set-face-foreground 'magit-diff-file-header "#4040ff")
     ))
