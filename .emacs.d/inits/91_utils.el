;; my extensions

(setq transient-mark-mode t)

;; ファインダーで今開いてるディレクトリを開く
(defun open-current-dir-with-finder ()
  (interactive)
  (shell-command (concat "open .")))

;; listenonrepeatを開く
(defun bgm ()
 (interactive)
 (shell-command (concat "open http://www.listenonrepeat.com/")))

;; コマンドを入力する
(defun input-command ()
  (interactive)
  (with-current-buffer (get-buffer-create "*output*")
    (erase-buffer)
    (shell-command (concat (read-string "input command:" "")) :buffer))
  (pop-to-buffer "*output*"))

(defvar query "")
(defvar start-index 1)
(defvar is_focused nil)

(defun youtube-search ()
  (interactive)
  (setq query (read-string "input-query:" ""))
  (setq start-index 1)
  (youtube-search-by-query)
)

;; youtube検索結果を取得
(defun youtube-search-by-query ()
  (let ((url-request-method "GET")
        (curl-command (concat "curl -s \'http://gdata.youtube.com/feeds/api/videos?q=" (replace-regexp-in-string " " "+" query) "\&orderby=viewCount\&start-index=" (number-to-string start-index) "\'"))
        (buffer (get-buffer-create "*youtube*")))
    (with-current-buffer buffer
      (setq buffer-read-only nil)
      (use-local-map youtube-mode-map);list-methods-mode-mapをキーマップとして使う
      ;(setq major-mode 'org-mode);major-mode を設定
      ;(setq mode-name "org-mode");モード名を設定
      ;(run-hooks 'org-mode-hook);このモード用のフックを実行
      (erase-buffer)
      (shell-command curl-command buffer))
    (parse-youtube-xml buffer)
    )
)

(defun next-page ()
  (interactive)
  (setq start-index (+ start-index 25))
  (youtube-search-by-query)
)

(defun previous-page ()
  (interactive)
  (when (> start-index 25)
    (setq start-index (- start-index 25))
    (youtube-search-by-query)
  )
)

(require 'cl)

(defun parse-youtube-xml (buf)
  (with-current-buffer buf
    (let ((feed (libxml-parse-xml-region (point-min) (point-max))))
      (let* ((rss (cddr feed)))
        (erase-buffer)
        (loop for elm in rss
              when (and (listp elm) (eq (car elm) 'entry))
              do (insert (get-id-and-title elm))
              )))
    (setq buffer-read-only t))
  (pop-to-buffer buf)
  (beginning-of-buffer)
)

(defsubst get-id-and-title (entry)
  (let ((title (extract-tag-value 'title entry))
        (id (caddr (split-string (extract-tag-value 'id entry) "s/"))))
    (make-link id title))
)

(defsubst make-link (id title)
  (let ((url (concat "http://www.youtube.com/embed/" id "?autoplay=1&loop=1&playlist=" id)))
  (add-text-properties 0 (length url) '(invisible t) url)
  (concat title "\n" url))
)

(defsubst replace-blace (str)
  (while (string-match "\\[\\|\\]" str)
      (setq str (replace-match "" t t str)))
  str
)

(defsubst extract-tag-value (tag tree)
  (cadr (assoc-default tag tree))
)

;; youtube-mode 用のキーマップ
(defvar youtube-mode-map nil)
(unless youtube-mode-map
  (let ((map (make-sparse-keymap)));キーマップを生成
    ;; キーマップにキーとコマンドの対を設定する
    (define-key map "n" 'next-line)
    (define-key map "p" 'previous-line)
    (define-key map "f" 'next-page)
    (define-key map "b" 'previous-page)
    (define-key map "s" 'play-movie)
    (define-key map "c" 'close-movie)
    (define-key map (kbd "SPC") 'pause-or-play-movie)
    (define-key map "w" 'write-to-mp3)
    (setq youtube-mode-map map))
);youtube-mode-map に生成したキーマップを設定する

(global-set-key "\C-x\C-y" 'youtube-search)

(defun play-movie ()
  (interactive)
  (setq is_focused nil)
  (let ((point (point)))
    (next-line)
    (shell-command (concat "osascript -e "
"\'tell application \"Google Chrome\"
 if the url of active tab of window 1 contains \"youtube\" then
  set w to window 1
 else
  set w to make window
 end if
 tell w
  set URL of active tab to " (extract-link (buffer-substring point (point))) "
  set the bounds to \{900, 500, 1400, 850 \}
 end tell
end tell\'"))
  )
  (previous-line)
)

; repeat with i from 2 to \(count windows\)
;  set index of window -1 to 1
;  delay 0.5
; end repeat


(defun close-movie ()
  (interactive)
  (shell-command (concat "osascript -e "
"\'tell application \"Google Chrome\"
  repeat with i from 1 to \(count windows\)
    if the url of active tab of window i contains \"youtube\" then
      close active tab of window i
    end if
  end repeat
end tell\'"))
)

(defsubst extract-link (str)
  (concat "\"" (cadr (split-string str "\n")) "\"")
)

(defun write-to-mp3 ()
  (interactive)
  (let ((point (point)))
    (next-line)
    (youtube-to-mp3 (extract-link (buffer-substring point (point))))
    (previous-line)
  )
)

(defun pause-or-play-movie ()
  (interactive)
  (let ((close-command (if is_focused "key code 49" 
"repeat 4 times
  key code 48
end repeat
key code 36")))
  (shell-command (concat "osascript -e "
"\'tell application \"System Events\"
  set frontApp to name of first application process whose frontmost is true
  tell application \"Google Chrome\" to activate
  " close-command
"
  tell process frontApp to set frontmost to true
end tell\'")))
  (setq is_focused t)
)

(global-set-key "\C-cm" 'rotate-window)

; アーティスト名をクエリとしてjoysoundの楽曲一覧を取得
(defun joysound-search ()
  (interactive)
  (let ((buffer (get-buffer-create "*joysound*"))
        (query (read-string "input query:" "")))
    (with-current-buffer buffer
      (setq buffer-read-only nil)
      (erase-buffer)
      (shell-command (concat "python ~/test/joysound.py " query) buffer)
      (setq buffer-read-only t)
    )
  )
  (pop-to-buffer buffer)
)

; 指定されたURLのyoutube動画をmp3に変換
(defun youtube-to-mp3 (url)
  (interactive)
  (let ((filename (read-string "Input filename to write:" "")))
    (shell-command (concat "youtubetomp3 " url " " filename " &"))
  )
)

; 次/前の空行に移動する
(defun blank-line? ()
    (string-match "^\n$" (substring-no-properties (thing-at-point 'line))))

(defun move-to-next-blank-line ()
    (interactive)
      (progn (forward-line 1)
              (if (blank-line?) () (move-to-next-blank-line))))

(defun move-to-previous-blank-line ()
    (interactive)
      (progn (forward-line -1)
              (if (blank-line?) () (move-to-previous-blank-line))))

(global-set-key "\M-n" 'move-to-next-blank-line)
(global-set-key "\M-p" 'move-to-previous-blank-line)

(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; マークアップ言語全部で使う
(add-hook 'css-mode-hook  'emmet-mode) ;; CSSにも使う
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent はスペース2個
(define-key emmet-mode-keymap (kbd "C-j") 'emmet-expand-line) ;; C-j で展開

(require 'hiwin)
(hiwin-activate)                           ;; hiwin-modeを有効化
(set-face-background 'hiwin-face "gray50") ;; 非アクティブウィンドウの背景色を設定

(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode t)
(custom-set-faces '(rainbow-delimiters-depth-1-face ((t (:foreground "#7f8c8d"))))) ;; 文字列の色と被るため,変更

(require 'tabbar)
(tabbar-mode)
(global-set-key "\M-}" 'tabbar-forward)  ; 次のタブ
(global-set-key "\M-{" 'tabbar-backward) ; 前のタブ
;; タブ上でマウスホイールを使わない
(setq mouse-wheel-mode nil)
(tabbar-mwheel-mode -1)
;; グループを使わない
(setq tabbar-buffer-groups-function nil)
;; 左側のボタンを消す
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
    (set btn (cons (cons "" nil)
                   (cons "" nil))))
(defun my-tabbar-buffer-list ()
  (delq nil
        (mapcar #'(lambda (b)
                    (cond
                     ;; Always include the current buffer.
                     ((eq (current-buffer) b) b)
                     ((buffer-file-name b) b)
                     ((char-equal ?\  (aref (buffer-name b) 0)) nil)
                     ;; ((equal "*Messages*" (buffer-name b)) b) ; *Messages*バッファは表示する
                     ;; ((equal "*Shell Command Output*" (buffer-name b)) b) ; *Shell Command Output*バッファは表示する
                     ((char-equal ?* (aref (buffer-name b) 0)) nil) ; それ以外の * で始まるバッファは表示しない
                     ((equal "-daemon" (buffer-name b)) nil) ; -daemonバッファは表示しない
                     ((buffer-live-p b) b)))
                (buffer-list))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)
;; 色設定
(set-face-attribute ; バー自体の色
   'tabbar-default nil
      :background "white"
         :family "Inconsolata"
            :height 1.0)
(set-face-attribute ; アクティブなタブ
   'tabbar-selected nil
      :background "black"
         :foreground "white"
            :weight 'bold
               :box nil)
(set-face-attribute ; 非アクティブなタブ
   'tabbar-unselected nil
      :background "white"
         :foreground "black"
            :box nil)
;; 幅設定
(setq tabbar-separator '(1.5))
