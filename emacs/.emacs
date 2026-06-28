(unless (>= emacs-major-version 30)
  (error "Requires Emacs 30 or later"))

;; general ---------------------------------------------------------------------

;; fix weird behaviour with swedish keyboard layout and macos
(define-key key-translation-map (kbd "M-(") (kbd "{"))
(define-key key-translation-map (kbd "M-)") (kbd "}"))
(define-key key-translation-map (kbd "M-8") (kbd "["))
(define-key key-translation-map (kbd "M-9") (kbd "]"))

(setq-default inhibit-startup-message t
              make-backup-files nil
              auto-save-default nil
              indent-tabs-mode nil
              tab-width 4
              mouse-yank-at-point t
              apropos-do-all t
              load-prefer-newer t
              backup-by-copying t
              search-default-mode t
              frame-inhibit-implied-resize t
              read-file-name-completion-ignore-case t
              read-buffer-completion-ignore-case t
              completion-ignore-case t
              ido-mode 1
              electric-pair-mode 1
              compilation-scroll-output t
              visible-bell nil
              fill-column 80
              display-line-numbers-type 'relative
              uniquify-buffer-name-style 'forward
              ring-bell-function 'ignore
              )

(require 'uniquify)

(unless (or (fboundp 'helm-mode) (fboundp 'ivy-mode)
            (bound-and-true-p fido-vertical-mode)
            (bound-and-true-p vertico-mode))
  (ido-mode t)
  (setq ido-enable-flex-matching t))

(unless (memq window-system '(mac ns))
  (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))

(set-fringe-mode 0)
(show-paren-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(global-display-line-numbers-mode +1)
(global-display-fill-column-indicator-mode 1)

;; window navigation
(global-set-key (kbd "s-R") #'restart-emacs)
(global-set-key (kbd "s-N") #'windmove-left)
(global-set-key (kbd "s-I") #'windmove-right)
(global-set-key (kbd "s-O") #'windmove-up)
(global-set-key (kbd "s-E") #'windmove-down)
(global-set-key (kbd "s-w") #'delete-window)
(global-set-key (kbd "s-W") #'delete-other-windows)
(global-set-key (kbd "s-d") #'split-window-right)
(global-set-key (kbd "s-D") #'split-window-below)

;; files and directories -------------------------------------------------------

;; recent files
(recentf-mode 1)
(setq recentf-max-saved-items 100)
(run-at-time nil (* 5 60) #'recentf-save-list)
(global-set-key (kbd "C-c r") #'recentf-open-files)

(global-set-key (kbd "s-k") #'kill-current-buffer)

(global-set-key (kbd "C-x b") 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; dired
(setq dired-listing-switches "-alh --group-directories-first --no-group --time-style=+%Y-%m-%d"
      delete-by-moving-to-trash t
      dired-dwim-target t
      dired-kill-when-opening-new-dired-buffer t
      )

(add-hook 'dired-mode-hook #'dired-hide-details-mode) ;; toggle with '('
(with-eval-after-load 'dired
                      (define-key dired-mode-map (kbd "-") #'dired-up-directory)
                      (define-key dired-mode-map (kbd "^") nil))

;; plugins ---------------------------------------------------------------------

(require 'package)

(add-to-list
  'package-archives
  '("melpa" . "https://melpa.org/packages/")
  t)

(package-initialize)

(use-package nerd-icons
             :ensure t)

(use-package vterm
             :ensure t
             :bind
             (("s-t" . vterm)
              ))
(setq vterm-max-scrollback 5000)
(add-hook 'vterm-mode-hook
          (lambda ()
            (display-line-numbers-mode 0)
            (hl-line-mode 0)
            (visual-line-mode 0)
            (setq-local scroll-margin 0)
            (setq-local scroll-conservatively 101)))

(use-package smex
             :ensure t
             :init
             (smex-initialize)
             :bind
             (("M-x" . smex)
              ("M-X" . smex-major-mode-commands)))

(use-package magit
             :ensure t)

(use-package dashboard
             :ensure t
             :config
             (dashboard-setup-startup-hook)
             (setq dashboard-display-icons-p t)
             (setq dashboard-icon-type 'nerd-icons)
             (setq dashboard-set-heading-icons t)
             (setq dashboard-set-file-icons t)
             (setq dashboard-startup-banner 'logo-braille)
             (setq dashboard-items '((recents  . 5)
                                     ;; (projects . 5)
                                     (bookmarks . 5)
                                     ))
             (setq dashboard-center-content t)
             (setq dashboard-startupify-list '(dashboard-insert-banner
                                                dashboard-insert-newline
                                                dashboard-insert-navigator
                                                dashboard-insert-items
                                                )))

(use-package doom-modeline
             :ensure t
             :init (doom-modeline-mode 1)
             :custom ((doom-modeline-height 40)))

;; theme -----------------------------------------------------------------------

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(use-package autothemer
  :ensure t)
(use-package apropospriate-theme
  :ensure t
  :config 
  (load-theme 'apropospriate-dark t))


(load-theme 'dimma t)

;; fonts -----------------------------------------------------------------------

(add-to-list 'default-frame-alist
             '(font . "Maple Mono NF-16")
             )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:height 150 :weight normal :box nil))))
 '(mode-line-inactive ((t (:height 150 :weight normal :box nil)))))

;; cursor ----------------------------------------------------------------------

(use-package centered-cursor-mode
             :ensure t
             :hook (after-init . global-centered-cursor-mode))

(blink-cursor-mode t)
(global-hl-line-mode 1) ; cursor line

;; compile ---------------------------------------------------------------------

(require 'ansi-color)
(defun my-colorize-compilation-buffer ()
  (ansi-color-apply-on-region compilation-filter-start (point)))
(add-hook 'compilation-filter-hook #'my-colorize-compilation-buffer)

(require 'compile)
(require 'project)
(require 'cl-lib)

(defvar my-run-candidates
  '("build.sh" "dev" "run" "run.py" "cenv"))

(defun my-find-runner ()
  "Search upward for a build script."
  (let ((dir (file-name-directory (buffer-file-name)))
        found)
    (while (and dir (not found))
           (setq found
                 (cl-find-if
                   #'file-exists-p
                   (mapcar (lambda (f)
                             (expand-file-name f dir))
                           my-run-candidates)))
           (unless found
             (let ((parent (file-name-directory
                             (directory-file-name dir))))
               (setq dir (unless (equal parent dir) parent)))))
    found))

(defun my-fallback-command ()
  (let* ((file (buffer-file-name))
         (outfile (file-name-sans-extension file)))
    (pcase major-mode
           ('c-mode
            (format
              "gcc -std=gnu23 -Wall -Wextra -O2 %s -o %s && %s"
              (shell-quote-argument file)
              (shell-quote-argument outfile)
              (shell-quote-argument outfile)))

           ('python-mode
            (format "python3 %s"
                    (shell-quote-argument file)))

           ('go-mode
            "go run .")

           ('rust-mode
            "cargo run")

           ('haskell-mode
            (format
              "ghc %s && %s"
              (shell-quote-argument file)
              (shell-quote-argument outfile)))

           (_
             "echo 'no build.sh was found'"))))

(defun my-build-command ()
  (if-let ((runner (my-find-runner)))
          (if (string-match-p "\\.py\\'" runner)
            (format "python3 %s"
                    (shell-quote-argument runner))
            (format "bash %s"
                    (shell-quote-argument runner)))
          (my-fallback-command)))

(defun my-run ()
  (interactive)
  (save-buffer)
  (compile (my-build-command)))

(defun my-open-compilation ()
  (interactive)
  (if-let ((buf (get-buffer "*compilation*")))
          (pop-to-buffer buf)
          (message "No compilation buffer")))

(global-set-key (kbd "C-c c") #'my-run)
(global-set-key (kbd "C-c t") #'my-open-compilation)
(global-set-key (kbd "C-c s") 'shell-command)

;; editing ---------------------------------------------------------------------

(global-set-key (kbd "M-z") 'zap-up-to-char)

;; grep
(global-set-key (kbd "C-c g") #'grep-find)

;; delete binds
(define-prefix-command 'my-delete-map)
(global-set-key (kbd "C-c d") 'my-delete-map)

(defun my-delete-word ()
  "Delete word at point (like M-d but without killing previous)"
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'word)))
    (when bounds
      (delete-region (car bounds) (cdr bounds)))))

(defun my-delete-paragraph ()
  "Delete current paragraph"
  (interactive)
  (delete-region
    (save-excursion (backward-paragraph) (point))
    (save-excursion (forward-paragraph) (point))))

(defun my-delete-parens ()
  "Delete text inside nearest enclosing parentheses"
  (interactive)
  (let ((pos (point))
        start end)
    (save-excursion
      (condition-case nil
                      (progn
                        (up-list -1)
                        (forward-char 1)
                        (setq start (point))
                        (goto-char pos)
                        (up-list 1)
                        (backward-char 1)
                        (setq end (point))
                        (delete-region start end))
                      (error (message "No enclosing parentheses found"))))))

(defun my-delete-line ()
  "Delete entire current line."
  (interactive)
  (delete-region
    (line-beginning-position)
    (line-end-position)))

;; keybindings under C-c d
(define-key my-delete-map (kbd "w") #'my-delete-word)
(define-key my-delete-map (kbd "p") #'my-delete-paragraph)
(define-key my-delete-map (kbd "b") #'my-delete-parens)
(define-key my-delete-map (kbd "l") #'my-delete-line)

;; comment line
(global-set-key (kbd "C-'") #'comment-line)

;; set mark
(global-unset-key (kbd "C-SPC"))
(global-set-key (kbd "C-.") #'set-mark-command)
(global-set-key (kbd "C-,") #'set-mark-command)

(defun my/line-move (n)
  (interactive "p")
  (forward-line n))

(defun my/goto-line-relative (n)
  "Move N lines relative to current line."
  (interactive "nMove lines: ")
  (forward-line n))

(global-set-key (kbd "C-c C-g") 'my/goto-line-relative)

;; https://thanosapollo.org/posts/emacs-built-in-completions-video/
(setf completion-styles '(basic flex)
      completion-auto-select t ;; Show completion on first call
      completion-auto-help 'visible ;; Display *Completions* upon first request
      completions-format 'one-column ;; Use only one column
      completions-sort 'historical ;; Order based on minibuffer history
      completions-max-height 20 ;; Limit completions to 15 (completions start at line 5)
      completion-ignore-case t)

;; lsp & modes -----------------------------------------------------------------

(dolist (hook '(c-mode-hook c++-mode-hook))
  (add-hook hook #'eglot-ensure))

(add-hook 'rust-mode-hook #'eglot-ensure)

(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode))

(use-package org
  :ensure t
  :config
  (set-face-attribute 'variable-pitch nil
                      :font "Helvetica-16"
                      )
  )
(add-hook 'org-mode-hook #'variable-pitch-mode)
(with-eval-after-load 'org
  (set-face-attribute 'org-document-title nil :inherit 'variable-pitch)
    (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-level-1 nil :inherit 'variable-pitch)
  (set-face-attribute 'org-level-2 nil :inherit 'variable-pitch)
  (set-face-attribute 'org-level-3 nil :inherit 'variable-pitch))

  ;; Keep tables monospace



  ;; (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-code nil :inherit 'fixed-pitch))
