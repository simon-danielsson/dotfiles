(unless (>= emacs-major-version 30)
  (error "Requires Emacs 30 or later"))

; general ---------------------------------------------------------------------

(setq inhibit-startup-message t)
(ido-mode 1)

; recent files
(recentf-mode 1)
(setq recentf-max-saved-items 100)
(run-at-time nil (* 5 60) #'recentf-save-list)
(global-set-key (kbd "C-c C-r") #'recentf-open-files)

; backups and saves
(setq auto-save-default nil)
(setq backup-by-copying t)
(setq backup-directory-alist '(("." . "~/.emacs_saves")))

; line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode +1)

; 80 col indicator
(setq-default fill-column 80)
(global-display-fill-column-indicator-mode 1)

; theme -----------------------------------------------------------------------

(set-fringe-mode 0)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(use-package autothemer
             :ensure t)

(load-theme 'modus-vivendi-tinted t)

(load-theme 'dimma t)

; fonts -----------------------------------------------------------------------

(add-to-list 'default-frame-alist
             '(font . "Maple Mono NF-18")
             )
(custom-set-faces
  '(mode-line
     ((t (:height 150 :weight normal :box nil))))

  '(mode-line-inactive
     ((t (:height 130 :weight normal :box nil))))
  )

; cursor ----------------------------------------------------------------------

(blink-cursor-mode t)
(global-hl-line-mode 1) ; cursor line

; plugins ---------------------------------------------------------------------

(require 'package)

(add-to-list
  'package-archives
  '("melpa" . "https://melpa.org/packages/")
  t)

(package-initialize)

(use-package smex
             :ensure t
             :init
             (smex-initialize)
             :bind
             (("M-x" . smex)
              ("M-X" . smex-major-mode-commands)))

(add-to-list 'load-path "~/.emacs.d/custom/better-defaults")
(require 'better-defaults)

; compile ---------------------------------------------------------------------

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

; editing ---------------------------------------------------------------------

(defun kill-other-buffers ()
  "Kill all buffers except the current one."
  (interactive)
  (mapc #'kill-buffer
        (delq (current-buffer)
              (buffer-list))))
(global-set-key (kbd "C-c K") #'kill-other-buffers)

(global-set-key "\C-cd" 'kill-whole-line) ; Sets C-c d to M-x kill-whole-line

; https://thanosapollo.org/posts/emacs-built-in-completions-video/
(setf completion-styles '(basic flex)
      completion-auto-select t ;; Show completion on first call
      completion-auto-help 'visible ;; Display *Completions* upon first request
      completions-format 'one-column ;; Use only one column
      completions-sort 'historical ;; Order based on minibuffer history
      completions-max-height 20 ;; Limit completions to 15 (completions start at line 5)
      completion-ignore-case t)

; lsp -------------------------------------------------------------------------

(dolist (hook '(c-mode-hook c++-mode-hook))
  (add-hook hook #'eglot-ensure))

(add-hook 'rust-mode-hook #'eglot-ensure)
