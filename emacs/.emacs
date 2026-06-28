(unless (>= emacs-major-version 30)
  (error "Requires Emacs 30 or later"))

;; general ---------------------------------------------------------------------

;; fix weird behaviour with swedish keyboard layout and macos
(define-key key-translation-map (kbd "M-(") (kbd "{"))
(define-key key-translation-map (kbd "M-)") (kbd "}"))
(define-key key-translation-map (kbd "M-8") (kbd "["))
(define-key key-translation-map (kbd "M-9") (kbd "]"))

(global-set-key (kbd "s-R") #'restart-emacs)
(setq ring-bell-function 'ignore)
(setq visible-bell nil)
(setq inhibit-startup-message t)
(pixel-scroll-precision-mode -1)
(ido-mode 1)
(electric-pair-mode 1)

;; line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode +1)

;; 80 col indicator
(setq-default fill-column 80)
(global-display-fill-column-indicator-mode 1)

;; window navigation
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

;; backups and saves
(setq auto-save-default nil)
(setq backup-by-copying t)
(setq backup-directory-alist '(("." . "~/.emacs_saves")))

;; dired
(setq dired-listing-switches "-alh --group-directories-first --no-group --time-style=+%Y-%m-%d")
(setq delete-by-moving-to-trash t)
(setq dired-dwim-target t)
(setq dired-kill-when-opening-new-dired-buffer t)
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
             (setq dashboard-footer-messages '(""))
             (setq dashboard-banner-logo-title "")
             (setq dashboard-startup-banner 'logo)
             (setq dashboard-items '((recents  . 10)
                                     ;(projects . 5)
                                     (bookmarks . 5)
                                     ))
             (setq dashboard-center-content t))

(use-package projectile
             :diminish projectile-mode
             :config (projectile-mode)
             :custom ((projectile-completion-system 'ivy))
             :bind-keymap
             ("C-c p" . projectile-command-map)
             :init
             (when (file-directory-p "~/dev")
               (setq projectile-project-search-path '("~/dev")))
             (setq projectile-switch-project-action #'projectile-dired))

(add-to-list 'load-path "~/.emacs.d/custom/better-defaults")
(require 'better-defaults)

;; theme -----------------------------------------------------------------------

(use-package doom-modeline
             :ensure t
             :init (doom-modeline-mode 1)
             :custom ((doom-modeline-height 40)))

(set-fringe-mode 0)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(use-package autothemer
             :ensure t)
(load-theme 'modus-vivendi-tinted t)
(load-theme 'dimma t)

;; fonts -----------------------------------------------------------------------

(add-to-list 'default-frame-alist
             '(font . "Maple Mono NF-18")
             )

(custom-set-faces
  '(mode-line
     ((t (:height 150 :weight normal :box nil))))

  '(mode-line-inactive
     ((t (:height 150 :weight normal :box nil))))
  )

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

;; grep
(global-set-key (kbd "C-c g") #'grep-find)

;; delete binds
(define-prefix-command 'my-delete-map)
(global-set-key (kbd "C-c d") 'my-delete-map)

;; 1. delete word at point
(defun my-delete-word ()
  "Delete word at point (like M-d but without killing previous)."
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'word)))
    (when bounds
      (delete-region (car bounds) (cdr bounds)))))

;; 2. delete paragraph
(defun my-delete-paragraph ()
  "Delete current paragraph."
  (interactive)
  (delete-region
    (save-excursion (backward-paragraph) (point))
    (save-excursion (forward-paragraph) (point))))

;; 3. delete inside parentheses (sexp contents)

(defun my-delete-parens ()
  "Delete text inside nearest enclosing parentheses."
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

;; 4. delete whole line
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


