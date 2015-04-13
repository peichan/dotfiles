;;; snippet.el -- insert snippets of text into a buffer

;; Copyright (C) 2005 Pete Kazmier

;; Version: 0.2
;; Author: Pete Kazmier

;; This file is not part of GNU Emacs, but it is distributed under
;; the same terms as GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation; either version 2, or (at your
;; option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Description:

;; A quick stab at providing a simple template facility like the one
;; present in TextMate (an OSX editor).  The general idea is that a
;; snippet of text (called a template) is inserted into a buffer
;; (perhaps triggered by an abbrev), and while the point is within the
;; snippet, a special keymap is active to permit the user to cycle the
;; point to any of the defined fields (placeholders) within the
;; template via `snippet-next-field' and `snippet-prev-field'.

;; For example, the following template might be a useful while editing
;; HTML:

;;   <a href="$$">$$</a>

;; This template might be useful for python developers.  In this
;; example, reasonable defaults have been supplied:

;;   for $${element} in $${sequence}:
;;       match = $${regexp}.search($${element})

;; When a template is inserted into a buffer (could be triggered by an
;; abbrev expansion, or simply bound to some key), point is moved to
;; the first field denoted by the "$$" characters (configurable via
;; `snippet-field-identifier').  The optional default for a field is
;; specified by the "{default}" (the delimiters are configurable via
;; `snippet-field-default-beg-char' and `snippet-field-defaul-end-char'.

;; If present, the default will be inserted and highlighted.  The user
;; then has the option of accepting the default by simply tabbing over
;; to the next field (any other key bound to `snippet-next-field' in
;; `snippet-map' can be used).  Alternatively, the user can start
;; typing their own value for the field which will cause the default
;; to be immediately replaced with the user's own input.  If two or
;; more fields have the same default value, they are linked together
;; (changing one will change the other dynamically as you type).

;; `snippet-next-field' (bound to <tab> by default) moves the point to
;; the next field.  `snippet-prev-field' (bound to <S-tab> by default)
;; moves the point to the previous field.  When the snippet has been
;; completed, the user simply tabs past the last field which causes
;; the snippet to revert to plain text in a buffer.  The idea is that
;; snippets should get out of a user's way as soon as they have been
;; filled and completed.

;; After tabbing past all of the fields, point is moved to the end of
;; the snippet, unless the user has specified a place within the
;; template with the `snippet-exit-identifier' ("$." by default).  For
;; example: 

;;   if ($${test} {
;;       $.
;;   }

;; Indentation can be controlled on a per line basis by including the
;; `snippet-indent' string within the template.  Most often one would
;; include this at the beginning of a line; however, there are times
;; when indentation is better performed in other parts of the line.
;; The following shows how to use the functionality:

;;   if ($${test}) {
;;   $>this line would be indented
;;   this line will be indented after being inserted$>
;;   }

;;; Usage:

;; Snippets are inserted with the `snippet-insert' function.  This
;; function inserts the snippet into the current buffer.  It expects a
;; single argument which is the template that is to be inserted.  For
;; example:

;;   (snippet-insert "for $${element} in $${sequence}:")

;; `snippet-insert' can be called interactively in which case the user
;; is prompted for the template to insert.  This is hardly useful at
;; all unless you are testing the functionality of this code.

;; Snippets are much more effective when they are bound to expansions
;; for abbreviations.  When binding a snippet to an abbreviation, it
;; is important that you disable the insertion of the character that
;; triggered the expansion (typically some form of whitespace).  For
;; example, this is what you should NOT do:

;;   (define-abbrev python-mode-abbrev-table  ; abbrev table
;;                  "for"                     ; name
;;                  ""                        ; expansion
;;                  '(lambda ()               ; expansion hook
;;                     (snippet-insert 
;;                      "for $${element} in $${sequence}:")))

;; The above example does not work as expected because after the
;; expansion hook is called, the snippet is inserted, and the point is
;; moved to the first field.  The problem occurs because when the user
;; typed "f o r <Spc>", the "<Spc>" character is inserted after the
;; snippet has been inserted.  The point happens to be located at the
;; first field and thus the "<Spc>" will delete any field default that
;; was present.

;; Fortunately, this is easy to fix.  According to the documentation
;; for `define-abbrev', if the hook function is a symbol whose
;; `no-self-insert' property is non-nil, then hook can control whether
;; or not the insertion of the character that triggered the abbrev
;; expansion is inserted.  `insert-snippet' return                          ; expansion
;;                  'python-foo-expansion)      ; expansion hook

;; Unfortunately, this is a lot of work to define what should be a
k.

;;; Implementation Notes:

;; This is my first significant chunk of elisp code.  I have very
;; little experience coding with elisp; however, I have tried to
;; document the code for anyone trying to follow along.  Here are some
;; brief notes on the implementation.

;; When a snippet is inserted, the entire template of text has an
;; overlay applied.  This overlay is referred to as the "bound"
;; overlay in the code.  It is used to bold-face the snippet as well
;; as provide the keymap that is used while the point is located
;; within the snippet (so users can tab between fields).  This overlay
;; ist
;; should move when tab is pressed (the start of the overlay is used
;; for this purpose), as well as the hooks to delete the default value
;; if a user starts to type their own value (the modification hooks of
;; the overlay are used for this purpose).

;; Once the user has tabbed out of the snippet, all overlays are
;; deleted and the snippet then becomes normal text.  Moving the
;; cursor back into the snippet has no affect (the snippet is not
;; activated again).  The idea is that the snippet concept should get
;; out of the users way as quickly as possible.

;;; Comparpand', when the text is
;;   inserted, it blows away a lot of the snippet.  Not sure why yet.
;; - Python mode indentation is strange.  Offer a flag to do the
;;   indentation after the insertion.
;; - Fix the space issue

;;; Code:

(require 'cl)

(defgroup snippet nil 
  "Insert a template with fields that con contain optional defaults."
  :prefix "snip 'character
  :group 'snippet)

(defcustom snippet-field-default-e`snippet-bound-face' as well as the keymap that
enables tabbing between fields.

The FIELDS slot contains a list of overlays used to indicate the
position of each field.  In addition, if a field has a default, t 'keymap snippet-map)
    (overlay-put bound 'face snippet-bound-face)
    (overlay-put bound 'modification-hooks '(snippet-bound-modified))
    bound))

(defun snippet-make-field-overlay (&optional name)
  "Create an overlay for a field in a snippet.  
Add the appropriate properties for the overlay to provide: a face used
toe)))
    field))

