(require 'autothemer)

(autothemer-deftheme
 dimma "Simon's nice and soothing colorscheme"

 ((((class color) (min-colors #xFFFFFF)))

  ;; palette
  (fg  "#aab3c0")
  (fg2 "#6e6e87")
  (mg  "#40404f")
  (bg  "#2a2a33")
  (bg2 "#25252d")
  (acc "#6087AE"))

 ;; faces
 ((default                   (:foreground fg :background bg2))
  (cursor                    (:background fg))
  (region                    (:background mg))
  (mode-line                 (:foreground fg :background bg))
 ;;(font-lock-keyword-face    (:foreground bg))
 ;;(font-lock-constant-face   (:foreground mg))
 ;;(font-lock-string-face     (:foreground fg))
 ;;(font-lock-builtin-face    (:foreground mg))

  (org-level-1               (:foreground acc))))

(provide-theme 'dimma)

