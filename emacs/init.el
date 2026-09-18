;;; init.el --- David's Emacs configuration -*- lexical-binding: t; -*-

;; ---------------------------------------------------------------------------
;; Startup
;; ---------------------------------------------------------------------------

(setq inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function #'ignore)

;; Keep Emacs customizations out of init.el.
(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))


;; ---------------------------------------------------------------------------
;; Interface
;; ---------------------------------------------------------------------------

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(line-number-mode 1)
(column-number-mode 1)

;; Line numbers only where they're useful.
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Highlight current line in programming modes.
(add-hook 'prog-mode-hook #'hl-line-mode)

(show-paren-mode 1)


;; ---------------------------------------------------------------------------
;; Theme
;; ---------------------------------------------------------------------------

(setq catppuccin-flavor 'mocha)
(load-theme 'catppuccin t)


;; ---------------------------------------------------------------------------
;; Smooth scrolling
;; ---------------------------------------------------------------------------

;; Smooth pixel scrolling, especially with the touchpad.
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(setq scroll-conservatively 101
      scroll-margin 3
      scroll-preserve-screen-position t
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(2 ((shift) . 1)))


;; ---------------------------------------------------------------------------
;; Editing
;; ---------------------------------------------------------------------------

(setq-default indent-tabs-mode nil
              tab-width 2)

(electric-pair-mode 1)
(delete-selection-mode 1)
(global-auto-revert-mode 1)

(setq require-final-newline t)

;; UTF-8 everywhere.
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)


;; ---------------------------------------------------------------------------
;; History
;; ---------------------------------------------------------------------------

(savehist-mode 1)
(save-place-mode 1)
(recentf-mode 1)

(setq history-length 1000
      recentf-max-saved-items 200)


;; ---------------------------------------------------------------------------
;; Backups / autosaves
;; ---------------------------------------------------------------------------

;; Don't scatter foo~ and #foo# throughout projects.

(let ((backup-dir
       (expand-file-name "backups/" user-emacs-directory))
      (autosave-dir
       (expand-file-name "auto-save/" user-emacs-directory)))

  (make-directory backup-dir t)
  (make-directory autosave-dir t)

  (setq backup-directory-alist
        `(("." . ,backup-dir))

        auto-save-file-name-transforms
        `((".*" ,autosave-dir t))))


;; ---------------------------------------------------------------------------
;; Completion
;; ---------------------------------------------------------------------------

(setq enable-recursive-minibuffers t
      completion-auto-help 'always
      completions-max-height 20
      completions-format 'one-column)

(setq completion-styles
      '(basic substring partial-completion flex))


;; ---------------------------------------------------------------------------
;; German ThinkPad-friendly navigation
;; ---------------------------------------------------------------------------

;; Keep the good native Emacs bindings:
;;
;; C-a       beginning of line
;; C-e       end of line
;; M-f       forward one word
;; M-b       backward one word
;;
;; Replace awkward M-< and M-> with mnemonic bindings.

(global-set-key (kbd "C-M-a") #'beginning-of-buffer)
(global-set-key (kbd "C-M-e") #'end-of-buffer)

;; Arrow-key word navigation also works.
(global-set-key (kbd "C-<left>")  #'backward-word)
(global-set-key (kbd "C-<right>") #'forward-word)


;; ---------------------------------------------------------------------------
;; Familiar editing
;; ---------------------------------------------------------------------------

;; Quickly kill the current buffer.
(global-set-key (kbd "C-x k") #'kill-current-buffer)

;; Reload current file from disk.
(global-set-key (kbd "<f5>") #'revert-buffer)

;; Short confirmations.
(fset 'yes-or-no-p 'y-or-n-p)


;; ---------------------------------------------------------------------------
;; Expand Region
;; ---------------------------------------------------------------------------

;; Repeated C-= expands the selected syntactic region.
;;
;; Example:
;;   x
;;   x + y
;;   (x + y)
;;   whole expression
;;   ...

(when (require 'expand-region nil t)
  (global-set-key (kbd "C-=") #'er/expand-region)
  (global-set-key (kbd "C--") #'er/contract-region))


;; ---------------------------------------------------------------------------
;; Multiple Cursors
;; ---------------------------------------------------------------------------

(when (require 'multiple-cursors nil t)

  ;; Add a cursor to the next/previous occurrence of the selection.
  ;;
  ;; C-c n = next
  ;; C-c p = previous
  ;; C-c a = all occurrences

  (global-set-key
   (kbd "C-c n")
   #'mc/mark-next-like-this)

  (global-set-key
   (kbd "C-c p")
   #'mc/mark-previous-like-this)

  (global-set-key
   (kbd "C-c a")
   #'mc/mark-all-like-this)

  ;; Add cursors vertically.
  ;;
  ;; C-c <down>
  ;; C-c <up>

  (global-set-key
   (kbd "C-c <down>")
   #'mc/mark-next-lines)

  (global-set-key
   (kbd "C-c <up>")
   #'mc/mark-previous-lines))




;; ---------------------------------------------------------------------------
;; Backups / autosaves
;; ---------------------------------------------------------------------------

;; Keep all Emacs-generated recovery files out of project directories.

(let ((backup-dir
       (expand-file-name "backups/" user-emacs-directory))
      (autosave-dir
       (expand-file-name "auto-save/" user-emacs-directory)))

  (make-directory backup-dir t)
  (make-directory autosave-dir t)

  ;; foo~ backup files
  (setq backup-directory-alist
        `(("." . ,backup-dir)))

  ;; #foo# auto-save files
  (setq auto-save-file-name-transforms
        `((".*" ,autosave-dir t)))

  ;; Auto-save metadata / session files
  (setq auto-save-list-file-prefix
        (expand-file-name ".saves-" autosave-dir)))

;; Don't create .#foo lockfiles either.
(setq create-lockfiles nil)

;; Load direnv environments buffer-locally.
(when (require 'envrc nil t)
  (envrc-global-mode 1))

;; ---------------------------------------------------------------------------
;; Lean 4
;; ---------------------------------------------------------------------------

;; LSP
(setq lsp-enable-snippet nil)


;; Completion
(setq company-minimum-prefix-length 1
      company-idle-delay 0.2)

(add-hook 'prog-mode-hook #'company-mode)

;; Lean
(when (require 'lean4-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.lean\\'" . lean4-mode)))

;; ---------------------------------------------------------------------------
;; End
;; ---------------------------------------------------------------------------

;;; init.el ends here