(defun snippet-fields-with-name (name)
  "Return a list of fields whose name property is equal to NAME."
  (loop for field in (snippet-fields snippet) 
        when (eq name (overlay-get field 'name))
        collect field))

(defun snippet-bound-modified (bound after beg end &optional change)
  "Ensure theault."
  (let ((inhibit-modification-hooks t))
    (when (not after)
      (delete-region (overlay-start field) (overlay-end field)))))

(defun snippet-field-modified (field after beg end &optional change)
  "Shrink the field overlay.
This modification hook is triggered when a user starts to type when
the point i((name (overlay-get field 'name))
        (value (buffer-substring (overlay-start field) (overlay-end field)))
        (inhibit-modification-hooks t))
    (when (and name after)
      (save-excursion
        (dolist (like-field (set-difference (snippet-fields-with-name name) 
                                            by `snippet-exit-identifier',
and the snippet reverts to normal text."
  (interactive)
  (let* ((bound (snippet-bound snippet))
         (fields (snippet-fields snippet))
         (exit (snippet-exit-marker snippet))
         (next-pos (loop for field in fields
                         foptional separators include-separators-p)
  "Split STRING into substrings and separators at SEPARATORS.
Return a list of substrings and optional include the separators in the
list if INCLUDE-SEPARATORS-P is non-nil."
  (let ((start 0) (list '()))
    (while (string-match (or separatos which are
specified by `snippet-field-identifier'.  Fields may optionally also
include default values delimited by `snippet-field-default-beg-char'
and `snippet-field-default-end-char'.

For example, the following template specifies two fields which have
the default values of \"element\" and \"sequence\":

  \"for $${element} in $${sequence}:\"

In the next example, only one field is specified and no default has
been provided:

  \"import $$\"

This function may be called interactively, in which case, the TEMPLATE
is prompted for.  However, users do not typinter larger than the template body text.
  ;; This enables our keymap to be active when a field happens to be
  ;; the last item in a template.  We disable abbrev mode to prevent
  ;; our template from triggering another abbrev expansion (I do not
  ;; know if the use of `insert' will actually trigger abbrevs).
  (let ((abbrev-mode nil))
    (setq snippet (make-snippet :bound (snippet-make-bound-overlay)))
    (let ((start (point))
          (count 0))
      (he end of the
    ;; snippet. 
    (goto-char (overlay-start (snippet-bound snippet)))
    (while (re-search-forward (regexp-quote snippet-exit-identifier)
                              (overlay-end (snippet-bound snippet)) 
                              t)
      (replace-match "")
      (setf (snippet-exit-marker snippet) (point-marker)))
    
    (unless (snippet-exit-marker snippet)
      (let ((end (overlay-end (snippet-bound snippet))))
        (goto-char (if (= end (point-ble-suffix (str)
  "Strip a suffix of \"-abbrev-table\" if one is present."
  (if (string-match "^\\(.*\\)-abbrev-table$" str)
      (match-string 1 str)
      str))

(defun snippet-make-abbrev-expansion-hook (abbrev-table abbrev-name template)
  "Define a function with te
                      template)
             (snippet-insert ,template)))
    (put abbrev-expansion 'no-self-insert t)
    abbrev-expansion))

(defmacro snippet-abbrev (abbrev-table abbrev-name template)
  "Establish an abbrev for a snippet template.
Set up an abbreviation called ABBREV-NAME in the ABBRo snippet-with-abbrev-table (abbrev-table &rest snippet-alist)
  "Establish a set of abbrevs for snippet templates.
Set up a series of snippet abbreviations in the ABBREV-TABLE (note
that ABBREV-TABLE must be quoted.  The abbrevs are specified in
SNIPPET-ALIST.  For example:

  (snippet-with-ab