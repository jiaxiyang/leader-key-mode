;;; leader-key-mode.el --- a minor mode to mimic leader key in VIM  -*- lexical-binding: t; -*-

;; Copyright (C) 2017  wangchunye

;; Author: wangchunye <wcy123@gmail.com>
;; Keywords: extensions, emulations
;; Version: 0.0
;; Package-Version: 0.0
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; usage
;; (require 'leader-key-mode)
;;
;; to add your own bindings
;;
;; (define-key leader-key-mode-keymap (kbd "O") 'your-faverite-command)
;;
;;; Code:

(defmacro leader-key-mode-kbd (key)
  (kbd key))

(defvar leader-key (leader-key-mode-kbd ",")
  "the default leader key")
;;;###autoload
(define-minor-mode leader-key-mode
  "Minor mode to support <leader> support." t)

(defmacro leader-key-mode--replay(str)
  "this macro is used to bind one key sequence to another key sequence."
  `#'(lambda () (interactive)
       (let* ((leader-key-mode)
              (seq ,(kbd str))
              (cmd (key-binding seq)))
         (cond
          ((eq cmd 'self-insert-command) (insert seq))
          (t (call-interactively cmd))))))

(defvar leader-key-mode-mark-active-keymap
  (let ((m (make-sparse-keymap)))
    (define-key m (leader-key-mode-kbd ";")  'er/expand-region)
    (define-key m (leader-key-mode-kbd "M-;")  'er/expand-region)
    (define-key m (leader-key-mode-kbd "M-m")  'set-mark-command)
    (define-key m (leader-key-mode-kbd "m")  'set-mark-command)
    (define-key m (leader-key-mode-kbd "'")  'er/contract-region)
    (define-key m (leader-key-mode-kbd "M-'")  'er/contract-region)
    (define-key m (leader-key-mode-kbd "g")  'keyboard-quit)
    (define-key m (leader-key-mode-kbd "d")  'leader-key-mode--delete-region)
    (define-key m (leader-key-mode-kbd "j") 'next-line)
    (define-key m (leader-key-mode-kbd "n") 'next-line)
    (define-key m (leader-key-mode-kbd "k") 'previous-line)
    (define-key m (leader-key-mode-kbd "l") 'forward-char)
    (define-key m (leader-key-mode-kbd "h") 'backward-char)
    (define-key m (leader-key-mode-kbd "o") 'exchange-point-and-mark)
    (define-key m (leader-key-mode-kbd "c") 'kill-ring-save)
    (define-key m (leader-key-mode-kbd "w") 'kill-ring-save)
    (define-key m (leader-key-mode-kbd "x")  'kill-region)
    (define-key m (leader-key-mode-kbd "y")  'leader-key-mode--delete-and-yank)
    (define-key m (leader-key-mode-kbd "a")  'mark-whole-buffer)
    (define-key m (leader-key-mode-kbd "f")  'mark-defun)
    ;; (define-key m (leader-key-mode-kbd "f")  'forward-sexp)
    (define-key m (leader-key-mode-kbd "b")  'backward-sexp)
    (define-key m (leader-key-mode-kbd "u")  'backward-up-list)
    (define-key m (leader-key-mode-kbd "s")  #'(lambda()
                                                 (interactive)
                                                 (leader-key-mode-select-thing-at-point
                                                  'sexp)))
    (define-key m (leader-key-mode-kbd "i")  #'(lambda()
                                                 (interactive)
                                                 (leader-key-mode-select-thing-at-point
                                                  'line)))
    (define-key m (leader-key-mode-kbd "p")  #'(lambda()
                                                 (interactive)
                                                 (leader-key-mode-select-thing-at-point
                                                  'sentence)))
    m))

(defvar leader-key-mode-keymap
  (let ((m (make-sparse-keymap)))
    (define-key m (leader-key-mode-kbd "f") 'ace-jump-char-mode)
    (define-key m (leader-key-mode-kbd "g g") 'goto-last-change)
    (define-key m (leader-key-mode-kbd "g l") 'goto-last-change-reverse)
    (define-key m (leader-key-mode-kbd "g d") 'xref-find-definitions)
    (define-key m (leader-key-mode-kbd "g b") 'xref-pop-marker-stack)
    (define-key m (leader-key-mode-kbd "g r") 'xref-find-references)
    (define-key m (leader-key-mode-kbd "g v") 'avy-copy-region)
    (define-key m (leader-key-mode-kbd "g x") 'avy-kill-region)
    (define-key m (leader-key-mode-kbd "x s") 'save-buffer)
    (define-key m (leader-key-mode-kbd "x c") 'save-buffers-kill-terminal)
    ;; (define-key m (leader-key-mode-kbd "x x") 'counsel-M-x)
    (define-key m (leader-key-mode-kbd "y y ") 'company-yasnippet)
    (define-key m (leader-key-mode-kbd "y l") 'yas-describe-tables)
    (define-key m (leader-key-mode-kbd "y f") 'yas-visit-snippet-file)
    (define-key m (leader-key-mode-kbd "t t") 'google-translate-at-point)
    (define-key m (leader-key-mode-kbd "t e") 'insert-translated-name-replace)
    (define-key m (leader-key-mode-kbd "t i") 'insert-translated-name-insert)
    (define-key m (leader-key-mode-kbd "s s") 'counsel-find-file)
    (define-key m (leader-key-mode-kbd "u u") 'undo-tree-undo)
    (define-key m (leader-key-mode-kbd "u c") 'upcase-char)
    (define-key m (leader-key-mode-kbd "u w") 'upcase-word)
    (define-key m (leader-key-mode-kbd "l c") 'downcase-char)
    (define-key m (leader-key-mode-kbd "l w") 'downcase-word)
    (define-key m (leader-key-mode-kbd "r d") 'undo-tree-redo)
    (define-key m (leader-key-mode-kbd "r r") 'cargo-process-repeat)
    (define-key m (leader-key-mode-kbd "c b") 'cargo-process-build)
    (define-key m (leader-key-mode-kbd "c r") 'cargo-process-run)
    (define-key m (leader-key-mode-kbd "c t") 'cargo-process-test)
    (define-key m (leader-key-mode-kbd "r e") 'rust-goto-format-problem)
    (define-key m (leader-key-mode-kbd "r p") 'query-replace)
    (define-key m (leader-key-mode-kbd "r g") 'rg)
    (define-key m (leader-key-mode-kbd "j s") 'point-to-register)
    ;;(define-key m (leader-key-mode-kbd "j j") 'jump-to-register)
    (define-key m (leader-key-mode-kbd "j j") 'counsel-register)
    (define-key m (leader-key-mode-kbd "m m") 'counsel-bookmark)
    (define-key m (leader-key-mode-kbd "m c") 'mc/edit-lines)
    ;;(define-key m (leader-key-mode-kbd "b") (leader-key-mode--replay "C-x b"))
    (define-key m (leader-key-mode-kbd "b b") 'ivy-switch-buffer)
    (define-key m (leader-key-mode-kbd "b l") 'ibuffer)
    (define-key m (leader-key-mode-kbd "d l") 'md-duplicate-down)
    (define-key m (leader-key-mode-kbd "d s") 'my-desktop-save)
    (define-key m (leader-key-mode-kbd "l l") 'leetcode)
    (define-key m (leader-key-mode-kbd "l t") 'leetcode-try)
    (define-key m (leader-key-mode-kbd "l s") 'leetcode-submit)
    (define-key m (leader-key-mode-kbd "l q") 'leetcode-quit)
    (define-key m (leader-key-mode-kbd "w w") 'eyebrowse-switch-to-window-config)
    (define-key m (leader-key-mode-kbd "w s") 'eyebrowse-create-window-config)
    (define-key m (leader-key-mode-kbd "w r") 'eyebrowse-rename-window-config)
    (define-key m (leader-key-mode-kbd "w n") 'eyebrowse-next-window-config)
    (define-key m (leader-key-mode-kbd "w p") 'eyebrowse-prev-window-config)
    (define-key m (leader-key-mode-kbd "w l") 'eyebrowse-last-window-config)
    (define-key m (leader-key-mode-kbd "w k") 'eyebrowse-close-window-config)
    (define-key m (leader-key-mode-kbd "w t") 'toggle-windows-split)
    (define-key m (leader-key-mode-kbd "w c") 'transpose-windows)
    (define-key m (leader-key-mode-kbd "k k") 'kill-this-buffer)
    (define-key m (leader-key-mode-kbd "c c") 'compile)
    (define-key m (leader-key-mode-kbd "c l") 'comment-line)
    (define-key m (leader-key-mode-kbd "c e") 'comment-dwim)
    (define-key m (leader-key-mode-kbd "p a") 'sp-beginning-of-sexp)
    (define-key m (leader-key-mode-kbd "p e") 'sp-end-of-sexp)
    (define-key m (leader-key-mode-kbd "p w") 'sp-wrap-round)
    (define-key m (leader-key-mode-kbd "p u") 'sp-unwrap-sexp)
    (define-key m (leader-key-mode-kbd "d d") 'projectile-find-file)
    (define-key m (leader-key-mode-kbd "p p") 'projectile-switch-project)
    (define-key m (leader-key-mode-kbd "e e") 'my-projectile-grep)
    (define-key m (leader-key-mode-kbd "p g") 'my-projectile-grep)
    (define-key m (leader-key-mode-kbd "n s") 'symbol-overlay-switch-forward)
    (define-key m (leader-key-mode-kbd "p s") 'symbol-overlay-switch-backward)
    (define-key m (leader-key-mode-kbd "n e") 'next-error)
    (define-key m (leader-key-mode-kbd "e n") 'next-error)
    (define-key m (leader-key-mode-kbd "e p") 'previous-error)
    (define-key m (leader-key-mode-kbd "o m") 'outline-minor-mode)
    (define-key m (leader-key-mode-kbd "o a") 'outline-show-all)
    (define-key m (leader-key-mode-kbd "o c") 'outline-show-children)
    (define-key m (leader-key-mode-kbd "o s") 'outline-show-subtree)
    (define-key m (leader-key-mode-kbd "o h") 'outline-hide-other)
    (define-key m (leader-key-mode-kbd "o o") 'hydra-origami/body)
    (define-key m (leader-key-mode-kbd "i i") 'imenu-list-smart-toggle)
    ;;(define-key m (leader-key-mode-kbd ":") pp-eval-expression)
    ;;(define-key m (leader-key-mode-kbd "SPC") 'set-mark-command)
    (define-key m (leader-key-mode-kbd "/") 'dabbrev-expand)
    (define-key m (leader-key-mode-kbd "?") 'hippie-expand)
    (define-key m (leader-key-mode-kbd "`") 'next-error)
    (define-key m (leader-key-mode-kbd "=") 'leader-key-mode-save-or-jump-to-point)
    (define-key m (leader-key-mode-kbd "1") 'delete-other-windows)
    (define-key m (leader-key-mode-kbd "2") '(lambda ()
                                               (interactive)
                                               (split-window-below)
                                               (let ((target-window (next-window)))
                                                 (set-window-buffer target-window (other-buffer))
                                                 (select-window target-window))))
    (define-key m (leader-key-mode-kbd "3") '(lambda ()
                                               (interactive)
                                               (split-window-right)
                                               (let ((target-window (next-window)))
                                                 (set-window-buffer target-window (other-buffer))
                                                 (select-window target-window))))

    ;; (define-key m (leader-key-mode-kbd "3") #'(lambda()
    ;;                                             (interactive)
    ;;                                             (point-to-register 'a)))
    (define-key m (leader-key-mode-kbd "4") 'dired-jump-other-window)
    (define-key m (leader-key-mode-kbd "5") 'leader-key-mode--display-buffer-name)
    (define-key m (leader-key-mode-kbd "7") 'compile)
    (define-key m (leader-key-mode-kbd "SPC") #'(lambda ()
                                                 (interactive)
                                                  (insert ",")
                                                  (insert " ")))
    (define-key m (leader-key-mode-kbd ",") #'(lambda ()
                                                 (interactive)
                                                 (switch-to-buffer
                                                  (other-buffer))))
    (define-key m (leader-key-mode-kbd ".") 'find-tag)
    (define-key m (leader-key-mode-kbd "(") 'insert-parentheses)
    (define-key m (leader-key-mode-kbd "\"") #'(lambda (arg) (interactive "P") (insert-pair arg 34 34)))
    (define-key m (leader-key-mode-kbd "[") #'(lambda (arg) (interactive "P") (insert-pair arg 91 93)))
    (define-key m (leader-key-mode-kbd "}") (leader-key-mode--replay "\\"))
    (define-key m (leader-key-mode-kbd "[") #'(lambda (arg) (interactive "P")
                                                (insert-pair arg 91 93)))
    (define-key m (leader-key-mode-kbd "]") (leader-key-mode--replay "\\"))
    (define-key m (leader-key-mode-kbd "{") #'(lambda (arg) (interactive "P") (insert-pair arg 123 125)))
    (define-key m (leader-key-mode-kbd "}") 'wcy-complete)
    m))

(defun leader-key-mode-create-entry-keymap (key)
  "It is a helper function.
it is used to create a keymap which bound to the leader key.

KEY is default to \"\\\" which is the leader key."
  (let ((m (make-sparse-keymap)))
    (define-key m key leader-key-mode-keymap)
    m))

(defconst leader-key-mode--emulation-mode-map-alist
  `((mark-active ,@leader-key-mode-mark-active-keymap)
    (leader-key-mode ,@(leader-key-mode-create-entry-keymap leader-key)))
  "an alist which will be added into `emulation-mode-map-alists`.")
(add-to-list 'emulation-mode-map-alists
             'leader-key-mode--emulation-mode-map-alist)


(defun leader-key-mode--delete-region (b e)
  "Delete the current region.
B is the beginning of the region.  E is the end of the region."
  (interactive "r")
  (delete-region b e))

(defun leader-key-mode--duplicate-line()
  "duplicate a line, and keep cursor's posistion in the line."
  (interactive)
  (let* ((b (line-beginning-position))
         (e (line-end-position))
         (c (point))
         (l (- c b))
         (txt (buffer-substring b e)))
    (forward-line)
    (save-excursion
      (insert txt "\n"))
    (forward-char l)))

(defun leader-key-mode--delete-and-yank (b e)
  "Delete the current region, and then yank(paste).
This is common convention for many editors.  B is the beginnin of
  the region and E is the end of the region."
  (interactive "r")
  (delete-region b e)
  (call-interactively 'yank))

(defun leader-key-mode--display-buffer-name ()
  "Display the full path of the current buffer-file."
  (interactive)
  (message (or (buffer-file-name (current-buffer))
               (format "%s[%s]" default-directory (buffer-name)))))

(defun leader-key-mode-select-thing-at-point(thing)
  (interactive "")
  (let* ((bounds
          (bounds-of-thing-at-point thing))
         (b (car bounds))
         (e (cdr bounds)))
    (when bounds
      (goto-char b)
      (set-mark-command nil)
      (goto-char e))
    ))

(defun leader-key-mode-select-symbol-at-point()
  (interactive "")
  (leader-key-mode-select-thing-at-point 'sexp))

(defun leader-key-mode-save-or-jump-to-point()
  (interactive "")
  (let ((r (get-register 'a)))
    (if (markerp r)
        (progn
          (jump-to-register 'a)
          (message "jump to register")
          (set-register 'a nil))
      (message "save point to register")
      (point-to-register 'a))))

;; jiaxiyang's config
;; Toggle between split windows and a single window
(defun toggle-windows-split()
  "Switch back and forth between one window and whatever split of windows we might have in the frame. The idea is to maximize the current buffer, while being able to go back to the previous split of windows in the frame simply by calling this command again."
  (interactive)
  (if (not (window-minibuffer-p (selected-window)))
      (progn
        (if (< 1 (count-windows))
            (progn
              (window-configuration-to-register ?u)
              (delete-other-windows))
          (jump-to-register ?u))))
  (my-iswitchb-close))

;; Note: you may also need to define the my-iswitchb-close function
;; created by Ignacio as well: http://emacswiki.org/emacs/IgnacioPazPosse
(defun my-iswitchb-close()
 "Open iswitchb or, if in minibuffer go to next match. Handy way to cycle through the ring."
 (interactive)
 (if (window-minibuffer-p (selected-window))
    (keyboard-escape-quit)))

;; https://emacs.stackexchange.com/questions/318/switch-window-split-orientation-fastest-way
(defun transpose-windows ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(defun split-window-func-with-other-buffer (split-function)
  (lambda (&optional arg)
    "Split this window and switch to the new window unless ARG is provided."
    (interactive "P")
    (funcall split-function)
    (let ((target-window (next-window)))
      (set-window-buffer target-window (other-buffer))
      (unless arg
        (select-window target-window)))))

(defun split-window-vertically-with-other-buffer ()
  (interactive)
  "Split this window and switch to the new window unless ARG is provided."
  (split-window-func-with-other-buffer 'split-window-vertically))

(defun my-projectile-grep()
  "delete other windows and split right to grep"
  (interactive)
  (delete-other-windows)
  (projectile-grep)
  (next-multiframe-window)
  (compilation-next-error))

(provide 'leader-key-mode)
;;; leader-key-mode.el ends here
