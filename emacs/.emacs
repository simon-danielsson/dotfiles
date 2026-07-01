(unless (>= emacs-major-version 30)
  (error "Requires Emacs 30 or later"))

;; general ---------------------------------------------------------------------

;; fix weird behaviour with swedish keyboard layout and macos
(define-key key-translation-map (kbd "M-(") (kbd "{"))
(define-key key-translation-map (kbd "M-)") (kbd "}"))
(define-key key-translation-map (kbd "M-8") (kbd "["))
(define-key key-translation-map (kbd "M-9") (kbd "]"))

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

(setq-default inhibit-startup-message t
	      column-number-mode 1
              mouse-yank-at-point t
              apropos-do-all t
              load-prefer-newer t
              search-default-mode t
              frame-inhibit-implied-resize t
              ido-mode 1
	      fill-column 80
              electric-pair-mode 1
              compilation-scroll-output t
              visible-bell nil
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
(set-fill-column 80)

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

;; buffer navigation

(global-tab-line-mode t)
(setq tab-line-new-button-show nil
      tab-line-close-button-show nil
      tab-line-separator " ")

(global-set-key (kbd "C-<tab>") 'tab-line-switch-to-next-tab)
(global-set-key (kbd "C-S-<tab>") 'tab-line-switch-to-prev-tab)

;; files and directories -------------------------------------------------------

(recentf-mode 1)

(setq recentf-max-saved-items 100
      make-backup-files nil
      backup-by-copying t
      auto-save-default nil
      )

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

(add-hook 'dired-mode-hook #'dired-hide-details-mode)
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

(use-package vterm
  :ensure t
  :bind
  (("s-t" . vterm)
   ))
(setq vterm-max-scrollback 1000)

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
  :init
  (setq dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-file-icons t
        dashboard-startup-banner 'logo-braille
        dashboard-center-content t
	dashboard-recentf-show-base 'truncate-middle
        dashboard-items-padding nil
        dashboard-items '((recents . 5)
                          (bookmarks . 10)
                          (agenda . 100)
                          )
        dashboard-startupify-list
        '(dashboard-insert-banner
          dashboard-insert-newline
          dashboard-insert-items))
  :config
  (dashboard-setup-startup-hook))

(use-package rainbow-mode
  :ensure t
  :hook (after-change-major-mode . rainbow-mode))

(use-package undo-fu-session
  :ensure t
  :init
  (undo-fu-session-global-mode))
(setq undo-fu-session-directory
      (expand-file-name "undo-fu-session" user-emacs-directory))

;; theme -----------------------------------------------------------------------

