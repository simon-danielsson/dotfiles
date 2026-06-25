; general ---------------------------------------------------------------------

(setq inhibit-startup-message t)
(ido-mode 1)

(setq backup-directory-alist '(("." . "~/.emacs_saves")))

(setq display-line-numbers-type 'relative) ; line numbers
(global-display-line-numbers-mode +1)

(global-hl-line-mode 1) ; cursor line

(setq-default fill-column 80) ; 80 col line
(global-display-fill-column-indicator-mode 1)

; theme -----------------------------------------------------------------------

(set-fringe-mode 0) ; no fringes

(load-theme 'wombat t)

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

(blink-cursor-mode t) ; blink

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
