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
;; lean4-mode already auto-starts the server: lean4-settings.el defines
;; `lean4-mode-hook' as (list #'lsp). The problem is where that server runs.
;;
;; lsp-mode launches it in the *buffer's* directory (its
;; `lsp-use-workspace-root-for-server-default-directory' defaults to nil), and
;; `lake' looks for lakefile.toml only in its own cwd -- it does not search
;; upward. So opening a file in a subdirectory, e.g. learn/Learn/Tactics.lean,
;; makes `lake serve' miss the lakefile and fall back to plain `lean --server'
;; with no LEAN_PATH: the server looks alive but resolves no imports and the
;; infoview stays empty. Pinning cwd to the workspace root fixes it.
(when (require 'lean4-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.lean\\'" . lean4-mode))
  (add-hook 'lean4-mode-hook
            (lambda ()
              (setq-local lsp-use-workspace-root-for-server-default-directory t))))

;; ---------------------------------------------------------------------------
;; C / C++
;; ---------------------------------------------------------------------------

;; The toolchain (g++/clang, clangd, cmake) is NOT installed globally; it
;; comes from each project's flake. envrc-global-mode above puts that
;; devShell's PATH into the buffer's environment, and lsp-deferred waits
;; until the buffer is actually displayed, so clangd is picked up from the
;; project rather than from the system.

;; Prefer the tree-sitter majors. The grammars are installed via Nix
;; (emacs-grammars in home.nix), so no M-x treesit-install-... needed.
(dolist (remap '((c-mode         . c-ts-mode)
                 (c++-mode       . c++-ts-mode)
                 (c-or-c++-mode  . c-or-c++-ts-mode)
                 (cmake-mode     . cmake-ts-mode)))
  (add-to-list 'major-mode-remap-alist remap))

;; Treat headers as C++ unless they're obviously C.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-or-c++-ts-mode))
(add-to-list 'auto-mode-alist
             '("\\.\\(cc\\|cpp\\|cxx\\|hh\\|hpp\\|hxx\\|ipp\\|tpp\\|inl\\)\\'"
               . c++-ts-mode))

;; Indentation: 2 spaces, K&R braces.
(setq c-ts-mode-indent-offset 2
      c-ts-mode-indent-style 'k&r)


;; --- LSP (clangd) ----------------------------------------------------------

(setq lsp-clients-clangd-args
      '("--background-index"
        "--clang-tidy"
        "--completion-style=detailed"
        "--header-insertion=never"
        "--pch-storage=memory"
        "-j=4"))

(setq lsp-idle-delay 0.3
      lsp-enable-on-type-formatting nil
      lsp-headerline-breadcrumb-enable nil
      lsp-signature-auto-activate '(:on-trigger-char :after-completion))

(add-hook 'c-ts-mode-hook   #'lsp-deferred)
(add-hook 'c++-ts-mode-hook #'lsp-deferred)
(add-hook 'cmake-ts-mode-hook #'lsp-deferred)   ; cmake-language-server

;; C-c l is the LSP prefix: C-c l g g = find definition, C-c l r r = rename,
;; C-c l a a = code actions, C-c l h h = describe thing at point.
(with-eval-after-load 'lsp-mode
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

;; Richer UI on top of lsp-mode: sideline diagnostics, peek, doc popup.
(when (require 'lsp-ui nil t)
  (setq lsp-ui-doc-enable nil              ; use C-c l h h / M-x lsp-ui-doc-glance
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-diagnostic-max-lines 3
        lsp-ui-peek-always-show t)
  (add-hook 'lsp-mode-hook #'lsp-ui-mode)
  (with-eval-after-load 'lsp-ui
    (define-key lsp-ui-mode-map (kbd "M-.") #'lsp-ui-peek-find-definitions)
    (define-key lsp-ui-mode-map (kbd "M-?") #'lsp-ui-peek-find-references)))

;; Diagnostics via flycheck (lsp-mode picks it up automatically when present).
(when (require 'flycheck nil t)
  (setq flycheck-indication-mode 'left-margin))


;; --- clang-format ----------------------------------------------------------

;; Formats according to the project's .clang-format file.
;;
;;   C-c f   reformat the whole buffer
(when (require 'clang-format nil t)
  (with-eval-after-load 'c-ts-mode
    (define-key c-ts-base-mode-map (kbd "C-c f")
                #'clang-format-buffer)))

;; Uncomment to format on every save instead:
;; (add-hook 'c++-ts-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook #'clang-format-buffer nil t)))


;; --- Building and debugging ------------------------------------------------

;; <f7> compile, <f8> re-run the last compile without being asked.
(global-set-key (kbd "<f7>") #'compile)
(global-set-key (kbd "<f8>") #'recompile)

(setq compilation-scroll-output 'first-error
      compilation-ask-about-save nil)

;; Colourise compiler output.
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

;; gdb: one window per purpose (locals, breakpoints, io, ...).
(setq gdb-many-windows t
      gdb-show-main t)


;; ---------------------------------------------------------------------------
;; End
;; ---------------------------------------------------------------------------

;;; init.el ends here