(load-theme 'wombat t)

(let ((fg  "#aab3c0")
      (fg2 "#6e6e87")
      (mg  "#40404f")
      (bg  "#2a2a33")
      (bg2 "#25252d")
      (acc "#6087AE"))
  (with-eval-after-load 'corfu
    (set-face-attribute 'corfu-default nil
			:background "#2a2a33"
			:foreground "#6e6e87")

    (set-face-attribute 'corfu-current nil
			:background "#40404f"
			:foreground "#6087ae"
			:weight 'bold)

    (set-face-attribute 'corfu-border nil
			:background nil))

  (set-face-attribute 'default nil
                      :foreground fg
                      :background bg2)

  (set-face-attribute 'cursor nil
                      :background fg)

  (set-face-attribute 'region nil
                      :background mg)

  (set-face-attribute 'font-lock-comment-face nil
                      :foreground fg2
                      :slant 'italic)
  (set-face-attribute 'tab-line nil ;; background behind tabs
		      :background bg2
		      :underline mg
		      :foreground nil :distant-foreground nil
		      :height 1.0 :box nil)

  (set-face-attribute 'tab-line-tab nil ;; active tab in another window
		      :inherit 'tab-line
		      :foreground fg :background nil :box nil)
  (set-face-attribute 'tab-line-tab-current nil ;; active tab in current window
		      :background bg2 :foreground fg :box nil)
  (set-face-attribute 'tab-line-tab-inactive nil ;; inactive tab
		      :background bg2 :foreground fg2 :box nil)
  (set-face-attribute 'tab-line-highlight nil ;; mouseover
		      :background acc :foreground 'unspecified)

  (set-face-attribute 'font-lock-doc-face nil
                      :foreground fg2
                      :slant 'italic)

  (set-face-attribute 'mode-line nil
                      :foreground fg
                      :background bg)

  (set-face-attribute 'line-number nil
                      :foreground mg
                      :background bg2)

  (set-face-attribute 'line-number-current-line nil
                      :foreground fg
                      :background bg)

  (set-face-attribute 'fill-column-indicator nil
                      :foreground bg
                      :background bg)

  (with-eval-after-load 'hl-line
    (set-face-attribute 'hl-line nil
			:inherit nil
			:underline nil
                        :background "#2a2a33"))

  (set-face-attribute 'mode-line nil
                      :height 150
                      :box (list :line-width 12 :color bg))

  (set-face-attribute 'mode-line-inactive nil
		      :foreground mg
		      :background bg
		      :box (list :line-width 12 :color bg)

		      )
  )

;; fonts -----------------------------------------------------------------------

(add-to-list 'default-frame-alist
	     '(font . "Maple Mono NF-16")
	     )

(custom-set-faces
 '(tab-line ((t (:height 100 :weight normal :box ))))

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

;; grep
(global-set-key (kbd "C-c g") #'grep-find)

;; delete binds
(define-prefix-command 'my-delete-map)
(global-set-key (kbd "C-c d") 'my-delete-map)

(defun my-delete-word ()
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'word)))
    (when bounds
      (delete-region (car bounds) (cdr bounds)))))

(defun my-delete-paragraph ()
  (interactive)
  (delete-region
   (save-excursion (backward-paragraph) (point))
   (save-excursion (forward-paragraph) (point))))

(defun my-delete-parens ()
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
  (interactive)
  (delete-region
   (line-beginning-position)
   (line-beginning-position 2)))

;; keybindings under C-c d
(define-key my-delete-map (kbd "w") #'my-delete-word)
(define-key my-delete-map (kbd "p") #'my-delete-paragraph)
(define-key my-delete-map (kbd "b") #'my-delete-parens)
(define-key my-delete-map (kbd "l") #'my-delete-line)
;; mark binds
(define-prefix-command 'my-mark-map)
(global-set-key (kbd "C-c m") 'my-mark-map)

(defun my-mark-word ()
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'word)))
    (when bounds
      (goto-char (car bounds))
      (push-mark (cdr bounds) nil t))))

(defun my-mark-paragraph ()
  (interactive)
  (let ((start (save-excursion (backward-paragraph) (point)))
	(end   (save-excursion (forward-paragraph) (point))))
    (goto-char start)
    (push-mark end nil t)))

(defun my-mark-parens ()
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
	    (setq end (point)))
	(error (user-error "No enclosing parentheses found"))))
    (goto-char start)
    (push-mark end nil t)))

(defun my-mark-line ()
  (interactive)
  (goto-char (line-beginning-position))
  (push-mark (line-beginning-position 2) nil t))

;; keybindings under C-c m
(define-key my-mark-map (kbd "w") #'my-mark-word)
(define-key my-mark-map (kbd "p") #'my-mark-paragraph)
(define-key my-mark-map (kbd "b") #'my-mark-parens)
(define-key my-mark-map (kbd "l") #'my-mark-line)

;; comment line
(global-set-key (kbd "C-'") #'comment-line)

;; set mark
(global-unset-key (kbd "C-SPC"))
(global-set-key (kbd "C-.") #'set-mark-command)
(global-set-key (kbd "C-,") #'set-mark-command)

(defun move-region (start end n)
  "Move the active region N lines."
  (let ((text (delete-and-extract-region start end)))
    (forward-line n)
    (let ((new-start (point)))
      (insert text)
      (set-mark new-start)
      (goto-char (+ new-start (length text)))
      (activate-mark)
      (setq deactivate-mark nil))))

(defun move-region-up ()
  (interactive)
  (when (use-region-p)
    (move-region (region-beginning) (region-end) -1)))

(defun move-region-down ()
  (interactive)
  (when (use-region-p)
    (move-region (region-beginning) (region-end) 1)))

(defun my-less ()
  (interactive)
  (if (use-region-p)
      (move-region-up)
    (self-insert-command 1)))

(defun my-greater ()
  (interactive)
  (if (use-region-p)
      (move-region-down)
    (self-insert-command 1)))

(keymap-global-set "<" #'my-less)
(keymap-global-set ">" #'my-greater)

;; lsp, modes & completion -----------------------------------------------------

;; https://thanosapollo.org/posts/emacs-built-in-completions-video/
(setf completion-styles '(basic flex)
      completion-auto-select t ;; Show completion on first call
      completion-auto-help 'visible ;; Display *Completions* upon first request
      completions-format 'one-column ;; Use only one column
      completions-sort 'historical ;; Order based on minibuffer history
      completions-max-height 20 ;; Limit completions to 15 (completions start at line 5)
      completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      )

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)

  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.05)
  (corfu-auto-prefix 1)
  (corfu-cycle t))

(use-package lua-mode
  :ensure t
  :hook ('lua-mode-hook #'eglot-ensure)
  )

(use-package cc-mode
  :ensure nil
  :hook (c-mode . eglot-ensure)
  )

(add-hook 'rust-mode-hook #'eglot-ensure)

;; auto-formatting

(defun my/delete-extra-blank-lines ()
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\n\\{3,\\}" nil t)
      (replace-match "\n\n" nil nil))))

(defun my/eglot-format-on-save ()
  (add-hook 'before-save-hook #'eglot-format-buffer nil t)
  (add-hook 'before-save-hook #'my/delete-extra-blank-lines nil t))

(add-hook 'eglot-managed-mode-hook #'my/eglot-format-on-save)

(defun my/elisp-format-buffer ()
  (indent-region (point-min) (point-max))
  (delete-trailing-whitespace))

(defun my/elisp-format-on-save ()
  (add-hook 'before-save-hook #'my/elisp-format-buffer nil t)
  (add-hook 'before-save-hook #'my/delete-extra-blank-lines nil t))

(add-hook 'emacs-lisp-mode-hook #'my/elisp-format-on-save)

;; org -------------------------------------------------------------------------

(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode))
(with-eval-after-load 'org (global-org-modern-mode))

(use-package org
  :ensure t
  :config
  (setq org-agenda-files (directory-files-recursively "~/org/" "\\.org$")
	org-agenda-span 'month
	org-agenda-start-on-weekday 1
	org-agenda-show-all-dates t))

(use-package visual-fill-column
  :ensure t
  :hook (org-mode . visual-fill-column-mode)
  :init
  (setq visual-fill-column-center-text t
	visual-fill-column-width 80))
(add-hook 'org-mode-hook
	  (lambda ()
	    (setq-local truncate-lines nil)))
(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook (lambda () (auto-fill-mode -1)))
(setq org-auto-fill-function nil
      org-pretty-entities t
      org-agenda-start-with-log-mode t
      org-log-done 'time
      org-log-into-drawer t
      truncate-lines nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("52a99baa1ee94e34bbbfb4571224706bfb7dbdbc0494b421232d474c960b9d8e"
     "4fca7538be1f03e9fefa5b41a96d55b5b2145941f5e26239569dcb39733dcba5" default))
 '(package-selected-packages nil))
