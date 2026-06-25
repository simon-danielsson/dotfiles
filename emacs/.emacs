; general ---------------------------------------------------------------------

(setq inhibit-startup-message t)

; line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode +1)

; cursor line
(global-hl-line-mode 1)

; 80 col line
(setq-default fill-column 80)
(global-display-fill-column-indicator-mode 1)

; appearance ------------------------------------------------------------------

(load-theme 'nordless t)

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

; blink
(blink-cursor-mode t)

; plugins ---------------------------------------------------------------------

(require 'package)

(add-to-list
  'package-archives
  '("melpa" . "https://melpa.org/packages/")
  t)

(package-initialize)

(use-package vterm
             :ensure t)

(add-to-list 'load-path "~/.emacs.d/custom/better-defaults")
(require 'better-defaults)
